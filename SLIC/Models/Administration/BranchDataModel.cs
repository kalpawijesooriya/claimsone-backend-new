using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Administration
{
    /// <summary>
    ///  <title>Branch Business Object</title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2012-mm-dd</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification> 
    /// </summary>
    public class BranchDataModel
    {
        public BranchDataModel()
        {
        }

        public BranchDataModel(BranchEntity entity)
        {
            this.BranchId = entity.BranchId;
            this.BranchName = entity.BranchName;
            this.BranchCode = entity.BranchCode;
            this.Address = entity.BranchAddress;
            this.IsClaimProcessed = entity.IsClaimProcessed;
            this.IsEnabled = entity.IsEnabled;
            this.IsDeleted = entity.IsDeleted;
            this.RegionId = entity.RegionId;
            this.RegionName = entity.Region.RegionName;
            this.CreatedBy = entity.CreatedBy;
            this.CreatedDate = entity.CreatedDate;
        }

        #region Properties

        public int BranchId { get; set; }

        [Required]
        [DisplayName("region")]
        public int? RegionId { get; set; }

        public string RegionName { get; set; }

        [Required]
        [DisplayName("branch code")]
        public string BranchCode { get; set; }

        [Required]
        [DisplayName("branch name")]
        public string BranchName { get; set; }

        [Required]
        [DisplayName("branch address")]
        public string Address { get; set; }

        public bool IsClaimProcessed { get; set; }

        public bool IsEnabled { get; set; }

        public bool IsDeleted { get; set; }

        public string ContactPerson { get; set; }

        //region tracking
        public DateTime CreatedDate { get; set; }

        public int CreatedBy { get; set; }

        public DateTime UpdatedDate { get; set; }

        public int UpdatedBy { get; set; }

        public DateTime DeletedDate { get; set; }
        //endregion tracking

        #endregion Properties

        #region PublicMethods

        public BranchEntity ToBranchEntity()
        {
            return new BranchEntity
            {
                BranchId = this.BranchId,
                BranchName = this.BranchName,
                BranchCode = this.BranchCode,
                BranchAddress = this.Address,
                IsClaimProcessed= this.IsClaimProcessed,
                IsEnabled = this.IsEnabled,
                IsDeleted = this.IsDeleted,
                RegionId = this.RegionId,
                CreatedBy = this.CreatedBy,
                CreatedDate = this.CreatedDate,
            };
        }

        #endregion PublicMethods
    }
}