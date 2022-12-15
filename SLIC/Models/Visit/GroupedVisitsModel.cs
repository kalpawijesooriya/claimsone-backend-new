using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Visit
{
    public class GroupedVisitsModel
    {
        public string JobNo { get; set; }
        public string VehNo { get; set; }
        //public IGrouping<string, VisitModel> JobVisits { get; set; }
        public IEnumerable<VisitModel> JobVisits { get; set; }
    }
}