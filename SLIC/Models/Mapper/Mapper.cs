/***************************************************************************/
/// <summary>
///  <title>SLIC Mapper Model</title>
///  <description>Mapper Model for Map data</description>
///  <copyRight>Copyright (c) 2010</copyRight>
///  <company>IronOne Technologies (Pvt)Ltd</company>
///  <createdOn>2011-08-01</createdOn>
///  <author></author>
///  <modification>
///     <modifiedBy></modifiedBy>
///      <modifiedDate></modifiedDate>
///     <description></description>
///  </modification>
///
/// </summary>
/***************************************************************************/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Xml;
using System.Data.SqlClient;
using System.Data;
using System.Collections.Specialized;
using System.Globalization;
using System.Text;

#region SLICReferences

using com.IronOne.SLIC2.HandlerClasses;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Models.Job;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Controllers;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.SLIC2.Models.Visit;
using com.IronOne.IronUtils;
#endregion SLICReferences

namespace com.IronOne.SLIC2.Models.Mapper
{
    public static class Mapper
    {
        #region Users

        public static UserDataModel ToUserObj(vw_UserLoginDetails view)
        {
            return new UserDataModel
            {
                Username = view.UserName,
                Id = view.UserId,
                UserId = view.UserGUID,
                FirstName = view.FirstName,
                LastName = view.LastName,
                RoleId = view.RoleId,
                RoleName = view.RoleName,
                IsEnabled = view.IsEnabled,
                IsDeleted = view.IsDeleted,
                CSRCode = view.Code,
                RolePermissions = view.Description
            };
        }

        public static UserDataModel ToUserObj(vw_UserDetails view)
        {
            return new UserDataModel
            {
                Username = view.UserName,
                Id = view.UserId,
                UserId = view.UserGUID,
                FirstName = view.FirstName,
                LastName = view.LastName,
                IsEnabled = view.IsEnabled,
                IsDeleted = view.IsDeleted,
                CSRCode = view.Code,
                Email = view.PrimaryEmail,
                //TODO: PrimaryEmail, Secondary Email, Contact No, Contact No 2
                RegionId = view.RegionId,
                RegionName = view.RegionName,
                BranchId = view.BranchId,
                BranchName = view.BranchName,
                RoleName = view.RoleName,
                RoleId = view.RoleId,
                CurrentRoleName = view.RoleName
            };
        }

        public static User ToUserEntity(UserDataModel model)
        {
            return new User
            {
                UserId = model.Id,
                UserGUID = model.UserId,
                FirstName = model.FirstName,
                LastName = model.LastName,
                Code = model.CSRCode,
                PrimaryEmail = model.Email,
                BranchId = model.BranchId,
                RegionId = model.RegionId,
                // IsEnabled = model.IsEnabled,
                // IsDeleted = model.IsDeleted                
            };
        }
        #endregion

        #region Jobs

        #region General

        public static JobGeneralModel ToJobGeneralObject(vw_SAForm_General view)
        {
            return new JobGeneralModel
            {

                VisitId = view.VisitId,
                JobNo = view.JobNo,
                VehicleNo = view.GEN_VehicleNo,
                AccidentDateTime = view.GEN_Acc_Time,
                CallerName = view.GEN_Caller_Name,
                CreatedBy = view.CreatedBy,
                CsrCode = view.Code,
                ApproximateCostOfRepair = view.OTH_Approx_RepairCost,
                IsPrinted = view.IsPrinted
            };
        }

        public static JobGeneralModel ToJobGeneralObject(vw_SAFormDetails view)
        {
            return new JobGeneralModel
            {
                VisitId = view.VisitId,
                JobNo = view.JobNo,
                VehicleNo = view.GEN_VehicleNo,
                AccidentDateTime = view.GEN_Acc_Time,
                AccidentLocation = view.GEN_Acc_Location,
                CallerName = view.GEN_Caller_Name,
                CallerContactNo = view.GEN_Caller_ContactNo,
                InsuredContactNo = view.GEN_Insured_ContactNo,
                InsuredName = view.GEN_Insured_Name,
                TimeReported = (DateTime)view.GEN_TimeReported,
                OriginalTimeReported = (DateTime)view.GEN_OriginalTimeReported,
                VehicleDescription = view.GEN_VehicleDescription,
                IsPrinted = view.IsPrinted
            };
        }

        #endregion

        #region Vehicle & Driver Details

        public static JobVehDriverModel ToJobDriverObject(vw_SAForm_VehDriverDetails view)
        {
            return new JobVehDriverModel
            {
                VisitId = view.VisitId,
                ChassisNo = view.VAD_ChassyNo,
                EngineNo = view.VAD_EngineNo,
                MeterReading = view.VAD_MeterReading,
                DriverCompetenceId = view.VAD_DriverCompetence,
                DriverLicenseExpiryDate = view.VAD_License_ExpiryDate,
                DriverLicenseIsNew = view.VAD_License_IsNew,
                DriverLicenseIsNewOldTypeId = view.VAD_License_IsNewOld_TypeId,
                DriverLicenseNo = view.VAD_License_No,
                DriverLicenseTypeId = view.VAD_License_TypeId,
                DriverName = view.VAD_DriverName,
                DriverNic = view.VAD_DriverNIC,
                DriverRelationshipId = view.VAD_DriverRelationship,
                /*Set Properties from Enum */
                DriverRelationship = (view.VAD_DriverRelationship != null) ? Enum.GetName(typeof(RelationshipType), view.VAD_DriverRelationship) : null,
                DriverLicenseType = (view.VAD_License_TypeId != null) ? Enum.GetName(typeof(LicenseType), view.VAD_License_TypeId) : null,
                DriverLicenseIsNewOldType = (view.VAD_License_IsNewOld_TypeId != null) ? Enum.GetName(typeof(LicenseIsNew), view.VAD_License_IsNewOld_TypeId) : null,
                DriverCompetence = (view.VAD_DriverCompetence != null) ? Enum.GetName(typeof(Confirmation), view.VAD_DriverCompetence) : null,
            };
        }

