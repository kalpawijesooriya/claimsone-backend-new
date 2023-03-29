/*SCHEMA CHANGES*/

--new columns
 ALTER TABLE [MotorClaimMigrate].[dbo].[SAForm_level1] ADD [VAD_DriverIdType] [smallint] NULL

 ALTER TABLE [MotorClaimMigrate].[dbo].[Visits] ADD [PrintedBy] [nvarchar](100) NULL,[PrintedBranch] [nvarchar](50) NULL,[PrintedDate] [datetime] NULL
 
GO

 --view changes
/****** Object:  View [dbo].[vw_SAFormDetails]    Script Date: 02/10/2016 12:35:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_SAFormDetails]
AS
SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
                      dbo.SAForm_level1.GEN_VehicleNo, dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
                      dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
                      dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.SAForm_level1.POL_Policy_CN_No, 
                      dbo.SAForm_level1.POL_Policy_CN_StartDate, dbo.SAForm_level1.POL_Policy_CN_EndDate, dbo.SAForm_level1.POL_Policy_CN_SerialNo, 
                      dbo.SAForm_level1.POL_CN_IssuedBy, dbo.SAForm_level1.POL_CN_Reasons, dbo.SAForm_level1.VAD_ChassyNo, dbo.SAForm_level1.VAD_EngineNo, 
                      dbo.SAForm_level1.VAD_MeterReading, dbo.SAForm_level1.VAD_DriverName, dbo.SAForm_level1.VAD_DriverNIC, dbo.SAForm_level1.VAD_DriverCompetence, 
                      dbo.SAForm_level1.VAD_License_No, dbo.SAForm_level1.VAD_DriverRelationship, dbo.SAForm_level1.VAD_License_ExpiryDate, 
                      dbo.SAForm_level1.VAD_License_TypeId, dbo.SAForm_level1.VAD_License_IsNew, dbo.SAForm_level1.VAD_License_IsNewOld_TypeId, 
                      dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.SAForm_level1.OTH_PavValue, dbo.SAForm_level1.OTH_CSR_Consistency, 
                      dbo.SAForm_level1.OTH_SiteEstimation, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.SAForm_level2.CON_Tyre_FR_Status, 
                      dbo.SAForm_level2.CON_Tyre_FL_Status, dbo.SAForm_level2.CON_Tyre_RRL_Status, dbo.SAForm_level2.CON_Tyre_RLR_Status, 
                      dbo.SAForm_level2.CON_Tyre_RLL_Status, dbo.SAForm_level2.CON_Tyre_RRR_Status, dbo.SAForm_level2.CON_Tyre_IsContributory, 
                      dbo.SAForm_level2.DAM_DamagedItems, dbo.SAForm_level2.DAM_DamagedItems_Other, dbo.SAForm_level2.DAM_PreAccidentDamages, 
                      dbo.SAForm_level2.DAM_PreAccidentDamages_Other, dbo.SAForm_level2.DAM_PossibleDR, dbo.SAForm_level2.DAM_PossibleDR_Other, 
                      dbo.SAForm_level2.DAM_Goods_Type, dbo.SAForm_level2.DAM_Goods_Weight, dbo.SAForm_level2.DAM_Goods_Damage, dbo.SAForm_level2.DAM_IsOverLoaded, 
                      dbo.SAForm_level2.DAM_OtherVeh_Involved, dbo.SAForm_level2.DAM_Is_OL_Contributory, dbo.SAForm_level2.DAM_ThirdParty_Damage, 
                      dbo.SAForm_level2.DAM_Injuries, dbo.SAForm_level2.OTH_Journey_PurposeId, dbo.SAForm_level2.OTH_Nearest_PoliceStation, 
                      dbo.Users.FirstName AS CSRFirstName, dbo.Users.LastName AS CSRLastName, dbo.Users.Code AS CSRCode, dbo.Branches.BranchName, dbo.Users.ContactNo, 
                      dbo.Visits.PrintedBy, dbo.Visits.PrintedDate, dbo.Visits.PrintedBranch, dbo.SAForm_level1.VAD_DriverIdType
FROM         dbo.Visits INNER JOIN
                      dbo.SAForm_level1 ON dbo.Visits.VisitId = dbo.SAForm_level1.VisitId INNER JOIN
                      dbo.SAForm_level2 ON dbo.Visits.VisitId = dbo.SAForm_level2.VisitId INNER JOIN
                      dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
                      dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
WHERE     (dbo.Visits.Info1 <> 'd') OR
                      (dbo.Visits.Info1 IS NULL)

GO



/****** Object:  View [dbo].[vw_SAForm_General]    Script Date: 02/10/2016 12:36:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_SAForm_General]
AS
SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
                      dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
                      dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
                      dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
                      dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
                      dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
                      dbo.Users.EPFNo,
                          (SELECT     COUNT(*) AS Expr1
                            FROM          dbo.ImageGallery
                            WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
                      dbo.Branches.RegionId AS ProcessingRegionId,
                          (SELECT     RegionName AS Expr2
                            FROM          dbo.Regions
                            WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
FROM         dbo.SAForm_level1 INNER JOIN
                      dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
                      dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
                      dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
WHERE     (dbo.Visits.Info1 <> 'd') OR
                      (dbo.Visits.Info1 IS NULL)

GO


/****** Object:  View [dbo].[vw_SAForm_VehDriverDetails]    Script Date: 02/10/2016 12:36:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_SAForm_VehDriverDetails]
AS
SELECT     VisitId, VAD_ChassyNo, VAD_EngineNo, VAD_MeterReading, VAD_DriverName, VAD_DriverNIC, VAD_DriverCompetence, VAD_DriverRelationship, VAD_License_No, 
                      VAD_License_ExpiryDate, VAD_License_TypeId, VAD_License_IsNew, VAD_License_IsNewOld_TypeId, VAD_DriverIdType
FROM         dbo.SAForm_level1

GO


/****** Object:  View [dbo].[vw_SAForm_OtherDetails]    Script Date: 02/10/2016 12:36:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vw_SAForm_OtherDetails]
AS
SELECT     dbo.SAForm_level1.VisitId, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.SAForm_level1.OTH_PavValue, dbo.SAForm_level1.OTH_CSR_Consistency, 
                      dbo.SAForm_level1.OTH_SiteEstimation, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.SAForm_level2.OTH_Journey_PurposeId, 
                      dbo.SAForm_level2.OTH_Nearest_PoliceStation
FROM         dbo.SAForm_level2 INNER JOIN
                      dbo.SAForm_level1 ON dbo.SAForm_level2.VisitId = dbo.SAForm_level1.VisitId

GO



/*DATA CHANGES*/
--update role permissions

UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML, ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,AuditLogToExcel_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML'
 WHERE [RoleName] = 'System Administrator'

 UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML'
 WHERE [RoleName] = 'Audit'

 UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PrintVisit_JSON,JobFullPrintPreview_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML'
 WHERE [RoleName] = 'Claim Processing Officer'

 UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML'
 WHERE [RoleName] = 'Engineer'

 UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML'
 WHERE [RoleName] = 'Management'

 UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML'
 WHERE [RoleName] = 'Technical Officer'

 UPDATE [MotorClaimMigrate].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UpdateProfile_HTML,AdvancedSearchResultPrintPreview_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PrintVisit_JSON,JobFullPrintPreview_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML'
 WHERE [RoleName] = 'Temp Printing'

 SET IDENTITY_INSERT [MotorClaimMigrate].[dbo].[Branches] ON
 
