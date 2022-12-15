<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Job.JobDataModel>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%  /// <summary>
        ///  <title></title>
        ///  <description>Partial View for</description>
        ///  <copyRight>Copyright (c) yyyy</copyRight>
        ///  <company>IronOne Technologies (Pvt)Ltd</company>
        ///  <createdOn>20yy-mm-dd</createdOn>
        ///  <author></author>
        ///  <modification>
        ///     <modifiedBy></modifiedBy>
        ///      <modifiedDate></modifiedDate>
        ///     <description></description>
        ///  </modification>
        /// </summary> %>
<style type="text/css">
    body
    {
        font-size: 15px;
    }
    .control-group .control-label
    {
        font-weight: bold;
        text-align: left;
        font-size: 15px;
        vertical-align: top;
    }
    
    .widget-content h3
    {
        text-decoration: underline;
        font-weight: normal;
        padding-bottom: 15px;
    }
    
    .control-group .colon
    {
        width: 5px;
        display: block;
        float: left;
    }
    
    .widget-header h3
    {
        font-size: 20px;
    }
    
    .widget-content
    {
        padding-top: 9px !important;
        padding-bottom: 0px !important;
    }
</style>
<style type="text/css" media="print">
    body
    {
        font-size: 15px;
    }
    .control-group .control-label
    {
        font-weight: bold;
        text-align: left;
        font-size: 15px;
        vertical-align: top;
    }
    
    .widget-content h3
    {
        text-decoration: underline;
        font-weight: normal;
        padding-bottom: 15px;
    }
    
    .control-group .colon
    {
        width: 5px;
        display: block;
        float: left;
    }
    
    .widget-header h3
    {
        font-size: 20px;
    }
    
    .widget-content
    {
        padding-top: 9px !important;
        padding-bottom: 0px !important;
    }
</style>
<style type="text/css" media="print">
    div.Comments
    {
        page-break-before: always;
        page-break-inside: avoid;
    }
</style>
<div class="widget-content">
    <h3>
        <%:Resources.info_gen_genaralInformation%></h3>
    <%if (Model.GeneralModel != null)
      { %>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_jobNumber%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.JobNo%></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_nameOfCaller%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.CallerName%></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_originalTimeReported%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%if (Model.GeneralModel.OriginalTimeReported != null)
                  { %>
                <%: ((DateTime)Model.GeneralModel.OriginalTimeReported).ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%>
                <%} %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_nameOfInsured%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.InsuredName%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_dateAndTimeOfAccident%></label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%if (Model.GeneralModel.AccidentDateTime != null)
                  { %>
                <%: Model.GeneralModel.AccidentDateTime.ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%>
                <%} %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_vehicleTypeAndColor%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.VehicleDescription%>
            </div>
        </div>
    </fieldset>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_vehicleNo%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.VehicleNo%></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_contactNumber%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.CallerContactNo%></div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_timeReported%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%if (Model.GeneralModel.TimeReported != null)
                  {%>
                <%: ((DateTime)Model.GeneralModel.TimeReported).ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%>
                <%} %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_contactNumberOfTheInsured%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.InsuredContactNo%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_timeVisited%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%if (Model.GeneralModel.VisitedDate != null)
                  { %>
                <%: Model.GeneralModel.VisitedDate.ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateTimeFormat)%>
                <%} %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_locationOfAccidentInspection%>
            </label>
            <div class="colon">
                :
            </div>
            <div class="controls">
                <%: Model.GeneralModel.AccidentLocation%>
            </div>
        </div>
    </fieldset>
    <%} %>