        public static JobVehDriverModel ToJobDriverObject(vw_SAFormDetails view)
        {
            return new JobVehDriverModel
            {
                VisitId = view.VisitId,
                ChassisNo = view.VAD_ChassyNo,
                EngineNo = view.VAD_EngineNo,
                MeterReading = view.VAD_MeterReading,
                DriverCompetenceId = view.VAD_DriverCompetence,
                DriverLicenseExpiryDate = view.VAD_License_ExpiryDate,
                DriverLicenseIsNew = view.VAD_License_IsNew,
                DriverLicenseIsNewOldTypeId = view.VAD_License_IsNewOld_TypeId,
                DriverLicenseNo = view.VAD_License_No,
                DriverLicenseTypeId = view.VAD_License_TypeId,
                DriverName = view.VAD_DriverName,
                DriverNic = view.VAD_DriverNIC,
                DriverRelationshipId = view.VAD_DriverRelationship,
                /*Set Properties from Enum */
                DriverRelationship = (view.VAD_DriverRelationship != null) ? Enum.GetName(typeof(RelationshipType), view.VAD_DriverRelationship) : null,
                DriverLicenseType = (view.VAD_License_TypeId != null) ? Enum.GetName(typeof(LicenseType), view.VAD_License_TypeId) : null,
                DriverLicenseIsNewOldType = (view.VAD_License_IsNewOld_TypeId != null) ? Enum.GetName(typeof(LicenseIsNew), view.VAD_License_IsNewOld_TypeId) : null,
                DriverCompetence = (view.VAD_DriverCompetence != null) ? Enum.GetName(typeof(Confirmation), view.VAD_DriverCompetence) : null,
                DriverLicenseIsNew_Val = (view.VAD_License_IsNew != null && (bool)view.VAD_License_IsNew) ? LicenseIsNew.New.ToString() : LicenseIsNew.Old.ToString()
            };
        }

        #endregion

        #region Policy

        public static JobPolicyModel ToJobPolicyObject(vw_SAForm_PolicyDetails view)
        {
            return new JobPolicyModel
            {
                VisitId = view.VisitId,
                PolicyCoverNoteNo = view.POL_Policy_CN_No,
                PolicyCoverNoteIssuedBy = view.POL_CN_IssuedBy,
                PolicyCoverNoteSerialNo = view.POL_Policy_CN_SerialNo,
                PolicyCoverNoteReasons = view.POL_CN_Reasons,
                PolicyCoverNoteStartDate = view.POL_Policy_CN_StartDate,
                PolicyCoverNoteEndDate = view.POL_Policy_CN_EndDate
            };
        }

        public static JobPolicyModel ToJobPolicyObject(vw_SAFormDetails view)
        {
            return new JobPolicyModel
            {
                VisitId = view.VisitId,
                PolicyCoverNoteNo = view.POL_Policy_CN_No,
                PolicyCoverNoteIssuedBy = view.POL_CN_IssuedBy,
                PolicyCoverNoteSerialNo = view.POL_Policy_CN_SerialNo,
                PolicyCoverNoteReasons = view.POL_CN_Reasons,
                PolicyCoverNoteStartDate = view.POL_Policy_CN_StartDate,
                PolicyCoverNoteEndDate = view.POL_Policy_CN_EndDate
            };
        }

        #endregion

        #region Vehicle Condition & Damages

