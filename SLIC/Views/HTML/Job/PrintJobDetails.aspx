<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Job.JobDataModel>" %>

<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>job detail print preview page</description>
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
    %>
    <%--Styles--%>
    <link href="../../../Content/css/bootstrap.css" rel="stylesheet" />
    <link href="../../../Content/css/bootstrap-overrides.css" rel="stylesheet" />
    <link href="../../../Content/css/Site.css" rel="stylesheet" type="text/css" />
    <link href="../../../Content/css/slate.css" rel="stylesheet" />
    <title>Job Details of
        <%: Model.GeneralModel.JobNo %></title>
    <script src="../../../Scripts/jquery.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/jquery.validate.min.js" type="text/javascript"></script>
    <script src="../../../Scripts/api.js" type="text/javascript"></script>
    <script type="text/javascript">
        function HideAndPrint(visitId) {
            document.printForm.PrintButton.style.visibility = 'hidden';
            printVisit(visitId);
            return;
        }     
    </script>
</head>
<body style="background: none">
    <form name="printForm">
    <div id="rightcontent" class="span12">
        <div class="span12">
            <div class="widget">
                <div class="widget-header">
                    <h3>
                        <i class="icon-map-marker"></i>Job Details of
                        <%: Model.GeneralModel.JobNo %>
                    </h3>
                    &nbsp;&nbsp;&nbsp;
                    <%if (com.IronOne.SLIC2.Models.Auth.RoleAuthorizationService.IsAuthorized(("PrintVisit_HTML")))
                      { %>
                    <input style="float: left; display: inline;" class="btn btn-primary btn-small" type="button"
                        name="PrintButton" onclick="HideAndPrint(<%= Model.GeneralModel.VisitId %>);"
                        value="Print Report" />
                    <%} %>
                </div>
                <div class="widget-content">
                    <fieldset class="form-horizontal">
                        <h5>
                            General Information</h5>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_jobNumber %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.JobNo %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_vehicleNo %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.VehicleNo %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_nameOfCaller %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.CallerName %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_contactNumber %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.CallerContactNo %></div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_originalTimeReported %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.OriginalTimeReported %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_timeReported %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.TimeReported %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_nameOfInsured %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.InsuredName %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_contactNumberOfTheInsured %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.InsuredContactNo %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_dateAndTimeOfAccident %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.AccidentDateTime %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_vehicleTypeAndColor %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.VehicleDescription %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_timeVisited %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.VisitedDate %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                <%: Resources.info_gen_locationOfAccidentInspection %></label>
                            <div class="controls">
                                <%: Model.GeneralModel.AccidentLocation %>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="widget-content">
                    <fieldset class="form-horizontal">
                        <h5>
                            Policy / Cover Note Information</h5>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Policy/Cover Note No</label>
                            <div class="controls">
                                <%: Model.PolicyModel.PolicyCoverNoteNo %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Policy/Cover Note Period From</label>
                            <div class="controls">
                                <%: Model.PolicyModel.PolicyCoverNoteStartDate %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                To</label>
                            <div class="controls">
                                <%: Model.PolicyModel.PolicyCoverNoteEndDate %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Policy/Cover Note Serial No</label>
                            <div class="controls">
                                <%: Model.PolicyModel.PolicyCoverNoteSerialNo %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Cover Issued By</label>
                            <div class="controls">
                                <%: Model.PolicyModel.PolicyCoverNoteIssuedBy %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Reasons for Issuing a Cover Note</label>
                            <div class="controls">
                                <%: Model.PolicyModel.PolicyCoverNoteReasons %>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="widget-content">
                    <fieldset class="form-horizontal">
                        <h5>
                            Vehicle and Driver Information</h5>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Chassis No</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.ChassisNo %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Engine No</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.EngineNo %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Meter Reading (km)</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.MeterReading %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Driver Name</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverName %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                NIC No of the Driver</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverNic %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Driver Competence</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverCompetence %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Driving License No</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverLicenseNo %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Expiry Date of License</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverLicenseExpiryDate %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Type of D/L</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverLicenseType %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                New/Old License Type</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverLicenseIsNew_Val %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="name">
                                Vehicle Class</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.VehicleClasses %>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="widget-content">
                    <fieldset class="form-horizontal">
                        <h5>
                            Damages and Vehicle Condition</h5>
                        <div class="control-group">
                            <h6>
                                Tyre Condition</h6>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                F/R</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_FR_Status %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                F/L</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_FL_Status %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                R/R/L</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_RRL_Status %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                R/L/R</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_RLR_Status %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                R/L/L</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_RLL_Status %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                R/R/R</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_RRR_Status %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Are They Contributory</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Tyre_IsContributory_Val %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Type of Goods Carried</label>
                            <div class="controls">
                                <%: Model.DamagesModel.GoodsTypeCarried %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Weight of Goods Carried (kg)</label>
                            <div class="controls">
                                <%: Model.DamagesModel.GoodsWeight %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Damages to the Goods</label>
                            <div class="controls">
                                <%: Model.DamagesModel.GoodsDamage %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Over Loaded</label>
                            <div class="controls">
                                <%: Model.DamagesModel.IsOverLoaded_Val %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Is Over Weight Contributory</label>
                            <div class="controls">
                                <%: Model.DamagesModel.IsOLContributory_Val %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Other Vehicles Involved</label>
                            <div class="controls">
                                <%: Model.DamagesModel.OtherVehInvolved %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Third Party Property Damages</label>
                            <div class="controls">
                                <%: Model.DamagesModel.ThirdPartyDamages %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Injuries (Insured + 3rd Party)</label>
                            <div class="controls">
                                <%: Model.DamagesModel.Injuries %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Pre Accident Damaged Items</label>
                            <div class="controls">
                                <%: Model.DamagesModel.PreAccDamages %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Other Pre Accident Damaged Items</label>
                            <div class="controls">
                                <%: Model.DamagesModel.PreAccDamages_Other %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Damaged Items</label>
                            <div class="controls">
                                <%: Model.DamagesModel.DamagedItems %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Other Damaged Items</label>
                            <div class="controls">
                                <%: Model.DamagesModel.PreAccDamages_Other %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Possible D/R</label>
                            <div class="controls">
                                <%: Model.DamagesModel.PossibleDR %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Other Possible D/R</label>
                            <div class="controls">
                                <%: Model.DamagesModel.PossibleDR_Other %>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <div class="widget-content">
                    <fieldset class="form-horizontal">
                        <h5>
                            Other Information</h5>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Nearest Police Station</label>
                            <div class="controls">
                                <%: Model.OtherModel.NearestPoliceStation %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Purpose of Journey</label>
                            <div class="controls">
                                <%: Model.OtherModel.JourneyPurpose %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Relationship between Driver &amp; Insured</label>
                            <div class="controls">
                                <%: Model.VehDriverModel.DriverRelationship %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                PAV Value (Rs.)</label>
                            <div class="controls">
                                <%: Model.OtherModel.PavValue %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Claim Processing Branch</label>
                            <div class="controls">
                                <%: Model.OtherModel.ClaimProcessingBranch %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Consistency by CSR</label>
                            <div class="controls">
                                <%: Model.OtherModel.CsrConsistency_Val %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Name of The CSR</label>
                            <div class="controls">
                                <%: Model.OtherModel.CSRName %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                On Site Estimation</label>
                            <div class="controls">
                                <%: Model.OtherModel.OnSiteEstimation_Val %>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="text">
                                Approximate Cost of Repair (Rs.)</label>
                            <div class="controls">
                                <%: Model.GeneralModel.ApproximateCostOfRepair %>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
    </div>
    <div id="foo" class="span12">
        &nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &copy;
        <%=DateTime.Now.Year %>
        <%:Resources.info_gen_copyright%>
    </div>
    </form>
</body>
</html>