</div>
<div class="widget-content">
    <h3>
        <%:Resources.info_gen_policyCoverNoteInformation%></h3>
    <%if (Model.PolicyModel != null)
      { %>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_policyCoverNoteNo%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.PolicyModel.PolicyCoverNoteNo%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_policyCoverNotePeriodFrom%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%if (Model.PolicyModel.PolicyCoverNoteStartDate != null)
                  { %>
                <%: ((DateTime)Model.PolicyModel.PolicyCoverNoteStartDate).ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateOnlyFormat)%>
                <%} %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_to%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%if (Model.PolicyModel.PolicyCoverNoteEndDate != null)
                  { %>
                <%: ((DateTime)Model.PolicyModel.PolicyCoverNoteEndDate).ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateOnlyFormat)%>
                <%} %>
            </div>
        </div>
    </fieldset>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_policyCoverNoteSerialNo%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.PolicyModel.PolicyCoverNoteSerialNo%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_coverIssuedBy%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.PolicyModel.PolicyCoverNoteIssuedBy%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_reasonsForIssuingACoverNote%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.PolicyModel.PolicyCoverNoteReasons%>
            </div>
        </div>
    </fieldset>
    <%} %>
</div>
<div class="widget-content">
    <h3>
        <%:Resources.info_gen_vehicleAndDriverInformation%></h3>
    <%if (Model.VehDriverModel != null)
      { %>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_chassisNo%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.ChassisNo%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_meterReading + " " + Resources.info_gen_km%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.MeterReading%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_nicNoOfTheDriver%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.DriverNic%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_drivingLicenseNo%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.DriverLicenseNo%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_driverLicenseType%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.DriverLicenseType%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_vehicleClass%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.VehicleClasses%>
            </div>
        </div>
    </fieldset>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_engineNo%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.EngineNo%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_driverName%></label>
            <div class="controls">
                <%: Model.VehDriverModel.DriverName%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_driverCompetence%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.DriverCompetence%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_expiryDateOfLicense%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%if (Model.VehDriverModel.DriverLicenseExpiryDate != null)
                  { %>
                <%: ((DateTime)Model.VehDriverModel.DriverLicenseExpiryDate).ToString(com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.GetDateOnlyFormat)%>
                <%} %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="name">
                <%:Resources.info_gen_newOldLicenseType%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.DriverLicenseIsNew_Val%>
            </div>
        </div>
    </fieldset>
    <%} %>
</div>
<div class="widget-content">
    <h3>
        <%:Resources.info_gen_damagesAndVehicleCondition%></h3>
    <%if (Model.DamagesModel != null)
      { %><div class="control-group">
          <h6>
              <%:Resources.info_gen_tyreCondition%></h6>
      </div>
    <fieldset class="form-horizontal table-horizontal">
        <table border="1" class="table" bordercolor="#CCCCCC">
            <tr>
                <td>
                    <div class="control-group">
                        <label class="control-label" for="text">
                            <%:Resources.info_gen_fl%></label><div class="colon">
                                :
                            </div>
                        <div class="controls">
                            <%: Model.DamagesModel.Tyre_FL_Status%>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label" for="text">
                            <%:Resources.info_gen_fr%></label><div class="colon">
                                :
                            </div>
                        <div class="controls">
                            <%: Model.DamagesModel.Tyre_FR_Status%>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="control-group">
                        <label class="control-label" for="text">
                            <%:Resources.info_gen_rrl%></label><div class="colon">
                                :
                            </div>
                        <div class="controls">
                            <%: Model.DamagesModel.Tyre_RRL_Status%>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label" for="text">
                            <%:Resources.info_gen_rlr%></label><div class="colon">
                                :
                            </div>
                        <div class="controls">
                            <%: Model.DamagesModel.Tyre_RLR_Status%>
                        </div>
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div class="control-group">
                        <label class="control-label" for="text">
                            <%:Resources.info_gen_rll%></label><div class="colon">
                                :
                            </div>
                        <div class="controls">
                            <%: Model.DamagesModel.Tyre_RLL_Status%>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="control-group">
                        <label class="control-label" for="text">
                            <%:Resources.info_gen_rrr%></label><div class="colon">
                                :
                            </div>
                        <div class="controls">
                            <%: Model.DamagesModel.Tyre_RRR_Status%>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
    </fieldset>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_areTheyContributory%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.Tyre_IsContributory_Val%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_weightOfGoodsCarried + " " + Resources.info_gen_kg%></label><div
                    class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.GoodsWeight%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_overLoaded%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.IsOverLoaded_Val%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_otherVehiclesInvolved%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.OtherVehInvolved%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_injuriesInsured3rdParty%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.Injuries%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_PreAccidentDamagedItems%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <% if (!string.IsNullOrEmpty(Model.DamagesModel.PreAccDamages))
                   {
                       ViewData["TreeFor"] = "DamagedItems"; %>
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/ViewDamagedItems.ascx", Model.DamagesModel.PreAccDamages); %>
                <% } %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_otherPreAccidentDamagedItems%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.PreAccDamages_Other%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_possibleDR%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <% if (!string.IsNullOrEmpty(Model.DamagesModel.PossibleDR))
                   {
                       ViewData["TreeFor"] = "PossibleDR";%>
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/ViewDamagedItems.ascx", Model.DamagesModel.PossibleDR); %>
                <% } %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_otherPossibleDR%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.PossibleDR_Other%>
            </div>
        </div>
    </fieldset>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <h6>
                &nbsp;
                <%--  <%:Resources.info_gen_tyreCondition%>--%></h6>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_typeOfGoodsCarried%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.GoodsTypeCarried%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_damagesToTheGoods%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.GoodsDamage%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_isOverWeightContributory%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.IsOLContributory_Val%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_thirdPartyPropertyDamages%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.ThirdPartyDamages%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_damagedItems%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <% if (!string.IsNullOrEmpty(Model.DamagesModel.DamagedItems))
                   {
                       ViewData["TreeFor"] = "DamagedItems";
                %>
                <%Html.RenderPartial("~/Views/HTML/Shared/Job/ViewDamagedItems.ascx", Model.DamagesModel.DamagedItems); %>
                <% } %>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_otherDamagedItems%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.DamagesModel.DamagedItems_Other%>
            </div>
        </div>
    </fieldset>
    <%} %>
