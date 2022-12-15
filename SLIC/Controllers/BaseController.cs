/***************************************************************************/
/// <summary>
///  <title>SLIC BaseController</title>
///  <description>BaseController for different format redirection</description>
///  <copyRight>Copyright (c) 2012</copyRight>
///  <company>IronOne Technologies (Pvt)Ltd</company>
///  <createdOn>2011-08-01</createdOn>
///  <author></author>
///  <modification>
///     <modifiedBy></modifiedBy>
///      <modifiedDate></modifiedDate>
///     <description></description> 
///  </modification>
///
/// </summary>
/***************************************************************************/

using System;
using System.Web.Mvc;
using System.Web.Routing;
using System.Collections.Generic;
using System.Linq;
using System.EnterpriseServices;


#region SLICReferences

using com.IronOne.SLIC2.Models.Auth;
using com.IronOne.SLIC2.Models.Enums;

#endregion SLICReferences

#region ThirdPartyReferences
using log4net;
using com.IronOne.SLIC2.Lang;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.Logger;
using com.IronOne.IronUtils;
using com.IronOne.SLIC2.Models;
using System.Web.Security;
#endregion ThirdPartyReferences

namespace com.IronOne.SLIC2.Controllers
{
    public class BaseController : Controller
    {
        protected static readonly ILog logevt = LogManager.GetLogger("EventLog");
        protected static readonly ILog logerr = LogManager.GetLogger("ErrorLog");
        protected static ILogManager auditLogger;

        AccountMembershipService MembershipService = new AccountMembershipService();
        FormsAuthenticationService FormsService = new FormsAuthenticationService();
        ///OnAuthorization event override
        ///<returns>
        ///true if the role has permission for the invoked action
        ///if false goes to NotAuthorized action
        ///</returns>       
        ///<exception cref="">
        ///
        /// </exception>
        /// <remarks></remarks>
        [Description("On Authorization")]
        protected override void OnAuthorization(AuthorizationContext filterContext)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On Authorization," + User.Identity.Name);

                UserDataModel userModel = GetLoggedUserDetail();
                auditLogger = IronLogManager.GetLogger(userModel == null ? 0 : userModel.Id, userModel == null ? string.Empty : userModel.Username, GetDeviceFormat(), Request.ServerVariables["REMOTE_ADDR"]);

                string action = filterContext.ActionDescriptor.ActionName;
                string controller = filterContext.ActionDescriptor.ControllerDescriptor.ControllerName;
                string fmt = GetFormat();

                if (action.Equals("LogOn")) return;
                if (action.Equals("LogOff")) return;
                if (action.Equals("NotAuthorized")) return;
                if (action.Equals("Error")) return;
                if (action.Equals("Index2")) return;
                if (action.Equals("SearchResultsExternal")) return;
                //if (action.Equals("JobWithImagesPrintPreview")) return;

                //if (action.Equals("AverageSendAjax")) return;
                //if (action.Equals("OnSiteEstimationPrintPreview")) return;
                //if (action.Equals("OnSiteEstimationRegionPrintPreview")) return;
                //if (action.Equals("SelectTO")) return;
                //if (action.Equals("OnSiteEstimationReport")) return;
                //if (action.Equals("RegionalLevelOutstandingReportPrintPreview")) return;
                //if (action.Equals("RegionalLevelPerformancePrintPreview")) return;

                //if (action.Equals("OutstandingSAPrintPreview")) return;//only TO
                //if (action.Equals("TOPerformancePrintPreview")) return;//only TO

              //  if (action.Equals("OnSiteEstimationToExcel")) return;
               // if (action.Equals("OnSiteEstimationRegionToExcel")) return;
              //  if (action.Equals("RegionalLevelOutstandingReportToExcel")) return;
              //  if (action.Equals("RegionalLevelPerformanceToExcel")) return;
               // if (action.Equals("TOPerformanceToExcel")) return;
              //  if (action.Equals("OutstandingSAToExcel")) return;
                
