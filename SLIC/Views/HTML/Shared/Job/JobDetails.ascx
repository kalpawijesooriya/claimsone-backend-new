<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Job.JobDataModel>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<div>
    <%
        /// <summary>
        /// 
        ///  <title>SLIC2</title>
        ///  <description>job detail view page</description>
        ///  <copyRight>Copyright (c) 2012</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2012-12-20</createdOn>
        ///  <author>Suren Manawatta</author>
        ///  <modification>
        ///     <modifiedBy></modifiedBy>
        ///      <modifiedDate></modifiedDate>
        ///     <description></description>
        ///  </modification>
        ///
        /// </summary>    
        /// <% 
    
    %>
    <%  com.IronOne.SLIC2.Models.Administration.UserDataModel user = (Session["LoggedUserDetail"] != null) ? Session["LoggedUserDetail"] as com.IronOne.SLIC2.Models.Administration.UserDataModel : null;
        string actions = (user != null) ? user.RolePermissions : string.Empty;                       
    %>
    <script src="../../../../Content/js/media/js/jquery.dataTables.min.js" type="text/javascript"></script>
    <script src="../../../../Content/js/media/js/TableTools.min.js" type="text/javascript"></script>
    <script src="../../../../Content/js/media/js/ZeroClipboard.js" type="text/javascript"></script>
    <script src="../../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.js"
        type="text/javascript"></script>
    <link href="../../../../Content/js/media/css/TableTools.css" rel="stylesheet" type="text/css" />
    <link href="../../../../Content/js/media/css/TableTools_JUI.css" rel="stylesheet"
        type="text/css" />
    <link href="../../../../Content/js/Slate/plugins/responsive-tables/responsive-tables.css"
        rel="stylesheet" type="text/css" />
    <script type="text/javascript">
        
    </script>
    <script type="text/javascript">
        function EditJob() {
            document.getElementById('GeneralModel_JobNo').removeAttribute("readonly");
            document.getElementById('GeneralModel_VehicleNo').removeAttribute("readonly");
            document.getElementById('SubmitButton').removeAttribute("disabled");
        }         
    </script>
    <script type="text/javascript">

        function UpdateJobDetailsAsync() {
            var actionUrl = '<%: Html.ActionLink(" ", "UpdateJobDetailsAjaxHandler", "Job", null, null) %>';
            actionUrl = actionUrl.replace('<a href="', '');
            actionUrl = actionUrl.replace('"> </a>', '');
            actionUrl = actionUrl.replace('amp;', '');
            actionUrl = actionUrl.replace('amp;', '');
            var visitId = document.getElementById('GeneralModel_VisitId').value;
            var jobNo = document.getElementById('GeneralModel_JobNo').value;
            var vehNo = document.getElementById('GeneralModel_VehicleNo').value;
            $.ajax({
                type: "POST",
                url: actionUrl + "?fmt=JSON",
                contentType: "application/x-www-form-urlencoded",
                data: { 'visitId': visitId, 'jobNo': jobNo, 'vehNo': vehNo },
                dataType: "json",

                success: function (data) {
                    try {
                        $('#step-slide2 form').find("input[type='text']").val('');
                        $('#step-slide2 form').find('textarea').val('');
                        AssignDataToPopup(data);
                    } catch (e) {
                    }
                },
                error: function () {
                    $('#step-slide2 form').find("input [type='text']").val('');
                    $('#step-slide2 form').find('textarea').val('');
                },
                complete: function () {
                }
            });
            document.getElementById('GeneralModel_JobNo').setAttribute("readonly", "readonly");
            document.getElementById('GeneralModel_VehicleNo').setAttribute("readonly", "readonly");
            document.getElementById('SubmitButton').setAttribute("disabled", "disabled");
        }  
    </script>
