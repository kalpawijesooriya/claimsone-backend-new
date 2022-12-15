using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class PhotoAvailabilityVisitModel
    {
        public string JobNo { get; set; }
        public string VehicleNo { get; set; }
        public string ToCode { get; set; }
        public string EPFNo { get; set; }
        public string VisitedDate { get; set; }
        public string OfficerComments { get; set; }
        public string EstimateAnyOtherComments { get; set; }
        public string InspectionPhotosSeenVisitsAnyOther { get; set; }
        public string TotalImageCount { get; set; }

    }
}