                //if (action.Equals("OnSiteEstimation")) return;
                //if (action.Equals("OnSiteEstimationAjaxHandler")) return;
                //if (action.Equals("RegionalLevelOutstandingReports")) return;
                //if (action.Equals("RegionalLevelOutstandingReportsAjaxHandler")) return;
                //if (action.Equals("TOPerformance")) return;  
                //if (action.Equals("RegionalLevelPerformance")) return;
                //if (action.Equals("RegionalLevelPerformanceAjaxHandler")) return;
                //if (action.Equals("OutstandingSAReports")) return;
                //if (action.Equals("AddJob")) return;/*TODO:Comment after using fiddler*/
               // if (action.Equals("AddVisit")) return;/*TODO:Comment after using fiddler*/

                bool authorized = RoleAuthorizationService.IsAuthorized(action + "_" + fmt);

                if (authorized)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On Authorization," + User.Identity.Name);
                    return;
                }
                else
                {
                    logerr.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On Authorization," + User.Identity.Name);
                    filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "LogOn", action = "NotAuthorized", fmt }));
                }
            }
            catch (Exception e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On Authorization," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
        }

        [Description("On Exception")]
        protected override void OnException(ExceptionContext filterContext)
        {
            logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On Exception," + User.Identity.Name + "," + filterContext.Exception);
            auditLogger.AddEvent(LogPoint.Failure.ToString(), filterContext.Exception.ToString(), string.Empty);
            //base.OnException(filterContext);
            ModelState.AddModelError("err", new GenException(132, filterContext.Exception.Message));
            filterContext.Result = new RedirectToRouteResult(new RouteValueDictionary(new { controller = "Base", action = "Error" }));
        }

        ///GetFormatView Action Method
        ///<param name="pageUrl">Location of the view</param>
        ///<param name="model">model</param>
        ///<returns>
        ///Directs to the required view
        ///</returns>       
        ///<exception cref="">
        ///
        /// </exception>
        /// <remarks></remarks>
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

        ///ErrorView Action Method
        ///<param name="pageUrl">Location of the view</param>
        ///<returns>
        ///The Error view
        ///</returns>       
        /// <remarks></remarks>
        [Description("Error View")]
        public ActionResult ErrorView()
        {
            auditLogger.AddEvent(LogPoint.Failure.ToString());
            return GetFormatView("Account/Error.aspx");
        }

        ///GetFormatView Action Method
        ///<param name="pageUrl">Location of the view</param>
        ///<returns>
        ///Directs to the required view
        ///</returns>       
        /// <remarks>GetFormatView without a model param</remarks>
        [Description("Get Format View")]
        public ActionResult GetFormatView(string pageUrl)
        {
            return GetFormatView(pageUrl, null);
        }

        ///GetFormat return method
        ///<returns>
        ///Gets fmt value from URL and returns it in uppercase
        ///</returns>       
        /// <remarks></remarks>
        [Description("Get Device Format")]
        public String GetDeviceFormat()
        {
            String fmt = GetFormat();
            if (fmt.Equals("HTML") || fmt.Equals("JSON"))
            {
                return DeviceTypes.WEB.ToString();
            }
            else if (fmt.Equals("XML"))
            {
                return DeviceTypes.TAB.ToString();
            }
            else
            {
                return DeviceTypes.UNKNOWN.ToString();
            }
        }

        ///GetFormat return method
        ///<returns>
        ///Gets fmt value from URL and returns it in uppercase
        ///</returns>       
        /// <remarks></remarks>
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

        ///Get Model Errors
        ///<returns>
        ///Get the Model Errors to Dictionary
        ///</returns>   
        /// <remarks></remarks>
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

        [Description("Set Success Message")]
        protected void SetSuccessMessage(string msg)
        {
            TempData["SuccessMsg"] = msg;
        }

        [Description("Get Logged User Detail")]
        public UserDataModel GetLoggedUserDetail()
        {
            string greeting = Resources.info_gen_welcome;
            try
            {
                var time = DateTime.Now.Hour;
                if (time < 12)
                    greeting = "Good Morning";
                else if (time < 17)
                    greeting = "Good Afternoon";
                else
                    greeting = "Good Evening";
            }
            catch (Exception)
            {
                greeting = Resources.info_gen_welcome;
            }

            if (Session["LoggedUserDetail"] == null)
            {
                UserDataModel loggedUser = null;
                try
                {
                    loggedUser = GetUserLoginDetails(User.Identity.Name);
                }
                catch (Exception)
                {
                    RedirectToAction("LogOn", "LogOn", null);
                }
                
                loggedUser.WelcomeMsg = greeting + " {0}";
                Session["LoggedUserDetail"] = loggedUser;
                return loggedUser;
            }
            else
            {                
                var uDetails = (UserDataModel)Session["LoggedUserDetail"];
                uDetails.WelcomeMsg = greeting + " {0}";
                return uDetails;
            }
        }

        /// <summary>
        /// Method to get User object from View_UserDetail table
        /// </summary>
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


        /// <summary>
        /// Method to get User object from View_UserDetail table
        /// </summary>
        [Description("Get User Login Details")]
        public UserDataModel GetUserLoginDetails(int userId)
        {
            try
            {
                using (MotorClaimEntities entities = DataObjectFactory.CreateContext())
                {
                    vw_UserLoginDetails userEntity = entities.vw_UserLoginDetails.FirstOrDefault(c => c.UserId == userId);

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

        #region GetUserOverloads

        //Gets the current logged in user
        [Description("Get User")]
        public UserDataModel GetUser()
        {
            try
            {
                return GetUser(User.Identity.Name);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

        

        //Gets the user given the user name
        [Description("Get User")]
        public UserDataModel GetUser(string userName)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_UserDetails usr = (from u in context.vw_UserDetails where u.UserName == userName && !u.IsDeleted select u).FirstOrDefault();

                    if (usr == null)
                        throw new GenException(704, Resources.err_704);
                    return new UserDataModel(usr);
                }
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

        //Gets the user model given the user id
        [Description("Get User")]
        public UserDataModel GetUser(int userId)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_UserDetails usr = (from u in context.vw_UserDetails where u.UserId == userId && !u.IsDeleted select u).FirstOrDefault();

                    if (usr == null)
                        throw new GenException(704, Resources.err_704);

                    return new UserDataModel(usr);
                }
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

        #endregion

        #region GetUserIdOverloads

        //Gets the current logged in user
        [Description("Get User Id")]
        public int GetUserId()
        {
            try
            {
                return GetUserId(User.Identity.Name);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User Id," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

      

        //Gets the user model given the user name
        [Description("Get User Id")]
        public int GetUserId(string username)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int userId = (from u in context.vw_UserDetails where u.UserName == username select u.UserId).FirstOrDefault();
                    return userId;
                }
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User Id," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

        #endregion

        #region GetUserNameOverloads

        //Gets the user name given the user Id
        [Description("Get User Name")]
        public string GetUserName(int userId)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    string userName = (from u in context.vw_UserDetails where u.UserId == userId select u.UserName).FirstOrDefault();
                    return userName;
                }
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get User Name," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

        #endregion

        /// <summary>
        /// Method to get User Access Level of the LoggedInUser
        /// </summary>
        [Description("Get Data Access Level")]
        public UserDataAccessLevel GetUserDataAccessLevel()
        {
            return (UserDataAccessLevel)(GetLoggedUserDetail().DataAccessLevel);
        }

        /// <summary>
        /// Method to get User Access Level of the user with the username param
        /// </summary>
        [Description("Get Data Access Level")]
        public UserDataAccessLevel GetUserDataAccessLevel(string userName)
        {
            return (UserDataAccessLevel)(GetUserLoginDetails(userName).DataAccessLevel);
        }

        /// <summary>
        /// Method to get User Access Level of the user with the userId param
        /// </summary>
        [Description("Get Data Access Level")]
        public UserDataAccessLevel GetUserDataAccessLevel(int userId)
        {
            return (UserDataAccessLevel)(GetUserLoginDetails(userId).DataAccessLevel);
        }

        /// <summary>
        /// Method to get BranchId of the LoggedInUser
        /// </summary>
        [Description("Get Data Access Level")]
        public int? GetUserBranchId()
        {
            return GetLoggedUserDetail().BranchId;
        }

        /// <summary>
        /// Method to get BranchId of the user with the username param
        /// </summary>
        [Description("Get Data Access Level")]
        public int? GetUserBranchId(string userName)
        {
            return GetUserLoginDetails(userName).BranchId;
        }

        /// <summary>
        /// Method to BranchId of the user with the userId param
        /// </summary>
        [Description("Get Data Access Level")]
        public int? GetUserBranchId(int userId)
        {
            return GetUserLoginDetails(userId).BranchId;
        }

        public string GetJobParamsString(int visitID)
        {
            string GEN_VehicleNo, JobNo, visitType;
            GEN_VehicleNo = JobNo = visitType = string.Empty;
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_Visits visit= context.vw_Visits.Where(c => c.VisitId == visitID).FirstOrDefault();

                    if (visit != null)
                    {
                        vw_SAFormDetails visitDetails = null;

                        if (visit.VisitType == 0)
                        {
                             visitDetails = context.vw_SAFormDetails.Where(c => c.VisitId == visitID).FirstOrDefault();                           
                        }
                        else
                        {
                             visitDetails = context.vw_SAFormDetails.Where(c => c.VisitType == 0 && c.JobNo == visit.JobNo).FirstOrDefault();
                        }
                        if (visitDetails != null)
                        {
                            GEN_VehicleNo = visitDetails.GEN_VehicleNo;
                            JobNo = visit.JobNo;
                            //visitType = ((VisitType)visitDetails.VisitType).ToString();
                            visitType = EnumUtils.stringValueOf(typeof(VisitType), visit.VisitType.ToString());
                            //((VisitType)visitDetails.VisitType).ToString();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get Job Params String," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return LogParams.GEN_VehicleNo.ToString() + '=' + GEN_VehicleNo + ',' + LogParams.JobNo.ToString() + '=' + JobNo + ',' + LogParams.VisitType.ToString() + '=' + visitType + ',' + LogParams.VisitId.ToString() + '=' + visitID;
        }

        [Description("Convert Regions To Select List")]
        public List<SelectListItem> ConvertRegionsToSelectList(List<RegionDataModel> regions)
        {
            try
            {
                List<SelectListItem> selectlist = new List<SelectListItem>();
                foreach (RegionDataModel item in regions)
                {
                    selectlist.Add(new SelectListItem
                    {
                        Text = item.RegionName,
                        Value = item.RegionId.ToString()
                    });
                }
                return selectlist;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Convert Regions To SelectList," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                return null;
            }
        }

        [Description("Convert Regions To Select List")]
        public List<SelectListItem> ConvertRegionsToSelectListForAuditLog(List<RegionDataModel> regions)
        {
            try
            {
                List<SelectListItem> selectlist = new List<SelectListItem>();
                foreach (RegionDataModel item in regions)
                {
                    selectlist.Add(new SelectListItem
                    {
                        Value = item.RegionId.ToString(),
                        Text = item.RegionName
                    });
                }
                return selectlist;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Convert Regions To SelectList For AuditLog," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                return null;
            }
        }
        [Description("Convert code To Select List")]
        public List<SelectListItem> ConvertCSRCodeToSelectListForAuditLog(List<UserDataModel> Users)
        {
            try
            {
                List<SelectListItem> selectlist = new List<SelectListItem>();
                foreach (UserDataModel item in Users)
                {
                    
                   if (item.RoleName == "Technical Officer")
                    {
                    selectlist.Add(new SelectListItem
                    {
                        Text = item.CSRCode,
                        Value = item.CSRCode
                    });
                   }
                }
                return selectlist;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Convert CSRCode To SelectList For AuditLog," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                return null;
            }
        }


        ///ConvertToSelectList
        ///<param name="keyValueList">
        ///keyValueList
        /// </param>
        ///<returns>
        ///List of selectList items for the dropdown
        ///</returns>  
        /// <remarks></remarks>
        [NonAction]
        [Description("Convert To Select List")]
        public List<SelectListItem> ConvertToSelectList(List<KeyValuePair<string, string>> keyValueList)
        {
            try
            {
                List<SelectListItem> selectListItem = new List<SelectListItem>();
                foreach (KeyValuePair<string, string> item in keyValueList)
                {
                    selectListItem.Add(new SelectListItem
                    {
                        Text = item.Value,
                        Value = item.Key

                    });
                }
                return selectListItem;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Convert To SelectList," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                return null;
            }
        }

        ///ConvertToSelectList
        ///<param name="keyValueList">
        ///keyValueList
        /// </param>
        ///<returns>
        ///List of selectList items for the dropdown
        ///</returns>  
        /// <remarks></remarks>
        [NonAction]
        [Description("Convert To Select List")]
        public List<SelectListItem> ConvertToSelectList(List<KeyValuePair<int, string>> keyValueList)
        {
            try
            {
                return keyValueList.Select(item => new SelectListItem
                {
                    Text = item.Value,
                    Value = item.Key.ToString()
                }).ToList();
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Convert To SelectList," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                return null;
            }
        }

        ///ConvertToSelectList
        ///<param name="keyValueList">
        ///keyValueList
        /// </param>
        ///<returns>
        ///List of selectList items for the dropdown
        ///</returns>  
        /// <remarks></remarks>
        [NonAction]
        [Description("Convert To Select List")]
        public List<SelectListItem> ConvertToTextSelectList(List<KeyValuePair<int, string>> keyValueList)
        {
            try
            {
                return keyValueList.Select(item => new SelectListItem
                {
                    Text = item.Value,
                    Value = item.Value
                }).ToList();
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Convert To Text SelectList," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                return null;
            }
        }

        ///Gets enumlist (Using enum and resource files)  
        ///<param name="type">Enum type</param>
        ///<returns>
        ///returns the language specific enum value list
        ///</returns>       
        ///<exception cref="">
        ///
        /// </exception>
        /// <remarks></remarks>
        [NonAction]
        [Description("Get Select List From Enum")]
        public List<SelectListItem> GetSelectListFromEnum(Type type)
        {
            try
            {
                if (!type.IsEnum)
                {
                    throw new System.TypeAccessException();
                }
                List<SelectListItem> list = new List<SelectListItem>();
                Array values = Enum.GetValues(type);

                foreach (Enum val in values)
                {
                    int key = (int)Enum.Parse(type, Enum.GetName(type, val));

                    string value = EnumUtils.stringValueOf(type, key.ToString());
                    SelectListItem selector = new SelectListItem
                    {
                        Text = value,
                        Value = key.ToString()
                    };
                    list.Add(selector);
                }
                return list;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Get SelectList From Enum," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }


        [Description("Set Growl")]
        protected void SetGrowl(string type, string msg)
        {
            try
            {

                string title = string.Empty;

                switch (type)
                {

                    case "info": title = Resources.info_gen_info; //"Info!";
                        break;
                    case "success": title = Resources.info_gen_success;
                        break;
                    case "warning": title = Resources.info_gen_warning; //"Warning!";
                        break;
                    case "error": title = Resources.info_gen_attention;// "Attention!";// "Error!";
                        break;
                    default:
                        break;
                }
                 
                TempData["GrowlType"] = type;
                TempData["GrowlTitle"] = title;
                TempData["GrowlMsg"] = msg;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Set Growl," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }
        }

             [Description("Sign In")]
        private UserDataModel SignIn(LogOnModel model)
        {
            try
            {
                UserDataModel userDetail = GetUserLoginDetails(model.UserName);

                #region Assign Temp Print User to Previous Roles

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


        
    }
}
