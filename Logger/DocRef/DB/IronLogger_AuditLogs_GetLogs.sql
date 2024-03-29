USE [MotorClaimDemo]
GO

/****** Object:  StoredProcedure [dbo].[IronLogger_AuditLogs_GetLogs]    Script Date: 03/12/2013 15:11:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[IronLogger_AuditLogs_GetLogs]
        @ModuleName			varchar(100),
        @ActionName			varchar(100),
        @AccessType			nvarchar(100),
        @AccessIP			nvarchar(200),
        @UserName			nvarchar(100),
        --@RefID				int,
        @EventStatus		varchar(25),
        @DateFrom			datetime,
        @DateTo				datetime,
        @Description		varchar(MAX),
        @Params				nvarchar(MAX),
        
		@orderByCol			VARCHAR(50),		
		@isAscending		BIT,
		@StartIndex			INT	= 1,
		@pageSize			INT	= 10,
		@rowCount			INT OUTPUT 
AS
BEGIN

DECLARE @T TABLE(EventId int, Module varchar(100), [Action] varchar(100), AccessType nvarchar(100), AccessIP nvarchar(200), UserName nvarchar(100), RefID int, EventStatus varchar(25), [Date] datetime, [Description] varchar(MAX), Params nvarchar(MAX))

INSERT INTO @T SELECT EventId, Module, [Action], AccessType, AccessIP, UserName, RefID, EventStatus, [Date], [Description], Params FROM AuditLogs
          WHERE Module LIKE @ModuleName + '%' 
          AND [Action] LIKE @ActionName + '%' 
          AND AccessType LIKE @AccessType + '%' 
          AND AccessIP LIKE @AccessIP + '%' 
          AND UserName LIKE @UserName + '%' 
          AND EventStatus LIKE @EventStatus + '%' 
          AND [Date] > @DateFrom
          AND [Date] < @DateTo
          AND [Description] LIKE @Description + '%'
          AND Params LIKE @Params + '%'

SELECT EventId, Module, [Action], AccessType, AccessIP, UserName, RefID, EventStatus, [Date], [Description], Params
FROM    ( SELECT    ROW_NUMBER() OVER ( ORDER BY 
		CASE WHEN @isAscending=1 THEN 
			CASE WHEN @orderByCol='EventId' THEN EventId END 
		END ASC,
		CASE WHEN @isAscending=1 THEN 
			CASE WHEN @orderByCol='EventStatus' THEN EventStatus
				WHEN @orderByCol='Description' THEN [Description]
			END
		END ASC,
		CASE WHEN @isAscending=1 THEN 
			CASE WHEN @orderByCol='RefId' THEN RefId END
		END ASC,
		CASE WHEN @isAscending=1 THEN 
			CASE WHEN @orderByCol='Date' THEN [Date] END
		END ASC,
		CASE WHEN @isAscending=1 THEN 
			CASE WHEN @orderByCol='UserName' THEN UserName
				WHEN @orderByCol='Module' THEN Module
				WHEN @orderByCol='Action' THEN [Action]
				WHEN @orderByCol='AccessType' THEN AccessType
				WHEN @orderByCol='AccessIP' THEN AccessIP
				WHEN @orderByCol='Params' THEN Params
			END
		END	ASC, 
		
		CASE WHEN @isAscending=0 THEN 
			CASE WHEN @orderByCol='EventId' THEN EventId END 
		END DESC,
		CASE WHEN @isAscending=0 THEN 
			CASE WHEN @orderByCol='EventStatus' THEN EventStatus
				WHEN @orderByCol='Description' THEN [Description]
			END
		END DESC,
		CASE WHEN @isAscending=0 THEN 
			CASE WHEN @orderByCol='RefId' THEN RefId END
		END DESC,
		CASE WHEN @isAscending=0 THEN 
			CASE WHEN @orderByCol='Date' THEN [Date] END
		END DESC,
		CASE WHEN @isAscending=0 THEN 
			CASE WHEN @orderByCol='UserName' THEN UserName
				WHEN @orderByCol='Module' THEN Module
				WHEN @orderByCol='Action' THEN [Action]
				WHEN @orderByCol='AccessType' THEN AccessType
				WHEN @orderByCol='AccessIP' THEN AccessIP
				WHEN @orderByCol='Params' THEN Params
			END
		END	DESC ) AS RowNum, *
          FROM  @T AS RT
        ) AS RowConstrainedResult
WHERE   RowNum >= @StartIndex AND RowNum < @StartIndex + @pageSize
ORDER BY RowNum

SELECT @rowCount = COUNT(*) FROM @T

END

/*
DECLARE @r AS int
 exec [dbo].[IronLogger_AuditLogs_GetLogs] '','','','','','Failure','2012-03-07 14:15:57.323','2013-03-11 14:15:57.323','','','Module',1,1,10,@r OUTPUT
SELECT @r
*/
GO

