USE [MotorClaimDemo]
GO

/****** Object:  StoredProcedure [dbo].[IronLogger_AuditLogs_AddLog]    Script Date: 03/12/2013 15:11:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[IronLogger_AuditLogs_AddLog]
        @eventStatus		varchar(25),
        @desciption			varchar(MAX),
        @refId				int,
        @userName			nvarchar(100),
        @module				varchar(100),
        @action				varchar(100),
        @accessType			nvarchar(100),
        @accessIP			nvarchar(200),
        @param				nvarchar(MAX)
AS
BEGIN
    INSERT
        dbo.AuditLogs
        (
            EventStatus,
            [Description],
            RefId,
            UserName,
            Module,
            [Action],
            AccessType,
            AccessIP,
            Params
        )
    VALUES
    (
        @eventStatus,
        @desciption,
        @refId,
        @userName,
        @module,
        @action,
        @accessType,
        @accessIP,
        @param
    )
END

GO

