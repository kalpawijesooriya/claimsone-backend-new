using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class PhotoAvailabilityJobModel
    {
        public string JobNo { get; set; }
        public string VehicleNo { get; set; }
        public string ToCode { get; set; }
        public string EPFNo { get; set; }
        public string AssignedDate { get; set; }
        public string AccidentImages { get; set; }
        public string DriverStatement { get; set; }
        public string OfficerComments { get; set; }
        public string TotalImageCount { get; set; }
        public string ClaimFormImage { get; set; }

    }
}