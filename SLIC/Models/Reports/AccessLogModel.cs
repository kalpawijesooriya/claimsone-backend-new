using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class AccessLogModel
    {
        public string VehicleNo { get; set; }
        public string JobNo { get; set; }
        public string CSRCode { get; set; }
        public int BranchId { get; set; }
        public int RegionId { get; set; }
        public string BranchName { get; set; }
        public string RegionName { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? TimeFrom { get; set; }
        public DateTime? TimeTo { get; set; }
        public string Username { get; set; }
        public int InspectionType { get; set; }
        public string InspectionTypeName { get; set; }
        public string EFPNo { get; set; }
        public string Action { get; set; }
    }
}