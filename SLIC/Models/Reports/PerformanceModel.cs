using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class PerformanceModel 
    {
        public string TOCode { get; set; }
        public string Name { get; set; }
        public string RName { get; set; }
        public string EFPNo { get; set; }
        public int Performance { get; set; }
        public int RegionId { get; set; }
        public string RegionCode { get; set; }
        public string RegionName { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }

        public string RegionNameDisplay { get; set; }
    }
}
