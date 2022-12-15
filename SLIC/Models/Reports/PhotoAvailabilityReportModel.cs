using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class PhotoAvailabilityReportModel
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
        public DateTime? VisitedDate { get; set; }
        public string VisitedDateDisplay { get; set; }
        public DateTime? DateFrom { get; set; }       
        public DateTime? DateTo { get; set; }
        public int InspectionType { get; set; }
        public string InspectionTypeName { get; set; }
        public int? C1 { get; set; } //Points Of Impact
        public int? C3 { get; set; } // Accident Images
        public int? C4 { get; set; } //Driver Statement
        public int? C5 { get; set; } //Technical Officer Comments
        public int? C6 { get; set; } //Claim-Form Image,	 
        public int? C20 { get; set; } //	Inspection Photos / Seen Visits / Any Other
        public int? C21 { get; set; } //Estimate/AnyotherComments       
        public string TotalImageAvailable { get; set; }
    }
}