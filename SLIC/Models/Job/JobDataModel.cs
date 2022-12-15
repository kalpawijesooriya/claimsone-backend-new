/***************************************************************************/
/// <summary>
///  <title>SLIC JobDataModel</title>
///  <description>JobData Model for All Job Details</description>
///  <copyRight>Copyright (c) 2010</copyRight>
///  <company>IronOne Technologies (Pvt) Ltd</company>
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
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Administration;

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobDataModel
    {
        public JobDataModel()
        {
            //GeneralModel = new JobGeneralModel();
            //VehDriverModel = new JobVehDriverModel();
            //PolicyModel = new JobPolicyModel();
            //DamagesModel = new JobDamageModel();
            //OtherModel = new JobOtherModel(); 
        }

        public JobDataModel(vw_SAFormDetails view)
        {
            GeneralModel = new JobGeneralModel(view);
            VehDriverModel = new JobVehDriverModel(view);
            PolicyModel = new JobPolicyModel(view);
            DamagesModel = new JobDamageModel(view);
            OtherModel = new JobOtherModel(view);
        }

        public JobDataModel(vw_SAFormDetails view,List<vw_ImageGallery> images)
        {
            GeneralModel = new JobGeneralModel(view, images);
            VehDriverModel = new JobVehDriverModel(view);
            PolicyModel = new JobPolicyModel(view);
            DamagesModel = new JobDamageModel(view);
            OtherModel = new JobOtherModel(view);
            //userModel= new UserDataModel
        }


        public JobGeneralModel GeneralModel { get; set; }
        public JobVehDriverModel VehDriverModel { get; set; }
        public JobPolicyModel PolicyModel { get; set; }
        public JobDamageModel DamagesModel { get; set; }
        public JobOtherModel OtherModel { get; set; }
    }
}