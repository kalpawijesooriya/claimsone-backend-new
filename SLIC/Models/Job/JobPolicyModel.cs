/***************************************************************************/
/// <summary>
///  <title>SLIC JobPolicyModel</title>
///  <description>Job Policy Details</description>
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

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobPolicyModel
    {
        #region Constructors
        public JobPolicyModel(){
        }

        public JobPolicyModel(vw_SAForm_PolicyDetails view)
        {
              this.VisitId = view.VisitId;
              this.PolicyCoverNoteNo = view.POL_Policy_CN_No;
              this.PolicyCoverNoteIssuedBy = view.POL_CN_IssuedBy;
              this.PolicyCoverNoteSerialNo = view.POL_Policy_CN_SerialNo;
              this.PolicyCoverNoteReasons = view.POL_CN_Reasons;
              this.PolicyCoverNoteStartDate = view.POL_Policy_CN_StartDate;
              this.PolicyCoverNoteEndDate = view.POL_Policy_CN_EndDate;
        }

        public JobPolicyModel(vw_SAFormDetails view)
        {
            this.VisitId = view.VisitId;
            this.PolicyCoverNoteNo = view.POL_Policy_CN_No;
            this.PolicyCoverNoteIssuedBy = view.POL_CN_IssuedBy;
            this.PolicyCoverNoteSerialNo = view.POL_Policy_CN_SerialNo;
            this.PolicyCoverNoteReasons = view.POL_CN_Reasons;
            this.PolicyCoverNoteStartDate = view.POL_Policy_CN_StartDate;
            this.PolicyCoverNoteEndDate = view.POL_Policy_CN_EndDate;
        }

        #endregion

        #region Properties
        public int VisitId { get; set; }

        public string PolicyCoverNoteNo { get; set; }

        public DateTime? PolicyCoverNoteStartDate { get; set; }

        public DateTime? PolicyCoverNoteEndDate { get; set; }

        public string PolicyCoverNoteSerialNo { get; set; }

        public string PolicyCoverNoteIssuedBy { get; set; }

        public string PolicyCoverNoteReasons { get; set; }
        #endregion
    }
}