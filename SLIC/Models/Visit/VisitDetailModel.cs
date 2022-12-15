using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.HandlerClasses;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.IronUtils;

namespace com.IronOne.SLIC2.Models.Visit
{
    public class VisitDetailModel : VisitModel
    {
        #region Constructors

        public VisitDetailModel()
        { }

        public VisitDetailModel(vw_VisitDetails view)
            : base(view)
        {
            this.ChassisNo = view.ChassyNo;
            this.EngineNo = view.EngineNo;

        }

        public VisitDetailModel(vw_VisitDetails view, List<vw_ImageGallery> images)
            : base(view, images)
        {
            this.ChassisNo = view.ChassyNo;
            this.EngineNo = view.EngineNo;
        }

        #endregion

        #region Properties
        public string ChassisNo { get; set; }
        public string EngineNo { get; set; }

        #endregion
    }
}