INSERT INTO [MotorClaimMigrate].[dbo].[Branches]
           ([BranchId]
			,[RegionId]
           ,[BranchName]
           ,[BranchCode]
           ,[BranchAddress]
           ,[IsClaimProcessed]
           ,[IsEnabled]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[DeletedDate]
           ,[Info1]
           ,[Info2]
           ,[Info3])
     VALUES
           (105,
		   15
           ,'Batticaloa'
           ,190
           ,'Batticaloa'
           ,'True'
           ,'True'
           ,'False'
           ,37
           ,'2016-02-10 15:35:03.090' 
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO
INSERT INTO [MotorClaimMigrate].[dbo].[Branches]
           ([BranchId]
			,[RegionId]
           ,[BranchName]
           ,[BranchCode]
           ,[BranchAddress]
           ,[IsClaimProcessed]
           ,[IsEnabled]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[DeletedDate]
           ,[Info1]
           ,[Info2]
           ,[Info3])
     VALUES
           (106
		   ,14
           ,'Galgamuwa'
           ,191
           ,'Galgamuwa'
           ,'True'
           ,'True'
           ,'False'
           ,37
           ,'2016-02-10 15:35:03.090' 
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO
INSERT INTO [MotorClaimMigrate].[dbo].[Branches]
           ([BranchId]
			,[RegionId]
           ,[BranchName]
           ,[BranchCode]
           ,[BranchAddress]
           ,[IsClaimProcessed]
           ,[IsEnabled]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[DeletedDate]
           ,[Info1]
           ,[Info2]
           ,[Info3])
     VALUES
           (107
		   ,15
           ,'Hingurakgoda'
           ,192
           ,'Hingurakgoda'
           ,'True'
           ,'True'
           ,'False'
           ,37
           ,'2016-02-10 15:35:03.090' 
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO

INSERT INTO [MotorClaimMigrate].[dbo].[Branches]
           ([BranchId],
		   [RegionId]
           ,[BranchName]
           ,[BranchCode]
           ,[BranchAddress]
           ,[IsClaimProcessed]
           ,[IsEnabled]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[DeletedDate]
           ,[Info1]
           ,[Info2]
           ,[Info3])
     VALUES
           (108
		   ,10
           ,'Kadawatha'
           ,193
           ,'Kadawatha'
           ,'True'
           ,'True'
           ,'False'
           ,37
           ,'2016-02-10 15:35:03.090' 
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO
SET IDENTITY_INSERT [MotorClaimMigrate].[dbo].[Branches] OFF
INSERT INTO [MotorClaimMigrate].[dbo].[Regions]
           (
		   
		   [RegionName]
           ,[RegionCode]
           ,[IsEnabled]
           ,[IsDeleted]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[UpdatedBy]
           ,[UpdatedDate]
           ,[DeletedDate]
           ,[Info1]
           ,[Info2]
           ,[Info3])
     VALUES
           ('Katana'
           ,'11111'
           ,'True'
           ,'False'
           ,37
           ,'2016-02-10 14:57:38.580'
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL
           ,NULL)
GO

 
 /*Sored procedure changes*/
 USE [MotorClaimMigrate]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationRatio]    Script Date: 02/17/2016 14:23:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Sasini Madhumali
-- Create date: 10/02/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SAForms_GetOnsiteEstimationRatio] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@UserId int = 0
AS
BEGIN

if(@UserId = -1)
	SELECT
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(5,2),
				(CONVERT(DECIMAL(6,3),(SELECT COUNT(*) 
									from [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId 
										AND v.OTH_SiteEstimation=1))
				/CONVERT(DECIMAL(6,3),(SELECT COUNT(*) 
									FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId))))*100
			AS Ratio
				
	FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
	GROUP BY UserId
	
	
else
	SELECT 
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(5,2),
			(	CONVERT(DECIMAL(6,3),(SELECT count(*) 
									FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))
				/CONVERT(DECIMAL(6,3),(SELECT count(*) 
									FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))*100
			AS Ratio
				
	FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId
	
	
END

GO


USE [MotorClaimMigrate]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetRegionalOnsiteEstimationRatio]    Script Date: 02/17/2016 14:25:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Sasini Madhumali
-- Create date: 12/02/2016
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SAForms_GetRegionalOnsiteEstimationRatio] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@RegionId = -1)
	SELECT
			(SELECT top(1) RegionCode FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionCode ,
			(SELECT top(1) RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.ProcessingRegionId= j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(5,2),
				(CONVERT(DECIMAL(6,3),(SELECT COUNT(*) 
									from [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.ProcessingRegionId= j.ProcessingRegionId  
										AND v.OTH_SiteEstimation=1))
				/CONVERT(DECIMAL(6,3),(SELECT COUNT(*) 
									FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.ProcessingRegionId= j.ProcessingRegionId ))))*100
			AS Ratio
				
	FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo
	GROUP BY ProcessingRegionId
	
	
else
	SELECT 
			(SELECT top(1) RegionCode FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionCode ,
			(SELECT top(1) RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.ProcessingRegionId= j.ProcessingRegionId 
					AND v.ProcessingRegionId=@RegionId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(5,2),
			(	CONVERT(DECIMAL(6,3),(SELECT count(*) 
									FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.ProcessingRegionId=@RegionId 
											AND v.ProcessingRegionId= j.ProcessingRegionId 
											AND v.OTH_SiteEstimation=1))
				/CONVERT(DECIMAL(6,3),(SELECT count(*) 
									FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.ProcessingRegionId= j.ProcessingRegionId
										AND v.ProcessingRegionId=@RegionId))))*100
			AS Ratio
				
	FROM [MotorClaimMigrate].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.ProcessingRegionId=@RegionId
	GROUP BY ProcessingRegionId
	
	
END

GO

-- =============================================
-- Author:		Dulaj Perera
-- Create date: 28/10/2016
-- Description:	update role permissions
-- =============================================

UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML'
 WHERE [RoleName] = 'System Administrator'

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML'
 WHERE [RoleName] = 'Engineer'


 -- =============================================
-- Author:		Dulaj Perera
-- Create date: 07/11/2016
-- Description:	update role permissions 
-- =============================================

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML'
 WHERE [RoleName] = 'Management'


  UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML'
 WHERE [RoleName] = 'Audit'



   -- =============================================
-- Author:		Dulaj Perera
-- Create date: 08/11/2016
-- Description:	update role permissions 
-- =============================================

  UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML'
 WHERE [RoleName] = 'Audit'

  UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML'
 WHERE [RoleName] = 'Engineer'


    -- =============================================
-- Author:		Dulaj Perera
-- Create date: 10/11/2016
-- Description:	update role permissions 
-- =============================================

  UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML'
 WHERE [RoleName] = 'Technical Officer'

   -- =============================================
-- Author:		Dulaj Perera
-- Create date: 15/11/2016
-- Description:	update role permissions 
-- =============================================

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML'
 WHERE [RoleName] = 'Management'

    -- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 15/11/2016
-- Description:	update role permissions 
-- =============================================
 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML'
 WHERE [RoleName] = 'Management'

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
	SET 
	[Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML'
WHERE RoleName='Audit'

    -- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2016
-- Description:	update role permissions 
-- =============================================

UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML'
 WHERE [RoleName] = 'System Administrator'

  UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
	SET 
	[Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML'
WHERE RoleName='Audit'

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
	SET 
	[Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML'
WHERE RoleName='Engineer'

    -- =============================================
-- Author:		Dulaj Perera
-- Create date: 01/12/2016
-- Description:	Create new View (vw_SAForm_GeneralNew)
-- =============================================



USE [ClaimsOneLive]
GO

/****** Object:  View [dbo].[vw_SAForm_GeneralNew]    Script Date: 12/2/2016 1:32:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_SAForm_GeneralNew]
AS
SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
                      dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
                      dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
                      dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
                      dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
                      dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
                      dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,
					  (SELECT     COUNT(*) AS Expr1
                            FROM          dbo.ImageGallery
                            WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
                      dbo.Branches.RegionId AS ProcessingRegionId,
                          (SELECT     RegionName AS Expr2
                            FROM          dbo.Regions
                            WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
FROM         dbo.SAForm_level1 INNER JOIN
                      dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
                      dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
                      dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
WHERE     (dbo.Visits.Info1 <> 'd') OR
                      (dbo.Visits.Info1 IS NULL)





GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[18] 2[23] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = -33
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Branches"
            Begin Extent = 
               Top = 358
               Left = 317
               Bottom = 657
               Right = 478
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Users"
            Begin Extent = 
               Top = 6
               Left = 571
               Bottom = 384
               Right = 735
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Visits"
            Begin Extent = 
               Top = 6
               Left = 316
               Bottom = 346
               Right = 533
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SAForm_level1"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 378
               Right = 278
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 30
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 15' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SAForm_GeneralNew'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'00
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SAForm_GeneralNew'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SAForm_GeneralNew'
GO




-- =============================================
-- Author:	Suren Manawatta
-- Create date: 2016-12-08
-- Description:	New table added (Settings)
-- =============================================

USE [ClaimsOneLive]
GO

/****** Object:  Table [dbo].[Settings]    Script Date: 12/8/2016 3:27:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Settings](
	[SettingId] [int] IDENTITY(1,1) NOT NULL,
	[SettingName] [nvarchar](100) NOT NULL,
	[SettingValue] [nvarchar](500) NULL,
 CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--Update role permissions for Sys admin
UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,AppManagement_HTML'
 WHERE [RoleName] = 'System Administrator'

-- END
-- Author:	Suren Manawatta
-- =============================================
-- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 15/12/2016
-- Description:	Update the sp to avoid Divide by zero error.
-- ============================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationRatio]    Script Date: 12/14/2016 14:28:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimationRatio] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@UserId int = 0
AS
BEGIN

if(@UserId = -1)
	SELECT
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId 
										AND v.OTH_SiteEstimation=1))
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId)),0)))*100
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
	GROUP BY UserId
	
	
else
	SELECT 
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))*100,0
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId
	
	
END
END


-- =============================================
-- Author:		Dulaj Perera
-- Create date: 21/12/2016
-- Description:	update role permissions 
-- =============================================

UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML'
 WHERE [RoleName] = 'System Administrator'


UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML'
 WHERE [RoleName] = 'Management'


UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML'
 WHERE [RoleName] = 'Audit'

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML'
 WHERE [RoleName] = 'Technical Officer'

 UPDATE [ClaimsOneLive].[dbo].[aspnet_Roles]
   SET 
      [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML'
 WHERE [RoleName] = 'Engineer'


-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: <01/09/2017>
-- Description:	Create new stored procedure
-- =============================================


/****** Object:  StoredProcedure [dbo].[SAForms_GetMissingImagesNew]    Script Date: 12/30/2016 14:27:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[SAForms_GetMissingImagesNew] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as a 
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as a 
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
    
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as a 
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END

GO

-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: <01/09/2017>
-- Description:	update role permissions 
-- =============================================

  update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML'
  where [RoleName]='Technical Officer'

-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: <01/09/2017>
-- Description:	update role permissions 
-- =============================================

  update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description] ='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,MissingImagesToExcel_HTML'
  where [RoleName] = 'Audit'

  update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description] ='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML'
  where [RoleName] = 'Management'

    update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description] ='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML'
  where [RoleName] = 'Technical Officer'


-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/09/2017>
-- Description:	<>
-- =============================================


  update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]= 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OutstandingSAPrintPreview_HTML,TOPerformancePrintPreview_HTML'
  where [RoleName]='Technical Officer'

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/09/2017>
-- Description:	<Get jobs SP>
-- =============================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[GetJobs]    Script Date: 01/06/2017 15:15:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[GetJobs] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId nvarchar(128),
    @EPFNo nvarchar(128),
	@orderBy nvarchar(128)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		
			SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId, ROW_NUMBER() OVER (ORDER BY dbo.Visits.VisitId) AS RowNum,
						  (SELECT     COUNT(*) AS Expr1
								FROM          dbo.ImageGallery
								WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
						  dbo.Branches.RegionId AS ProcessingRegionId,
							  (SELECT     RegionName AS Expr2
								FROM          dbo.Regions
								WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName LIKE '%'+ @TOName+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)
				
			ORDER BY 
			CASE @orderBy WHEN 'Job No asc' THEN JobNo END ASC,
			CASE @orderBy WHEN 'Job No desc' THEN JobNo END DESC,
			CASE @orderBy WHEN 'Vehicle No asc' THEN GEN_VehicleNo END ASC,
			CASE @orderBy WHEN 'Vehicle No desc' THEN GEN_VehicleNo END DESC,
			CASE @orderBy WHEN 'TO Code asc' THEN Code END ASC,
			CASE @orderBy WHEN 'TO Code desc' THEN Code END DESC,
			CASE @orderBy WHEN 'ACR asc' THEN OTH_Approx_RepairCost END ASC,
			CASE @orderBy WHEN 'ACR desc' THEN OTH_Approx_RepairCost END DESC,
			CASE @orderBy WHEN 'Claim Processing Branch asc' THEN BranchName END ASC,
			CASE @orderBy WHEN 'Claim Processing Branch desc' THEN BranchName END DESC,
			CASE @orderBy WHEN 'Date of Accident asc' THEN GEN_Acc_Time END ASC,
			CASE @orderBy WHEN 'Date of Accident desc' THEN GEN_Acc_Time END DESC

END


GO


-- =============================================
-- Author:		Suren Manawatta
-- Create date: 2017-01-10
-- Description:	vw_ImageGallery optimization
-- =============================================

--NOTE: Execute the followings one by one
ALTER INDEX PK_ImageGallery ON dbo.ImageGallery REBUILD

UPDATE STATISTICS ImageGallery

CREATE NONCLUSTERED INDEX IX_ImgGal_VisitId ON dbo.ImageGallery ([VisitId],[FieldId])

-- =============================================

-- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 2017-01-18
-- Description:	SAForms_GetOnsiteEstimationRatio is Updated
-- =======================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationRatio]    Script Date: 01/18/2017 13:39:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimationRatio] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@UserId int = 0
AS
BEGIN

if(@UserId = -1)
	SELECT
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
	GROUP BY UserId
	
	
else
	SELECT 
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId
	
	
END

-- ======================================================

-- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 2017-01-18
-- Description:	SAForms_GetRegionalOnsiteEstimationRatio is Updated
-- =======================================================

/****** Object:  StoredProcedure [dbo].[SAForms_GetRegionalOnsiteEstimationRatio]    Script Date: 01/18/2017 13:56:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SAForms_GetRegionalOnsiteEstimationRatio] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if(@RegionId = -1)
	SELECT
			(SELECT top(1) RegionCode FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionCode ,
			(SELECT top(1) RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.ProcessingRegionId= j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.ProcessingRegionId= j.ProcessingRegionId  
										AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.ProcessingRegionId= j.ProcessingRegionId ))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo
	GROUP BY ProcessingRegionId
	
	
else
	SELECT 
			(SELECT top(1) RegionCode FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionCode ,
			(SELECT top(1) RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.ProcessingRegionId= j.ProcessingRegionId 
					AND v.ProcessingRegionId=@RegionId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.ProcessingRegionId=@RegionId 
											AND v.ProcessingRegionId= j.ProcessingRegionId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.ProcessingRegionId= j.ProcessingRegionId
										AND v.ProcessingRegionId=@RegionId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.ProcessingRegionId=@RegionId
	GROUP BY ProcessingRegionId
	
	
END



-- =============================================

-- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 2017-01-19
-- Description:	Role Permissions are Updated
-- =======================================================

  update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,MissingImagesToExcel_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML'
  where [RoleName]='Audit'

    update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML'
  where [RoleName]='Engineer'

    update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML'
  where [RoleName]='Management'

    update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AppManagement_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML'
  where [RoleName]='System Administrator'

   update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OutstandingSAPrintPreview_HTML,TOPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML'
  where [RoleName]='Technical Officer'

  -- =============================================

 update [ClaimsOneLive].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,SearchByVehicleNo_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OutstandingSAPrintPreview_HTML,TOPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationToExcel_HTML'
  where [RoleName]='Technical Officer'

  -- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 2017-01-20
-- Description:	Role Permissions are Updated
-- =======================================================

/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationRatio]    Script Date: 01/20/2017 14:03:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimationRatio] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@UserId int = 0
AS
BEGIN

if(@UserId = -1)
	SELECT
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
	GROUP BY UserId
	
	
else
	SELECT 
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId
	
	
END

-- ======================================================

-- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 2017-01-25
-- Description:	[vw_SAForm_General] is modified
-- =======================================================

USE [ClaimsOneLive]
GO

/****** Object:  View [dbo].[vw_SAForm_General]    Script Date: 01/24/2017 14:24:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_SAForm_General]
AS
SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
                      dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
                      dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
                      dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
                      dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
                      dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
                      dbo.Users.EPFNo,
                          (SELECT     COUNT(*) AS Expr1
                            FROM          dbo.ImageGallery
                            WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
                      dbo.Branches.RegionId AS ProcessingRegionId,
                          (SELECT     RegionName AS Expr2
                            FROM          dbo.Regions
                            WHERE      (RegionId = dbo.Branches.RegionId) AND RegionId= dbo.Users.RegionId) AS RegionName
FROM         dbo.SAForm_level1 INNER JOIN
                      dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
                      dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
                      dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
WHERE     (dbo.Visits.Info1 <> 'd') OR
                      (dbo.Visits.Info1 IS NULL) AND (dbo.Branches.RegionId= dbo.Users.RegionId)


GO
-- ======================================================

-- =======================================================
-- Author:		Uthpala Pathirana
-- Create date: 2017-01-25
-- Description:	[SAForms_GetOnsiteEstimation] is created
-- =======================================================


/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimation]    Script Date: 01/24/2017 14:44:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	For the purpose of displaying TO list in onsite estimation report
-- ============================================================================
CREATE PROCEDURE [dbo].[SAForms_GetOnsiteEstimation] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
if(@RegionId = -1)
	if(@UserId = -1)
	
		-- All regions all TOs
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId
					--AND v.ProcessingRegionId=j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId )),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
	GROUP BY UserId,j.ProcessingRegionId
	
	else
		-- All regions, specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId,j.ProcessingRegionId
else
	
	if(@UserId = -1)
	-- Specific region all TOs in that region
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId
					AND v.ProcessingRegionId= @RegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId
										AND v.ProcessingRegionId= @RegionId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo AND j.ProcessingRegionId= @RegionId
	GROUP BY UserId,j.ProcessingRegionId
	
	else
		-- Specific region specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId
					AND j.ProcessingRegionId = @RegionId
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND j.ProcessingRegionId = @RegionId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND j.ProcessingRegionId = @RegionId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
		AND j.ProcessingRegionId = @RegionId
	GROUP BY UserId,j.ProcessingRegionId
	
END

GO

-- ======================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 25/01/2017
-- Description:	Deleted the SP [SAForms_GetOnsiteEstimationRatio]
-- ============================================================================

/*USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationRatio]    Script Date: 01/25/2017 13:40:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAForms_GetOnsiteEstimationRatio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SAForms_GetOnsiteEstimationRatio]
GO*/
-- ======================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 25/01/2017
-- Description:	Deleted the SP [SAForms_GetRegionalOnsiteEstimationRatio]
-- ============================================================================

/*USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetRegionalOnsiteEstimationRatio]    Script Date: 01/25/2017 13:40:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SAForms_GetRegionalOnsiteEstimationRatio]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SAForms_GetRegionalOnsiteEstimationRatio]
GO*/
-- ======================================================


-- ======================================================
-- ============================================================================
-- Author:		Suren Manawatta
-- Create date: 30/01/2017
-- Description:	
-- ============================================================================

USE [ClaimsOneLive]
GO

/****** Object:  Table [dbo].[AssignedJobs]    Script Date: 1/30/2017 5:00:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AssignedJobs](
	[AssignedJobId] [int] IDENTITY(1,1) NOT NULL,
	[JobNumber] [nvarchar](30) NOT NULL,
	[CSRCode] [nvarchar](30) NOT NULL,
	[VehicleNumber] [nvarchar](50) NULL,
	[AssignedDateTime] [datetime] NULL,
	[Info1] [nvarchar](250) NULL,
	[Info2] [nvarchar](250) NULL,
	[Info3] [nvarchar](250) NULL,
 CONSTRAINT [PK_AssignedJobs] PRIMARY KEY CLUSTERED 
(
	[AssignedJobId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

USE [ClaimsOneLive]
GO

/****** Object:  Table [dbo].[Holidays]    Script Date: 1/30/2017 5:05:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Holidays](
	[HolidayId] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Info1] [nvarchar](250) NULL,
	[Info2] [nvarchar](250) NULL,
	[Info3] [nvarchar](250) NULL,
 CONSTRAINT [PK__Holidays__2D35D57A6F9A089B] PRIMARY KEY CLUSTERED 
(
	[HolidayId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

-- ======================================================


-- ============================================================================
-- Author:		Lushanthan Sivaneasharajah
-- Create date: 02/02/2017
-- Description:	Web version 3.11.22
-- ============================================================================
USE [ClaimsOneLive]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetJobs] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
    @EPFNo nvarchar(128),
	@orderBy nvarchar(128),
	@SkipRows smallint,
	@GetRows smallint
AS
BEGIN
	SET NOCOUNT ON;		
			SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId, ROW_NUMBER() OVER (ORDER BY dbo.Visits.VisitId) AS RowNum,
						  (SELECT     COUNT(*) AS Expr1
								FROM          dbo.ImageGallery
								WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
						  dbo.Branches.RegionId AS ProcessingRegionId,
							  (SELECT     RegionName AS Expr2
								FROM          dbo.Regions
								WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName LIKE '%'+ @TOName+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)
				
			ORDER BY
			CASE @orderBy WHEN 'Job No asc' THEN JobNo END ASC,
			CASE @orderBy WHEN 'Job No desc' THEN JobNo END DESC,
			CASE @orderBy WHEN 'Vehicle No asc' THEN GEN_VehicleNo END ASC,
			CASE @orderBy WHEN 'Vehicle No desc' THEN GEN_VehicleNo END DESC,
			CASE @orderBy WHEN 'TO Code asc' THEN Code END ASC,
			CASE @orderBy WHEN 'TO Code desc' THEN Code END DESC,
			CASE @orderBy WHEN 'ACR asc' THEN OTH_Approx_RepairCost END ASC,
			CASE @orderBy WHEN 'ACR desc' THEN OTH_Approx_RepairCost END DESC,
			CASE @orderBy WHEN 'Claim Processing Branch asc' THEN BranchName END ASC,
			CASE @orderBy WHEN 'Claim Processing Branch desc' THEN BranchName END DESC,
			CASE @orderBy WHEN 'Date of Accident asc' THEN GEN_Acc_Time END ASC,
			CASE @orderBy WHEN 'Date of Accident desc' THEN GEN_Acc_Time END DESC

			OFFSET     @SkipRows ROWS       -- skip 10 rows
			FETCH NEXT @GetRows ROWS ONLY; -- take 10 rows
END
GO

CREATE PROCEDURE [dbo].[GetJobsCount]
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	SET NOCOUNT ON;
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName LIKE '%'+ @TOName+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)			
END
GO

-- ============================================================================



-- ============================================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/02/2017
-- Description:	Updated StoredProcedure GetJobs to filter from BranchId as well
-- ============================================================================


USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetJobs]    Script Date: 02/03/2017 13:03:54 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobs] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,--nvarchar(128),--int
    @EPFNo nvarchar(128),
	@orderBy nvarchar(128),
	@SkipRows int,
	@GetRows int
 -- @StartIndex			INT	= 1,
 -- @pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		;WITH PostCTE AS (
			SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId, ROW_NUMBER() OVER 
						  (	ORDER BY 
							CASE @orderBy WHEN 'Job No asc' THEN JobNo END ASC,
							CASE @orderBy WHEN 'Job No desc' THEN JobNo END DESC,
							CASE @orderBy WHEN 'Vehicle No asc' THEN GEN_VehicleNo END ASC,
							CASE @orderBy WHEN 'Vehicle No desc' THEN GEN_VehicleNo END DESC,
							CASE @orderBy WHEN 'TO Code asc' THEN Code END ASC,
							CASE @orderBy WHEN 'TO Code desc' THEN Code END DESC,
							CASE @orderBy WHEN 'ACR asc' THEN OTH_Approx_RepairCost END ASC,
							CASE @orderBy WHEN 'ACR desc' THEN OTH_Approx_RepairCost END DESC,
							CASE @orderBy WHEN 'Claim Processing Branch asc' THEN BranchName END ASC,
							CASE @orderBy WHEN 'Claim Processing Branch desc' THEN BranchName END DESC,
							CASE @orderBy WHEN 'Date of Accident asc' THEN GEN_Acc_Time END ASC,
							CASE @orderBy WHEN 'Date of Accident desc' THEN GEN_Acc_Time END DESC) AS RowNum,
						  dbo.Branches.BranchName,
						  (SELECT     COUNT(*) AS Expr1
								FROM          dbo.ImageGallery
								WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
						  dbo.Branches.RegionId AS ProcessingRegionId,
							  (SELECT     RegionName AS Expr2
								FROM          dbo.Regions
								WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName LIKE '%'+ @TOName+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)
			--OFFSET     @SkipRows ROWS       -- skip 10 rows
			--FETCH NEXT @GetRows ROWS ONLY; -- take 10 rows
			)
SELECT *
FROM PostCTE
WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)

END
-- ============================================================================

-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/02/2017
-- Description:	Updated StoredProcedure GetJobsCount to filter from BranchId as well
-- ============================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetJobsCount]    Script Date: 02/03/2017 14:27:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobsCount] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
	--int
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
			
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName LIKE '%'+ @TOName+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate) AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)			

END
-- ======================================================================================

-- ======================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 06/02/2017
-- Description:	Updated StoredProcedure SAForms_GetMissingImagesNew to filter 0 column
-- ======================================================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetMissingImagesNew]    Script Date: 02/06/2017 09:16:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SAForms_GetMissingImagesNew] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	END
	
else if(@Flag = -3) /*TO*/
	BEGIN	
	SET NOCOUNT ON;    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
		
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]	
	END	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]	
	END
-- ======================================================================================

-- ======================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 07/02/2017
-- Description:	Creates StoredProcedure [GetOutstandingJobs]
-- ======================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[GetOutstandingJobs]    Script Date: 02/07/2017 08:13:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 06/02/2017
-- Description:	Outstanding Jobs
-- =============================================
CREATE PROCEDURE [dbo].[GetOutstandingJobs] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime
	WITH RECOMPILE	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(Select AssignedJobs.CSRCode,
				AssignedJobs.JobNumber,
				AssignedJobs.VehicleNumber,
				AssignedJobs.AssignedDateTime,
				(SELECT FirstName+' '+LastName FROM dbo.Users AS u WHERE u.Code = CSRCode)AS FullName,
				(SELECT UserId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS UserId,
				(SELECT RegionId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS RegionId,
				ROW_NUMBER() OVER (ORDER BY AssignedJobs.CSRCode) AS RowNum
		 from dbo.AssignedJobs
		 where AssignedDateTime > @DateFrom AND AssignedDateTime <= @DateTo AND
		 dbo.AssignedJobs.JobNumber NOT IN (SELECT JobNo from dbo.Visits))
 )
 SELECT *
 FROM TEMP 
END
-- =============================================

-- ======================================================================================
-- Author:		Suren Manawatta
-- Create date: 06/02/2017
-- Description:	Added some missing permissions
-- ======================================================================================

--Please add following permissions to 'aspnet_Roles' table
--NOTE: This permission and "JobDetailsPrintPreview_HTML" permissions should be available to all users

--Admin: VisitDetailsPrintPreview_HTML
--Engineer: VisitDetailsPrintPreview_HTML
--Audit: VisitDetailsPrintPreview_HTML

-- ======================================================================================






-- ======================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 09/02/2017
-- Release: V3.11.27
-- Description:	Optimized Job Search
-- ======================================================================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <09/02/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobs] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,--nvarchar(128),--int
    @EPFNo nvarchar(128),
	@orderBy nvarchar(128),
	@SkipRows int,
	@GetRows int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		;WITH PostCTE AS (
			SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId, ROW_NUMBER() OVER 
						  (	ORDER BY 
							CASE @orderBy WHEN 'Job No asc' THEN JobNo END ASC,
							CASE @orderBy WHEN 'Job No desc' THEN JobNo END DESC,
							CASE @orderBy WHEN 'Vehicle No asc' THEN GEN_VehicleNo END ASC,
							CASE @orderBy WHEN 'Vehicle No desc' THEN GEN_VehicleNo END DESC,
							CASE @orderBy WHEN 'TO Code asc' THEN Code END ASC,
							CASE @orderBy WHEN 'TO Code desc' THEN Code END DESC,
							CASE @orderBy WHEN 'ACR asc' THEN OTH_Approx_RepairCost END ASC,
							CASE @orderBy WHEN 'ACR desc' THEN OTH_Approx_RepairCost END DESC,
							CASE @orderBy WHEN 'Claim Processing Branch asc' THEN BranchName END ASC,
							CASE @orderBy WHEN 'Claim Processing Branch desc' THEN BranchName END DESC,
							CASE @orderBy WHEN 'Date of Accident asc' THEN GEN_Acc_Time END ASC,
							CASE @orderBy WHEN 'Date of Accident desc' THEN GEN_Acc_Time END DESC) AS RowNum,
						  dbo.Branches.BranchName,
						  (SELECT     COUNT(*) AS Expr1
								FROM          dbo.ImageGallery
								WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
						  dbo.Branches.RegionId AS ProcessingRegionId,
							  (SELECT     RegionName AS Expr2
								FROM          dbo.Regions
								WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo LIKE '%'+ @VehicleNo + '%') AND
							  (@TOCode IS NULL OR dbo.Users.Code LIKE '%'+ @TOCode+ '%') AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo LIKE '%'+ @EPFNo + '%') AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)
			
			)
SELECT *
FROM PostCTE
WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
	

END
-- ====================================================================================================================================================================================

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <09/02/2017>
-- Description:	GetJobsCount
-- =============================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetJobsCount] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
	--int
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo LIKE '%'+ @VehicleNo + '%') AND
							  (@TOCode IS NULL OR dbo.Users.Code LIKE '%'+ @TOCode+ '%') AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo LIKE '%'+ @EPFNo + '%') AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)		