        public static JobDamageModel ToJobDamagesObject(vw_SAForm_Damages view)
        {
            return new JobDamageModel
            {
                VisitId = view.VisitId,
                Tyre_FL_Id = view.CON_Tyre_FL_Status,
                Tyre_RLL_Id = view.CON_Tyre_RLL_Status,
                Tyre_RLR_Id = view.CON_Tyre_RLR_Status,
                Tyre_RRR_Id = view.CON_Tyre_RRR_Status,
                Tyre_FR_Id = view.CON_Tyre_FR_Status,
                Tyre_RRL_Id = view.CON_Tyre_RRL_Status,
                Tyre_IsContributory = view.CON_Tyre_IsContributory,
                DamagedItems = view.DAM_DamagedItems,
                DamagedItems_Other = view.DAM_DamagedItems_Other,
                GoodsDamage = view.DAM_Goods_Damage,
                GoodsTypeCarried = view.DAM_Goods_Type,
                GoodsWeight = view.DAM_Goods_Weight,
                Injuries = view.DAM_Injuries,
                IsOLContributory = view.DAM_Is_OL_Contributory,
                IsOverLoaded = view.DAM_IsOverLoaded,
                OtherVehInvolved = view.DAM_OtherVeh_Involved,
                PossibleDR = view.DAM_PossibleDR,
                PossibleDR_Other = view.DAM_PossibleDR_Other,
                PreAccDamages = view.DAM_PreAccidentDamages,
                PreAccDamages_Other = view.DAM_PreAccidentDamages_Other,
                ThirdPartyDamages = view.DAM_ThirdParty_Damage,
                /*Set Properties from Enum */
                Tyre_FL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_FL_Status),
                Tyre_RLL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RLL_Status),
                Tyre_RLR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RLR_Status),
                Tyre_RRR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RRR_Status),
                Tyre_FR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_FR_Status),
                Tyre_RRL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RRL_Status),
            };
        }

        public static JobDamageModel ToJobDamagesObject(vw_SAFormDetails view)
        {
            return new JobDamageModel
            {
                VisitId = view.VisitId,
                Tyre_FL_Id = view.CON_Tyre_FL_Status,
                Tyre_RLL_Id = view.CON_Tyre_RLL_Status,
                Tyre_RLR_Id = view.CON_Tyre_RLR_Status,
                Tyre_RRR_Id = view.CON_Tyre_RRR_Status,
                Tyre_FR_Id = view.CON_Tyre_FR_Status,
                Tyre_RRL_Id = view.CON_Tyre_RRL_Status,               
                Tyre_IsContributory = view.CON_Tyre_IsContributory,
                DamagedItems = view.DAM_DamagedItems,
                DamagedItems_Other = view.DAM_DamagedItems_Other,
                GoodsDamage = view.DAM_Goods_Damage,
                GoodsTypeCarried = view.DAM_Goods_Type,
                GoodsWeight = view.DAM_Goods_Weight,
                Injuries = view.DAM_Injuries,
                IsOLContributory = view.DAM_Is_OL_Contributory,
                IsOverLoaded = view.DAM_IsOverLoaded,
                OtherVehInvolved = view.DAM_OtherVeh_Involved,
                PossibleDR = view.DAM_PossibleDR,
                PossibleDR_Other = view.DAM_PossibleDR_Other,
                PreAccDamages = view.DAM_PreAccidentDamages,
                PreAccDamages_Other = view.DAM_PreAccidentDamages_Other,
                ThirdPartyDamages = view.DAM_ThirdParty_Damage,
                /*Set Properties from Enum */
                Tyre_FL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_FL_Status),
                Tyre_RLL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RLL_Status),
                Tyre_RLR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RLR_Status),
                Tyre_RRR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RRR_Status),
                Tyre_FR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_FR_Status),
                Tyre_RRL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RRL_Status),
                /*Set Properties from Enum */
                Tyre_IsContributory_Val = (view.CON_Tyre_IsContributory != null && (bool)view.CON_Tyre_IsContributory) ? Confirmation.Yes.ToString() : Confirmation.No.ToString(),
                IsOLContributory_Val = (view.DAM_Is_OL_Contributory != null && (bool)view.DAM_Is_OL_Contributory) ? Confirmation.Yes.ToString() : Confirmation.No.ToString(),
                IsOverLoaded_Val = (view.DAM_IsOverLoaded != null && (bool)view.DAM_IsOverLoaded) ? Confirmation.Yes.ToString() : Confirmation.No.ToString()
            };
        }

        #endregion

        #region Other Details

        public static JobOtherModel ToJobOtherObject(vw_SAForm_OtherDetails view)
        {
            return new JobOtherModel
            {
                VisitId = view.VisitId,
                JourneyPurposeId = view.OTH_Journey_PurposeId,
                NearestPoliceStation = view.OTH_Nearest_PoliceStation,
                OnSiteEstimation = view.OTH_SiteEstimation,
                PavValue = view.OTH_PavValue,
                CsrConsistency = view.OTH_CSR_Consistency,
                ClaimProcessingBranchId = view.OTH_ProcessingBranchId,
             //   ClaimProcessingBranch = "test",
                /*Set Properties from Enum */
                JourneyPurpose = (view.OTH_Journey_PurposeId != null) ? Enum.GetName(typeof(JourneyPurpose), view.OTH_Journey_PurposeId) : null
            };
        }

        public static JobOtherModel ToJobOtherObject(vw_SAFormDetails view)
        {
            return new JobOtherModel
            {
                VisitId = view.VisitId,
                JourneyPurposeId = view.OTH_Journey_PurposeId,
                NearestPoliceStation = view.OTH_Nearest_PoliceStation,
                OnSiteEstimation = view.OTH_SiteEstimation,
                PavValue = view.OTH_PavValue,
                CsrConsistency = view.OTH_CSR_Consistency,
                ClaimProcessingBranchId = view.OTH_ProcessingBranchId,
                ClaimProcessingBranch = view.BranchName,
                CSRName = view.CSRFirstName + " " + view.CSRLastName,
                /*Set Properties from Enum */
                JourneyPurpose = (view.OTH_Journey_PurposeId != null) ? Enum.GetName(typeof(JourneyPurpose), view.OTH_Journey_PurposeId) : null,
                OnSiteEstimation_Val = (view.OTH_SiteEstimation != null) ? Enum.GetName(typeof(OnSiteEstimation), view.OTH_SiteEstimation) : null,
                CsrConsistency_Val = (view.OTH_CSR_Consistency != null) ? Enum.GetName(typeof(CSR_Consistency), view.OTH_CSR_Consistency) : null,

            };
        }

        #endregion

        #endregion

        #region Visits

        public static VisitDetailModel ToVisitObject(vw_VisitDetails view)
        {
            return new VisitDetailModel
            {
                JobNo = view.JobNo,
                VisitId = view.VisitId,
                VisitType = view.VisitType,
                InspectionType = EnumUtils.stringValueOf(typeof(VisitType), view.VisitType.ToString()),
                VisitedDate = view.TimeVisited,
                ChassisNo = view.ChassyNo,
                EngineNo = view.EngineNo,
                CreatedByFullName = view.CreatedByFullName,
                IsPrinted = view.IsPrinted,
                ImageCount = view.ImageCount
            };
        }
         
        public static VisitModel ToVisitObject(vw_Visits view)
        {
            return new VisitModel
            {
                JobNo = view.JobNo,
                VisitId = view.VisitId,
                VisitType = view.VisitType,
                InspectionType = EnumUtils.stringValueOf(typeof(VisitType), view.VisitType.ToString()),
                VisitedDate = view.TimeVisited,
                CreatedByFullName = view.CreatedByFullName,
                IsPrinted = view.IsPrinted,
                ImageCount = view.ImageCount
            };
        }

        #endregion

        #region Region and Branches

        public static RegionDataModel ToRegionObject(Region entity, bool getBranches)
        {
            return new RegionDataModel
            {
                RegionId = entity.RegionId,
                RegionName = entity.RegionName,
                RegionCode = entity.RegionCode,
                IsEnabled = entity.IsEnabled,
                IsDeleted = entity.IsDeleted,
                CreatedDate = entity.CreatedDate,
                CreatedBy = entity.CreatedBy,
                //Get Branches
                Branches = getBranches ? ToBranchListObject(entity.Branches) : null
            };
        }

        public static Region ToRegionEntity(RegionDataModel model)
        {
            return new Region
            {
                RegionId = model.RegionId,
                RegionName = model.RegionName,
                RegionCode = model.RegionCode,
                IsEnabled = model.IsEnabled,
                IsDeleted = model.IsDeleted,
                CreatedDate = model.CreatedDate,
                CreatedBy = model.CreatedBy
            };
        }

        public static BranchDataModel ToBranchObject(Branch entity)
        {
            return new BranchDataModel
            {
                BranchId = entity.BranchId,
                BranchName = entity.BranchName,
                BranchCode = entity.BranchCode,
                Address = entity.BranchAddress,
                IsEnabled = entity.IsEnabled,
                IsDeleted = entity.IsDeleted,
                RegionId = entity.RegionId,
                RegionName = entity.Region.RegionName,
                CreatedBy = entity.CreatedBy,
                CreatedDate = entity.CreatedDate,
            };
        }

        public static Branch ToBranchEntity(BranchDataModel model)
        {
            return new Branch
            {
                BranchId = model.BranchId,
                BranchName = model.BranchName,
                BranchCode = model.BranchCode,
                BranchAddress = model.Address,
                IsEnabled = model.IsEnabled,
                IsDeleted = model.IsDeleted,
                RegionId = model.RegionId,
                CreatedBy = model.CreatedBy,
                CreatedDate = model.CreatedDate,
            };
        }

        public static List<BranchDataModel> ToBranchListObject(IEnumerable<Branch> entities)
        {
            List<BranchDataModel> branchlist = new List<BranchDataModel>();

            foreach (var item in entities)
            {
                branchlist.Add(ToBranchObject(item));
            }

            return branchlist;
        }

        #endregion

        /*
          /// <summary>Convert job XML to Job Entity.</summary>
        /// <param name="jobXml">Job XML</param>
        ///<returns>
        ///JobEntity
        ///</returns>
        ///<exception cref="">
        ///Vehicle number cannot be null or empty
        ///no jobs found
        ///database errors
        ///xml parsing errors(XPATH not found)
        /// </exception>        
        /// <remarks></remarks> 
        /// 
        public static SLIC2.Models.EntityModel.Job ToJobEntity(XmlDocument jobXml)
        {
            try
            {
                int userId = 0;

                //sample job xml can be found at SampleXml\Jobs\AddJobRequest.xml
                XmlNode jobNode = jobXml.SelectSingleNode("/Request/Data/Job");
                //string no = jobNode.SelectSingleNode("FieldList/JobNo").Value;

                if (jobNode == null)
                {
                    throw new GenException(670, "Error on xml. Job node not found!");
                }

                SLIC2.Models.EntityModel.Job jobEntity = new EntityModel.Job();

                try
                {
                    using (SLICEntities context = DataObjectFactory.CreateContext())
                    {
                        string userName = jobNode.SelectSingleNode("FieldList/CSRUserName").InnerText;
                        jobEntity.CSR_UserName = userName;
                        IQueryable<int> userIds = from us in context.aspnet_Users
                                                  where us.UserName == userName
                                                  select (us.Users.FirstOrDefault().UserId);
                        userId = userIds.FirstOrDefault();
                    }
                }
                catch (Exception)
                {
                    throw new GenException(671, "Invalid CSR User Name. Please Login again with valid credentials!");
                }

                jobEntity.JobNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/JobNo").InnerText);
                jobEntity.Caller_Name = CheckEmptyString(jobNode.SelectSingleNode("FieldList/CallerName").InnerText);
                jobEntity.Caller_ContactNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/CallerContactNo").InnerText);
                jobEntity.Insured_Name = CheckEmptyString(jobNode.SelectSingleNode("FieldList/InsuredName").InnerText);
                jobEntity.Insured_ContactNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/InsuredContactNo").InnerText);
                try
                {
                    jobEntity.TimeReported = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/TimeReported").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/TimeReported").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Time Reported value.");
                }
                try
                {
                    jobEntity.TimeVisited = DateTime.Parse(jobNode.SelectSingleNode("FieldList/TimeVisited").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Time Visited value.");
                }

                jobEntity.VehicleNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/VehicleNo").InnerText.ToUpper());
                jobEntity.VehicleDescription = CheckEmptyString(jobNode.SelectSingleNode("FieldList/VehicleTypeColor").InnerText);
                jobEntity.Policy_CN_No = CheckEmptyString(jobNode.SelectSingleNode("FieldList/Policy_CoverNoteNo").InnerText);
                jobEntity.Policy_CN_SerialNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/Policy_CoverNoteSerialNo").InnerText);
                try
                {
                    jobEntity.Policy_CN_StartDate = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/from").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/from").InnerText);

                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Policy/ Cover Note Start Date.");
                }
                try
                {
                    jobEntity.Policy_CN_EndDate = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/to").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/to").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Policy/ Cover Note End Date.");
                }
                jobEntity.EngineNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/EngineNo").InnerText);
                jobEntity.ChassisNo = CheckEmptyString(jobNode.SelectSingleNode("FieldList/ChassisNo").InnerText);
                jobEntity.DriverName = CheckEmptyString(jobNode.SelectSingleNode("FieldList/DriverName").InnerText);
                jobEntity.DriverNIC = CheckEmptyString(jobNode.SelectSingleNode("FieldList/DriverNIC").InnerText);
                try
                {
                    jobEntity.DriverCompetence = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/DriverCompetence").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/DriverCompetence").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Driver Competence.");
                }
                try
                {
                    jobEntity.DriverRelationship = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/DriverRelationship").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/DriverRelationship").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Driver Relationship.");
                }
                jobEntity.Acc_Location = CheckEmptyString(jobNode.SelectSingleNode("FieldList/AccidentLocation").InnerText);
                try
                {
                    jobEntity.Acc_Time = DateTime.Parse(jobNode.SelectSingleNode("FieldList/AccidentTime").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Accident Time.");
                }
                try
                {
                    jobEntity.MeterReading = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/MeterReading").InnerText) ? (int?)null : int.Parse(jobNode.SelectSingleNode("FieldList/MeterReading").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Meter Reading.");
                }
                jobEntity.License_No = CheckEmptyString(jobNode.SelectSingleNode("FieldList/LicenceNo").InnerText);
                try
                {
                    jobEntity.License_ExpiryDate = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenceExpiryDate").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/LicenceExpiryDate").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid License Expiry Date.");
                }
                try
                {
                    jobEntity.License_TypeId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenceType").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/LicenceType").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid License Type.");
                }
                try
                {
                    jobEntity.License_IsNew = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenseNewOld/IsNew").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/LicenseNewOld/IsNew").InnerText));
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid License New/ Old value.");
                }
                //jobEntity.License_IsNewOld_TypeId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenseNewOld/Type").InnerText) ? (int?)null : int.Parse(jobNode.SelectSingleNode("FieldList/LicenseNewOld/Type").InnerText);
                jobEntity.CN_IssuedBy = CheckEmptyString(jobNode.SelectSingleNode("FieldList/CoverNoteIssuedBy").InnerText);
                jobEntity.CN_Reasons = CheckEmptyString(jobNode.SelectSingleNode("FieldList/CoverNoteReasons").InnerText);
                jobEntity.DamagedItems = HttpUtility.HtmlEncode(jobNode.SelectSingleNode("FieldList/DamagedItems").InnerXml);
                jobEntity.PossibleDR = HttpUtility.HtmlEncode(jobNode.SelectSingleNode("FieldList/PossibleDR").InnerXml);
                jobEntity.Goods_Damage = CheckEmptyString(jobNode.SelectSingleNode("FieldList/GoodsDamages").InnerText);
                jobEntity.Goods_Type = CheckEmptyString(jobNode.SelectSingleNode("FieldList/GoodsType").InnerText);
                try
                {
                    jobEntity.Goods_Weight = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/GoodsWeight").InnerText) ? (decimal?)null : decimal.Parse(jobNode.SelectSingleNode("FieldList/GoodsWeight").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Goods Weight value.");
                }
                jobEntity.Injuries = CheckEmptyString(jobNode.SelectSingleNode("FieldList/Injuries").InnerText);
                try
                {
                    jobEntity.Is_OL_Contributory = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/OverWeightContributory").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/OverWeightContributory").InnerText));

                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Is Over Load Contributory value.");
                }
                try
                {
                    jobEntity.IsOverLoaded = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/OverLoaded").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/OverLoaded").InnerText));
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Is Over Loaded.");
                }
                try
                {
                    jobEntity.Journey_PurposeId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/JourneyPurpose").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/JourneyPurpose").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Journey Purpose.");
                }        
                jobEntity.OtherVeh_Involved = CheckEmptyString(jobNode.SelectSingleNode("FieldList/OtherVehiclesInvolved").InnerText);
                try
                {
                    jobEntity.PavValue = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/PavValue").InnerText) ? (decimal?)null : decimal.Parse(jobNode.SelectSingleNode("FieldList/PavValue").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid PAV Value.");
                }
                try
                {
                    jobEntity.ProcessingBranchId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/ClaimProcessBranch").InnerText) ? (int?)null : int.Parse(jobNode.SelectSingleNode("FieldList/ClaimProcessBranch").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Claim Processing Branch.");
                }
                jobEntity.ThirdParty_Damage = CheckEmptyString(jobNode.SelectSingleNode("FieldList/ThirdPartyDamages").InnerText);

                try
                {
                    jobEntity.Tyre_FL_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/FL").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Tyre F/L Condition.");
                }
                try
                {
                    jobEntity.Tyre_FR_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/FR").InnerText);

                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Tyre F/R Condition.");
                }
                try
                {
                    jobEntity.Tyre_RLL_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RLL").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Tyre R/L/L Condition.");
                }
                try
                {
                    jobEntity.Tyre_RLR_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RLR").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Tyre R/L/R Condition.");
                }
                try
                {
                    jobEntity.Tyre_RRL_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RRL").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Tyre R/R/L Condition.");
                }
                try
                {
                    jobEntity.Tyre_RRR_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RRR").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Tyre R/R/R Condition.");
                }
                try
                {
                    jobEntity.Tyre_IsContributory = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/TyreContributory").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/TyreContributory").InnerText));
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid Is Tyre Contributory value.");
                }
                try
                {
                    jobEntity.CSR_Consistency = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/CSRConsistency").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/CSRConsistency").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid CSR Consistency.");
                }
                jobEntity.CSR_UserId = userId;

                //Feature asked by SLIC for adding comments - Release v2.0.0
                XmlNode commentNode = jobNode.SelectSingleNode("FieldList/Comment");

                if (commentNode != null)
                {
                    jobEntity.Comment = CheckEmptyString(commentNode.InnerText);
                }

                //START Release v2.1.0 Changes - Onsite Estimation and Approximate Repair Cost

                XmlNode siteEstNode = jobNode.SelectSingleNode("FieldList/SiteEstimation");
                if (siteEstNode != null)
                {
                    try
                    {
                        jobEntity.SiteEstimation = String.IsNullOrEmpty(siteEstNode.InnerText) ? (short?)null : short.Parse(siteEstNode.InnerText);
                    }
                    catch (Exception)
                    {
                        throw new GenException(672, "Please enter a valid On Site Estimation Value.");
                    }
                }

                XmlNode repairCostNode = jobNode.SelectSingleNode("FieldList/ApproxRepairCost");
                if (repairCostNode != null)
                {
                    try
                    {
                        jobEntity.Approx_RepairCost = String.IsNullOrEmpty(repairCostNode.InnerText) ? (decimal?)null : decimal.Parse(repairCostNode.InnerText);
                    }
                    catch (Exception)
                    {
                        throw new GenException(672, "Please enter a valid Approximate Repair Cost Value.");
                    }
                }

                XmlNode imageCountNode = jobNode.SelectSingleNode("FieldList/ImageCount");

                if (imageCountNode != null)
                {
                    try
                    {
                        jobEntity.ImageCount = String.IsNullOrEmpty(imageCountNode.InnerText) ? (short?)null : short.Parse(imageCountNode.InnerText);
                    }
                    catch (Exception)
                    {
                        //  throw new GenException(672, "Please select a valid CSR Consistency.");
                    }
                }
                //END Release v2.1.0 Changes

                // Phase 3 Changes

                // New Fields
                jobEntity.Nearest_PoliceStation = CheckEmptyString(jobNode.SelectSingleNode("FieldList/NearestPoliceStation").InnerText);

                XmlNode preAccNode = jobNode.SelectSingleNode("FieldList/PreAccidentDamages");

                if (preAccNode != null)
                {
                    jobEntity.PreAccidentDamages = HttpUtility.HtmlEncode(preAccNode.InnerXml);
                }
            
                XmlNode OtherPossibleDRNode = jobNode.SelectSingleNode("FieldList/OtherPossibleDR");

                if (OtherPossibleDRNode != null)
                {
                    jobEntity.PossibleDR_Other = CheckEmptyString(OtherPossibleDRNode.InnerText); ;
                }

                XmlNode OtherDamagedItemsNode = jobNode.SelectSingleNode("FieldList/OtherDamagedItems");

                if (OtherDamagedItemsNode != null)
                {
                    jobEntity.DamagedItems_Other = CheckEmptyString(OtherDamagedItemsNode.InnerText); ;
                }

                XmlNode OtherPreAccNode = jobNode.SelectSingleNode("FieldList/OtherPreAccidentDamages");

                if (OtherPreAccNode != null)
                {
                    jobEntity.PreAccidentDamages_Other = CheckEmptyString(OtherPreAccNode.InnerText); ;
                }

                XmlNode OrgTimeRepNode = jobNode.SelectSingleNode("FieldList/OriginalTimeReported");

                // 19-04-2012 
                // CR- Missed out
                if (OrgTimeRepNode != null)
                {
                    try
                    {
                        jobEntity.OriginalTimeReported = String.IsNullOrEmpty(OrgTimeRepNode.InnerText) ? (DateTime?)null : DateTime.Parse(OrgTimeRepNode.InnerText);
                    }
                    catch (Exception)
                    {
                        throw new GenException(672, "Original Time Reported is not in the correct format.");
                    }
                }

                //END Phase 3 Changes 

                XmlNodeList nodeList = jobNode.SelectNodes("FieldList/VehicleClass/class");

                try
                {
                    if (nodeList != null)
                    {
                        foreach (XmlNode node in nodeList)
                        {
                            Job_VehicleClasses jobVehicleEntity = new Job_VehicleClasses();
                            jobVehicleEntity.JobId = jobEntity.Id;
                            jobVehicleEntity.VehicleClassId = short.Parse(node.InnerText);
                            jobEntity.Job_VehicleClasses.Add(jobVehicleEntity);
                        }
                    }
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please select a valid set of  Vehicle Classes.");
                }

                return jobEntity;
            }
            catch (GenException)
            {
                throw;
            }
            catch (XmlException)
            {
                throw new GenException(901, "Error occurred while processing the xml.");
                //throw;
            }
            catch (SqlException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static SLIC2.Models.EntityModel.Job_ReSubmissions ToReSubmissionEntity(XmlDocument jobXml)
        {
            try
            {
                int userId = 0;

                //sample job xml can be found at SampleXml\Jobs\AddJobRequest.xml
                XmlNode jobNode = jobXml.SelectSingleNode("/Request/Data/Job");
                //string no = jobNode.SelectSingleNode("FieldList/JobNo").Value;

                if (jobNode == null)
                {
                    throw new GenException(670, "Error on xml. Job node not found!");
                }

                SLIC2.Models.EntityModel.Job_ReSubmissions jobEntity = new EntityModel.Job_ReSubmissions();
                jobEntity.TimeSubmited = DateTime.Now;

                #region CompulsoryXMLTags

                XmlNode userNameNode = jobNode.SelectSingleNode("FieldList/CSRUserName");
                if (userNameNode == null)
                {
                    throw new GenException(808, "User name not attached to the request. Please install a new version of the app.");
                }
                using (SLICEntities context = DataObjectFactory.CreateContext())
                {
                    try
                    {

                        string userName = userNameNode.InnerText;
                        IQueryable<int> userIds = from us in context.aspnet_Users
                                                  where us.UserName == userName
                                                  select (us.Users.FirstOrDefault().UserId);
                        userId = userIds.FirstOrDefault();
                        //jobEntity.CSR_UserId = userId;

                    }
                    catch (Exception)
                    {
                        throw new GenException(671, "Invalid CSR User Name. Please Login again with valid credentials!");
                    }

                    XmlNode jobNoNode = jobNode.SelectSingleNode("FieldList/JobNo");
                    if (jobNoNode == null)
                    { throw new GenException(808, "Job number not attached to the request. Please install a new version of the app."); }
                    jobEntity.JobNo = CheckEmptyString(jobNoNode.InnerText);
                    //if (string.IsNullOrWhiteSpace(jobEntity.JobNo))
                    //{
                    //    jobEntity.JobNo = jobEntity.JobNo.ToUpper();
                    //}
                    SLIC2.Models.EntityModel.Job originalJob = context.Jobs.Where(j => j.JobNo == jobEntity.JobNo).SingleOrDefault();

                    if (originalJob == null)
                    {
                        throw new GenException(808, "Job not found!");
                    }
                    jobEntity.JobId = originalJob.Id;
                }
                XmlNode refNoNode = jobNode.SelectSingleNode("FieldList/RefNo");
                if (refNoNode == null)
                {
                    throw new GenException(808, "Job reference number not attached to the request. Please install a new version of the app.");
                }
                try
                {
                    jobEntity.RefNo = int.Parse(refNoNode.InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Invalid Ref No.");
                }

                XmlNode timeVisitedNode = jobNode.SelectSingleNode("FieldList/TimeVisited");
                if (timeVisitedNode == null)
                { throw new GenException(808, "Time visited not attached to the request. Please install a new version of the app."); }
                try
                {
                    jobEntity.TimeVisited = DateTime.Parse(timeVisitedNode.InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(672, "Please enter a valid Time Visited value.");
                }

                jobEntity.CSR_UserId = userId;

                XmlNode commentNode = jobNode.SelectSingleNode("FieldList/Comment");

                if (commentNode == null)
                {
                    throw new GenException(808, "Comment not attached to the request. Please install a new version of the app.");
                }
                jobEntity.Comment = CheckEmptyString(commentNode.InnerText);

                #endregion CompulsoryXMLTags

                #region OptionalXMLTags

                XmlNode submissionTypeNode = jobNode.SelectSingleNode("FieldList/SubmissionType");
                if (submissionTypeNode != null)
                {
                    try
                    {
                        jobEntity.SubmissionType = CheckEmptyString(submissionTypeNode.InnerText);
                    }
                    catch (Exception)
                    {
                        //  throw new GenException(672, "Please select a valid CSR Consistency.");
                    }
                }

                XmlNode imageCountNode = jobNode.SelectSingleNode("FieldList/ImageCount");
                if (imageCountNode != null)
                {
                    try
                    {
                        jobEntity.ImageCount = String.IsNullOrEmpty(imageCountNode.InnerText) ? (short)0 : short.Parse(imageCountNode.InnerText);
                    }
                    catch (Exception)
                    {
                        //  throw new GenException(672, "Please select a valid CSR Consistency.");
                    }
                }

                #endregion OptionalXMLTags

                return jobEntity;
            }
            catch (GenException)
            {
                throw;
            }
            catch (XmlException)
            {
                throw new GenException(901, "Error occurred while processing the xml.");
                //throw;
            }
            catch (SqlException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }
       

        /// <summary>Check and Trim the innertext of the xml node. </summary>
        /// <param name="innertext">innertext</param>
        ///<returns>
        ///trimmed innertext
        ///</returns>      
        /// <remarks></remarks> 
        private static string CheckEmptyString(string innertext)
        {
            if (!String.IsNullOrWhiteSpace(innertext))
            {
                return innertext.Trim();
            }
            return null;
        }

        /// <summary>getInnerTextt from the xml node. </summary>
        ///<returns>
        ///trimmed innertext
        ///</returns>      
        /// <remarks>This method is still not used</remarks> 
        private static string getInnerText(XmlNode jobNode, string xpath)
        {
            XmlNode node = jobNode.SelectSingleNode(xpath);

            if (node == null)
            {
                return null;
            }

            if (!String.IsNullOrWhiteSpace(node.InnerText))
            {
                return node.InnerText.Trim();
            }
            return null;
        }

        /// <summary>Convert job entity values to dictionary list values.</summary>
        ///<param name="entity">Job Entity</param>
        ///<returns>
        ///ListDictionary containing the tags and it's values
        ///</returns>      
        /// <remarks>
        /// This result of this method is used for generating the body string of the email.
        /// The template is Content\templates\jobEmailTemplate.txt
        /// </remarks> 
        public static ListDictionary JobToDictionaryValues(SLIC2.Models.EntityModel.Job entity)
        {
            ListDictionary replacements = new ListDictionary();
            replacements.Add("<%JobNo%>", getStringValue(entity.JobNo));
            replacements.Add("<%Caller_Name%>", getStringValue(entity.Caller_Name));
            replacements.Add("<%Caller_ContactNo%>", getStringValue(entity.Caller_ContactNo));
            replacements.Add("<%Insured_Name%>", getStringValue(entity.Insured_Name));
            replacements.Add("<%Insured_ContactNo%>", getStringValue(entity.Insured_ContactNo));
            replacements.Add("<%TimeReported%>", getStringValue(entity.TimeReported));
            replacements.Add("<%TimeVisited%>", getStringValue(entity.TimeVisited));
            replacements.Add("<%VehicleNo%>", getStringValue(entity.VehicleNo));
            replacements.Add("<%VehicleDescription%>", getStringValue(entity.VehicleDescription));
            replacements.Add("<%Policy_CN_No%>", getStringValue(entity.Policy_CN_No));
            replacements.Add("<%Policy_CN_SerialNo%>", getStringValue(entity.Policy_CN_SerialNo));
            replacements.Add("<%Policy_CN_StartDate%>", getStringValue(entity.Policy_CN_StartDate));
            replacements.Add("<%Policy_CN_EndDate%>", getStringValue(entity.Policy_CN_EndDate));
            replacements.Add("<%EngineNo%>", getStringValue(entity.EngineNo));
            replacements.Add("<%ChassisNo%>", getStringValue(entity.ChassisNo));
            replacements.Add("<%DriverName%>", getStringValue(entity.DriverName));
            replacements.Add("<%DriverNIC%>", getStringValue(entity.DriverNIC));
            replacements.Add("<%DriverCompetence%>", (entity.DriverCompetence != null) ? Enum.GetName(typeof(SLIC2.Models.Enums.Confirmation), entity.DriverCompetence) : string.Empty);
            replacements.Add("<%DriverRelationship%>", getStringValue(entity.DriverRelationshipEnum.Value));
            replacements.Add("<%Acc_Location%>", getStringValue(entity.Acc_Location));
            replacements.Add("<%Acc_Time%>", getStringValue(entity.Acc_Time));
            replacements.Add("<%MeterReading%>", getStringValue(entity.MeterReading));
            replacements.Add("<%License_No%>", getStringValue(entity.License_No));
            replacements.Add("<%License_ExpiryDate%>", getStringValue(entity.License_ExpiryDate));
            replacements.Add("<%License_Type%>", (entity.License_TypeId != null) ? Enum.GetName(typeof(SLIC2.Models.Enums.LicenseType), entity.License_TypeId) : string.Empty);
            replacements.Add("<%License_IsNew%>", (entity.License_IsNew != null) ? (((bool)entity.License_IsNew) ? "New" : "Old") : null);
            replacements.Add("<%CN_IssuedBy%>", getStringValue(entity.CN_IssuedBy));
            replacements.Add("<%CN_Reasons%>", getStringValue(entity.CN_Reasons));
            replacements.Add("<%Goods_Damage%>", getStringValue(entity.Goods_Damage));
            replacements.Add("<%Goods_Type%>", getStringValue(entity.Goods_Type));
            replacements.Add("<%Goods_Weight%>", getStringValue(entity.Goods_Weight));
            replacements.Add("<%Injuries%>", getStringValue(entity.Injuries));
            replacements.Add("<%Is_OL_Contributory%>", (entity.Is_OL_Contributory != null) ? (((bool)entity.Is_OL_Contributory) ? "Yes" : "No") : null);
            replacements.Add("<%IsOverLoaded%>", (entity.IsOverLoaded != null) ? (((bool)entity.IsOverLoaded) ? "Yes" : "No") : null);
            replacements.Add("<%Journey_PurposeId%>", getStringValue(entity.Journey_Purpose.Value));
            replacements.Add("<%Nearest_PoliceStation%>", getStringValue(entity.Nearest_PoliceStation));
            replacements.Add("<%OtherVeh_Involved%>", getStringValue(entity.OtherVeh_Involved));
            replacements.Add("<%PavValue%>", getStringValue(entity.PavValue));
            replacements.Add("<%ProcessingBranchId%>", getStringValue(CultureInfo.CurrentCulture.TextInfo.ToTitleCase(entity.ClaimProcessingBranch.BranchName.ToLower())));
            replacements.Add("<%ThirdParty_Damage%>", getStringValue(entity.ThirdParty_Damage));
            replacements.Add("<%Tyre_FL_Status%>", getStringValue(entity.Tyre_FL_Status_Enum.Value));
            replacements.Add("<%Tyre_FR_Status%>", getStringValue(entity.Tyre_FR_Status_Enum.Value));
            replacements.Add("<%Tyre_RLL_Status%>", getStringValue(entity.Tyre_RLL_Status_Enum.Value));
            replacements.Add("<%Tyre_RLR_Status%>", getStringValue(entity.Tyre_RLR_Status_Enum.Value));
            replacements.Add("<%Tyre_RRL_Status%>", getStringValue(entity.Tyre_RRL_Status_Enum.Value));
            replacements.Add("<%Tyre_RRR_Status%>", getStringValue(entity.Tyre_RRR_Status_Enum.Value));
            replacements.Add("<%Tyre_IsContributory%>", (entity.Tyre_IsContributory != null) ? (((bool)entity.Tyre_IsContributory) ? "Yes" : "No") : null);
            replacements.Add("<%CSR_Consistency%>", (entity.CSR_Consistency != null) ? Enum.GetName(typeof(SLIC2.Models.Enums.CSR_Consistency), entity.CSR_Consistency) : string.Empty);
            replacements.Add("<%Comment%>", getStringValue(entity.Comment));
            replacements.Add("<%CSR_UserName%>", getStringValue(entity.User.aspnet_Users.UserName));
            replacements.Add("<%Approx_RepairCost%>", getStringValue(entity.Approx_RepairCost));
            replacements.Add("<%SiteEstimation%>", entity.SiteEstimation != null ? Enum.GetName(typeof(SLIC2.Models.Enums.OnSiteEstimation), entity.SiteEstimation) : string.Empty);

            //Other Fields
            replacements.Add("<%PossibleDR_Other%>", getStringValue(entity.PossibleDR_Other));
            replacements.Add("<%DamagedItems_Other%>", getStringValue(entity.DamagedItems_Other));
            replacements.Add("<%PreAccDamages_Other%>", getStringValue(entity.PreAccidentDamages_Other));
            // replacements.Add("<%CN_Reasons_Other%>", getStringValue(entity.CN_Reasons_Other));

            JobController jobController = new JobController();
            //Process Damaged Items

            String damagedItemString = HttpUtility.HtmlDecode(getStringValue(entity.DamagedItems));

            damagedItemString = "<DamagedItems>" + damagedItemString + "</DamagedItems>";
            XmlDocument damagedItemsDoc = new XmlDocument();
            try
            {
                damagedItemsDoc.LoadXml(damagedItemString);
                //returns an ArrayList of DamagedItems
                entity.DamagedItemsList = jobController.ProcessDamagedItemsXML(damagedItemsDoc);
                StringBuilder sbDamagedItems = new StringBuilder();
                sbDamagedItems.Append("\n");
                foreach (string[] item in entity.DamagedItemsList)
                {
                    sbDamagedItems.Append(String.Join(" > ", item) + "\n");
                }
                replacements.Add("<%DamagedItems%>", HttpUtility.HtmlDecode(sbDamagedItems.ToString()));
            }
            catch (Exception)
            {
                replacements.Add("<%DamagedItems%>", HttpUtility.HtmlDecode(getStringValue(entity.DamagedItems)));
            }

            //Process Possible DR
            string possibleDRString = HttpUtility.HtmlDecode(getStringValue(entity.PossibleDR));
            XmlDocument possibleDRDoc = new XmlDocument();
            possibleDRString = "<PossibleDR>" + possibleDRString + "</PossibleDR>";

            try
            {
                possibleDRDoc.LoadXml(possibleDRString);
                entity.PossibleDRList = jobController.ProcessPossibleDRXML(possibleDRDoc);
                if (entity.PossibleDRList.Length > 0)
                {
                    replacements.Add("<%PossibleDR%>", String.Join(",", entity.PossibleDRList));
                }
                else
                {
                    replacements.Add("<%PossibleDR%>", string.Empty);
                }
            }
            catch (Exception)
            {
                // throw new GenException(624, "Possible xml is not in the correct format.");
                replacements.Add("<%PossibleDR%>", HttpUtility.HtmlDecode(getStringValue(entity.PossibleDR)));
            }


            //Process Vehicle classes
            StringBuilder vehicleClasses = new StringBuilder();

            if (entity.License_IsNew != null)
            {
                entity.VehicleClassIds = entity.Job_VehicleClasses.Select(x => x.VehicleClassId).ToList();

                foreach (short id in entity.VehicleClassIds)
                {
                    if ((bool)entity.License_IsNew)
                    {
                        vehicleClasses.Append(Enum.GetName(typeof(SLIC2.Models.Enums.NewLicenseVehClasses), id));
                        vehicleClasses.Append(",");
                    }
                    else
                    {
                        vehicleClasses.Append(Enum.GetName(typeof(SLIC2.Models.Enums.OldLicenseVehClasses), id));
                        vehicleClasses.Append(",");
                    }
                }
            }

            if (vehicleClasses.Length > 0)
            {
                char finalchar = vehicleClasses[vehicleClasses.Length - 1];

                if (finalchar.Equals(','))
                    vehicleClasses = vehicleClasses.Remove(vehicleClasses.Length - 1, 1);
            }

            replacements.Add("<%VehicleClasses%>", vehicleClasses.ToString());

            //Process Pre-Accident Damaged Items

            String PreDamagedItemString = HttpUtility.HtmlDecode(getStringValue(entity.PreAccidentDamages));

            PreDamagedItemString = "<PreAccidentDamages>" + PreDamagedItemString + "</PreAccidentDamages>";
            XmlDocument PreDamagedItemsDoc = new XmlDocument();
            try
            {
                PreDamagedItemsDoc.LoadXml(PreDamagedItemString);
                //returns an ArrayList of DamagedItems
                entity.PreAccDamagesItemsList = jobController.ProcessPreDamagedItemsXML(PreDamagedItemsDoc);
                StringBuilder sbPreDamagedItems = new StringBuilder();
                sbPreDamagedItems.Append("\n");
                foreach (string[] item in entity.PreAccDamagesItemsList)
                {
                    sbPreDamagedItems.Append(String.Join(" > ", item) + "\n");
                }
                replacements.Add("<%PreAccDamages%>", HttpUtility.HtmlDecode(sbPreDamagedItems.ToString()));
            }
            catch (Exception)
            {
                replacements.Add("<%PreAccDamages%>", HttpUtility.HtmlDecode(getStringValue(entity.PreAccidentDamages)));
            }
            return replacements;
        }

        /// <summary>Convert job entity values to dictionary list values.</summary>
        ///<param name="entity">Job Entity</param>
        ///<returns>
        ///ListDictionary containing the tags and it's values
        ///</returns>      
        /// <remarks>
        /// This result of this method is used for generating the body string of the email.
        /// The template is Content\templates\jobEmailTemplate.txt
        /// </remarks> 
        public static ListDictionary ReSubmissionToDictionaryValues(SLIC2.Models.EntityModel.Job_ReSubmissions entity)
        {

            try
            {
                ListDictionary replacements = new ListDictionary();
                replacements.Add("<%JobNo%>", getStringValue(entity.JobNo));
                replacements.Add("<%TimeVisited%>", getStringValue(entity.TimeVisited));
                replacements.Add("<%Comment%>", getStringValue(entity.Comment));
                replacements.Add("<%CSR_UserName%>", getStringValue(entity.CSR_UserName));
                replacements.Add("<%TimeSubmitted%>", getStringValue(entity.TimeSubmited));
                replacements.Add("<%SubmissionType%>", getStringValue(entity.SubmissionType));
                return replacements;
            }
            catch (Exception)   
            {
                throw new GenException(111, "Error occurred on mapper"); ;
            }
        }

        /// <summary>get string value of any job field. This is used by ModelToDictionaryValues() for email purposes.</summary>
        /// <param name="jobfield"> any job field</param>
        ///<returns>
        ///string value of any field.
        ///</returns>      
        /// <remarks>
        /// This is the inverse of getInnerTextMethod
        /// </remarks> 
        private static string getStringValue(object jobfield)
        {
            if (jobfield == null)
            {
                return string.Empty;
            }
            else
            {
                return jobfield.ToString();
            }
        }
        */

    }
}