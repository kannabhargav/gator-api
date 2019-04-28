/****** Object:  Table [dbo].[TenantRepositories]    Script Date: 4/7/2019 10:38:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TenantRepositories](
	[Org] [varchar](200) NOT NULL,
	[Repository] [varchar](200) NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
	[LastRefereshed] [datetime] NOT NULL,
	[Organization] [varchar](200) NOT NULL,
 CONSTRAINT [PK_TenantRepositories] PRIMARY KEY CLUSTERED 
(
	[Org] ASC,
	[Organization] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TenantRepositories] ADD  CONSTRAINT [DF_TenantRepositories_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO

ALTER TABLE [dbo].[TenantRepositories] ADD  CONSTRAINT [DF_TenantRepositories_LastRefereshed]  DEFAULT (getdate()) FOR [LastRefereshed]
GO




ALTER TABLE [dbo].[Tenant] DROP CONSTRAINT [DF_Tenant_LastUpdated]
GO

/****** Object:  Table [dbo].[Tenant]    Script Date: 4/7/2019 9:31:36 AM ******/
DROP TABLE [dbo].[Tenant]
GO

/****** Object:  Table [dbo].[Tenant]    Script Date: 4/7/2019 9:31:36 AM ******/
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
	[Refresh_Token] [varchar] (4000) NULL,
	[Photo] varchar(1000) NULL
 CONSTRAINT [PK_Tenant] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tenant] ADD  CONSTRAINT [DF_Tenant_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO




/****** Object:  Table [dbo].[GitLogIn]    Script Date: 4/6/2019 1:26:04 PM ******/
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

ALTER TABLE [dbo].[GitLogIn] ADD  CONSTRAINT [DF_GitLogIn_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO

/****** Object:  Table [dbo].[PullRequestDetails]    Script Date: 4/6/2019 1:29:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[PullRequestDetails](
	[Org] [nchar](100) NOT NULL,
	[login] [varchar](100) NOT NULL,
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
	[LastUpdated] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PullRequestDetails] ADD  CONSTRAINT [DF_PullRequestDetails_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO





