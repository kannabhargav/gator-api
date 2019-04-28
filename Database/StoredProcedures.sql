/****** Object:  Database [Git]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE DATABASE [Git]  (EDITION = 'Standard', SERVICE_OBJECTIVE = 'S0', MAXSIZE = 250 GB) WITH CATALOG_COLLATION = SQL_Latin1_General_CP1_CI_AS;
GO
ALTER DATABASE [Git] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Git] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Git] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Git] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Git] SET ARITHABORT OFF 
GO
ALTER DATABASE [Git] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Git] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Git] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Git] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Git] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Git] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Git] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Git] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Git] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [Git] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Git] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [Git] SET  MULTI_USER 
GO
ALTER DATABASE [Git] SET QUERY_STORE = ON
GO
ALTER DATABASE [Git] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
/****** Object:  User [gitadmin]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE USER [gitadmin] FOR LOGIN [gitadmin] WITH DEFAULT_SCHEMA=[dbo]
GO
sys.sp_addrolemember @rolename = N'db_owner', @membername = N'gitadmin'
GO
/****** Object:  Table [dbo].[PullRequestDetails]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PullRequestDetails](
	[Org] [nchar](100) NOT NULL,
	[Login] [varchar](100) NOT NULL,
	[Action] [varchar](50) NOT NULL,
	[PullRequestId] [int] NOT NULL,
	[PullRequestUrl] [varchar](2000) NOT NULL,
	[State] [varchar](50) NOT NULL,
	[Avatar_Url] [varchar](2000) NOT NULL,
	[User_Url] [varchar](2000) NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Body] [varchar](2000) NOT NULL,
	[Teams_Url] [varchar](2000) NOT NULL,
	[Repo_Name] [varchar](1000) NOT NULL,
	[Repo_FullName] [varchar](1000) NOT NULL,
	[Repo_Description] [varchar](1000) NOT NULL,
	[links] [varchar](5000) NOT NULL,
	[PullId] [varchar](1000) NULL,
	[LastUpdated] [datetime] NULL,
	[Title] [varchar](5000) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vwOpenClosedPR]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwOpenClosedPR]
AS
SELECT DISTINCT Login, Action, State, Created_At, Repo_Name, Avatar_Url, CAST(CAST(LastUpdated AS varchar(12)) AS DATEtIME) AS LastUpdated, PullRequestUrl, Org
FROM     dbo.PullRequestDetails
WHERE  (Action IN ('closed', 'opened'))
GO
/****** Object:  Table [dbo].[GitLogIn]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GitLogIn](
	[Org] [nvarchar](100) NOT NULL,
	[Login] [varchar](200) NOT NULL,
	[FullName] [varchar](1000) NOT NULL,
	[Avatar_Url] [varchar](1000) NOT NULL,
	[LastUpdated] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RepoCollections]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RepoCollections](
	[TenantId] [varchar](200) NOT NULL,
	[Org] [varchar](200) NOT NULL,
	[Repo] [varchar](200) NOT NULL,
	[LastUpdated] [datetime] NULL,
	[CollectionName] [varchar](200) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tenant]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tenant](
	[Id] [varchar](200) NOT NULL,
	[UserName] [varchar](200) NULL,
	[DisplayName] [varchar](200) NULL,
	[ProfileUrl] [varchar](1000) NULL,
	[LastUpdated] [datetime] NOT NULL,
	[Auth_Token] [varchar](4000) NULL,
	[Refresh_Token] [varchar](4000) NULL,
	[Photo] [varchar](1000) NULL,
 CONSTRAINT [PK_Tenant] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantOrg]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantOrg](
	[TenantId] [varchar](200) NOT NULL,
	[Org] [varchar](600) NOT NULL,
	[LastUpdated] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TenantRepos]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantRepos](
	[TenantId] [varchar](200) NOT NULL,
	[RepoName] [varchar](200) NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
	[LastRefereshed] [datetime] NOT NULL,
	[Organization] [varchar](200) NOT NULL,
	[ID] [varchar](100) NOT NULL,
	[Desc] [varchar](200) NULL,
	[HomePage] [varchar](1000) NULL,
	[Created_At] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [TenantId_Login]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [TenantId_Login] ON [dbo].[GitLogIn]
(
	[Org] ASC,
	[Login] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TenantId]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [IX_TenantId] ON [dbo].[PullRequestDetails]
(
	[Org] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PR_Login]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [PR_Login] ON [dbo].[PullRequestDetails]
(
	[Org] ASC,
	[Login] ASC,
	[Created_At] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [PR_repo]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [PR_repo] ON [dbo].[PullRequestDetails]
(
	[Org] ASC,
	[Repo_Name] ASC,
	[Created_At] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [TenantId_PullId_Action]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [TenantId_PullId_Action] ON [dbo].[PullRequestDetails]
(
	[Org] ASC,
	[Login] ASC,
	[Action] ASC,
	[PullRequestId] ASC,
	[State] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_RepoCollections]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [IX_RepoCollections] ON [dbo].[RepoCollections]
(
	[TenantId] ASC,
	[Org] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_RepoCollections_1]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [IX_RepoCollections_1] ON [dbo].[RepoCollections]
(
	[CollectionName] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_TenantOrg]    Script Date: 4/27/2019 7:40:10 PM ******/
