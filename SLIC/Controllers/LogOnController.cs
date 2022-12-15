/***************************************************************************/
/// <summary>
/// 
///  <title>SLIC LogOnController</title>
///  <description>LogOnController for LogOn LogOff actions</description>
///  <copyRight>Copyright (c) 2012</copyRight>
///  <company>IronOne Technologies (Pvt)Ltd</company>
///  <createdOn>2011-08-01</createdOn>
///  <author>Lushanthan Sivaneasharajah</author>
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
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.EnterpriseServices;

#region SLICReferences
using com.IronOne.SLIC2.Models;
using com.IronOne.SLIC2.Models.Auth;
using com.IronOne.SLIC2.Models.Enums;
#endregion SLICReferences

#region ThirdPartyReferences
using log4net;
using com.IronOne.SLIC2.Lang;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.Logger;
using com.IronOne.SLIC2.HandlerClasses;
#endregion ThirdPartyReferences


namespace com.IronOne.SLIC2.Controllers
{
    public class LogOnController : BaseController
    {
        protected static readonly ILog logevt = LogManager.GetLogger("EventLog");
        protected static readonly ILog logerr = LogManager.GetLogger("ErrorLog");

        AccountMembershipService MembershipService = new AccountMembershipService();
        FormsAuthenticationService FormsService = new FormsAuthenticationService();


        ///GetUserGuid return method
        ///<returns>
        ///Returns the GUID of the current user
        ///</returns>       
        ///<exception cref="">
        ///
        /// </exception>
        /// <remarks>NOT USED IN THIS PROJECT!!!</remarks>
        public Guid GetUserGuid()
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get User Guid,");
            Guid id = new Guid();
            try
            {
                id = (Guid)(Membership.GetUser().ProviderUserKey);
                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get User Guid," + User.Identity.Name);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get User Guid," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                throw;
            }

            return id;
        }