END

-- ====================================================================================================================================

-- ==========================================================================================
-- Author:		<Uthpala Pathirana>
-- Create date: <13/02/2017>
-- Description:	Optimization of performance report
-- ==========================================================================================

USE [ClaimsOne]
GO

/****** Object:  StoredProcedure [dbo].[GetTOPerformance]    Script Date: 02/13/2017 12:58:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 13/02/2017
-- Description:	Obtain Performance Data
-- =============================================
CREATE PROCEDURE [dbo].[GetTOPerformance] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(Select *
		 from dbo.vw_TO_Performance AS t
		 where AssignedDate > @DateFrom AND CompletedDate <= @DateTo 
		 AND 
		 (@TOCode= -1 OR t.TOCode = @TOCode)
		 AND (@RegionCode = -1 OR t.RegionId = @RegionCode)
		 )
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END


GO
-- =============================================================
-- Author:		Uthpala Pathirana
-- Create date: 16/02/2017
-- Description:	Outstanding Jobs modified for a Bug Fix
-- =============================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetOutstandingJobs]    Script Date: 02/16/2017 15:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 06/02/2017
-- Description:	Outstanding Jobs
-- =============================================
ALTER PROCEDURE [dbo].[GetOutstandingJobs] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime
	--@SkipRows int,
	--@GetRows int
	--WITH RECOMPILE
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(Select AssignedJobs.CSRCode,
				AssignedJobs.JobNumber,
				AssignedJobs.VehicleNumber,
				AssignedJobs.AssignedDateTime,
				(SELECT FirstName+' '+LastName FROM dbo.Users AS u WHERE u.Code = CSRCode)AS FullName,
				(SELECT UserId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS UserId,
				(SELECT RegionId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS RegionId,
				ROW_NUMBER() OVER (ORDER BY AssignedJobs.CSRCode) AS RowNum
		 from dbo.AssignedJobs
		 where AssignedDateTime > @DateFrom AND AssignedDateTime <= @DateTo AND
		 dbo.AssignedJobs.JobNumber NOT IN (SELECT JobNo from dbo.Visits))
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END

-- ======================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 28/02/2017
-- Release: V3.11.28
-- Description:	Optimized Onsite Estimation
-- ======================================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimation]    Script Date: 02/27/2017 08:32:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	For the case of displaying TO list in onsite estimation report
-- ============================================================================
ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimation] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@SkipRows int,
	@GetRows int,
	@RowCount int OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
if(@RegionId = -1)
	if(@UserId = -1)
	
		-- All regions all TOs
		
			SELECT
				(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
				(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
				(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
				(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
				COUNT(*) AS TotalJobs,
				(SELECT count(*) 
				FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
						AND v.GEN_TimeReported <= @DateTo 
						AND v.UserId= j.UserId
						--AND v.ProcessingRegionId=j.ProcessingRegionId 
						AND v.OTH_SiteEstimation=1) 
					AS EstimatedJobs,
				
				CONVERT(DECIMAL(16,2),
					(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
										from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										where v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId= j.UserId
											AND v.ProcessingRegionId=j.ProcessingRegionId 
											AND v.OTH_SiteEstimation=1))*100.0
					/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
										FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId= j.UserId
											AND v.ProcessingRegionId=j.ProcessingRegionId )),0)))
				AS Ratio
					
		FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
		WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
		GROUP BY UserId,j.ProcessingRegionId
		ORDER BY Ratio DESC
		OFFSET     @SkipRows ROWS       
		FETCH NEXT @GetRows ROWS ONLY 
	
	else
		-- All regions, specific TO
		
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId,j.ProcessingRegionId
	ORDER BY Ratio DESC
		OFFSET     @SkipRows ROWS       
		FETCH NEXT @GetRows ROWS ONLY 
else
	
	if(@UserId = -1)
	-- Specific region all TOs in that region
	
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId
					AND v.ProcessingRegionId= @RegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId
										AND v.ProcessingRegionId= @RegionId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo AND j.ProcessingRegionId= @RegionId
	GROUP BY UserId,j.ProcessingRegionId
	ORDER BY Ratio DESC
		OFFSET     @SkipRows ROWS       
		FETCH NEXT @GetRows ROWS ONLY 
	
	else
		-- Specific region specific TO
		
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId
					AND j.ProcessingRegionId = @RegionId
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND j.ProcessingRegionId = @RegionId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND j.ProcessingRegionId = @RegionId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
		AND j.ProcessingRegionId = @RegionId
	GROUP BY UserId,j.ProcessingRegionId
	ORDER BY Ratio DESC
		OFFSET     @SkipRows ROWS       
		FETCH NEXT @GetRows ROWS ONLY 
	
END

SELECT @RowCount= @@ROWCOUNT;
-- ============================================================================



USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationCount]    Script Date: 02/27/2017 08:34:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	For the case of displaying TO list in onsite estimation report
-- ============================================================================

CREATE PROCEDURE [dbo].[SAForms_GetOnsiteEstimationCount] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@RowCount int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
if(@RegionId = -1)
	if(@UserId = -1)
	
		-- All regions all TOs
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId
					--AND v.ProcessingRegionId=j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId )),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
	GROUP BY UserId,j.ProcessingRegionId
	
	else
		-- All regions, specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId,j.ProcessingRegionId
else
	
	if(@UserId = -1)
	-- Specific region all TOs in that region
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
			WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId
					AND v.ProcessingRegionId= @RegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									where v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
									WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.ProcessingRegionId=j.ProcessingRegionId
										AND v.ProcessingRegionId= @RegionId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo AND j.ProcessingRegionId= @RegionId
	GROUP BY UserId,j.ProcessingRegionId
	
	else
		-- Specific region specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			COUNT(*) AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
				WHERE v.GEN_TimeReported >= @DateFrom 
					AND v.GEN_TimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId
					AND j.ProcessingRegionId = @RegionId
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
											AND v.GEN_TimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND j.ProcessingRegionId = @RegionId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] v 
										WHERE v.GEN_TimeReported >= @DateFrom 
										AND v.GEN_TimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND j.ProcessingRegionId = @RegionId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_General] AS j
	WHERE j.CreatedDate > @DateFrom 
		AND j.CreatedDate <= @DateTo 
		AND j.UserId=@UserId
		AND j.ProcessingRegionId = @RegionId
	GROUP BY UserId,j.ProcessingRegionId
	
	
	
END

SELECT @RowCount= @@ROWCOUNT;

-- ============================================================================

USE [ClaimsOne]
GO

/****** Object:  StoredProcedure [dbo].[GetPerformanceHours]    Script Date: 02/28/2017 08:36:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 27/02/2017
-- Description:	Get a list with hours spent fo the job
-- =============================================
CREATE PROCEDURE [dbo].[GetPerformanceHours]
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) UserId FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserCode ,
				(SELECT top(1) AssignedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS AssignedDate ,
				(SELECT top(1) CompletedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS CompletedDate ,
				(SELECT top(1) JobNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS JobNo ,
				(SELECT top(1) VehicleNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS VehicleNo ,
				(SELECT (dbo.WorkTime(AssignedDate,CompletedDate)/60)) AS HRSSpent
				
		FROM dbo.vw_TO_Performance AS j
		WHERE (AssignedDate > @DateFrom AND CompletedDate <= @DateTo
				AND 
		 (@TOCode= -1 OR j.TOCode = @TOCode)
		 AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		 )
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode,AssignedDate,CompletedDate,JobNo,VehicleNo
END


GO

-- =========================================================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetTOPerformance]    Script Date: 02/28/2017 08:37:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 13/02/2017
-- Description:	Obtain Performance Data with total number
-- ===========================================================================
ALTER PROCEDURE [dbo].[GetTOPerformance] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		SELECT
				(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionId ,
				(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionName ,
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) TOCode FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS UserCode ,
				(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserEPFNo ,
				COUNT(AssignedDate) AS TotalNoOfJobs
				
		FROM dbo.vw_TO_Performance AS j
		WHERE (AssignedDate > @DateFrom AND CompletedDate <= @DateTo
				AND 
		 (@TOCode= -1 OR j.TOCode = @TOCode)
		 AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		 )
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END

-- =========================================================================================================

USE [ClaimsOne]
GO

/****** Object:  StoredProcedure [dbo].[GetUserCount]    Script Date: 02/28/2017 15:50:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <28/02/2017>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[GetUserCount] 
	-- Add the parameters for the stored procedure here
	@CurrentUser int,
	@RoleName nvarchar(128),
	@RoleId uniqueidentifier,
	@Username nvarchar(128),
	@FirstName nvarchar(128),
	@LastName nvarchar(128),
	@Email nvarchar(128),
	@UserRole nvarchar(128),
	@Branch nvarchar(128),
	@CSRCode nvarchar(128)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
    -- Insert statements for procedure here
		
			SELECT     COUNT(dbo.vw_UserDetails.UserId) AS TotalUserCount
			FROM        [dbo].[vw_UserDetails]
			where IsDeleted <> '1'
			AND UserId <> @CurrentUser
			AND (@RoleName = 'All' OR RoleName = @RoleName)
			AND (@RoleId IS NULL OR RoleId <> @RoleId)	 --manager won't see other managers 
			
			AND ((@Username IS NULL OR UserName LIKE '%'+ @Username + '%') 
			OR (@FirstName IS NULL OR FirstName LIKE '%'+ @FirstName + '%')
			OR (@LastName IS NULL OR LastName LIKE '%'+ @LastName + '%') 
			OR (@Email IS NULL OR PrimaryEmail LIKE '%'+ @Email + '%') 
			OR (@UserRole IS NULL OR RoleName LIKE '%'+ @UserRole + '%')
			OR (@Branch IS NULL OR BranchName LIKE '%'+ @Branch + '%') 
			OR (@CSRCode IS NULL OR Code LIKE '%'+ @CSRCode + '%'))

END

GO

-- =========================================================================================================
USE [ClaimsOne]
GO

/****** Object:  StoredProcedure [dbo].[GetUsers]    Script Date: 02/28/2017 15:51:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <08/02/2017>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[GetUsers] 
	-- Add the parameters for the stored procedure here
	@CurrentUser int,
	@RoleName nvarchar(128),
	@RoleId uniqueidentifier,
	@Username nvarchar(128),
	@FirstName nvarchar(128),
	@LastName nvarchar(128),
	@Email nvarchar(128),
	@UserRole nvarchar(128),
	@Branch nvarchar(128),
	@CSRCode nvarchar(128),
	@OrderBy nvarchar(128),
	@SkipRows int,
	@GetRows int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		
    -- Insert statements for procedure here
		;WITH PostCTE AS (
			SELECT    *,ROW_NUMBER() OVER 
						  (	ORDER BY 
							CASE @orderBy WHEN '0 asc' THEN Code END ASC,
							CASE @orderBy WHEN '0 desc' THEN Code END DESC,
							CASE @orderBy WHEN '1 asc' THEN UserName END ASC,
							CASE @orderBy WHEN '1 desc' THEN UserName END DESC,
							CASE @orderBy WHEN '2 asc' THEN FirstName END ASC,
							CASE @orderBy WHEN '2 desc' THEN FirstName END DESC,
							CASE @orderBy WHEN '3 asc' THEN LastName END ASC,
							CASE @orderBy WHEN '3 desc' THEN LastName END DESC,
							CASE @orderBy WHEN '4 asc' THEN PrimaryEmail END ASC,
							CASE @orderBy WHEN '4 desc' THEN PrimaryEmail END DESC,
							CASE @orderBy WHEN '5 asc' THEN RoleName END ASC,
							CASE @orderBy WHEN '5 desc' THEN RoleName END DESC,
							CASE @orderBy WHEN '6 asc' THEN BranchName END ASC,
							CASE @orderBy WHEN '6 desc' THEN BranchName END DESC
						  ) AS RowNum
						  
						  
			FROM        [dbo].[vw_UserDetails] As v
			where IsDeleted <> '1'
			AND UserId <> @CurrentUser
			AND (@RoleName = 'All' OR RoleName = @RoleName)
			AND (@RoleId IS NULL OR RoleId <> @RoleId)	 --manager won't see other managers 
			
			AND((@Username IS NULL OR UserName LIKE '%'+ @Username + '%') 
			OR (@FirstName IS NULL OR FirstName LIKE '%'+ @FirstName + '%')
			OR (@LastName IS NULL OR LastName LIKE '%'+ @LastName + '%') 
			OR (@Email IS NULL OR PrimaryEmail LIKE '%'+ @Email + '%') 
			OR (@UserRole IS NULL OR RoleName LIKE '%'+ @UserRole + '%')
			OR (@Branch IS NULL OR BranchName LIKE '%'+ @Branch + '%') 
			OR (@CSRCode IS NULL OR Code LIKE '%'+ @CSRCode + '%'))
			)
SELECT *
FROM PostCTE
WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)

END

GO
-- ===============================================================================================================================================================================
-- ======================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 28/02/2017
-- Release: V3.11.29
-- Description:	View Record in Job Search and Missing Images Report
-- ======================================================================================

-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/03/2017
-- Description:	Role Permission Updates
-- ===========================================================================

  update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,MissingImagesToExcel_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,VisitDetailsPrintPreview_HTML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='Audit'

    update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PrintVisit_JSON,JobFullPrintPreview_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='Claim Processing Officer'

    update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,VisitDetailsPrintPreview_HTML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='Engineer'

    update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='Management'

    update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AppManagement_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,VisitDetailsPrintPreview_HTML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='System Administrator'

    update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,UpdateProfile_HTML,AddJob_XML,GetImageById_XML,GetVisitDetailsAjaxHandler_XML,AddVisit_XML,UploadImage_XML,PossibleDR_HTML,DamagedItems_HTML,AdvancedSearchAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,GetCommentsByJobNo_XML,GetJobDetailsAjaxHandler_XML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintRecord_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReports_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationToExcel_HTML,OutstandingSAToExcel_HTML,TOPerformanceToExcel_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OutstandingSAPrintPreview_HTML,TOPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationToExcel_HTML,SearchByVehicleNo_XML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='Technical Officer'

    update [ClaimsOne].[dbo].[aspnet_Roles]
  set [Description]='LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UpdateProfile_HTML,AdvancedSearchResultPrintPreview_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PrintVisit_JSON,JobFullPrintPreview_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,JobWithImagesPrintPreview_HTML'
  where [RoleName]='Temp Printing'

  -- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================

  -- ======================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 28/02/2017
-- Release: V3.11.30
-- Description:	Changed filteration from UserId to TOCode and removed FETCH/OFFSET
-- ======================================================================================

-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 06/03/2017
-- Description:	SAForms_GetJobsWithNoImages to display jobs with no images
-- ===========================================================================


  USE [ClaimsOne]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetJobsWithNoImages]    Script Date: 03/06/2017 15:38:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SAForms_GetJobsWithNoImages] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and v.CreatedDate >= @BeginDate AND v.CreatedDate <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END

GO
-- ===========================================================================
-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 10/03/2017
-- Description:	Bug Fix
-- ===========================================================================


USE [ClaimsOne]
GO

/****** Object:  View [dbo].[vw_TO_Performance]    Script Date: 03/10/2017 12:57:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_TO_Performance]
AS
SELECT        v.CreatedBy AS TOCode, u.FirstName, u.LastName, u.EPFNo, s.GEN_VehicleNo AS VehicleNo, v.JobNo, 
			(CASE
			WHEN s.GEN_OriginalTimeReported IS NULL THEN s.GEN_TimeReported
			ELSE s.GEN_OriginalTimeReported
			END) AS AssignedDate, 
			s.GEN_TimeReported AS SecondaryAssignedDate,
            v.CreatedDate AS CompletedDate, dbo.Regions.RegionName, dbo.Regions.RegionId
FROM            dbo.Visits AS v INNER JOIN
                         dbo.SAForm_level1 AS s ON v.VisitId = s.VisitId INNER JOIN
                         dbo.Users AS u ON v.CreatedBy = u.UserId INNER JOIN
                         dbo.Regions ON u.RegionId = dbo.Regions.RegionId

GO

-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 10/03/2017
-- Description:	Bug Fix
-- ===========================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetTOPerformance]    Script Date: 03/10/2017 12:35:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 13/02/2017
-- Description:	StoredProcedure [dbo].[GetTOPerformance] 
-- ===========================================================================
ALTER PROCEDURE [dbo].[GetTOPerformance] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    ;WITH TEMP AS(
		SELECT
				(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionId ,
				(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionName ,
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) TOCode FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS UserCode ,
				(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS Code ,
				(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserEPFNo ,
				COUNT(AssignedDate) AS TotalNoOfJobs
				
		FROM dbo.vw_TO_Performance AS j
		WHERE 
			(CASE (AssignedDate)
				WHEN NULL THEN AssignedDate 
				ELSE SecondaryAssignedDate
				END)  > @DateFrom AND
			CompletedDate <= @DateTo AND 
			(@TOCode= -1 OR j.TOCode = @TOCode)
			AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
END

-- ========================================================================
-- Author:		<Uthpala Pathirana>
-- Create date: <13/03/2017>
-- Description:	Updated the query to search by TO Name
-- ========================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetJobsCount]    Script Date: 03/13/2017 11:32:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobsCount] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
	--int
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)			
		--TODO: Filter By Branch

END


-- ========================================================================
-- Author:		<Uthpala Pathirana>
-- Create date: <13/03/2017>
-- Description:	Updated the query
-- ========================================================================

USE [ClaimsOne]
GO

/****** Object:  View [dbo].[vw_OutstandingJobs]    Script Date: 03/13/2017 12:07:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [dbo].[vw_OutstandingJobs]
AS
SELECT        a.CSRFirstName, a.CSRLastName, a.CSRCode, a.VehicleNumber, a.JobNumber, a.AssignedDateTime, dbo.Regions.RegionName
FROM            dbo.Visits AS v INNER JOIN
                         dbo.vw_AssignedJobs AS a ON v.JobNo <> a.JobNumber INNER JOIN
                         dbo.Users ON a.CSRCode = dbo.Users.Code INNER JOIN
                         dbo.Regions ON dbo.Users.RegionId = dbo.Regions.RegionId
GO


-- ==============================================================================================================================
-- ========================================================================
-- Author:		<Uthpala Pathirana>
-- Create date: <16/03/2017>
-- Description:	Removed FETCH/OFFSET (needs to fix sorting)
-- ========================================================================
USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimation]    Script Date: 03/16/2017 16:45:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	For the case of displaying TO list in onsite estimation report
-- ============================================================================
ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimation] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@SkipRows int,
	@GetRows int,
	@RowCount int OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	

	
;WITH PostCTE AS (
SELECT
					(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
					(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
					(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
					(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
					(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
					
					COUNT(*) AS TotalJobs,
					(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_General] v 
					WHERE v.GEN_TimeReported >= @DateFrom
							AND v.GEN_TimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.ProcessingRegionId= @RegionId )
							AND v.OTH_SiteEstimation=1) 
						AS EstimatedJobs,
					
					CONVERT(DECIMAL(16,2),
						(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											from [ClaimsOne].[dbo].[vw_SAForm_General] v 
											where v.GEN_TimeReported >= @DateFrom  
												AND v.GEN_TimeReported <= @DateTo
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND (@RegionId = '-1' OR v.ProcessingRegionId= @RegionId )
												AND v.ProcessingRegionId=j.ProcessingRegionId 
												AND v.OTH_SiteEstimation=1))*100.0
						/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											FROM [ClaimsOne].[dbo].[vw_SAForm_General] v 
											WHERE v.GEN_TimeReported >= @DateFrom 
												AND v.GEN_TimeReported <= @DateTo 
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND v.ProcessingRegionId=j.ProcessingRegionId
												AND (@RegionId = '-1' OR v.ProcessingRegionId= @RegionId ) )),0)))
					AS Ratio,
					ROW_NUMBER() OVER 
							  (	ORDER BY EPFNo DESC) AS RowNum
						
			FROM [ClaimsOne].[dbo].[vw_SAForm_General] AS j
			WHERE j.CreatedDate > @DateFrom AND j.CreatedDate <= @DateTo
					AND (@UserId= '-1' OR j.UserId=@UserId )
					AND (@RegionId = '-1' OR j.ProcessingRegionId= @RegionId )
			GROUP BY UserId,j.ProcessingRegionId,EPFNo
			--ORDER BY Ratio DESC
			)


SELECT *
FROM PostCTE
WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows) ORDER BY Ratio DESC
END


SELECT @RowCount= @@ROWCOUNT;

-- ==============================================================================================================================
-- ========================================================================
-- Author:		<Uthpala Pathirana>
-- Create date: <17/03/2017>
-- Description:	WorkTime
-- ========================================================================

USE [ClaimsOne]
GO

/****** Object:  UserDefinedFunction [dbo].[WorkTime]    Script Date: 03/17/2017 10:53:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[WorkTime] 
(
    @StartDate DATETIME,
    @FinishDate DATETIME
)
RETURNS BIGINT
AS
BEGIN
    DECLARE @Temp BIGINT
    SET @Temp=0

    DECLARE @FirstDay DATE
    SET @FirstDay = CONVERT(DATE, @StartDate, 112)

    DECLARE @LastDay DATE
    SET @LastDay = CONVERT(DATE, @FinishDate, 112)

    DECLARE @StartTime TIME
    SET @StartTime = CONVERT(TIME, @StartDate)

    DECLARE @FinishTime TIME
    SET @FinishTime = CONVERT(TIME, @FinishDate)

    DECLARE @WorkStart TIME
    SET @WorkStart = '09:00'

    DECLARE @WorkFinish TIME
    SET @WorkFinish = '17:00'

    DECLARE @DailyWorkTime BIGINT
    SET @DailyWorkTime = DATEDIFF(MINUTE, @WorkStart, @WorkFinish)

    IF (@StartTime<@WorkStart)
    BEGIN
        SET @StartTime = @WorkStart
    END
    IF (@FinishTime>@WorkFinish)
    BEGIN
        SET @FinishTime=@WorkFinish
    END
    IF (@FinishTime<@WorkStart)
    BEGIN
        SET @FinishTime=@WorkStart
    END
    IF (@StartTime>@WorkFinish)
    BEGIN
        SET @StartTime = @WorkFinish
    END

    DECLARE @CurrentDate DATE
    SET @CurrentDate = @FirstDay
    DECLARE @LastDate DATE
    SET @LastDate = @LastDay

    WHILE(@CurrentDate<=@LastDate)
    BEGIN       
        IF (DATEPART(dw, @CurrentDate)!=1 AND DATEPART(dw, @CurrentDate)!=7)
        BEGIN
            IF (@CurrentDate!=@FirstDay) AND (@CurrentDate!=@LastDay)
            BEGIN
                SET @Temp = @Temp + @DailyWorkTime
            END
            --IF it starts at startdate and it finishes not this date find diff between work finish and start as minutes
            ELSE IF (@CurrentDate=@FirstDay) AND (@CurrentDate!=@LastDay)
            BEGIN
                SET @Temp = @Temp + DATEDIFF(MINUTE, @StartTime, @WorkFinish)
            END

            ELSE IF (@CurrentDate!=@FirstDay) AND (@CurrentDate=@LastDay)
            BEGIN
                SET @Temp = @Temp + DATEDIFF(MINUTE, @WorkStart, @FinishTime)
            END
            --IF it starts and finishes in the same date
            ELSE IF (@CurrentDate=@FirstDay) AND (@CurrentDate=@LastDay)
            BEGIN
                SET @Temp = DATEDIFF(MINUTE, @StartTime, @FinishTime)
            END
        END
        SET @CurrentDate = DATEADD(day, 1, @CurrentDate)
    END

    -- Return the result of the function
    IF @Temp<0
    BEGIN
        SET @Temp=0
    END
    RETURN @Temp

END
GO

-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================

-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 21/03/2017
-- Release: V3.11.31 - Updated Version
-- Description:	Sorting in OnSite Estimation and DateFrom and DateTo to searched on the mentioned day itself
-- ============================================================================================================

USE [ClaimsOne]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_OnStEstDataToTable]    Script Date: 03/20/2017 16:50:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =================================================================
-- Author:		Uthpala Pathirana
-- Create date: 16/03/2017
-- Description:	Gets all onsite estimation data prior to sorting
-- =================================================================
CREATE FUNCTION [dbo].[fn_OnStEstDataToTable]  
(
	-- Add the parameters for the function here
	@DateFrom datetime, 
	@DateTo datetime,
	@RegionId int,
	@UserId int,
	@SkipRows int,
	@GetRows int
)
RETURNS @tableItems TABLE (
	
	RegionId int,
	RegionName VARCHAR(100),
	FullName VARCHAR(100),
	TOCode NVARCHAR(7) NOT NULL ,
	EPFNo NVARCHAR(5) NOT NULL,
	TotalJobs int,
	EstimatedJobs int,
	Ratio DECIMAL(16,2)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	INSERT INTO @tableItems (RegionId, RegionName, FullName, TOCode, EPFNo, TotalJobs, EstimatedJobs, Ratio)
	SELECT
					(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionId ,
					(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.ProcessingRegionId) AS RegionName ,
					(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE Code=j.Code) AS FullName ,
					(SELECT top(1) Code FROM  dbo.Users AS u WHERE Code=j.Code) AS UserCode ,
					(SELECT top(1) EPFNo FROM dbo.Users AS u WHERE Code=j.Code) AS UserEPFNo ,
					
					COUNT(*) AS TotalJobs,
					(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_General] v 
					WHERE v.GEN_TimeReported >= @DateFrom
							AND v.GEN_TimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.ProcessingRegionId= @RegionId )
							AND v.OTH_SiteEstimation=1) 
						AS EstimatedJobs,
					
					CONVERT(DECIMAL(16,2),
						(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											from [ClaimsOne].[dbo].[vw_SAForm_General] v 
											where v.GEN_TimeReported >= @DateFrom  
												AND v.GEN_TimeReported <= @DateTo
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND (@RegionId = '-1' OR v.ProcessingRegionId= @RegionId )
												AND v.ProcessingRegionId=j.ProcessingRegionId 
												AND v.OTH_SiteEstimation=1))*100.0
						/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											FROM [ClaimsOne].[dbo].[vw_SAForm_General] v 
											WHERE v.GEN_TimeReported >= @DateFrom 
												AND v.GEN_TimeReported <= @DateTo 
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND v.ProcessingRegionId=j.ProcessingRegionId
												AND (@RegionId = '-1' OR v.ProcessingRegionId= @RegionId ) )),0)))
					AS Ratio
						
			FROM [ClaimsOne].[dbo].[vw_SAForm_General] AS j
			WHERE j.CreatedDate >= @DateFrom AND j.CreatedDate <= @DateTo
					AND (@UserId= '-1' OR j.UserId=@UserId )
					AND (@RegionId = '-1' OR j.ProcessingRegionId= @RegionId )
			GROUP BY UserId,j.ProcessingRegionId,EPFNo,Code
			ORDER BY Ratio DESC
	RETURN 
	
END


GO

-- ========================================================================
-- Author:		<Uthpala Pathirana>
-- Create date: <21/03/2017>
-- Description:	Updated [SAForms_GetOnsiteEstimation]
-- ========================================================================
USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimation]    Script Date: 03/20/2017 16:41:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	For the case of displaying TO list in onsite estimation report
-- ============================================================================
ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimation] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@SkipRows int,
	@GetRows int,
	@RowCount int OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	WITH PostCTE AS (
		SELECT *,ROW_NUMBER() OVER(ORDER BY Ratio DESC) AS RowIndex FROM [ClaimsOne].[dbo].[fn_OnStEstDataToTable](@DateFrom,@DateTo,@RegionId,@UserId,@SkipRows,@GetRows)
	)

SELECT *
FROM PostCTE
WHERE RowIndex > @SkipRows AND RowIndex <= (@SkipRows+@GetRows)
END

SELECT @RowCount= @@ROWCOUNT;


-- ======================================================================================================================================================================================================================================================================================================================================================================
-- =================================================================
-- Author:		Uthpala Pathirana
-- Create date: 21/03/2017
-- Description:	Date 'From' and 'To' on the entire web need to count both dates
-- =================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetTOPerformance]    Script Date: 03/21/2017 11:43:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 13/02/2017
-- Description:	Obtain Performance Data with total number
-- ===========================================================================
ALTER PROCEDURE [dbo].[GetTOPerformance] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		SELECT
				(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionId ,
				(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionName ,
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) TOCode FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS UserCode ,
				(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS Code ,
				(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserEPFNo ,
				COUNT(AssignedDate) AS TotalNoOfJobs
				
		FROM dbo.vw_TO_Performance AS j
		WHERE 
			(CASE (AssignedDate)
				WHEN NULL THEN AssignedDate 
				ELSE SecondaryAssignedDate
				END)  >= @DateFrom AND
			CompletedDate <= @DateTo AND 
			(@TOCode= -1 OR j.TOCode = @TOCode)
			AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END
-- ===========================================================================
USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetPerformanceHours]    Script Date: 03/21/2017 12:05:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 27/02/2017
-- Description:	Get a list with hours spent fo the job
-- =============================================
ALTER PROCEDURE [dbo].[GetPerformanceHours]
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) UserId FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserCode ,
				(SELECT top(1) AssignedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS AssignedDate ,
				(SELECT top(1) CompletedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS CompletedDate ,
				(SELECT top(1) JobNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS JobNo ,
				(SELECT top(1) VehicleNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS VehicleNo ,
				(SELECT (dbo.WorkTime(AssignedDate,CompletedDate)/60)) AS HRSSpent
				
		FROM dbo.vw_TO_Performance AS j
		WHERE (AssignedDate >= @DateFrom AND CompletedDate <= @DateTo
				AND 
		 (@TOCode= -1 OR j.TOCode = @TOCode)
		 AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		 )
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode,AssignedDate,CompletedDate,JobNo,VehicleNo
END
-- =====================================================================================================================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetOutstandingJobs]    Script Date: 03/21/2017 12:23:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 06/02/2017
-- Description:	Outstanding Jobs
-- =============================================
ALTER PROCEDURE [dbo].[GetOutstandingJobs] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime
	--@SkipRows int,
	--@GetRows int
	--WITH RECOMPILE
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(Select AssignedJobs.CSRCode,
				AssignedJobs.JobNumber,
				AssignedJobs.VehicleNumber,
				AssignedJobs.AssignedDateTime,
				(SELECT FirstName+' '+LastName FROM dbo.Users AS u WHERE u.Code = CSRCode)AS FullName,
				(SELECT UserId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS UserId,
				(SELECT RegionId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS RegionId,
				ROW_NUMBER() OVER (ORDER BY AssignedJobs.CSRCode) AS RowNum
		 from dbo.AssignedJobs
		 where AssignedDateTime >= @DateFrom AND AssignedDateTime <= @DateTo AND
		 dbo.AssignedJobs.JobNumber NOT IN (SELECT JobNo from dbo.Visits))
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END

-- =====================================================================================================================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[IronLogger_AuditLogs_GetLogs]    Script Date: 03/21/2017 14:05:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[IronLogger_AuditLogs_GetLogs]
        @ModuleName			varchar(100),
        @ActionName			varchar(100),
        @AccessType			nvarchar(100),
        @AccessIP			nvarchar(200),
        @UserName			nvarchar(100),
        --@RefID				int,
        @EventStatus		varchar(25),
        @DateFrom			datetime,
        @DateTo				datetime = NULL,
        @Description		varchar(MAX),
        @Params				nvarchar(MAX),
        
        @ParaCol1			nvarchar(100) = '',
        @ParaCol2			nvarchar(100) = '',
        @ParaCol3			nvarchar(100) = '',
        @ParaCol4			nvarchar(100) = '',
        @ParaCol5			nvarchar(100) = '',
        @ParaCol6			nvarchar(100) = '',
        @ParaCol7			nvarchar(100) = '',
        @ParaCol8			nvarchar(100) = '',
        @ParaCol9			nvarchar(100) = '',
        @ParaCol10			nvarchar(100) = '',
        
		@orderByCol			VARCHAR(50),		
		@isAscending		BIT,
		@StartIndex			INT	= 1,
		@pageSize			INT	= 10,
		@rowCount			INT OUTPUT 
AS
BEGIN

IF @DateTo IS NULL
	SET @DateTo = GETDATE()

DECLARE @T TABLE(
	EventId int, 
	Module varchar(100), 
	[Action] varchar(100), 
	AccessType nvarchar(100), 
	AccessIP nvarchar(200), 
	UserName nvarchar(100), 
	RefID int, 
	EventStatus varchar(25), 
	[Date] datetime, 
	[Description] varchar(MAX), 
	Params nvarchar(MAX),
    ParaCol1 nvarchar(100),
    ParaCol2 nvarchar(100),
    ParaCol3 nvarchar(100),
    ParaCol4 nvarchar(100),
    ParaCol5 nvarchar(100),
    ParaCol6 nvarchar(100),
    ParaCol7 nvarchar(100),
    ParaCol8 nvarchar(100),
    ParaCol9 nvarchar(100),
    ParaCol10 nvarchar(100)
	)

DECLARE @logParams LogParams
INSERT INTO @logParams SELECT EventId,Params FROM dbo.AuditLogs

INSERT INTO @T SELECT 
	AuditLogs.EventId, 
	AuditLogs.Module, 
	AuditLogs.[Action], 
	AuditLogs.AccessType, 
	AuditLogs.AccessIP, 
	AuditLogs.UserName, 
	AuditLogs.RefId, 
	AuditLogs.EventStatus, 
	AuditLogs.[Date], 
	AuditLogs.[Description], 
	AuditLogs.Params, 
	fn_StringToTable_1.Col1, 
	fn_StringToTable_1.Col2, 
	fn_StringToTable_1.Col3, 
	fn_StringToTable_1.Col4, 
	fn_StringToTable_1.Col5, 
	fn_StringToTable_1.Col6, 
	fn_StringToTable_1.Col7, 
	fn_StringToTable_1.Col8, 
	fn_StringToTable_1.Col9, 
	fn_StringToTable_1.Col10
	FROM dbo.fn_StringToTable(@logParams) AS fn_StringToTable_1 INNER JOIN AuditLogs ON fn_StringToTable_1.LogID = AuditLogs.EventId
    WHERE Module LIKE @ModuleName + '%' 
          AND [Action] LIKE @ActionName + '%' 
          AND AccessType LIKE @AccessType + '%' 
          AND AccessIP LIKE @AccessIP + '%' 
          AND UserName LIKE @UserName + '%' 
          AND EventStatus LIKE @EventStatus + '%' 
          AND [Date] >= @DateFrom
          AND [Date] <= @DateTo
          AND [Description] LIKE @Description + '%'
          AND Col1 LIKE @ParaCol1 + '%'
          AND Col2 LIKE @ParaCol2 + '%'
          AND Col3 LIKE @ParaCol3 + '%'
          AND Col4 LIKE @ParaCol4 + '%'
          AND Col5 LIKE @ParaCol5 + '%'
          AND Col6 LIKE @ParaCol6 + '%'
          /* AND Col7 LIKE @ParaCol7 + '%'*/
            AND Col7 LIKE 
          CASE WHEN (@ParaCol7= '') THEN 
			@ParaCol7 + '%'
		  ELSE
			@ParaCol7
		  END
          AND Col8 LIKE 
          CASE WHEN (@ParaCol8= '') THEN 
			@ParaCol8 + '%'
		  ELSE
			@ParaCol8
		  END
         /* AND Col8 = @ParaCol8 VisitId */
          AND Col9 LIKE @ParaCol9 + '%'
          AND Col10 LIKE @ParaCol10 + '%'

