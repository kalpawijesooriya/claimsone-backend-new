using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.EnterpriseServices;
using com.IronOne.SLIC2.Models.Job;
using com.IronOne.SLIC2.Models.Reports;
using com.IronOne.SLIC2.Models.Enums;
using log4net;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.IronUtils;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.SLIC2.Lang;
using com.IronOne.SLIC2.HandlerClasses;
using System.Globalization;
using System.Configuration;
using System.Data.SqlClient;
using System.Data.Objects;

namespace com.IronOne.SLIC2.Controllers
{
    /// <summary>
    ///  <title></title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2012-mm-dd</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary>
    public class ReportController : BaseController
    {
        protected static readonly ILog logevt = LogManager.GetLogger("EventLog");
        protected static readonly ILog logerr = LogManager.GetLogger("ErrorLog");
        string rptDateFormat = "yyyy-MM-dd HH.mm.ss";

        [Description("Index")]
        public ActionResult Index()
        {
            return View();
        }

        [Description("Outstanding SA Test")]
        public ActionResult OutstandingSATest(OutstandingJobsModel Model)
        {
            if (Model.Name == "All")
            {
                Model.Name = null;
            }
            UserDataModel user = new UserDataModel();
            List<SelectListItem> techOfficersList = new List<SelectListItem>();
            List<SelectListItem> regionList = new List<SelectListItem>();

            user = GetLoggedUserDetail();


            //Regions including All

            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1"
            });
            if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            }
            else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));
            }

            //If selected manually
            if (Model.RegionName != null)
            {
                if (Model.RegionName != "-1")
                {
                    //not null and not all
                    regionList.First(x => x.Value == Model.RegionName).Selected = true;
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = null,
                    });
                }
            }

            if (user.RoleName != Resources.info_role_engineer)
            {
                if (Model.RegionName == null)
                {
                    regionList.First(x => x.Value == "-1").Selected = true;
                }
            }
            else
            {
                string regionId = user.RegionId.ToString();
                regionList.First(x => x.Value == regionId).Selected = true;
                techOfficersList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                });
            }

            //TOs including All
            if (Model.RegionName == "-1" || Model.RegionName == null)
            {
                if (user.RoleName != Resources.info_role_engineer)
                {
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = "-1",
                    });
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(-1)));
                }
                else
                {
                    ViewData["RegionName"] = regionList.Where(x => x.Selected == true).FirstOrDefault().Text;
                }
            }

            SelectListItem selectedListItem = regionList.Where(x => x.Selected == true).FirstOrDefault();


            if (selectedListItem != null)
            {
                if (selectedListItem.Value == "-1")
                {
                    techOfficersList.First(y => y.Value == "-1").Selected = true;
                }
                else
                {
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(selectedListItem.Value))));
                }
            }

            ViewData["Role"] = user.RoleName;
            ViewData["TechOfficers"] = techOfficersList;
            ViewData["Regions"] = regionList;

            return GetFormatView("Reports/OutstandingSATest.aspx", Model);
        }

        #region OnSite Estimation Section (TO)

        [Description("On Site Estimation TO")]
        public ActionResult OnSiteEstimation(OnSiteEstimationModel Model)
        {
            UserDataModel user = new UserDataModel();
            user = GetLoggedUserDetail();

            #region TO drpdwn
            List<SelectListItem> users = new List<SelectListItem>();
            users.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1",
                Selected = true
            });

            if (user.RoleName.Equals(Resources.info_role_engineer))
                users.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(user.RegionId)));
            else
                users.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(-1)));
            #endregion

            int count = users.Count();
            ViewData["users"] = users;

            #region Adding Region Dropdown
            List<SelectListItem> regionList = new List<SelectListItem>();

            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            #endregion

            if (Model.Type == null)
                Model.Type = "TO";

            if (Model.Type.Equals("TO"))
                ViewData["ReportType"] = "TO";

            return GetFormatView("Reports/OnSiteEstimationTO.aspx", Model); //CHANGE
        }

        [Description("OnSite Estimation TO Ajax Handler")]
        public ActionResult OnSiteEstimationAjaxHandler(JQueryDataTableParamModel param, OnSiteEstimationModel searchModel)
        {
            int count = 0;
            List<string[]> stringRatioList = new List<string[]>();
            var objArr = OnSiteEstimationReportCommon(param, searchModel);

            if (objArr != null)
            {
                var dataX = objArr as object[];
                stringRatioList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            this.Session["RegionName"] = searchModel.RName;

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = stringRatioList
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("OnSite Estimation Print Preview")]
        public ActionResult OnSiteEstimationPrintPreview(JQueryDataTableParamModel param, OnSiteEstimationModel searchModel)
        {
            List<String[]> stringRatioList = new List<string[]>();
            List<OnSiteEstimationModel> data = new List<OnSiteEstimationModel>();

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Ratio of Onsite Estimation Print Preview," + User.Identity.Name);

                var objArr = OnSiteEstimationReportCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<OnSiteEstimationModel>;
                }

                if (!searchModel.UserId.Equals("-1"))
                {
                    searchModel.UserName = "Any";
                    if (data.Count != 0)
                        searchModel.UserName = data.First().EPFNo + " - " + data.First().UserName;
                }
            }
            catch (Exception)
            {
                throw;
            }

            return GetFormatView("Reports/PrintOnSiteEstimation.aspx", data);
        }

        [Description("On Site Estimation TO to Excel")]
        public FileContentResult OnSiteEstimationToExcel(OnSiteEstimationModel searchModel)
        {
            try
            {

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = OnSiteEstimationReportCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);
                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Ratio of Onsite Estimation TO To Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Ratio of Onsite Estimation - TO " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        #endregion

        #region OnSite Estimation Section (Region)

        [Description("On Site Estimation Region")]
        public ActionResult OnSiteEstimationRegion(OnSiteEstimationModel Model)
        {
            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1",
                Selected = true
            });

            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            if (Model.Type == "Region")
                ViewData["ReportType"] = "Region";

            return GetFormatView("Reports/OnSiteEstimationReport.aspx", Model);
        }

        //[Description("Select TO according to Region")]
        //public ActionResult SelectTO(OutstandingJobsModel Model)
        //{
        //    UserDataModel user = new UserDataModel();
        //    user = GetLoggedUserDetail();

        //    List<SelectListItem> regionList = new List<SelectListItem>();
        //    regionList.Add(new SelectListItem
        //    {
        //        Text = Resources.info_gen_all,
        //        Value = "-1"
        //    });
        //    if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
        //    {
        //        regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
        //    }
        //    else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
        //    {
        //        regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));
        //    }

        //    List<SelectListItem> techOfficersList = new List<SelectListItem>();
        //    if (Model.RegionName == "-1")
        //    {
        //        techOfficersList.Add(new SelectListItem
        //        {
        //            Text = Resources.info_gen_all,
        //            Value = "-1",
        //        });
        //    }
        //    else
        //    {
        //        techOfficersList.Add(new SelectListItem
        //        {
        //            Text = Resources.info_gen_all,
        //            Value = "All",
        //        });
        //    }
        //    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(Model.RegionName))));

        //    ViewData["TechOfficers"] = techOfficersList;
        //    ViewData["RegionName"] = regionList;
        //    ViewData["Role"] = user.RoleName;

        //    return Json(new
        //    {
        //        aaData = techOfficersList
        //    },
        //    JsonRequestBehavior.AllowGet);
        //}

        [Description("OnSite Estimation Region Ajax Handler")]
        public ActionResult OnSiteEstimationRegionAjaxHandler(JQueryDataTableParamModel param, OnSiteEstimationModel searchModel)
        {
            int count = 0;
            List<string[]> stringRatioList = new List<string[]>();
            var objArr = OnSiteEstimationReportCommon(param, searchModel, false, false);

            if (objArr != null)
            {
                var dataX = objArr as object[];
                stringRatioList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            ViewData["ReportType"] = "Region";
            searchModel.Type = "Region";

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = stringRatioList
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("OnSite Estimation Region Print Preview")]
        public ActionResult OnSiteEstimationRegionPrintPreview(JQueryDataTableParamModel param, OnSiteEstimationModel searchModel)
        {
            List<String[]> stringRatioList = new List<string[]>();
            List<OnSiteEstimationModel> data = new List<OnSiteEstimationModel>();

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation Region Print Preview," + User.Identity.Name);

                var objArr = OnSiteEstimationReportCommon(param, searchModel, true, false);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<OnSiteEstimationModel>;
                }

                if (!searchModel.RegionName.Equals("-1"))
                {
                    if (data.Count != 0)
                        searchModel.RegionCode = data.First().RegionName;
                    else
                        searchModel.RegionCode = "Any";
                }
            }
            catch (Exception)
            {
                throw;
            }
            return GetFormatView("Reports/PrintOnSiteEstimationRegion.aspx", data);
        }

        [Description("On Site Estimation Region to Excel")]
        public FileContentResult OnSiteEstimationRegionToExcel(OnSiteEstimationModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation Region To Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = OnSiteEstimationReportCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation Region To Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "OnSite Estimation Report - Region " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSite Estimation To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        #endregion

        #region OnSite Estimation Common Report

        private object[] OnSiteEstimationReportCommon(JQueryDataTableParamModel param, OnSiteEstimationModel searchModel, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSiteEstimationReportCommon," +
                    User.Identity.Name + ",[Params=(DateFrom: " + searchModel.DateFrom + ",Date To: " + searchModel.DateTo + ",Region Id: " + searchModel.RegionName + ",TO Code: " + searchModel.UserId + ")]");

                string avg = "0";
                decimal? totOfRatio = 0;
                int noOfRatios = 0;

                List<OnSiteEstimationModel> data = new List<OnSiteEstimationModel>();
                DateTime? dateFrom = searchModel.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = searchModel.DateTo;//set to 23:59 PM of the given date
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);

                int regionId = -1;
                if (searchModel.RegionName != "undefined")
                    regionId = (searchModel.RegionName == null) ? 0 : Convert.ToInt32(searchModel.RegionName);

                int userId = 0;
                int count;
                string role = GetLoggedUserDetail().RoleName;

                if (searchModel.UserId.Equals("All"))
                {
                    userId = -1;
                    searchModel.UserId = "-1";
                }
                else
                {
                    if (searchModel.UserId != "undefined")
                        userId = (searchModel.UserId == null) ? -1 : Convert.ToInt32(searchModel.UserId);
                    else
                        userId = -1;
                }


                List<String[]> stringRatioList = new List<string[]>();

                #region SearchModel data

                if (searchModel.DateFrom.HasValue) //&& searchModel.TimeFrom.HasValue
                    dateFrom = searchModel.DateFrom.Value; //+ (searchModel.TimeFrom.Value - DateTime.Today)

                if (searchModel.DateTo.HasValue) //&& searchModel.TimeTo.HasValue
                    dateTo = searchModel.DateTo.Value; //+ (searchModel.TimeTo.Value - DateTime.Today)

                if (!searchModel.DateFrom.HasValue)
                    //dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!searchModel.DateTo.HasValue)
                        dateTo = null;// Convert.ToDateTime(DateTime.Now.ToString("dd/MM/yyyy HH:mm"));

                #endregion

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<SAForms_GetOnsiteEstimation_Result> ratios = new List<SAForms_GetOnsiteEstimation_Result>();

                    #region  TO wise

                    if (role.Equals(Resources.info_role_technicalOfficer))
                    {
                        userId = Convert.ToInt32(GetLoggedUserDetail().Id);
                    }
                    else if (role.Equals(Resources.info_role_engineer))
                    {
                        regionId = Convert.ToInt32(GetLoggedUserDetail().RegionId);

                        var tmp = context.RegionEntities.Where(u => u.RegionId == regionId).FirstOrDefault();
                        searchModel.RName = (tmp == null) ? "" : tmp.RegionName;
                        searchModel.RegionName = (tmp == null) ? "" : tmp.RegionId.ToString();

                        this.Session["RegionName"] = searchModel.RName;
                    }

                    ObjectParameter output = new ObjectParameter("RowCount", typeof(int));
                    var SAForms_GetOnsiteEstimationCount_result = context.SAForms_GetOnsiteEstimationCount(dateFrom, dateTo, regionId, userId, output).ToList();
                    int TotalCount = (int)output.Value;

                    logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSiteEstimationReportCommon," +
                    User.Identity.Name + ",SAForms_GetOnsiteEstimationCount_result count: " + SAForms_GetOnsiteEstimationCount_result.Count() + ",[Params=(DateFrom: " + searchModel.DateFrom + ",Date To: " + searchModel.DateTo + ",Region Id: " + searchModel.RegionName + ",TO Code: " + searchModel.UserId + ")]");

                    foreach (var item in SAForms_GetOnsiteEstimationCount_result)
                    {
                        totOfRatio = totOfRatio + item.Ratio.GetValueOrDefault();
                        //noOfRatios = noOfRatios + 1;
                    }
                    noOfRatios = TotalCount;
                    avg = "0";
                    if (noOfRatios != 0)
                        avg = string.Format("{0:0.00}", Convert.ToDecimal(totOfRatio / noOfRatios));


                    if (isPrintPreview || isExcel)
                    {
                        ratios = context.SAForms_GetOnsiteEstimation(dateFrom, dateTo, regionId, userId, 0, TotalCount, output).ToList();
                    }
                    else
                    {
                        //var test = context.SAForms_GetOnsiteEstimation(dateFrom, dateTo, regionId, userId, param.iDisplayStart, param.iDisplayLength, output).ToList();
                        ratios = context.SAForms_GetOnsiteEstimation(dateFrom, dateTo, regionId, userId, param.iDisplayStart, param.iDisplayLength, output).ToList();
                    }

                    logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OnSiteEstimationReportCommon," +
                    User.Identity.Name + ",OnSite Estimation Ratios Count: " + ratios.Count() +
                    ",[Params=(DateFrom: " + searchModel.DateFrom + ",Date To: " + searchModel.DateTo + ",Region Id: " + searchModel.RegionName + ",TO Code: " + searchModel.UserId + ")]");

                    #endregion

                    //count = ratios.Count();
                    count = TotalCount;


                    #region IsPrintPreview TO wise

                    if (isPrintPreview)
                    {
                        ratios = ratios.OrderByDescending(r => r.Ratio).ToList<SAForms_GetOnsiteEstimation_Result>();

                        foreach (SAForms_GetOnsiteEstimation_Result estRatio in ratios)
                        {
                            data.Add(new OnSiteEstimationModel
                            {
                                UserId = estRatio.TOCode,
                                UserName = estRatio.FullName,
                                CSRCode = estRatio.TOCode,
                                EPFNo = estRatio.EPFNo,
                                EstimatedJobs = estRatio.EstimatedJobs,
                                Ratio = estRatio.Ratio.GetValueOrDefault(),
                                TotalJobs = estRatio.TotalJobs
                            });

                            totOfRatio = totOfRatio + estRatio.Ratio.GetValueOrDefault();
                            noOfRatios = noOfRatios + 1;
                        }

                        avg = "0";
                        if (noOfRatios != 0)
                            avg = string.Format("{0:0.00}", Convert.ToDecimal(totOfRatio / noOfRatios));

                        this.Session["totAverage"] = avg;

                        if (regionId != -1 && regionId != 0)
                        {
                            if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals(Resources.info_role_management) || role.Equals(Resources.info_role_audit))
                                searchModel.RegionName = context.RegionEntities.Where(u => u.RegionId == regionId).FirstOrDefault().RegionName.ToString();

                        }

                        TempData["searchModel"] = searchModel;

                        ViewData["PrintUser"] = GetUser();//Used for the footer

                        return new object[] { data, count };
                    }

                    #endregion



                    #region IsExcel TO
                    if (isExcel)
                    {
                        totOfRatio = 0;
                        noOfRatios = 0;
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();


                        ratios = ratios.OrderByDescending(r => r.Ratio).ToList<SAForms_GetOnsiteEstimation_Result>();

                        foreach (SAForms_GetOnsiteEstimation_Result item in ratios)
                        {
                            filteredData.Add(new KeyValuePair<string, string>[] { 
                                    new KeyValuePair<string,string>("TO Code", item.TOCode),
                                    new KeyValuePair<string,string>("TO Name", item.FullName),
                                    new KeyValuePair<string,string>("EPF No", item.EPFNo),
                                    new KeyValuePair<string,string>("Total Jobs", item.TotalJobs.ToString()),
                                    new KeyValuePair<string,string>("Estimated Jobs", item.EstimatedJobs.ToString()),
                                    new KeyValuePair<string,string>("Onsite Estimation Ratio (%)", item.Ratio.GetValueOrDefault().ToString()),
                                });

                            totOfRatio = totOfRatio + item.Ratio.GetValueOrDefault();
                            noOfRatios = noOfRatios + 1;
                        }

                        avg = "0";
                        if (noOfRatios != 0)
                            avg = string.Format("{0:0.00}", Convert.ToDecimal(totOfRatio / noOfRatios));

                        filteredData.Add(new KeyValuePair<string, string>[] { 
                                    new KeyValuePair<string,string>("TO Code", ""),
                                    new KeyValuePair<string,string>("TO Name", ""),
                                    new KeyValuePair<string,string>("EPF No", ""),
                                    new KeyValuePair<string,string>("Total Jobs", ""),
                                    new KeyValuePair<string,string>("Estimated Jobs", "Average"),
                                    new KeyValuePair<string,string>("Onsite Estimation Ratio (%)", avg),
                                });

                        return new object[] { filteredData, count };
                    }
                    #endregion

                    #region Normal report TO wise

                    int countOfData = 0;
                    //totOfRatio = 0;
                    //noOfRatios = 0;


                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    ratios = ratios.OrderBy(arr => arr.TOCode).ToList();
                                else
                                    ratios = ratios.OrderByDescending(arr => arr.TOCode).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    ratios = ratios.OrderBy(arr => arr.FullName).ToList();
                                else
                                    ratios = ratios.OrderByDescending(arr => arr.FullName).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    ratios = ratios.OrderBy(arr => arr.EPFNo).ToList();
                                else
                                    ratios = ratios.OrderByDescending(arr => arr.EPFNo).ToList();
                                break;
                            }
                        case 3:
                            {
                                if (sortDirection == "asc")
                                    ratios = ratios.OrderBy(arr => arr.TotalJobs).ToList();
                                else
                                    ratios = ratios.OrderByDescending(arr => arr.TotalJobs).ToList();
                                break;
                            }
                        case 4:
                            {
                                if (sortDirection == "asc")
                                    ratios = ratios.OrderBy(arr => arr.EstimatedJobs).ToList();
                                else
                                    ratios = ratios.OrderByDescending(arr => arr.EstimatedJobs).ToList();
                                break;
                            }
                        case 5:
                            {
                                if (sortDirection == "asc")
                                    ratios = ratios.OrderBy(arr => arr.Ratio).ToList();
                                else
                                    ratios = ratios.OrderByDescending(arr => arr.Ratio).ToList();
                                break;
                            }
                    }
                    #endregion

                    var ratioList = ratios.AsQueryable();
                    //Issue in the average ratio when using 2 sp's
                    //foreach (var estRatio in ratioList)
                    //{
                    //    totOfRatio = totOfRatio + estRatio.Ratio.GetValueOrDefault();
                    //    noOfRatios = noOfRatios + 1;
                    //}

                    //countOfData = ratios.Count();
                    countOfData = TotalCount;
                    //ratioList = ratioList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (SAForms_GetOnsiteEstimation_Result estRatio in ratioList)
                    {
                        String[] userRatios = new String[6];
                        userRatios[0] = estRatio.TOCode.ToString();
                        userRatios[1] = estRatio.FullName.ToString();
                        userRatios[2] = estRatio.EPFNo.ToString();
                        userRatios[3] = estRatio.TotalJobs.ToString();
                        userRatios[4] = estRatio.EstimatedJobs.ToString();
                        userRatios[5] = estRatio.Ratio.GetValueOrDefault().ToString();

                        stringRatioList.Add(userRatios);
                    }


                    ViewData["Average"] = "0";
                    if (noOfRatios != 0)
                        ViewData["Average"] = string.Format("{0:0.00}", Convert.ToDecimal(avg));

                    this.Session["Average"] = ViewData["Average"];
                    return new object[] { stringRatioList, countOfData };

                    #endregion
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Performance Report Section (TO)

        [Description("TO Performance")]
        public ActionResult TOPerformance(TOPerformanceModel Model)
        {
            try
            {
                List<SelectListItem> techOfficersList = new List<SelectListItem>();
                UserDataModel user = new UserDataModel();
                user = GetLoggedUserDetail();

                if (user.RoleName.Equals(Resources.info_role_engineer))
                {
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(GetTechnicalOfficersDataList()));
                    ViewData["Role"] = user.RoleName;
                }
                else if (user.RoleName.Equals(Resources.info_role_technicalOfficer))
                {
                    ViewData["TOCode"] = user.CSRCode;
                    ViewData["Role"] = user.RoleName;
                }
                ViewData["TechOfficers"] = techOfficersList;
            }
            catch (Exception)
            {
            }
            return GetFormatView("Reports/TOPerformance.aspx", Model);
        }

        [Description("TO Performance Ajax Handler")]
        public ActionResult TOPerformanceAjaxHandler(JQueryDataTableParamModel param, TOPerformanceModel searchModel)
        {
            try
            {
                int count = 0;
                List<string[]> perfList = null;

                var objArr = TOPerformanceCommon(param, searchModel);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    perfList = dataX[0] as List<string[]>;
                    count = Convert.ToInt32(dataX[1]);
                }

                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = count,
                    iTotalDisplayRecords = count,
                    aaData = perfList
                },
                JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {
                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = 0,
                    iTotalDisplayRecords = 0,
                    aaData = ""
                },
                JsonRequestBehavior.AllowGet);
            }
        }

        [Description("TO performance print preview")]
        public ActionResult TOPerformancePrintPreview(JQueryDataTableParamModel param, TOPerformanceModel searchModel)
        {
            List<String[]> stringJobsList = new List<string[]>();
            List<TOPerformanceModel> data = new List<TOPerformanceModel>();
            try
            {
                int count = 0;
                var objArr = TOPerformanceCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<TOPerformanceModel>;
                    count = Convert.ToInt32(dataX[1]);
                }

                TempData["searchModel"] = searchModel;
                ViewData["PrintUser"] = GetUser();
            }
            catch (Exception)
            {
            }
            return GetFormatView("Reports/PrintTOPerformance.aspx", data);
        }

        [Description("TO Performance to Excel")]
        public FileContentResult TOPerformanceToExcel(TOPerformanceModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",TO Performance To Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = TOPerformanceCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }
                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",TO Performance To Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Performance Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",TO Performance To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",TO Performance To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;

        }

        public object[] TOPerformanceCommon(JQueryDataTableParamModel param, TOPerformanceModel searchModel, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                DateTime startTime = Convert.ToDateTime(ConfigurationManager.AppSettings["startTime"]);
                DateTime endTime = Convert.ToDateTime(ConfigurationManager.AppSettings["endTime"]);
                TimeSpan timeDiff = endTime - startTime;

                int positiveScore = Int32.Parse(ConfigurationManager.AppSettings["positiveScore"]);
                //int negativeScore = Int32.Parse(ConfigurationManager.AppSettings["negativeScore"]);

                DateTime hoursToComplete = Convert.ToDateTime(ConfigurationManager.AppSettings["hoursToComplete"]);
                TimeSpan hrsToComplete = new TimeSpan(hoursToComplete.Hour, hoursToComplete.Minute, 0);

                UserDataModel user = new UserDataModel();
                user = GetLoggedUserDetail();

                int id = 0;
                if (user.RoleName.Equals(Resources.info_role_engineer))
                    id = Int32.Parse(searchModel.Name);

                else if (user.RoleName.Equals(Resources.info_role_technicalOfficer))
                    id = user.Id;

                DateTime? dateFrom = searchModel.DateFrom;
                DateTime? dateTo = searchModel.DateTo;
                int count;

                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);

                if (!searchModel.DateFrom.HasValue)
                    //dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!searchModel.DateTo.HasValue)
                        dateTo = DateTime.Now;

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //var jobs = (from u in context.vw_TO_Performance
                    //            where u.TOCode == id && (u.AssignedDate >= dateFrom && u.AssignedDate <= dateTo) &&
                    //                (u.CompletedDate >= dateFrom && u.CompletedDate <= dateTo)
                    //            select u).ToList<vw_TO_Performance>();
                    var jobs = context.GetPerformanceHours(dateFrom, dateTo, id, -1).ToList();
                    count = jobs.Count();

                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (isPrintPreview || isExcel)
                    {
                        sortColumnIndex = 4;  //Job Completion Total Time (Client requested)
                        sortDirection = "asc";
                    }

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    jobs = jobs.OrderBy(arr => arr.JobNo).ToList();
                                else
                                    jobs = jobs.OrderByDescending(arr => arr.JobNo).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    jobs = jobs.OrderBy(arr => arr.VehicleNo).ToList();
                                else
                                    jobs = jobs.OrderByDescending(arr => arr.VehicleNo).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    jobs = jobs.OrderBy(arr => arr.AssignedDate).ToList();
                                else
                                    jobs = jobs.OrderByDescending(arr => arr.AssignedDate).ToList();
                                break;
                            }
                        case 3:
                            {
                                if (sortDirection == "asc")
                                    jobs = jobs.OrderBy(arr => arr.CompletedDate).ToList();
                                else
                                    jobs = jobs.OrderByDescending(arr => arr.CompletedDate).ToList();
                                break;
                            }
                    }

                    #endregion

                    int totalNegative = 0;
                    int totalPositive = 0;
                    List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                    List<TOPerformanceModel> jobLst = new List<TOPerformanceModel>();

                    foreach (var job in jobs)
                    {
                        #region 20161024 New implementation
                        DateTime startDateTime = job.AssignedDate.GetValueOrDefault();
                        DateTime endDateTime = job.CompletedDate.GetValueOrDefault();

                        double startTimePeriod = 0;
                        double endTimePeriod = 0;
                        TimeSpan startTimeSpan = new TimeSpan(9, 0, 0); //8AM Convert.ToDateTime(ConfigurationManager.AppSettings["startTime"]);
                        TimeSpan endTimeSpan = new TimeSpan(17, 0, 0); //5PM
                        double regWorkingPeriod = (endTimeSpan - startTimeSpan).TotalMinutes;

                        if (startDateTime < startDateTime.Date.Add(startTimeSpan))
                        {
                            startDateTime = startDateTime.Date.Add(startTimeSpan);
                        }
                        if (endDateTime > endDateTime.Date.Add(endTimeSpan))
                        {
                            endDateTime = endDateTime.Date.Add(endTimeSpan);
                        }

                        if (startDateTime >= startDateTime.Date.Add(startTimeSpan) && startDateTime <= startDateTime.Date.Add(endTimeSpan))
                        {
                            startTimePeriod = (startDateTime.Date.Add(endTimeSpan) - startDateTime).TotalMinutes;
                        }

                        if (endDateTime >= endDateTime.Date.Add(startTimeSpan) && endDateTime <= endDateTime.Date.Add(endTimeSpan))
                        {
                            endTimePeriod = (endDateTime - endDateTime.Date.Add(startTimeSpan)).TotalMinutes;
                        }

                        if (startDateTime.Date == endDateTime.Date)
                        {
                            startTimePeriod = (endDateTime - startDateTime).TotalMinutes;
                            //60 Min removed coz TimeSpan(17, 0, 0) - TimeSpan(8, 0, 0) == should be 8 hours but C# returns as 9 hours
                            //double regWorkingPeriod = (endTimeSpan - startTimeSpan).TotalMinutes - 60;
                            if (startTimePeriod > regWorkingPeriod)
                                startTimePeriod = regWorkingPeriod;
                            endTimePeriod = 0;
                        }

                        bool takeFirstDay = false;
                        bool takeEndDay = false;
                        string saturday = "saturday";
                        string sunday = "sunday";
                        string dateFormatter = "yyyy/MM/dd";

                        DateTime intermideateDate = startDateTime;
                        string startDateTimeName = startDateTime.DayOfWeek.ToString().ToLower();
                        string endDateTimeName = endDateTime.DayOfWeek.ToString().ToLower();

                        //Get all holidays from DB and format it then make a string with comma separated
                        string holidays = "";
                        var dates = (from u in context.Holidays where u.Date >= startDateTime.Date && u.Date <= endDateTime.Date select u).ToList();
                        foreach (var date in dates)
                        {
                            holidays = holidays + "," + date.Date.ToString("yyyy/MM/dd");
                        }

                        string startDateTime_ = startDateTime.Date.ToString(dateFormatter);
                        string endDateTime_ = endDateTime.Date.ToString(dateFormatter);
                        double totalMinutesSpent = 0;

                        while (intermideateDate <= endDateTime)
                        {
                            if (!startDateTimeName.Equals(saturday) && !startDateTimeName.Equals(sunday) && !holidays.Contains(startDateTime_))
                                takeFirstDay = true;
                            if (!endDateTimeName.Equals(saturday) && !endDateTimeName.Equals(sunday) && !holidays.Contains(endDateTime_))
                                takeEndDay = true;

                            if (intermideateDate.Date == startDateTime.Date || intermideateDate.Date == endDateTime.Date)
                            {
                                intermideateDate = intermideateDate.AddDays(1);
                                continue;
                            }

                            var dayName = intermideateDate.DayOfWeek.ToString().ToLower();
                            if (!dayName.Equals(saturday) && !dayName.Equals(sunday) && !holidays.Contains(intermideateDate.Date.ToString(dateFormatter)))
                            {
                                totalMinutesSpent += regWorkingPeriod;
                            }

                            intermideateDate = intermideateDate.AddDays(1);
                            continue;
                        }

                        if (takeFirstDay) totalMinutesSpent += startTimePeriod;
                        if (takeEndDay) totalMinutesSpent += endTimePeriod;

                        int hours = Convert.ToInt32(Math.Truncate(totalMinutesSpent / 60));

                        #endregion

                        if (hours <= hrsToComplete.TotalHours)
                            totalPositive = totalPositive + positiveScore;
                        else
                            totalNegative = totalNegative + positiveScore;  //negativeScore no need of this variable                        

                        jobLst.Add(new TOPerformanceModel
                        {
                            VehicleNo = job.VehicleNo,
                            JobNo = job.JobNo,
                            AssignedDateDisplay = job.AssignedDate.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat),
                            CompletedDateDisplay = job.CompletedDate.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat),
                            Hours = hours
                        });
                    }

                    float avg = 0;
                    int tot = ((totalPositive + totalNegative) == 0) ? 1 : (totalPositive + totalNegative);
                    avg = (float)(((float)totalPositive * 100) / (float)tot);

                    var totScore = String.Format("{0:0.0#}", avg);
                    Session["totalScore"] = totScore;

                    if (isPrintPreview || isExcel)
                    {
                        sortColumnIndex = 4;  //Jon Assigned On (Client requested)
                        sortDirection = "asc";
                    }
                    if (sortColumnIndex == 4)
                    {
                        if (sortDirection == "asc")
                            jobLst = jobLst.OrderBy(y => y.Hours).ToList();
                        else
                            jobLst = jobLst.OrderByDescending(y => y.Hours).ToList();
                    }

                    List<TOPerformanceModel> jobListX = new List<TOPerformanceModel>();
                    if (!isPrintPreview && !isExcel)
                        jobListX = jobLst.Skip(param.iDisplayStart).Take(param.iDisplayLength).ToList();
                    else
                        jobListX = jobLst;

                    if (isPrintPreview)
                    {
                        TempData["totalCount"] = totScore;
                        return new object[] { jobListX, count };
                    }

                    if (isExcel)
                    {
                        foreach (var item in jobListX)
                        {
                            filteredData.Add(new KeyValuePair<string, string>[] {                            
                            new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),
                            new KeyValuePair<string,string>("Job No", item.JobNo),
                            new KeyValuePair<string,string>("Job Assigned On", item.AssignedDateDisplay.ToString()), //.ToString(ApplicationSettings.GetDateTimeFormat))
                            new KeyValuePair<string,string>("Job Completed On", item.CompletedDateDisplay.ToString()),
                            new KeyValuePair<string,string>("Job Completion Total Time", item.Hours.ToString()),                            
                            });
                        }

                        filteredData.Insert(filteredData.Count, new KeyValuePair<string, string>[] {
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", "Average"),
                            new KeyValuePair<string,string>("", totScore.Replace("&nbsp;", " "))
                        });

                        return new object[] { filteredData, count };
                    }

                    List<String[]> stringJobsList = new List<string[]>();
                    foreach (var item in jobListX)
                    {
                        String[] job = new String[5];
                        job[0] = item.VehicleNo;
                        job[1] = item.JobNo;
                        job[2] = item.AssignedDateDisplay;
                        job[3] = item.CompletedDateDisplay;
                        job[4] = item.Hours.ToString();
                        stringJobsList.Add(job);
                    }
                    return new object[] { stringJobsList, count };
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Performance Report Section (Region)

        [Description("RegionalLevelPerformance")]
        public ActionResult RegionalLevelPerformance(PerformanceModel Model)
        {
            try
            {
                UserDataModel user = new UserDataModel();
                List<SelectListItem> techOfficersList = new List<SelectListItem>();
                List<SelectListItem> regionList = new List<SelectListItem>();

                user = GetLoggedUserDetail();

                //Regions including All
                regionList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1"
                });
                if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
                    regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));

                else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
                    regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));

                //If selected manually
                if (Model.RegionName != null)
                {
                    if (Model.RegionName != "-1")
                    {
                        //not null and not all
                        regionList.First(x => x.Value == Model.RegionName).Selected = true;
                    }
                }

                if (user.RoleName != Resources.info_role_engineer)
                {
                    if (Model.RegionName == null)
                        regionList.First(x => x.Value == "-1").Selected = true;
                }
                else
                {
                    string regionId = user.RegionId.ToString();
                    regionList.First(x => x.Value == regionId).Selected = true;
                    ViewData["RegionName"] = regionList.Where(x => x.Selected == true).FirstOrDefault().Text;
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = "-1",
                    });
                }

                //TOs including All
                if (Model.RegionName == "-1" || Model.RegionName == null)
                {
                    if (user.RoleName != Resources.info_role_engineer)
                    {
                        techOfficersList.Add(new SelectListItem
                        {
                            Text = Resources.info_gen_all,
                            Value = "-1",
                        });
                        techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(-1)));
                    }
                }
                SelectListItem selectedListItem = regionList.Where(x => x.Selected == true).FirstOrDefault();

                if (selectedListItem.Value == "-1")
                    techOfficersList.First(y => y.Value == "-1").Selected = true;
                else
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(selectedListItem.Value))));

                ViewData["Role"] = user.RoleName;
                ViewData["TechOfficers"] = techOfficersList;
                ViewData["Regions"] = regionList;

                return GetFormatView("Reports/RegionalLevelPerformance.aspx", Model);
            }
            catch (Exception)
            {
                throw;
            }
        }

        [Description("Regional Level Performance Ajax Handler")]
        public ActionResult RegionalLevelPerformanceAjaxHandler(JQueryDataTableParamModel param, PerformanceModel Model)
        {
            try
            {
                if (Model.RegionName == "null")
                {
                    return Json(new
                    {
                        sEcho = param.sEcho,
                        iTotalRecords = 0,
                        iTotalDisplayRecords = 0,
                        aaData = ""
                    },
                    JsonRequestBehavior.AllowGet);
                }

                int count = 0;
                List<string[]> perfList = null;

                var objArr = PerformanceReportCommon(param, Model);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    perfList = dataX[0] as List<string[]>;
                    count = Convert.ToInt32(dataX[1]);
                }

                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = count,
                    iTotalDisplayRecords = count,
                    aaData = perfList
                },
                JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {
                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = 0,
                    iTotalDisplayRecords = 0,
                    aaData = ""
                },
                JsonRequestBehavior.AllowGet);
            }
        }

        [Description("Regional Level Performance Print Preview")]
        public ActionResult RegionalLevelPerformancePrintPreview(JQueryDataTableParamModel param, PerformanceModel searchModel)
        {
            List<TOPerformanceModel> data = new List<TOPerformanceModel>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Performance Print Preview," + User.Identity.Name);

                string count = "";
                var objArr = PerformanceReportCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<TOPerformanceModel>;
                    count = dataX[1].ToString();
                }

                TempData["totalCount"] = count;
                TempData["searchModel"] = searchModel;
                ViewData["PrintUser"] = GetUser();
            }
            catch (Exception)
            {
                throw;
            }
            return GetFormatView("Reports/PrintPerformanceReportRegion.aspx", data);
        }

        [Description("Regional Level Performance to Excel")]
        public FileContentResult RegionalLevelPerformanceToExcel(PerformanceModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Performance to Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = PerformanceReportCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Performance to Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Performance Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Performance to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Outstanding Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        private object[] PerformanceReportCommon(JQueryDataTableParamModel param, PerformanceModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",PerformanceReportCommon," +
                   User.Identity.Name +
                   ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                double totscore = 0;
                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;//set to 23:59 PM of the given date
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);

                String RegionName = Model.RegionName;
                int RegionId = 0;
                List<String[]> perfList = new List<string[]>();
                List<DateTime> holidays = new List<DateTime>();

                if (Model.RegionName != "undefined")
                    RegionId = Convert.ToInt32(RegionName);

                if (Model.Name == "All")//all TOs in the region                
                    Model.Name = null;

                string logeedUserRole = GetLoggedUserDetail().RoleName;

                if (logeedUserRole.Equals("Engineer"))
                    RegionId = GetLoggedUserDetail().RegionId;

                else if (logeedUserRole.Equals(Resources.info_role_systemAdministrator) || logeedUserRole.Equals("Audit") || logeedUserRole.Equals("Management"))
                    RegionId = Convert.ToInt32(RegionName);

                if (!Model.DateFrom.HasValue)
                    //dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!Model.DateTo.HasValue)
                        dateTo = DateTime.Now;

                //no TO's in the region       
                if (string.IsNullOrWhiteSpace(Model.Name))
                    Model.Name = "-1";

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<GetTOPerformance_Result1> performance_Results;

                    int TOcode = Convert.ToInt32(Model.Name);

                    if (isPrintPreview)
                    {
                        var region = (from s in context.RegionEntities where s.RegionId == RegionId select s).FirstOrDefault();
                        if (region != null)
                        {
                            Model.RegionNameDisplay = " - " + region.RegionName;
                            if (Model.RegionName.Equals("undefined"))
                                Model.RegionName = Convert.ToInt32(region.RegionCode).ToString(); //Some values comes as 018, need to be displayed like 18
                        }

                        if (TOcode != -1)
                        {
                            string Code = TOcode.ToString();
                            var username = (from s in context.UserEntities where s.UserId == TOcode select s.FirstName + " " + s.LastName).FirstOrDefault();
                            Model.Name = username;
                            Model.TOCode = Code;
                        }
                    }

                    performance_Results = context.GetTOPerformance(dateFrom, dateTo, TOcode, RegionId).ToList();//distinct users with total no of jobs

                    //var distinct_perf_Rslts = performance_Results.GroupBy(x => x.TOCode).Select(y => y.First()); //Take distinct users
                    var distinct_perf_Rslts = performance_Results;

                    var jobsWithTimeTaken = context.GetPerformanceHours(dateFrom, dateTo, TOcode, RegionId).ToList();

                    logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",PerformanceReportCommon," +
                   User.Identity.Name + ",performance_Results count: " + performance_Results.Count() + ",jobsWithTimeTaken Count: " + jobsWithTimeTaken.Count() +
                   ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                    int count = (distinct_perf_Rslts != null) ? distinct_perf_Rslts.Count() : 0;
                    int positiveS = 0; //Add positive and negatives separately
                    int negativeS = 0;
                    int totalNoofAssignedjobs = 0;
                    decimal totRatio = 0;
                    int noOfRecords = 0;
                    var dtVar = Convert.ToDateTime(ConfigurationManager.AppSettings["hoursToComplete"]);
                    var potScore = int.Parse(ConfigurationManager.AppSettings["positiveScore"]);
                    var negScore = int.Parse(ConfigurationManager.AppSettings["negativeScore"]);

                    if (count > 0)
                    {
                        var holidaytable = from rw in context.Holidays select rw.Date;
                        if (holidaytable != null)
                            holidays = holidaytable.ToList();
                    }

                    List<TOPerformanceModel> model = new List<TOPerformanceModel>();

                    #region for loops
                    foreach (GetTOPerformance_Result1 performRslt in distinct_perf_Rslts)
                    {
                        TOPerformanceModel element = new TOPerformanceModel();
                        //element.AssignedDate = performRslt.;
                        //element.CompletedDate = performRslt.CompletedDate;
                        element.EPFNo = performRslt.UserEPFNo;
                        element.Name = performRslt.FullName;
                        element.TOCode = Convert.ToInt32(performRslt.Code);
                        //element.TotNoOfJobs = jobsWithTimeTaken.Count();

                        positiveS = 0; //Set 0 for each user
                        negativeS = 0;
                        totalNoofAssignedjobs = 0;
                        var list2 = jobsWithTimeTaken.Where(r => r.UserCode == performRslt.UserCode).ToList();//jobs of the specific TO

                        int countY = (list2 == null) ? 0 : list2.Count();

                        foreach (var item in list2)
                        {
                            DateTime startTime = item.AssignedDate.Value;
                            DateTime endTime = item.CompletedDate.Value;

                            TimeSpan hrsToComplete = new TimeSpan(dtVar.Hour, dtVar.Minute, 0);
                            int spent = CheckHoliday(startTime, endTime, holidays);

                            totalNoofAssignedjobs += 1;

                            if (spent <= hrsToComplete.TotalHours)
                                positiveS = positiveS + potScore;

                            else
                                negativeS = negativeS + negScore;
                        }

                        if (totalNoofAssignedjobs != 0)
                            element.Performance = Math.Round(Decimal.Divide((positiveS * 100), totalNoofAssignedjobs) * 100) / 100;
                        else
                            element.Performance = 0;

                        element.PositiveScore = positiveS.ToString();
                        element.negativeScore = (negativeS * -1).ToString();
                        element.TotNoOfJobs = totalNoofAssignedjobs;
                        totRatio = totRatio + element.Performance;
                        noOfRecords += 1;

                        model.Add(element);
                    }
                    #endregion

                    if (noOfRecords != 0)
                        totscore = (double)totRatio / noOfRecords;


                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (isPrintPreview || isExcel)
                    {
                        sortColumnIndex = 6;  //Completed Ratio (Client requested)
                        sortDirection = "desc";
                    }

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    model = model.OrderBy(arr => arr.TOCode).ToList();
                                else
                                    model = model.OrderByDescending(arr => arr.TOCode).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    model = model.OrderBy(arr => arr.Name).ToList();
                                else
                                    model = model.OrderByDescending(arr => arr.Name).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    model = model.OrderBy(arr => arr.EPFNo).ToList();
                                else
                                    model = model.OrderByDescending(arr => arr.EPFNo).ToList();
                                break;
                            }
                        case 3:
                            {
                                if (sortDirection == "asc")
                                    model = model.OrderBy(arr => arr.Performance).ToList();
                                else
                                    model = model.OrderByDescending(arr => arr.Performance).ToList();
                                break;
                            }
                    }


                    if (sortColumnIndex == 5)
                    {
                        if (sortDirection == "asc")
                            model = model.OrderBy(y => y.TotNoOfJobs).ToList();
                        else
                            model = model.OrderByDescending(y => y.TotNoOfJobs).ToList();
                    }
                    if (sortColumnIndex == 6)
                    {
                        if (sortDirection == "asc")
                            model = model.OrderBy(y => y.Performance).ToList();
                        else
                            model = model.OrderByDescending(y => y.Performance).ToList();
                    }
                    #endregion

                    if (!isPrintPreview && !isExcel)
                        model = model.Skip(param.iDisplayStart).Take(param.iDisplayLength).ToList();

                    #region PrintPreview
                    if (isPrintPreview)
                    {
                        //List<TOPerformanceModel> data = new List<TOPerformanceModel>();
                        //foreach (var item in model)
                        //{
                        //    data.Add(new TOPerformanceModel
                        //    {
                        //        TOCode = item.TOCode,
                        //        Name = item.Name,
                        //        EPFNo = item.EPFNo,
                        //        AssignedDate = item.AssignedDate,
                        //        CompletedDate = item.CompletedDate,
                        //        Performance = item.Performance,
                        //        PositiveScore = item.PositiveScore,
                        //        negativeScore = item.negativeScore,
                        //        TotNoOfJobs = item.TotNoOfJobs
                        //    });
                        //}

                        this.Session["totalScore"] = String.Format("{0:0.0#}", totscore);
                        return new object[] { model, String.Format("{0:0.0#}", totscore) };
                    }
                    #endregion

                    #region Excel
                    if (isExcel)
                    {
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                        foreach (var item in model)
                        {
                            filteredData.Add(new KeyValuePair<string, string>[] { 
                            new KeyValuePair<string,string>("TO Code", item.TOCode.ToString()),
                            new KeyValuePair<string,string>("TO Name", item.Name),
                            new KeyValuePair<string,string>("EPF No", item.EPFNo),
                            new KeyValuePair<string,string>("Completed within " + dtVar.Hour + " hours", item.PositiveScore.ToString()),
                            new KeyValuePair<string,string>("Not Completed within " + dtVar.Hour + " hours", item.negativeScore.ToString()),
                            new KeyValuePair<string,string>("Total Jobs", item.TotNoOfJobs.ToString()),
                            new KeyValuePair<string,string>("Completed Ratio (%)", item.Performance.ToString())
                        });
                        }

                        filteredData.Insert(filteredData.Count, new KeyValuePair<string, string>[] {
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", ""),
                            new KeyValuePair<string,string>("", Resources.info_gen_regionPerformance),
                            new KeyValuePair<string,string>("", String.Format("{0:0.0#}", totscore))
                        });

                        return new object[] { filteredData, count };
                    }
                    #endregion

                    foreach (TOPerformanceModel x in model)
                    {
                        String[] perfArr = new String[7];
                        perfArr[0] = x.TOCode.ToString();
                        perfArr[1] = x.Name;
                        perfArr[2] = x.EPFNo;
                        perfArr[3] = x.PositiveScore.ToString();
                        perfArr[4] = x.negativeScore.ToString();
                        perfArr[5] = x.TotNoOfJobs.ToString();
                        perfArr[6] = x.Performance.ToString();
                        perfList.Add(perfArr);
                    }

                    this.Session["totalScore"] = String.Format("{0:0.0#}", totscore);
                    return new object[] { perfList, count };
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Outstanding SA Reports Section (TO)

        [Description("Outstanding SA Reports")]
        public ActionResult OutstandingSAReports(TOPerformanceModel Model)
        {
            try
            {
                List<SelectListItem> techOfficersList = new List<SelectListItem>();
                UserDataModel user = new UserDataModel();
                user = GetLoggedUserDetail();

                if (user.RoleName.Equals("Engineer") || user.RoleName.Equals("System Administrator"))
                {
                    ViewData["Role"] = user.RoleName;
                }
                else if (user.RoleName.Equals("Technical Officer"))
                {
                    ViewData["TOCode"] = user.CSRCode;
                    ViewData["Role"] = user.RoleName;
                }
                ViewData["TechOfficers"] = techOfficersList;
            }
            catch (Exception)
            {
            }
            return GetFormatView("Reports/OutstandingSAReports.aspx", Model);
        }

        [Description("Outstanding SA Reports Ajax Handler")]
        public ActionResult OutstandingSAReportsAjaxHandler(JQueryDataTableParamModel param, OutstandingJobsModel searchModel)
        {
            int count = 0;
            List<string[]> perfList = null;

            var objArr = OutstandingSAReportsCommon(param, searchModel);
            if (objArr != null)
            {
                var dataX = objArr as object[];
                perfList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = perfList,
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("Outstanding SA Report -TO print preview")]
        public ActionResult OutstandingSAPrintPreview(JQueryDataTableParamModel param, OutstandingJobsModel searchModel)
        {
            List<OutstandingJobsModel> data = new List<OutstandingJobsModel>();
            try
            {
                var objArr = OutstandingSAReportsCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<OutstandingJobsModel>;
                }

                TempData["searchModel"] = searchModel;
                ViewData["PrintUser"] = GetUser();
            }
            catch (Exception)
            {
            }
            return GetFormatView("Reports/PrintOutstandingReportTO.aspx", data);
        }

        [Description("Outstanding SA Report to Excel")]
        public FileContentResult OutstandingSAToExcel(OutstandingJobsModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingSA TO To Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = OutstandingSAReportsCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingSA TO To Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Outstanding SA Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingSA TO To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingSA TO To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        [Description("Outstanding SA Common method for TO")]
        private object[] OutstandingSAReportsCommon(JQueryDataTableParamModel param, OutstandingJobsModel searchModel, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                UserDataModel user = GetLoggedUserDetail();
                string id = user.Id.ToString();

                DateTime? dateFrom = searchModel.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = searchModel.DateTo;//set to 23:59 PM of the given date

                int count = 0;
                List<String[]> reportList = new List<string[]>();

                if (searchModel.DateFrom.HasValue)
                    dateFrom = searchModel.DateFrom.Value;

                if (searchModel.DateTo.HasValue)
                    dateTo = searchModel.DateTo.Value;

                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);

                if (!searchModel.DateFrom.HasValue)
                    // dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!searchModel.DateTo.HasValue)
                        dateTo = DateTime.Now;

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<GetOutstandingJobs_Result> assignedJobList = new List<GetOutstandingJobs_Result>();


                    assignedJobList = context.GetOutstandingJobs(dateFrom, dateTo).ToList();//Get all outstanding jobs
                    var reports = assignedJobList.Where(r =>
                                            (id != null
                                                    ? Convert.ToInt32(r.UserId) == Convert.ToInt32(id)
                                                    : r.CSRCode != null)).ToList();//filter by the id of logged TO
                    if (!isPrintPreview)
                        count = reports.Count;

                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (isPrintPreview || isExcel)
                    {
                        sortColumnIndex = 2;  //Job Assigned On (Client requested)
                        sortDirection = "asc";
                    }

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.VehicleNumber).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.VehicleNumber).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.JobNumber).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.JobNumber).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.AssignedDateTime).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.AssignedDateTime).ToList();
                                break;
                            }
                    }

                    #endregion

                    var reportsList = reports.AsQueryable();
                    if (!isPrintPreview && !isExcel)
                        reportsList = reportsList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    List<OutstandingJobsModel> data = new List<OutstandingJobsModel>();
                    if (isPrintPreview)
                    {
                        foreach (var result in reportsList)
                        {
                            data.Add(new OutstandingJobsModel
                            {
                                JobNo = result.JobNumber,
                                VehicleNo = result.VehicleNumber,
                                AssignedDateDisplay = result.AssignedDateTime.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat)
                            });
                        }
                        return new object[] { data, count };
                    }

                    if (isExcel)
                    {
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                        foreach (var item in reportsList)
                        {
                            filteredData.Add(new KeyValuePair<string, string>[] 
                            {                            
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNumber),
                                new KeyValuePair<string,string>("Job No", item.JobNumber),                                
                                new KeyValuePair<string,string>("Job Assigned On", item.AssignedDateTime.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat))
                            });
                        }
                        return new object[] { filteredData, count };  //Second param (count) will not be used 
                    }

                    foreach (var report in reportsList)
                    {
                        String[] allreports = new String[3];
                        allreports[0] = report.VehicleNumber;
                        allreports[1] = report.JobNumber;
                        allreports[2] = report.AssignedDateTime.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat);
                        reportList.Add(allreports);
                    }
                }
                return new object[] { reportList, count };
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Outstanding SA Reports Section (Region)

        [Description("Regional Outstanding Jobs")]
        public ActionResult RegionalLevelOutstandingReports(OutstandingJobsModel Model)
        {
            if (Model.Name == "All")
            {
                Model.Name = null;
            }
            UserDataModel user = new UserDataModel();
            List<SelectListItem> techOfficersList = new List<SelectListItem>();
            List<SelectListItem> regionList = new List<SelectListItem>();

            user = GetLoggedUserDetail();


            //Regions including All

            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1"
            });
            if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            }
            else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));
            }

            //If selected manually
            if (Model.RegionName != null)
            {
                if (Model.RegionName != "-1")
                {
                    //not null and not all
                    regionList.First(x => x.Value == Model.RegionName).Selected = true;
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = null,
                    });
                }
            }

            if (user.RoleName != Resources.info_role_engineer)
            {
                if (Model.RegionName == null)
                {
                    regionList.First(x => x.Value == "-1").Selected = true;
                }
            }
            else
            {
                string regionId = user.RegionId.ToString();
                regionList.First(x => x.Value == regionId).Selected = true;
                techOfficersList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                });
            }

            //TOs including All
            if (Model.RegionName == "-1" || Model.RegionName == null)
            {
                if (user.RoleName != Resources.info_role_engineer)
                {
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = "-1",
                    });
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(-1)));
                }
                else
                {
                    ViewData["RegionName"] = regionList.Where(x => x.Selected == true).FirstOrDefault().Text;
                }
            }

            SelectListItem selectedListItem = regionList.Where(x => x.Selected == true).FirstOrDefault();


            if (selectedListItem != null)
            {
                if (selectedListItem.Value == "-1")
                {
                    techOfficersList.First(y => y.Value == "-1").Selected = true;
                }
                else
                {
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(selectedListItem.Value))));
                }
            }

            ViewData["Role"] = user.RoleName;
            ViewData["TechOfficers"] = techOfficersList;
            ViewData["Regions"] = regionList;

            return GetFormatView("Reports/RegionalLevelOutstandingReports.aspx", Model);
        }

        [Description("Regional Outstanding Jobs Ajax Handler")]
        public ActionResult RegionalLevelOutstandingReportsAjaxHandler(JQueryDataTableParamModel param, OutstandingJobsModel Model)
        {
            if (Model.RegionName == "null") return null;

            int count = 0;
            List<string[]> perfList = null;

            var objArr = OutstandingReportCommonNew(param, Model);
            if (objArr != null)
            {
                var dataX = objArr as object[];
                perfList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = perfList
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("Regional Level Outstanding Report Print Preview")]
        public ActionResult RegionalLevelOutstandingReportPrintPreview(JQueryDataTableParamModel param, OutstandingJobsModel searchModel)
        {
            List<OutstandingJobsModel> data = new List<OutstandingJobsModel>();
            try
            {
                var objArr = OutstandingReportCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<OutstandingJobsModel>;
                }
            }
            catch (Exception)
            {
                throw;
            }
            return GetFormatView("Reports/PrintOutstandingReportsRegion.aspx", data);
        }

        [Description("Outstanding Report to Excel")]
        public FileContentResult RegionalLevelOutstandingReportToExcel(OutstandingJobsModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Outstanding Report to Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = OutstandingReportCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);
                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Outstanding Report to Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Outstanding SA Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Outstanding Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Outstanding Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        private object[] OutstandingReportCommon(JQueryDataTableParamModel param, OutstandingJobsModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingReportCommon," +
                   User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                int count = 0;

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;//set to 23:59 PM of the given date
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);
                String RegionName = Model.RegionName;

                var udm = GetLoggedUserDetail();
                int RegionId = udm.RegionId;
                string role = udm.RoleName;

                if (Model.Name == "All")//all TOs in the region                
                    Model.Name = null;

                List<String[]> perfList = new List<string[]>();

                if (!Model.DateFrom.HasValue)
                    //dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!Model.DateTo.HasValue)
                    {
                        dateTo = DateTime.Now;
                    }

                #region MyRegion
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<GetOutstandingJobs_Result> assignedJobList = new List<GetOutstandingJobs_Result>();
                    assignedJobList = context.GetOutstandingJobs(dateFrom, dateTo).ToList();//Get all outstanding jobs

                    logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingReportCommon," +
                   User.Identity.Name + ",GetOutstandingJobs Count: " + assignedJobList.Count() + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                    int regionIdInFilter = 0;
                    if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                    {
                        if (Model.RegionName != "undefined")
                            regionIdInFilter = Convert.ToInt32(Model.RegionName);
                    }

                    if (regionIdInFilter != -1)//filtered region
                    {
                        if (isPrintPreview)
                        {
                            var tmp = context.RegionEntities.Where(u => u.RegionId == regionIdInFilter).FirstOrDefault();
                            Model.RName = (tmp == null) ? "" : tmp.RegionName;
                            Model.RegionName = (tmp == null) ? "" : tmp.RegionId.ToString();//set region name in the print preview
                        }

                        if (!role.Equals(Resources.info_role_engineer))
                            assignedJobList = assignedJobList.Where(r => r.RegionId == regionIdInFilter).ToList();
                    }

                    if (role.Equals(Resources.info_role_engineer))
                    {
                        var tmp = context.RegionEntities.Where(u => u.RegionId == RegionId).FirstOrDefault();
                        Model.RName = (tmp == null) ? "" : tmp.RegionName;
                        Model.RegionName = tmp.RegionId.ToString();
                        assignedJobList = assignedJobList.Where(r => r.RegionId == tmp.RegionId).ToList();
                    }

                    string TOcode = "";
                    if (Model.Name != null)
                    {
                        if (Model.Name != "")
                            TOcode = Model.Name;
                    }

                    var reports = assignedJobList;

                    if (TOcode != "")
                    {
                        if (TOcode != "-1")
                        {
                            reports = assignedJobList.Where(r =>
                                            (TOcode != null
                                                    ? Convert.ToInt32(r.UserId) == Convert.ToInt32(TOcode)
                                                    : r.CSRCode != null)).ToList();


                            if (isPrintPreview)
                            {
                                Model.TOCode = TOcode;
                                var firstRow = reports.First();
                                Model.Name = firstRow.FullName;
                            }
                        }
                    }

                    count = (reports == null) ? 0 : reports.Count();

                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    var sortData = "CSR Code asc";

                    if (isPrintPreview || isExcel)
                    {
                        sortColumnIndex = 0;  //TO Code (Client requested)
                        sortDirection = "desc";
                    }

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.CSRCode).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.CSRCode).ToList();

                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.FullName).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.FullName).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.VehicleNumber).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.VehicleNumber).ToList();
                                break;
                            }
                        case 3:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.JobNumber).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.JobNumber).ToList();
                                break;
                            }
                        case 4:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.AssignedDateTime).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.AssignedDateTime).ToList();
                                break;
                            }
                    }

                    #endregion

                    List<OutstandingJobsModel> data = new List<OutstandingJobsModel>();
                    if (isPrintPreview)
                    {
                        #region isPrintPreview
                        foreach (var estRatio in reports)
                        {
                            data.Add(new OutstandingJobsModel
                            {
                                TOCode = estRatio.CSRCode,
                                Name = (estRatio.FullName == null) ? " " : estRatio.FullName.ToString(),
                                JobNo = estRatio.JobNumber,
                                VehicleNo = estRatio.VehicleNumber,
                                //AssignedDate = estRatio.AssignedDateTime,
                                AssignedDateDisplay = (estRatio.AssignedDateTime != null) ? estRatio.AssignedDateTime.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat) : ""
                            });
                        }
                        TempData["searchModel"] = Model;
                        ViewData["PrintUser"] = GetUser();
                        return new object[] { data, count };  //Second param (count) will not be used 
                        #endregion
                    }

                    if (isExcel)
                    {
                        #region isExcel
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                        var reportsList = reports.AsQueryable();
                        foreach (var item in reportsList)
                        {
                            filteredData.Add(new KeyValuePair<string, string>[]
                            {
                            new KeyValuePair<string,string>("TO Code", item.CSRCode),
                            new KeyValuePair<string,string>("TO Name", (item.FullName == null) ? " ": item.FullName.ToString()),
                            new KeyValuePair<string,string>("Vehicle No", item.VehicleNumber),
                            new KeyValuePair<string,string>("Job No", item.JobNumber),                            
                            new KeyValuePair<string,string>("Job Assigned On", item.AssignedDateTime.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat)),
                        });
                        }

                        return new object[] { filteredData, count };  //Second param (count) will not be used 
                        #endregion
                    }

                    #region Normal scenario
                    var reportsList1 = reports.AsQueryable();
                    if (reports.Count == 0)
                        perfList = new List<string[]>();

                    if (!isPrintPreview && !isExcel)
                        reportsList1 = reportsList1.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (var report in reportsList1.OrderBy(x => x.CSRCode))
                    {
                        String[] perfArr = new String[5];
                        perfArr[0] = report.CSRCode.ToString();
                        perfArr[1] = (report.FullName == null) ? " " : report.FullName.ToString();
                        perfArr[2] = report.VehicleNumber.ToString();
                        perfArr[3] = report.JobNumber.ToString();
                        perfArr[4] = report.AssignedDateTime.GetValueOrDefault().ToString(ApplicationSettings.GetDateTimeFormat);
                        perfList.Add(perfArr);
                    }
                    #endregion
                }
                #endregion

                return new object[] { perfList, count };
            }
            catch (Exception)
            {
                throw;
            }
        }

        private object[] OutstandingReportCommonNew(JQueryDataTableParamModel param, OutstandingJobsModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            List<String[]> perfList = new List<string[]>();
            int? count = 0;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",OutstandingReportCommon," +
                   User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                #region DateTO/From

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);//set to 23:59 PM of the given date
                if (!Model.DateTo.HasValue)
                    dateTo = DateTime.Now;
                //datefrom default date

                #endregion

                var udm = GetLoggedUserDetail();
                int RegionId = udm.RegionId;
                string role = udm.RoleName;

                #region RoleBasedProperty

                #region TO

                if (Model.Name == "All" || Model.Name == "-1" || Model.Name == "undefined" || Model.Name == null)
                    Model.TOCode = null;
                else
                    Model.TOCode = Model.Name;

                #endregion

                if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                {
                    if (Model.RegionName == "-1" || Model.RegionName == "All" || Model.RegionName == "undefined" || Model.RegionName == null)
                        Model.RegionId = null;
                    else
                        Model.RegionId = Convert.ToInt32(Model.RegionName);
                }

                if (role.Equals(Resources.info_role_engineer))
                    Model.RegionId = RegionId;


                //isPrintPreview
                //isExcel

                #endregion

                #region Sorting Section

                var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                var sortDirection = Request["sSortDir_0"]; // asc or desc
                var sortData = "CSR Code asc";

                switch (sortColumnIndex)
                {
                    case 0:
                        {
                            if (sortDirection == "asc")
                                sortData = "CSR Code asc";
                            else
                                sortData = "CSR Code desc";

                            break;
                        }
                    case 1:
                        {
                            if (sortDirection == "asc")
                                sortData = "Full Name asc";
                            else
                                sortData = "Full Name desc";
                            break;
                        }
                    case 2:
                        {
                            if (sortDirection == "asc")
                                sortData = "Vehicle No asc";
                            else
                                sortData = "Vehicle No desc";
                            break;
                        }
                    case 3:
                        {
                            if (sortDirection == "asc")
                                sortData = "Job No asc";
                            else
                                sortData = "Job No desc";
                            break;
                        }
                    case 4:
                        {
                            if (sortDirection == "asc")
                                sortData = "Assigned Date asc";
                            else
                                sortData = "Assigned Date desc";
                            break;
                        }
                }

                #endregion

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    count = context.GetOutstandingJobs_Count(dateFrom, dateTo, Model.TOCode, Model.RegionId).FirstOrDefault();//record count

                    if (isPrintPreview || isExcel)
                        param.iDisplayLength = count.GetValueOrDefault();

                    var assignedJobList = context.GetOutstandingJobs_Paginated(dateFrom, dateTo, Model.TOCode, Model.RegionId, sortData, param.iDisplayStart, param.iDisplayLength);

                    foreach (var report in assignedJobList)
                    {
                        String[] perfArr = new String[5];
                        perfArr[0] = report.CSRCode.ToString();
                        perfArr[1] = (report.FullName == null) ? " " : report.FullName.ToString();
                        perfArr[2] = report.VehicleNumber.ToString();
                        perfArr[3] = report.JobNumber.ToString();
                        perfArr[4] = report.AssignedDateTime.ToString(ApplicationSettings.GetDateTimeFormat);
                        perfList.Add(perfArr);
                    }

                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "OutstandingReportCommonNew," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return new object[] { perfList, count };
        }

        #endregion

        #region Photo Availability Reports Section (Region)

        [Description("Regional Photo Availability")]
        public ActionResult RegionalLevelPhotoAvailabilityReports(PhotoAvailabilityModel Model)
        {
            if (Model.Name == "All")
            {
                Model.Name = null;
            }
            UserDataModel user = new UserDataModel();
            List<SelectListItem> techOfficersList = new List<SelectListItem>();
            List<SelectListItem> regionList = new List<SelectListItem>();

            user = GetLoggedUserDetail();


            //Regions including All

            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1"
            });
            if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            }
            else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));
            }

            //If selected manually
            if (Model.RegionName != null)
            {
                if (Model.RegionName != "-1")
                {
                    //not null and not all
                    regionList.First(x => x.Value == Model.RegionName).Selected = true;
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = null,
                    });
                }
            }

            if (user.RoleName != Resources.info_role_engineer)
            {
                if (Model.RegionName == null)
                {
                    regionList.First(x => x.Value == "-1").Selected = true;
                }
            }
            else
            {
                string regionId = user.RegionId.ToString();
                regionList.First(x => x.Value == regionId).Selected = true;
                techOfficersList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                });
            }

            //TOs including All
            if (Model.RegionName == "-1" || Model.RegionName == null)
            {
                if (user.RoleName != Resources.info_role_engineer)
                {
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = "-1",
                    });
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(-1)));
                }
                else
                {
                    ViewData["RegionName"] = regionList.Where(x => x.Selected == true).FirstOrDefault().Text;
                }
            }

            SelectListItem selectedListItem = regionList.Where(x => x.Selected == true).FirstOrDefault();


            if (selectedListItem != null)
            {
                if (selectedListItem.Value == "-1")
                {
                    techOfficersList.First(y => y.Value == "-1").Selected = true;
                }
                else
                {
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(selectedListItem.Value))));
                }
            }

            List<SelectListItem> InspectionTypeList = new List<SelectListItem>();
            InspectionTypeList.AddRange(ConvertToSelectList(EnumUtils.GetEnumList(typeof(VisitType))));

            ViewData["InspectionType"] = InspectionTypeList;
            ViewData["Role"] = user.RoleName;
            ViewData["TechOfficers"] = techOfficersList;
            ViewData["Regions"] = regionList;

            return GetFormatView("Reports/RegionalLevelPhotoAvailabilityReports.aspx", Model);
        }

        [Description("Regional Photo Availability Ajax Handler")]
        public ActionResult RegionalLevelPhotoAvailabilityReportsAjaxHandler(JQueryDataTableParamModel param, PhotoAvailabilityModel Model)
        {
            if (Model.RegionName == "null") return null;

            int count = 0;
            List<string[]> perfList = null;

            var objArr = PhotoAvailabilityReportCommonNew(param, Model);
            if (objArr != null)
            {
                var dataX = objArr as object[];
                perfList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = perfList
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("Regional Level Photo Availability Reports Print Preview")]
        public ActionResult RegionalLevelPhotoAvailabilityReportsPrintPreview(JQueryDataTableParamModel param, PhotoAvailabilityModel searchModel)
        {
            List<PhotoAvailabilityReportModel> data = new List<PhotoAvailabilityReportModel>();
            try
            {
                var objArr = PhotoAvailabilityReportCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<PhotoAvailabilityReportModel>;
                }
            }
            catch (Exception)
            {
                throw;
            }
            return GetFormatView("Reports/PrintPhotoAvailabilityReportsRegion.aspx", data);
        }

        [Description("Photo Availability Report to Excel")]
        public FileContentResult RegionalLevelPhotoAvailabilityReportToExcel(PhotoAvailabilityModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Photo Availability Report to Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = PhotoAvailabilityReportCommonNew(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                string VisitType = EnumUtils.GetEnumList(typeof(VisitType)).Single(v => v.Key == searchModel.InspectionType).Value;

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Photo Availability to Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    // return File(fileContent, "text/csv", "Photo Availability Report ( " +VisitType + " )"+ DateTime.Now.ToString(rptDateFormat) + ".csv");
                    return File(fileContent, "text/csv", "Photo Availability Report ( " + VisitType + " )" + DateTime.Now.ToString(rptDateFormat) + ".csv");

                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Photo Availability Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Regional Level Photo Availability Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        private object[] PhotoAvailabilityReportCommon(JQueryDataTableParamModel param, PhotoAvailabilityModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",PhotoAvailabilityReportCommon," +
                   User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");

                int count = 0;

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;//set to 23:59 PM of the given date
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);
                String RegionName = Model.RegionName;

                var udm = GetLoggedUserDetail();
                int RegionId = udm.RegionId;
                string role = udm.RoleName;

                if (Model.Name == "All")//all TOs in the region                
                    Model.Name = null;

                List<String[]> perfList = new List<string[]>();

                if (!Model.DateFrom.HasValue)
                    //dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!Model.DateTo.HasValue)
                    {
                        dateTo = DateTime.Now;
                    }

                #region MyRegion
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (Model.InspectionType == 0)
                    {
                        #region Photo Availability SA
                        List<GetPhotoAvailability_SANew_Result> photoAvailabilityList = new List<GetPhotoAvailability_SANew_Result>();
                        photoAvailabilityList = context.GetPhotoAvailability_SANew(dateFrom, dateTo, Model.InspectionType).ToList();

                        logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",PhotoAvailabilityReportCommon," +
                       User.Identity.Name + ",GetPhotoAvailability_SA Count: " + photoAvailabilityList.Count() + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                        int regionIdInFilter = 0;
                        if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                        {
                            if (Model.RegionName != "undefined")
                                regionIdInFilter = Convert.ToInt32(Model.RegionName);
                        }

                        if (regionIdInFilter != -1)//filtered region
                        {
                            if (isPrintPreview)
                            {
                                var tmp = context.RegionEntities.Where(u => u.RegionId == regionIdInFilter).FirstOrDefault();
                                Model.RName = (tmp == null) ? "" : tmp.RegionName;
                                Model.RegionName = (tmp == null) ? "" : tmp.RegionId.ToString();//set region name in the print preview
                            }

                            if (!role.Equals(Resources.info_role_engineer))
                                photoAvailabilityList = photoAvailabilityList.Where(r => r.RegionId == regionIdInFilter).ToList();
                        }

                        if (role.Equals(Resources.info_role_engineer))
                        {
                            var tmp = context.RegionEntities.Where(u => u.RegionId == RegionId).FirstOrDefault();
                            Model.RName = (tmp == null) ? "" : tmp.RegionName;
                            Model.RegionName = tmp.RegionId.ToString();
                            photoAvailabilityList = photoAvailabilityList.Where(r => r.RegionId == tmp.RegionId).ToList();
                        }

                        string TOcode = "";
                        if (Model.Name != null)
                        {
                            if (Model.Name != "")
                                TOcode = Model.Name;
                        }

                        var reports = photoAvailabilityList;

                        if (TOcode != "")
                        {
                            if (TOcode != "-1")
                            {
                                reports = photoAvailabilityList.Where(r =>
                                                (TOcode != null
                                                        ? Convert.ToInt32(r.UserId) == Convert.ToInt32(TOcode)
                                                        : r.OfficerCode != null)).ToList();


                                if (isPrintPreview)
                                {
                                    Model.TOCode = TOcode;
                                    var firstRow = reports.First();
                                    Model.Name = firstRow.FullName;
                                }
                            }
                        }

                        count = (reports == null) ? 0 : reports.Count();

                        #region Sorting Section

                        var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                        var sortDirection = Request["sSortDir_0"]; // asc or desc
                        var sortData = "CSR Code asc";

                        if (isPrintPreview || isExcel)
                        {
                            sortColumnIndex = 0;  //TO Code (Client requested)
                            sortDirection = "desc";
                        }

                        switch (sortColumnIndex)
                        {
                            case 0:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.JobNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.JobNo).ToList();

                                    break;
                                }
                            case 1:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.VehicleNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.VehicleNo).ToList();
                                    break;
                                }
                            case 2:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.OfficerCode).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.OfficerCode).ToList();
                                    break;
                                }
                            case 3:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.EPFNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.EPFNo).ToList();
                                    break;
                                }
                            case 4:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.AssignedDateTime).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.AssignedDateTime).ToList();
                                    break;
                                }
                        }

                        #endregion

                        string VisitType = EnumUtils.GetEnumList(typeof(VisitType)).Single(v => v.Key == Model.InspectionType).Value;
                        Model.InspectionTypeName = VisitType;
                        List<PhotoAvailabilityReportModel> data = new List<PhotoAvailabilityReportModel>();
                        if (isPrintPreview)
                        {
                            #region isPrintPreview
                            foreach (var estRatio in reports)
                            {
                                data.Add(new PhotoAvailabilityReportModel
                                {
                                    TOCode = estRatio.OfficerCode,
                                    Name = (estRatio.FullName == null) ? " " : estRatio.FullName.ToString(),
                                    JobNo = estRatio.JobNo,
                                    VehicleNo = estRatio.VehicleNo,
                                    EPFNo = estRatio.EPFNo,
                                    C3 = estRatio.C3.GetValueOrDefault(),
                                    C4 = estRatio.C4.GetValueOrDefault(),
                                    C5 = estRatio.C5.GetValueOrDefault(),
                                    C6 = estRatio.C6.GetValueOrDefault(),
                                    TotalImageAvailable = estRatio.TotalAvailable.ToString() + '/' + estRatio.TotalImages.ToString(),
                                    AssignedDate = estRatio.AssignedDateTime,
                                    AssignedDateDisplay = (estRatio.AssignedDateTime != null) ? Convert.ToDateTime(estRatio.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat) : ""
                                });
                            }
                            TempData["searchModel"] = Model;
                            ViewData["PrintUser"] = GetUser();
                            return new object[] { data, count };  //Second param (count) will not be used 
                            #endregion
                        }

                        if (isExcel)
                        {
                            #region isExcel
                            List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                            var reportsList = reports.AsQueryable();
                            foreach (var item in reportsList)
                            {
                                filteredData.Add(new KeyValuePair<string, string>[]
                            {
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),    
                                new KeyValuePair<string,string>("TO Code", item.OfficerCode),
                                new KeyValuePair<string,string>("EPF No", item.EPFNo),
                                new KeyValuePair<string,string>("Assigned Date", Convert.ToDateTime(item.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),
                                new KeyValuePair<string,string>("Accident Images", item.C3.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Driver Statement", item.C4.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Claim Form Image", item.C6.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Total image Count", item.TotalAvailable+"|"+item.TotalImages.ToString())
                        });
                            }

                            return new object[] { filteredData, count };  //Second param (count) will not be used 
                            #endregion
                        }

                        #region Normal scenario
                        var reportsList1 = reports.AsQueryable();
                        if (reports.Count == 0)
                            perfList = new List<string[]>();

                        if (!isPrintPreview && !isExcel)
                            reportsList1 = reportsList1.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                        foreach (var report in reportsList1.OrderBy(x => x.OfficerCode))
                        {
                            String[] perfArr = new String[9];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = report.OfficerCode.ToString();
                            perfArr[3] = report.EPFNo.ToString();
                            perfArr[4] = Convert.ToDateTime(report.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[5] = report.C3.ToString();
                            perfArr[6] = report.C4.ToString();
                            perfArr[7] = report.C5.ToString();
                            perfArr[8] = report.C6.ToString();
                            perfArr[9] = report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString();
                            perfList.Add(perfArr);
                        }
                        #endregion
                        #endregion
                    }
                    else
                    {
                        #region Photo Availability ARI And Other Vists
                        List<GetPhotoAvailability_ARINew_Result> photoAvailabilityList = new List<GetPhotoAvailability_ARINew_Result>();
                        photoAvailabilityList = context.GetPhotoAvailability_ARINew(dateFrom, dateTo, Model.InspectionType).ToList();//Get all outstanding jobs

                        logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",PhotoAvailabilityReportCommon," +
                       User.Identity.Name + ",GetPhotoAvailability_ARINew Count: " + photoAvailabilityList.Count() + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                        int regionIdInFilter = 0;
                        if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                        {
                            if (Model.RegionName != "undefined")
                                regionIdInFilter = Convert.ToInt32(Model.RegionName);
                        }

                        if (regionIdInFilter != -1)//filtered region
                        {
                            if (isPrintPreview)
                            {
                                var tmp = context.RegionEntities.Where(u => u.RegionId == regionIdInFilter).FirstOrDefault();
                                Model.RName = (tmp == null) ? "" : tmp.RegionName;
                                Model.RegionName = (tmp == null) ? "" : tmp.RegionId.ToString();//set region name in the print preview
                            }

                            if (!role.Equals(Resources.info_role_engineer))
                                photoAvailabilityList = photoAvailabilityList.Where(r => r.RegionId == regionIdInFilter).ToList();
                        }

                        if (role.Equals(Resources.info_role_engineer))
                        {
                            var tmp = context.RegionEntities.Where(u => u.RegionId == RegionId).FirstOrDefault();
                            Model.RName = (tmp == null) ? "" : tmp.RegionName;
                            Model.RegionName = tmp.RegionId.ToString();
                            photoAvailabilityList = photoAvailabilityList.Where(r => r.RegionId == tmp.RegionId).ToList();
                        }

                        string TOcode = "";
                        if (Model.Name != null)
                        {
                            if (Model.Name != "")
                                TOcode = Model.Name;
                        }

                        var reports = photoAvailabilityList;

                        if (TOcode != "")
                        {
                            if (TOcode != "-1")
                            {
                                reports = photoAvailabilityList.Where(r =>
                                                (TOcode != null
                                                        ? Convert.ToInt32(r.UserId) == Convert.ToInt32(TOcode)
                                                        : r.OfficerCode != null)).ToList();


                                if (isPrintPreview)
                                {
                                    Model.TOCode = TOcode;
                                    var firstRow = reports.First();
                                    Model.Name = firstRow.FullName;
                                }
                            }
                        }

                        count = (reports == null) ? 0 : reports.Count();

                        #region Sorting Section

                        var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                        var sortDirection = Request["sSortDir_0"]; // asc or desc
                        var sortData = "CSR Code asc";

                        if (isPrintPreview || isExcel)
                        {
                            sortColumnIndex = 0;  //TO Code (Client requested)
                            sortDirection = "desc";
                        }

                        switch (sortColumnIndex)
                        {
                            case 0:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.JobNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.JobNo).ToList();

                                    break;
                                }
                            case 1:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.VehicleNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.VehicleNo).ToList();
                                    break;
                                }
                            case 2:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.OfficerCode).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.OfficerCode).ToList();
                                    break;
                                }
                            case 3:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.EPFNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.EPFNo).ToList();
                                    break;
                                }
                            case 4:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.VisitDateTime).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.VisitDateTime).ToList();
                                    break;
                                }
                        }

                        #endregion

                        string VisitType = EnumUtils.GetEnumList(typeof(VisitType)).Single(v => v.Key == Model.InspectionType).Value;
                        Model.InspectionTypeName = VisitType;
                        List<PhotoAvailabilityReportModel> data = new List<PhotoAvailabilityReportModel>();
                        if (isPrintPreview)
                        {
                            #region isPrintPreview
                            foreach (var estRatio in reports)
                            {
                                data.Add(new PhotoAvailabilityReportModel
                                {
                                    TOCode = estRatio.OfficerCode,
                                    Name = (estRatio.FullName == null) ? " " : estRatio.FullName.ToString(),
                                    JobNo = estRatio.JobNo,
                                    VehicleNo = estRatio.VehicleNo,
                                    EPFNo = estRatio.EPFNo,
                                    C5 = estRatio.C5.GetValueOrDefault(),
                                    C20 = estRatio.C20.GetValueOrDefault(),
                                    C21 = estRatio.C21.GetValueOrDefault(),
                                    TotalImageAvailable = estRatio.TotalAvailable.ToString() + '/' + estRatio.TotalImages.ToString(),
                                    VisitedDate = estRatio.VisitDateTime,
                                    VisitedDateDisplay = (estRatio.VisitDateTime != null) ? Convert.ToDateTime(estRatio.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat) : ""
                                });
                            }
                            TempData["searchModel"] = Model;
                            ViewData["PrintUser"] = GetUser();
                            return new object[] { data, count };  //Second param (count) will not be used 
                            #endregion
                        }

                        if (isExcel)
                        {
                            #region isExcel
                            List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                            var reportsList = reports.AsQueryable();
                            foreach (var item in reportsList)
                            {
                                filteredData.Add(new KeyValuePair<string, string>[]
                            {
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),    
                                new KeyValuePair<string,string>("TO Code", item.OfficerCode),
                                new KeyValuePair<string,string>("EPF No", item.EPFNo),
                                new KeyValuePair<string,string>("Visited Date", Convert.ToDateTime(item.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),                                
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Estimate/AnyotherComments", item.C21.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Inspection/Seen Visits/Any Other", item.C20.GetValueOrDefault().ToString()),   
                                new KeyValuePair<string,string>("Total image Count", item.TotalAvailable.ToString() +'|'+item.TotalImages.ToString())
                        });
                            }

                            return new object[] { filteredData, count };  //Second param (count) will not be used 
                            #endregion
                        }

                        #region Normal scenario
                        var reportsList1 = reports.AsQueryable();
                        if (reports.Count == 0)
                            perfList = new List<string[]>();

                        if (!isPrintPreview && !isExcel)
                            reportsList1 = reportsList1.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                        foreach (var report in reportsList1.OrderBy(x => x.OfficerCode))
                        {
                            String[] perfArr = new String[9];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = report.OfficerCode.ToString();
                            perfArr[3] = report.EPFNo.ToString();
                            perfArr[4] = Convert.ToDateTime(report.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[5] = report.C5.ToString();
                            perfArr[6] = report.C21.ToString();
                            perfArr[7] = report.C20.ToString();
                            perfArr[8] = (report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString());
                            perfList.Add(perfArr);
                        }
                        #endregion
                        #endregion
                    }

                }
                #endregion

                return new object[] { perfList, count };
            }
            catch (Exception)
            {
                throw;
            }
        }

        //This endpoint for Special requirement which is need to acces from outside
        public ActionResult photoAvailability(DateTime dateFrom, DateTime dateTo, int inspectionType)
        {
            try
            {
                JQueryDataTableParamModel param;
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<String[]> perfList = new List<string[]>();
                    int? count = 0;
                    if (inspectionType == 0)
                    {


                        List<GetPhotoAvailability_SANew_Result> images = new List<GetPhotoAvailability_SANew_Result>();

                        var assignedJobList = context.GetPhotoAvailability_Paginated_SANew(dateFrom, dateTo, null, null, inspectionType);
                        foreach (var report in assignedJobList)
                        {
                            GetPhotoAvailability_SANew_Result element = new GetPhotoAvailability_SANew_Result();
                            element.JobNo = report.JobNo.ToString();
                            element.VehicleNo = report.VehicleNo.ToString();
                            element.OfficerCode = report.OfficerCode.ToString();
                            element.EPFNo = report.EPFNo.ToString();
                            element.AssignedDateTime = report.AssignedDateTime;
                            element.C3 = report.C3;
                            element.C4 = report.C4;
                            element.C5 = report.C5;
                            element.C6 = report.C6;
                            element.TotalImages = report.TotalImages;
                            element.TotalAvailable = report.TotalAvailable;
                            images.Add(element);
                        }
                        count = perfList.Count;
                        images = images.OrderBy(arr => arr.JobNo).ToList();
                        var reportList = images.AsQueryable();
                        count = (reportList == null) ? 0 : reportList.Count();


                        // reportList = reportList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                        foreach (GetPhotoAvailability_SANew_Result report in reportList)
                        {
                            String[] perfArr = new String[10];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = report.OfficerCode.ToString();
                            perfArr[3] = report.EPFNo.ToString();
                            perfArr[4] = Convert.ToDateTime(report.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[5] = report.C3.ToString();
                            perfArr[6] = report.C4.ToString();
                            perfArr[7] = report.C5.ToString();
                            perfArr[8] = report.C6.ToString();
                            perfArr[9] = report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString();
                            perfList.Add(perfArr);
                        }






                    }
                    else
                    {



                        List<GetPhotoAvailability_ARINew_Result> images = new List<GetPhotoAvailability_ARINew_Result>();

                        var assignedJobList = context.GetPhotoAvailability_Paginated_ARINew(dateFrom, dateTo, null, null, inspectionType);

                        foreach (var report in assignedJobList)
                        {
                            GetPhotoAvailability_ARINew_Result element = new GetPhotoAvailability_ARINew_Result();
                            element.JobNo = report.JobNo.ToString();
                            element.VehicleNo = report.VehicleNo.ToString();
                            element.OfficerCode = report.OfficerCode.ToString();
                            element.EPFNo = report.EPFNo.ToString();
                            element.VisitDateTime = report.VisitedDateTime;
                            element.C5 = report.C5;   // Technical Officer Comments  
                            element.C21 = report.C21; //Estimate/AnyotherComments
                            element.C20 = report.C20; //Inspection Photos / Seen Visits / Any Other  
                            element.TotalImages = report.TotalImages;
                            element.TotalAvailable = report.TotalAvailable;
                            images.Add(element);
                        }
                        count = perfList.Count;
                        images = images.OrderBy(arr => arr.JobNo).ToList();
                        var reportList = images.AsQueryable();
                        count = (reportList == null) ? 0 : reportList.Count();

                        foreach (GetPhotoAvailability_ARINew_Result report in reportList)
                        {
                            String[] perfArr = new String[9];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = report.OfficerCode.ToString();
                            perfArr[3] = report.EPFNo.ToString();
                            perfArr[4] = Convert.ToDateTime(report.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[5] = report.C5.ToString();// Technical Officer Comments                   
                            perfArr[6] = report.C21.ToString();//Estimate/AnyotherComments
                            perfArr[7] = report.C20.ToString();//Inspection Photos / Seen Visits / Any Other
                            perfArr[8] = (report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString());
                            perfList.Add(perfArr);
                        }


                    }

                    var objArr = new object[] { perfList, count };
                    if (objArr != null)
                    {
                        var dataX = objArr as object[];
                        perfList = dataX[0] as List<string[]>;
                        count = Convert.ToInt32(dataX[1]);
                    }
                    return Json(new
                    {
                        message = "Data resived",
                        count = count,
                        data = perfList

                    },
                        JsonRequestBehavior.AllowGet);

                }


            }
            catch (Exception e)
            {

                return Json(new
                {
                    message = "Error",
                    data = e
                },
                     JsonRequestBehavior.AllowGet);
            }

        }


        private object[] PhotoAvailabilityReportCommonNew(JQueryDataTableParamModel param, PhotoAvailabilityModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            List<String[]> perfList = new List<string[]>();
            int? count = 0;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",PhotoAvailabilityReportCommon," +
                   User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ",Visit Type: " + Model.InspectionTypeName + ")]");

                #region DateTO/From

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);//set to 23:59 PM of the given date
                if (!Model.DateTo.HasValue)
                    dateTo = DateTime.Now;
                //datefrom default date

                #endregion

                var udm = GetLoggedUserDetail();
                int RegionId = udm.RegionId;
                string role = udm.RoleName;



                #region RoleBasedProperty

                #region TO

                if (Model.Name == "All" || Model.Name == "-1" || Model.Name == "undefined" || Model.Name == null)
                    Model.TOCode = null;
                else
                    Model.TOCode = Model.Name;

                #endregion

                if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                {
                    if (Model.RegionName == "-1" || Model.RegionName == "All" || Model.RegionName == "undefined" || Model.RegionName == null)
                        Model.RegionId = null;
                    else
                        Model.RegionId = Convert.ToInt32(Model.RegionName);
                }

                if (role.Equals(Resources.info_role_engineer))
                    Model.RegionId = RegionId;


                //isPrintPreview
                //isExcel

                #endregion

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (Model.InspectionType == 0)
                    {
                        #region Photo Availability SA

                        List<GetPhotoAvailability_SANew_Result> images = new List<GetPhotoAvailability_SANew_Result>();

                        var assignedJobList = context.GetPhotoAvailability_Paginated_SANew(dateFrom, dateTo, Model.RegionId, Model.TOCode, Model.InspectionType);

                        foreach (var report in assignedJobList)
                        {
                            GetPhotoAvailability_SANew_Result element = new GetPhotoAvailability_SANew_Result();
                            element.JobNo = report.JobNo.ToString();
                            element.VehicleNo = report.VehicleNo.ToString();
                            element.OfficerCode = report.OfficerCode.ToString();
                            element.EPFNo = report.EPFNo.ToString();
                            element.AssignedDateTime = report.AssignedDateTime;
                            element.C3 = report.C3;
                            element.C4 = report.C4;
                            element.C5 = report.C5;
                            element.C6 = report.C6;
                            element.TotalImages = report.TotalImages;
                            element.TotalAvailable = report.TotalAvailable;
                            images.Add(element);
                        }
                        count = perfList.Count;

                        #region Sorting Section

                        var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                        var sortDirection = Request["sSortDir_0"]; // asc or desc                        

                        if (isExcel)
                        {
                            sortColumnIndex = 2;  //TO Code
                            sortDirection = "asc";

                            if (role.Equals(Resources.info_role_technicalOfficer))
                                sortColumnIndex = 1;  //Job No
                        }

                        switch (sortColumnIndex)
                        {
                            case 0:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.JobNo).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.JobNo).ToList();
                                    break;
                                }
                            case 1:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.VehicleNo).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.VehicleNo).ToList();
                                    break;
                                }
                            case 2:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.OfficerCode).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.OfficerCode).ToList();
                                    break;
                                }
                            case 3:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.EPFNo).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.EPFNo).ToList();
                                    break;
                                }
                            case 4:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.AssignedDateTime).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.AssignedDateTime).ToList();
                                    break;
                                }
                        }

                        #endregion

                        var reportList = images.AsQueryable();

                        if (isExcel)
                        {
                            List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                            foreach (GetPhotoAvailability_SANew_Result item in images)
                            {

                                filteredData.Add(new KeyValuePair<string, string>[]
                            { 
                                
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),    
                                new KeyValuePair<string,string>("TO Code", item.OfficerCode),
                                new KeyValuePair<string,string>("EPF No", item.EPFNo),
                                new KeyValuePair<string,string>("Assigned Date", Convert.ToDateTime(item.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),
                                new KeyValuePair<string,string>("Accident Images", item.C3.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Driver Statement", item.C4.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Claim Form Image", item.C6.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Total image Count", item.TotalAvailable.ToString() +'|'+item.TotalImages.ToString())
                            });

                            }
                            return new object[] { filteredData, count };
                        }

                        if (!isExcel)
                            count = (reportList == null) ? 0 : reportList.Count();

                        if (!isExcel)
                            reportList = reportList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                        foreach (GetPhotoAvailability_SANew_Result report in reportList)
                        {
                            String[] perfArr = new String[10];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = report.OfficerCode.ToString();
                            perfArr[3] = report.EPFNo.ToString();
                            perfArr[4] = Convert.ToDateTime(report.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[5] = report.C3.ToString();
                            perfArr[6] = report.C4.ToString();
                            perfArr[7] = report.C5.ToString();
                            perfArr[8] = report.C6.ToString();
                            perfArr[9] = report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString();
                            perfList.Add(perfArr);
                        }
                        #endregion
                    }
                    else
                    {
                        #region Photo Availability ARI and Other Visits

                        List<GetPhotoAvailability_ARINew_Result> images = new List<GetPhotoAvailability_ARINew_Result>();

                        var assignedJobList = context.GetPhotoAvailability_Paginated_ARINew(dateFrom, dateTo, Model.RegionId, Model.TOCode, Model.InspectionType);

                        foreach (var report in assignedJobList)
                        {
                            GetPhotoAvailability_ARINew_Result element = new GetPhotoAvailability_ARINew_Result();
                            element.JobNo = report.JobNo.ToString();
                            element.VehicleNo = report.VehicleNo.ToString();
                            element.OfficerCode = report.OfficerCode.ToString();
                            element.EPFNo = report.EPFNo.ToString();
                            element.VisitDateTime = report.VisitedDateTime;
                            element.C5 = report.C5;   // Technical Officer Comments  
                            element.C21 = report.C21; //Estimate/AnyotherComments
                            element.C20 = report.C20; //Inspection Photos / Seen Visits / Any Other  
                            element.TotalImages = report.TotalImages;
                            element.TotalAvailable = report.TotalAvailable;
                            images.Add(element);
                        }
                        count = perfList.Count;

                        #region Sorting Section

                        var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                        var sortDirection = Request["sSortDir_0"]; // asc or desc                        

                        if (isExcel)
                        {
                            sortColumnIndex = 2;  //TO Code
                            sortDirection = "asc";

                            if (role.Equals(Resources.info_role_technicalOfficer))
                                sortColumnIndex = 1;  //Job No
                        }

                        switch (sortColumnIndex)
                        {
                            case 0:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.JobNo).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.JobNo).ToList();
                                    break;
                                }
                            case 1:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.VehicleNo).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.VehicleNo).ToList();
                                    break;
                                }
                            case 2:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.OfficerCode).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.OfficerCode).ToList();
                                    break;
                                }
                            case 3:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.EPFNo).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.EPFNo).ToList();
                                    break;
                                }
                            case 4:
                                {
                                    if (sortDirection == "asc")
                                        images = images.OrderBy(arr => arr.VisitDateTime).ToList();
                                    else
                                        images = images.OrderByDescending(arr => arr.VisitDateTime).ToList();
                                    break;
                                }
                        }

                        #endregion

                        var reportList = images.AsQueryable();

                        if (isExcel)
                        {
                            List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                            foreach (GetPhotoAvailability_ARINew_Result item in images)
                            {

                                filteredData.Add(new KeyValuePair<string, string>[]
                            { 
                                
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),    
                                new KeyValuePair<string,string>("TO Code", item.OfficerCode),
                                new KeyValuePair<string,string>("EPF No", item.EPFNo),
                                new KeyValuePair<string,string>("Visited Date", Convert.ToDateTime(item.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),                               
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Estimate/AnyotherComments", item.C21.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Inspection/Seen Visits/Any Other", item.C20.GetValueOrDefault().ToString()),                                
                                new KeyValuePair<string,string>("Total image Count", item.TotalAvailable.ToString() +'|'+item.TotalImages.ToString())
                            });

                            }
                            return new object[] { filteredData, count };
                        }

                        if (!isExcel)
                            count = (reportList == null) ? 0 : reportList.Count();

                        if (!isExcel)
                            reportList = reportList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                        foreach (GetPhotoAvailability_ARINew_Result report in reportList)
                        {
                            String[] perfArr = new String[9];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = report.OfficerCode.ToString();
                            perfArr[3] = report.EPFNo.ToString();
                            perfArr[4] = Convert.ToDateTime(report.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[5] = report.C5.ToString();// Technical Officer Comments                   
                            perfArr[6] = report.C21.ToString();//Estimate/AnyotherComments
                            perfArr[7] = report.C20.ToString();//Inspection Photos / Seen Visits / Any Other
                            perfArr[8] = (report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString());
                            perfList.Add(perfArr);
                        }
                        #endregion
                    }
                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "PhotoAvailabilityReportCommonNew," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return new object[] { perfList, count };
        }


        #endregion

        #region Photo Availability Reports Section (TO)

        [Description("Photo Availability Reports")]
        public ActionResult PhotoAvailabilityReports(TOPerformanceModel Model)
        {
            try
            {
                List<SelectListItem> techOfficersList = new List<SelectListItem>();
                UserDataModel user = new UserDataModel();
                user = GetLoggedUserDetail();

                if (user.RoleName.Equals("Engineer") || user.RoleName.Equals("System Administrator"))
                {
                    ViewData["Role"] = user.RoleName;
                }
                else if (user.RoleName.Equals("Technical Officer"))
                {
                    ViewData["TOCode"] = user.CSRCode;
                    ViewData["Role"] = user.RoleName;
                }
                ViewData["TechOfficers"] = techOfficersList;

                List<SelectListItem> InspectionTypeList = new List<SelectListItem>();
                InspectionTypeList.AddRange(ConvertToSelectList(EnumUtils.GetEnumList(typeof(VisitType))));

                ViewData["InspectionType"] = InspectionTypeList;
            }
            catch (Exception)
            {
            }
            return GetFormatView("Reports/TOLevelPhotoAvailabilityReports.aspx", Model);
        }

        [Description("Photo Availability Reports Ajax Handler")]
        public ActionResult PhotoAvailabilityReportsAjaxHandler(JQueryDataTableParamModel param, PhotoAvailabilityModel searchModel)
        {
            int count = 0;
            List<string[]> perfList = null;

            var objArr = PhotoAvailabilityReportsCommon(param, searchModel);
            if (objArr != null)
            {
                var dataX = objArr as object[];
                perfList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = perfList,
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("Photo Availability Reports -TO print preview")]
        public ActionResult PhotoAvailabilityReportPrintPreview(JQueryDataTableParamModel param, PhotoAvailabilityModel searchModel)
        {
            List<PhotoAvailabilityReportModel> data = new List<PhotoAvailabilityReportModel>();
            try
            {
                var objArr = PhotoAvailabilityReportsCommon(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<PhotoAvailabilityReportModel>;
                }

                TempData["searchModel"] = searchModel;
                ViewData["PrintUser"] = GetUser();
            }
            catch (Exception)
            {
            }
            return GetFormatView("Reports/PrintPhotoAvailabilityReportTO.aspx", data);
        }

        [Description("Photo Availability Report to Excel")]
        public FileContentResult PhotoAvailabilityReportToExcel(PhotoAvailabilityModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Photo Availability Report To Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = PhotoAvailabilityReportsCommon(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Photo Availability Report," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Photo Availability Report" + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Photo Availability Report To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Photo Availability Report To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        [Description("Photo Availability Common method for TO")]
        private object[] PhotoAvailabilityReportsCommon(JQueryDataTableParamModel param, PhotoAvailabilityModel searchModel, bool isPrintPreview = false, bool isExcel = false)
        {
            try
            {
                UserDataModel user = GetLoggedUserDetail();
                string id = user.Id.ToString();

                DateTime? dateFrom = searchModel.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = searchModel.DateTo;//set to 23:59 PM of the given date

                int count = 0;
                List<String[]> reportList = new List<string[]>();

                string VisitType = EnumUtils.GetEnumList(typeof(VisitType)).Single(v => v.Key == searchModel.InspectionType).Value;
                searchModel.InspectionTypeName = VisitType;

                if (searchModel.DateFrom.HasValue)
                    dateFrom = searchModel.DateFrom.Value;

                if (searchModel.DateTo.HasValue)
                    dateTo = searchModel.DateTo.Value;

                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);

                if (!searchModel.DateFrom.HasValue)
                    // dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!searchModel.DateTo.HasValue)
                        dateTo = DateTime.Now;

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (searchModel.InspectionType == 0)
                    {
                        #region Photo Availability SA


                        List<GetPhotoAvailability_SANew_Result> assignedJobList = new List<GetPhotoAvailability_SANew_Result>();


                        assignedJobList = context.GetPhotoAvailability_SANew(dateFrom, dateTo, searchModel.InspectionType).ToList();//Get all outstanding jobs
                        var reports = assignedJobList.Where(r =>
                                                (id != null
                                                        ? Convert.ToInt32(r.UserId) == Convert.ToInt32(id)
                                                        : r.OfficerCode != null)).ToList();//filter by the id of logged TO
                        if (!isPrintPreview)
                            count = reports.Count;

                        #region Sorting Section

                        var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                        var sortDirection = Request["sSortDir_0"]; // asc or desc
                        if (isPrintPreview || isExcel)
                        {
                            sortColumnIndex = 2;  //Job Assigned On (Client requested)
                            sortDirection = "asc";
                        }

                        switch (sortColumnIndex)
                        {
                            case 0:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.JobNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.JobNo).ToList();
                                    break;
                                }
                            case 1:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.VehicleNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.VehicleNo).ToList();
                                    break;
                                }
                            case 2:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.AssignedDateTime).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.AssignedDateTime).ToList();
                                    break;
                                }
                        }

                        #endregion

                        var reportsList = reports.AsQueryable();
                        if (!isPrintPreview && !isExcel)
                            reportsList = reportsList.Skip(param.iDisplayStart).Take(param.iDisplayLength);


                        List<PhotoAvailabilityReportModel> data = new List<PhotoAvailabilityReportModel>();
                        if (isPrintPreview)
                        {
                            foreach (var result in reportsList)
                            {
                                data.Add(new PhotoAvailabilityReportModel
                                {
                                    JobNo = result.JobNo,
                                    VehicleNo = result.VehicleNo,
                                    EPFNo = result.EPFNo,
                                    C3 = result.C3.GetValueOrDefault(),
                                    C4 = result.C4.GetValueOrDefault(),
                                    C5 = result.C5.GetValueOrDefault(),
                                    C6 = result.C6.GetValueOrDefault(),
                                    TotalImageAvailable = result.TotalAvailable.ToString() + '/' + result.TotalImages.ToString(),
                                    AssignedDate = result.AssignedDateTime,
                                    AssignedDateDisplay = (result.AssignedDateTime != null) ? Convert.ToDateTime(result.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat) : ""
                                });
                            }
                            return new object[] { data, count };
                        }

                        if (isExcel)
                        {
                            #region isExcel
                            List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                            foreach (var item in reportsList)
                            {
                                filteredData.Add(new KeyValuePair<string, string>[]
                            {
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),
                                new KeyValuePair<string,string>("Assigned Date", Convert.ToDateTime(item.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),
                                new KeyValuePair<string,string>("Accident Images", item.C3.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Driver Statement", item.C4.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Claim Form Image", item.C6.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Total image Count", item.TotalAvailable+"|"+item.TotalImages.ToString())
                        });
                            }

                            return new object[] { filteredData, count };  //Second param (count) will not be used 
                            #endregion
                        }

                        foreach (var report in reportsList)
                        {
                            String[] perfArr = new String[8];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = Convert.ToDateTime(report.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[3] = report.C3.ToString();
                            perfArr[4] = report.C4.ToString();
                            perfArr[5] = report.C5.ToString();
                            perfArr[6] = report.C6.ToString();
                            perfArr[7] = report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString();
                            reportList.Add(perfArr);
                        }


                        #endregion
                    }
                    else
                    {
                        #region Photo Availability Other Reports



                        List<GetPhotoAvailability_ARINew_Result> assignedJobList = new List<GetPhotoAvailability_ARINew_Result>();


                        assignedJobList = context.GetPhotoAvailability_ARINew(dateFrom, dateTo, searchModel.InspectionType).ToList();//Get all outstanding jobs
                        var reports = assignedJobList.Where(r =>
                                                (id != null
                                                        ? Convert.ToInt32(r.UserId) == Convert.ToInt32(id)
                                                        : r.OfficerCode != null)).ToList();//filter by the id of logged TO
                        if (!isPrintPreview)
                            count = reports.Count;

                        #region Sorting Section

                        var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                        var sortDirection = Request["sSortDir_0"]; // asc or desc
                        if (isPrintPreview || isExcel)
                        {
                            sortColumnIndex = 2;  //Job Assigned On (Client requested)
                            sortDirection = "asc";
                        }

                        switch (sortColumnIndex)
                        {
                            case 0:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.JobNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.JobNo).ToList();
                                    break;
                                }
                            case 1:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.VehicleNo).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.VehicleNo).ToList();
                                    break;
                                }
                            case 2:
                                {
                                    if (sortDirection == "asc")
                                        reports = reports.OrderBy(arr => arr.VisitDateTime).ToList();
                                    else
                                        reports = reports.OrderByDescending(arr => arr.VisitDateTime).ToList();
                                    break;
                                }
                        }

                        #endregion

                        var reportsList = reports.AsQueryable();
                        if (!isPrintPreview && !isExcel)
                            reportsList = reportsList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                        List<PhotoAvailabilityReportModel> data = new List<PhotoAvailabilityReportModel>();
                        if (isPrintPreview)
                        {
                            foreach (var result in reportsList)
                            {
                                data.Add(new PhotoAvailabilityReportModel
                                {
                                    JobNo = result.JobNo,
                                    VehicleNo = result.VehicleNo,
                                    EPFNo = result.EPFNo,
                                    C5 = result.C5.GetValueOrDefault(),
                                    C20 = result.C20.GetValueOrDefault(),
                                    C21 = result.C21.GetValueOrDefault(),
                                    TotalImageAvailable = result.TotalAvailable.ToString() + '/' + result.TotalImages.ToString(),
                                    VisitedDate = result.VisitDateTime,
                                    VisitedDateDisplay = (result.VisitDateTime != null) ? Convert.ToDateTime(result.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat) : ""
                                });
                            }
                            return new object[] { data, count };
                        }

                        if (isExcel)
                        {
                            #region isExcel
                            List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                            foreach (var item in reportsList)
                            {
                                filteredData.Add(new KeyValuePair<string, string>[]
                            {
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo), 
                                new KeyValuePair<string,string>("Visited Date", Convert.ToDateTime(item.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),                                
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Estimate/AnyotherComments", item.C21.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Inspection/Seen Visits/Any Other", item.C20.GetValueOrDefault().ToString()),   
                                new KeyValuePair<string,string>("Total image Count", item.TotalAvailable.ToString() +'|'+item.TotalImages.ToString())
                         });
                            }

                            return new object[] { filteredData, count };  //Second param (count) will not be used 
                            #endregion
                        }

                        foreach (var report in reportsList)
                        {
                            String[] perfArr = new String[7];
                            perfArr[0] = report.JobNo.ToString();
                            perfArr[1] = report.VehicleNo.ToString();
                            perfArr[2] = Convert.ToDateTime(report.VisitDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                            perfArr[3] = report.C5.ToString();
                            perfArr[4] = report.C21.ToString();
                            perfArr[5] = report.C20.ToString();
                            perfArr[6] = (report.TotalAvailable.ToString() + '/' + report.TotalImages.ToString());
                            reportList.Add(perfArr);
                        }

                        #endregion
                    }
                }
                return new object[] { reportList, count };
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        #region Missing Images Section

        public ActionResult MissingImages(MissingImagesModel mImages)
        {
            return GetFormatView("Reports/MissingImages.aspx", mImages);
        }

        public ActionResult MissingImagesAjaxHandler(JQueryDataTableParamModel param, MissingImagesModel searchModel)
        {
            try
            {
                int count = 0;
                List<string[]> perfList = null;

                var objArr = MissingImagesCommon(param, searchModel);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    perfList = dataX[0] as List<string[]>;
                    count = Convert.ToInt32(dataX[1]);
                }

                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = count,
                    iTotalDisplayRecords = count,
                    aaData = perfList
                },
                JsonRequestBehavior.AllowGet);
            }
            catch (Exception)
            {
                return Json(new
                {
                    sEcho = param.sEcho,
                    iTotalRecords = 0,
                    iTotalDisplayRecords = 0,
                    aaData = ""
                },
                JsonRequestBehavior.AllowGet);
            }
        }

        public FileContentResult MissingImagesToExcel(MissingImagesModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Missing Images To Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = MissingImagesCommon(null, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }
                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",MissingImages To Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    return File(fileContent, "text/csv", "Missing Images Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",MissingImages To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",MissingImages To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        private object[] MissingImagesCommon(JQueryDataTableParamModel param, MissingImagesModel searchModel, bool isExcel = false)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",MissingImagesCommon," +
                    User.Identity.Name + ",[Params=(DateFrom: " + searchModel.DateFrom + ",Date To: " + searchModel.DateTo + ")]");

                int Flag = 0;
                int? GeneralId = 0;
                var user = GetLoggedUserDetail();

                DateTime? dateFrom = searchModel.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = searchModel.DateTo;//set to 23:59 PM of the given date

                if (searchModel.DateFrom.HasValue)
                    dateFrom = searchModel.DateFrom.Value;

                if (searchModel.DateTo.HasValue)
                    dateTo = searchModel.DateTo.Value;

                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);

                if (!searchModel.DateFrom.HasValue)
                    //dateFrom = Convert.ToDateTime("2014-01-01 00:00:00.000");

                    if (!searchModel.DateTo.HasValue)
                        dateTo = null; // DateTime.Now;

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<SAForms_GetMissingImagesNew_Results> images = new List<SAForms_GetMissingImagesNew_Results>();
                    List<SAForms_GetJobsWithNoImages_Result> jobsWithNoImages;
                    string role = user.RoleName;

                    if (role.Equals(Resources.info_role_engineer))
                    {
                        Flag = -2;
                        GeneralId = GetLoggedUserDetail().RegionId;
                    }
                    else if (role.Equals(Resources.info_role_technicalOfficer))
                    {
                        Flag = -3;
                        GeneralId = Convert.ToInt32(GetLoggedUserDetail().CSRCode);
                    }
                    else
                    {
                        Flag = -1;
                        GeneralId = null;
                    }

                    if (searchModel.IsJobsWithoutImgs)
                    {
                        jobsWithNoImages = context.SAForms_GetJobsWithNoImages(dateFrom, dateTo, Flag, GeneralId).ToList<SAForms_GetJobsWithNoImages_Result>();

                        foreach (var item in jobsWithNoImages)
                        {
                            SAForms_GetMissingImagesNew_Results element = new SAForms_GetMissingImagesNew_Results();
                            element.JobNo = item.JobNo;
                            element.OfficerCode = item.OfficerCode;
                            element.VehicleNo = item.VehicleNo;
                            element.C1 = item.C1;
                            element.C2 = item.C3;
                            element.C3 = item.C4;
                            element.C5 = item.C5;
                            element.C6 = item.C6;

                            images.Add(element);
                        }

                        logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",MissingImagesCommon," +
                    User.Identity.Name + ",JobsWithNoImages Count: " + jobsWithNoImages.Count() + ",[Params=(DateFrom: " + searchModel.DateFrom + ",Date To: " + searchModel.DateTo + ")]");
                    }
                    else
                    {
                        images = context.SAForms_GetMissingImagesNew(dateFrom, dateTo, Flag, GeneralId).ToList<SAForms_GetMissingImagesNew_Results>();

                        logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",MissingImagesCommon," +
                    User.Identity.Name + ",JobsWithMissingImages Count: " + images.Count() + ",[Params=(DateFrom: " + searchModel.DateFrom + ",Date To: " + searchModel.DateTo + ")]");
                    }


                    #region sorting section
                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; //asc or desc
                    if (isExcel)
                    {
                        sortColumnIndex = 2;  //TO Code
                        sortDirection = "asc";

                        if (role.Equals(Resources.info_role_technicalOfficer))
                            sortColumnIndex = 1;  //Job No
                    }

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    images = images.OrderBy(arr => arr.VehicleNo).ToList();
                                else
                                    images = images.OrderByDescending(arr => arr.VehicleNo).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    images = images.OrderBy(arr => arr.JobNo).ToList();
                                else
                                    images = images.OrderByDescending(arr => arr.JobNo).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    images = images.OrderBy(arr => arr.OfficerCode).ToList();
                                else
                                    images = images.OrderByDescending(arr => arr.OfficerCode).ToList();
                                break;
                            }
                    }
                    #endregion

                    var imgList = images.AsQueryable();
                    int count = 0;

                    if (isExcel)
                    {
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                        foreach (SAForms_GetMissingImagesNew_Results item in images)
                        {

                            filteredData.Add(new KeyValuePair<string, string>[]
                            { 
                                new KeyValuePair<string,string>("Vehicle No", item.VehicleNo),
                                new KeyValuePair<string,string>("Job No", item.JobNo),                                    
                                new KeyValuePair<string,string>("TO Code", item.OfficerCode),
                                new KeyValuePair<string,string>("Driver Statement", item.C3.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Accident Images", item.C4.GetValueOrDefault().ToString()),
                                new KeyValuePair<string,string>("Officer Comments", item.C5.GetValueOrDefault().ToString()),
                            });

                        }
                        return new object[] { filteredData, count };
                    }

                    if (!isExcel)
                        count = (imgList == null) ? 0 : imgList.Count();

                    if (!isExcel)
                        imgList = imgList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    List<String[]> LostImgList = new List<string[]>();
                    foreach (SAForms_GetMissingImagesNew_Results img in imgList)
                    {
                        String[] imageDetails = new String[6];
                        imageDetails[0] = img.VehicleNo.ToString();
                        imageDetails[1] = img.JobNo.ToString();
                        imageDetails[2] = img.OfficerCode.ToString();
                        imageDetails[3] = img.C3.GetValueOrDefault().ToString();
                        imageDetails[4] = img.C4.GetValueOrDefault().ToString();
                        imageDetails[5] = img.C5.GetValueOrDefault().ToString();

                        LostImgList.Add(imageDetails);
                    }

                    return new object[] { LostImgList, count };
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        #endregion

        //Atheek 22-05-2019

        #region SA Visited Time Difference Section

        [Description("Visited Time Difference")]
        public ActionResult VisitedTimeDifferenceReport(VisitedTimeDifferenceModel Model)
        {
            if (Model.Name == "All")
            {
                Model.Name = null;
            }
            UserDataModel user = new UserDataModel();
            List<SelectListItem> techOfficersList = new List<SelectListItem>();
            List<SelectListItem> regionList = new List<SelectListItem>();

            user = GetLoggedUserDetail();


            //Regions including All

            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1"
            });
            if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            }
            else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));
            }

            //If selected manually
            if (Model.RegionName != null)
            {
                if (Model.RegionName != "-1")
                {
                    //not null and not all
                    regionList.First(x => x.Value == Model.RegionName).Selected = true;
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = null,
                    });
                }
            }

            if (user.RoleName != Resources.info_role_engineer)
            {
                if (Model.RegionName == null)
                {
                    regionList.First(x => x.Value == "-1").Selected = true;
                }
            }
            else
            {
                string regionId = user.RegionId.ToString();
                regionList.First(x => x.Value == regionId).Selected = true;
                techOfficersList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                });
            }

            //TOs including All
            if (Model.RegionName == "-1" || Model.RegionName == null)
            {
                if (user.RoleName != Resources.info_role_engineer)
                {
                    techOfficersList.Add(new SelectListItem
                    {
                        Text = Resources.info_gen_all,
                        Value = "-1",
                    });
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(-1)));
                }
                else
                {
                    ViewData["RegionName"] = regionList.Where(x => x.Selected == true).FirstOrDefault().Text;
                }
            }

            SelectListItem selectedListItem = regionList.Where(x => x.Selected == true).FirstOrDefault();


            if (selectedListItem != null)
            {
                if (selectedListItem.Value == "-1")
                {
                    techOfficersList.First(y => y.Value == "-1").Selected = true;
                }
                else
                {
                    techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(selectedListItem.Value))));
                }
            }

            ViewData["Role"] = user.RoleName;
            ViewData["TechOfficers"] = techOfficersList;
            ViewData["Regions"] = regionList;

            return GetFormatView("Reports/VisitedTimeDifferenceReport.aspx", Model);
        }

        [Description("Visited Time Difference Ajax Handler")]
        public ActionResult VisitedTimeDifferenceReportAjaxHandler(JQueryDataTableParamModel param, VisitedTimeDifferenceModel Model)
        {
            if (Model.RegionName == "null") return null;

            int count = 0;
            List<string[]> perfList = null;

            var objArr = VisitedTimeDifferenceReportCommonNew(param, Model);
            if (objArr != null)
            {
                var dataX = objArr as object[];
                perfList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = perfList
            },
            JsonRequestBehavior.AllowGet);
        }

        private object[] VisitedTimeDifferenceReportCommonNew(JQueryDataTableParamModel param, VisitedTimeDifferenceModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            List<String[]> perfList = new List<string[]>();
            int? count = 0;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",VisitedTimeDifferenceReportCommon," +
                   User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",Region Id: " + Model.RegionName + ",TO Code: " + Model.Name + ")]");

                #region DateTO/From

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);//set to 23:59 PM of the given date
                if (!Model.DateTo.HasValue)
                    dateTo = DateTime.Now;
                //datefrom default date

                #endregion

                var udm = GetLoggedUserDetail();
                int RegionId = udm.RegionId;
                string role = udm.RoleName;



                #region RoleBasedProperty

                #region TO

                if (Model.Name == "All" || Model.Name == "-1" || Model.Name == "undefined" || Model.Name == null)
                    Model.TOCode = null;
                else
                    Model.TOCode = Model.Name;

                #endregion

                if (role.Equals(Resources.info_role_systemAdministrator) || role.Equals("Audit") || role.Equals("Management"))
                {
                    if (Model.RegionName == "-1" || Model.RegionName == "All" || Model.RegionName == "undefined" || Model.RegionName == null)
                        Model.RegionId = null;
                    else
                        Model.RegionId = Convert.ToInt32(Model.RegionName);
                }

                if (role.Equals(Resources.info_role_engineer))
                    Model.RegionId = RegionId;



                #endregion

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<GetVisitedTimeDifference_Result> reports = new List<GetVisitedTimeDifference_Result>();

                    var VisitedJobList = context.GetVisitedTimeDifference(dateFrom, dateTo, Model.RegionId, Model.TOCode);

                    foreach (var report in VisitedJobList)
                    {
                        GetVisitedTimeDifference_Result element = new GetVisitedTimeDifference_Result();
                        element.JobNo = report.JobNo.ToString();
                        element.TOCode = report.TOCode;
                        element.TOName = report.TOName;
                        element.GEN_VehicleNo = report.GEN_VehicleNo;
                        element.AssignedDateTime = report.AssignedDateTime;
                        element.TimeVisited = report.TimeVisited;
                        element.Difference = report.Difference;
                        reports.Add(element);
                    }
                    count = perfList.Count;

                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc     

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.TOCode).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.TOCode).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.TOName).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.TOName).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.GEN_VehicleNo).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.GEN_VehicleNo).ToList();
                                break;
                            }
                        case 3:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.JobNo).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.JobNo).ToList();
                                break;
                            }
                        case 4:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.AssignedDateTime).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.AssignedDateTime).ToList();
                                break;
                            }
                        case 5:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.TimeVisited).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.TimeVisited).ToList();
                                break;
                            }
                        case 6:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.Difference).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.Difference).ToList();
                                break;
                            }
                    }

                    #endregion

                    var reportList = reports.AsQueryable();
                    var data = new List<VisitedTimeDifferenceModel>();
                    if (isPrintPreview)
                    {
                        if (Model.TOCode != null)
                        {
                            Model.TOCode = Model.Name;
                            var firstRow = reportList.First();
                            Model.Name = firstRow.TOName;

                        }

                        if (Model.RegionName != "-1")
                        {
                            int regionID = Convert.ToInt32(Model.RegionName);
                            var tmp = context.RegionEntities.Where(u => u.RegionId == regionID).FirstOrDefault();
                            Model.RName = (tmp == null) ? "" : tmp.RegionName;
                            Model.RegionName = (tmp == null) ? "" : tmp.RegionId.ToString();//set region name in the print preview
                        }
                        #region isPrintPreview
                        foreach (var item in reportList)
                        {
                            data.Add(new VisitedTimeDifferenceModel
                            {
                                TOCode = item.TOCode,
                                Name = item.TOName,
                                VehicleNo = item.GEN_VehicleNo,
                                JobNo = item.JobNo,
                                AssignedTimeDisplay = (item.AssignedDateTime != null) ? Convert.ToDateTime(item.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat) : "",
                                VisitedTimeDisplay = (item.TimeVisited != null) ? Convert.ToDateTime(item.TimeVisited).ToString(ApplicationSettings.GetDateTimeFormat) : "",
                                TimeDifference = item.Difference
                            });
                        }
                        TempData["searchModel"] = Model;
                        ViewData["PrintUser"] = GetUser();
                        return new object[] { data, count };  //Second param (count) will not be used 
                        #endregion
                    }

                    if (isExcel)
                    {
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                        foreach (GetVisitedTimeDifference_Result item in reportList)
                        {

                            filteredData.Add(new KeyValuePair<string, string>[]
                            { 
                                
                                new KeyValuePair<string,string>("TO Code", item.TOCode),
                                new KeyValuePair<string,string>("TO Name", item.TOName),    
                                new KeyValuePair<string,string>("Vehicle No", item.GEN_VehicleNo),
                                new KeyValuePair<string,string>("Job No", item.JobNo),
                                new KeyValuePair<string,string>("Assigned Time", Convert.ToDateTime(item.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat)),
                                new KeyValuePair<string,string>("Time Visited", Convert.ToDateTime(item.TimeVisited).ToString(ApplicationSettings.GetDateTimeFormat)),
                                new KeyValuePair<string,string>("Difference", item.Difference.ToString())
                               
                            });

                        }
                        count = reports.Count;
                        return new object[] { filteredData, count };
                    }

                    if (!isExcel)
                        count = (reportList == null) ? 0 : reportList.Count();

                    if (!isExcel)
                        reportList = reportList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (GetVisitedTimeDifference_Result report in reportList)
                    {
                        String[] perfArr = new String[7];
                        perfArr[0] = report.TOCode.ToString();
                        perfArr[1] = report.TOName.ToString();
                        perfArr[2] = report.GEN_VehicleNo.ToString();
                        perfArr[3] = report.JobNo.ToString();
                        perfArr[4] = Convert.ToDateTime(report.AssignedDateTime).ToString(ApplicationSettings.GetDateTimeFormat);
                        perfArr[5] = Convert.ToDateTime(report.TimeVisited).ToString(ApplicationSettings.GetDateTimeFormat);
                        perfArr[6] = report.Difference.ToString();
                        perfList.Add(perfArr);
                    }

                }

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "VisitedTimeDifferenceReportCommonNew," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return new object[] { perfList, count };
        }

        [Description("Visited Time Difference Report to Excel")]
        public FileContentResult VisitedTimeDifferenceReportToExcel(VisitedTimeDifferenceModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Site Visit Monitoring Report to Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = VisitedTimeDifferenceReportCommonNew(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Site Visit Monitoring Report to Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    // return File(fileContent, "text/csv", "Photo Availability Report ( " +VisitType + " )"+ DateTime.Now.ToString(rptDateFormat) + ".csv");
                    return File(fileContent, "text/csv", "Site Visit Monitoring Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");

                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Site Visit Monitoring Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Site Visit Monitoring Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        [Description("Visited Time Difference Report Print Preview")]
        public ActionResult VisitedTimeDifferenceReportPrintPreview(JQueryDataTableParamModel param, VisitedTimeDifferenceModel searchModel)
        {
            List<VisitedTimeDifferenceModel> data = new List<VisitedTimeDifferenceModel>();
            try
            {
                var objArr = VisitedTimeDifferenceReportCommonNew(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<VisitedTimeDifferenceModel>;
                }
            }
            catch (Exception)
            {
                throw;
            }
            return GetFormatView("Reports/PrintVisitedTimeDifferenceReport.aspx", data);
        }

        #endregion

        #region Investigation Monitoring Report (Further Review)

        [Description("Investigation Monitoring Report")]
        public ActionResult InvestigationMonitoringReport(InvestigationMonitorModel Model)
        {
            #region RelationshipType
            List<SelectListItem> RelationshipTypeList = new List<SelectListItem>();

            RelationshipTypeList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "0",
                Selected = true
            });

            RelationshipTypeList.AddRange(ConvertToSelectList(EnumUtils.GetEnumList(typeof(RelationshipType))));

            #endregion

            #region FurtherReview
            List<SelectListItem> FurtherReviewList = new List<SelectListItem>();

            //FurtherReviewList.Add(new SelectListItem
            //{
            //    Text = Resources.info_gen_all,
            //    Value = "-1",
            //    Selected = true
            //});

            FurtherReviewList.AddRange(ConvertToSelectList(EnumUtils.GetEnumList(typeof(Confirmation))));
            #endregion


            ViewData["RelationshipType"] = RelationshipTypeList;
            ViewData["FutherReview"] = FurtherReviewList;

            return GetFormatView("Reports/InvestigationMonitoringReport.aspx", Model);
        }

        [Description("Investigation Monitoring Report Ajax Handler")]
        public ActionResult InvestigationMonitoringReportAjaxHandler(JQueryDataTableParamModel param, InvestigationMonitorModel Model)
        {

            int count = 0;
            List<string[]> perfList = null;

            var objArr = InvestigationMonitoringReportCommonNew(param, Model);
            if (objArr != null)
            {
                var dataX = objArr as object[];
                perfList = dataX[0] as List<string[]>;
                count = Convert.ToInt32(dataX[1]);
            }

            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = count,
                iTotalDisplayRecords = count,
                aaData = perfList
            },
            JsonRequestBehavior.AllowGet);
        }

        [Description("Investigation Monitoring Report to Excel")]
        public FileContentResult InvestigationMonitoringReportToExcel(InvestigationMonitorModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Site Visit Monitoring Report to Excel," + User.Identity.Name);

                List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                var objArr = InvestigationMonitoringReportCommonNew(null, searchModel, false, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    filteredData = dataX[0] as List<KeyValuePair<string, string>[]>;
                }

                byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                if (fileContent != null)
                {
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Investigation Monitoring Report to Excel," + User.Identity.Name);
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                    // return File(fileContent, "text/csv", "Photo Availability Report ( " +VisitType + " )"+ DateTime.Now.ToString(rptDateFormat) + ".csv");
                    return File(fileContent, "text/csv", "Investigation Monitoring Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");

                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Investigation Monitoring Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Investigation Monitoring Report to Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        [Description("Investigation Monitoring Report Print Preview")]
        public ActionResult InvestigationMonitoringReportPrintPreview(JQueryDataTableParamModel param, InvestigationMonitorModel searchModel)
        {
            List<InvestigationMonitorModel> data = new List<InvestigationMonitorModel>();
            try
            {
                var objArr = InvestigationMonitoringReportCommonNew(param, searchModel, true);
                if (objArr != null)
                {
                    var dataX = objArr as object[];
                    data = dataX[0] as List<InvestigationMonitorModel>;
                }
            }
            catch (Exception)
            {
                throw;
            }
            return GetFormatView("Reports/PrintInvestigationMonitoringReport.aspx", data);
        }


        private object[] InvestigationMonitoringReportCommonNew(JQueryDataTableParamModel param, InvestigationMonitorModel Model, bool isPrintPreview = false, bool isExcel = false)
        {
            List<String[]> perfList = new List<string[]>();
            int? count = 0;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",InvestigationMonitoringReporCommonNew," +
                   User.Identity.Name + ",[Params=(DateFrom: " + Model.DateFrom + ",Date To: " + Model.DateTo + ",ACR From: " + Model.ACRFrom + ",ACR TO: " + Model.ACRTo + "," +
                   "Time From: " + Model.TimeFrom + ",Time TO: " + Model.TimeTo + ",Realtionship: " + Model.RelationshipId + ",Further Review: " + Model.FurtherReview + " )]");

                #region DateTO/From

                DateTime? dateFrom = Model.DateFrom;//set to 12:00 AM of the given date
                DateTime? dateTo = Model.DateTo;
                if (dateTo.HasValue)
                    dateTo = dateTo.Value.AddHours(23).AddMinutes(59);//set to 23:59 PM of the given date
                if (!Model.DateTo.HasValue)
                    dateTo = DateTime.Now;
                //datefrom default date

                string timeFrom = Model.TimeFrom.HasValue ? Model.TimeFrom.Value.ToString("t") : null;
                string timeTo = Model.TimeTo.HasValue ? Model.TimeTo.Value.ToString("t") : null;

                #endregion

                var udm = GetLoggedUserDetail();
                int RegionId = udm.RegionId;
                string role = udm.RoleName;
                string acrFrom = String.IsNullOrWhiteSpace(Model.ACRFrom) ? null : Convert.ToDecimal(Model.ACRFrom).ToString();
                string acrTo = String.IsNullOrWhiteSpace(Model.ACRTo) ? null : Convert.ToDecimal(Model.ACRTo).ToString();

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<GetInvestigationMonitor_Result> reports = new List<GetInvestigationMonitor_Result>();

                    var InvestigationMonitorList = context.GetInvestigationMonitor(dateFrom, dateTo, acrFrom, acrTo, timeFrom, timeTo, Model.RelationshipId, Model.FurtherReview);

                    foreach (var report in InvestigationMonitorList)
                    {
                        GetInvestigationMonitor_Result element = new GetInvestigationMonitor_Result();
                        element.JobNo = report.JobNo.ToString();
                        element.VehicleNo = report.VehicleNo;
                        element.AccidentDate = report.AccidentDate;
                        element.ACR = report.ACR;
                        element.ToName = report.ToName;
                        element.ToContactNo = report.ToContactNo;
                        element.PoliceStation = report.PoliceStation;
                        element.Relationship = report.Relationship;
                        element.FurtherReview = report.FurtherReview;
                        reports.Add(element);
                    }
                    count = perfList.Count;

                    #region Sorting Section

                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    var sortDirection = Request["sSortDir_0"]; // asc or desc     

                    switch (sortColumnIndex)
                    {
                        case 0:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.VehicleNo).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.VehicleNo).ToList();
                                break;
                            }
                        case 1:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.JobNo).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.JobNo).ToList();
                                break;
                            }
                        case 2:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.AccidentDate).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.AccidentDate).ToList();
                                break;
                            }
                        case 3:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.ACR).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.ACR).ToList();
                                break;
                            }
                        case 4:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.ToName).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.ToName).ToList();
                                break;
                            }
                        case 5:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.ToContactNo).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.ToContactNo).ToList();
                                break;
                            }
                        case 6:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.PoliceStation).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.PoliceStation).ToList();
                                break;
                            }
                        case 7:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.Relationship).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.Relationship).ToList();
                                break;
                            }
                        case 8:
                            {
                                if (sortDirection == "asc")
                                    reports = reports.OrderBy(arr => arr.FurtherReview).ToList();
                                else
                                    reports = reports.OrderByDescending(arr => arr.FurtherReview).ToList();
                                break;
                            }
                    }
                    #endregion

                    var reportList = reports.AsQueryable();

                    var data = new List<InvestigationMonitorModel>();

                    if (isPrintPreview)
                    {
                        string relationship = (Model.RelationshipId == 0) ? null : EnumUtils.GetEnumList(typeof(RelationshipType)).Single(v => v.Key == Model.RelationshipId).Value;
                        Model.Relationship = relationship;
                        Model.FurtherReviewDisplay = (Model.FurtherReview == 1) ? "Yes" : "No";
                        foreach (var item in reportList)
                        {
                            data.Add(new InvestigationMonitorModel
                            {
                                VehicleNo = item.VehicleNo,
                                JobNo = item.JobNo,
                                AccidentTimeDisplay = Convert.ToDateTime(item.AccidentDate).ToString(ApplicationSettings.GetDateTimeFormat),
                                ACRAmount = string.Format("{0:N}", Convert.ToDouble(item.ACR)),
                                Name = item.ToName,
                                ToContactNo = item.ToContactNo,
                                PoliceStation = item.PoliceStation,
                                Relationship = item.Relationship,
                                FurtherReviewDisplay = (item.FurtherReview) ? "Yes" : "No"
                            });
                        }

                        TempData["searchModel"] = Model;
                        ViewData["PrintUser"] = GetUser();
                        return new object[] { data, count };
                    }

                    if (isExcel)
                    {
                        List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();
                        foreach (GetInvestigationMonitor_Result item in reportList)
                        {
                            filteredData.Add(new KeyValuePair<string, string>[]
                            {
                                new KeyValuePair<string,string>("Vehicle No",item.VehicleNo),
                                new KeyValuePair<string,string>("Job No",item.JobNo),
                                new KeyValuePair<string,string>("Date and Time of the Accident",Convert.ToDateTime(item.AccidentDate).ToString(ApplicationSettings.GetDateTimeFormat)),
                                new KeyValuePair<string,string>("ACR",item.ACR.ToString()),
                                new KeyValuePair<string,string>("To Name",item.ToName),
                                new KeyValuePair<string,string>("Contact Number",item.ToContactNo),
                                new KeyValuePair<string,string>("Police Station",item.PoliceStation),
                                new KeyValuePair<string,string>("Relationship between Driver & Insured",item.Relationship),
                                new KeyValuePair<string,string>("Further Review",(item.FurtherReview) ? "Yes" : "No")
                            });
                        }

                        count = reports.Count;
                        return new object[] { filteredData, count };
                    }



                    if (!isExcel)
                        count = (reportList == null) ? 0 : reportList.Count();

                    if (!isExcel)
                        reportList = reportList.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (GetInvestigationMonitor_Result report in reportList)
                    {
                        String[] perfArr = new String[9];
                        perfArr[0] = report.JobNo.ToString();
                        perfArr[1] = report.VehicleNo.ToString();
                        perfArr[2] = Convert.ToDateTime(report.AccidentDate).ToString(ApplicationSettings.GetDateTimeFormat);
                        perfArr[3] = string.Format("{0:N}", Convert.ToDouble(report.ACR));
                        perfArr[4] = report.ToName;
                        perfArr[5] = report.ToContactNo;
                        perfArr[6] = report.PoliceStation;
                        perfArr[7] = report.Relationship;
                        perfArr[8] = (report.FurtherReview) ? "Yes" : "No";
                        perfList.Add(perfArr);
                    }
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + "VisitedTimeDifferenceReportCommonNew," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return new object[] { perfList, count };
        }

        #endregion


        #region Audit Logs Section

        [Description("Audit Log")]
        public ActionResult AuditLog(AccessLogModel searchModel)
        {
            List<SelectListItem> branchList = new List<SelectListItem>();
            branchList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1",
                Selected = true
            });

            if (!string.IsNullOrEmpty(searchModel.RegionName))
            {
                if (!searchModel.RegionName.Equals("-1"))
                {
                    try
                    {
                        List<SelectListItem> initBranchList = new List<SelectListItem>();
                        using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                        {
                            int regionId = Convert.ToInt32(searchModel.RegionName);
                            IEnumerable<vw_Branches> query = from b in context.vw_Branches
                                                             where b.RegionId == regionId
                                                             select b;
                            initBranchList = (from b in query
                                              orderby b.BranchName
                                              select new SelectListItem
                                              {
                                                  Text = b.BranchName,
                                                  Value = b.BranchName
                                              }).ToList();
                            branchList.AddRange(initBranchList);
                        }
                    }
                    catch (Exception)
                    { }
                }
            }

            ViewData["Branches"] = branchList;

            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectListForAuditLog(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            List<SelectListItem> InspectionTypeList = new List<SelectListItem>();
            InspectionTypeList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1",
                Selected = true
            });

            InspectionTypeList.AddRange(ConvertToTextSelectList(EnumUtils.GetEnumList(typeof(VisitType))));

            ViewData["InspectionType"] = InspectionTypeList;
            return GetFormatView("Reports/AuditLogs.aspx", searchModel);
        }

        [Description("Visit Log")]
        public ActionResult VisitLog(int? ID)
        {
            if (ID.HasValue)
            {
                return GetFormatView("Reports/VisitLogs.aspx", ID);
            }
            else
            {
                return ErrorView();
            }
        }

        [Description("Audit Log Ajax Handler")]
        public ActionResult AuditLogAjaxHandler(JQueryDataTableParamModel param, AccessLogModel searchModel)
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();

            var isModuleSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
            var isActionSearchable = Convert.ToBoolean(Request["bSearchable_1"]);
            var isAccessTypeSearchable = Convert.ToBoolean(Request["bSearchable_2"]);
            var isAccessIPSearchable = Convert.ToBoolean(Request["bSearchable_3"]);
            var isUserNameSearchable = Convert.ToBoolean(Request["bSearchable_4"]);
            var isRefIDSearchable = Convert.ToBoolean(Request["bSearchable_5"]);
            var isEventStatusSearchable = Convert.ToBoolean(Request["bSearchable_6"]);
            var isDateSearchable = Convert.ToBoolean(Request["bSearchable_7"]);
            var isDescriptionSearchable = Convert.ToBoolean(Request["bSearchable_8"]);
            var isParamsSearchable = Convert.ToBoolean(Request["bSearchable_9"]);

            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            string orderingColomn = "Date";
            DateTime? dateFrom = searchModel.DateFrom;
            DateTime? dateTo = searchModel.DateTo;

            if (searchModel.DateFrom.HasValue && searchModel.TimeFrom.HasValue)
            {
                dateFrom = searchModel.DateFrom.Value + (searchModel.TimeFrom.Value - DateTime.Today);
            }
            if (searchModel.DateTo.HasValue && searchModel.TimeTo.HasValue)
            {
                dateTo = searchModel.DateTo.Value + (searchModel.TimeTo.Value - DateTime.Today);
            }
            if (!dateFrom.HasValue)
            {
                dateFrom = Convert.ToDateTime("2017-01-01 00:00:00"); ; //dateFrom.HasValue ? dateFrom.Value : DateTime.Now.AddYears(-1),
            }

            #region sorting section
            switch (sortColumnIndex)
            {
                case 0:
                    orderingColomn = "Date";
                    break;
                case 1:
                    orderingColomn = "VehicleNo";
                    break;
                case 2:
                    orderingColomn = "JobNo";
                    break;
                case 3:
                    orderingColomn = "CSRCode";
                    break;
                case 4:
                    orderingColomn = "Username";
                    break;
                case 5:
                    orderingColomn = "BranchName";
                    break;
                case 6:
                    orderingColomn = "InspectionType";
                    break;
                case 7:
                    orderingColomn = "Action";
                    break;
                default:
                    orderingColomn = "Date";
                    break;
            }
            #endregion

            List<KeyValuePair<string, string>[]> eventList = auditLogger.GetEvents(string.Empty,
                string.Empty,
                string.Empty,
                string.Empty,
                searchModel.Username,
                string.Empty,
                dateFrom,
                dateTo,
                string.Empty,
                string.Empty,
                searchModel.CSRCode,
                searchModel.BranchName.Equals("-1") ? string.Empty : searchModel.BranchName.ToString(),
                searchModel.RegionName.Equals("-1") ? string.Empty : searchModel.RegionName.ToString(),
                searchModel.EFPNo,
                searchModel.VehicleNo,
                searchModel.JobNo,
                searchModel.InspectionTypeName.Equals("-1") ? string.Empty : searchModel.InspectionTypeName.ToString(),
                string.Empty,
                string.Empty, string.Empty,
                orderingColomn,
                Request["sSortDir_0"] == null ? true : Request["sSortDir_0"].Equals("desc") ? true : false,
                param.iDisplayStart, param.iDisplayLength, out totalRecordCount);

            foreach (KeyValuePair<string, string>[] item in eventList)
            {
                string[] eventRow = new string[9];
                eventRow[0] = DateTime.Parse(item[8].Value).ToString(ApplicationSettings.GetDateTimeFormat); //Date
                eventRow[1] = item[15].Value; //GEN_VehicleNo
                eventRow[2] = item[16].Value; //JobNo
                eventRow[3] = item[11].Value; //Code
                eventRow[4] = item[5].Value; //UserName
                eventRow[5] = item[12].Value; //Branch
                eventRow[6] = item[17].Value; //InspectionType
                eventRow[7] = item[2].Value; //Action
                //eventRow[7] = item[7].Value;
                //eventRow[8] = item[8].Value;
                //eventRow[9] = item[9].Value;
                //eventRow[10] = item[10].Value;
                jsonData.Add(eventRow);
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

        [Description("Visit Log Ajax Handler")]
        public ActionResult VisitLogAjaxHandler(JQueryDataTableParamModel param, int ID)
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();

            var isModuleSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
            var isActionSearchable = Convert.ToBoolean(Request["bSearchable_1"]);
            var isAccessTypeSearchable = Convert.ToBoolean(Request["bSearchable_2"]);
            var isAccessIPSearchable = Convert.ToBoolean(Request["bSearchable_3"]);
            var isUserNameSearchable = Convert.ToBoolean(Request["bSearchable_4"]);
            var isRefIDSearchable = Convert.ToBoolean(Request["bSearchable_5"]);
            var isEventStatusSearchable = Convert.ToBoolean(Request["bSearchable_6"]);
            var isDateSearchable = Convert.ToBoolean(Request["bSearchable_7"]);
            var isDescriptionSearchable = Convert.ToBoolean(Request["bSearchable_8"]);
            var isParamsSearchable = Convert.ToBoolean(Request["bSearchable_9"]);

            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            string orderingColomn = "Date";

            switch (sortColumnIndex)
            {
                case 0:
                    orderingColomn = "Date";
                    break;
                case 1:
                    orderingColomn = "VehicleNo";
                    break;
                case 2:
                    orderingColomn = "JobNo";
                    break;
                case 3:
                    orderingColomn = "CSRCode";
                    break;
                case 4:
                    orderingColomn = "Username";
                    break;
                case 5:
                    orderingColomn = "BranchName";
                    break;
                case 6:
                    orderingColomn = "InspectionType";
                    break;
                case 7:
                    orderingColomn = "Action";
                    break;
                default:
                    orderingColomn = "Date";
                    break;
            }

            List<KeyValuePair<string, string>[]> eventList = auditLogger.GetEvents(string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, DateTime.Now.AddYears(-1), null, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, string.Empty, ID.ToString(), string.Empty, string.Empty, orderingColomn, Request["sSortDir_0"] == null ? true : Request["sSortDir_0"].Equals("desc") ? true : false, param.iDisplayStart, param.iDisplayLength, out totalRecordCount);

            foreach (KeyValuePair<string, string>[] item in eventList)
            {
                string[] eventRow = new string[9];
                eventRow[0] = DateTime.Parse(item[8].Value).ToString(ApplicationSettings.GetDateTimeFormat); //Date
                eventRow[1] = item[15].Value; //GEN_VehicleNo
                eventRow[2] = item[16].Value; //JobNo
                eventRow[3] = item[11].Value; //Code
                eventRow[4] = item[5].Value; //UserName
                eventRow[5] = item[12].Value; //Branch
                eventRow[6] = item[17].Value; //InspectionType
                eventRow[7] = item[2].Value; //Action
                //eventRow[7] = item[7].Value;
                //eventRow[8] = item[8].Value;
                //eventRow[9] = item[9].Value;
                //eventRow[10] = item[10].Value;
                jsonData.Add(eventRow);
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

        [Description("Audit Log Print Preview")]
        public ActionResult AuditLogPrintPreview(AccessLogModel searchModel)
        {
            List<AccessLogModel> data = new List<AccessLogModel>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Audit Log Print Preview," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int rowCount = 0;
                    DateTime? dateFrom = searchModel.DateFrom;
                    DateTime? dateTo = searchModel.DateTo;

                    if (searchModel.DateFrom.HasValue && searchModel.TimeFrom.HasValue)
                    {
                        dateFrom = searchModel.DateFrom.Value + (searchModel.TimeFrom.Value - DateTime.Today);
                    }
                    if (searchModel.DateTo.HasValue && searchModel.TimeTo.HasValue)
                    {
                        dateTo = searchModel.DateTo.Value + (searchModel.TimeTo.Value - DateTime.Today);
                    }

                    List<KeyValuePair<string, string>[]> events = auditLogger.GetEvents(string.Empty, string.Empty, string.Empty, string.Empty, searchModel.Username, string.Empty, dateFrom.HasValue ? dateFrom.Value : DateTime.Now.AddYears(-1), dateTo, string.Empty, string.Empty, searchModel.CSRCode, searchModel.BranchName.Equals("-1") ? string.Empty : searchModel.BranchName.ToString(), searchModel.RegionName.Equals("-1") ? string.Empty : searchModel.RegionName.ToString(), searchModel.EFPNo, searchModel.VehicleNo, searchModel.JobNo, searchModel.InspectionTypeName.Equals("-1") ? string.Empty : searchModel.InspectionTypeName.ToString(), string.Empty, string.Empty, string.Empty, "", true, 1, 65535, out rowCount);

                    foreach (KeyValuePair<string, string>[] item in events)
                    {
                        data.Add(new AccessLogModel()
                        {
                            VehicleNo = item[15].Value,
                            JobNo = item[16].Value,
                            CSRCode = item[11].Value,
                            Username = item[5].Value,
                            BranchName = item[12].Value,
                            InspectionTypeName = item[17].Value,
                            Action = item[2].Value
                        });
                    }

                    TempData["searchModel"] = searchModel;

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Audit Log Print Preview," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                }

                //Used for the footer
                ViewData["PrintUser"] = GetUser();
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Audit Log Print Preview," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(600, Resources.err_600));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Audit Log Print Preview," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return GetFormatView("Reports/PrintAuditLogs.aspx", data);
        }

        [Description("Download AuditLog as Excel")]
        public FileContentResult AuditLogToExcel(AccessLogModel searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AuditLog To Excel," + User.Identity.Name);

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int rowCount = 0;
                    DateTime? dateFrom = searchModel.DateFrom;
                    DateTime? dateTo = searchModel.DateTo;

                    if (searchModel.DateFrom.HasValue && searchModel.TimeFrom.HasValue)
                    {
                        dateFrom = searchModel.DateFrom.Value + (searchModel.TimeFrom.Value - DateTime.Today);
                    }
                    if (searchModel.DateTo.HasValue && searchModel.TimeTo.HasValue)
                    {
                        dateTo = searchModel.DateTo.Value + (searchModel.TimeTo.Value - DateTime.Today);
                    }

                    List<KeyValuePair<string, string>[]> events = auditLogger.GetEvents(string.Empty, string.Empty, string.Empty, string.Empty, searchModel.Username, string.Empty, dateFrom.HasValue ? dateFrom.Value : DateTime.Now.AddYears(-1), dateTo, string.Empty, string.Empty, searchModel.CSRCode, searchModel.BranchName.Equals("-1") ? string.Empty : searchModel.BranchName.ToString(), searchModel.RegionName.Equals("-1") ? string.Empty : searchModel.RegionName.ToString(), searchModel.EFPNo, searchModel.VehicleNo, searchModel.JobNo, searchModel.InspectionTypeName.Equals("-1") ? string.Empty : searchModel.InspectionTypeName.ToString(), string.Empty, string.Empty, string.Empty, "", true, 1, 65535, out rowCount);
                    List<KeyValuePair<string, string>[]> filteredData = new List<KeyValuePair<string, string>[]>();

                    foreach (KeyValuePair<string, string>[] item in events)
                    {
                        filteredData.Add(new KeyValuePair<string, string>[] { 
                            new KeyValuePair<string,string>("Vehicle No", item[15].Value),
                            new KeyValuePair<string,string>("Job No", item[16].Value),
                            new KeyValuePair<string,string>("CSR Code", item[11].Value),
                            new KeyValuePair<string,string>("User Name", item[5].Value),
                            new KeyValuePair<string,string>("Branch", item[12].Value),
                            new KeyValuePair<string,string>("Inspection Type", item[17].Value),
                            new KeyValuePair<string,string>("Action", item[2].Value)
                        });
                    }
                    byte[] fileContent = ConverterUtils.DataListToExcel(filteredData);

                    if (fileContent != null)
                    {
                        logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AuditLog To Excel," + User.Identity.Name);
                        auditLogger.AddEvent(LogPoint.Success.ToString());
                        return File(fileContent, "text/csv", "Audit Logs Report " + DateTime.Now.ToString(rptDateFormat) + ".csv");
                    }
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AuditLog To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",AuditLog To Excel," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            return null;
        }

        #endregion



        [Description("Get Technical Officers Data List for Performance Report")]
        public static List<TOPerformanceModel> GetTechnicalOfficersDataList()
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    var technicalOfficers = (from u in context.vw_TO_Performance select new TOPerformanceModel { TOCode = u.TOCode, Name = u.FirstName + " " + u.LastName }).Distinct().ToList();
                    return technicalOfficers;

                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Description("Get Technical Officers Data List for Outstanding SA Report")]
        public static List<TOPerformanceModel> GetTechnicalOfficersDataListOutstandingJobs()
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //20161130 Uthpalap
                    var assignedJobList = (from u in context.AssignedJobs select new TOPerformanceModel { CSRCode = u.CSRCode }).Distinct();

                    //var assignedJobList = context.AssignedJobs.OrderBy(a => a.CSRCode).ToList();

                    var userList = context.UserEntities.Where(u => u.UserId != null).ToList();

                    var technicalOfficers = userList.Join(assignedJobList, s => s.UserId.ToString(), a => a.CSRCode, (s, a) =>
                        new TOPerformanceModel
                        {
                            TOCode = s.UserId,
                            Name = s.FirstName + " " + s.LastName
                        }).ToList();

                    return technicalOfficers;


                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        //2016/12/01 // A new method is written in Utility
        [Description("Get Technical Officers Data List for Outstanding SA Report")]
        public static List<TOPerformanceModel> GetAllTechnicalOfficers(int regionId)
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
                            Name = s.FirstName + " " + s.LastName
                        }).ToList();
                }
                return technicalOfficers;
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Description("Convert Technical Officers To Select List")]
        public List<SelectListItem> ConvertTechOfiicersToSelectList(List<TOPerformanceModel> techOfficers)
        {
            try
            {
                List<SelectListItem> selectlist = new List<SelectListItem>();
                foreach (TOPerformanceModel item in techOfficers)
                {
                    selectlist.Add(new SelectListItem
                    {
                        Text = item.Name,
                        Value = item.TOCode.ToString()
                    });
                }
                return selectlist;
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Description("Get users List")]
        public static List<KeyValuePair<Guid, string>> GetUsersList()
        {
            List<KeyValuePair<Guid, string>> list = new List<KeyValuePair<Guid, string>>();
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<UserEntity> query = from u in context.UserEntities select u;

                    foreach (UserEntity val in query)
                    {
                        if (val.Code != null)
                        {
                            Guid key = val.UserGUID;
                            string value = val.Code;
                            list.Add(new KeyValuePair<Guid, string>(key, value));
                        }
                    }
                    return list;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static List<KeyValuePair<string, string>> GetUsersListWithNames()
        {
            List<KeyValuePair<string, string>> list = new List<KeyValuePair<string, string>>();
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<UserEntity> query = from u in context.UserEntities select u;

                    foreach (UserEntity val in query)
                    {
                        if (val.Code != null)
                        {
                            string key = val.UserId.ToString();
                            string value = val.FirstName + " " + val.LastName;
                            list.Add(new KeyValuePair<string, string>(key, value));
                        }
                    }
                    return list;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Description("Convert To Select List")]
        public List<SelectListItem> ConvertToSelectList(List<KeyValuePair<Guid, string>> keyValueList)
        {
            try
            {

                return keyValueList.Select(item => new SelectListItem
                {
                    Text = item.Value,
                    Value = item.Value,
                }).ToList();
            }
            catch (Exception)
            {
                return null;
            }
        }

        public List<SelectListItem> ConvertToSelectListWithNames(List<KeyValuePair<string, string>> keyValueList)
        {
            try
            {

                return keyValueList.Select(item => new SelectListItem
                {
                    Value = item.Key,
                    Text = item.Value,
                }).ToList();
            }
            catch (Exception)
            {
                return null;
            }
        }

        public int CheckHoliday(DateTime AssignedDate, DateTime CompletedDate, List<DateTime> holidaysList)
        {
            DateTime starttime = Convert.ToDateTime(ConfigurationManager.AppSettings["startTime"]);
            DateTime endTime = Convert.ToDateTime(ConfigurationManager.AppSettings["endTime"]);
            #region Suren

            DateTime startDateTime = AssignedDate;
            DateTime endDateTime = CompletedDate;

            double startTimePeriod = 0;
            double endTimePeriod = 0;
            TimeSpan startTimeSpan = new TimeSpan(9, 0, 0); //8AM Convert.ToDateTime(ConfigurationManager.AppSettings["startTime"]);
            TimeSpan endTimeSpan = new TimeSpan(17, 0, 0); //5PM
            double regWorkingPeriod = (endTimeSpan - startTimeSpan).TotalMinutes;

            if (startDateTime < startDateTime.Date.Add(startTimeSpan))
            {
                startDateTime = startDateTime.Date.Add(startTimeSpan);
            }
            if (endDateTime > endDateTime.Date.Add(endTimeSpan))
            {
                endDateTime = endDateTime.Date.Add(endTimeSpan);
            }

            if (startDateTime >= startDateTime.Date.Add(startTimeSpan) && startDateTime <= startDateTime.Date.Add(endTimeSpan))
            {
                startTimePeriod = (startDateTime.Date.Add(endTimeSpan) - startDateTime).TotalMinutes;
            }

            if (endDateTime >= endDateTime.Date.Add(startTimeSpan) && endDateTime <= endDateTime.Date.Add(endTimeSpan))
            {
                endTimePeriod = (endDateTime - endDateTime.Date.Add(startTimeSpan)).TotalMinutes;
            }

            if (startDateTime.Date == endDateTime.Date)
            {
                startTimePeriod = (endDateTime - startDateTime).TotalMinutes;
                //60 Min removed coz TimeSpan(17, 0, 0) - TimeSpan(8, 0, 0) == should be 8 hours but C# returns as 9 hours
                //double regWorkingPeriod = (endTimeSpan - startTimeSpan).TotalMinutes - 60;
                if (startTimePeriod > regWorkingPeriod)
                    startTimePeriod = regWorkingPeriod;
                endTimePeriod = 0;
            }

            bool takeFirstDay = false;
            bool takeEndDay = false;
            string saturday = "saturday";
            string sunday = "sunday";
            string dateFormatter = "yyyy/MM/dd";

            DateTime intermideateDate = startDateTime;
            string startDateTimeName = startDateTime.DayOfWeek.ToString().ToLower();
            string endDateTimeName = endDateTime.DayOfWeek.ToString().ToLower();

            //Get all holidays from DB and format it then make a string with comma separated
            string holidays = "";

            //var dates = (from u in context.Holidays where u.Date >= startDateTime.Date && u.Date <= job.CompletedDate.Date select u).ToList();

            foreach (var date in holidaysList)
            {
                holidays = holidays + "," + date.ToString("yyyy/MM/dd");
            }

            string startDateTime_ = startDateTime.Date.ToString(dateFormatter);
            string endDateTime_ = endDateTime.Date.ToString(dateFormatter);
            double totalMinutesSpent = 0;

            while (intermideateDate <= endDateTime)
            {
                if (!startDateTimeName.Equals(saturday) && !startDateTimeName.Equals(sunday) && !holidays.Contains(startDateTime_))
                    takeFirstDay = true;
                if (!endDateTimeName.Equals(saturday) && !endDateTimeName.Equals(sunday) && !holidays.Contains(endDateTime_))
                    takeEndDay = true;

                if (intermideateDate.Date == startDateTime.Date || intermideateDate.Date == endDateTime.Date)
                {
                    intermideateDate = intermideateDate.AddDays(1);
                    continue;
                }

                var dayName = intermideateDate.DayOfWeek.ToString().ToLower();
                if (!dayName.Equals(saturday) && !dayName.Equals(sunday) && !holidays.Contains(intermideateDate.Date.ToString(dateFormatter)))
                {
                    totalMinutesSpent += regWorkingPeriod;
                }

                intermideateDate = intermideateDate.AddDays(1);
                continue;
            }

            if (takeFirstDay) totalMinutesSpent += startTimePeriod;
            if (takeEndDay) totalMinutesSpent += endTimePeriod;

            int hours = Convert.ToInt32(Math.Truncate(totalMinutesSpent / 60));
            #endregion

            return hours;
        }

        [HttpPost]
        [Description("Find Branches By Region Id")]
        public JsonResult FindBranchesByRegionId(string regionName)
        {
            try
            {
                List<BranchDataModel> branches = new List<BranchDataModel>();

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int regionId = Convert.ToInt32(regionName);
                    IEnumerable<vw_Branches> query = from b in context.vw_Branches
                                                     where b.RegionId == regionId
                                                     select b;
                    branches.Add(new BranchDataModel
                    {
                        BranchName = Resources.info_gen_all,
                        BranchId = -1
                    });
                    branches.AddRange((from b in query
                                       orderby b.BranchName
                                       select new BranchDataModel
                                       {
                                           BranchName = b.BranchName,
                                           RegionId = b.RegionId,
                                           BranchId = b.BranchId
                                       }).ToList());
                }
                JsonResult result = new JsonResult { JsonRequestBehavior = JsonRequestBehavior.AllowGet };

                result.Data = branches;
                return result;
            }
            catch (Exception e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On FindBranchesByRegionId," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);

                return new JsonResult
                {
                    Data = Resources.err_901
                };
            }
        }

        [Description("Select TO according to Region")]
        public ActionResult SelectTO(OutstandingJobsModel Model)
        {
            UserDataModel user = new UserDataModel();
            user = GetLoggedUserDetail();

            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "-1"
            });
            if (user.DataAccessLevel == (UserDataAccessLevel.AllRegion.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            }
            else if (user.DataAccessLevel == (UserDataAccessLevel.BranchOnly.GetHashCode()))
            {
                regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataListPerf(GetUserId())));
            }

            List<SelectListItem> techOfficersList = new List<SelectListItem>();
            if (Model.RegionName == "-1")
            {
                techOfficersList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                });
            }
            else
            {
                techOfficersList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "All",
                });
            }
            techOfficersList.AddRange(ConvertTechOfiicersToSelectList(Utility.GetTOs(Convert.ToInt32(Model.RegionName))));

            ViewData["TechOfficers"] = techOfficersList;
            ViewData["RegionName"] = regionList;
            ViewData["Role"] = user.RoleName;

            return Json(new
            {
                aaData = techOfficersList
            },
            JsonRequestBehavior.AllowGet);
        }

        //used in performance ratio calculation
        public ActionResult ScoreSendAjax()
        {
            var val = System.Web.HttpContext.Current.Session["totalScore"];
            if (val != null)
                return Json(val.ToString(), JsonRequestBehavior.AllowGet);
            return null;
        }

        //used in onsite average calculation
        public ActionResult AverageSendAjax()
        {
            //var val = System.Web.HttpContext.Current.Session["Average"];
            string[] val = new string[2];
            val[0] = System.Web.HttpContext.Current.Session["Average"].ToString();//ViewData["Average"];
            if (System.Web.HttpContext.Current.Session["RegionName"] != null)
            {
                val[1] = System.Web.HttpContext.Current.Session["RegionName"].ToString();
            }
            if (val[0] != null)
                return Json(val, JsonRequestBehavior.AllowGet);
            return null;
        }

        [Description("ARI PhotoAvailability Report")]
        public ActionResult ARIPhotoAvailabilityReport(InvestigationMonitorModel Model)
        {
            #region RelationshipType
            List<SelectListItem> RelationshipTypeList = new List<SelectListItem>();

            RelationshipTypeList.Add(new SelectListItem
            {
                Text = Resources.info_gen_all,
                Value = "0",
                Selected = true
            });

            RelationshipTypeList.AddRange(ConvertToSelectList(EnumUtils.GetEnumList(typeof(RelationshipType))));

            #endregion

            #region FurtherReview
            List<SelectListItem> FurtherReviewList = new List<SelectListItem>();

            //FurtherReviewList.Add(new SelectListItem
            //{
            //    Text = Resources.info_gen_all,
            //    Value = "-1",
            //    Selected = true
            //});

            FurtherReviewList.AddRange(ConvertToSelectList(EnumUtils.GetEnumList(typeof(Confirmation))));
            #endregion


            ViewData["RelationshipType"] = RelationshipTypeList;
            ViewData["FutherReview"] = FurtherReviewList;

            return GetFormatView("Reports/ARIPhotoAvailabilityReport.aspx");
        }


    }
}