</div>
<div class="widget"><p>wHAT IS THIS</p>
    <div class="widget-content">
        <div class="tab-content">
            <div class="tab-pane active" id="genInfo">
                <div id="Div2" class="widget widget-form">
                    <form class="form-horizontal" id="JobDetailsPopup" name="JobDetailsPopup">
                    <fieldset>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_jobNumber %></label>
                                        <div class="controls" id="11">
                                            <%:Html.TextBoxFor(m => m.GeneralModel.JobNo, new { @readonly = "readonly"} )%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_vehicleNo %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.GeneralModel.VehicleNo)%>
                                        </div>
                                    </td>
                                    <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("UpdateJobDetailsAjaxHandler_JSON")))
                                      { %>
                                    <td>
                                        <%if (!actions.Contains("AdvancedSearchExternal_HTML"))
                                        { %>
                                        <input style="display: inline;" class="btn btn-primary btn-small" type="button" name="EditButton"
                                            id="EditButton" onclick="EditJob();" value="Edit" />
                                        <input style="display: inline;" class="btn btn-primary btn-small" type="button" name="SubmitButton"
                                            id="SubmitButton" onclick="UpdateJobDetailsAsync();" value="Submit" disabled="true" />
                                        <div class="controls" id="id" style="visibility: hidden">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.VisitId) %>
                                        </div>
                                          <%} %>
                                    </td>
                                    <%} %>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_nameOfCaller %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.CallerName) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_contactNumber %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.CallerContactNo) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_originalTimeReported %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.OriginalTimeReported) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_timeReported %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.TimeReported) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_nameOfInsured %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.InsuredName) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_contactNumberOfTheInsured %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.InsuredContactNo) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_dateAndTimeOfAccident %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.AccidentDateTime) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_vehicleTypeAndColor %></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.GeneralModel.VehicleDescription) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_timeVisited %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.GeneralModel.VisitedDate) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_locationOfAccidentInspection %></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.GeneralModel.AccidentLocation) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                    </form>
                    <!-- /widget-content -->
                </div>
            </div>
            <div class="tab-pane" id="policyCoverInfo">
                <div id="Div1" class="widget widget-form">
                    <form class="form-horizontal">
                    <fieldset>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_policyCoverNoteNo %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.PolicyModel.PolicyCoverNoteNo) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_policyCoverNotePeriodFrom %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.PolicyModel.PolicyCoverNoteStartDate) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_to %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.PolicyModel.PolicyCoverNoteEndDate) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_policyCoverNoteSerialNo %></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.PolicyModel.PolicyCoverNoteSerialNo) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_coverNoteIssuedBy%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m=>m.PolicyModel.PolicyCoverNoteIssuedBy) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_reasonsForIssuingACoverNote%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.PolicyModel.PolicyCoverNoteReasons) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                    </form>
                </div>
            </div>
            <div class="tab-pane" id="vehicleAndDriverInfo">
                <div id="Div3" class="widget widget-form">
                    <form class="form-horizontal">
                    <fieldset>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_chassisNo%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.VehDriverModel.ChassisNo) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_engineNo%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.VehDriverModel.EngineNo) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_meterReading + " " + Resources.info_gen_km%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.VehDriverModel.MeterReading) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_driverName%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.VehDriverModel.DriverName) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_DriverIdType%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverIdentificationType)%>
                                            <%:Html.TextAreaFor(m=>m.VehDriverModel.DriverNic) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_driverCompetence%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverCompetence)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_drivingLicenseNo%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverLicenseNo)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_expiryDateOfLicense%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverLicenseExpiryDate)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_driverLicenseType%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverLicenseType)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_newOldLicenseType%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverLicenseIsNew_Val)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="name">
                                            <%:Resources.info_gen_vehicleClass%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m => m.VehDriverModel.VehicleClasses, new {@rows =3 })%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                    </form>
                </div>
            </div>
            <div class="tab-pane" id="damagesAndVehicleCondition">
                <div id="Div6" class="widget widget-form">
                    <form class="form-horizontal">
                    <fieldset>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="4">
                                        <label class="control-label" for="name">
                                            <b>
                                                <%:Resources.info_gen_tyreCondition%></b></label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_fr%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_FR_Status)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_fl%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_FL_Status)%>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_rrl%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_RRL_Status)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_rlr%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_RLR_Status)%>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_rll%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_RLL_Status)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_rrr%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_RRR_Status)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_areTheyContributory%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.Tyre_IsContributory_Val)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_typeOfGoodsCarried%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m => m.DamagesModel.GoodsTypeCarried)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_weightOfGoodsCarried + " " + Resources.info_gen_kg%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.DamagesModel.GoodsWeight)%>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_damagesToTheGoods%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.GoodsDamage) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_overLoaded%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.IsOverLoaded_Val) %>
                                        </div>
                                    </td>
                                    <td>
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_isOverWeightContributory%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.IsOLContributory_Val) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_otherVehiclesInvolved%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.OtherVehInvolved) %>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_thirdPartyPropertyDamages%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.ThirdPartyDamages) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_injuriesInsured3rdParty%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.Injuries) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_PreAccidentDamagedItems%></label>
                                        <div class="controls">
                                            <%:Html.HiddenFor(m => m.DamagesModel.PreAccDamages)%>
                                            <div id="DamagesModel_PreAccDamages_TreeView">
                                            </div>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_otherPreAccidentDamagedItems%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.PreAccDamages_Other) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_damagedItems%></label>
                                        <div class="controls">
                                            <%:Html.HiddenFor(m=>m.DamagesModel.DamagedItems) %>
                                            <div id="DamagesModel_DamagedItems_TreeView">
                                            </div>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_otherDamagedItems%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m => m.DamagesModel.DamagedItems_Other)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_possibleDR%></label>
                                        <div class="controls">
                                            <%:Html.HiddenFor(m => m.DamagesModel.PossibleDR)%>
                                            <div id="DamagesModel_PossibleDR_TreeView">
                                            </div>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_otherPossibleDR%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.DamagesModel.PossibleDR_Other) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                    </form>
                </div>
            </div>
            <div class="tab-pane" id="other">
                <div id="Div5" class="widget widget-form">
                    <form class="form-horizontal">
                    <fieldset>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_nearestPoliceStation%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.NearestPoliceStation)%>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_purposeOfJourney%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.JourneyPurpose)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_relationshipBetweenDriverAndInsured%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.VehDriverModel.DriverRelationship)%>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_pavValue + " " + Resources.info_gen_rs%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.PavValue)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_claimProcessingBranch%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.ClaimProcessingBranch)%>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_consistencyByCSR%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.CsrConsistency_Val)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_nameOfTheCSR%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.CSRName)%>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_ContactNo%></label>
                                        <div class="controls">
                                            <%:Html.TextBoxFor(m => m.OtherModel.ContactNo)%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_onSiteEstimation%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.OtherModel.OnSiteEstimation_Val) %>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%--   Approximate Cost of Repair (Rs.)--%><%:Resources.info_gen_approximateCostOfRepair + " " + Resources.info_gen_rs%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.GeneralModel.ApproximateCostOfRepair) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="control-group">
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_PrintedDate%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.OtherModel.PrintedDate) %>
                                        </div>
                                    </td>
                                    <td colspan="2">
                                        <label class="control-label" for="text">
                                            <%:Resources.info_gen_PrintedBranch%></label>
                                        <div class="controls">
                                            <%:Html.TextAreaFor(m=>m.OtherModel.PrintedBranch) %>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </fieldset>
                    </form>
                </div>
            </div>
            <div class="tab-pane" id="Comments">
                <div id="AddCommentForm" class="top-accordion-grid-with-search">
                    <div id="validation" class="widget highlight widget-form widget-accordion">
                        <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsEngineer(Page.User.Identity.Name))
                          { %>
                        <div class="accordion" id="sample-accordion">
                            <div class="accordion-group">
                                <div class="accordion-heading">
                                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#sample-accordion"
                                        href="#collapseVisitComments2"><span class="leftPadder-medium"></span>
                                        <%:Resources.info_gen_addNewComment%>
                                    </a><i class="icon-plus toggle-icon"></i>
                                </div>
                                <div id="collapseVisitComments2" class="accordion-body in collapse">
                                    <form action="#" class="form-horizontal" id="contact-form" novalidate="novalidate">
                                    <div id="successHeader" class="alert alert-success" style="display: none;">
                                        <a class="close" data-dismiss="alert" href="#">&times;</a>
                                        <h4 class="alert-heading">
                                            <%: Resources.info_gen_success %></h4>
                                        <div id="smsg">
                                        </div>
                                    </div>
                                    <div id="errorHeader" class="alert alert-error" style="display: none;">
                                        <a class="close" data-dismiss="alert" href="#">&times;</a>
                                        <h4 class="alert-heading">
                                            <%: Resources.info_gen_error %></h4>
                                        <div id="errormsg">
                                        </div>
                                    </div>
                                    <fieldset>
                                        <div class="control-group">
                                            <label class="control-label" for="name">
                                                <%:Resources.info_gen_newComment%></label>
                                            <label class="redStar">
                                                *</label>
                                            <div class="controls">
                                                <textarea class="input-large ui-tooltip" id="comment" name="comment" placement="right"
                                                    rows="5" cols="1" title="<%:Resources.info_help_comment%>"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-actions">
                                            <input type="button" id="commentPostButton" class="btn btn-primary" value="<%:Resources.info_gen_addComment%>"
                                                onclick="CreateComment();" />
                                            <input type="reset" class="btn btn-secondary" value="<%:Resources.info_gen_reset%>" />
                                        </div>
                                    </fieldset>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <%} %>
                        <table id="JobDetailsCommentsTable" class="table table-striped table-bordered table-highlight">
                            <thead>
                                <tr>
                                    <th>
                                        <%:Resources.info_gen_dateAndTime%>
                                    </th>
                                    <th>
                                        <%:Resources.info_gen_commentedBy%>
                                    </th>
                                    <th>
                                        <%:Resources.info_gen_comment%>
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="tab-pane" id="Gallery">
                <div id="Div7" class="widget widget-form">
                    <% Html.RenderPartial("~/Views/HTML/Shared/Job/ImageGallery.ascx", com.IronOne.SLIC2.Models.Enums.JobType.SAForm); %>
                </div>
            </div>
        </div>
    </div>
    <!-- /.widget-content -->
</div>