SELECT EventId, 
		Module, 
		[Action], 
		AccessType, 
		AccessIP, 
		UserName, 
		RefID, 
		EventStatus, 
		[Date], 
		[Description], 
		Params, 
		ParaCol1, 
		ParaCol2, 
		ParaCol3, 
		ParaCol4, 
		ParaCol5, 
		ParaCol6, 
		ParaCol7, 
		ParaCol8, 
		ParaCol9, 
		ParaCol10
	FROM (SELECT ROW_NUMBER() OVER ( ORDER BY 
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
				WHEN @orderByCol='CSRCode' THEN ParaCol1
				WHEN @orderByCol='BranchName' THEN ParaCol2
				WHEN @orderByCol='RegionName' THEN ParaCol3
				WHEN @orderByCol='EFPNo' THEN ParaCol4
				WHEN @orderByCol='VehicleNo' THEN ParaCol5
				WHEN @orderByCol='JobNo' THEN ParaCol6
				WHEN @orderByCol='InspectionType' THEN ParaCol7
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
				WHEN @orderByCol='CSRCode' THEN ParaCol1
				WHEN @orderByCol='BranchName' THEN ParaCol2
				WHEN @orderByCol='RegionName' THEN ParaCol3
				WHEN @orderByCol='EFPNo' THEN ParaCol4
				WHEN @orderByCol='VehicleNo' THEN ParaCol5
				WHEN @orderByCol='JobNo' THEN ParaCol6
				WHEN @orderByCol='InspectionType' THEN ParaCol7
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
 exec [dbo].[IronLogger_AuditLogs_GetLogs] '','','','','','','2012-03-07 14:15:57.323','2013-04-11 14:15:57.323','','','',Default,Default,Default,'',Default,Default,Default,Default,Default,'Date',1,1,100,@r OUTPUT
SELECT @r
*/
-- ====================================================================================================================================================================

-- =====================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/03/2017
-- Description:	DateFrom and DateTo is searched by the wrong column
-- =====================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetJobsWithNoImages]    Script Date: 03/23/2017 12:03:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SAForms_GetJobsWithNoImages] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and sa.GEN_OriginalTimeReported >= @BeginDate AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and sa.GEN_OriginalTimeReported >= @BeginDate AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and sa.GEN_OriginalTimeReported >= @BeginDate AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END


	
	
