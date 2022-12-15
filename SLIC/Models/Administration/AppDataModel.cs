using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using com.IronOne.SLIC2.Models.EntityModel;
using System.Globalization;

namespace com.IronOne.SLIC2.Models.Administration
{
    /// <summary>
    ///  <title>AppData Business Object</title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2016-12-08</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification> 
    /// </summary>
    public class AppDataModel
    {
        public AppDataModel()
        {
        }

        public AppDataModel(SettingEntity entity) /*BranchEntity entity*/
        {
            //this.SettingId = entity.SettingId;
            //this.SettingName = entity.SettingName;
            //this.SettingValue = entity.SettingValue;            
        }

        #region Properties

        [Required]
        [DisplayName("Current Web Version")]
        public string CurrentWebVersion { get; set; }

        [Required]
        [DisplayName("Minimum Supported App Version")]
        public string MinimumSupportedAppVersion { get; set; }

        [Required]
        [DisplayName("Latest App Version in Google Play")]
        public string LatestAppVersioninGooglePlay { get; set; }

        [Required]
        [DisplayName("Force Latest Version to Users")]
        public bool ForceLatestVersionToUsers { get; set; }

        [Required]
        [DisplayName("Google Play App URL")]
        public string GooglePlayAppURL { get; set; }

        [Required]
        [DisplayName("Maximum Allowed Drafts Count")]
        public string MaximumAllowedDraftsCount { get; set; }

        #endregion Properties

        #region PublicMethods

        public SettingEntity ToSettingEntity()
        {
            return new SettingEntity
            {
                //SettingId = this.SettingId,
                //SettingName = this.SettingName,
                //SettingValue = this.SettingValue                
            };
        }

        #endregion PublicMethods
    }   
}