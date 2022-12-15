using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.ComponentModel.DataAnnotations;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Administration
{
    /// <summary>
    ///  <title>Region Business Object</title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-18</createdOn>
    ///  <author>Aruna Herath</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification> 
    /// </summary>
    public class RegionDataModel
    {      
        public RegionDataModel()
        {
        }

        public RegionDataModel(RegionEntity entity, bool getBranches)
        {
            this.RegionId = entity.RegionId;
            this.RegionName = entity.RegionName;
            this.RegionCode = entity.RegionCode;
            this.IsEnabled = entity.IsEnabled;
            this.IsDeleted = entity.IsDeleted;
            this.CreatedDate = entity.CreatedDate;
            this.CreatedBy = entity.CreatedBy;
            //Get Branches
            this.Branches = new List<BranchDataModel>();

            if (getBranches)
            {
                foreach (var item in entity.Branches)
                {
                    Branches.Add(new BranchDataModel(item));
                }
            }

        }  


        #region Properties

        public int RegionId { get; set; }

        [Required]
        [DisplayName("region code")]
        public string RegionCode { get; set; }

        [Required]
        [DisplayName("region name")]
        public string RegionName { get; set; }

        public bool IsEnabled { get; set; }

        public bool IsDeleted { get; set; }

        public List<BranchDataModel> Branches { get; set; }

        //region tracking
        public DateTime CreatedDate { get; set; }

        public int CreatedBy { get; set; }

        public DateTime UpdatedDate { get; set; }

        public int UpdatedBy { get; set; }

        public DateTime DeletedDate { get; set; }
        //endregion tracking   

        #endregion Properties

        public RegionEntity ToRegionEntity()
        {
            return new RegionEntity
            {
                RegionId = this.RegionId,
                RegionName = this.RegionName,
                RegionCode = this.RegionCode,
                IsEnabled = this.IsEnabled,
                IsDeleted = this.IsDeleted,
                CreatedDate = this.CreatedDate,
                CreatedBy = this.CreatedBy
            };
        }

    }
}