-- =====================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/03/2017
-- Description:	DateFrom and DateTo is searched by the wrong column
-- =====================================================================
	
	USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetMissingImagesNew]    Script Date: 03/23/2017 12:41:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SAForms_GetMissingImagesNew] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and sa.GEN_OriginalTimeReported >= @BeginDate AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and sa.GEN_OriginalTimeReported >= @BeginDate AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and sa.GEN_OriginalTimeReported >= @BeginDate AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END

-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================

-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/08/2017
-- Release: V3.11.32 
-- Description:	Bug Fixes & Modifications
-- ============================================================================================================

USE [ClaimsOne]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_OnStEstDataToTable]    Script Date: 08/03/2017 11:53:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		Uthpala Pathirana
-- Create date: 16/03/2017
-- Description:	Gets all onsite estimation data prior to sorting
-- =================================================================
ALTER FUNCTION [dbo].[fn_OnStEstDataToTable]  
(
	-- Add the parameters for the function here
	@DateFrom datetime, 
	@DateTo datetime,
	@RegionId int,
	@UserId int,
	@SkipRows int,
	@GetRows int
)
RETURNS @tableItems TABLE (
	
	RegionId int,
	RegionName VARCHAR(100),
	FullName VARCHAR(100),
	TOCode NVARCHAR(7) NOT NULL ,
	EPFNo NVARCHAR(5) NOT NULL,
	TotalJobs int,
	EstimatedJobs int,
	Ratio DECIMAL(16,2)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	--GEN_OriginalTimeReported = Assigned Date
	INSERT INTO @tableItems (RegionId, RegionName, FullName, TOCode, EPFNo, TotalJobs, EstimatedJobs, Ratio)
	SELECT
					(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
					(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
					(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE Code=j.Code) AS FullName ,
					(SELECT top(1) Code FROM  dbo.Users AS u WHERE Code=j.Code) AS UserCode ,
					(SELECT top(1) EPFNo FROM dbo.Users AS u WHERE Code=j.Code) AS UserEPFNo ,
					
					--COUNT(*) AS TotalJobs,
					(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE v.GEN_OriginalTimeReported >= @DateFrom
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
					(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE v.GEN_OriginalTimeReported >= @DateFrom
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )
							AND v.OTH_SiteEstimation=1) 
						AS EstimatedJobs,
					
					CONVERT(DECIMAL(16,2),
						(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											from [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
											where v.GEN_OriginalTimeReported >= @DateFrom  
												AND v.GEN_OriginalTimeReported <= @DateTo
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND (@RegionId = '-1' OR v.TORegion= @RegionId )
												AND v.TORegion=j.TORegion 
												AND v.OTH_SiteEstimation=1))*100.0
						/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
											WHERE v.GEN_OriginalTimeReported >= @DateFrom 
												AND v.GEN_OriginalTimeReported <= @DateTo 
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND v.TORegion=j.TORegion
												AND (@RegionId = '-1' OR v.TORegion= @RegionId ) )),0)))
					AS Ratio
						
			FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] AS j
			WHERE j.GEN_OriginalTimeReported >= @DateFrom AND j.GEN_OriginalTimeReported <= @DateTo
					AND (@UserId= '-1' OR j.UserId=@UserId )
					AND (@RegionId = '-1' OR j.TORegion= @RegionId )
			GROUP BY UserId,j.TORegion,EPFNo,Code
			ORDER BY Ratio DESC
	RETURN 
	
END



-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/08/2017
-- Description:	Modifications
-- ============================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetJobsCount]    Script Date: 08/03/2017 11:46:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobsCount] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
	--int
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo = @JobNo) AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo = @VehicleNo) AND
							  (@TOCode IS NULL OR dbo.Users.Code = @TOCode) AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo = @EPFNo) AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported <= @EndDate)
							  AND(@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)

END

-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/08/2017
-- Description:	Modifications
-- ============================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationCount]    Script Date: 08/03/2017 12:31:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	Display TO list in onsite estimation report
-- ============================================================================

ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimationCount] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@RowCount int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
if(@RegionId = -1)
	if(@UserId = -1)
	
		-- All regions all TOs
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE v.GEN_OriginalTimeReported >= @DateFrom
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
			WHERE v.GEN_OriginalTimeReported >= @DateFrom 
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId
					--AND v.ProcessingRegionId=j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
									where v.GEN_OriginalTimeReported >= @DateFrom 
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
									WHERE v.GEN_OriginalTimeReported >= @DateFrom 
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion )),0)))
			AS Ratio
				
	FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE j.GEN_OriginalTimeReported >= @DateFrom AND j.GEN_OriginalTimeReported <= @DateTo
	GROUP BY UserId,j.TORegion
	
	else
		-- All regions, specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE v.GEN_OriginalTimeReported >= @DateFrom
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
				WHERE v.GEN_OriginalTimeReported >= @DateFrom 
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE v.GEN_OriginalTimeReported >= @DateFrom 
											AND v.GEN_OriginalTimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE v.GEN_OriginalTimeReported >= @DateFrom 
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE j.GEN_OriginalTimeReported >= @DateFrom 
		AND j.GEN_OriginalTimeReported <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId,j.TORegion
else
	
	if(@UserId = -1)
	-- Specific region all TOs in that region
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE v.GEN_OriginalTimeReported >= @DateFrom
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
			WHERE v.GEN_OriginalTimeReported >= @DateFrom 
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId
					AND v.TORegion= @RegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
									where v.GEN_OriginalTimeReported >= @DateFrom 
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
									WHERE v.GEN_OriginalTimeReported >= @DateFrom 
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion
										AND v.TORegion= @RegionId)),0)))
			AS Ratio
				
	FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE j.GEN_OriginalTimeReported >= @DateFrom AND j.GEN_OriginalTimeReported <= @DateTo AND j.TORegion= @RegionId
	GROUP BY UserId,j.TORegion
	
	else
		-- Specific region specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE v.GEN_OriginalTimeReported >= @DateFrom
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
				WHERE v.GEN_OriginalTimeReported >= @DateFrom 
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId
					AND j.TORegion = @RegionId
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE v.GEN_OriginalTimeReported >= @DateFrom 
											AND v.GEN_OriginalTimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND j.TORegion = @RegionId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE v.GEN_OriginalTimeReported >= @DateFrom 
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND j.TORegion = @RegionId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOne].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE j.GEN_OriginalTimeReported >= @DateFrom 
		AND j.GEN_OriginalTimeReported <= @DateTo 
		AND j.UserId=@UserId
		AND j.TORegion = @RegionId
	GROUP BY UserId,j.TORegion
	
	
	
END

SELECT @RowCount= @@ROWCOUNT;



-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/08/2017
-- Description:	Modifications
-- ============================================================================

USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetJobs]    Script Date: 08/03/2017 16:38:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobs] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,--nvarchar(128),--int
    @EPFNo nvarchar(128),
	@orderBy nvarchar(128),
	@SkipRows int,
	@GetRows int
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		;WITH PostCTE AS (
			SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId, ROW_NUMBER() OVER 
						  (	ORDER BY 
							CASE @orderBy WHEN 'Job No asc' THEN JobNo END ASC,
							CASE @orderBy WHEN 'Job No desc' THEN JobNo END DESC,
							CASE @orderBy WHEN 'Vehicle No asc' THEN GEN_VehicleNo END ASC,
							CASE @orderBy WHEN 'Vehicle No desc' THEN GEN_VehicleNo END DESC,
							CASE @orderBy WHEN 'TO Code asc' THEN Code END ASC,
							CASE @orderBy WHEN 'TO Code desc' THEN Code END DESC,
							CASE @orderBy WHEN 'ACR asc' THEN OTH_Approx_RepairCost END ASC,
							CASE @orderBy WHEN 'ACR desc' THEN OTH_Approx_RepairCost END DESC,
							CASE @orderBy WHEN 'Claim Processing Branch asc' THEN BranchName END ASC,
							CASE @orderBy WHEN 'Claim Processing Branch desc' THEN BranchName END DESC,
							CASE @orderBy WHEN 'Date of Accident asc' THEN GEN_Acc_Time END ASC,
							CASE @orderBy WHEN 'Date of Accident desc' THEN GEN_Acc_Time END DESC) AS RowNum,
						  dbo.Branches.BranchName,
						  (SELECT     COUNT(*) AS Expr1
								FROM          dbo.ImageGallery
								WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
						  dbo.Branches.RegionId AS ProcessingRegionId,
							  (SELECT     RegionName AS Expr2
								FROM          dbo.Regions
								WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo LIKE '%'+ @VehicleNo + '%') AND
							  (@TOCode IS NULL OR dbo.Users.Code LIKE '%'+ @TOCode+ '%') AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo LIKE '%'+ @EPFNo + '%') AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)
			--OFFSET     @SkipRows ROWS       -- skip 10 rows
			--FETCH NEXT @GetRows ROWS ONLY; -- take 10 rows
			)
SELECT *
FROM PostCTE
WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
	

END

-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 03/08/2017
-- Description:	Modifications
-- ============================================================================
USE [ClaimsOne]
GO

