using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data.SqlClient;
//using SLIC2.Models.Entity;
using System.Web.Security;
using System.Web.SessionState;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Auth
{

    public class RoleAuthorizationService
    {
        // TODO : Change this when new role is added
        static aspnet_Roles[] rolesinDB;
        
        static RoleAuthorizationService()
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    rolesinDB = (from p in context.aspnet_Roles select p).ToArray();
                }
            }
            catch (Exception)
            {                
                throw;  
            }
        }

        public static Boolean IsAuthorized(string action_fmt)
        {
            bool status = false;
            try
            {
                string[] userroles = Roles.GetRolesForUser(HttpContext.Current.User.Identity.Name);

                foreach (var userrole in userroles)
                {
                    status= rolesinDB.Any(x => ((x.RoleName == userrole) && (x.Description.Contains(action_fmt))));

                    //for multiple roles
                    if (status)
                    {
                        break;
                    }
                }              
            }
            catch (Exception)
            {
                throw;
            }
            return status;
        }

        public static string GetUserActions()
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(HttpContext.Current.User.Identity.Name);
                return rolesinDB.Where(x => x.RoleName == userroles[0]).FirstOrDefault().Description;
            }
            catch (Exception)
            {
                throw;
            }
        }

        public static string GetUserActions(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return rolesinDB.Where(x => x.RoleName == userroles[0]).FirstOrDefault().Description;
            }
            catch (Exception)
            {
                throw;
            }
        }


        #region Role Check

        public static bool IsEngineer(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return userroles.Contains("Engineer");
            }
            catch (Exception)
            {}
            return false;
        }

        public static bool IsAudit(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return userroles.Contains("Audit");
            }
            catch (Exception)
            { }
            return false;
        }

        public static bool IsClaimProcessingOfficer(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return userroles.Contains("Claim Processing Officer");
            }
            catch (Exception)
            { }
            return false;
        }

        public static bool IsSystemAdministrator(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return userroles.Contains("System Administrator");
            }
            catch (Exception)
            { }
            return false;
        }

        public static bool IsTechnicalOfficer(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return userroles.Contains("Technical Officer");
            }
            catch (Exception)
            { }
            return false;
        }

        public static bool IsTempPrinting(string userName)
        {
            try
            {
                string[] userroles = Roles.GetRolesForUser(userName);
                return userroles.Contains("Temp Printing");
            }
            catch (Exception)
            { }
            return false;
        }

        public static bool IsManagement(string userName)
        {
            try
            {
                return Roles.IsUserInRole(userName, "Management");               
            }
            catch (Exception)
            { }
            return false;
        }
        #endregion

    }
}