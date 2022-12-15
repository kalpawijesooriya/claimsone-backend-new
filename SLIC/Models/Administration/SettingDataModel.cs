using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.EntityModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace com.IronOne.SLIC2.Models.Administration
{
    /// <summary>
    ///  <title>Setting Business Object</title>
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
    public class SettingDataModel
    {
        public SettingDataModel()
        {
        }

        public SettingDataModel(SettingEntity entity) /*BranchEntity entity*/
        {
            this.SettingId = entity.SettingId;
            this.SettingName = entity.SettingName;
            this.SettingValue = entity.SettingValue;            
        }

        #region Properties
        
        [DisplayName("Setting Id")]
        public int SettingId { get; set; }

        [Required]
        [DisplayName("Setting Name")]
        public string SettingName { get; set; }
                
        [DisplayName("Setting Value")]
        public string SettingValue { get; set; }
       
        #endregion Properties

        #region PublicMethods

        public SettingEntity ToSettingEntity()
        {
            return new SettingEntity
            {
                SettingId = this.SettingId,
                SettingName = this.SettingName,
                SettingValue = this.SettingValue                
            };
        }

        #endregion PublicMethods
    }
}