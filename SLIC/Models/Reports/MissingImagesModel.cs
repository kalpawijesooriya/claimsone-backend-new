using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class MissingImagesModel
    {
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? TimeFrom { get; set; }
        public DateTime? TimeTo { get; set; }
        public string RegionName { get; set; }
        public string RName { get; set; }
        public string TOCode { get; set; }
        public string Name { get; set; }
        public bool IsJobsWithoutImgs { get; set; }
    }
}