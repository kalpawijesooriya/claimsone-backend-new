using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class OutstandingJobsModel
    {
        public string Name { get; set; }
        public string RName { get; set; }
        public string TOCode { get; set; }
        public string VehicleNo { get; set; }
        public string JobNo { get; set; }
        public string RegionName { get; set; }
        public int? RegionId { get; set; }
        public DateTime? AssignedDate { get; set; }
        public string AssignedDateDisplay { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}