/****** Object:  View [dbo].[vw_SAForm_GeneralNew]    Script Date: 08/04/2017 12:07:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_SAForm_GeneralNew]
AS
SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
                      dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
                      dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
                      dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
                      dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
                      dbo.Users.FirstName, dbo.Users.LastName, dbo.Users.RegionId AS TORegion, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
                      dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,
					  (SELECT     COUNT(*) AS Expr1
                            FROM          dbo.ImageGallery
                            WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
                      dbo.Branches.RegionId AS ProcessingRegionId,
                          (SELECT     RegionName AS Expr2
                            FROM          dbo.Regions
                            WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
FROM         dbo.SAForm_level1 INNER JOIN
                      dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
                      dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
                      dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
WHERE     (dbo.Visits.Info1 <> 'd') OR
                      (dbo.Visits.Info1 IS NULL)

GO

-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================

-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 09/08/2017
-- Release: V3.11.32 - Script update
-- Description:	Search by Job Assigned Date & Time  for all the reports and Job Search
-- ============================================================================================================

USE [ClaimsOne]
GO

/****** Object:  View [dbo].[vw_TO_Performance]    Script Date: 08/08/2017 15:07:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_TO_Performance]
AS
SELECT        v.CreatedBy AS TOCode, u.FirstName, u.LastName, u.EPFNo, s.GEN_VehicleNo AS VehicleNo, v.JobNo, 
			--(CASE
			--WHEN s.GEN_OriginalTimeReported IS NULL THEN s.GEN_TimeReported
			--ELSE s.GEN_OriginalTimeReported
			--END) AS AssignedDate,
			s.GEN_OriginalTimeReported AS AssignedDate,
			s.GEN_TimeReported AS SecondaryAssignedDate,
            v.CreatedDate AS CompletedDate, dbo.Regions.RegionName, dbo.Regions.RegionId
FROM            dbo.Visits AS v INNER JOIN
                         dbo.SAForm_level1 AS s ON v.VisitId = s.VisitId INNER JOIN
                         dbo.Users AS u ON v.CreatedBy = u.UserId INNER JOIN
                         dbo.Regions ON u.RegionId = dbo.Regions.RegionId

GO
-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 10/08/2017
-- Release: V3.11.33 - Script update
-- Description: Issue occured from Search by Job Assigned Date & Time
-- ============================================================================================================

UPDATE [ClaimsOne].[dbo].[SAForm_level1]
SET [Info2]='GEN_OriginalTimeReported was null so it is replaced from GEN_TimeReported'
WHERE GEN_OriginalTimeReported is null


UPDATE [ClaimsOne].[dbo].[SAForm_level1]
SET GEN_OriginalTimeReported=[GEN_TimeReported]
WHERE GEN_OriginalTimeReported is null

-- =================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 11/08/2017
-- Release: V3.11.32 - Missed Script
-- Description: Performance report
-- ============================================================================================================
USE [ClaimsOne]
GO
/****** Object:  StoredProcedure [dbo].[GetPerformanceHours]    Script Date: 08/11/2017 15:22:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 27/02/2017
-- Description:	Get a list with hours spent fo the job
-- =============================================
ALTER PROCEDURE [dbo].[GetPerformanceHours]
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) UserId FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserCode ,
				(SELECT top(1) AssignedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS AssignedDate ,
				(SELECT top(1) CompletedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS CompletedDate ,
				(SELECT top(1) JobNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS JobNo ,
				(SELECT top(1) VehicleNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS VehicleNo ,
				(SELECT (dbo.WorkTime(AssignedDate,CompletedDate)/60)) AS HRSSpent
				
		FROM dbo.vw_TO_Performance AS j
		WHERE (AssignedDate > @DateFrom AND AssignedDate <= @DateTo
				AND 
		 (@TOCode= -1 OR j.TOCode = @TOCode)
		 AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		 )
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode,AssignedDate,CompletedDate,JobNo,VehicleNo
END

-- ============================================================================================================

-- =============================================
-- Author:		Suren Manawatta
-- Create date: 01/11/2017
-- Description:	Performance improvements for job search
-- =============================================

--NOTE: Eg query for testing purposes only
--exec [dbo].[GetJobs] @BeginDate='1990-01-01 00:00:00',@EndDate='2017-11-02 15:19:54.3308000',@JobNo=NULL,@VehicleNo=N'KS 2587',@TOCode=NULL,@TOName=NULL,@RegionId=NULL,@BranchId=NULL,@EPFNo=NULL,@orderBy=N'Vehicle No asc',@SkipRows=0,@GetRows=10

CREATE STATISTICS [_dta_stat_2105058535_7_2_3] ON [dbo].[ImageGallery]([IsPrinted], [VisitId], [FieldId])
CREATE STATISTICS [_dta_stat_261575970_10_30_2] ON [dbo].[SAForm_level1]([GEN_Acc_Time], [OTH_ProcessingBranchId], [GEN_VehicleNo])
CREATE STATISTICS [_dta_stat_261575970_2_30_1] ON [dbo].[SAForm_level1]([GEN_VehicleNo], [OTH_ProcessingBranchId], [VisitId])
CREATE STATISTICS [_dta_stat_261575970_10_30_1_2] ON [dbo].[SAForm_level1]([GEN_Acc_Time], [OTH_ProcessingBranchId], [VisitId], [GEN_VehicleNo])
CREATE STATISTICS [_dta_stat_37575172_5_1] ON [dbo].[Users]([Code], [UserId])
CREATE STATISTICS [_dta_stat_37575172_6_12_5] ON [dbo].[Users]([RegionId], [EPFNo], [Code])
CREATE STATISTICS [_dta_stat_37575172_6_5] ON [dbo].[Users]([RegionId], [Code])
CREATE STATISTICS [_dta_stat_37575172_1_6_5_12] ON [dbo].[Users]([UserId], [RegionId], [Code], [EPFNo])
CREATE STATISTICS [_dta_stat_37575172_12_1] ON [dbo].[Users]([EPFNo], [UserId])
CREATE STATISTICS [_dta_stat_85575343_17_2] ON [dbo].[Visits]([Info1], [JobNo])
CREATE STATISTICS [_dta_stat_85575343_2_13_1] ON [dbo].[Visits]([JobNo], [CreatedBy], [VisitId])
CREATE STATISTICS [_dta_stat_85575343_13_17_2] ON [dbo].[Visits]([CreatedBy], [Info1], [JobNo])
CREATE STATISTICS [_dta_stat_85575343_13_1_17] ON [dbo].[Visits]([CreatedBy], [VisitId], [Info1])

--DROP STATISTICS [dbo].[ImageGallery].[_dta_stat_2105058535_7_2_3]
--DROP STATISTICS [dbo].[SAForm_level1].[_dta_stat_261575970_10_30_2]
--DROP STATISTICS [dbo].[SAForm_level1].[_dta_stat_261575970_2_30_1]
--DROP STATISTICS [dbo].[SAForm_level1].[_dta_stat_261575970_10_30_1_2]
--DROP STATISTICS [dbo].[Users].[_dta_stat_37575172_5_1]
--DROP STATISTICS [dbo].[Users].[_dta_stat_37575172_6_12_5]
--DROP STATISTICS [dbo].[Users].[_dta_stat_37575172_6_5]
--DROP STATISTICS [dbo].[Users].[_dta_stat_37575172_1_6_5_12]
--DROP STATISTICS [dbo].[Users].[_dta_stat_37575172_12_1]
--DROP STATISTICS [dbo].[Visits].[_dta_stat_85575343_17_2]
--DROP STATISTICS [dbo].[Visits].[_dta_stat_85575343_2_13_1]
--DROP STATISTICS [dbo].[Visits].[_dta_stat_85575343_13_17_2]
--DROP STATISTICS [dbo].[Visits].[_dta_stat_85575343_13_1_17]


SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [_dta_index_Visits_147_85575343__K1_K17_K2_K13_3_4_5_6_7_8_14_21_22] ON [dbo].[Visits]
(
	[VisitId] ASC,
	[Info1] ASC,
	[JobNo] ASC,
	[CreatedBy] ASC
)
INCLUDE ( 	[VisitType],
	[RefNo],
	[TimeVisited],
	[ImageCount],
	[IsPrinted],
	[IsOriginal],
	[CreatedDate],
	[PrintedBranch],
	[PrintedDate]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

	
	CREATE NONCLUSTERED INDEX [_dta_index_Visits_5_85575343__K1_K17_K2_K13] ON [dbo].[Visits] 
(
	[VisitId] ASC,
	[Info1] ASC,
	[JobNo] ASC,
	[CreatedBy] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]



SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [_dta_index_Users_147_37575172__K1_K6_K12_K5_3_4] ON [dbo].[Users]
(
	[UserId] ASC,
	[RegionId] ASC,
	[EPFNo] ASC,
	[Code] ASC
)
INCLUDE ( 	[FirstName],
	[LastName]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
		

SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [_dta_index_SAForm_level1_147_261575970__K1_K30_K10_K2_3_4_5_6_7_8_9_11_33_34] ON [dbo].[SAForm_level1]
(
	[VisitId] ASC,
	[OTH_ProcessingBranchId] ASC,
	[GEN_Acc_Time] ASC,
	[GEN_VehicleNo] ASC
)
INCLUDE ( 	[GEN_Caller_Name],
	[GEN_Caller_ContactNo],
	[GEN_TimeReported],
	[GEN_OriginalTimeReported],
	[GEN_Insured_Name],
	[GEN_Insured_ContactNo],
	[GEN_VehicleDescription],
	[GEN_Acc_Location],
	[OTH_SiteEstimation],
	[OTH_Approx_RepairCost]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

	
SET ANSI_PADDING ON
CREATE NONCLUSTERED INDEX [_dta_index_SAForm_level1_147_261575970__K1_K10_K30_K2] ON [dbo].[SAForm_level1]
(
	[VisitId] ASC,
	[GEN_Acc_Time] ASC,
	[OTH_ProcessingBranchId] ASC,
	[GEN_VehicleNo] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

		    
DROP INDEX [_dta_index_Visits_147_85575343__K1_K17_K2_K13_3_4_5_6_7_8_14_21_22] ON [dbo].[Visits]
DROP INDEX [_dta_index_Visits_5_85575343__K1_K17_K2_K13] ON [dbo].[Visits]
DROP INDEX [_dta_index_Users_147_37575172__K1_K6_K12_K5_3_4] ON [dbo].[Users]
DROP INDEX [_dta_index_SAForm_level1_147_261575970__K1_K30_K10_K2_3_4_5_6_7_8_9_11_33_34] ON [dbo].[SAForm_level1]
DROP INDEX [_dta_index_SAForm_level1_147_261575970__K1_K10_K30_K2] ON [dbo].[SAForm_level1];




----------------------------------------------for getjobscount this has 52% improvments------------------------------------------------------------

--NOTE: Eg query for testing purposes only
--exec [dbo].[GetJobsCount] @BeginDate='1990-01-01 00:00:00',@EndDate=null,@JobNo=NULL,@VehicleNo=null,@TOCode=NULL,@TOName=NULL,@RegionId=NULL,@BranchId=NULL,@EPFNo=NULL


CREATE STATISTICS [_dta_stat_261575970_2_6] ON [dbo].[SAForm_level1]([GEN_VehicleNo], [GEN_OriginalTimeReported])
CREATE STATISTICS [_dta_stat_261575970_6_30_2_1] ON [dbo].[SAForm_level1]([GEN_OriginalTimeReported], [OTH_ProcessingBranchId], [GEN_VehicleNo], [VisitId])
CREATE NONCLUSTERED INDEX [_dta_index_SAForm_level1_5_261575970__K1_K2_K6_K30] ON [dbo].[SAForm_level1] 
(
	[VisitId] ASC,
	[GEN_VehicleNo] ASC,
	[GEN_OriginalTimeReported] ASC,
	[OTH_ProcessingBranchId] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE STATISTICS [_dta_stat_261575970_1_6_30] ON [dbo].[SAForm_level1]([VisitId], [GEN_OriginalTimeReported], [OTH_ProcessingBranchId])


CREATE NONCLUSTERED INDEX [_dta_index_Visits_5_85575343__K1_K17_K2_K13] ON [dbo].[Visits] 
(
	[VisitId] ASC,
	[Info1] ASC,
	[JobNo] ASC,
	[CreatedBy] ASC
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

--for getjobscount this has 52% improvments - Done

-- =============================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 10/23/2017
-- Description: GetJobsCount was not updated to search JobNo (LIKE not equal)
-- Release: V3.11.35
-- ============================================================================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetJobsCount]    Script Date: 10/23/2017 3:23:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/0/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobsCount] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
	--int
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId				  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo LIKE '%'+ @VehicleNo + '%') AND
							  (@TOCode IS NULL OR dbo.Users.Code LIKE '%'+ @TOCode+ '%') AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo LIKE '%'+ @EPFNo + '%') AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_Acc_Time <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)		
END

-- =============================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetTOPerformance]    Script Date: 1/12/2018 9:30:03 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ===========================================================================
-- Author:		Uthpala Pathirana
-- Create date: 13/02/2017
-- Description:	Obtain Performance Data with total number
-- ===========================================================================
ALTER PROCEDURE [dbo].[GetTOPerformance] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		SELECT
				(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionId ,
				(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.RegionId) AS RegionName ,
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) TOCode FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS UserCode ,
				(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId= j.TOCode) AS Code ,
				(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserEPFNo ,
				COUNT(AssignedDate) AS TotalNoOfJobs
				
		FROM dbo.vw_TO_Performance AS j
		WHERE 
			(@DateFrom IS NULL OR (CASE (AssignedDate)
				WHEN NULL THEN AssignedDate 
				ELSE SecondaryAssignedDate
				END)  >= @DateFrom) AND
			(@DateTo IS NULL OR CompletedDate <= @DateTo) AND 
			(@TOCode= -1 OR j.TOCode = @TOCode)
			AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END

-- =============================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetPerformanceHours]    Script Date: 1/12/2018 9:32:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 27/02/2017
-- Description:	Get a list with hours spent fo the job
-- =============================================
ALTER PROCEDURE [dbo].[GetPerformanceHours]
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode int,
	@RegionCode int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT
				(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS FullName ,
				(SELECT top(1) UserId FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS UserCode ,
				(SELECT top(1) AssignedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS AssignedDate ,
				(SELECT top(1) CompletedDate FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS CompletedDate ,
				(SELECT top(1) JobNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS JobNo ,
				(SELECT top(1) VehicleNo FROM dbo.Users AS u WHERE u.UserId=j.TOCode) AS VehicleNo ,
				(SELECT (dbo.WorkTime(AssignedDate,CompletedDate)/60)) AS HRSSpent
				
		FROM dbo.vw_TO_Performance AS j
		WHERE ((@DateFrom IS NULL OR AssignedDate > @DateFrom) AND (@DateTo IS NULL OR AssignedDate <= @DateTo))
		 AND (@TOCode= -1 OR j.TOCode = @TOCode)
		 AND (@RegionCode = -1 OR j.RegionId = @RegionCode)
		 
		GROUP BY RegionId,RegionName,FirstName,LastName,TOCode,AssignedDate,CompletedDate,JobNo,VehicleNo
END


-- =============================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetOutstandingJobs]    Script Date: 1/12/2018 9:32:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 06/02/2017
-- Description:	Outstanding Jobs
-- =============================================
ALTER PROCEDURE [dbo].[GetOutstandingJobs] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime
	--@SkipRows int,
	--@GetRows int
	--WITH RECOMPILE
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(Select AssignedJobs.CSRCode,
				AssignedJobs.JobNumber,
				AssignedJobs.VehicleNumber,
				AssignedJobs.AssignedDateTime,
				(SELECT FirstName+' '+LastName FROM dbo.Users AS u WHERE u.Code = CSRCode)AS FullName,
				(SELECT UserId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS UserId,
				(SELECT RegionId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS RegionId,
				ROW_NUMBER() OVER (ORDER BY AssignedJobs.CSRCode) AS RowNum
		 from dbo.AssignedJobs
		 where ( @DateFrom IS NULL OR AssignedDateTime >= @DateFrom) AND (@DateTo IS NULL OR AssignedDateTime <= @DateTo) AND
		 dbo.AssignedJobs.JobNumber NOT IN (SELECT JobNo from dbo.Visits))
 )
 SELECT *
 FROM TEMP
 --WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END

-- =============================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_OnStEstDataToTable]    Script Date: 1/12/2018 9:33:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:		Uthpala Pathirana
-- Create date: 16/03/2017
-- Description:	Gets all onsite estimation data prior to sorting
-- =================================================================
ALTER FUNCTION [dbo].[fn_OnStEstDataToTable]  
(
	-- Add the parameters for the function here
	@DateFrom datetime, 
	@DateTo datetime,
	@RegionId int,
	@UserId int,
	@SkipRows int,
	@GetRows int
)
RETURNS @tableItems TABLE (
	
	RegionId int,
	RegionName VARCHAR(100),
	FullName VARCHAR(100),
	TOCode NVARCHAR(7) NOT NULL ,
	EPFNo NVARCHAR(5) NOT NULL,
	TotalJobs int,
	EstimatedJobs int,
	Ratio DECIMAL(16,2)
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set
	--GEN_OriginalTimeReported = Assigned Date
	INSERT INTO @tableItems (RegionId, RegionName, FullName, TOCode, EPFNo, TotalJobs, EstimatedJobs, Ratio)
	SELECT
					(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
					(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
					(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE Code=j.Code) AS FullName ,
					(SELECT top(1) Code FROM  dbo.Users AS u WHERE Code=j.Code) AS UserCode ,
					(SELECT top(1) EPFNo FROM dbo.Users AS u WHERE Code=j.Code) AS UserEPFNo ,
					
					--COUNT(*) AS TotalJobs,
					(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
					(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )
							AND v.OTH_SiteEstimation=1) 
						AS EstimatedJobs,
					
					CONVERT(DECIMAL(16,2),
						(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											from [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
											where (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)  
												AND v.GEN_OriginalTimeReported <= @DateTo
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND (@RegionId = '-1' OR v.TORegion= @RegionId )
												AND v.TORegion=j.TORegion 
												AND v.OTH_SiteEstimation=1))*100.0
						/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
											WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
												AND v.GEN_OriginalTimeReported <= @DateTo 
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND v.TORegion=j.TORegion
												AND (@RegionId = '-1' OR v.TORegion= @RegionId ) )),0)))
					AS Ratio
						
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
			WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom) AND j.GEN_OriginalTimeReported <= @DateTo
					AND (@UserId= '-1' OR j.UserId=@UserId )
					AND (@RegionId = '-1' OR j.TORegion= @RegionId )
			GROUP BY UserId,j.TORegion,EPFNo,Code
			ORDER BY Ratio DESC
	RETURN 
	
END

-- =============================================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationCount]    Script Date: 1/12/2018 9:34:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	Display TO list in onsite estimation report
-- ============================================================================

ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimationCount] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@RowCount int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
if(@RegionId = -1)
	if(@UserId = -1)
	
		-- All regions all TOs
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
			WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId
					--AND v.ProcessingRegionId=j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									where (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion )),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom) AND j.GEN_OriginalTimeReported <= @DateTo
	GROUP BY UserId,j.TORegion
	
	else
		-- All regions, specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
				WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
											AND v.GEN_OriginalTimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom)
		AND j.GEN_OriginalTimeReported <= @DateTo 
		AND j.UserId=@UserId
	GROUP BY UserId,j.TORegion
else
	
	if(@UserId = -1)
	-- Specific region all TOs in that region
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
			WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId
					AND v.TORegion= @RegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									where (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion
										AND v.TORegion= @RegionId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom) AND j.GEN_OriginalTimeReported <= @DateTo AND j.TORegion= @RegionId
	GROUP BY UserId,j.TORegion
	
	else
		-- Specific region specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND v.GEN_OriginalTimeReported <= @DateTo  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
				WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND v.GEN_OriginalTimeReported <= @DateTo 
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId
					AND j.TORegion = @RegionId
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
											AND v.GEN_OriginalTimeReported <= @DateTo 
											AND v.UserId=@UserId
											AND j.TORegion = @RegionId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND v.GEN_OriginalTimeReported <= @DateTo 
										AND v.UserId=@UserId
										AND j.TORegion = @RegionId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom)
		AND j.GEN_OriginalTimeReported <= @DateTo 
		AND j.UserId=@UserId
		AND j.TORegion = @RegionId
	GROUP BY UserId,j.TORegion
	
	
	
END

SELECT @RowCount= @@ROWCOUNT;

-- ============================================================================================================



-- ============================================================================================================
-- ============================================================================================================
-- Author:		Suren Manwatta
-- Create date: 01/11/2018
-- Description: Removed ststs and indexes previously introduced. 
-- Release: V3.11.35
-- ============================================================================================================
DROP STATISTICS [dbo].[SAForm_level1].[_dta_stat_261575970_2_6]
DROP STATISTICS [dbo].[SAForm_level1].[_dta_stat_261575970_6_30_2_1]
DROP STATISTICS [dbo].[SAForm_level1].[_dta_stat_261575970_1_6_30]

DROP INDEX [_dta_index_Visits_5_85575343__K1_K17_K2_K13] ON [dbo].[Visits] 
DROP INDEX [_dta_index_SAForm_level1_5_261575970__K1_K2_K6_K30] ON [dbo].[SAForm_level1]

--GetAllUsers.sql
use [ClaimsOneLive]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Users_9_37575172__K15_K1_K7_K6_K2_3_4_5_8_9_10_11_12_13_14_16_17] ON [dbo].[Users]
(
	[IsDeleted] ASC,
	[UserId] ASC,
	[BranchId] ASC,
	[RegionId] ASC,
	[UserGUID] ASC
)
INCLUDE ( 	[FirstName],
	[LastName],
	[Code],
	[PrimaryEmail],
	[SecondaryEmail],
	[ContactNo],
	[ContactNo2],
	[EPFNo],
	[DataAccessLevel],
	[IsEnabled],
	[PreviousRoleId],
	[PreviousRoleChangedDate]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_37575172_1_6_15] ON [dbo].[Users]([UserId], [RegionId], [IsDeleted])
go

CREATE STATISTICS [_dta_stat_37575172_2_15_1_6_7] ON [dbo].[Users]([UserGUID], [IsDeleted], [UserId], [RegionId], [BranchId])
go

CREATE STATISTICS [_dta_stat_37575172_6_15] ON [dbo].[Users]([RegionId], [IsDeleted])
go

CREATE STATISTICS [_dta_stat_37575172_6_2_7_1] ON [dbo].[Users]([RegionId], [UserGUID], [BranchId], [UserId])
go

CREATE STATISTICS [_dta_stat_37575172_7_15] ON [dbo].[Users]([BranchId], [IsDeleted])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_aspnet_Users_9_1013578649__K2_K1_K4_3] ON [dbo].[aspnet_Users]
(
	[UserId] ASC,
	[ApplicationId] ASC,
	[LoweredUserName] ASC
)
INCLUDE ( 	[UserName]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_aspnet_Users_9_1013578649__K3_K2] ON [dbo].[aspnet_Users]
(
	[UserName] ASC,
	[UserId] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_1013578649_1_4_2] ON [dbo].[aspnet_Users]([ApplicationId], [LoweredUserName], [UserId])
go

CREATE STATISTICS [_dta_stat_1013578649_2_3] ON [dbo].[aspnet_Users]([UserId], [UserName])
go

CREATE STATISTICS [_dta_stat_1013578649_4_2] ON [dbo].[aspnet_Users]([LoweredUserName], [UserId])
go
--==============================
--RatioOfOnsiteEstimation.sql

use [ClaimsOneLive]
go

CREATE NONCLUSTERED INDEX [_dta_index_SAForm_level1_9_261575970__K1_K6_K33_K30] ON [dbo].[SAForm_level1]
(
	[VisitId] ASC,
	[GEN_OriginalTimeReported] ASC,
	[OTH_SiteEstimation] ASC,
	[OTH_ProcessingBranchId] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE NONCLUSTERED INDEX [_dta_index_SAForm_level1_9_261575970__K33_K30_K1_K6] ON [dbo].[SAForm_level1]
(
	[OTH_SiteEstimation] ASC,
	[OTH_ProcessingBranchId] ASC,
	[VisitId] ASC,
	[GEN_OriginalTimeReported] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE NONCLUSTERED INDEX [_dta_index_SAForm_level1_9_261575970__K6_K30] ON [dbo].[SAForm_level1]
(
	[GEN_OriginalTimeReported] ASC,
	[OTH_ProcessingBranchId] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_261575970_30_1_6] ON [dbo].[SAForm_level1]([OTH_ProcessingBranchId], [VisitId], [GEN_OriginalTimeReported])
go

CREATE STATISTICS [_dta_stat_261575970_30_6] ON [dbo].[SAForm_level1]([OTH_ProcessingBranchId], [GEN_OriginalTimeReported])
go

CREATE STATISTICS [_dta_stat_261575970_6_1_30] ON [dbo].[SAForm_level1]([GEN_OriginalTimeReported], [VisitId], [OTH_ProcessingBranchId])
go

CREATE STATISTICS [_dta_stat_261575970_6_33_1] ON [dbo].[SAForm_level1]([GEN_OriginalTimeReported], [OTH_SiteEstimation], [VisitId])
go

CREATE STATISTICS [_dta_stat_261575970_6_33_30_1] ON [dbo].[SAForm_level1]([GEN_OriginalTimeReported], [OTH_SiteEstimation], [OTH_ProcessingBranchId], [VisitId])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Visits_9_85575343__K13_K1_K17] ON [dbo].[Visits]
(
	[CreatedBy] ASC,
	[VisitId] ASC,
	[Info1] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Visits_9_85575343__K17_K1_K13] ON [dbo].[Visits]
(
	[Info1] ASC,
	[VisitId] ASC,
	[CreatedBy] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Visits_9_85575343__K1_K17_K13] ON [dbo].[Visits]
(
	[VisitId] ASC,
	[Info1] ASC,
	[CreatedBy] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE STATISTICS [_dta_stat_85575343_1_13] ON [dbo].[Visits]([VisitId], [CreatedBy])
go

CREATE STATISTICS [_dta_stat_85575343_13_17_1] ON [dbo].[Visits]([CreatedBy], [Info1], [VisitId])
go

CREATE STATISTICS [_dta_stat_85575343_17_13_1] ON [dbo].[Visits]([Info1], [CreatedBy], [VisitId])
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Users_9_37575172__K1_5] ON [dbo].[Users]
(
	[UserId] ASC
)
INCLUDE ( 	[Code]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

CREATE NONCLUSTERED INDEX [_dta_index_Users_9_37575172__K1_K6] ON [dbo].[Users]
(
	[UserId] ASC,
	[RegionId] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go

SET ANSI_PADDING ON

go

CREATE NONCLUSTERED INDEX [_dta_index_Users_9_37575172__K1_12] ON [dbo].[Users]
(
	[UserId] ASC
)
INCLUDE ( 	[EPFNo]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
go
--==============================



-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================


USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetMissingImagesNew]    Script Date: 1/12/2018 4:30:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SAForms_GetMissingImagesNew] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END

	-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/12/2018
-- Description: When DateFrom is not selected, it will search in all records
-- Release: V3.11.35
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetJobsWithNoImages]    Script Date: 1/12/2018 4:31:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SAForms_GetJobsWithNoImages] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND sa.GEN_OriginalTimeReported <= @EndDate 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/18/2018
-- Description: Performance Improvements
-- Release: V3.11.35
-- ============================================================================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetJobs]    Script Date: 1/18/2018 10:02:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobs]
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,--nvarchar(128),--int
    @EPFNo nvarchar(128),
	@orderBy nvarchar(128),
	@SkipRows int,
	@GetRows int
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	CREATE TABLE #Temp(VisitId  int,JobNo  nvarchar(30),VisitType  smallint,RefNo  int,TimeVisited  datetime,ImageCount  smallint,
	IsPrinted  bit, IsOriginal  bit,CreatedBy  int,OTH_Approx_RepairCost decimal,Code  nvarchar(50),UserId  int,GEN_VehicleNo  nvarchar(50),
	GEN_Caller_Name  nvarchar(150),GEN_Caller_ContactNo  nvarchar(50),GEN_TimeReported  datetime,GEN_OriginalTimeReported  datetime,
	GEN_Insured_Name  nvarchar(150),GEN_Insured_ContactNo  nvarchar(50),GEN_VehicleDescription  nvarchar(200),GEN_Acc_Time  datetime,
	GEN_Acc_Location  nvarchar(100),CreatedDate  datetime,FirstName  nvarchar(100),LastName  nvarchar(100),OTH_ProcessingBranchId  int,
	ProcessingBranchName  nvarchar(100),EPFNo  nvarchar(20),PrintedBranch  nvarchar(50),PrintedDate  datetime,RegionId  int,
	RowNum  bigint,BranchName  nvarchar(100),ImgDetailsId  int,ClaimFormImgCount  int,OTH_SiteEstimation  smallint,ProcessingRegionId  int,RegionName  nvarchar(100))


	CREATE CLUSTERED INDEX ix_tempIdIndex ON #Temp ([RowNum]);

INSERT INTO #Temp

    SELECT   dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId, ROW_NUMBER() OVER 
						  (	ORDER BY 
							CASE @orderBy WHEN 'Job No asc' THEN JobNo END ASC,
							CASE @orderBy WHEN 'Job No desc' THEN JobNo END DESC,
							CASE @orderBy WHEN 'Vehicle No asc' THEN GEN_VehicleNo END ASC,
							CASE @orderBy WHEN 'Vehicle No desc' THEN GEN_VehicleNo END DESC,
							CASE @orderBy WHEN 'TO Code asc' THEN Code END ASC,
							CASE @orderBy WHEN 'TO Code desc' THEN Code END DESC,
							CASE @orderBy WHEN 'ACR asc' THEN OTH_Approx_RepairCost END ASC,
							CASE @orderBy WHEN 'ACR desc' THEN OTH_Approx_RepairCost END DESC,
							CASE @orderBy WHEN 'Claim Processing Branch asc' THEN BranchName END ASC,
							CASE @orderBy WHEN 'Claim Processing Branch desc' THEN BranchName END DESC,
							CASE @orderBy WHEN 'Date of Accident asc' THEN GEN_Acc_Time END ASC,
							CASE @orderBy WHEN 'Date of Accident desc' THEN GEN_Acc_Time END DESC) AS RowNum,
							dbo.Branches.BranchName,
						  
								ImageDetails.VisitId,
								(CASE WHEN ImageDetails.VisitId IS NULL THEN 0 ELSE 1 END) AS ClaimFormAvailablity,
																
						    dbo.SAForm_level1.OTH_SiteEstimation,dbo.Branches.RegionId AS ProcessingRegionId,dbo.Regions.RegionName
							
			FROM         (dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId INNER JOIN
							  dbo.Regions ON dbo.Branches.RegionId = dbo.Regions.RegionId ) LEFT OUTER JOIN

							  (  SELECT dbo.ImageGallery.VisitId FROM dbo.ImageGallery where (FieldId = 6) group by dbo.ImageGallery.VisitId )
							  AS ImageDetails ON (dbo.Visits.VisitId = ImageDetails.VisitId)
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo LIKE '%'+ @VehicleNo + '%') AND
							  (@TOCode IS NULL OR dbo.Users.Code LIKE '%'+ @TOCode+ '%') AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo LIKE '%'+ @EPFNo + '%') AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId) 
							

SELECT *
FROM #Temp
WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
	

END
-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/18/2018
-- Description: Count taken to match the Performance Improvements
-- Release: V3.11.35
-- ============================================================================================================
USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[GetJobsCount]    Script Date: 1/18/2018 10:03:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Uthpala Pathirana>
-- Create date: <01/03/2017>
-- Description:	<>
-- =============================================
ALTER PROCEDURE [dbo].[GetJobsCount] 
	-- Add the parameters for the stored procedure here
	@BeginDate dateTime, 
    @EndDate dateTime,
    @JobNo nvarchar(128),
    @VehicleNo nvarchar(128),
    @TOCode nvarchar(128),
    @TOName nvarchar(128),
    @RegionId int,
	@BranchId int,
	--int
    @EPFNo nvarchar(128)
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		
			SELECT     COUNT(dbo.Visits.VisitId)
			FROM         (dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId INNER JOIN
							  dbo.Regions ON dbo.Branches.RegionId = dbo.Regions.RegionId ) LEFT OUTER JOIN

							  (  SELECT dbo.ImageGallery.VisitId FROM dbo.ImageGallery where (FieldId = 6) group by dbo.ImageGallery.VisitId )
							  AS ImageDetails ON (dbo.Visits.VisitId = ImageDetails.VisitId)
							  							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') AND
							  (@VehicleNo IS NULL OR dbo.SAForm_level1.GEN_VehicleNo LIKE '%'+ @VehicleNo + '%') AND
							  (@TOCode IS NULL OR dbo.Users.Code LIKE '%'+ @TOCode+ '%') AND
							  (@TOName IS NULL OR dbo.Users.FirstName+' '+dbo.Users.LastName LIKE '%'+ (RTRIM(LTRIM(@TOName) ))+ '%') AND --lowercase
							  (@RegionId IS NULL OR dbo.Users.RegionId = @RegionId) AND
							  (@EPFNo IS NULL OR dbo.Users.EPFNo LIKE '%'+ @EPFNo + '%') AND
							  (@BeginDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported >= @BeginDate) AND
							  (@EndDate IS NULL OR dbo.SAForm_level1.GEN_OriginalTimeReported <= @EndDate)AND
							  (@BranchId IS NULL OR dbo.SAForm_level1.OTH_ProcessingBranchId = @BranchId)

END

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/18/2018
-- Description: 
-- Release: V3.11.36
-- ============================================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationRatio]    Script Date: 1/18/2018 11:16:51 AM ******/
DROP PROCEDURE [dbo].[SAForms_GetOnsiteEstimationRatio]
GO


