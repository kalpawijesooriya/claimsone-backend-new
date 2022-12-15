/***************************************************************************/
/// <summary>
///  <title>SLIC JobOtherModel</title>
///  <description>Job Other Details</description>
///  <copyRight>Copyright (c) 2012</copyRight>
///  <company>IronOne Technologies (Pvt)Ltd</company>
///  <createdOn>2013-01-07</createdOn>
///  <author>Suren Manawatta</author>
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
using com.IronOne.SLIC2.Models.EntityModel;
//using com.IronOne.SLIC2.Models.Administration.UserDataModel;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.IronUtils;

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobOtherModel
    {
        #region Constructors

        public JobOtherModel()
        {
        }

        public JobOtherModel(vw_SAForm_OtherDetails view)
        {
            this.VisitId = view.VisitId;
            this.JourneyPurposeId = view.OTH_Journey_PurposeId;
            this.NearestPoliceStation = view.OTH_Nearest_PoliceStation;
            this.OnSiteEstimation = view.OTH_SiteEstimation;
            this.PavValue = view.OTH_PavValue;
            this.CsrConsistency = view.OTH_CSR_Consistency;
            this.ClaimProcessingBranchId = view.OTH_ProcessingBranchId;
            
            /*Set Properties from Enum */
            this.JourneyPurpose = (view.OTH_Journey_PurposeId != null) ? Enum.GetName(typeof(JourneyPurpose), view.OTH_Journey_PurposeId) : null;
        }

        public JobOtherModel(vw_SAFormDetails view)
        {
            this.VisitId = view.VisitId;
            this.JourneyPurposeId = view.OTH_Journey_PurposeId;
            this.NearestPoliceStation = view.OTH_Nearest_PoliceStation;
            this.OnSiteEstimation = view.OTH_SiteEstimation;
            this.PavValue = view.OTH_PavValue;
            this.CsrConsistency = view.OTH_CSR_Consistency;
            this.ClaimProcessingBranchId = view.OTH_ProcessingBranchId;
            this.ClaimProcessingBranch = view.BranchName;
            this.CSRName = view.CSRFirstName + " " + view.CSRLastName;
            this.ContactNo = view.ContactNo;
            this.PrintedBranch = view.PrintedBranch;
            this.PrintedDate = view.PrintedDate;
            this.FurtherReview = view.Further_Review_isRequired;
            
            
            /*Set Properties from Enum */
            this.JourneyPurpose = (view.OTH_Journey_PurposeId != null) ? EnumUtils.stringValueOf(typeof(JourneyPurpose), view.OTH_Journey_PurposeId.ToString()) : null;
            this.OnSiteEstimation_Val = (view.OTH_SiteEstimation != null) ? EnumUtils.stringValueOf(typeof(OnSiteEstimation), view.OTH_SiteEstimation.ToString()) : null;
            this.CsrConsistency_Val = (view.OTH_CSR_Consistency != null) ? EnumUtils.stringValueOf(typeof(CSR_Consistency), view.OTH_CSR_Consistency.ToString()) : null;
        }



        #endregion

        #region Properties
        public int VisitId { get; set; }

        public decimal? PavValue { get; set; }

        public short? CsrConsistency { get; set; }

        public short? OnSiteEstimation { get; set; }

        public short? JourneyPurposeId { get; set; }

        public string NearestPoliceStation { get; set; }

        public int? ClaimProcessingBranchId { get; set; }

        public string CSRName { get; set; }

        public string ContactNo { get; set; }

        public string PrintedBranch { get; set; }

        public DateTime? PrintedDate { get; set; }

        public bool? FurtherReview { get; set; }        

        //Extra String Properties

        public string JourneyPurpose { get; set; }

        public string ClaimProcessingBranch { get; set; }

        public string CsrConsistency_Val { get; set; }

        public string OnSiteEstimation_Val { get; set; }

        //public string ApproximateCostOfRepair { get; set; }
        #endregion
    }
}