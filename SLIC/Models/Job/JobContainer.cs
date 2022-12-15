using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.Visit;

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobContainer
    {
        public JobDataModel SAForm { get; set; }

        public List<VisitDetailModel> Visits { get; set; }
    }
}