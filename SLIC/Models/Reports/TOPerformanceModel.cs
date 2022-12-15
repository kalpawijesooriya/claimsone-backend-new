using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class TOPerformanceModel
    {

        #region Properties

        public int TOCode { get; set; }
        public string CSRCode { get; set; }
        public string Name { get; set; }        
        public string EPFNo { get; set; }
        public int EPFNumber { get; set; } //Used to order by EPFNo - int type
        public string VehicleNo { get; set; } 
        public string JobNo { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public DateTime? AssignedDate { get; set; }
        public DateTime? CompletedDate { get; set; }
        public DateTime? TotalTime { get; set; }
        public string PositiveScore { get; set; }
        public string negativeScore { get; set; }
        public int Hours { get; set; }
        public decimal Performance { get; set; }
        public int TotNoOfJobs { get; set; }
        public string AssignedDateDisplay { get; set; }
        public string CompletedDateDisplay { get; set; }

        public int InspectionType { get; set; }  //used in photo availability report To Wise
        public string InspectionTypeName { get; set; }

        #endregion

        
    }
}
