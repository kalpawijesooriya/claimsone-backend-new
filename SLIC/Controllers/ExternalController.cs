using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.EnterpriseServices;
using com.IronOne.SLIC2.Models;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.SLIC2.Models.Auth;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Models.EntityModel;
using log4net;
using com.IronOne.SLIC2.Lang;
using System.Web.Security;
using com.IronOne.SLIC2.HandlerClasses;
using com.IronOne.SLIC2.Models.Reports;


namespace com.IronOne.SLIC2.Controllers
{

    public class ExternalController : Controller
    {
        protected static readonly ILog logevt = LogManager.GetLogger("EventLog");
        protected static readonly ILog logerr = LogManager.GetLogger("ErrorLog");

        FormsAuthenticationService FormsService = new FormsAuthenticationService();
        AccountMembershipService MembershipService = new AccountMembershipService();
        //
        // GET: /External/

        [Description("Search Results External")]
        public ActionResult SearchResultsExternal(string JobNo, string AccessCode)
        {            
            try
            {
                if (AccessCode == ApplicationSettings.CommonUserAccessCode)
                {
                    #region #ViewVisits

                    LogOnModel usermodel = new LogOnModel { UserName = ApplicationSettings.CommonUserUsername, Password = ApplicationSettings.CommonUserPassword, RememberMe = true, ReturnURL = "" };
                    UserDataModel loggedUser = this.SignIn(usermodel);
                    Session.Add("LoggedUserDetail", loggedUser);
                    //Session.Add("AuthorizedActions", loggedUser.RolePermissions);

                    //Form authentication on successful credential validation against the database.
                    FormsService.SignIn(usermodel.UserName, usermodel.RememberMe);

                    var data = "";

                    logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Ajax Handler," +
                        User.Identity.Name + ",[Params=(Job No:" + JobNo + ")]");


                    using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                    {
                        var jobInfo = context.GetParticularJob(JobNo);
                        foreach (GetParticularJob_Result job in jobInfo)
                        {
                            ViewData["JobNo"] = job.JobNo;
                            ViewData["VehicleNo"] = job.GEN_VehicleNo;
                            ViewData["VisitID"] = job.VisitId;
                        }
                        return GetFormatView("Job/SearchResultsExternal.aspx", data);
                    }

                    #endregion
                }
                else
                {
                    return Content("NotAllowed");
                }
            }           

            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                //logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Ajax Handler," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                logerr.Error(LogPoint.Failure.ToString() + " , " + this.ControllerContext.Controller.ToString() + ", Advanced Search Ajax Handler ," + User.Identity.Name + " , Message: " + e.Message + " , Stack Trace:" + e.StackTrace + " , Inner Exception: " + e.InnerException + " , Data: " + e.Data);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(600, Resources.err_600));
                logerr.Error(LogPoint.Failure.ToString() + " , " + this.ControllerContext.Controller.ToString() + ", Advanced Search Ajax Handler ," + User.Identity.Name + " , Message: " + e.Message + " , Stack Trace:" + e.StackTrace + " , Inner Exception: " + e.InnerException + " , Data: " + e.Data);
            }
            return GetFormatView("Job/SearchResultsExternal.aspx");
        }

        [Description("Get Format View")]
        public ActionResult GetFormatView(string pageUrl)
        {
            return GetFormatView(pageUrl, null);
        }

        [Description("Get Format View")]
        public ActionResult GetFormatView(string pageUrl, object model)
        {
            //if (Request.IsAjaxRequest())
            //{
            //    //Returns a Json for Ajax requests
            //    //Request.IsAjaxRequest() is NOT true when working with jquery Ajax post of older version
            //    return Json(model, JsonRequestBehavior.AllowGet);
            //}
            string fmt = GetFormat();

            if (fmt.ToUpper() == "JSON")
            {
                return JsonResult(model);
            }

            return View("~/Views/" + GetFormat() + "/" + pageUrl, model);
        }

        [Description("Json Result")]
        public JsonResult JsonResult(object model)
        {
            JsonResult result = new JsonResult();
            result.JsonRequestBehavior = JsonRequestBehavior.AllowGet;

            Dictionary<string, object> jsonPacket = new Dictionary<string, object>();

            if (ModelState.Where(x => x.Value.Errors.Count > 0).Any())
            {
                jsonPacket.Add("ModelErrors", GetModelErrorsJson());
            }
            else
            {
                jsonPacket.Add("Success", 0);
            }

            if (TempData["SuccessMsg"] != null)
            {
                jsonPacket.Add("SuccessMsg", TempData["SuccessMsg"]);
            }

            result.Data = new { Status = jsonPacket, result = model };
            return result;
        }

        [Description("Get Format")]
        public String GetFormat()
        {
            String fmt = "HTML";

            fmt = Request.Params.Get("fmt");

            if (fmt == null)
            {
                if (Session["fmt"] != null)
                {
                    fmt = Session["fmt"].ToString();
                }
                else
                {
                    fmt = "HTML";
                }
            }
            return fmt.ToUpper();
        }

        [NonAction]
        [Description("Get Model Errors Json")]
        public Dictionary<string, string> GetModelErrorsJson()
        {
            Dictionary<string, string> modelErrors = new Dictionary<string, string>();
            try
            {
                List<string> modelKeys = new List<string>();
                int keyIndex = 0;

                modelKeys = ModelState.Keys.ToList();

                foreach (ModelState item in ModelState.Values)
                {
                    foreach (ModelError error in item.Errors)
                    {
                        string errorKey = (string.IsNullOrEmpty(modelKeys[keyIndex]) ? "Errors" : modelKeys[keyIndex]);
                        if (modelErrors.Keys.Contains(errorKey))
                        {
                            modelErrors[errorKey] = modelErrors[errorKey] + "<br/>" + error.ErrorMessage;
                        }
                        else
                        {

                            //if (errorKey == "err" && error.Exception!=null)
                            if (error.Exception != null)
                            {
                                modelErrors.Add(errorKey, error.Exception.Message);
                            }
                            else
                            {
                                modelErrors.Add(errorKey, error.ErrorMessage);
                            }

                            //if (error.ErrorMessage == null)
                            //{
                            //    modelErrors.Add(errorKey, String.Format(Resources.ResourceManager.GetString("err_sys_103"), item.Value.AttemptedValue));
                            //}
                            //else
                            //{
                            //    modelErrors.Add(errorKey, error.ErrorMessage);                           
                            //}
                        }
                    }
                    keyIndex++;
                }
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get Model Errors Json," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return modelErrors;
        }


        //Photo Availability web services access by external users

        [HttpGet]
        [Description("View SA Form Photo Availability Details")]
        public ActionResult GetPhotoAvailabilityJobDetailsAjaxHandler(PhotoAvailabilityModel Model)
        {
            int count = 0;
            List<PhotoAvailabilityJobModel> perfList = new List<PhotoAvailabilityJobModel>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",GetPhotoAvailabilityJobDetailsAjaxHandler ," + User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");

                Model.InspectionType = (Model.InspectionType == null) ? 0 : Model.InspectionType;

                #region DateTO/From

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);//set to 23:59 PM of the given date
                if (!Model.DateTo.HasValue)
                    dateTo = DateTime.Now;
                //datefrom default date

                #endregion

               // var udm = GetLoggedUserDetail();
               // int RegionId = udm.RegionId;
              //  string role = udm.RoleName;

                #region RoleBasedProperty

                //#region TO

                //if (Model.TOCode == "All" || Model.Name == "-1" || Model.TOCode == "undefined" || Model.TOCode == null)
                //    Model.TOCode = null;
                //else
                //    Model.TOCode = Model.TOCode;
                #endregion

                //if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                //{
                //    if (Model.RegionName == "-1" || Model.RegionName == "All" || Model.RegionName == "undefined" || Model.RegionName == null)
                //        Model.RegionId = null;
                //    else
                //        Model.RegionId = Convert.ToInt32(Model.RegionName);
                //}

                //if (role.Equals(Resources.info_role_engineer))
                //    Model.RegionId = RegionId;


                //isPrintPreview
                //isExcel

                Model.RegionId = null;
                Model.TOCode = null;

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (Model.InspectionType == 0)
                    {
                        #region Photo Availability SA

                        var assignedJobList = context.GetPhotoAvailability_Paginated_SANew(dateFrom, dateTo, Model.RegionId, Model.TOCode, Model.InspectionType);

                        foreach (var report in assignedJobList)
                        {
                            PhotoAvailabilityJobModel job = new PhotoAvailabilityJobModel
                            {
                                JobNo = report.JobNo.ToString(),
                                VehicleNo = report.VehicleNo.ToString(),
                                ToCode = report.OfficerCode.ToString(),
                                EPFNo = report.EPFNo.ToString(),
                                AssignedDate = Convert.ToDateTime(report.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat),
                                AccidentImages = report.C3.ToString(),
                                DriverStatement = report.C4.ToString(),
                                OfficerComments = report.C5.ToString(),
                                ClaimFormImage = report.C6.ToString(),
                                TotalImageCount = report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString()
                            };
                            perfList.Add(job);
                        }
                        count = perfList.Count;

                        #endregion
                    }
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Photo Availability Job Details AjaxHandler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Photo Availability JobDetails AjaxHandler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");
            }

            var objArr = new object[] { perfList, count };
            if (objArr != null)
            {
                var dataX = objArr as object[];
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                TotalRecords = count,
                //iTotalDisplayRecords = count,
                Data = perfList

            },
            JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        [Description("View ARI Form Photo Availability Details")]
        public ActionResult GetPhotoAvailabilityVisitDetailsAjaxHandler(PhotoAvailabilityModel Model)
        {
            int count = 0;
            List<PhotoAvailabilityVisitModel> perfList = new List<PhotoAvailabilityVisitModel>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",GetPhotoAvailabilityVisitDetailsAjaxHandler ," + User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");

                #region DateTO/From

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);//set to 23:59 PM of the given date
                if (!Model.DateTo.HasValue)
                    dateTo = DateTime.Now;
                //datefrom default date

                #endregion

                //var udm = GetLoggedUserDetail();
                //int RegionId = udm.RegionId;
                //string role = udm.RoleName;

                //#region RoleBasedProperty

                //#region TO

                //if (Model.Name == "All" || Model.Name == "-1" || Model.Name == "undefined" || Model.Name == null)
                //    Model.TOCode = null;
                //else
                //    Model.TOCode = Model.Name;

                //#endregion

                //if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                //{
                //    if (Model.RegionName == "-1" || Model.RegionName == "All" || Model.RegionName == "undefined" || Model.RegionName == null)
                //        Model.RegionId = null;
                //    else
                //        Model.RegionId = Convert.ToInt32(Model.RegionName);
                //}

                //if (role.Equals(Resources.info_role_engineer))
                //    Model.RegionId = RegionId;


                //isPrintPreview
                //isExcel

                Model.RegionId = null;
                Model.TOCode = null;

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (Model.InspectionType != 0)
                    {
                        #region Photo Availability ARI and Other

                        var assignedJobList = context.GetPhotoAvailability_Paginated_ARINew(dateFrom, dateTo, Model.RegionId, Model.TOCode, Model.InspectionType);

                        foreach (var report in assignedJobList)
                        {
                            PhotoAvailabilityVisitModel job = new PhotoAvailabilityVisitModel
                            {
                                JobNo = report.JobNo.ToString(),
                                VehicleNo = report.VehicleNo.ToString(),
                                ToCode = report.OfficerCode.ToString(),
                                EPFNo = report.EPFNo.ToString(),
                                VisitedDate = Convert.ToDateTime(report.VisitedDateTime).ToString(ApplicationSettings.GetDateTimeFormat),
                                OfficerComments = report.C5.ToString(),
                                EstimateAnyOtherComments = report.C21.ToString(),
                                InspectionPhotosSeenVisitsAnyOther = report.C20.ToString(),
                                TotalImageCount = report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString()
                            };
                            perfList.Add(job);
                        }
                        count = perfList.Count;
                        #endregion
                    }
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Photo Availability Visit Details AjaxHandler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Photo Availability Visit Details AjaxHandler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");
            }

            var objArr = new object[] { perfList, count };
            if (objArr != null)
            {
                var dataX = objArr as object[];
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                TotalRecords = count,
                //iTotalDisplayRecords = count,
                Data = perfList
            },
            JsonRequestBehavior.AllowGet);
        }

        #region SignIn
        [Description("Sign In")]
        private UserDataModel SignIn(LogOnModel model)
        {
            try
            {
                UserDataModel userDetail = GetUserLoginDetails(model.UserName);

                #region Assign Temp Print User to Previous Roles

                //using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                //{
                //    if (CheckIfTempPrinterHasPreviousRole(userDetail))
                //    {
                //        string newRole = (from r in context.aspnet_Roles
                //                          where r.RoleId == (Guid)userDetail.PreviousRoleId
                //                          select r.RoleName).FirstOrDefault();

                //        Roles.AddUserToRole(userDetail.Username, newRole);
                //        Roles.RemoveUserFromRole(userDetail.Username, userDetail.RoleName);

                //        //Assign to new role
                //        userDetail.RoleName = newRole;
                //    }
                //}

                #endregion

                //Check whether the user is deleted
                if (userDetail.IsDeleted)
                    throw new GenException(107, Resources.err_107);

                //Check whether the user is enabled
                if (!userDetail.IsEnabled)
                    throw new GenException(106, Resources.err_106);

                MembershipUser mUser = Membership.GetUser(model.UserName);

                //Check whether the account has been locked out due to invalid login attempts.
                if (mUser != null && mUser.IsLockedOut)
                    throw new GenException(105, Resources.err_105);

                //Validate the user credentials
                if (!MembershipService.ValidateUser(model.UserName, model.Password))
                    throw new GenException(104, Resources.err_104);

                return userDetail;
            }
            catch (GenException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion

        [Description("Get User Login Details")]
        public UserDataModel GetUserLoginDetails(string userName)
        {
            try
            {
                using (MotorClaimEntities entities = DataObjectFactory.CreateContext())
                {
                    vw_UserLoginDetails userEntity = entities.vw_UserLoginDetails.FirstOrDefault(c => c.UserName == userName);

                    if (userEntity == null)
                        throw new GenException(704, Resources.err_704);

                    return new UserDataModel(userEntity);
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User Login Details," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw ex;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User Login Details," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw ex;
            }
        }
    }
}
