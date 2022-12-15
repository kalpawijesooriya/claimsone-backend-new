using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.IronUtils;

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobDamageModel
    {
        #region Constructors

        public JobDamageModel()
        {
        }

        public JobDamageModel(vw_SAForm_Damages view)
        {
            this.VisitId = view.VisitId;
            this.Tyre_FL_Id = view.CON_Tyre_FL_Status;
            this.Tyre_RLL_Id = view.CON_Tyre_RLL_Status;
            this.Tyre_RLR_Id = view.CON_Tyre_RLR_Status;
            this.Tyre_RRR_Id = view.CON_Tyre_RRR_Status;
            this.Tyre_FR_Id = view.CON_Tyre_FR_Status;
            this.Tyre_RRL_Id = view.CON_Tyre_RRL_Status;
            this.Tyre_IsContributory = view.CON_Tyre_IsContributory;
            this.DamagedItems = view.DAM_DamagedItems;
            this.DamagedItems_Other = view.DAM_DamagedItems_Other;
            this.GoodsDamage = view.DAM_Goods_Damage;
            this.GoodsTypeCarried = view.DAM_Goods_Type;
            this.GoodsWeight = view.DAM_Goods_Weight;
            this.Injuries = view.DAM_Injuries;
            this.IsOLContributory = view.DAM_Is_OL_Contributory;
            this.IsOverLoaded = view.DAM_IsOverLoaded;
            this.OtherVehInvolved = view.DAM_OtherVeh_Involved;
            this.PossibleDR = view.DAM_PossibleDR;
            this.PossibleDR_Other = view.DAM_PossibleDR_Other;
            this.PreAccDamages = view.DAM_PreAccidentDamages;
            this.PreAccDamages_Other = view.DAM_PreAccidentDamages_Other;
            this.ThirdPartyDamages = view.DAM_ThirdParty_Damage;
            /*Set Properties from Enum */
            this.Tyre_FL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_FL_Status);
            this.Tyre_RLL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RLL_Status);
            this.Tyre_RLR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RLR_Status);
            this.Tyre_RRR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RRR_Status);
            this.Tyre_FR_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_FR_Status);
            this.Tyre_RRL_Status = Enum.GetName(typeof(TyreConditon), view.CON_Tyre_RRL_Status);
        }

        public JobDamageModel(vw_SAFormDetails view)
        {
            this.VisitId = view.VisitId;
            this.Tyre_FL_Id = view.CON_Tyre_FL_Status;
            this.Tyre_RLL_Id = view.CON_Tyre_RLL_Status;
            this.Tyre_RLR_Id = view.CON_Tyre_RLR_Status;
            this.Tyre_RRR_Id = view.CON_Tyre_RRR_Status;
            this.Tyre_FR_Id = view.CON_Tyre_FR_Status;
            this.Tyre_RRL_Id = view.CON_Tyre_RRL_Status;
            this.Tyre_IsContributory = view.CON_Tyre_IsContributory;
            this.DamagedItems = view.DAM_DamagedItems;
            this.DamagedItems_Other = view.DAM_DamagedItems_Other;
            this.GoodsDamage = view.DAM_Goods_Damage;
            this.GoodsTypeCarried = view.DAM_Goods_Type;
            this.GoodsWeight = view.DAM_Goods_Weight;
            this.Injuries = view.DAM_Injuries;
            this.IsOLContributory = view.DAM_Is_OL_Contributory;
            this.IsOverLoaded = view.DAM_IsOverLoaded;
            this.OtherVehInvolved = view.DAM_OtherVeh_Involved;
            this.PossibleDR = HttpUtility.HtmlDecode(view.DAM_PossibleDR);
            this.PossibleDR_Other = view.DAM_PossibleDR_Other;
            this.PreAccDamages = view.DAM_PreAccidentDamages;
            this.PreAccDamages_Other = view.DAM_PreAccidentDamages_Other;
            this.ThirdPartyDamages = view.DAM_ThirdParty_Damage;
            /*Set Properties from Enum */
            this.Tyre_FL_Status =(view.CON_Tyre_FL_Status!=null)? EnumUtils.stringValueOf(typeof(TyreConditon), view.CON_Tyre_FL_Status.ToString()):string.Empty;
            this.Tyre_RLL_Status = (view.CON_Tyre_RLL_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), view.CON_Tyre_RLL_Status.ToString()) : string.Empty;
            this.Tyre_RLR_Status = (view.CON_Tyre_RLR_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), view.CON_Tyre_RLR_Status.ToString()) : string.Empty;
            this.Tyre_RRR_Status = (view.CON_Tyre_RRR_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), view.CON_Tyre_RRR_Status.ToString()) : string.Empty;
            this.Tyre_FR_Status = (view.CON_Tyre_FR_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), view.CON_Tyre_FR_Status.ToString()) : string.Empty;
            this.Tyre_RRL_Status = (view.CON_Tyre_RRL_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), view.CON_Tyre_RRL_Status.ToString()) : string.Empty;
            this.Tyre_IsContributory_Val = (view.CON_Tyre_IsContributory != null && (bool)view.CON_Tyre_IsContributory) ? Confirmation.Yes.ToString() : Confirmation.No.ToString();
            this.IsOLContributory_Val = (view.DAM_Is_OL_Contributory != null && (bool)view.DAM_Is_OL_Contributory) ? Confirmation.Yes.ToString() : Confirmation.No.ToString();
            this.IsOverLoaded_Val = (view.DAM_IsOverLoaded != null && (bool)view.DAM_IsOverLoaded) ? Confirmation.Yes.ToString() : Confirmation.No.ToString();
        }

        #endregion

        #region Properties
        public int VisitId { get; set; }

        //Vehicle tyre Condition
        public int Tyre_FR_Id { get; set; }

        public int Tyre_FL_Id { get; set; }

        public int Tyre_RRL_Id { get; set; }

        public int Tyre_RLR_Id { get; set; }

        public int Tyre_RLL_Id { get; set; }

        public int Tyre_RRR_Id { get; set; }

        public string Tyre_FR_Status { get; set; }

        public string Tyre_FL_Status { get; set; }

        public string Tyre_RRL_Status { get; set; }

        public string Tyre_RLR_Status { get; set; }

        public string Tyre_RLL_Status { get; set; }

        public string Tyre_RRR_Status { get; set; }

        public bool? Tyre_IsContributory { get; set; }


        //Damages
        public string DamagedItems { get; set; }

        public string DamagedItems_Other { get; set; }

        public string PreAccDamages { get; set; }

        public string PreAccDamages_Other { get; set; }

        public string PossibleDR { get; set; }

        public string PossibleDR_Other { get; set; }

        public string GoodsTypeCarried { get; set; }

        public decimal? GoodsWeight { get; set; }

        public string GoodsDamage { get; set; }

        public bool? IsOverLoaded { get; set; }

        public bool? IsOLContributory { get; set; }

        public string OtherVehInvolved { get; set; }

        public string ThirdPartyDamages { get; set; }

        public string Injuries { get; set; }

        //Extra String Properties

        public string Tyre_IsContributory_Val { get; set; } // Yes , No

        public string IsOverLoaded_Val { get; set; } // Yes , No

        public string IsOLContributory_Val { get; set; } // Yes , No

        #endregion
    }
}