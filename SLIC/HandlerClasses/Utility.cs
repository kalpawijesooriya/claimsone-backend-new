using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.Reports;
using com.IronOne.SLIC2.Models.EntityModel;
using System.EnterpriseServices;

namespace com.IronOne.SLIC2.HandlerClasses
{
    public class Utility
    {
        /// <summary>
        /// Created by : Uthpala Pathirana
        /// Created on : 03/01/2017
        /// </summary>
        /// <returns></returns>
        [Description("Get TO List")]
        public static List<TOPerformanceModel> GetTOs(int regionId)
        {
            try
            {
                List<TOPerformanceModel> technicalOfficers = new List<TOPerformanceModel>();
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<UserEntity> userList = new List<UserEntity>();
                    List<TOPerformanceModel> TO = new List<TOPerformanceModel>();
                    Guid g = new Guid("3147D396-C9D9-4A25-9F61-AA48072961F2");

                    var TOIds = context.vw_aspnet_UsersInRoles.Where(a => a.RoleId.Equals(g));
                    foreach (var item in TOIds)
                    {
                        TO.Add(new TOPerformanceModel { Name = item.UserId.ToString() });
                    }


                    if (regionId == -1)
                    {
                        //all
                        userList = context.UserEntities.Where(u => u.UserId != null).ToList();
                    }
                    else
                    {
                        //region wise
                        userList = context.UserEntities.Where(u => u.UserId != null && u.RegionId == regionId).ToList();
                    }

                    technicalOfficers = userList.Join(TOIds, s => s.UserGUID.ToString(), a => a.UserId.ToString(), (s, a) =>
                        new TOPerformanceModel
                        {
                            TOCode = s.UserId,
                            Name = s.EPFNo+" - "+ s.FirstName + " " + s.LastName,
                            EPFNumber = Convert.ToInt32(s.EPFNo)
                        }).OrderBy(s => s.EPFNumber).ToList();
                }
                return technicalOfficers;
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// Created by : Uthpala Pathirana
        /// Created on : 03/01/2017
        /// </summary>
        /// <returns></returns>
        [Description("Get Region Data List")]
        public static int GetRegions(int regionId)
        {

            return 0;
        }
    }
}