-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/18/2018
-- Description: 
-- Release: V3.11.36
-- ============================================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[SAForms_GetRegionalOnsiteEstimationRatio]    Script Date: 1/18/2018 11:17:51 AM ******/
DROP PROCEDURE [dbo].[SAForms_GetRegionalOnsiteEstimationRatio]
GO


-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/18/2018
-- Description: 
-- Release: V3.11.36
-- ============================================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_OnStEstDataToTable2]    Script Date: 1/18/2018 12:23:47 PM ******/
DROP FUNCTION [dbo].[fn_OnStEstDataToTable2]
GO

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/18/2018
-- Description: 
-- Release: V3.11.36
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  Index [IX_ImgGal_VisitId]    Script Date: 1/25/2018 09:46:00 AM ******/
CREATE INDEX IX_ImgGal_FieldId_VisitId ON [dbo].[ImageGallery](FieldId) 
INCLUDE ([VisitId])
GO

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/30/2018
-- Description: Indexes that improved the performance of OutstandingJobs Report
-- Release: V3.11.37
-- ============================================================================================================

CREATE NONCLUSTERED INDEX ix_JobNo ON [dbo].[Visits](JobNo ) 
GO

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/30/2018
-- Description: Indexes that improved the performance of OutstandingJobs Report
-- Release: V3.11.37
-- ============================================================================================================

CREATE NONCLUSTERED INDEX ix_AssignedDate_Include ON [dbo].[AssignedJobs](AssignedDateTime)
INCLUDE (CSRCode,JobNumber,VehicleNumber)
GO

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/30/2018
-- Description: Indexes that improved the performance of Performance Report
-- Release: V3.11.37
-- ============================================================================================================
CREATE NONCLUSTERED INDEX ix_VisitId_Include ON [dbo].[Visits](VisitId)
INCLUDE (CreatedBy,CreatedDate,JobNo)
GO

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 01/30/2018
-- Description: Indexes that improved the performance of Performance Report
-- Release: V3.11.37
-- ============================================================================================================

CREATE NONCLUSTERED INDEX ix_VisitId_Include ON [dbo].[SAForm_level1](VisitId)
INCLUDE (GEN_VehicleNo,GEN_OriginalTimeReported,GEN_TimeReported)
GO

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 02/05/2018
-- Description: Onsite Estimation Report
-- Release: V3.11.37
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimation]    Script Date: 2/5/2018 12:41:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	For the case of displaying TO list in onsite estimation report
-- ============================================================================
ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimation] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@SkipRows int,
	@GetRows int,
	@RowCount int OUTPUT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #Temp(RegionId int, RegionName nvarchar(150), FullName nvarchar(255), TOCode nvarchar(50), 
	EPFNo nvarchar(20), TotalJobs int, EstimatedJobs int, Ratio DECIMAL(16,2))

	CREATE CLUSTERED INDEX ix_tempIdIndex ON #Temp ([Ratio]);

	INSERT INTO #Temp
		
		SELECT
					(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
					(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
					(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE Code=j.Code) AS FullName ,
					(SELECT top(1) Code FROM  dbo.Users AS u WHERE Code=j.Code) AS UserCode ,
					(SELECT top(1) EPFNo FROM dbo.Users AS u WHERE Code=j.Code) AS UserEPFNo ,
					
					(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,

					(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )
							AND v.OTH_SiteEstimation=1) 
						AS EstimatedJobs,
					
					CONVERT(DECIMAL(16,2),
						(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											from [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
											where (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)  
												AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)  
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND (@RegionId = '-1' OR v.TORegion= @RegionId )
												AND v.TORegion=j.TORegion 
												AND v.OTH_SiteEstimation=1))*100.0
						/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
											FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
											WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
												AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
												AND v.UserId= j.UserId
												AND (@UserId= '-1' OR v.UserId=@UserId )
												AND v.TORegion=j.TORegion
												AND (@RegionId = '-1' OR v.TORegion= @RegionId ) )),0)))
					AS Ratio
					
					
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
			WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom) AND (@DateTo IS NULL OR j.GEN_OriginalTimeReported <= @DateTo)
					AND (@UserId= '-1' OR j.UserId=@UserId )
					AND (@RegionId = '-1' OR j.TORegion= @RegionId )
			GROUP BY UserId,j.TORegion,EPFNo,Code
			ORDER BY Ratio DESC

	;WITH POSTCTE AS (
		SELECT TOP 100000 *, ROW_NUMBER() OVER (ORDER BY Ratio DESC)  AS RowNum
		FROM #Temp
		Order by Ratio DESC) 

		--if the total no of rows are more than 100000, will have to find an alteration for this constant

	SELECT *
	FROM POSTCTE
	WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)

END

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 02/05/2018
-- Description: Onsite Estimation Count
-- Release: V3.11.37
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetOnsiteEstimationCount]    Script Date: 2/5/2018 3:03:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============================================================================
-- Author:		Uthpala Pathirana
-- Create date: 23/01/2017
-- Description:	Display TO list in onsite estimation report
-- ============================================================================

ALTER PROCEDURE [dbo].[SAForms_GetOnsiteEstimationCount] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime = 0, 
	@DateTo datetime = 0,
	@RegionId int = 0,
	@UserId int = 0,
	@RowCount int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
    -- Insert statements for procedure here
if(@RegionId = -1)
	if(@UserId = -1)
	
		-- All regions all TOs
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
			WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo) 
					AND v.UserId= j.UserId
					--AND v.ProcessingRegionId=j.ProcessingRegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									where (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion )),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom) AND (@DateTo IS NULL OR j.GEN_OriginalTimeReported <= @DateTo)
	GROUP BY UserId,j.TORegion
	
	else
		-- All regions, specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
				WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId 
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
											AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
											AND v.UserId=@UserId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
										AND v.UserId=@UserId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom)
		AND (@DateTo IS NULL OR j.GEN_OriginalTimeReported <= @DateTo)
		AND j.UserId=@UserId
	GROUP BY UserId,j.TORegion
else
	
	if(@UserId = -1)
	-- Specific region all TOs in that region
		SELECT
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)  
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) 
			FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
			WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
					AND v.UserId= j.UserId
					AND v.TORegion= @RegionId 
					AND v.OTH_SiteEstimation=1) 
				AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
				(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									from [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									where (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo) 
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion 
										AND v.OTH_SiteEstimation=1))*100.0
				/NULLIF(CONVERT(DECIMAL(16,2),(SELECT COUNT(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
									WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
										AND v.UserId= j.UserId
										AND v.TORegion=j.TORegion
										AND v.TORegion= @RegionId)),0)))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom) AND (@DateTo IS NULL OR j.GEN_OriginalTimeReported <= @DateTo) AND j.TORegion= @RegionId
	GROUP BY UserId,j.TORegion
	
	else
		-- Specific region specific TO
		SELECT 
			(SELECT top(1) r.RegionId FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionId ,
			(SELECT top(1) r.RegionName FROM dbo.Regions AS r WHERE r.RegionId=j.TORegion) AS RegionName ,
			(SELECT top(1) u.FirstName + ' '+ u.LastName FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS FullName ,
			(SELECT top(1) Code FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserCode ,
			(SELECT top(1) u.EPFNo FROM dbo.Users AS u WHERE u.UserId=j.UserId) AS UserEPFNo ,
			(SELECT count(*) 
					FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
					WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
							AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo) 
							AND v.UserId= j.UserId
							AND (@UserId= '-1' OR v.UserId=@UserId )
							AND (@RegionId = '-1' OR v.TORegion= @RegionId )) 
						AS TotalJobs,
			(SELECT count(*) FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
				WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
					AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
					AND v.UserId= j.UserId 
					AND v.UserId=@UserId
					AND j.TORegion = @RegionId
					AND v.OTH_SiteEstimation=1) 
			AS EstimatedJobs,
			
			CONVERT(DECIMAL(16,2),
			(	CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
											AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
											AND v.UserId=@UserId
											AND j.TORegion = @RegionId
											AND v.UserId= j.UserId 
											AND v.OTH_SiteEstimation=1))*100.0
				/CONVERT(DECIMAL(16,2),(SELECT count(*) 
									FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] v 
										WHERE (@DateFrom IS NULL OR v.GEN_OriginalTimeReported >= @DateFrom)
										AND (@DateTo IS NULL OR v.GEN_OriginalTimeReported <= @DateTo)
										AND v.UserId=@UserId
										AND j.TORegion = @RegionId
										AND v.UserId= j.UserId))))
			AS Ratio
				
	FROM [ClaimsOneLive].[dbo].[vw_SAForm_GeneralNew] AS j
	WHERE (@DateFrom IS NULL OR j.GEN_OriginalTimeReported >= @DateFrom)
		AND (@DateTo IS NULL OR j.GEN_OriginalTimeReported <= @DateTo)
		AND j.UserId=@UserId
		AND j.TORegion = @RegionId
	GROUP BY UserId,j.TORegion
	
	
	
END

SELECT @RowCount= @@ROWCOUNT;

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 02/06/2018
-- Description: Missing Images
-- Release: V3.11.37
-- ============================================================================================================

USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetMissingImagesNew]    Script Date: 2/5/2018 3:04:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SAForms_GetMissingImagesNew] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND (@EndDate IS NULL OR sa.GEN_OriginalTimeReported <= @EndDate) 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND (@EndDate IS NULL OR sa.GEN_OriginalTimeReported <= @EndDate) 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, abs(s.Value-isnull(g.ImageCount,0)) as MissingImageCount,/*v.VisitId as VisitId,*/  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND (@EndDate IS NULL OR sa.GEN_OriginalTimeReported <= @EndDate) 
	) as b
	where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 02/06/2018
-- Description: Missing Images - Job with No Images
-- Release: V3.11.37
-- ============================================================================================================

	USE [ClaimsOneLive]
GO
/****** Object:  StoredProcedure [dbo].[SAForms_GetJobsWithNoImages]    Script Date: 2/6/2018 10:10:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[SAForms_GetJobsWithNoImages] 
    @BeginDate dateTime, 
    @EndDate dateTime,
    @Flag int,
    @GeneralId int 
AS 

if(@Flag = -2) /*Engineer*/
	BEGIN
    SET NOCOUNT ON;
    
    select * from(
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.RegionId = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND (@EndDate IS NULL OR sa.GEN_OriginalTimeReported <= @EndDate) 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]

	END
	
