using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Reports
{
    public class AuditLogModel
    {
        public int EventId { get; set; }
        public string EventStatus { get; set; }
        public string Description { get; set; }
        public int RefID { get; set; }
        public DateTime Date { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string UserName { get; set; }
        public string ModuleName { get; set; }
        public string ActionName { get; set; }
        public string AccessType { get; set; }
        public string AccessIP { get; set; }
        public string Params { get; set; }
        public string Info1 { get; set; }
        public string Info2 { get; set; }
        public string Info3 { get; set; }
    }
}