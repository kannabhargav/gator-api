import * as _ from 'lodash';
import {isNullOrUndefined} from 'util';
const NodeCache = require('node-cache');
import {SQLRepository} from './sqlRepository';
// const req = require('request');
const request = require('request-promise');

class GitRepository {
  httpOptions: any;
  url: string;
  sqlRepository: SQLRepository;

  constructor() {
    this.sqlRepository = new SQLRepository(null);
  }

  //https://developer.github.com/v3/repos/hooks/
  async GetHookStatus(tenantId: string, org: string) {
    const url = 'https://api.github.com/orgs/' + org + '/hooks';
    const reqHeader = await this.makeGitRequest(tenantId, 'GET', url, 'GET');
    return new Promise((resolve, reject) => {
      request(reqHeader, (error: any, response: any, body: any) => {
        if (!error && response.statusCode === 200) {
          let a = JSON.parse(body);
          if (a[0].config.url) {
            resolve(true);
          } else {
            reject(false);
          }
        } else {
          reject(false);
        }
      });
    });
  }

  //Gets the PR for a Organization and a repo

  async FillPullRequest(tenantId: string, org: string, repo: string, bustTheCache: Boolean = false, getFromGit: Boolean = false, endCursor: string = '') {
    let cacheKey = 'FillPullRequest' + tenantId + org + repo;
    if (endCursor.length > 0) {
      //No need to be bothered by caching etc

      if (bustTheCache) {
        this.sqlRepository.myCache.del(cacheKey);
      }

      if (!getFromGit) {
        //Get from local store
        let result = this.sqlRepository.myCache.get(cacheKey);
        if (result) {
          return result;
        }
        //Get from sql
        result = await this.sqlRepository.GetPR4Repo(org, repo);
        if (result.recordset[0]) {
          this.sqlRepository.myCache.set(cacheKey, result.recordset);
          return result.recordset[0];
        }
      }
    }
    //Lets go to git
    let graphQL =
      `{\"query\":\"{viewer  {  name          organization(login: \\"` +
      org +
      `\\") {     name        repository(name: \\"` +
      repo +
      `\\") { name            pullRequests(last: 10) {  nodes { id  url  state  title   permalink   createdAt  body  repository { name } author                                                                                                                                                                                { login  avatarUrl url                                           }            }          }        }      }    }  }\",\"variables\":{}}`;

    try {
      request(
        await this.makeGitRequest(tenantId, graphQL),

        async (error: any, response: any, body: any) => {
          if (response.statusCode === 200) {
            await this.sqlRepository.SavePR4Repo(org, repo, body);
          } else {
            console.log('FillPullRequest: ' + body);
          }
        },
      );
      //git call has put the PR in SQL, now lets get it from (cache).
      return await this.sqlRepository.GetPR4Repo(org, repo);
    } catch (ex) {
      console.log(ex);
    }
  }

  async GetRepos(tenantId: string, org: string, bustTheCache: Boolean = false, getFromGit: Boolean = false, endCursor: string = '') {
    let cacheKey = 'GetRepos' + tenantId + org;
    if (endCursor.length > 0) {
      //No need to be bothered by caching etc

      if (bustTheCache) {
        this.sqlRepository.myCache.del(cacheKey);
      }

      if (!getFromGit) {
        //Get from local store
        let result = this.sqlRepository.myCache.get(cacheKey);
        if (result) {
          return result;
        }
        result = await this.sqlRepository.GetRepo(tenantId, org);
        if (result.recordset[0]) {
          this.sqlRepository.myCache.set(cacheKey, result.recordset);
          return result.recordset[0];
        }
      }
    }
    //Lets go to git
    let graphQL = `{\"query\":\"query {  organization(login: ` + org + `) { repositories(first: 50 , after: \\"` + endCursor + `\\") {      nodes {id  name  isDisabled isArchived description homepageUrl createdAt } pageInfo { endCursor hasNextPage  } }  }}\",\"variables\":{}}`;

    try {
      request(
        await this.makeGitRequest(tenantId, graphQL),

        async (error: any, response: any, body: any) => {
          if (response.statusCode === 200) {
            await this.sqlRepository.SaveRepo(tenantId, org, JSON.parse(body).data.organization.repositories.nodes);
            let pageInfo = JSON.parse(body).data.organization.repositories.pageInfo;
            if (pageInfo.hasNextPage) {
              this.GetRepos(tenantId, org, bustTheCache, getFromGit, pageInfo.endCursor); //ooph! Recursive call
            }
          } else {
            console.log('GetRpo: ' + body);
          }
        },
      );
      //git call has put the org in SQL, now lets get it from (cache).
      return await this.sqlRepository.GetRepo(tenantId, org, false);
    } catch (ex) {
      console.log(ex);
    }
  }

  async makeGitRequest(tenantId: string, graphQL: string, gUri: string = 'https://api.github.com/graphql', method: string = 'POST') {
    const token = 'Bearer ' + (await this.sqlRepository.GetToken(Number(tenantId)));
    let header = {
      method: method,
      uri: gUri,
      headers: {
        'Content-Type': 'application/json',
        Authorization: token,
        Accept: 'application/vnd.github.machine-man-preview+json',
        'cache-control': 'no-cache',
        'user-agent': 'Gator',
      },
      body: graphQL,
    };

    return header;
  }

  async SetupWebHook(tenantId: string, org: string) {
    //Lets go to git
    const graphQL = `{
      "name": "web",
      "active": true,
      "events": [
        "push",
        "pull_request"
      ],
      "config": {
        "url": "https://gatorgithook.azurewebsites.net/api/httptrigger",
        "content_type": "application/json",
        "secret": "Secret"
      }
    }`;
    try {
      await request(await this.makeGitRequest(tenantId, graphQL, 'https://api.github.com/orgs/' + org + '/hooks'), (error: any, response: any, body: any) => {
        if (response.statusCode === 201) {
          console.log('Successfully hook is setup');
          console.log(body);
          return 1;
        } else {
          if (response.statusCode === 422) {
            console.log('error: ' + response.statusCode);
            console.log(body);
            return 1;
          }
          return 0;
        }
      });
    } catch (ex) {
      console.log(ex);
    }
  }

  async GetOrg(tenantId: string, bustTheCache: Boolean = false, getFromGit: Boolean = false) {
    //Lets check in our local sql tables first
    let cacheKey = 'GetOrg' + tenantId;

    if (bustTheCache) {
      this.sqlRepository.myCache.del(cacheKey);
    }

    if (!getFromGit) {
      //Get from local store
      const result = await this.sqlRepository.GetOrg(tenantId);
      return result;
    }
    //Lets go to git
    const graphQL = `{\"query\": \"query { viewer {name organizations(last: 100) { nodes { name }} }}\",\"variables\":{}}`;
    try {
      request(await this.makeGitRequest(tenantId, graphQL), async (error: any, response: any, body: any) => {
        if (response.statusCode === 200) {
          await this.sqlRepository.SaveOrg(tenantId, JSON.parse(response.body).data.viewer.organizations.nodes);
        } else {
          console.log('error: ' + response.statusCode);
          console.log(body);
        }
      });
      //git call has put the org in SQL, now lets get it from (cache).
      return await this.sqlRepository.GetOrg(tenantId, false);
    } catch (ex) {
      console.log(ex);
    }
  }
}

export {GitRepository};