CREATE NONCLUSTERED INDEX [IX_TenantOrg] ON [dbo].[TenantOrg]
(
	[TenantId] ASC,
	[Org] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GitLogIn] ADD  CONSTRAINT [DF_GitLogIn_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[PullRequestDetails] ADD  CONSTRAINT [DF_PullRequestDetails_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[RepoCollections] ADD  CONSTRAINT [DF_RepoCollections_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[Tenant] ADD  CONSTRAINT [DF_Tenant_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[TenantOrg] ADD  CONSTRAINT [DF_TenantOrg_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[TenantRepos] ADD  CONSTRAINT [DF_TenantRepositories_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
ALTER TABLE [dbo].[TenantRepos] ADD  CONSTRAINT [DF_TenantRepositories_LastRefereshed]  DEFAULT (getdate()) FOR [LastRefereshed]
GO
/****** Object:  StoredProcedure [dbo].[GetAllRepoCollection4TenantOrg]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[GetAllRepoCollection4TenantOrg]
(
   @TenantId VARCHAR (200),
   @Org VARCHAR (200)
)
AS
	BEGIN

	    SELECT * FROM RepoCollections WHERE TenantId = @TenantId AND ORG = @Org  
		
	END
GO
/****** Object:  StoredProcedure [dbo].[GetOrg]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[GetOrg]
(
    -- Add the parameters for the stored procedure here
   @TenantId varchar(200) 
)
AS
BEGIN

      Select * from [dbo].[TenantOrg]  where TenantId = @TenantId   
	 

END
GO
/****** Object:  StoredProcedure [dbo].[GetPullRequestforId]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[GetPullRequestforId]
(
    -- Add the parameters for the stored procedure here
    @Id int, 
	@Org varchar(100)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	select * from [dbo].[PullRequestDetails] 
			where [PullRequestId] = @Id  and Org = @Org  
			 
				
	
  

END
GO
/****** Object:  StoredProcedure [dbo].[GetRepoCollectionByName]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[GetRepoCollectionByName]
(
   @CollectionName VARCHAR(200)
)
AS
	BEGIN

	    SELECT * FROM RepoCollections WHERE CollectionName = @CollectionName 
		
	END
GO
/****** Object:  StoredProcedure [dbo].[GetRepos]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[GetRepos]
(
    -- Add the parameters for the stored procedure here
    @TenantId varchar(200),
	@Organization varchar(200)
	
)
AS
BEGIN
	Select * from TenantRepositories  where TenantId = @TenantId and Organization = @Organization
			
END
GO
/****** Object:  StoredProcedure [dbo].[GetTenant]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[GetTenant]
(
    -- Add the parameters for the stored procedure here
    @Id varchar(200)
)
AS
BEGIN

    Select * from Tenant  where Id = @Id
		
END
GO
/****** Object:  StoredProcedure [dbo].[GetTopRespositories4XDays]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[GetTopRespositories4XDays]
(
    -- Add the parameters for the stored procedure here
    @Day int = 1,
	@Org varchar(200)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	
	select [Repo_Name], count(*) ctr   from [vwOpenClosedPR] where 
			LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
			and Org = @Org
			     group by [Repo_Name] order by ctr desc

	
END
GO
/****** Object:  StoredProcedure [dbo].[LongestPullRequest]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[LongestPullRequest]
(
    -- Add the parameters for the stored procedure here
    @Day int = 1, 
	@Org varchar(100)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	select [PullRequestId], DATEDIFF(day, [Created_At], [LastUpdated] ) duration from [dbo].[PullRequestDetails] 
			where state = 'closed'  and Org = @Org and LastUpdated between getdate() - @Day and getdate() 
				order by duration desc
				
	
  

END
GO
/****** Object:  StoredProcedure [dbo].[PullRequest4Devs]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
/* If state is null then get all the pull Request */
CREATE PROCEDURE [dbo].[PullRequest4Devs]
(
	@Org varchar(100),
	@login varchar(200),
	@Action varchar(50),
	@day int, 
	@pageSize int
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	if ( @Action = 'null')
		begin
		if (@login = 'null' )
				begin
							-- No login no action (for all pr )
					SELECT DISTINCT TopRow.*, Pr.title as title, pr.Body as body, 
					    pr.pullrequestUrl as pullrequesturl, 
					    cast (pr.Created_At as char(12)) as created_at, pr.Created_At as sortonthis FROM (
						SELECT * , ROW_NUMBER () Over (partition by Org order by [LastUpdated] desc) as [ROW NUMBER]  from [vwOpenClosedPR] 
							WHERE LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
							AND Org = @Org
						
						) AS TopRow JOIN  PullRequestDetails PR ON 
							PR.PullRequestUrl = TopRow.PullRequestUrl
								       WHERE  TopRow.[ROW NUMBER] <= @pageSize 
								ORDER BY sortonthis DESC
				end
		else
				BEGIN
					-- all (open and closed) pr per dev
 
					SELECT DISTINCT TopRow.*, Pr.title as title, pr.Body as body, 
					    pr.pullrequestUrl as pullrequesturl, 
					    cast (pr.Created_At as char(12)) as created_at, pr.Created_At as sortonthis FROM (
						SELECT * , ROW_NUMBER () Over (partition by Org order by [LastUpdated] desc) as [ROW NUMBER]  from [vwOpenClosedPR] 
							WHERE LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
							AND Org = @Org
							AND login = @login 
							AND (Action = 'opened' or Action = 'closed') 
						) AS TopRow JOIN  PullRequestDetails PR ON 
							PR.PullRequestUrl = TopRow.PullRequestUrl
								       WHERE  TopRow.[ROW NUMBER] <= @pageSize 
								ORDER BY sortonthis DESC
					  
				 
				END
		end
	else
		-- action is not null
		begin
			if (@login = 'null' )
				begin
							-- No login but Action (for all pr )
									SELECT DISTINCT TopRow.*, Pr.title as title, pr.Body as body, 
					    pr.pullrequestUrl as pullrequesturl, 
					    cast (pr.Created_At as char(12)) as created_at, pr.Created_At as sortonthis FROM (
						SELECT * , ROW_NUMBER () Over (partition by Org order by [LastUpdated] desc) as [ROW NUMBER]  from [vwOpenClosedPR] 
							WHERE LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
							AND Org = @Org
						 	AND (Action = 'opened' or Action = 'closed') 
						) AS TopRow JOIN  PullRequestDetails PR ON 
							PR.PullRequestUrl = TopRow.PullRequestUrl
								       WHERE  TopRow.[ROW NUMBER] <= @pageSize 
								ORDER BY sortonthis DESC
				end
				else
				begin
					-- login and  Action (for all pr  for particluar dev)
										SELECT DISTINCT TopRow.*, Pr.title as title, pr.Body as body, 
					    pr.pullrequestUrl as pullrequesturl, 
					    cast (pr.Created_At as char(12)) as created_at, pr.Created_At as sortonthis FROM (
						SELECT * , ROW_NUMBER () Over (partition by Org order by [LastUpdated] desc) as [ROW NUMBER]  from [vwOpenClosedPR] 
							WHERE LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
							AND Org = @Org
							AND login = @login 
							AND (Action = 'opened' or Action = 'closed') 
						) AS TopRow JOIN  PullRequestDetails PR ON 
							PR.PullRequestUrl = TopRow.PullRequestUrl
								       WHERE  TopRow.[ROW NUMBER] <= @pageSize 
								ORDER BY sortonthis DESC			
						 
				end
		end
	 
	
END
GO
/****** Object:  StoredProcedure [dbo].[PullRequestCountForLastXDays]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[PullRequestCountForLastXDays]
(
    -- Add the parameters for the stored procedure here
    @Day int = 1,
	@Org varchar(100)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	
	select Action, count(*) ctr from (
	select  Action  from [vwOpenClosedPR] Where 
			LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
			and Org = @Org) T
			group by Action
	
END
GO
/****** Object:  StoredProcedure [dbo].[PullRequestForLastXDays]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[PullRequestForLastXDays]
(
    -- Add the parameters for the stored procedure here
    @Day int = 1,
	@Org varchar(200)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	declare @ctr int
	select * from [vwOpenClosedPR] where 
			LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
			and Org = @Org
	return @ctr
END
GO
/****** Object:  StoredProcedure [dbo].[SetOrg]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SetOrg]
(
    -- Add the parameters for the stored procedure here
   @TenantId varchar(200),
   @Org varchar(1000)
)
AS
BEGIN

    IF NOT EXISTS ( Select * from [dbo].[TenantOrg]  where TenantId = @TenantId  and Org = @org)   
		begin
			Insert into TenantOrg (TenantId,Org) Values (@TenantId, @Org);
		end
	


	 

END
GO
/****** Object:  StoredProcedure [dbo].[SetRepoCollection]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SetRepoCollection]
(
   @TenantId VARCHAR (200),
   @Org VARCHAR (200),
   @Repos VARCHAR (8000),
   @CollectionName VARCHAR (200)
)
AS
	DECLARE @Repo VARCHAR (200)

	CREATE TABLE #T1 (
		val VARCHAR(200),
	)
	INSERT INTO #t1  SELECT VALUE FROM  STRING_SPLIT (@Repos, ',')  
		
	DECLARE RepoCur CURSOR READ_ONLY
      FOR
      SELECT val FROM #T1

	OPEN RepoCur

	FETCH NEXT FROM RepoCur INTO @Repo 

	WHILE @@FETCH_STATUS = 0
	BEGIN

	    IF NOT EXISTS ( SELECT * FROM RepoCollections WHERE TenantId = @TenantId AND ORG = @Org AND CollectionName = @CollectionName AND Repo = @Repo)
			BEGIN
				INSERT INTO RepoCollections ([TenantId],[Org],[Repo],[CollectionName]) VALUES (@TenantId, @Org, @Repo, @CollectionName) 
			END
		FETCH NEXT FROM RepoCur INTO @Repo 
	END
GO
/****** Object:  StoredProcedure [dbo].[SetRepos]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [dbo].[SetRepos]
(
    -- Add the parameters for the stored procedure here
    @TenantId varchar(200),
  --  @Repository varchar(200),
	@Organization varchar(200),
	@Id varchar(100),
    @name VARCHAR(200),
    @desc VARCHAR(1000),
	@HomePage VARCHAR(1000),
	@CreatedAt varchar(10) 
	
)
AS
BEGIN

/*	DECLARE @ID VARCHAR(100)
	DECLARE @Name VARCHAR(200)
	DECLARE @Desc VARCHAR(1000)
	DECLARE @HomePage VARCHAR(1000)
	DECLARE @CreatedAt DateTime

	CREATE TABLE #T1 (
		id VARCHAR(100),
		[name] VARCHAR(200),
		[desc] VARCHAR(1000),
		HomePage VARCHAR(1000),
		CreatedAt varchar(12),

	)
	INSERT INTO #t1  SELECT VALUE FROM  STRING_SPLIT (@Repository, ',')  
		
	DECLARE RepoCur CURSOR READ_ONLY
      FOR
      SELECT * FROM #T1
	OPEN RepoCur
	FETCH NEXT FROM RepoCur INTO @ID, @Name, @Desc, @HomePage, @CreatedAt

	WHILE @@FETCH_STATUS = 0
	BEGIN
	*/
		IF EXISTS ( Select * from TenantRepos  where TenantId = @TenantId and ID = @ID and Organization = @Organization)   
			UPDATE TenantRepos  
					SET LastRefereshed = getDate(),
						RepoName = @Name,
						ID = @ID,
						[Desc] = @Desc,
						HomePage = @HomePage,
						Created_At = cast (@CreatedAt as datetime)
						WHERE TenantId = @TenantId and RepoName = @Name and Organization = @Organization
		ELSE

			INSERT INTO TenantRepos (TenantId,RepoName, Organization, ID, [Desc], HomePage, Created_At)  VALUES
				(@TenantId, @Name, @Organization, @ID, @Desc, @HomePage, cast (@CreatedAt as DateTime));

	/*	FETCH NEXT FROM RepoCur INTO @ID, @Name, @Desc, @HomePage, @CreatedAt
	END
	CLOSE RepoCur
	DEALLOCATE RepoCur
	*/
END
GO
/****** Object:  StoredProcedure [dbo].[SetTenant]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[SetTenant]
(
    -- Add the parameters for the stored procedure here
    @Id varchar(200),
    @UserName varchar(200),
	@DisplayName varchar(200),
	@ProfileUrl varchar(1000),
	@AuthToken varchar(4000),
	@RefreshToken varchar(4000),
	@Photo varchar(1000)
)
AS
BEGIN

    IF EXISTS ( Select * from Tenant  where Id = @Id)   
		Update Tenant Set Auth_Token = @AuthToken, 
						  Refresh_Token = @RefreshToken ,
						  UserName = @UserName,
						  DisplayName = @DisplayName,
						  ProfileUrl = @ProfileUrl,
						  Photo = @Photo
							where Id = @Id
	Else
		Insert into Tenant (Id, UserName, DisplayName, ProfileUrl, Photo, Auth_Token, Refresh_token) Values (@Id, @UserName, @DisplayName, @ProfileUrl, @Photo, @AuthToken, @RefreshToken);
END
GO
/****** Object:  StoredProcedure [dbo].[TopDevForLastXDays]    Script Date: 4/27/2019 7:40:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      <Author, , Name>
-- Create Date: <Create Date, , >
-- Description: <Description, , >
-- =============================================
CREATE PROCEDURE [dbo].[TopDevForLastXDays]
(
    -- Add the parameters for the stored procedure here
    @Day int = 1, 
	@Org varchar(100)
)
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	select login, Avatar_Url, count(*) as ctr from [vwOpenClosedPR]  where 
	LastUpdated between CAST (cast (getdate() - @Day as char(12)) AS DateTime) and Cast (CAST(getdate() as char(12)) as DateTime)
	and Org = @Org
		and Action = 'Opened'
			 group by login, Avatar_Url
				order by ctr desc

END
GO
ALTER DATABASE [Git] SET  READ_WRITE 
GO