else if(@Flag = -3) /*TO*/
	BEGIN
	
	SET NOCOUNT ON;
    
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where u.Code = @GeneralId AND v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND (@EndDate IS NULL OR sa.GEN_OriginalTimeReported <= @EndDate) 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END
	
else if(@Flag = -1) /*Admin , Management, Audit*/
	BEGIN
	
	SET NOCOUNT ON;
	
    select * from (
	select * from(
	select v.JobNo as JobNo, u.Code as OfficerCode, sa.GEN_VehicleNo as VehicleNo, 
	(CASE s.Value
	WHEN 0
		THEN s.Value
	ELSE
		abs(s.Value-isnull(g.ImageCount,0))
	END) as MissingImageCount,
	  
	s.ParamKey as ImageType /*ImageCount as SentImageCount ,v.CreatedDate  as SubmitedDate*/
	from dbo.Visits v 
	inner join (select VisitId as visit,paramkey,Value from dbo.VisitParams) s on s.visit = v.visitid 
	left outer join (
	select VisitId,FieldId, ( COUNT(*)) as ImageCount /*TODO:get the image count for each category and replace '100' */  
	from dbo.vw_ImageGallery
	group by FieldId,VisitId) g on s.visit = g.VisitId and g.FieldId = s.ParamKey
	inner join SAForm_level1 sa on sa.VisitId = v.VisitId
	inner join Users u on u.UserId = v.CreatedBy
	where v.VisitType = 0 /*SA Form*/ and (@BeginDate IS NULL OR sa.GEN_OriginalTimeReported >= @BeginDate) AND (@EndDate IS NULL OR sa.GEN_OriginalTimeReported <= @EndDate) 
	) as b
	--where b.MissingImageCount != 0
	)as a
	
	PIVOT (
	max([MissingImageCount])
	FOR [ImageType] IN ([1],[2],[3],[4],[5],[6])
	) as pvt order by [JobNo]
	
	END

-- ============================================================================================================
-- ============================================================================================================
-- Author:		Uthpala Pathirana
-- Create date: 12/11/2018
-- Description: Regional Level Outstanding Jobs
-- Release: V3.11.8
-- ============================================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[GetOutstandingJobs_Paginated]    Script Date: 11/12/2018 08:53:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 11/08/2018
-- Description:	Outstanding Jobs
-- =============================================
CREATE PROCEDURE [dbo].[GetOutstandingJobs_Paginated] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode nvarchar(128),
    @RegionId int,
    @orderBy nvarchar(128),
    @SkipRows int,
	@GetRows int
	--WITH RECOMPILE
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(Select a.CSRCode,
				a.JobNumber,
				a.VehicleNumber,
				a.AssignedDateTime,
				u.FirstName+' '+u.LastName AS FullName,
				u.UserId AS UserId,
				u.RegionId AS RegionId,
				--(SELECT FirstName+' '+LastName FROM dbo.Users AS u WHERE u.Code = CSRCode)AS FullName,
				--(SELECT UserId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS UserId,
				--(SELECT RegionId FROM dbo.Users AS u WHERE u.Code = CSRCode)AS RegionId,
				ROW_NUMBER() OVER (
				ORDER BY 
					CASE @orderBy WHEN 'CSR Code asc' THEN a.CSRCode END ASC,
					CASE @orderBy WHEN 'CSR Code desc' THEN a.CSRCode END DESC,
					CASE @orderBy WHEN 'Full Name asc' THEN u.FirstName+' '+u.LastName END ASC,
					CASE @orderBy WHEN 'Full Name desc' THEN u.FirstName+' '+u.LastName END DESC,
					CASE @orderBy WHEN 'Vehicle No asc' THEN VehicleNumber END ASC,
					CASE @orderBy WHEN 'Vehicle No desc' THEN VehicleNumber END DESC,
					CASE @orderBy WHEN 'Job No asc' THEN JobNumber END ASC,
					CASE @orderBy WHEN 'Job No desc' THEN JobNumber END DESC,
					CASE @orderBy WHEN 'Assigned Date asc' THEN AssignedDateTime END ASC,
					CASE @orderBy WHEN 'Assigned Date desc' THEN AssignedDateTime END DESC
				) AS RowNum
				
		 from [dbo].[AssignedJobs] AS a LEFT JOIN dbo.Users AS u ON a.CSRCode = u.Code
		 
		 where (@DateFrom IS NULL OR AssignedDateTime >= @DateFrom) AND 
				(@DateTo IS NULL OR AssignedDateTime <= @DateTo) AND
				a.JobNumber NOT IN (SELECT JobNo from dbo.Visits) AND
				(@TOCode IS NULL OR u.UserId = @TOCode) AND
				(@RegionId IS NULL OR u.RegionId = @RegionId)
		 )
	)
 SELECT *
 FROM TEMP
 WHERE RowNum > @SkipRows AND RowNum <= (@SkipRows+@GetRows)
 
 
END
GO


-- ==================================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[GetOutstandingJobs_Count]    Script Date: 11/12/2018 08:54:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Uthpala Pathirana
-- Create date: 11/08/2018
-- Description:	Outstanding Jobs
-- =============================================
CREATE PROCEDURE [dbo].[GetOutstandingJobs_Count] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@TOCode nvarchar(128),
    @RegionId int
    --@orderBy nvarchar(128),
    --@SkipRows int,
	--@GetRows int
	--WITH RECOMPILE
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
	SELECT COUNT(a.CSRCode)
			
	 FROM [dbo].[AssignedJobs] AS a LEFT JOIN dbo.Users AS u ON a.CSRCode = u.Code
	 
	 WHERE (@DateFrom IS NULL OR AssignedDateTime >= @DateFrom) AND 
			(@DateTo IS NULL OR AssignedDateTime <= @DateTo) AND
			a.JobNumber NOT IN (SELECT JobNo from dbo.Visits) AND
			(@TOCode IS NULL OR u.UserId = @TOCode) AND
			(@RegionId IS NULL OR u.RegionId = @RegionId)

END
GO

-- ==================================================================================================
/****** Object:  Index [ix_JobNo]    Script Date: 11/15/2018 08:56:01 ******/
CREATE NONCLUSTERED INDEX [ix_JobNo] ON [dbo].[Visits] 
(
	[JobNo] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


--======================================================================================================

USE [ClaimsOneLive]
GO

/****** Object:  StoredProcedure [dbo].[GetParticularJob]    Script Date: 05/16/2019 08:30:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Atheek Azmy>
-- Create date: <05/06/2019>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [dbo].[GetParticularJob] 
	-- Add the parameters for the stored procedure here	
    @JobNo nvarchar(128)
    
 --   @StartIndex			INT	= 1,
	--@pageSize			INT	= 10
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
	
		;WITH PostCTE AS (
			SELECT     dbo.Visits.VisitId, dbo.Visits.JobNo, dbo.Visits.VisitType, dbo.Visits.RefNo, dbo.Visits.TimeVisited, dbo.Visits.ImageCount, dbo.Visits.IsPrinted, dbo.Visits.IsOriginal, 
						  dbo.Visits.CreatedBy, dbo.SAForm_level1.OTH_Approx_RepairCost, dbo.Users.Code, dbo.Users.UserId, dbo.SAForm_level1.GEN_VehicleNo, 
						  dbo.SAForm_level1.GEN_Caller_Name, dbo.SAForm_level1.GEN_Caller_ContactNo, dbo.SAForm_level1.GEN_TimeReported, 
						  dbo.SAForm_level1.GEN_OriginalTimeReported, dbo.SAForm_level1.GEN_Insured_Name, dbo.SAForm_level1.GEN_Insured_ContactNo, 
						  dbo.SAForm_level1.GEN_VehicleDescription, dbo.SAForm_level1.GEN_Acc_Time, dbo.SAForm_level1.GEN_Acc_Location, dbo.Visits.CreatedDate, 
						  dbo.Users.FirstName, dbo.Users.LastName, dbo.SAForm_level1.OTH_ProcessingBranchId, dbo.Branches.BranchName AS ProcessingBranchName, 
						  dbo.Users.EPFNo,dbo.Visits.PrintedBranch,dbo.Visits.PrintedDate,dbo.Users.RegionId,
						  dbo.Branches.BranchName,
						  (SELECT     COUNT(*) AS Expr1
								FROM          dbo.ImageGallery
								WHERE      (dbo.Visits.VisitId = VisitId) AND (FieldId = 6)) AS ClaimFormImgCount, dbo.SAForm_level1.OTH_SiteEstimation, 
						  dbo.Branches.RegionId AS ProcessingRegionId,
							  (SELECT     RegionName AS Expr2
								FROM          dbo.Regions
								WHERE      (RegionId = dbo.Branches.RegionId)) AS RegionName
			FROM         dbo.SAForm_level1 INNER JOIN
							  dbo.Visits ON dbo.SAForm_level1.VisitId = dbo.Visits.VisitId INNER JOIN
							  dbo.Users ON dbo.Visits.CreatedBy = dbo.Users.UserId INNER JOIN
							  dbo.Branches ON dbo.SAForm_level1.OTH_ProcessingBranchId = dbo.Branches.BranchId
							  
			WHERE     ((dbo.Visits.Info1 <> 'd') OR
							  (dbo.Visits.Info1 IS NULL)) AND
							  (@JobNo IS NULL OR dbo.Visits.JobNo LIKE '%'+ @JobNo + '%') 
			--OFFSET     @SkipRows ROWS       -- skip 10 rows
			--FETCH NEXT @GetRows ROWS ONLY; -- take 10 rows
			)
SELECT *
FROM PostCTE
END

GO

--===========================================================/
USE [ClaimsOne]
GO

/****** Object:  StoredProcedure [dbo].[GetVisitedTimeDifference]    Script Date: 05/24/2019 11:56:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Atheek Azmy
-- Create date: 22/05/2019
-- Description:	Visited Time Difference
-- =============================================
CREATE PROCEDURE [dbo].[GetVisitedTimeDifference] 
	-- Add the parameters for the stored procedure here
	@DateFrom datetime,
	@DateTo datetime,
	@GeneralId int ,
    @ToCode varchar(30)
	--WITH RECOMPILE
	
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    ;WITH TEMP AS(
		(SELECT     u.Code AS TOCode, u.FirstName + ' ' + u.LastName AS TOName, SA.VisitId, V.JobNo,
 SA.GEN_VehicleNo, SA.GEN_TimeReported, V.TimeVisited,
 convert(varchar(5),DateDiff(s,SA.GEN_TimeReported , V.TimeVisited)/3600)+'h '+convert(varchar(5),DateDiff(s, SA.GEN_TimeReported , V.TimeVisited)%3600/60)+'m' as [Difference]
FROM         SAForm_level1 AS SA INNER JOIN
                      Visits AS V ON SA.VisitId = V.VisitId INNER JOIN
                      Users AS u ON u.UserId = V.CreatedBy
                      where v.VisitType = 0 and SA.GEN_TimeReported >= @DateFrom AND SA.GEN_TimeReported <= @DateTo AND
							(@TOCode IS NULL OR u.UserId = @TOCode) AND
							(@GeneralId IS NULL OR u.RegionId = @GeneralId))
 )
 SELECT *
 FROM TEMP 
 
END

GO


-- =============================================
-- Author:		Atheek Azmy
-- Create date: 24/05/2019
-- Description:	update role permissions
-- =============================================

UPDATE    [aspnet_Roles]
SET              [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,TOPerformanceAjaxHandleLogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,TemplateView_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,IsUsernameAvailable_HTML,IsUsernameAvailable_JSON,UpdateUser_HTML,ResetPassword_HTML,DeactivateUser_HTML,DeleteUser_HTML,ActivateUser_HTML,CreateUser_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,ViewRegions_HTML,RegionListAjaxHandler_HTML,CreateRegion_HTML,UpdateRegion_HTML,ActivateRegion_HTML,DeactivateRegion_HTML,DeleteRegion_HTML,ViewBranches_HTML,BranchListAjaxHandler_HTML,CreateBranch_HTML,ActivateBranch_HTML,DeactivateBranch_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,UserListAjaxHandlr_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,GetJobDetailsAjaxHandler_XML,LogDetails_HTML,LockedUsers_HTML,UnlockUsers_HTML,DamagedItems_HTML,DamagedItems_HTML,PossibleDR_HTML,AuditLogPrintPreview_HTML,VisitLogAjaxHandler_HTML,VisitLog_HTML,TempDeleteJob_HTML,UpdateBranch_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,AuditLogToExcel_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,OutstandingSAReports_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AppManagement_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,VisitDetailsPrintPreview_HTML,JobWithImagesPrintPreview_HTML,RegionalLevelPhotoAvailabilityReports_HTML,RegionalLevelPhotoAvailabilityReportsAjaxHandler_HTML,RegionalLevelPhotoAvailabilityReportsPrintPreview_HTML,RegionalLevelPhotoAvailabilityReportToExcel_HTML,VisitedTimeDifferenceReport_HTML,VisitedTimeDifferenceReportAjaxHandler_HTML,GetPhotoAvailabilityJobDetailsAjaxHandler_XML,GetPhotoAvailabilityVisitDetailsAjaxHandler_XML'
WHERE     [RoleName] = 'System Administrator'

 UPDATE    [aspnet_Roles]
SET              [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,UpdateProfile_HTML,AuditLog_HTML,AuditLogAjaxHandler_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,PossibleDR_HTML,DamagedItems_HTML,AuditLogPrintPreview_HTML,Maintenance_HTML,VisitLog_HTML,VisitLogAjaxHandler_HTML,AuditLogToExcel_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,MissingImagesToExcel_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,VisitDetailsPrintPreview_HTML,JobWithImagesPrintPreview_HTML,RegionalLevelPhotoAvailabilityReports_HTML,RegionalLevelPhotoAvailabilityReportsAjaxHandler_HTML,RegionalLevelPhotoAvailabilityReportsPrintPreview_HTML,RegionalLevelPhotoAvailabilityReportToExcel_HTML,VisitedTimeDifferenceReport_HTML,VisitedTimeDifferenceReportAjaxHandler_HTML,GetPhotoAvailabilityJobDetailsAjaxHandler_XML,GetPhotoAvailabilityVisitDetailsAjaxHandler_XML'
WHERE     [RoleName] = 'Audit'

 UPDATE    [aspnet_Roles]
SET              [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,CreateComment_HTML,CreateComment_JSON,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PossibleDR_HTML,DamagedItems_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,RegionalLevelPerformance_HTML,RegionalLevelPerformanceAjaxHandler_HTML,TOPerformance_HTML,TOPerformanceAjaxHandler_HTML,OutstandingSAReportsRL_HTML,OutstandingSAReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OutstandingSAReports_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,JobVisitResultPrintPreview_HTML,JobDetailsPrintPreview_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,VisitDetailsPrintPreview_HTML,JobWithImagesPrintPreview_HTML,RegionalLevelPhotoAvailabilityReports_HTML,RegionalLevelPhotoAvailabilityReportsAjaxHandler_HTML,RegionalLevelPhotoAvailabilityReportsPrintPreview_HTML,RegionalLevelPhotoAvailabilityReportToExcel_HTML,VisitedTimeDifferenceReport_HTML,VisitedTimeDifferenceReportAjaxHandler_HTML,GetPhotoAvailabilityJobDetailsAjaxHandler_XML,GetPhotoAvailabilityVisitDetailsAjaxHandler_XML'
WHERE     [RoleName] = 'Engineer'

UPDATE    [aspnet_Roles]
SET              [Description] = 'LogOn_HTML,LogOff_HTML,ChangePassword_HTML,Index_HTML,MyProfile_HTML,Search_HTML,AdvancedSearch_HTML,AdvancedSearchAjaxHandler_HTML,UserManagement_HTML,ViewUsers_HTML,ViewReports_HTML,AccessLogs_HTML,ReportInquery_HTML,Maintenance_HTML,RegionList_HTML,BranchesList_HTML,UpdateProfile_HTML,GetVisitsOfJobsAjaxHandler_HTML,FindBranchesByRegionId_HTML,CommentsListAjaxHandler_HTML,CommentsListAjaxHandler2_HTML,JobDetailsPrintPreview_HTML,AdvancedSearchResultPrintPreview_HTML,JobVisitResultPrintPreview_HTML,GetJobDetailsAjaxHandler_HTML,GetRolesListJson_HTML,JobDetailsPrintPreview_JSON,GetVisitDetailsAjaxHandler_HTML,GetVisitDetailsAjaxHandler_JSON,ViewUsers_HTML,UserListAjaxHandler_HTML,VisitDetailsPrintPreview_HTML,GetImageIds_HTML,GetImage_HTML,GetJobDetailsAjaxHandler_JSON,UserListAjaxHandler_HTML,PrintVisit_JSON,PossibleDR_HTML,DamagedItems_HTML,UpdateUser_HTML,JobFullPrintPreview_HTML,ViewReports_HTML,OnSiteEstimationAjaxHandler_HTML,OnSiteEstimation_HTML,OnSiteEstimationRegion_HTML,OnSiteEstimationRegionAjaxHandler_HTML,UpdateJobDetailsAjaxHandler_JSON,UpdateJobDetailsAjaxHandler_HTML,RegionalLevelPerformanceAjaxHandler_HTML,RegionalLevelPerformance_HTML,MissingImages_HTML,MissingImagesAjaxHandler_HTML,MissingImagesToExcel_HTML,RegionalLevelOutstandingReports_HTML,RegionalLevelOutstandingReportsAjaxHandler_HTML,ScoreSendAjax_HTML,OnSiteEstimationToExcel_HTML,OnSiteEstimationRegionToExcel_HTML,RegionalLevelPerformanceToExcel_HTML,RegionalLevelOutstandingReportToExcel_HTML,OnSiteEstimationPrintPreview_HTML,OnSiteEstimationRegionPrintPreview_HTML,RegionalLevelOutstandingReportPrintPreview_HTML,RegionalLevelPerformancePrintPreview_HTML,AverageSendAjax_HTML,SelectTO_HTML,OnSiteEstimationReport_HTML,JobWithImagesPrintPreview_HTML,RegionalLevelPhotoAvailabilityReports_HTML,RegionalLevelPhotoAvailabilityReportsAjaxHandler_HTML,RegionalLevelPhotoAvailabilityReportsPrintPreview_HTML,RegionalLevelPhotoAvailabilityReportToExcel_HTML,VisitedTimeDifferenceReport_HTML,VisitedTimeDifferenceReportAjaxHandler_HTML,GetPhotoAvailabilityJobDetailsAjaxHandler_XML,GetPhotoAvailabilityVisitDetailsAjaxHandler_XML'
WHERE     [RoleName] = 'Management'
 
