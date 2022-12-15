using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class InvestigationMonitorModel
    {
                 
            public DateTime? DateFrom { get; set; }
            public DateTime? DateTo { get; set; }
            public DateTime? TimeFrom { get; set; }
            public DateTime? TimeTo { get; set; }
            public string ACRFrom { get; set; }
            public string ACRTo { get; set; }
            public int RelationshipId { get; set; }
            public string Relationship { get; set; }
            public int FurtherReview { get; set; }
            public DateTime? AccidentTime { get; set; }
            public string AccidentTimeDisplay { get; set; }
            public string Name { get; set; }
            public string VehicleNo { get; set; }
            public string JobNo { get; set; }
            public string ToCode { get; set; }
            public string ACRAmount { get; set; }
            public string ToContactNo { get; set; }
            public string PoliceStation { get; set; }
            public string FurtherReviewDisplay { get; set; }

        
    }
}