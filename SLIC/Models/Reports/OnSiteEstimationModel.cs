using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class OnSiteEstimationModel
    {
       
        public string CSRCode { get; set; }
        public string Type { get; set; } //Region wise or TO wise
        public string Average { get; set; }//display avg
        public string UserId { get; set; }
        public int RegionId { get; set; }
        public string RegionCode { get; set; }
        public string RegionName { get; set; }
        public string RName { get; set; }//display region name in the view for regional engineer
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? TimeFrom { get; set; }
        public DateTime? TimeTo { get; set; }
        public string UserName { get; set; }
        public string EPFNo { get; set; }
        public int? EstimatedJobs { get; set; }
        public decimal? Ratio { get; set; }
        public int? TotalJobs { get; set; }
        public string Action { get; set; }
       
    }
}