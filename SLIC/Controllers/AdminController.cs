using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using com.IronOne.SLIC2.HandlerClasses;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.SLIC2.Models.Auth;
using com.IronOne.SLIC2.Models.EntityModel;
using System.Web.Security;
using com.IronOne.SLIC2.Models.Job;
using log4net;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Lang;
using System.Text;
using System.EnterpriseServices;
using System.Data.Objects;


namespace com.IronOne.SLIC2.Controllers
{
    /// <summary> 
    ///  <title></title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-12</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description> 
    ///  </modification>
    /// </summary>
    public class AdminController : BaseController
    {
        protected static readonly ILog logevt = LogManager.GetLogger("EventLog");
        protected static readonly ILog logerr = LogManager.GetLogger("ErrorLog");

        #region Actions

        [Description("Index")]
        public ActionResult Index()
        {
            return RedirectToAction("Index", "Default");
        }

        #region Users

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Description("View Users")]
        public ActionResult ViewUsers()
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + "View Users," + User.Identity.Name);

                List<SelectListItem> userRoles = new List<SelectListItem>();
                userRoles.Add(new SelectListItem
                                  {
                                      Text = Resources.info_gen_all,
                                      Value = "-1",
                                      Selected = true
                                  });
                userRoles.AddRange(ConvertToSelectList(GetRolesList()));

                ViewData["userType"] = userRoles;

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + "View Users," + User.Identity.Name);
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "View Users," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(99, ex.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "View Users," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }

            return GetFormatView("UserMgt/ViewUsers.aspx");
        }

        /*public String ViewContact(String CSRCode)
        {
            String TOno= null;
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",View Contact," + User.Identity.Name + ",[Params=(User Id:" + CSRCode + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {

                    UserEntity entity = (from u in context.UserEntities where u.Code == CSRCode select u).FirstOrDefault();
                    TOno = entity.ContactNo;
                    //context.SaveChanges();

                    //log for success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",View Contact," + User.Identity.Name + ",[Params=(User nameId" + CSRCode + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), CSRCode);

                    throw new GenException(120, "User not found");
                }
            }
            catch (GenException e)
            {
                
                
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",View Contact," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + CSRCode + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                
            }
            

            return TOno;
        }*/

        /// <summary>
        /// Ajax Action for loading all the users 
        /// </summary>
        /// <param name="param"></param>
        /// <param name="roleName"></param>
        /// <returns></returns>
        [Description("User List Ajax Handler")]
        public ActionResult UserListAjaxHandler(JQueryDataTableParamModel param, string roleName = "", bool isLockedUsers = false)
        {
            int totalRecordCount = 0;
            //var count;
            int? count;
            ObjectParameter output = new ObjectParameter("Column1", typeof(int));

            List<String[]> jsonData = new List<string[]>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + "User List AjaxHandler," + User.Identity.Name);

                var isCsrCodeSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
                var isUsernameSearchable = Convert.ToBoolean(Request["bSearchable_1"]);
                var isFirstNameSearchable = Convert.ToBoolean(Request["bSearchable_2"]);
                var isLastNameSearchable = Convert.ToBoolean(Request["bSearchable_3"]);
                var isEmailSearchable = Convert.ToBoolean(Request["bSearchable_4"]);
                var isUserRoleSearchable = Convert.ToBoolean(Request["bSearchable_5"]);
                var isBranchSearchable = Convert.ToBoolean(Request["bSearchable_6"]);

                var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                var sortDirection = Request["sSortDir_0"]; // asc or desc

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IQueryable<vw_UserDetails> users;
                    int uid = GetUserId();
                    if (roleName == "") roleName = "All";

                    users = from u in context.vw_UserDetails
                            where u.IsDeleted == false && u.UserId != uid
                                  && ((roleName != "All") ? u.RoleName == roleName : u.RoleName != null)
                            select u;

                    if (RoleAuthorizationService.IsEngineer(User.Identity.Name))
                    {

                        roleName = Resources.info_role_technicalOfficer;
                        users = from u in context.vw_UserDetails
                                where u.IsDeleted == false && u.RoleName == roleName // && u.RegionId == engRegionId
                                select u;
                    }
                    else if (RoleAuthorizationService.IsManagement(User.Identity.Name))
                    {
                        //Remove Super Admins for Manager
                        users = from u in users
                                where u.RoleId != new Guid("d64d0f39-966c-406f-b544-363d70412ce0")
                                select u;
                    }
                    if (isLockedUsers)
                    {
                        IQueryable<Guid> mUsers = from u in context.aspnet_Membership
                                                  where u.IsLockedOut == true
                                                  select u.UserId;
                        users = users.Where(c => mUsers.Contains(c.UserGUID));
                    }

                     //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        int? branchId = GetUserBranchId();
                        users = users.Where(x => x.BranchId == branchId);
                    }

                    #region Searching Section
                    if (!String.IsNullOrEmpty(param.sSearch))
                    {
                        users =
                            users.Where(
                                r => isUsernameSearchable && r.UserName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isFirstNameSearchable && r.FirstName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isLastNameSearchable && r.LastName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isEmailSearchable && r.PrimaryEmail.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isUserRoleSearchable && r.RoleName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isBranchSearchable && r.BranchName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isCsrCodeSearchable && r.Code.ToLower().Contains(param.sSearch.ToLower())
                                     );
                    }
                    #endregion

                    #region Sorting Section

                    Func<vw_UserDetails, string> orderingFunction;

                    switch (sortColumnIndex)
                    {
                        case 0:
                            orderingFunction = (c => c.Code);
                            break;
                        case 1:
                            orderingFunction = (c => c.UserName);
                            break;
                        case 2:
                            orderingFunction = (c => c.FirstName);
                            break;
                        case 3:
                            orderingFunction = (c => c.LastName);
                            break;
                        case 4:
                            orderingFunction = (c => c.PrimaryEmail);
                            break;
                        case 5:
                            orderingFunction = (c => c.RoleName);
                            break;
                        case 6:
                            orderingFunction = (c => c.BranchName);
                            break;
                        default:
                            orderingFunction = (c => c.UserName);
                            break;
                    }


                    if (sortDirection == "asc")
                        users = users.OrderBy(orderingFunction).AsQueryable();
                    else
                        users = users.OrderByDescending(orderingFunction).AsQueryable();
                    #endregion

                    totalRecordCount = users.Count();
                    users = users.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (var user in users)
                    {
                        //Add to Mapper
                        String[] userDetails = new String[8];
                        userDetails[0] = user.Code;
                        userDetails[1] = user.UserName;
                        userDetails[2] = user.FirstName;
                        userDetails[3] = user.LastName;
                        userDetails[4] = user.PrimaryEmail;
                        userDetails[5] = user.RoleName;
                        userDetails[6] = user.BranchName;
                        if (user.RoleName.ToLower() == Resources.info_role_engineer.ToLower())
                        {
                            userDetails[6] = user.RegionName;
                        }

                        string rolePermissions = GetLoggedUserDetail().RolePermissions;
                        if (user.IsEnabled)
                        {
                            userDetails[7] = "<div class=\"btn-group btn-group-grid\">" +
                                             "<a class=\"btn dropdown-toggle btn-small\" data-toggle=\"dropdown\" href=\"\">" +
                                             "<i class=\"icon-cog\">&nbsp;</i><span class=\"caret\"></span>" +
                                             "</a>" +
                                             "<ul class=\"dropdown-menu pull-right\">";

                            if (rolePermissions.Contains("UpdateUser_HTML"))
                            {
                                userDetails[7] = userDetails[7] + "<li><a href=\"../Admin/UpdateUser?userId=" + user.UserId + "\">Update User</a></li>";
                            }
                            if (rolePermissions.Contains("ResetPassword_HTML"))
                            {
                                userDetails[7] = userDetails[7] + "<li><a href=\"../Admin/ResetPassword?userName=" + user.UserName + "\" onclick=\"return confirm('" + Resources.info_confirm_resetPw + "')\">Reset Password</a></li>";
                            }
                            if (rolePermissions.Contains("DeactivateUser_HTML"))
                            {
                                userDetails[7] = userDetails[7] + "<li><a href=\"../Admin/DeactivateUser?userid=" + user.UserId + "\" onclick=\"return confirm('" + Resources.info_confirm_deactivateUser + "')\">Deactivate User</a></li>";
                            }
                            if (rolePermissions.Contains("DeleteUser_HTML"))
                            {
                                userDetails[7] = userDetails[7] + "<li><a href=\"../Admin/DeleteUser?userid=" + user.UserId + "\" onclick=\"return confirm('" + Resources.info_confirm_deleteUser + "')\">Delete User</a></li>";
                            }
                            userDetails[7] = userDetails[7] + "</ul></div>";
                        }
                        else
                        {
                            if (rolePermissions.Contains("ActivateUser_HTML"))
                            {
                                userDetails[7] = userDetails[7] + "<div class=\"btn-group btn-group-grid\"><a class=\"btn dropdown-toggle btn-small\" href=\"../Admin/ActivateUser?userid=" + user.UserId + "\" onclick=\"return confirm('" + Resources.info_confirm_activateUser + "')\">&nbsp;&nbsp;<i class=\"icon-signin awesome-font-medium\"></i>&nbsp;</a></div>";
                            }
                        }
                        jsonData.Add(userDetails);

                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + "User List AjaxHandler," + User.Identity.Name);
                    }
                }
            }
            catch (GenException ex)
            {
                //log on exception
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "User List AjaxHandler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                //log on exception
                ModelState.AddModelError("err", new GenException(99, ex.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "User List AjaxHandler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = totalRecordCount,
                    iTotalDisplayRecords = totalRecordCount,
                    aaData = jsonData
                },
            JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// The Action to create users (GET Method)
        /// </summary>
        /// <returns>Redirects to the all users view</returns>
        [HttpGet]
        [Description("Create User")]
        public ActionResult CreateUser()
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + "Create User," + User.Identity.Name);
                DropdownManipulations();

                //Remove Temp Printing on user creation
                ViewData["Roles"] = ((List<SelectListItem>)ViewData["Roles"]).Where(x => x.Text.Trim() != Resources.info_role_tempPrinting).ToList();

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create User," + User.Identity.Name);
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Create User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "Create User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return GetFormatView("UserMgt/UserDetails.aspx");
        }


        /// <summary>
        /// The Action to create users (POST method)
        /// </summary>
        /// <param name="model">UserDataModel</param>
        /// <returns>Redirects to the all users view</returns>
        [HttpPost]
        [Description("Create User")]
        public ActionResult CreateUser(UserDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create User - Post," + User.Identity.Name + ",[Params=(User Name:" + model.Username + ",Role Name:" + model.RoleName + ")]");

                //load drop down data
                CreateUser();
                List<SelectListItem> branchList = new List<SelectListItem>();
                branchList.AddRange(ConvertBranchedToSelectList(GetBranchDataList(model.RegionId, false, false)));
                ViewData["Branches"] = branchList;


                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (ModelState.IsValid)
                    {
                        //TODO: Add to model error
                        if (model.RoleName != null && model.RoleName.ToLower() == "system administrator" && Roles.GetUsersInRole("System Administrator").Length >= ApplicationSettings.MaxAllowedSystemAdmins)
                        {
                            throw new GenException(706, Resources.err_706);
                        }

                        //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                        if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                        {
                            if (model.BranchId != GetUserBranchId())
                                throw new GenException(703, Resources.err_703);
                        }

                        //TODO: move create user into a Non-action method.
                        MembershipCreateStatus memStatus;
                        MembershipUser memUser = Membership.CreateUser(model.Username, model.Password, model.Email, "company name", "slic", true, out memStatus);
                        //TODO: Add password question and answer to web config.

                        if (memStatus == MembershipCreateStatus.Success)
                        {
                            //Add user to role.
                            Roles.AddUserToRole(model.Username, model.RoleName);

                            model.UserId = (Guid)memUser.ProviderUserKey;

                            //Convert User model to User entity
                            UserEntity entity = model.ToUserEntity();//.Mapper.ToUserEntity(model);
                            entity.IsEnabled = true;
                            entity.IsDeleted = false;
                            entity.CreatedBy = GetLoggedUserDetail().Id;
                            entity.CreatedDate = DateTime.Now;

                            ////Comment later
                            if (model.RoleName == "Engineer")
                                entity.BranchId = null;

                            try
                            {
                                //Save to db
                                context.AddToUserEntities(entity);
                                context.SaveChanges();
                                auditLogger.AddEvent(LogPoint.Success.ToString(), entity.UserId);
                            }
                            catch (Exception)
                            {
                                //Delete Membership User on Exception
                                Roles.RemoveUserFromRole(model.Username, model.RoleName);
                                Membership.DeleteUser(model.Username);
                                throw new GenException(700, Resources.err_700);
                            }

                            //log for Success
                            logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create User -Post," + User.Identity.Name + ",[Params=(User Name:" + model.Username + ",Role Name:" + model.RoleName + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                            throw new GenException(120, String.Format(Resources.info_success_createUser, model.Username));
                        }
                        else if (memStatus == MembershipCreateStatus.DuplicateUserName)
                        {
                            throw new GenException(701, Resources.err_701);
                        }
                        else if (memStatus == MembershipCreateStatus.InvalidUserName)
                        {
                            throw new GenException(702, Resources.err_702);
                        }
                        else
                        {
                            throw new GenException(703, memStatus.ToString());
                        }
                    }
                    else
                    {
                        throw new GenException(850, Resources.err_950);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code == 120)
                {
                    ViewUsers();
                    return GetFormatView("UserMgt/ViewUsers.aspx");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                    auditLogger.AddEvent(LogPoint.Failure.ToString());
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                auditLogger.AddEvent(LogPoint.Failure.ToString());
            }
            return GetFormatView("UserMgt/UserDetails.aspx");
        }

        /// <summary>
        /// Action to load details of a particular user to be updated
        /// GET Method
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        [HttpGet]
        [Description("Update User")]
        public ActionResult UpdateUser(int userId)
        {
            UserDataModel model = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User," + User.Identity.Name + ",[Params=(User Id:" + userId + ")]");

                UpdateuserDropdownManupulations();

                model = GetUser(userId);

                if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                {
                    if (model.BranchId != GetUserBranchId())
                        return RedirectToAction("NotAuthorized", "LogOn");
                }

                var branchList = (ConvertBranchedToSelectList(GetBranchDataList(model.RegionId, false, false)));
                ViewData["Branches"] = branchList;

                //CPO and management can only be allocated for temp printing
                if (!(model.RoleId == new Guid("77d38667-5b15-47c1-836c-ebb798dbafde") || model.RoleId == new Guid("771511e4-56ac-4b3a-aa29-40636510b13a") || model.RoleId == new Guid("5cb24ac1-013f-4d39-98f3-0ecf810f58d4")))
                {
                    //Remove Temp Printing on user update
                    ViewData["Roles"] = ((List<SelectListItem>)ViewData["Roles"]).Where(x => x.Text.Trim() != Resources.info_role_tempPrinting.Trim()).ToList();
                }
                if (RoleAuthorizationService.IsManagement(User.Identity.Name))
                {
                    //Management User can only assign 'temp print' as user role// And that is only for management and CPO users
                    if (model.RoleId == new Guid("5cb24ac1-013f-4d39-98f3-0ecf810f58d4"))
                    {
                        string previousRole = "";
                        try
                        {
                            using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                            {
                                previousRole = (from p in context.aspnet_Roles
                                                where p.RoleId == model.PreviousRoleId
                                                select p.RoleName).FirstOrDefault();
                            }
                        }
                        catch (Exception)
                        {
                        }

                        ViewData["Roles"] = ((List<SelectListItem>)ViewData["Roles"]).Where(x => x.Text == previousRole || x.Text.Trim() == Resources.info_role_tempPrinting.Trim()).ToList();
                    }
                    else
                    {
                        ViewData["Roles"] = ((List<SelectListItem>)ViewData["Roles"]).Where(x => x.Text == model.RoleName || x.Text.Trim() == Resources.info_role_tempPrinting.Trim()).ToList();
                    }
                }

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User," + User.Identity.Name + ",[Params=(User Id:" + userId + ")]");
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, Resources.err_711));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return GetFormatView("UserMgt/UserDetails.aspx", model);
        }


        /// <summary>
        /// Action to update details of a particular user 
        /// POST Method 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken] /* DO NOT REMOVE the ANTIFORGERYTOKEN KEY. * This is done to avoid CROSS SITE REQUEST FORGERY.*/
        [Description("Update User")]
        public ActionResult UpdateUser(UserDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User - Post," + User.Identity.Name + ",[Params=(User Name:" + model.Username + ",Role Name:" + model.RoleName + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                UpdateUserPostDropdownManipulations(model);

                if (ModelState.IsValid)
                {
                    // (model.CurrentRoleName != model.RoleName)
                    //TODO: Add to model error
                    if (model.RoleName != null && model.RoleName.ToLower() == "system administrator" && (model.CurrentRoleName != model.RoleName) && Roles.GetUsersInRole("System Administrator").Length >= ApplicationSettings.MaxAllowedSystemAdmins)
                    {
                        throw new GenException(706, Resources.err_706);
                    }

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        if (model.BranchId != GetUserBranchId())
                            throw new GenException(902, "You are not authorized to update user of this branch");
                    }

                    //Update User Entity
                    UpdateUserEntity(model, false);
                    String No = model.ContactNo;
                    //log for Success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User - Post," + User.Identity.Name + ",[Params=(User Name:" + model.Username + ",Role Name:" + model.RoleName + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), model.Id);

                    throw new GenException(120, String.Format(Resources.info_success_updateUser, model.Username));
                }
                else
                {
                    throw new GenException(850, Resources.err_950);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code == 120)
                {
                    return GetFormatView("UserMgt/ViewUsers.aspx");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User - Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Name:" + model.Username + ",Role Name:" + model.RoleName + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, Resources.err_710));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User - Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Name:" + model.Username + ",Role Name:" + model.RoleName + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("UserMgt/UserDetails.aspx", model);
        }

        [Authorize(Roles = "System Administrator")]
        [Description("Locked Users")]
        public ActionResult LockedUsers()
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Locked Users," + User.Identity.Name);

                List<SelectListItem> userRoles = new List<SelectListItem>();
                userRoles.Add(new SelectListItem
                {
                    Text = "All",
                    Value = "-1",
                    Selected = true
                });
                userRoles.AddRange(ConvertToSelectList(GetRolesList()));
                ViewData["userType"] = userRoles;
                ViewData["lockedUsers"] = true;

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Locked Users," + User.Identity.Name);
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Locked Users," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Locked Users," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }

            return GetFormatView("UserMgt/ViewUsers.aspx");
        }

        [HttpPost]
        [Authorize(Roles = "System Administrator")]
        [Description("Unlock Users")]
        public ActionResult UnlockUsers(List<string> UserNames)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Unlock Users - Post," + User.Identity.Name + ",[Params=(User Count:" + ((UserNames != null) ? UserNames.Count : 0) + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                List<string> errorList = new List<string>();

                if (UserNames == null || UserNames.Count == 0)
                    throw new GenException(722, Resources.err_722);

                foreach (string item in UserNames)
                {
                    try
                    {
                        Membership.Provider.UnlockUser(item);

                        auditLogger.AddEvent(LogPoint.Success.ToString(), item, null);
                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Unlock Users - Post," + User.Identity.Name + ",[Params=(Unlocked User:" + item + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    }
                    catch (Exception ex)
                    {
                        errorList.Add(item);
                        auditLogger.AddEvent(LogPoint.Failure.ToString(), "UserName=" + item + "," + ex.ToString(), null);
                        logerr.Info(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Unlock Users - Post," + User.Identity.Name + ",[Params=(Unlocked User:" + item + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                        continue;
                    }
                }

                if (errorList.Count > 0)
                {
                    throw new GenException(721, Resources.err_721 + string.Join(", ", errorList.ToArray()));
                }

                return Json(new
                {
                    status = true,
                    message = Resources.info_success_unlock
                }, JsonRequestBehavior.AllowGet);

            }
            catch (GenException e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Locked Users - Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                return Json(new
                {
                    status = false,
                    message = e.Message
                },
                       JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Locked Users - Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                return Json(new
                    {
                        status = false,
                        message = Resources.err_720
                    },
                    JsonRequestBehavior.AllowGet);
            }
        }

        [HttpGet]
        [Authorize]
        [Description("Update Profile")]
        public ActionResult UpdateProfile()
        {
            UserDataModel model = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Profile," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                ViewData["ProfileEdit"] = true;

                UpdateuserDropdownManupulations();
                model = GetUser();

                var branchList = (ConvertBranchedToSelectList(GetBranchDataList(model.RegionId, false, false)));
                ViewData["Branches"] = branchList;

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Profile," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, Resources.err_713));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("UserMgt/UserDetails.aspx", model);
        }

        /// <summary>
        /// Action to update details of a particular user 
        /// POST Method
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken] /* DO NOT REMOVE the ANTIFORGERYTOKEN KEY. * This is done to avoid CROSS SITE REQUEST FORGERY.*/
        [Description("Update Profile")]
        public ActionResult UpdateProfile(UserDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User -Post," + User.Identity.Name + ",[Params=(User Name:" + model.Username + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                ViewData["ProfileEdit"] = true;
                UpdateUserPostDropdownManipulations(model);

                var branchList = (ConvertBranchedToSelectList(GetBranchDataList(model.RegionId, false, false)));
                ViewData["Branches"] = branchList;

                #region Security

                if (model.Username.ToLower() != User.Identity.Name.ToLower())
                {
                    //Not Authorized
                    return RedirectToAction("NotAuthorized", "LogOn");
                }

                #endregion

                if (ModelState.IsValid)
                {
                    //Update User Entity
                    UpdateUserEntity(model, true);

                    //Set Session values
                    Session["LoggedUserDetail"] = null;
                    Session["LoggedUserDetail"] = GetLoggedUserDetail();

                    //log for Success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User -Post," + User.Identity.Name + ",[Params=(User Name:" + model.Username + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), "UserName=" + model.Username, null);

                    throw new GenException(120, Resources.info_success_updateProfile);
                }
                else
                {
                    auditLogger.AddEvent(LogPoint.Failure.ToString(), "UserName=" + model.Username, null);
                    model = GetUser();
                    throw new GenException(850, Resources.err_950);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code == 120)
                {
                    SetGrowl("success", e.Message);
                    return RedirectToAction("Index", "Default");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Name:" + model.Username + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, Resources.err_712));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update User -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Name:" + model.Username + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("UserMgt/UserDetails.aspx", model);
        }

        /// <summary>
        /// Action to be activated a user who has been deactivated 
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="userid"></param>
        /// <returns></returns>
        [HttpGet]
        [Description("Activate User")]
        public ActionResult ActivateUser(int userid)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate User," + User.Identity.Name + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    UserEntity entity = (from u in context.UserEntities where u.UserId == userid select u).FirstOrDefault();
                    entity.IsEnabled = true;
                    context.SaveChanges();

                    //log for success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate User," + User.Identity.Name + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), userid);

                    throw new GenException(120, Resources.info_success_activateUser);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (Exception e)
            {
                // Include a general error msg
                // Redirect to Error.aspx page
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                ModelState.AddModelError("err", new GenException(99, Resources.err_714));
            }
            return GetFormatView("UserMgt/ViewUsers.aspx");
        }

        /// <summary>
        /// Action to be deactivated a particular user
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="userid"></param>
        /// <returns></returns>
        [HttpGet]
        [Description("Deactivate User")]
        public ActionResult DeactivateUser(int userid)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate User," + User.Identity.Name + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {

                    UserEntity entity = (from u in context.UserEntities where u.UserId == userid select u).FirstOrDefault();
                    entity.IsEnabled = false;
                    context.SaveChanges();

                    //log for success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate User," + User.Identity.Name + ",[Params=(User nameId" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), userid);

                    throw new GenException(120, Resources.info_success_deactivateUser);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (Exception e)
            {
                // Include a general error msg
                // Redirect to Error.aspx page
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                ModelState.AddModelError("err", new GenException(99, Resources.err_715));
            }
            return GetFormatView("UserMgt/ViewUsers.aspx");
        }

        /// <summary>
        /// Action to delete a particular user
        /// </summary>
        /// <param name="userName"></param>
        /// <param name="userid"></param>
        /// <returns></returns>
        [HttpGet]
        [Description("Delete User")]
        public ActionResult DeleteUser(int userid)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete User," + User.Identity.Name + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    UserEntity entity = (from u in context.UserEntities where u.UserId == userid select u).FirstOrDefault();
                    entity.IsDeleted = true;
                    context.SaveChanges();

                    //log for success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete User," + User.Identity.Name + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), userid);

                    throw new GenException(120, Resources.info_success_deleteUser);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (Exception e)
            {
                // Include a general error msg
                // Redirect to Error.aspx page
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete User," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User Id:" + userid + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                ModelState.AddModelError("err", new GenException(99, Resources.err_716));
            }
            return GetFormatView("UserMgt/ViewUsers.aspx");
        }

        /// <summary>
        /// Method to be implemented
        /// </summary>
        /// <returns></returns>
        [Description("Reset Password")]
        public ActionResult ResetPassword(string userName)
        {
            MembershipUser mu = null;
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Reset Password," + User.Identity.Name + ",[Params=(User name:" + userName + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                mu = Membership.GetUser(userName);
                if (mu != null)
                {
                    //Sasini Madhumali
                    //29/01/2016
                    //set the 'new password' parameter of the ChangePassword() method as the userName
                    mu.ChangePassword(mu.ResetPassword(), userName);

                    //ToDO: send a mail with the new password
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Reset Password," + User.Identity.Name + ",[Params=(User name:" + userName + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), "UserName=" + userName, null);

                    throw new GenException(120, String.Format(Resources.info_success_pwReset, userName));
                }
            }
            catch (GenException e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Reset Password," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User name:" + userName + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                ModelState.AddModelError("err", e);
            }
            catch (Exception e)
            {
                // Include a general error msg
                // Redirect to Error.aspx page
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Reset Password," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User name:" + userName + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                //Sasini Madhumali | 16/02/2016 | Error message for locked users
                if (mu.IsLockedOut)
                    ModelState.AddModelError("err", new GenException(99, Resources.err_723));
                else
                    ModelState.AddModelError("err", new GenException(99, Resources.err_717));
            }
            return GetFormatView("UserMgt/ViewUsers.aspx");
        }

        [Description("Is Username Available")]
        public ActionResult IsUsernameAvailable(string username)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Is Username Available," + User.Identity.Name + ",[Params=(User name:" + username + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int userId = (from u in context.vw_UserDetails
                                  where u.UserName == username
                                  select u.UserId).FirstOrDefault();

                    if (userId > 0)
                    {
                        //false
                        ModelState.AddModelError("err", Resources.err_701);
                    }
                    else
                    {
                        //true
                        TempData["SuccessMsg"] = Resources.info_success_userNameAvailable;
                    }
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Is Username Available," + User.Identity.Name + ",[Params=(User name:" + username + ")]");
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Is Username Available," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User name:" + username + ")]");
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Is Username Available," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(User name:" + username + ")]");
            }
            return GetFormatView("UserMgt/UserDetails.aspx");
        }

        #endregion

        #region Regions

        /// <summary>
        /// Get method for add region view
        /// </summary>
        /// <returns>RegionDetails.aspx</returns>
        /// <remarks></remarks>
        [Description("View Regions")]
        public ActionResult ViewRegions()
        {
            return GetFormatView("RegionMgt/ViewRegions.aspx");
        }

        /// <summary>
        /// Handler (Ajax source for region list data table)
        /// </summary>
        /// <param name="param"></param>
        /// <returns>json containing required no of RegionDataModel objects</returns>
        /// <remarks></remarks>
        [Description("Region List Ajax Handler")]
        public ActionResult RegionListAjaxHandler(JQueryDataTableParamModel param)
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Region List AjaxHandler," + User.Identity.Name);

                var isRegionNameSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
                var isRegionCodeSearchable = Convert.ToBoolean(Request["bSearchable_1"]);

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IQueryable<RegionEntity> entities = from r in context.RegionEntities orderby r.RegionName where !r.IsDeleted select r;

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        int? branchId = GetUserBranchId();
                        entities = entities.Where(x => x.Branches.Any(y => y.BranchId == branchId));
                    }

                    #region Searching Section
                    if (!String.IsNullOrEmpty(param.sSearch))
                    {
                        entities =
                            entities.Where(
                                r => isRegionNameSearchable && r.RegionName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isRegionCodeSearchable && r.RegionCode.ToLower().Contains(param.sSearch.ToLower()));
                    }
                    #endregion

                    #region Sorting Section
                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    Func<RegionEntity, string> orderingFunction;

                    switch (sortColumnIndex)
                    {
                        case 0:
                            orderingFunction = (c => c.RegionName);
                            break;
                        case 1:
                            orderingFunction = (c => c.RegionCode);
                            break;
                        default:
                            orderingFunction = (c => c.RegionName);
                            break;
                    }

                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (sortDirection == "asc")
                        entities = entities.OrderBy(orderingFunction).AsQueryable();
                    else
                        entities = entities.OrderByDescending(orderingFunction).AsQueryable();
                    #endregion

                    totalRecordCount = entities.Count();
                    entities = entities.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (RegionEntity entity in entities)
                    {
                        //Add to Mapper
                        String[] regionDetails = new String[3];
                        regionDetails[0] = entity.RegionName;
                        regionDetails[1] = entity.RegionCode;

                        string rolePermissions = GetLoggedUserDetail().RolePermissions;

                        if (entity.IsEnabled)
                        {
                            regionDetails[2] = "<div class=\"btn-group btn-group-grid \">" +
                                               "<a class=\"btn dropdown-toggle btn-small\" data-toggle=\"dropdown\" href=\"\">" +
                                               "<i class=\"icon-cog\">&nbsp;</i><span class=\"caret\"></span>" +
                                               "</a>" +
                                               "<ul class=\"dropdown-menu pull-right\">";

                            if (rolePermissions.Contains("UpdateRegion_HTML"))
                            {
                                regionDetails[2] = regionDetails[2] + "<li><a href=\"/Admin/UpdateRegion?regionId=" + entity.RegionId + "\">" + Resources.info_gen_updateRegion + "</a></li>";
                            }
                            if (rolePermissions.Contains("DeactivateRegion_HTML"))
                            {
                                regionDetails[2] = regionDetails[2] + "<li><a href=\"/Admin/DeactivateRegion?regionId=" + entity.RegionId + "\" onclick=\"return confirm('" + Resources.info_confirm_deactivateRegion + "')\">" + Resources.info_gen_deactivateRegion + "</a></li>";
                            }

                            if (rolePermissions.Contains("DeleteRegion_HTML"))
                            {
                                regionDetails[2] = regionDetails[2] + "<li><a href=\"../Admin/DeleteRegion?regionId=" + entity.RegionId + "\" onclick=\"return confirm('" + Resources.info_confirm_deleteRegion + "')\">" + Resources.info_gen_deleteRegion + "</a></li>";
                            }
                            regionDetails[2] = regionDetails[2] + "</ul></div>";
                        }
                        else
                        {
                            if (rolePermissions.Contains("ActivateRegion_HTML"))
                            {
                                regionDetails[2] = "<div class=\"btn-group btn-group-grid\"><a class=\"btn dropdown-toggle btn-small\" href=\"/Admin/ActivateRegion?regionId=" + entity.RegionId + "\" onclick=\"return confirm('" + Resources.info_confirm_activateRegion + "')\">&nbsp;&nbsp;<i class=\"icon-signin awesome-font-medium\"></i>&nbsp;</a></div>";// "<a href=\"/Admin/ActivateRegion?regionId=" + entity.RegionId + "\" onclick=\"return confirm('" + Resources.info_confirm_activateRegion + "')\">" + Resources.info_gen_activateRegion + "</a></li>";
                            }
                        }
                        jsonData.Add(regionDetails);

                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Region List AjaxHandler," + User.Identity.Name);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Region List AjaxHandler," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);

            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(111, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Region List AjaxHandler," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = totalRecordCount,
                iTotalDisplayRecords = totalRecordCount,
                aaData = jsonData
            },
            JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Description("Create Region")]
        public ActionResult CreateRegion()
        {
            return GetFormatView("RegionMgt/RegionDetails.aspx");
        }

        /// <summary>
        /// Adds a region to the database
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Create Region")]
        public ActionResult CreateRegion(RegionDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Region -Post," + User.Identity.Name + ",[Params=(Region name:" + model.RegionName + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (ModelState.IsValid)
                    {
                        #region validations

                        if (context.RegionEntities.Any(r => r.RegionCode == model.RegionCode && !r.IsDeleted))
                        {
                            throw new GenException(731, Resources.err_801);
                        }

                        if (context.RegionEntities.Any(r => r.RegionName == model.RegionName && !r.IsDeleted))
                        {
                            throw new GenException(732, Resources.err_802);
                        }

                        #endregion validations

                        //Region entity = Mapper.ToRegionEntity(model);
                        RegionEntity entity = model.ToRegionEntity();
                        entity.IsEnabled = true;
                        entity.IsDeleted = false;
                        entity.CreatedDate = DateTime.Now;
                        entity.CreatedBy = GetLoggedUserDetail().Id;

                        context.AddToRegionEntities(entity);
                        context.SaveChanges();

                        //log for Success
                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Region -Post," + User.Identity.Name + ",[Params=(Region name:" + model.RegionName + ")]");
                        auditLogger.AddEvent(LogPoint.Success.ToString(), model.RegionId);

                        throw new GenException(120, String.Format(Resources.info_success_createRegion, model.RegionName));
                    }
                    else
                    {
                        //log for error
                        auditLogger.AddEvent(LogPoint.Failure.ToString(), model.RegionId);
                        throw new GenException(850, Resources.err_950);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code == 120)
                {
                    return GetFormatView("RegionMgt/ViewRegions.aspx");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Region -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region name:" + model.RegionName + ")]");
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(730, Resources.err_800));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Region -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region name:" + model.RegionName + ")]");
            }
            return GetFormatView("RegionMgt/RegionDetails.aspx");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        [HttpGet]
        [Description("Update Region")]
        public ActionResult UpdateRegion(int regionId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region ," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    RegionEntity entity = context.RegionEntities.SingleOrDefault(r => r.RegionId == regionId && !r.IsDeleted);

                    if (entity == null)
                        throw new GenException(734, Resources.err_804);

                    RegionDataModel regionModel = new RegionDataModel(entity, false);

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region ," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");
                    return GetFormatView("RegionMgt/RegionDetails.aspx", regionModel);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(735, Resources.err_805));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
            }
            return GetFormatView("RegionMgt/RegionDetails.aspx");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Update Region")]
        public ActionResult UpdateRegion(RegionDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region -Post ," + User.Identity.Name + ",[Params=(Region Id:" + model.RegionId + ",Region Code:" + model.RegionCode + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (ModelState.IsValid)
                    {
                        #region validations

                        if (context.RegionEntities.Any(r => r.RegionCode == model.RegionCode && r.RegionId != model.RegionId && !r.IsDeleted))
                        {
                            throw new GenException(731, Resources.err_801);
                        }

                        if (context.RegionEntities.Any(r => r.RegionName == model.RegionName && r.RegionId != model.RegionId && !r.IsDeleted))
                        {
                            throw new GenException(732, Resources.err_802);
                        }

                        #endregion

                        RegionEntity entity = context.RegionEntities.SingleOrDefault(r => r.RegionId == model.RegionId && !r.IsDeleted);

                        if (entity == null)
                            throw new GenException(734, Resources.err_804);

                        entity.RegionCode = model.RegionCode;
                        entity.RegionName = model.RegionName;
                        entity.UpdatedBy = GetLoggedUserDetail().Id;
                        entity.UpdatedDate = DateTime.Now;

                        context.RegionEntities.ApplyCurrentValues(entity);
                        context.SaveChanges();

                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region -Post," + User.Identity.Name + ",[Params=(Region Id:" + model.RegionId + ",Region Code:" + model.RegionCode + ")]");
                        auditLogger.AddEvent(LogPoint.Success.ToString(), model.RegionId);

                        throw new GenException(120, String.Format(Resources.info_success_updateRegion, model.RegionName));
                    }
                    else
                    {
                        auditLogger.AddEvent(LogPoint.Failure.ToString(), model.RegionId);
                        throw new GenException(850, Resources.err_950);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code == 120)
                {
                    return GetFormatView("RegionMgt/ViewRegions.aspx");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + model.RegionId + ",Region Code:" + model.RegionCode + ")]");
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(733, Resources.err_803));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Region -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + model.RegionId + ",Region Code:" + model.RegionCode + ")]");
            }
            return GetFormatView("RegionMgt/RegionDetails.aspx", model);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        [Description("Activate Region")]
        public ActionResult ActivateRegion(int regionId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Region," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    RegionEntity entity = context.RegionEntities.SingleOrDefault(r => r.RegionId == regionId && !r.IsDeleted);

                    if (entity == null)
                        throw new GenException(734, Resources.err_804);

                    entity.IsEnabled = true;
                    context.SaveChanges();

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Region," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), regionId);

                    throw new GenException(120, String.Format(Resources.info_success_activateRegion, entity.RegionName));
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                auditLogger.AddEvent(LogPoint.Failure.ToString(), regionId);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Region," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(736, Resources.err_806));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Region," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
            }
            return GetFormatView("RegionMgt/ViewRegions.aspx");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        [Description("Deactivate Region")]
        public ActionResult DeactivateRegion(int regionId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Region," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    RegionEntity entity = context.RegionEntities.SingleOrDefault(r => r.RegionId == regionId && !r.IsDeleted);

                    if (entity == null)
                        throw new GenException(734, Resources.err_804);

                    entity.IsEnabled = false;
                    context.SaveChanges();

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Region," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), regionId);

                    throw new GenException(120, String.Format(Resources.info_success_deactivateRegion, entity.RegionName));
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Region," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
                auditLogger.AddEvent(LogPoint.Failure.ToString(), regionId);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(737, Resources.err_807));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Region," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
            }
            return GetFormatView("RegionMgt/ViewRegions.aspx");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        [Description("Delete Region")]
        public ActionResult DeleteRegion(int regionId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Region," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    RegionEntity entity = context.RegionEntities.SingleOrDefault(r => r.RegionId == regionId && !r.IsDeleted);

                    if (entity == null)
                        throw new GenException(734, Resources.err_804);

                    #region Region Deletion Validation

                    int count = entity.Branches.Where(x => x.IsDeleted == false).Count();
                    //Check available branches
                    if (count > 0)
                    {
                        throw new GenException(739, String.Format(Resources.err_809, entity.RegionName, count));
                    }

                    count = entity.Users.Where(x => x.IsDeleted == false && x.aspnet_Users.aspnet_Roles.FirstOrDefault().RoleName.ToLower() == Resources.info_role_engineer.ToLower()).Count();
                    //check available users
                    if (count > 0)
                    {
                        throw new GenException(740, String.Format(Resources.err_810, entity.RegionName, count));
                    }
                    #endregion

                    entity.IsDeleted = true;
                    context.SaveChanges();

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Region," + User.Identity.Name + ",[Params=(Region Id:" + regionId + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), regionId);

                    throw new GenException(120, String.Format(Resources.info_success_deleteRegion, entity.RegionName));
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Region," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
                    auditLogger.AddEvent(LogPoint.Failure.ToString(), regionId);
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(738, Resources.err_808));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Region," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Region Id:" + regionId + ")]");
            }
            return GetFormatView("RegionMgt/ViewRegions.aspx");
        }

        #endregion

        #region Branch

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Description("View Branches")]
        public ActionResult ViewBranches()
        {
            return GetFormatView("BranchMgt/ViewBranches.aspx");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="param"></param>
        /// <returns></returns>
        [Description("Branch List Ajax Handler")]
        public ActionResult BranchListAjaxHandler(JQueryDataTableParamModel param)
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Branch List Ajax Handler," + User.Identity.Name);

                if (!User.Identity.IsAuthenticated)
                {
                    return RedirectToAction("LogOn", "LogOn");
                }

                //Optionally check whether the columns are searchable at all
                var isBranchNameSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
                var isBranchCodeSearchable = Convert.ToBoolean(Request["bSearchable_1"]);
                var isRegionNameSearchable = Convert.ToBoolean(Request["bSearchable_2"]);
                var isBranchAddressSearchable = Convert.ToBoolean(Request["bSearchable_3"]);

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IQueryable<vw_Branches> branches = (from u in context.vw_Branches orderby u.BranchName select u);

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        int? branchId = GetUserBranchId();
                        branches = branches.Where(x => x.BranchId == branchId);
                    }

                    #region Searching Section
                    if (!String.IsNullOrEmpty(param.sSearch))
                    {
                        branches =
                            branches.Where(
                                u => isBranchNameSearchable && u.BranchName.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isBranchCodeSearchable && u.BranchCode.ToLower().Contains(param.sSearch.ToLower())
                                     ||
                                     isRegionNameSearchable && u.RegionName.Contains(param.sSearch.ToLower())
                                     ||
                                     isBranchAddressSearchable && u.BranchAddress.ToLower().Contains(param.sSearch.ToLower()));
                    }
                    #endregion

                    #region Sorting Section
                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    Func<vw_Branches, object> orderingFunction;

                    switch (sortColumnIndex)
                    {
                        case 0:
                            orderingFunction = (c => c.BranchName);
                            break;
                        case 1:
                            orderingFunction = (c => c.BranchCode);
                            break;
                        case 2:
                            orderingFunction = (c => c.RegionName);
                            break;
                        case 3:
                            orderingFunction = (c => c.BranchAddress);
                            break;
                        case 4:
                            orderingFunction = (c => c.IsClaimProcessed);
                            break;
                        default:
                            orderingFunction = (c => c.BranchName);
                            break;
                    }

                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (sortDirection == "asc")
                        branches = branches.OrderBy(orderingFunction).AsQueryable();
                    else
                        branches = branches.OrderByDescending(orderingFunction).AsQueryable();
                    #endregion

                    totalRecordCount = branches.Count();
                    branches = branches.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (vw_Branches br in branches)
                    {
                        //Add to Mapper
                        String[] brDetails = new String[6];
                        brDetails[0] = br.BranchName;
                        brDetails[1] = br.BranchCode;
                        brDetails[2] = br.RegionName;
                        brDetails[3] = br.BranchAddress;
                        brDetails[4] = (br.IsClaimProcessed) ? Resources.info_gen_y : Resources.info_gen_n;

                        string rolePermissions = GetLoggedUserDetail().RolePermissions;

                        if ((bool)br.IsEnabled)
                        {
                            StringBuilder sb = new StringBuilder("<div class=\"btn-group btn-group-grid\">" +
                                           "<a class=\"btn dropdown-toggle btn-small\" data-toggle=\"dropdown\" href=\"\">" +
                                           "<i class=\"icon-cog\">&nbsp;</i><span class=\"caret\"></span>" +
                                           "</a>" +
                                           "<ul class=\"dropdown-menu pull-right\">");

                            if (rolePermissions.Contains("UpdateBranch_HTML"))
                            {
                                sb.Append("<li><a href=\"/Admin/UpdateBranch?branchId=" + br.BranchId + "\">" + Resources.info_gen_updateBranch + " </a></li>");
                            }
                            if (rolePermissions.Contains("DeactivateBranch_HTML"))
                            {
                                sb.Append("<li><a href=\"../Admin/DeactivateBranch?branchId=" + br.BranchId + "\" onclick=\"return confirm('" + Resources.info_confirm_deactivateBranch + "')\">" + Resources.info_gen_deactivateBranch + "</a></li>");
                            }
                            if (rolePermissions.Contains("DeleteBranch_HTML"))
                            {
                                sb.Append("<li><a href=\"../Admin/DeleteBranch?branchId=" + br.BranchId + "\" onclick=\"return confirm('" + Resources.info_confirm_deleteBranch + "')\">" + Resources.info_gen_deleteBranch + "</a></li>");
                            }
                            sb.Append("</ul></div>");

                            brDetails[5] = sb.ToString();
                        }
                        else
                        {
                            if (rolePermissions.Contains("ActivateBranch_HTML"))
                            {
                                brDetails[5] = "<div class=\"btn-group btn-group-grid\"><a class=\"btn dropdown-toggle btn-small\" href=\"../Admin/ActivateBranch?branchId=" + br.BranchId + "\" onclick=\"return confirm('" + Resources.info_confirm_activateBranch + "')\">&nbsp;&nbsp;<i class=\"icon-signin awesome-font-medium\"></i>&nbsp;</a></div>";// "<a href=\"../Admin/ActivateBranch?branchId=" + br.BranchId + "\" onclick=\"return confirm('" + Resources.info_confirm_activateBranch + "')\">" + Resources.info_gen_activateBranch + "</a>";
                            }
                        }

                        jsonData.Add(brDetails);

                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Branch List Ajax Handler," + User.Identity.Name);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Branch List Ajax Handler," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(111, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Branch List Ajax Handler," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = totalRecordCount,
                iTotalDisplayRecords = totalRecordCount,
                aaData = jsonData
            },
            JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Description("Create Branch")]
        public ActionResult CreateBranch()
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch," + User.Identity.Name);
                PopulateRegions();

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch," + User.Identity.Name);
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(111, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return GetFormatView("BranchMgt/BranchDetails.aspx");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Create Branch")]
        public ActionResult CreateBranch(BranchDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch -Post," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                PopulateRegions();

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (ModelState.IsValid)
                    {
                        #region validations

                        //TODO: Add to model validations
                        if (context.BranchEntities.Any(br => br.BranchCode == model.BranchCode && !br.IsDeleted))
                        {
                            throw new GenException(820, Resources.err_821);
                        }

                        if (context.BranchEntities.Any(br => br.BranchName == model.BranchName && !br.IsDeleted))
                        {
                            throw new GenException(821, Resources.err_822);
                        }

                        #endregion validations

                        BranchEntity entity = model.ToBranchEntity();
                        entity.IsEnabled = true;
                        entity.IsDeleted = false;
                        entity.CreatedBy = GetLoggedUserDetail().Id;
                        entity.CreatedDate = DateTime.Now;

                        context.AddToBranchEntities(entity);
                        context.SaveChanges();

                        //log for Success
                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch -Post," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                        auditLogger.AddEvent(LogPoint.Success.ToString(), model.BranchId);

                        throw new GenException(120, String.Format(Resources.info_success_createBranch, model.BranchName));
                    }
                    else
                    {
                        //log for error
                        auditLogger.AddEvent(LogPoint.Failure.ToString(), model.BranchId);
                        throw new GenException(850, Resources.err_950);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code == 120)
                {
                    return GetFormatView("BranchMgt/ViewBranches.aspx");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(820, Resources.err_820));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Branch -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return GetFormatView("BranchMgt/BranchDetails.aspx");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="branchId"></param>
        /// <returns></returns>
        [Description("Update Branch")]
        public ActionResult UpdateBranch(int branchId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch," + User.Identity.Name + ",[Params=(Branch Id: " + branchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                PopulateRegions();

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    BranchEntity entity = context.BranchEntities.SingleOrDefault(br => br.BranchId == branchId && !br.IsDeleted);

                    if (entity == null)
                        throw new GenException(824, Resources.err_824);

                    BranchDataModel model = new BranchDataModel(entity);

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch," + User.Identity.Name + ",[Params=(Branch Id: " + branchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    return GetFormatView("BranchMgt/BranchDetails.aspx", model);
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(825, Resources.err_825));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }

            return GetFormatView("BranchMgt/BranchDetails.aspx");
        }

        /// <summary>
        /// Action to update a particular branch 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Update Branch")]
        public ActionResult UpdateBranch(BranchDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch -Post," + User.Identity.Name + ",[Params=(Branch Id: " + model.BranchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                CreateBranch();

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (ModelState.IsValid)
                    {
                        //TODO: Add to model validations
                        if (context.BranchEntities.Any(br => br.BranchCode == model.BranchCode && br.BranchId != model.BranchId && !br.IsDeleted))
                        {
                            throw new GenException(821, Resources.err_821);
                        }

                        BranchEntity entity = context.BranchEntities.SingleOrDefault(br => br.BranchId == model.BranchId && !br.IsDeleted);

                        if (entity == null)
                            throw new GenException(824, Resources.err_824);

                        entity.RegionId = model.RegionId;
                        entity.BranchCode = model.BranchCode;
                        entity.BranchName = model.BranchName;
                        entity.BranchAddress = model.Address;
                        entity.IsClaimProcessed = model.IsClaimProcessed;
                        entity.UpdatedBy = GetLoggedUserDetail().Id;
                        entity.UpdatedDate = DateTime.Now;

                        context.BranchEntities.ApplyCurrentValues(entity);
                        context.SaveChanges();

                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch -Post," + User.Identity.Name + ",[Params=(Branch Id: " + model.BranchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                        auditLogger.AddEvent(LogPoint.Success.ToString(), model.BranchId);

                        throw new GenException(120, String.Format(Resources.info_success_updateBranch, model.BranchName));
                    }
                    else
                    {
                        //log for error                        
                        auditLogger.AddEvent(LogPoint.Failure.ToString(), model.BranchId);
                        throw new GenException(850, Resources.err_950);
                    }
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                if (e.Code == 120)
                {
                    return GetFormatView("BranchMgt/ViewBranches.aspx");
                }
                else
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + model.BranchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(823, Resources.err_823));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Update Branch -Post," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + model.BranchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("BranchMgt/BranchDetails.aspx", model);
        }

        /// <summary>
        /// Branch activation
        /// </summary>
        /// <param name="BranchId"></param>
        /// <returns></returns>
        [Description("Activate Branch")]
        public ActionResult ActivateBranch(int BranchId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Branch ," + User.Identity.Name + ",[Params=(Branch Id: " + BranchId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    BranchEntity entity = context.BranchEntities.SingleOrDefault(br => br.BranchId == BranchId && !br.IsDeleted);

                    if (entity == null)
                        throw new GenException(824, Resources.err_824);

                    entity.IsEnabled = true;

                    context.BranchEntities.ApplyCurrentValues(entity);
                    context.SaveChanges();

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Branch ," + User.Identity.Name + ",[Params=(Branch Id: " + BranchId + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), BranchId);

                    throw new GenException(120, String.Format(Resources.info_success_activateBranch, entity.BranchName));
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Branch ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + BranchId + ")]");
                    auditLogger.AddEvent(LogPoint.Failure.ToString(), BranchId);
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(826, Resources.err_826));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Activate Branch ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + BranchId + ")]");
            }
            return GetFormatView("BranchMgt/ViewBranches.aspx");
        }

        /// <summary>
        /// Branch deactivation
        /// </summary>
        /// <param name="branchId"></param>
        /// <returns></returns>
        [Description("Deactivate Branch")]
        public ActionResult DeactivateBranch(int branchId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Branch ," + User.Identity.Name + ",[Params=(Branch Id: " + branchId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    BranchEntity entity = context.BranchEntities.SingleOrDefault(br => br.BranchId == branchId && !br.IsDeleted);

                    if (entity == null)
                        throw new GenException(824, Resources.err_824);

                    entity.IsEnabled = false;
                    context.BranchEntities.ApplyCurrentValues(entity);
                    context.SaveChanges();

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Branch ," + User.Identity.Name + ",[Params=(Branch Id: " + branchId + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), branchId);

                    throw new GenException(120, String.Format(Resources.info_success_deactivateBranch, entity.BranchName));
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Branch ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + branchId + ")]");
                    auditLogger.AddEvent(LogPoint.Failure.ToString(), branchId);
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(827, Resources.err_827));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Deactivate Branch ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + branchId + ")]");
            }
            return GetFormatView("BranchMgt/ViewBranches.aspx");
        }

        /// <summary>
        /// branch deletion
        /// </summary>
        /// <param name="branchId"></param>
        /// <returns></returns>
        [Description("Delete Branch")]
        public ActionResult DeleteBranch(int branchId)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Branch ," + User.Identity.Name + ",[Params=(Branch Id: " + branchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    BranchEntity entity = context.BranchEntities.SingleOrDefault(br => br.BranchId == branchId && !br.IsDeleted);

                    if (entity == null)
                        throw new GenException(824, Resources.err_824);

                    #region User Count Validation

                    int count = entity.Users.Where(x => x.IsDeleted == false).Count();

                    if (count > 0)
                    {
                        throw new GenException(121, String.Format(Resources.err_829, entity.BranchName, count));
                    }
                    #endregion

                    entity.IsDeleted = true;
                    entity.DeletedDate = DateTime.Now;

                    context.BranchEntities.ApplyCurrentValues(entity);
                    context.SaveChanges();

                    logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Branch ," + User.Identity.Name + ",[Params=(Branch Id: " + branchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), branchId);

                    throw new GenException(120, String.Format(Resources.info_success_deleteBranch, entity.BranchName));
                }
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);

                if (e.Code != 120)
                {
                    logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Branch ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + branchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Failure.ToString(), branchId);
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(828, Resources.err_828));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Delete Branch ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Branch Id: " + branchId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("BranchMgt/ViewBranches.aspx");
        }

        #endregion

        #region App Management

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [Description("App Management")]
        public ActionResult AppManagement(AppDataModel model)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AppManagement," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                string CurrentWebVersion = ApplicationSettings.CurrentWebVersion;
                string MinimumSupportedAppVersion = ApplicationSettings.MinimumSupportedAppVersion;
                string LatestAppVersioninGooglePlay = ApplicationSettings.LatestAppVersioninGooglePlay;
                string GooglePlayAppURL = ApplicationSettings.GooglePlayAppURL;
                string ForceLatestVersionToUsers = ApplicationSettings.ForceLatestVersionToUsers;
                string MaximumAllowedDraftsCount = ApplicationSettings.MaximumAllowedDraftsCount;

                if (model == null || model.CurrentWebVersion == null || String.IsNullOrWhiteSpace(model.CurrentWebVersion))
                {
                    //GET
                    using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                    {
                        SettingEntity entity1 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(CurrentWebVersion));
                        SettingEntity entity2 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(MinimumSupportedAppVersion));
                        SettingEntity entity3 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(LatestAppVersioninGooglePlay));
                        SettingEntity entity4 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(ForceLatestVersionToUsers));
                        SettingEntity entity5 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(GooglePlayAppURL));
                        SettingEntity entity6 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(MaximumAllowedDraftsCount));


                        model = new AppDataModel();
                        model.CurrentWebVersion = (entity1 != null) ? entity1.SettingValue : "";
                        model.MinimumSupportedAppVersion = (entity2 != null) ? entity2.SettingValue : "";
                        model.LatestAppVersioninGooglePlay = (entity3 != null) ? entity3.SettingValue : "";
                        model.ForceLatestVersionToUsers = (entity4 != null) ? Convert.ToBoolean(entity4.SettingValue) : false;
                        model.GooglePlayAppURL = (entity5 != null) ? entity5.SettingValue : "";
                        model.MaximumAllowedDraftsCount = (entity5 != null) ? entity6.SettingValue : "0";
                    }
                }
                else
                {
                    //POST
                    if (!ModelState.IsValid) throw new GenException(850, Resources.err_950);

                    string errMsg = "";
                    Version result;
                    Uri uriResult;
                    if (String.IsNullOrWhiteSpace(model.CurrentWebVersion))
                        errMsg += CurrentWebVersion + " can't be empty<br />";
                    else
                        if (!Version.TryParse(model.CurrentWebVersion, out result))
                            errMsg += CurrentWebVersion + " format should be X.X.X<br />";

                    if (String.IsNullOrWhiteSpace(model.MinimumSupportedAppVersion))
                        errMsg += MinimumSupportedAppVersion + " can't be empty<br />";
                    else
                        if (!Version.TryParse(model.MinimumSupportedAppVersion, out result))
                            errMsg += MinimumSupportedAppVersion + " format should be X.X.X<br />";

                    if (String.IsNullOrWhiteSpace(model.LatestAppVersioninGooglePlay))
                        errMsg += LatestAppVersioninGooglePlay + " can't be empty<br />";
                    else
                        if (!Version.TryParse(model.LatestAppVersioninGooglePlay, out result))
                            errMsg += LatestAppVersioninGooglePlay + " format should be X.X.X<br />";

                    if (String.IsNullOrWhiteSpace(model.GooglePlayAppURL))
                        errMsg += "Google Play App URL can't be empty<br />";
                    else
                        if (!Uri.TryCreate(model.GooglePlayAppURL, UriKind.Absolute, out uriResult))
                            errMsg += "Google Play App URL is not in a valid URL format<br />";

                    if (String.IsNullOrWhiteSpace(model.MaximumAllowedDraftsCount))
                        errMsg += MaximumAllowedDraftsCount + " can't be empty<br />";
                    else
                        if (model.MaximumAllowedDraftsCount == "0")
                            errMsg += MaximumAllowedDraftsCount + " can't be zero<br />";


                    if (Version.TryParse(model.LatestAppVersioninGooglePlay, out result) && Version.TryParse(model.MinimumSupportedAppVersion, out result))
                    {
                        Version v1 = new Version(model.MinimumSupportedAppVersion);
                        Version v2 = new Version(model.LatestAppVersioninGooglePlay);

                        if (v1 > v2)
                            errMsg += MinimumSupportedAppVersion + " can't be a higher version than " + LatestAppVersioninGooglePlay + "<br />";
                    }

                    if (!String.IsNullOrWhiteSpace(errMsg))
                        ModelState.AddModelError("err", new GenException(0, errMsg));

                    if (ModelState.Keys.Contains("err"))
                        return GetFormatView("AppMgt/AppManagement.aspx", model);

                    #region Save data to database
                    using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                    {
                        #region CurrentWebVersion
                        SettingEntity entity1 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(CurrentWebVersion));
                        if (entity1 == null)
                        {
                            entity1 = new SettingEntity { SettingName = CurrentWebVersion, SettingValue = model.CurrentWebVersion };
                            context.SettingEntities.AddObject(entity1);
                        }
                        else
                        {
                            entity1.SettingValue = model.CurrentWebVersion;
                            context.SettingEntities.ApplyCurrentValues(entity1);
                        }
                        #endregion

                        #region MinimumSupportedAppVersion
                        SettingEntity entity2 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(MinimumSupportedAppVersion));
                        if (entity2 == null)
                        {
                            entity2 = new SettingEntity { SettingName = MinimumSupportedAppVersion, SettingValue = model.MinimumSupportedAppVersion };
                            context.SettingEntities.AddObject(entity2);
                        }
                        else
                        {
                            entity2.SettingValue = model.MinimumSupportedAppVersion;
                            context.SettingEntities.ApplyCurrentValues(entity2);
                        }
                        #endregion

                        #region LatestAppVersioninGooglePlay
                        SettingEntity entity3 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(LatestAppVersioninGooglePlay));
                        if (entity3 == null)
                        {
                            entity3 = new SettingEntity { SettingName = LatestAppVersioninGooglePlay, SettingValue = model.LatestAppVersioninGooglePlay };
                            context.SettingEntities.AddObject(entity3);
                        }
                        else
                        {
                            entity3.SettingValue = model.LatestAppVersioninGooglePlay;
                            context.SettingEntities.ApplyCurrentValues(entity3);
                        }
                        #endregion

                        #region GooglePlayAppURL
                        SettingEntity entity4 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(ForceLatestVersionToUsers));
                        if (entity4 == null)
                        {
                            entity4 = new SettingEntity { SettingName = ForceLatestVersionToUsers, SettingValue = model.ForceLatestVersionToUsers.ToString() };
                            context.SettingEntities.AddObject(entity4);
                        }
                        else
                        {
                            entity4.SettingValue = model.ForceLatestVersionToUsers.ToString();
                            context.SettingEntities.ApplyCurrentValues(entity4);
                        }
                        #endregion

                        #region GooglePlayAppURL
                        SettingEntity entity5 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(GooglePlayAppURL));
                        if (entity5 == null)
                        {
                            entity5 = new SettingEntity { SettingName = GooglePlayAppURL, SettingValue = model.GooglePlayAppURL };
                            context.SettingEntities.AddObject(entity5);
                        }
                        else
                        {
                            entity5.SettingValue = model.GooglePlayAppURL;
                            context.SettingEntities.ApplyCurrentValues(entity5);
                        }
                        #endregion

                        #region MaximumAllowedDraftsCount
                        SettingEntity entity6 = context.SettingEntities.SingleOrDefault(br => br.SettingName == MaximumAllowedDraftsCount);
                        if (entity6 == null)
                        {
                            entity6 = new SettingEntity { SettingName = MaximumAllowedDraftsCount, SettingValue = model.MaximumAllowedDraftsCount };
                            context.SettingEntities.AddObject(entity6);
                        }
                        else
                        {
                            entity6.SettingValue = model.MaximumAllowedDraftsCount;
                            context.SettingEntities.ApplyCurrentValues(entity6);
                        }
                        #endregion

                        context.SaveChanges();
                    }
                    #endregion

                    //NOTE: 120 means success
                    ModelState.AddModelError("err", new GenException(120, "App management information successfully saved"));
                }
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AppManagement," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                auditLogger.AddEvent(LogPoint.Failure.ToString());
            }
            finally
            {
                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AppManagement," + User.Identity.Name + ",[Params=()]");
                auditLogger.AddEvent(LogPoint.Success.ToString(), "");
            }
            return GetFormatView("AppMgt/AppManagement.aspx", model);
        }

        [Description("Get Maximum Allowed Drafts Count")]
        public ActionResult GetMaximumAllowedDraftsCount()
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    SettingEntity entity6 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(ApplicationSettings.MaximumAllowedDraftsCount));
                    Dictionary<string, string> result = new Dictionary<string, string>();
                    result.Add("DraftsCount", entity6.SettingValue);
                    return JsonResult(result);
                    //return Json(new { entity6.SettingValue },JsonRequestBehavior.AllowGet);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        #endregion      

        #endregion

        #region NonActions

        [NonAction]
        [Description("Update User Entity")]
        private void UpdateUserEntity(UserDataModel model, bool isProfileEdit)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    UserEntity entity = (from u in context.UserEntities where u.UserId == model.Id select u).FirstOrDefault();

                    entity.FirstName = model.FirstName;
                    entity.LastName = model.LastName;
                    entity.Code = model.CSRCode;
                    entity.EPFNo = model.EPFNo;
                    entity.PrimaryEmail = model.Email;
                    entity.ContactNo = model.ContactNo;

                    if (!isProfileEdit)
                    {
                        entity.BranchId = model.BranchId;
                        entity.RegionId = model.RegionId;
                        entity.DataAccessLevel = model.DataAccessLevel;

                        if (model.RoleName.ToLower() == Resources.info_role_tempPrinting.ToLower() && (model.CurrentRoleName != model.RoleName)/*Check if role is updated*/)
                        {
                            entity.PreviousRoleId = (from r in context.aspnet_Roles
                                                     where r.RoleName == model.CurrentRoleName
                                                     select r.RoleId).FirstOrDefault();
                            entity.PreviousRoleChangedDate = DateTime.Now;
                        }
                    }

                    entity.UpdatedBy = GetLoggedUserDetail().Id;
                    entity.UpdatedDate = DateTime.Now;

                    int rows = context.SaveChanges();

                    if (rows > 0 && (model.CurrentRoleName != model.RoleName)/*Check if role is updated*/ && !isProfileEdit)
                    {
                        try
                        {
                            Roles.AddUserToRole(model.Username, model.RoleName);
                            Roles.RemoveUserFromRole(model.Username, model.CurrentRoleName);
                        }
                        catch (Exception)
                        {
                            throw new GenException(705, Resources.err_705);
                        }
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        /// <summary>
        ///Method to get Roles list from the database 
        /// </summary>
        /// <returns></returns>
        [Description("Get Roles List")]
        public static List<KeyValuePair<Guid, string>> GetRolesList()
        {
            List<KeyValuePair<Guid, string>> list = new List<KeyValuePair<Guid, string>>();
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<aspnet_Roles> query = from u in context.aspnet_Roles orderby u.RoleId select u;

                    foreach (aspnet_Roles val in query)
                    {
                        Guid key = val.RoleId;
                        string value = val.RoleName;
                        list.Add(new KeyValuePair<Guid, string>(key, value));
                    }
                    return list;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        ///Method to get Roles list from the database 
        /// </summary>
        /// <returns></returns>
        [Description("Get Role Name List")]
        public static List<KeyValuePair<string, string>> GetRoleNameList()
        {
            List<KeyValuePair<string, string>> list = new List<KeyValuePair<string, string>>();
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<aspnet_Roles> query = from u in context.aspnet_Roles orderby u.RoleName select u;

                    list.AddRange(query.Select(val => new KeyValuePair<string, string>(val.RoleName, val.RoleName)));
                    return list;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// Get list of roles will "All" list item to dropdown controls
        /// as a json
        /// </summary>
        /// <returns>a json list of roles</returns>
        [HttpPost]
        [Description("Get Roles List - Json")]
        public JsonResult GetRolesListJson()
        {
            try
            {
                List<KeyValuePair<string, string>> list = new List<KeyValuePair<string, string>>();
                list.Add(new KeyValuePair<string, string>(Resources.info_gen_all, Resources.info_gen_all));
                list.AddRange(GetRoleNameList());
                return Json(new
                {
                    Data = list
                },
               JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {
                return new JsonResult
                {
                    Data = Resources.err_901
                };
            }

        }

        /// <summary>
        ///  Method to convert Roles list into Roles SelectItem list 
        /// </summary>
        /// <param name="keyValueList"></param>
        /// <returns></returns>
        [Description("Convert To Select List")]
        public List<SelectListItem> ConvertToSelectList(List<KeyValuePair<Guid, string>> keyValueList)
        {
            try
            {

                return keyValueList.Select(item => new SelectListItem
                                                       {
                                                           Text = item.Value,
                                                           Value = item.Key.ToString()
                                                       }).ToList();
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// Get set of branches related to a given region id 
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        [Description("Get Branch Data List")]
        public static List<BranchDataModel> GetBranchDataList(int regionId, bool isClaimProcessed, bool includeInactive)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<vw_Branches> query = from u in context.vw_Branches where (u.RegionId == regionId) && !u.IsDeleted orderby u.BranchName select u;

                    if (!includeInactive)
                    {
                        query = query.Where(x => x.IsEnabled);
                    }
                    if (isClaimProcessed)
                    {
                        query = query.Where(x => x.IsClaimProcessed == true);
                    }

                    List<BranchDataModel> branches = (from u in query
                                                      select new BranchDataModel
                                                      {
                                                          BranchName = u.BranchName,
                                                          BranchId = u.BranchId,
                                                      }).ToList();
                    return branches;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }


        /// <summary>
        /// Convert a set of branches model into a select item list
        /// </summary>
        /// <param name="branches"></param>
        /// <returns></returns>
        [Description("Convert Branched To Select List")]
        public List<SelectListItem> ConvertBranchedToSelectList(List<BranchDataModel> branches)
        {
            try
            {
                return branches.Select(item => new SelectListItem
                                                   {
                                                       Text = item.BranchName,
                                                       Value = item.BranchId.ToString()
                                                   }).ToList();
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        [Description("Populate Regions")]
        private void PopulateRegions()
        {
            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRegion,
                Value = "",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;
        }

        /// <summary>
        /// 
        /// </summary>
        [NonAction]
        [Description("Dropdown Manipulations")]
        private void DropdownManipulations()
        {
            //roles
            List<SelectListItem> userroles = new List<SelectListItem>();
            userroles.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRole,
                Value = "-1",
                Selected = true
            });
            userroles.AddRange(ConvertToSelectList(GetRoleNameList()));
            ViewData["Roles"] = userroles;

            //branches
            List<SelectListItem> branchList = new List<SelectListItem>();
            branchList.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectBranch,
                Value = "-1",
                Selected = true
            });
            ViewData["Branches"] = branchList;

            //regions
            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRegion,
                Value = "-1",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            List<SelectListItem> accessLevels = new List<SelectListItem>();
            accessLevels.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectAccessLevel,
                Value = "-1",
                Selected = true
            });
            accessLevels.AddRange(GetSelectListFromEnum(typeof(UserDataAccessLevel)));
            ViewData["AccessLevels"] = accessLevels;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [NonAction]
        [Description("Update User Dropdown Manupulations")]
        private void UpdateuserDropdownManupulations()
        {
            List<SelectListItem> userroles = new List<SelectListItem>();
            userroles.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRole,
                Value = "-1",
                Selected = true
            });
            userroles.AddRange(ConvertToSelectList(GetRoleNameList()));
            ViewData["Roles"] = userroles;

            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRegion,
                Value = "-1",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            List<SelectListItem> accessLevels = new List<SelectListItem>();
            accessLevels.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectAccessLevel,
                Value = "-1",
                Selected = true
            });
            accessLevels.AddRange(GetSelectListFromEnum(typeof(UserDataAccessLevel)));
            ViewData["AccessLevels"] = accessLevels;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        [NonAction]
        [Description("Update User Post Dropdown Manipulations")]
        private void UpdateUserPostDropdownManipulations(UserDataModel model)
        {
            List<SelectListItem> userroles = new List<SelectListItem>();
            userroles.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRole,
                Value = "",
                Selected = true
            });
            userroles.AddRange(ConvertToSelectList(GetRoleNameList()));
            ViewData["Roles"] = userroles;

            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectRegion,
                Value = "",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            List<SelectListItem> branchList = new List<SelectListItem>();
            branchList.AddRange(ConvertBranchedToSelectList(GetBranchDataList(model.RegionId, false, false)));
            ViewData["Branches"] = branchList;

            List<SelectListItem> accessLevels = new List<SelectListItem>();
            accessLevels.Add(new SelectListItem
            {
                Text = Resources.info_gen_selectAccessLevel,
                Value = "-1",
                Selected = true
            });
            accessLevels.AddRange(GetSelectListFromEnum(typeof(UserDataAccessLevel)));
            ViewData["AccessLevels"] = accessLevels;
        }

        #endregion
    }
}
