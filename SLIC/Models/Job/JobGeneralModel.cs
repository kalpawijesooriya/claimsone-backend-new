/***************************************************************************/
/// <summary>
///  <title>SLIC JobGeneralModel</title>
///  <description>General Job Details</description>
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
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.Visit;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobGeneralModel : VisitModel
    {

        #region Constructors

        public JobGeneralModel()
        {
        }

        public JobGeneralModel(vw_SAForm_General view)
        {
            this.VisitId = view.VisitId;
            this.JobNo = view.JobNo;
            this.VehicleNo = view.GEN_VehicleNo;
            this.AccidentDateTime = view.GEN_Acc_Time;
            this.CallerName = view.GEN_Caller_Name;
            this.CreatedBy = view.CreatedBy;
            this.CsrCode = view.Code;
            this.ApproximateCostOfRepair = view.OTH_Approx_RepairCost;
            this.IsPrinted = view.IsPrinted;
            this.IsOriginal = view.IsOriginal;
        }

        public JobGeneralModel(vw_SAFormDetails view)
            : base(view)
        {
            // this.VisitId = view.VisitId;
            // this.JobNo = view.JobNo;
            this.VehicleNo = view.GEN_VehicleNo;
            this.AccidentDateTime = view.GEN_Acc_Time;
            this.AccidentLocation = view.GEN_Acc_Location;
            this.CallerName = view.GEN_Caller_Name;
            this.CallerContactNo = view.GEN_Caller_ContactNo;
            this.InsuredContactNo = view.GEN_Insured_ContactNo;
            this.InsuredName = view.GEN_Insured_Name;
            this.TimeReported = (DateTime?)view.GEN_TimeReported;
            this.OriginalTimeReported = (DateTime?)view.GEN_OriginalTimeReported;
            this.VehicleDescription = view.GEN_VehicleDescription;
            this.ApproximateCostOfRepair = view.OTH_Approx_RepairCost;

            try
            {
                this.VehicleType = int.Parse(view.DAM_DamagedItems.Split(',').FirstOrDefault().Split('/').FirstOrDefault());
            }
            catch (Exception)
            {
                this.VehicleType = 0;
            }
            //this.IsPrinted = view.IsPrinted;
        }

        public JobGeneralModel(vw_SAFormDetails view, List<vw_ImageGallery> images)
            : base(view, images)
        {
            // this.VisitId = view.VisitId;
            // this.JobNo = view.JobNo;
            this.VehicleNo = view.GEN_VehicleNo;
            this.AccidentDateTime = view.GEN_Acc_Time;
            this.AccidentLocation = view.GEN_Acc_Location;
            this.CallerName = view.GEN_Caller_Name;
            this.CallerContactNo = view.GEN_Caller_ContactNo;
            this.InsuredContactNo = view.GEN_Insured_ContactNo;
            this.InsuredName = view.GEN_Insured_Name;
            this.TimeReported = (DateTime?)view.GEN_TimeReported;
            this.OriginalTimeReported = (DateTime?)view.GEN_OriginalTimeReported;
            this.VehicleDescription = view.GEN_VehicleDescription;
            this.ApproximateCostOfRepair = view.OTH_Approx_RepairCost;


            //20161219
            //if (images != null)
            //{
                
            //    foreach (var item in images)
            //    {
            //        this.ImageCategories.Add(new ImageCategoryModel
            //        {
            //            ImageTypeId = item.ImageId,
            //            ImageType = item.ImagePath,
                        
            //        });

            //        //{ ImageId = item.ImageId, ImageName = item.ImageName,ImagePath = item.ImagePath}
            //    }
                
            //}
            
            try
            {
                this.VehicleType = int.Parse(view.DAM_DamagedItems.Split(',').FirstOrDefault().Split('/').FirstOrDefault());
            }
            catch (Exception)
            {
                this.VehicleType = 0;
            }
            // this.IsPrinted = view.IsPrinted;        
        }


        #endregion

        #region Properties

        public string VehicleNo { get; set; }

        public string CallerName { get; set; }

        public string CallerContactNo { get; set; }

        public DateTime? TimeReported { get; set; }

        public DateTime? OriginalTimeReported { get; set; }

        public string InsuredName { get; set; }

        public string InsuredContactNo { get; set; }

        public string VehicleDescription { get; set; }

        public DateTime AccidentDateTime { get; set; }

        public string AccidentLocation { get; set; }

        public string CsrCode { get; set; }

        public decimal? ApproximateCostOfRepair { get; set; }

        public int VehicleType { get; set; }

        #endregion
    }
}