        /// <summary>
        /// If Authenticated redirect to home, else to the login page
        /// </summary>
        /// <returns>If authenticated home view, else logon view</returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [HttpGet]
        [Description("Log On")]
        public ActionResult LogOn()
        {
            try
            {
                //log on entry
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                //If Authenticated redirect to home
                if (User.Identity.IsAuthenticated)
                {
                    return RedirectToAction("Index", "Default");
                }

                if (Request.Params.Get("fmt") == "xml" || Request.Params.Get("fmt") == "XML")
                    throw new GenException(101, Resources.err_101);

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return GetFormatView("Account/LogOn.aspx");
        }

        ///LogOn Action Method
        ///<param name="model">LogOnModel</param>
        ///<param name="returnUrl">return URL</param>
        ///<returns>
        ///If successfully logged on goes to Default/Index or the return url
        ///</returns>       
        ///<exception cref="">
        ///Same view with the error
        /// </exception>
        /// <remarks></remarks>
        ///        

        [HttpPost]
        [Description("Log On")]
        public ActionResult LogOn(LogOnModel model, string returnUrl)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On - Post," + User.Identity.Name + ", [Params=( User name:" + model.UserName + ",Return Url: " + returnUrl + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                //If already authenticated redirect to index
                if (User.Identity.IsAuthenticated)
                {
                    return RedirectToAction("Index", "Default");
                }

                if (ModelState.IsValid)
                {
                    //Checks User Authentication and adds the user      
                    UserDataModel loggedUser = this.SignIn(model);
                    Session.Add("LoggedUserDetail", loggedUser);
                    //Session.Add("AuthorizedActions", loggedUser.RolePermissions);

                    //Form authentication on successful credential validation against the database.
                    FormsService.SignIn(model.UserName, model.RememberMe);

                    //log on success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On- Post," + User.Identity.Name + ", [Params=( User name:" + model.UserName + ",Return Url: " + returnUrl + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    //UserDataModel userModel = GetLoggedUserDetail();

                    auditLogger = IronLogManager.GetLogger(loggedUser == null ? 0 : loggedUser.Id, loggedUser == null ? string.Empty : loggedUser.Username, GetDeviceFormat(), Request.ServerVariables["REMOTE_ADDR"]);
                    auditLogger.AddEvent(LogPoint.Success.ToString(), loggedUser.Id);

                    // Add format to session
                    if (Request.Params.Get("fmt") != null)
                    {
                        Session.Add("fmt", (Request.Params.Get("fmt").ToUpper() == "JSON") ? "HTML" : Request.Params.Get("fmt"));
                    }

                    if (!String.IsNullOrEmpty(returnUrl))
                    {
                        return Redirect(returnUrl);
                    }
                    else
                    {
                        //return RedirectToAction("Index", "Default");
                        return GetFormatView("Account/LogOn.aspx");
                    }
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);

                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));

                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            catch (EntityException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));

                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(901, Resources.err_901));

                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log On - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            return GetFormatView("Account/LogOn.aspx");
        }

        [Description("Sign In")]
        private UserDataModel SignIn(LogOnModel model)
        {
            try
            {
                UserDataModel userDetail = GetUserLoginDetails(model.UserName);

                #region Assign Temp Print User to Previous Roles

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (CheckIfTempPrinterHasPreviousRole(userDetail))
                    {
                        string newRole = (from r in context.aspnet_Roles
                                          where r.RoleId == (Guid)userDetail.PreviousRoleId
                                          select r.RoleName).FirstOrDefault();

                        Roles.AddUserToRole(userDetail.Username, newRole);
                        Roles.RemoveUserFromRole(userDetail.Username, userDetail.RoleName);

                        //Assign to new role
                        userDetail.RoleName = newRole;
                    }
                }

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

        private bool CheckIfTempPrinterHasPreviousRole(UserDataModel model)
        {
            return (model.RoleId == new Guid("5cb24ac1-013f-4d39-98f3-0ecf810f58d4") && model.PreviousRoleId != null && model.PreviousRoleChangedDate != null && ((DateTime)model.PreviousRoleChangedDate).AddMinutes(ApplicationSettings.TempPrintingPeriod) <= DateTime.Now);
        }

        /// <summary>
        /// handles logOff 
        /// </summary>
        /// <returns></returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Description("Log Off")]
        public ActionResult LogOff()
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log Off," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

            FormsService.SignOut();

            logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Log Off," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            auditLogger.AddEvent(LogPoint.Success.ToString());

            return RedirectToAction("Index", "Default");
        }

        /// <summary>
        /// redirects to relevant page when user is not authorized
        /// </summary>
        /// <returns>view when the user is not authorized</returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Description("Not Authorized")]
        public ActionResult NotAuthorized()
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Not Authorized," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            auditLogger.AddEvent(LogPoint.Entry.ToString());

            return GetFormatView("Account/NotAuthorized.aspx");
        }

        #region PasswordManagement

        #region ChangePassword

        /// <summary>
        /// display the change password view
        /// </summary>
        /// <returns>view for change password</returns>
        /// <remarks></remarks>
        [Authorize]
        [Description("Change Password")]
        public ActionResult ChangePassword()
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Change Password," + User.Identity.Name);
            ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

            return GetFormatView("Account/ChangePassword.aspx");
        }

        /// <summary>
        /// Handles changing the password of the logged in user
        /// </summary>
        /// <param name="model">ChangePassword data model</param>
        /// <returns></returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Authorize]
        [HttpPost]
        [Description("Change Password")]
        public ActionResult ChangePassword(ChangePasswordModel model)
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Change Password," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            try
            {
                if (ModelState.IsValid)
                {
                    if (MembershipService.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword))
                    {
                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Change Password," + User.Identity.Name + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                        throw new GenException(120, Resources.info_success_changePw);
                    }
                    else
                    {
                        throw new GenException(122, Resources.err_122);
                    }
                }
                else
                {
                    ViewData["PasswordLength"] = MembershipService.MinPasswordLength;

                    if (model.OldPassword == null || model.NewPassword == null || model.ConfirmPassword == null)
                    {
                        throw new GenException(850, Resources.err_950);
                    }
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);

                if (ex.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Change Password," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Change Password," + User.Identity.Name + ",ClientIP:" + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(901, Resources.err_901));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Change Password," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }

            // If we got this far, something failed, redisplay form
            //ViewData["PasswordLength"] = MembershipService.MinPasswordLength;
            return GetFormatView("Account/ChangePassword.aspx", model);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns>the view displayed after password successfully changed</returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Description("Change Password Success")]
        public ActionResult ChangePasswordSuccess()
        {
            return GetFormatView("Account/ViewPage2.aspx");
        }
        #endregion ChangePassword

        #endregion PasswordManagement
      
    }
}
