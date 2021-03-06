USE [master]
GO
/****** Object:  Database [electiondata]    Script Date: 12/23/2016 10:34:35 PM ******/
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'electiondata')
BEGIN
CREATE DATABASE [electiondata]
 COLLATE SQL_Latin1_General_CP1_CI_AS
END

GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [electiondata].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [electiondata] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [electiondata] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [electiondata] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [electiondata] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [electiondata] SET ARITHABORT OFF 
GO
ALTER DATABASE [electiondata] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [electiondata] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [electiondata] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [electiondata] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [electiondata] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [electiondata] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [electiondata] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [electiondata] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [electiondata] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [electiondata] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [electiondata] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [electiondata] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [electiondata] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [electiondata] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [electiondata] SET  MULTI_USER 
GO
ALTER DATABASE [electiondata] SET DB_CHAINING OFF 
GO
ALTER DATABASE [electiondata] SET QUERY_STORE = ON
GO
ALTER DATABASE [electiondata] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
/* For security reasons the login is created disabled and with a random password. */
/****** Object:  Login [hadith]    Script Date: 12/23/2016 10:34:35 PM ******/
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'hadith')
CREATE LOGIN [hadith] WITH PASSWORD=N'yxHHypitg2hPFIQ6vU8wJN7QX5T+mtwWxc7p+70p9RM=', DEFAULT_DATABASE=[master], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
ALTER LOGIN [hadith] DISABLE
GO
ALTER AUTHORIZATION ON DATABASE::[electiondata] TO [hadith]
GO
USE [electiondata]
GO
/****** Object:  Table [dbo].[County]    Script Date: 12/23/2016 10:34:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[County]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[County](
	[CountyId] [int] IDENTITY(1,1) NOT NULL,
	[CountyName] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[State] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_County] PRIMARY KEY CLUSTERED 
(
	[CountyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
ALTER AUTHORIZATION ON [dbo].[County] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Precinct]    Script Date: 12/23/2016 10:34:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Precinct]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Precinct](
	[PrecinctId] [int] IDENTITY(1,1) NOT NULL,
	[CountyId] [int] NOT NULL,
	[PrecinctName] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Created] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Precinct] PRIMARY KEY CLUSTERED 
(
	[PrecinctId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
ALTER AUTHORIZATION ON [dbo].[Precinct] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[Results]    Script Date: 12/23/2016 10:34:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Results]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Results](
	[ResultId] [int] IDENTITY(1,1) NOT NULL,
	[PrecinctId] [int] NOT NULL,
	[VoteOptionId] [int] NOT NULL,
	[Count] [int] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[ResultsUntil] [datetime2](7) NOT NULL,
	[ResultType] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_Results] PRIMARY KEY CLUSTERED 
(
	[PrecinctId] ASC,
	[VoteOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
ALTER AUTHORIZATION ON [dbo].[Results] TO  SCHEMA OWNER 
GO
/****** Object:  Table [dbo].[VoteOption]    Script Date: 12/23/2016 10:34:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VoteOption]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[VoteOption](
	[VoteOptionId] [int] IDENTITY(1,1) NOT NULL,
	[ElectionCycle] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Vote] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[VoteOption] [varchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_VoteOption] PRIMARY KEY CLUSTERED 
(
	[ElectionCycle] ASC,
	[Vote] ASC,
	[VoteOption] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
END
GO
ALTER AUTHORIZATION ON [dbo].[VoteOption] TO  SCHEMA OWNER 
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_County_Created]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[County] ADD  CONSTRAINT [DF_County_Created]  DEFAULT (getdate()) FOR [Created]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Precinct_Created]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Precinct] ADD  CONSTRAINT [DF_Precinct_Created]  DEFAULT (getdate()) FOR [Created]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Results_Created]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Results] ADD  CONSTRAINT [DF_Results_Created]  DEFAULT (getdate()) FOR [Created]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Results_ResultsUntil]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Results] ADD  CONSTRAINT [DF_Results_ResultsUntil]  DEFAULT (getdate()) FOR [ResultsUntil]
END

GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DF_Results_ResultType]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[Results] ADD  CONSTRAINT [DF_Results_ResultType]  DEFAULT ('Final') FOR [ResultType]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Precinct_CountyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Precinct]'))
ALTER TABLE [dbo].[Precinct]  WITH CHECK ADD  CONSTRAINT [FK_Precinct_CountyId] FOREIGN KEY([CountyId])
REFERENCES [dbo].[County] ([CountyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Precinct_CountyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[Precinct]'))
ALTER TABLE [dbo].[Precinct] CHECK CONSTRAINT [FK_Precinct_CountyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Results_Precinct1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Results]'))
ALTER TABLE [dbo].[Results]  WITH CHECK ADD  CONSTRAINT [FK_Results_Precinct1] FOREIGN KEY([PrecinctId])
REFERENCES [dbo].[Precinct] ([PrecinctId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Results_Precinct1]') AND parent_object_id = OBJECT_ID(N'[dbo].[Results]'))
ALTER TABLE [dbo].[Results] CHECK CONSTRAINT [FK_Results_Precinct1]
GO
USE [master]
GO
ALTER DATABASE [electiondata] SET  READ_WRITE 
GO
