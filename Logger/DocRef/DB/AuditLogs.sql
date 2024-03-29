USE [MotorClaimDemo]
GO

/****** Object:  Table [dbo].[AuditLogs]    Script Date: 03/12/2013 15:10:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[AuditLogs](
	[EventId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventStatus] [varchar](25) NOT NULL,
	[Description] [varchar](max) NULL,
	[RefId] [int] NULL,
	[Date] [datetime] NULL,
	[UserName] [nvarchar](100) NULL,
	[Module] [varchar](100) NOT NULL,
	[Action] [varchar](100) NOT NULL,
	[AccessType] [nvarchar](100) NOT NULL,
	[AccessIP] [nvarchar](200) NOT NULL,
	[Params] [nvarchar](max) NOT NULL,
	[Info1] [nvarchar](500) NULL,
	[Info2] [nvarchar](250) NULL,
	[Info3] [int] NULL,
 CONSTRAINT [PK_AuditLogs] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[AuditLogs] ADD  CONSTRAINT [DF_AuditLogs_Date]  DEFAULT (getdate()) FOR [Date]
GO

