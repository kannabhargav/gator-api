//https://www.youtube.com/watch?v=or1_A4sJ-oY
const router = require('express').Router();

import {SQLRepository} from './Lib/sqlRepository';
import {GitRepository} from './Lib/gitRepository';
let sqlRepositoy = new SQLRepository(null);
let gitRepository = new GitRepository();
const jwt = require('jsonwebtoken');
const verifyOptions =  {
  algorithm:  ["RS256"]
 };

 function checkToken (req:any, res: any)  {
  try {
    const token = req.headers['authorization'];
    const result = jwt.verify ( token, 'JWTSuperSecret', verifyOptions);
    } catch (ex) {
      // var callbackURL = 'http://localhost:8080/login' ;
      // res.redirct (callbackURL);
      return false ;
    }
 }

router.get('/TopDevForLastXDays', (req: any, res: any) => {
  if (!checkToken(req, res)) {
      return '{result: "Auth Failed"}';
  }

  if (!req.query.day) {
    req.query.day = '1';
  }

  sqlRepositoy.TopDevForLastXDays(req.query.tenant, req.query.day).then(result => {
    return res.json(result.recordset);
  });
});
/*

PullRequestCountForLastXDays
returns 
[
    [
        {
            "Action": "closed",
            "ctr": 27
        },
        {
            "Action": "opened",
            "ctr": 34
        }
    ]
]

*/
router.get('/PullRequestCountForLastXDays', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }

  if (!req.query.day) {
    req.query.day = '1';
  }
  sqlRepositoy.PullRequestCountForLastXDays(req.query.tenant, req.query.day).then(result => {
    return res.json(result.recordsets);
  });
});

router.get('/PullRequestForLastXDays', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }

  if (!req.query.day) {
    req.query.day = '1';
  }
  sqlRepositoy.PullRequestForLastXDays(req.query.tenant, req.query.day).then(result => {
    return res.json(result.recordset);
  });
});

router.get('/GetTopRespositories4XDays', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  if (!req.query.day) {
    req.query.day = '1';
  }
  sqlRepositoy.GetTopRespositories4XDays(req.query.tenant, req.query.day).then(result => {
    return res.json(result.recordset);
  });
});

router.get('/PullRequest4Dev', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  if (!req.query.day) {
    req.query.day = '1';
  }

  sqlRepositoy.PullRequest4Dev(req.query.tenant, req.query.day, req.query.login, req.query.action, req.query.pageSize).then(result => {
    return res.json(result.recordset);
  });
});

//    /GetOrg?tenantId='rsarosh@hotmail.com'&bustTheCache=false&getFromGit = true
router.get('/GetOrg', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  gitRepository.GetOrg(req.query.tenantId, req.query.bustTheCache, req.query.getFromGit).then(result => {
    return res.json(result.recordset);
  });
});

//    /GetOrg?tenantId='rsarosh@hotmail.com'&Org='LabShare'&bustTheCache=false&getFromGit = true
router.get('/GetRepos', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  gitRepository.GetRepos(req.query.tenantId, req.query.org, req.query.bustTheCache, req.query.getFromGit).then(result => {
    return res.json(result.recordset);
  });
});

//  /SetRepoCollection?tenantId=rsarosh@hotmail.com&org=Labshare&repoCollectionName=Collection1&repos=Repo1,Repo2,Repo3
router.get('/SetRepoCollection', (req: any, res: any) => {
  sqlRepositoy.SetRepoCollection(req.query.tenantId, req.query.org, req.query.repoCollectionName, req.query.repos).then(result => {
    return res.json(result.recordset);
  });
});


router.get('/GetAllRepoCollection4TenantOrg', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  sqlRepositoy.GetAllRepoCollection4TenantOrg(req.query.tenantId, req.query.org,  req.query.bustTheCache).then(result => {
    return res.json(result.recordset);
  });
});

//collectionName
router.get('/GetRepoCollectionByName', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  sqlRepositoy.GetAllRepoCollection4TenantOrg(req.query.collectionName,  req.query.bustTheCache).then(result => {
    return res.json(result.recordset);
  });
});

router.get('/SetupWebHook', (req: any, res: any) => {
  if (!checkToken(req, res)) {
    return '{result: "Auth Failed"}';
  }
  gitRepository.SetupWebHook(req.query.tenantId, req.query.org,).then(result => {
    return res.json(result);
  });
});

module.exports = router;
