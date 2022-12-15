using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SLIC.Models.Reports
{
    public class InqueryModel
    {
        public string VehicleNo { get; set; }
        public string JobNo { get; set; }
        public string CSRCode { get; set; }
        public string CSRName { get; set; }
        public string Branch { get; set; }
        public string Region { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
    }
}