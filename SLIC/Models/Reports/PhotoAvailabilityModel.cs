using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class PhotoAvailabilityModel
    {
        public string Name { get; set; }
        public string RName { get; set; }
        public string TOCode { get; set; }
        public string VehicleNo { get; set; }
        public string JobNo { get; set; }
        public string EPFNo { get; set; }
        public string RegionName { get; set; }
        public int? RegionId { get; set; }
        public DateTime? AssignedDate { get; set; }
        public string AssignedDateDisplay { get; set; }

        [Required(ErrorMessage = "Please select a valid date range")]
        public DateTime? DateFrom { get; set; }
        [Required(ErrorMessage = "Please select a valid date range")]
        public DateTime? DateTo { get; set; }

        public int InspectionType { get; set; }
        public string InspectionTypeName { get; set; }
    }
}