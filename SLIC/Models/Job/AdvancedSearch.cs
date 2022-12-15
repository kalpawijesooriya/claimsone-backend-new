using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Job
{
    public class AdvancedSearch : Search
    {
        public DateTime? DateFrom { get; set; }//Submitted Date
        public DateTime? DateTo { get; set; }
        public int? UserId { get; set; }
        public string CSRCode { get; set; }
        public short RegionId { get; set; }
        public short BranchId { get; set; }


        public string VehicleNo { get; set; }
        public string JobNo { get; set; }
        public string CSRName { get; set; }

        //Just used in print preview
        public string BranchName { get; set; }
        public string RegionName { get; set; }

        public string EPFNo { get; set; }
    }
}