</div>
<div class="widget-content">
    <%if (Model.OtherModel != null)
      { %>
    <h3>
        <%:Resources.info_gen_otherInformation%></h3>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_nearestPoliceStation%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.NearestPoliceStation%>
            </div>
        </div>
        <%if (Model.VehDriverModel != null)
          { %>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_relationshipBetweenDriverAndInsured%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.VehDriverModel.DriverRelationship%>
            </div>
        </div>
        <%} %>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_claimProcessingBranch%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.ClaimProcessingBranch%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_nameOfTheCSR%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.CSRName%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_onSiteEstimation%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.OnSiteEstimation_Val%>
            </div>
        </div>
    </fieldset>
    <fieldset class="form-horizontal control-group-width-half table-horizontal">
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_purposeOfJourney%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.JourneyPurpose%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_pavValue + " " + Resources.info_gen_rs%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.PavValue%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_consistencyByCSR%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.CsrConsistency_Val%>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_ContactNo%></label><div class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.OtherModel.ContactNo%>
            </div>
        </div>
        <%if (Model.GeneralModel != null)
          { %>
        <div class="control-group">
            <label class="control-label" for="text">
                <%:Resources.info_gen_approximateCostOfRepair + " " + Resources.info_gen_rs%></label><div
                    class="colon">
                    :
                </div>
            <div class="controls">
                <%: Model.GeneralModel.ApproximateCostOfRepair%>
            </div>
        </div>
        <%} %>
    </fieldset>
    <%} %>
</div>
<div id ="Comments" class="widget-content Comments">
    <h3>
        SA Form Comments</h3>
    <%if (Model.GeneralModel != null)
      { %>
    <%Html.RenderPartial("~/Views/HTML/Shared/Job/PrintComments.ascx", Model.GeneralModel.Comments); %>
    <%} %>
</div>

<script type="text/javascript">

    var user = '<%:ViewData["RoleName"]%>';
    if (user == 'Common User') 
        $("#Comments").removeClass("Comments");
      
   
</script>
