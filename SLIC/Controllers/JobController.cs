 /***************************************************************************/
/// <summary>
/// 
///  <title>SLIC JobController</title>
///  <description>JobController for Jobs related actions</description>
///  <copyRight>Copyright (c) 2012</copyRight>
///  <company>IronOne Technologies (Pvt) Ltd</company>
///  <createdOn>2012-11-01</createdOn>
///  <author></author>
///  <modification>
///     <modifiedBy></modifiedBy>
///      <modifiedDate></modifiedDate>
///     <description></description> 
///  </modification>
///
/// </summary>
/***************************************************************************/

using System.Linq;
using System.Web.Mvc;
using System;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Job;
using System.Collections.Generic;
using com.IronOne.SLIC2.Models.Administration;
using log4net;
using com.IronOne.SLIC2.HandlerClasses;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Models.Visit;
using com.IronOne.SLIC2.Models.Vehicle;
using com.IronOne.IronUtils;
using System.Threading;
using System.IO;
using System.Xml;
using System.Data.SqlClient;
using System.Web;
using System.Configuration;
using System.Drawing;
using System.ComponentModel;
using System.Net.Mail;
using System.Web.UI.WebControls;
using System.Collections.Specialized;
using System.Globalization;
using System.Text;
using com.IronOne.SLIC2.Lang;
using System.Data;
using com.IronOne.SLIC2.Models;
using com.IronOne.SLIC2.Models.Auth;
using System.Web.Security;

#region SLICReferences

#endregion SLICReferences

#region ThirdPartyReferences

#endregion ThirdPartyReferences


namespace com.IronOne.SLIC2.Controllers
{
    public class JobController : BaseController
    {
        protected static readonly ILog logevt = LogManager.GetLogger("EventLog");
        protected static readonly ILog logerr = LogManager.GetLogger("ErrorLog");

        #region Actions

        #region Search

        /// <summary>
        /// action method to handle a search request
        /// </summary>
        /// <param name="searchModel"></param>
        /// <returns>If search model is not null redirect to advanced search</returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Description("Search")]
        public ActionResult Search(Search searchModel)
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search ," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");


            //System.Net.Mail.MailMessage message = this.CreateVisitMessage(new VisitEntity() { JobNo = "1111" });
            //message.IsBodyHtml = true;

            //Start sending email from a separate thread
            //EmailUtils e = new EmailUtils(message);
            //Thread thread = new Thread(new ThreadStart(e.SendEmail));
            //thread.Start();



            //adding dummy values to the branch code/name list
            //If search model is not null redirect to advanced search
            if (searchModel != null)
                return RedirectToAction("AdvancedSearch", searchModel = new AdvancedSearch { JobNo = searchModel.JobNo, VehicleNo = searchModel.VehicleNo });

            logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search ," + User.Identity.Name);

            return GetFormatView("Home/Home.aspx");
        }

        /// <summary>
        /// action method to handle an advanced search request
        /// </summary>
        /// <param name="searchModel"></param>
        /// <returns>search results view according to the search model</returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Description("Advanced Search")]
        public ActionResult AdvancedSearch(AdvancedSearch searchModel)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search ," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");

                TempData["searchModel"] = searchModel;

                List<SelectListItem> branchList = new List<SelectListItem>();
                branchList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                    Selected = true
                });

                List<SelectListItem> regionList = new List<SelectListItem>();
                regionList.Add(new SelectListItem
                {
                    Text = Resources.info_gen_all,
                    Value = "-1",
                    Selected = true
                });

                if (searchModel.RegionId != null && searchModel.RegionId > 0)
                {
                    List<SelectListItem> items = new AdminController().ConvertBranchedToSelectList(AdminController.GetBranchDataList(searchModel.RegionId, true, false));
                    branchList.AddRange(items);
                }

                ViewData["Branches"] = branchList;

                regionList.AddRange(ConvertRegionsToSelectList(GetRegionDataList()));
                ViewData["Regions"] = regionList;

                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search ," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");
                return GetFormatView("Job/SearchResults.aspx", searchModel);
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(99, e.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search ," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }

            return GetFormatView("Job/SearchResults.aspx");
        }      

        /// <summary>
        /// 
        /// </summary>
        /// <param name="param"></param>
        /// <param name="searchModel"></param>
        /// <returns></returns>
        /// <remarks></remarks>
        [Description("Advanced Search Ajax Handler")]
        public ActionResult AdvancedSearchAjaxHandler(JQueryDataTableParamModel param, AdvancedSearch searchModel)// Add JqueryParamModel
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Ajax Handler," +
                    User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");

                if (searchModel.BranchId == -1 &&
                    string.IsNullOrWhiteSpace(searchModel.BranchName) &&
                    string.IsNullOrWhiteSpace(searchModel.CSRCode) &&
                    string.IsNullOrWhiteSpace(searchModel.CSRName) &&
                    searchModel.DateFrom == null &&
                    searchModel.DateTo == null &&
                    string.IsNullOrWhiteSpace(searchModel.EPFNo) &&
                    string.IsNullOrWhiteSpace(searchModel.JobNo) &&
                    searchModel.RegionId == -1 &&
                    string.IsNullOrWhiteSpace(searchModel.RegionName) &&
                    searchModel.UserId == null &&
                    string.IsNullOrWhiteSpace(searchModel.VehicleNo)) return null;

                var iVehicleNoSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
                var isJobNoSearchable = Convert.ToBoolean(Request["bSearchable_1"]);
                var isDateofAccidentSearchable = Convert.ToBoolean(Request["bSearchable_2"]);
                var isCsrCodeSearchable = Convert.ToBoolean(Request["bSearchable_3"]);
                var isAcrSearchable = Convert.ToBoolean(Request["bSearchable_4"]);
                var isSaFormPrintSearchable = Convert.ToBoolean(Request["bSearchable_5"]);
                var isClaimFormImageSearchable = Convert.ToBoolean(Request["bSearchable_6"]);
                var isClaimProcessingBranchSearchable = Convert.ToBoolean(Request["bSearchable_7"]);

                if (!searchModel.DateFrom.HasValue)
                    //searchModel.DateFrom = Convert.ToDateTime("2017-01-01 00:00:00");

                    #region 2017-11-01 Uthpalap - Data not loading at the first load
                    //set to 23:59 PM of the given date
                    if (searchModel.DateTo.HasValue)
                        searchModel.DateTo = searchModel.DateTo.Value.AddHours(23).AddMinutes(59);

                if (!searchModel.DateTo.HasValue)
                    searchModel.DateTo = null;
                //searchModel.DateTo = DateTime.Now; //This gives the date time with miliseconds
                //searchModel.DateTo = Convert.ToDateTime(DateTime.Now.ToString("dd/MM/yyyy HH:mm"));

                    #endregion

                #region Get Sorting Column

                string orderBy = "";
                var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                Func<vw_SAForm_GeneralNew, object> orderingFunction = c => c.GEN_VehicleNo;

                switch (sortColumnIndex)
                {
                    case 0:
                        orderBy = "Vehicle No";
                        break;
                    case 1:
                        orderBy = "Job No";
                        break;
                    case 2:
                        orderBy = "Date of Accident";
                        break;
                    case 3:
                        orderBy = "TO Code";
                        break;
                    case 4:
                        orderBy = "ACR";
                        break;
                    case 7:
                        orderBy = "Claim Processing Branch";
                        break;
                    default:
                        orderBy = "Vehicle No";
                        break;
                }

                var sortDirection = Request["sSortDir_0"]; // asc or desc
                if (sortDirection == "asc")
                    orderBy = orderBy + " asc";
                else
                    orderBy = orderBy + " desc";

                #endregion

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    #region New

                    int? regionId;
                    int? branchId;
                    if (searchModel.RegionId == -1)
                        regionId = null;
                    else
                        regionId = searchModel.RegionId;

                    if (searchModel.BranchId == -1)
                        branchId = null;
                    else
                        branchId = searchModel.BranchId;

                    logerr.Error(LogPoint.Failure.ToString() + " , " + this.ControllerContext.Controller.ToString()
                        + ", Advanced Search Ajax Handler , DateFrom " + searchModel.DateFrom
                        + " DateTo " + searchModel.DateTo + " JobNo " + searchModel.JobNo + " VehicleNo " + searchModel.VehicleNo
                        + " CSRCode " + searchModel.CSRCode + " CSR Name " + searchModel.CSRName + " regionId " + regionId + " branchId " + branchId
                        + " EPF No " + searchModel.EPFNo + "orderby " + orderBy
                        + " displayStart " + param.iDisplayStart + " displayLength " + param.iDisplayLength);

                    var jobList = context.GetJobs(searchModel.DateFrom,
                                                    searchModel.DateTo,
                                                    (string.IsNullOrWhiteSpace(searchModel.JobNo)) ? null : searchModel.JobNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.VehicleNo)) ? null : searchModel.VehicleNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRCode)) ? null : searchModel.CSRCode.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRName)) ? null : searchModel.CSRName.Trim(),
                                                    regionId,
                                                    branchId,
                                                    (string.IsNullOrWhiteSpace(searchModel.EPFNo)) ? null : searchModel.EPFNo.Trim(),
                                                    orderBy,
                                                    param.iDisplayStart,
                                                    param.iDisplayLength).ToList();

                    /*to view in logs*/
                    logerr.Error(LogPoint.Failure.ToString() + " , " + this.ControllerContext.Controller.ToString()
                        + ", Advanced Search Ajax Handler , jobListCount " + jobList.Count());

                    /*to view in logs*/
                    logerr.Error(LogPoint.Failure.ToString() + " , " + this.ControllerContext.Controller.ToString()
                        + ", Advanced Search Ajax Handler , DateFrom " + searchModel.DateFrom
                        + " DateTo " + searchModel.DateTo + " JobNo " + searchModel.JobNo + " VehicleNo " + searchModel.VehicleNo
                        + " CSRCode " + searchModel.CSRCode + " CSR Name " + searchModel.CSRName + " regionId " + regionId + " branchId " + branchId + "orderby " + orderBy
                        + " EPFNo " + searchModel.EPFNo);

                    totalRecordCount = context.GetJobsCount(searchModel.DateFrom,
                                                    searchModel.DateTo,
                                                    (string.IsNullOrWhiteSpace(searchModel.JobNo)) ? null : searchModel.JobNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.VehicleNo)) ? null : searchModel.VehicleNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRCode)) ? null : searchModel.CSRCode.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRName)) ? null : searchModel.CSRName.Trim(),
                                                    regionId,
                                                    branchId,
                                                    (string.IsNullOrWhiteSpace(searchModel.EPFNo)) ? null : searchModel.EPFNo.Trim()
                                                   ).First().Value;
                    /*to view in logs*/
                    logerr.Error(LogPoint.Failure.ToString() + " , " + this.ControllerContext.Controller.ToString()
                        + ", Advanced Search Ajax Handler , totalRecordcount " + totalRecordCount);

                    #endregion

                    string tmp = "";
                    int i = 0;
                    //vw_SAForm_GeneralNew
                    foreach (GetJobs_Result job in jobList)
                    {
                        //Add to Mapper
                        String[] jobDetails = new String[10];
                        tmp = "<div id=\"" + i++ + "\" class=\"value\" style=\"display: none\">" + job.VisitId + "</div>" + "<div id=\"i" + i++ + "\" class=\"vehicleNoValue\">" + job.GEN_VehicleNo + "</div>";
                        jobDetails[0] = tmp;
                        jobDetails[1] = job.JobNo;
                        jobDetails[2] = job.GEN_Acc_Time.ToString(ApplicationSettings.GetDateOnlyFormat);
                        jobDetails[3] = job.Code;
                        jobDetails[4] = job.OTH_Approx_RepairCost.ToString(); //ACR
                        jobDetails[5] = (!job.IsOriginal) ? Resources.info_gen_y : Resources.info_gen_n; //SA Form Printed
                        jobDetails[6] = (job.ClaimFormImgCount > 0) ? Resources.info_gen_y : Resources.info_gen_n;//Claim Form Images
                        jobDetails[7] = job.ProcessingBranchName;
                        jobDetails[8] = job.PrintedBranch + "</br>" + ((job.PrintedDate == null) ? "" : job.PrintedDate.Value.ToString(ApplicationSettings.GetDateOnlyFormat));
                        jobDetails[9] = ApplicationSettings.JobMore_UIString;
                        jsonData.Add(jobDetails);
                    }
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Ajax Handler," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");
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
        /// <param name="searchModel"></param>
        /// <returns></returns>
        [Description("Advanced Search Result Print Preview")]
        public ActionResult AdvancedSearchResultPrintPreview(AdvancedSearch searchModel, JQueryDataTableParamModel param)
        {
            List<GetJobs_Result> data = null;
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Result Print Preview," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (searchModel != null && searchModel.RegionId != -1) searchModel.RegionName = (from r in context.RegionEntities where r.RegionId == searchModel.RegionId select r).FirstOrDefault().RegionName;

                    if (searchModel != null && searchModel.BranchId != -1) searchModel.BranchName = (from b in context.BranchEntities where b.BranchId == searchModel.BranchId select b).FirstOrDefault().BranchName;

                    int dataCount = GetJobsCount(searchModel, context);
                    data = GetJobs(dataCount, searchModel, context).ToList();
                    TempData["searchModel"] = searchModel;

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Result Print Preview," + User.Identity.Name + ",[Params=(Job No:" + searchModel.JobNo + ",Vehicle No:" + searchModel.VehicleNo + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString());
                }

                //Used for the footer
                ViewData["PrintUser"] = GetUser();
            }
            catch (GenException e)
            {
                ModelState.AddModelError("err", e);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Result Print Preview," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(600, Resources.err_600));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Advanced Search Result Print Preview," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
            }
            return GetFormatView("Job/PrintSearchResults.aspx", data);
        }

        #endregion

        #region Jobs Management

        /// <summary>
        /// 
        /// </summary>
        /// <param name="visitId"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("View SA Form Details")]
        public ActionResult GetJobDetailsAjaxHandler(int visitId, bool getImages = false)
        {
            JobDataModel model = null;
            List<vw_ImageGallery> visitImages = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_SAFormDetails view = context.vw_SAFormDetails.FirstOrDefault(x => x.VisitId == visitId);

                    if (view == null)
                        throw new GenException(605, Resources.err_605);

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        if (view.OTH_ProcessingBranchId != GetUserBranchId())
                            return RedirectToAction("NotAuthorized", "LogOn");
                    }

                    if (getImages)
                    {
                        //TODO: write sp
                        visitImages = (from i in context.vw_ImageGallery
                                       where i.VisitId == visitId
                                       select i).ToList();
                    }

                    model = new JobDataModel(view, visitImages);

                    if (GetFormat().ToUpper() == "XML")
                    {
                        //get Comments                     
                        model.GeneralModel.Comments = GetCommentsByVisitId(context, visitId).ToList().Select(x => new CommentModel(x)).ToList();
                        //Get Image Ids
                        model.GeneralModel.ImageIds = context.ImageGalleryEntities.Where(x => x.VisitId == visitId).Select(x => x.ImageId).ToArray();
                        model.GeneralModel.ReceivedImageCount = model.GeneralModel.ImageIds.Length;
                    }

                    // Get vehicle classes                    
                    //TODO: write sp
                    SAForm_level1Entity level1 = context.SAForm_level1Entity.Where(x => x.VisitId == visitId).FirstOrDefault();

                    if (level1.SAForm_VehicleClasses.Any())
                    {
                        model.VehDriverModel.VehicleClassIds = level1.SAForm_VehicleClasses.Select(x => x.VehicleClassId).ToArray();
                    }

                    if (view.VAD_License_IsNew != null)
                    {
                        model.VehDriverModel.VehicleClasses = SetVehicleClasses((bool)view.VAD_License_IsNew, model.VehDriverModel.VehicleClassIds);
                    }

                    //Audit log
                    auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");
            }
            return GetFormatView("Job/ViewJob.aspx", model);
        }

        [HttpPost]
        [Description("View SA Form Details")]
        public ActionResult UpdateJobDetailsAjaxHandler(int visitId, String jobNo, String vehNo, bool getImages = false)
        {
            JobDataModel model = null;
            List<vw_ImageGallery> visitImages = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    VisitEntity ventity = (from u in context.VisitEntities where u.VisitId == visitId select u).FirstOrDefault();
                    SAForm_level1Entity sentity = (from u in context.SAForm_level1Entity where u.VisitId == visitId select u).FirstOrDefault();
                    ventity.JobNo = jobNo;
                    sentity.GEN_VehicleNo = vehNo;




                    ventity.UpdatedBy = GetLoggedUserDetail().Id;
                    ventity.UpdatedDate = DateTime.Now;


                    int rows = context.SaveChanges();
                    //this.GetJobDetailsAjaxHandler(visitId);
                    vw_SAFormDetails view = context.vw_SAFormDetails.FirstOrDefault(x => x.VisitId == visitId);

                    if (view == null)
                        throw new GenException(605, Resources.err_605);

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        if (view.OTH_ProcessingBranchId != GetUserBranchId())
                            return RedirectToAction("NotAuthorized", "LogOn");
                    }

                    if (getImages)
                    {
                        visitImages = (from i in context.vw_ImageGallery
                                       where i.VisitId == visitId
                                       select i).ToList();
                    }

                    model = new JobDataModel(view, visitImages);

                    if (GetFormat().ToUpper() == "XML")
                    {
                        //get Comments                     
                        model.GeneralModel.Comments = GetCommentsByVisitId(context, visitId).ToList().Select(x => new CommentModel(x)).ToList();
                        //Get Image Ids
                        model.GeneralModel.ImageIds = context.ImageGalleryEntities.Where(x => x.VisitId == visitId).Select(x => x.ImageId).ToArray();
                        model.GeneralModel.ReceivedImageCount = model.GeneralModel.ImageIds.Length;
                    }

                    // Get vehicle classes
                    SAForm_level1Entity level1 = context.SAForm_level1Entity.Where(x => x.VisitId == visitId).FirstOrDefault();

                    if (level1.SAForm_VehicleClasses.Any())
                    {
                        model.VehDriverModel.VehicleClassIds = level1.SAForm_VehicleClasses.Select(x => x.VehicleClassId).ToArray();
                    }

                    if (view.VAD_License_IsNew != null)
                    {
                        model.VehDriverModel.VehicleClasses = SetVehicleClasses((bool)view.VAD_License_IsNew, model.VehDriverModel.VehicleClassIds);
                    }

                    //Audit log
                    auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Job Details Ajax Handler ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",get Images:" + getImages + ")]");
            }
            return GetFormatView("Job/ViewJob.aspx", model);
        }

        //update job

        /// <summary>
        /// 
        /// </summary>
        /// <param name="visitId"></param>
        /// <returns></returns>
        [Description("Job Details Print Preview")]
        public ActionResult JobDetailsPrintPreview(int visitId = 0, bool IsShowImages = true)
        {
            JobDataModel model = null;
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print Preview ," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_SAFormDetails view = context.vw_SAFormDetails.FirstOrDefault(x => x.VisitId == visitId);
                    List<vw_ImageGallery> SAImages = context.vw_ImageGallery.Where(x => x.VisitId == visitId).ToList();//view.VisitId

                    if (view == null)
                        throw new GenException(605, Resources.err_605);

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        if (view.OTH_ProcessingBranchId != GetUserBranchId())
                            return RedirectToAction("NotAuthorized", "LogOn");
                    }

                    model = new JobDataModel(view, SAImages);//added SAImages 20161215

                    // Get vehicle classes
                    SAForm_level1Entity level1 = context.SAForm_level1Entity.Where(x => x.VisitId == visitId).FirstOrDefault();

                    if (level1.SAForm_VehicleClasses.Any())
                    {
                        model.VehDriverModel.VehicleClassIds = level1.SAForm_VehicleClasses.Select(x => x.VehicleClassId).ToArray();
                    }

                    if (view.VAD_License_IsNew != null)
                    {
                        model.VehDriverModel.VehicleClasses = SetVehicleClasses((bool)view.VAD_License_IsNew, model.VehDriverModel.VehicleClassIds);
                    }

                    //Get Comments
                    model.GeneralModel.Comments = GetCommentsByVisitId(context, visitId).ToList().Select(x => new CommentModel(x)).ToList();

                    //List<vw_ImageGallery> visitImages = (from i in context.vw_ImageGallery
                    //                                     where i.VisitId == visitId
                    //                                     select i).ToList();

                    #region UpdateIsOriginalFlag
                    //var duplicatePrntPrvw = context.VisitEntities.Where(v => v.VisitId == visitId).ToList();

                    //foreach (var item in duplicatePrntPrvw)
                    //{
                    //    //After displaying Original Print preview, will be updated as Duplicate
                    //    //2017/05/15 Uthpala Pathirana
                    //    item.IsOriginal = false;
                    //    item.IsPrinted = true;
                    //}
                    //context.SaveChanges();

                    #endregion
                }

                //Used for the footer
                var user = GetUser();
                if (!(user.RoleName == "Technical Officer"))
                {
                    ViewData["PrintUser"] = user;
                }



                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print Preview ," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");
                auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logevt.Error(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print Preview ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logevt.Error(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print Preview ," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            ViewData["ShowImages"] = (IsShowImages) ? "True" : "False"; // added to show report without images for common user
            return GetFormatView("Job/PrintJob.aspx", model); // 20161215 changed from PrintJob.aspx 
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="items"></param>
        /// <returns></returns>
        [Description("Damaged Items")]
        public ActionResult DamagedItems(string items)
        {
            List<Models.Vehicle.Component> model = new List<Models.Vehicle.Component>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + ",[Params=(Items:" + items + ")]");

                model = ComponentManager.GetComponantTree(items);

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + ",[Params=(Items:" + items + ")]");
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Items:" + items + ")]");
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Items:" + items + ")]");
            }

            return GetFormatView("Shared/Job/DamagedItems.ascx", model);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="items"></param>
        /// <returns></returns>
        [Description("Possible DR")]
        [ValidateInput(false)]//To allow xml string as request param.
        public ActionResult PossibleDR(string xmlString)
        {
            List<Models.Vehicle.Component> model = new List<Models.Vehicle.Component>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + ",[Params=(Items:" + xmlString + ")]");

                model = ComponentManager.GetPossibleDR(xmlString);

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + ",[Params=(Items:" + xmlString + ")]");
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Items:" + xmlString + ")]");
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Damaged Items," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Items:" + xmlString + ")]");
            }

            return GetFormatView("Shared/Job/DamagedItems.ascx", model);
        }

        #region Tab

        /// <summary>Gets the input stream xml and adds the job to the DB</summary>
        ///<param>Request Input Stream XML</param>
        ///<returns>
        ///Returns the status of the action
        ///</returns>
        ///<exception cref="">
        ///XML incorrect format
        ///job number exists
        ///database errors
        /// </exception>        
        /// <remarks></remarks>     
        [Description("Add Job")]
        [HttpPost]
        public ActionResult AddJob()
        {
            VisitEntity entity = null; XmlDocument xmlDoc = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Job -Post," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                //Job can only be added by Android tablets
                if (!GetFormat().Equals("XML"))
                {
                    throw new GenException(620, Resources.err_620);
                }

                StreamReader reader = new StreamReader(Request.InputStream);
                String xmlData = reader.ReadToEnd();

                //check for input stream to convert it to the job xml
                if (String.IsNullOrEmpty(xmlData))
                {
                    throw new GenException(954, Resources.err_954);
                }
                xmlDoc = new XmlDocument();

                try
                {
                    xmlDoc.LoadXml(xmlData);
                }
                catch (Exception)
                {
                    //Request xml not in the correct format
                    throw new GenException(955, Resources.err_955);
                }

                //Converting XML data to job entity object  
                //sample "add job xml" can be found at SampleXml\Jobs\AddJobRequest.xml
                entity = ToVisitEntity(xmlDoc, true);

                if (entity == null)
                {
                    throw new GenException(621, Resources.err_621);
                }

                //check whether the job number is unique
                if (!IsJobNumberUnique(entity.JobNo))
                {
                    throw new GenException(622, Resources.err_622);
                }

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //save to database.
                    context.AddToVisitEntities(entity);
                    context.SaveChanges();
                    ViewData["VisitId"] = entity.VisitId;

                    //send email on success if no images are attached
                    //Otherwise email will be sent after all the images get received. Check "ImageController/UploadImage"
                    if (entity.ImageCount == 0)
                    {
                        SendVisitEmail(entity, false);
                    }

                    //logged on success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Job -Post," + User.Identity.Name + ",[Params=(Visit Id" + entity.VisitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), entity.VisitId, GetJobParamsString(entity.VisitId));
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                //TODO: Log to db
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Job -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (XmlException ex)
            {
                ModelState.AddModelError("err", new GenException(621, Resources.err_621));
                //TODO: Log to db
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Job -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                //TODO: Log to db
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Job -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(623, Resources.err_623));
                //TODO: Log to db
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Job -Post," + User.Identity.Name + ",Exception Message:" + ex.Message + ",Inner Exception:" + ex.InnerException + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("Job/AddJob.aspx");
        }


        /// <summary>Gets the job list with visits (if exists) related to a vehicle number or job number.</summary>
        /// <param name="VehNo">Vehicle Number or Job Number string</param>
        ///<returns>
        ///List of Job Numbers with Visits if Exists
        ///</returns>
        ///<exception cref="">
        ///search string cannot be null or empty
        ///no jobs found
        ///database errors
        /// </exception>        
        /// <remarks></remarks>
        [Description("Search By Vehicle No")]
        public ActionResult SearchByVehicleNo(string searchText)
        {
            List<GroupedVisitsModel> visits = new List<GroupedVisitsModel>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search By Vehicle No," + User.Identity.Name + ",[Params=(Search Text:" + searchText + ")]");

                //check if parameter is valid
                if (String.IsNullOrEmpty(searchText))
                {
                    throw new GenException(625, Resources.err_625);
                }

                //vehicle numbers are saved to uppercase in database
                visits = SearchVisits(searchText.ToUpper());

                //logged on success
                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search By Vehicle No," + User.Identity.Name + ",[Params=(Search Text:" + searchText + ")]");
                auditLogger.AddEvent(LogPoint.Success.ToString());

                return GetFormatView("Job/SearchJobs.aspx", visits);

            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search By Vehicle No," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Search Text:" + searchText + ")]");
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search By Vehicle No," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Search Text:" + searchText + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(624, Resources.err_624));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Search By Vehicle No," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Search String:" + searchText + ")]");
            }

            return GetFormatView("Job/SearchJobs.aspx", visits);
        }

        #endregion

        #endregion

        #region Visits Management

        /// <summary>
        /// 
        /// </summary>
        /// <param name="param"></param>
        /// <param name="jobNo"></param>
        /// <returns></returns>
        [Description("Get Visits Of Jobs Ajax Handler")]
        public ActionResult GetVisitsOfJobsAjaxHandler(JQueryDataTableParamModel param, string jobNo)
        {
            int totalCount = 0;
            List<String[]> jsonData = new List<string[]>();

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visits Of Jobs Ajax Handler," + User.Identity.Name + ",[Params=(Job No:" + jobNo + ")]");

                List<VisitModel> visits = this.GetJobVisits(jobNo, param.iDisplayStart, param.iDisplayLength);
                var user = GetUser();
                int i = 0;
                foreach (VisitModel visit in visits)
                {
                    String[] visitDetails = new String[5];

                    visitDetails[0] = "<div id=\"" + i++ + "\" class=\"value\" style=\"display: none\">" + visit.VisitId + "</div>" + "<div id=\"i" + i++ + "\" class=\"visitNoValue\">" + visit.VisitNo.ToString() + "</div>";
                    visitDetails[1] = EnumUtils.stringValueOf(typeof(VisitType), visit.VisitType.ToString());
                    visitDetails[2] = visit.VisitedDate.ToString(ApplicationSettings.GetDateTimeFormat);
                    visitDetails[3] = visit.Code;
                    if (user.RoleName == "Common User")
                        visitDetails[4] = ApplicationSettings.VisitMoreExternal_UIString;
                    else
                        visitDetails[4] = ApplicationSettings.VisitMore_UIString;

                    //visitDetails[5] = visit.VisitId.ToString();

                    jsonData.Add(visitDetails);
                }
         
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    totalCount = (from v in context.vw_Visits
                                  where v.JobNo == jobNo
                                  select v).OrderBy(v => v.VisitId).Count();
                }
                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visits Of Jobs Ajax Handler," + User.Identity.Name + ",[Params=(Job No:" + jobNo + ")]");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visits Of Jobs Ajax Handler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(601, Resources.err_601));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visits Of Jobs Ajax Handler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + ")]");
            }

            var data = Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = totalCount,
                iTotalDisplayRecords = totalCount,
                aaData = jsonData
            }, JsonRequestBehavior.AllowGet);
           
            return data;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="jobNo"></param>
        /// <returns></returns>
        [Description("Job Visit Result Print Preview")]
        public ActionResult JobVisitResultPrintPreview(string jobNo)
        {
            //log on entry here
            List<VisitModel> visitList = new List<VisitModel>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Visit Result Print Preview," + User.Identity.Name + ",[Params=(Job No:" + jobNo + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<vw_Visits> visits = (from v in context.vw_Visits
                                              where v.JobNo == jobNo
                                              select v).OrderBy(v => v.VisitId).ToList();

                    int inc = 1;
                    foreach (vw_Visits t in visits)
                    {
                        VisitModel vdm = new VisitModel(t);
                        vdm.VisitNo = inc++;
                        visitList.Add(vdm);
                    }

                    if (visitList.Count > 0)
                    {
                        auditLogger.AddEvent(LogPoint.Success.ToString(), GetJobParamsString(visitList[0].VisitId));
                    }
                }

                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Visit Result Print Preview," + User.Identity.Name + ",[Params=(Job No:" + jobNo + ")]");

                //Used for the print footer
                var user = GetUser();
                if (!(user.RoleName == "Technical Officer"))
                {
                    ViewData["PrintUser"] = user;
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Visit Result Print Preview," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(601, Resources.err_601));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Visit Result Print Preview," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + ")]");
            }
            return GetFormatView("Job/PrintJobVisitDetails.aspx", visitList);
        }

        /// <summary>
        /// get details of a visit when given the visit id
        /// </summary>
        /// <param name="visitId"></param>
        /// <returns></returns>        
        [HttpPost]
        [Description("View Visit Details")]
        public ActionResult GetVisitDetailsAjaxHandler(int visitId, bool getImages = false)
        {
            VisitDetailModel model = null;
            List<vw_ImageGallery> visitImages = null;
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visit Details AjaxHandler," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_VisitDetails view = context.vw_VisitDetails.FirstOrDefault(x => x.VisitId == visitId);

                    if (view == null)
                        throw new GenException(607, Resources.err_607);

                    if (getImages)
                    {
                        visitImages = (from i in context.vw_ImageGallery
                                       where i.VisitId == visitId
                                       select i).ToList();
                    }

                    model = new VisitDetailModel(view, visitImages);

                    if (GetFormat().ToUpper() == "XML")
                    {
                        //get Comments                     
                        model.Comments = GetCommentsByVisitId(context, visitId).ToList().Select(x => new CommentModel(x)).ToList();
                        //Get Image Ids
                        model.ImageIds = context.ImageGalleryEntities.Where(x => x.VisitId == visitId).Select(x => x.ImageId).ToArray();
                        model.ReceivedImageCount = model.ImageIds.Length;
                    }
                }

                //Audit log
                auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visit Details AjaxHandler," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visit Details AjaxHandler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(608, Resources.err_608));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Visit Details AjaxHandler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            return GetFormatView("Job/ViewVisit.aspx", model);
        }

        /// <summary>
        /// get details of a visit for print when given the visit id
        /// </summary>
        /// <param name="visitId"></param>
        /// <returns></returns>
        [Description("Visit Details Print Preview")]
        public ActionResult VisitDetailsPrintPreview(int visitId = 1, bool IsShowImages = true)
        {
            VisitDetailModel model = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Visit Details Print-Preview," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    vw_VisitDetails view = context.vw_VisitDetails.FirstOrDefault(x => x.VisitId == visitId);
                    if (view == null)
                        throw new GenException(607, Resources.err_607);

                    List<vw_ImageGallery> SAImages = context.vw_ImageGallery.Where(x => x.VisitId == visitId).ToList();//view.VisitId
                    model = new VisitDetailModel(view, SAImages);

                    //Get Comments
                    model.Comments = GetCommentsByVisitId(context, visitId).ToList().Select(x => new CommentModel(x)).ToList();
                }

                //Used for the footer
                ViewData["PrintUser"] = GetUser();

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Visit Details Print-Preview," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");
                auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Visit Details Print-Preview," + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(608, Resources.err_608));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Visit Details Print-Preview," + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            ViewData["ShowImages"] = (IsShowImages) ? "True" : "False";
            return GetFormatView("Job/PrintVisit.aspx", model);
        }

        #region Tab

        /// <summary>Gets the input stream xml and resubmits the job to the DB</summary>        
        ///<param name="job">JobModel</param>
        ///<param>Request Input Stream XML</param>
        ///<returns>
        ///Returns the status of the action
        ///</returns>
        ///<exception cref="">
        ///XML incorrect format
        ///job number exists
        ///database errors
        /// </exception>        
        /// <remarks></remarks>     
        [Description("Add Visit")]
        [HttpPost]
        public ActionResult AddVisit()
        {
            VisitEntity entity = null; //Job jobEntity = null;
            XmlDocument xmlDoc = null;

            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post," + User.Identity.Name + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                // Check from where the action is called from
                if (!GetFormat().Equals("XML"))
                {
                    //Visit can only be resubmitted by tablets
                    throw new GenException(626, Resources.err_626);
                }

                StreamReader reader = new StreamReader(Request.InputStream);
                String xmlData = reader.ReadToEnd();

                //check for input stream to convert it to the job xml
                if (String.IsNullOrEmpty(xmlData))
                {
                    throw new GenException(954, Resources.err_954);
                }
                xmlDoc = new XmlDocument();

                try
                {
                    xmlDoc.LoadXml(xmlData);
                }
                catch (Exception)
                {
                    //Request xml not in the correct format
                    throw new GenException(955, Resources.err_955);
                }

                //Check for resubmission tag
                try
                {
                    string action = xmlDoc.SelectSingleNode("/Request/Data/Job/@action").Value;

                    if (!String.Equals("visit", action, StringComparison.OrdinalIgnoreCase))
                    {
                        throw new GenException(627, Resources.err_627);
                    }
                }
                catch (GenException)
                {
                    throw;
                }
                catch (Exception)
                {
                    throw new GenException(628, Resources.err_628);
                }

                //Converting XML data to resubmission job entity object  
                //sample "add job xml" can be found at SampleXml\Jobs\ResubmitJobRequest.xml               
                entity = ToVisitEntity(xmlDoc, false);

                if (entity == null)
                {
                    throw new GenException(629, Resources.err_629);
                }

                if (!entity.Comments.Any() && entity.ImageCount == 0)
                {
                    throw new GenException(630, Resources.err_630);
                }

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //save to databse.
                    context.AddToVisitEntities(entity);
                    context.SaveChanges();

                    ViewData["VisitId"] = entity.VisitId;
                    //send email on success if no images are attached
                    //Otherwise email will be sent after all the images get received. Check "ImageController/UploadImage"

                    if (entity.ImageCount == 0)
                    {
                        try
                        {
                            SendVisitEmail(entity, false);
                        }
                        catch (Exception ex)
                        {
                            logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post (Email Sending)," + User.Identity.Name + "," + ex.Message + ",[Params=(Visit Id:" + entity.VisitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                        }
                    }

                    //logged on success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post," + User.Identity.Name + ",[Params=(Visit Id:" + entity.VisitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), entity.VisitId, GetJobParamsString(entity.VisitId));
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (XmlException ex)
            {
                ModelState.AddModelError("err", new GenException(629, Resources.err_629));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(631, Resources.err_631));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Add Visit -Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }

            return GetFormatView("Job/AddJob.aspx");
        }

        #endregion

        #endregion

        #region Comments Management

        /// <summary>
        /// 
        /// </summary>
        /// <param name="param"></param>
        /// <param name="visitId"></param>
        /// <returns></returns>
        [Description("Comments List Ajax Handler")]
        public ActionResult CommentsListAjaxHandler(JQueryDataTableParamModel param, string visitId)
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                if (!User.Identity.IsAuthenticated)
                {
                    return RedirectToAction("LogOn", "LogOn");
                }

                //Optionally check whether the columns are searchable at all
                var isCommentedDateSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
                var isCommentedBySearchable = Convert.ToBoolean(Request["bSearchable_1"]);
                var isCommentSearchable = Convert.ToBoolean(Request["bSearchable_2"]);

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int visitIdNo = int.Parse(visitId);
                    IQueryable<vw_Comments> comments = GetCommentsByVisitId(context, visitIdNo);

                    #region Searching Section

                    if (!String.IsNullOrEmpty(param.sSearch))
                    {
                        comments =
                            comments.Where(u => isCommentedBySearchable && u.CommentedBy.Contains(param.sSearch.ToLower())
                                                ||
                                                isCommentSearchable && u.Comment.ToLower().Contains(param.sSearch.ToLower()));
                    }

                    #endregion

                    #region Sorting Section
                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    Func<vw_Comments, object> orderingFunction;
                    switch (sortColumnIndex)
                    {
                        case 0:
                            orderingFunction = (c => c.CommentedDate);
                            break;
                        case 1:
                            orderingFunction = (c => c.CommentedBy);
                            break;
                        case 2:
                            orderingFunction = (c => c.Comment);
                            break;
                        default:
                            orderingFunction = (c => c.CommentedDate);
                            break;
                    }

                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (sortDirection == "asc")
                        comments = comments.OrderBy(orderingFunction).AsQueryable();
                    else
                        comments = comments.OrderByDescending(orderingFunction).AsQueryable();
                    #endregion

                    totalRecordCount = comments.Count();
                    comments = comments.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (vw_Comments cm in comments)
                    {
                        //Add to Mapper
                        String[] comDetails = new String[3];
                        comDetails[0] = cm.CommentedDate.ToString(ApplicationSettings.GetDateTimeFormat);
                        comDetails[1] = cm.CommentedBy;
                        comDetails[2] = cm.Comment;

                        jsonData.Add(comDetails);
                    }
                }

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(111, ex.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
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
        /// <param name="visitId"> </param>
        /// <param name="comment"></param>
        /// <returns></returns>       
        [HttpPost]
        [Description("Create Comment")]
        public JsonResult CreateComment(int visitId, string comment)
        {
            string msgSend;
            int codeSend;
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Comment," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (String.IsNullOrEmpty(comment))
                    {
                        throw new GenException(671, Resources.err_671);
                    }

                    //Avoid using this characters as converting to xml throws error
                    if (comment.Contains('<') || comment.Contains('>') || comment.Contains('&'))
                    {
                        throw new GenException(955, Resources.err_955);
                    }

                    if (comment.Trim().Length > Int32.Parse(ConfigurationManager.AppSettings["commentLength"].ToString()))
                    {
                        throw new GenException(678, "Please enter less than " + ConfigurationManager.AppSettings["commentLength"].ToString() + " characters.");
                    }

                    CommentEntity entity = new CommentEntity();
                    entity.CommentedBy = GetLoggedUserDetail().Id;
                    entity.VisitId = visitId;
                    entity.Comment1 = comment.Trim();// HttpUtility.HtmlEncode(comment.Trim());
                    entity.CommentedDate = DateTime.Now;
                    context.AddToCommentEntities(entity);
                    context.SaveChanges();

                    //log for Success
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Comment," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ")]");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));

                    msgSend = Resources.info_success_createComment;
                    codeSend = 0;
                }
            }
            catch (GenException ex)
            {
                msgSend = ex.Message;
                codeSend = -1;

                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Comment," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            catch (Exception ex)
            {
                msgSend = Resources.err_672;
                codeSend = -1;

                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Create Comment," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ")]");
            }
            return Json(new
            {
                msg = msgSend,
                code = codeSend
            },
           JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="param"></param>
        /// <param name="jobNo"></param>
        /// <returns></returns>
        [Description("Comments List Ajax Handler 2")]
        public ActionResult CommentsListAjaxHandler2(JQueryDataTableParamModel param, string jobNo)
        {
            int totalRecordCount = 0;
            List<String[]> jsonData = new List<string[]>();
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler2," + User.Identity.Name + ",[Params=(Job No:" + jobNo + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

                if (!User.Identity.IsAuthenticated)
                {
                    return RedirectToAction("LogOn", "LogOn");
                }

                //Optionally check whether the columns are searchable at all
                var isCommentedDateSearchable = Convert.ToBoolean(Request["bSearchable_0"]);
                var isCommentedBySearchable = Convert.ToBoolean(Request["bSearchable_1"]);
                var isCommentSearchable = Convert.ToBoolean(Request["bSearchable_2"]);

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //int JNO = int.Parse(jobNo);
                    IQueryable<vw_AllComments> comments = (from u in context.vw_AllComments
                                                           where u.JobNo == jobNo
                                                           select u);

                    #region Searching Section

                    if (!String.IsNullOrEmpty(param.sSearch))
                    {
                        comments =
                            comments.Where(u => isCommentedBySearchable && u.CommentedBy.Contains(param.sSearch.ToLower())
                                                ||
                                                isCommentSearchable && u.Comment.ToLower().Contains(param.sSearch.ToLower()));
                    }

                    #endregion

                    #region Sorting Section
                    var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
                    Func<vw_AllComments, object> orderingFunction;
                    switch (sortColumnIndex)
                    {
                        case 0:
                            orderingFunction = (c => c.VisitType);
                            break;
                        case 1:
                            orderingFunction = (c => c.CommentedBy);
                            break;
                        case 2:
                            orderingFunction = (c => c.Comment);
                            break;
                        default:
                            orderingFunction = (c => c.VisitType);
                            break;
                    }

                    var sortDirection = Request["sSortDir_0"]; // asc or desc
                    if (sortDirection == "asc")
                        comments = comments.OrderBy(orderingFunction).AsQueryable();
                    else
                        comments = comments.OrderByDescending(orderingFunction).AsQueryable();
                    #endregion

                    totalRecordCount = comments.Count();
                    comments = comments.Skip(param.iDisplayStart).Take(param.iDisplayLength);

                    foreach (vw_AllComments cm in comments)
                    {
                        //Add to Mapper
                        String[] comDetails = new String[4];
                        comDetails[0] = EnumUtils.stringValueOf(typeof(VisitType), cm.VisitType.ToString());
                        comDetails[1] = cm.CommentedDate.ToString(ApplicationSettings.GetDateTimeFormat);
                        comDetails[2] = cm.CommentedBy;
                        comDetails[3] = cm.Comment;

                        jsonData.Add(comDetails);
                    }
                }
                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler2," + User.Identity.Name + ",[Params=(Job No:" + jobNo + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler2," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(99, ex.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Comments List AjaxHandler2," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + "Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
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
        /// <param name="param"></param>
        /// <param name="jobNo"></param>
        /// <returns></returns>
        [Description("Get Comments By Job Number")]
        [HttpPost]
        public ActionResult GetCommentsByJobNo(string jobNo)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Comments By Job Number," + User.Identity.Name + ",[Params=(Job No:" + jobNo + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //int JNO = int.Parse(jobNo);
                    IQueryable<vw_AllComments> commentsView = (from u in context.vw_AllComments
                                                               where u.JobNo == jobNo
                                                               select u);

                    List<CommentModel> allComments = commentsView.AsEnumerable().Select(x => new CommentModel(x)).ToList();

                    List<VisitModel> groupedVisits = (from p in allComments
                                                      group p by p.VisitId into grps
                                                      select new
                                                      {
                                                          Key = grps.Key,
                                                          Comments = grps.Distinct()
                                                      }).Select(x => new VisitModel { VisitId = x.Key, VisitType = x.Comments.Where(y => y.VisitId == x.Key).Select(y => y.VisitType).FirstOrDefault(), VisitedDate = x.Comments.Where(y => y.VisitId == x.Key).Select(y => y.VisitDate).FirstOrDefault(), Comments = x.Comments.ToList() }).ToList();

                    if (allComments.Count <= 0)
                    {
                        throw new GenException(673, Resources.err_673);
                    }

                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Comments By Job Number," + User.Identity.Name + ",[Params=(Job No:" + jobNo + ")]");

                    return GetFormatView("Job/ViewComments.aspx", groupedVisits);
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Comments By Job Number," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(674, Resources.err_674));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Comments By Job Number," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Job No:" + jobNo + ")]");
            }
            return GetFormatView("Job/ViewComments.aspx");
        }

        [Description("Get Comments By Visit Id")]
        public IQueryable<vw_Comments> GetCommentsByVisitId(MotorClaimEntities context, int visitId)
        {
            try
            {
                IQueryable<vw_Comments> comments = (from u in context.vw_Comments
                                                    where u.VisitId == visitId
                                                    select u);

                return comments;
            }
            catch (Exception)
            {
                throw;
            }
        }
        #endregion

        #region ImageGallery

        /// <summary>
        /// </summary>
        /// <param name="imageType"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Get Image Ids")]
        public virtual JsonResult GetImageIds(int visitId, int imageType)
        {
            try
            {
                //TODO!!!!- Combine GetImageIds() and GetImage() into One Single Method!
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    int[] arr = context.ImageGalleryEntities.Where(x => x.VisitId == visitId && x.FieldId == imageType).Select(x => x.ImageId).ToArray();

                    return Json(arr);
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        /// <summary>
        /// </summary>
        /// <param name="imageId"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Get Image")]
        public virtual JsonResult GetImage(int imageId)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    string imagePath = context.ImageGalleryEntities.FirstOrDefault(x => x.ImageId == imageId).ImagePath;
                    var filePath = ApplicationSettings.ImageGalleryPath + imagePath;
                    return Json(filePath);
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }

        ///ImageUpload Action Method        
        ///<returns>
        /// to ImageUploadView
        ///</returns>       
        ///<exception cref="">
        ///JobNo not found
        ///Please upload a file.
        ///image name cant be empty
        ///Field cant be empty
        ///Please upload a Image
        ///Error occurred while connecting to the database.Please try again later
        /// </exception>
        /// <remarks>this method uploads the images to a folder and save those data in database table</remarks>
        [Description("Upload Image")]
        public virtual ActionResult UploadImage()
        {
            XmlDocument xmlDoc = null;
            HttpPostedFileBase imageFile = null;
            int visitId;
            logevt.Info("UploadImage entered");

            try
            {
                //log.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name);
                if (Request.Files.Count != 2)
                {
                    throw new GenException(850, Resources.err_850_sys);
                }
                logevt.Info("2 files found");

                #region Read Files

                //Fetch and process Request Files
                foreach (string file in Request.Files)
                {
                    var imageXmlFile = Request.Files[file] as HttpPostedFileBase;

                    if (file.Equals("ImageData"))
                    {
                        XmlTextReader reader = new XmlTextReader(imageXmlFile.InputStream);
                        reader.WhitespaceHandling = WhitespaceHandling.None;
                        try
                        {
                            xmlDoc = new XmlDocument();
                            xmlDoc.Load(reader);
                            logevt.Info("XML file :" + xmlDoc.InnerXml);
                        }
                        catch (Exception)
                        {
                            throw new GenException(851, Resources.err_851);
                        }
                        //Close off the connection to the file.
                        reader.Close();
                    }
                    else if (file.Equals("Image"))
                    {
                        imageFile = Request.Files[file] as HttpPostedFileBase;
                        logevt.Info("Image file :" + imageFile.FileName);
                    }
                }

                if (xmlDoc == null)
                {
                    throw new GenException(852, Resources.err_852);
                }

                #endregion

                logevt.Info("XML node data");

                //Process XML File
                XmlNode imgNode = xmlDoc.SelectSingleNode("Request/Data/Image/FieldList");
                try
                {
                    visitId = int.Parse(imgNode.SelectSingleNode("visitId").InnerText); ;
                    logevt.Info("visit Id:" + visitId);
                }
                catch (Exception)
                {
                    throw new GenException(853, Resources.err_853);
                }

                string imageName = imgNode.SelectSingleNode("imageName").InnerText; ;
                logevt.Info("Image Name:" + imageName);
                string field = imgNode.SelectSingleNode("imageType").InnerText;//3-"AccidentImages";
                logevt.Info("Image type:" + field);

                #region remove
                /* XmlNode submissionNode = imgNode.SelectSingleNode("isResubmission");

                try
                {
                    if (submissionNode != null && bool.Parse(submissionNode.InnerText))
                    {
                        isReSubmission = true;
                        try
                        {
                            refNo = int.Parse(imgNode.SelectSingleNode("refNo").InnerText);
                        }
                        catch (Exception)
                        {
                            throw new GenException(808, "Invalid image reference no.");
                        }
                    }
                    else
                    {
                        isReSubmission = false;
                    }
                }
                catch (Exception e)
                {
                    //log.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + e.Message);
                }*/
                #endregion

                #region Validations

                //Process Image File

                if (imageFile.ContentLength == 0)
                {
                    logevt.Info("Image content:" + imageFile.ContentLength);
                    throw new GenException(854, Resources.err_854);
                }
                if (string.IsNullOrEmpty(imageName))
                {
                    throw new GenException(855, Resources.err_855);
                }
                if (string.IsNullOrEmpty(field))
                {
                    throw new GenException(856, Resources.err_856);
                }

                byte imageTypeId;
                if (!Byte.TryParse(field, out imageTypeId))
                {
                    throw new GenException(857, Resources.err_857);
                }

                //process field id enum
                string imageType = Enum.GetName(typeof(ImageType), imageTypeId);
                logevt.Info("Image type name:" + imageType);
                if (string.IsNullOrEmpty(imageType))
                {
                    throw new GenException(857, Resources.err_857);
                }

                #endregion

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    VisitEntity entity = (from v in context.VisitEntities where v.VisitId == visitId select v).FirstOrDefault();

                    if (entity == null)
                    {
                        throw new GenException(858, Resources.err_858);
                    }
                    logevt.Info("Entity Job No:" + entity.JobNo);

                    #region Save & add to Database
                    ImageGalleryEntity uploadedImg = this.SaveImage(imageFile, entity.JobNo, visitId, imageType);
                    uploadedImg.VisitId = visitId;
                    uploadedImg.FieldId = imageTypeId;
                    //uploadedImg.Title = fieldName + " | " + imageName;
                    uploadedImg.IsPrinted = false;
                    uploadedImg.UploadedDate = DateTime.Now;
                    logevt.Info("Before saved to DB");
                    context.AddToImageGalleryEntities(uploadedImg);
                    context.SaveChanges(); logevt.Info("Saved to DB " + uploadedImg.ImageId);
                    ViewData["ImageId"] = uploadedImg.ImageId;

                    #endregion

                    #region Send email
                    if (entity.ImageGalleries != null && (entity.ImageGalleries.Count == entity.ImageCount))
                    {
                        logevt.Info("Send Email Started");
                        try
                        {
                            SendVisitEmail(entity, true);
                            //logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + "Email sending started");
                        }
                        catch (Exception e)
                        {
                            //logevt.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image - Send Email," + User.Identity.Name + "," + e.Message);
                        }
                    }

                    #endregion

                    logevt.Info("All  Success");
                    auditLogger.AddEvent(LogPoint.Success.ToString(), uploadedImg.ImageId, GetJobParamsString(visitId));
                }
            }
            catch (GenException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                ModelState.AddModelError("err", ex);
            }
            catch (XmlException e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                ModelState.AddModelError("err", new GenException(711, "Error in xml data"));
            }
            catch (IOException e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                ModelState.AddModelError("err", new GenException(712, "File Path not Accessible"));
            }
            catch (SqlException ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
                ModelState.AddModelError("err", new GenException(713, "Error occurred while connecting to the database. Please try again later"));
            }
            catch (Exception e)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace);
                ModelState.AddModelError("err", new GenException(714, e.ToString()));
            }

            return GetFormatView("Image/ImageUpload.aspx");
        }

        [Description("Save Image")]
        private ImageGalleryEntity SaveImage(HttpPostedFileBase imageFile, string jobNo, int visitId, string imageType)
        {
            try
            {
                if (imageFile == null)
                {
                    throw new GenException(708, "Image not found.");
                }

                string commonFolderPath = "ImageGallery\\" + jobNo + "\\Visit_" + visitId + "\\" + imageType;

                string dateTimeStamp = String.Format("{0:MM_dd_yyyy_HH-mm-ss}", DateTime.Now);
                string newImageName = jobNo + "_" + dateTimeStamp + "_" + imageType + "_" + Path.GetFileName(imageFile.FileName);

                string dbImagepath = commonFolderPath + "\\" + newImageName;
                logevt.Info("DB path:" + dbImagepath);
                FileManager.CreateFolder(ApplicationSettings.ImageGalleryPath + commonFolderPath);
                logevt.Info(LogPoint.Success.ToString() + ",Folders created at:" + ApplicationSettings.ImageGalleryPath + commonFolderPath);

                string imageFullPath = ApplicationSettings.ImageGalleryPath + dbImagepath;

                if (System.IO.File.Exists(imageFullPath))
                {
                    throw new GenException(859, Resources.err_859);
                }

                imageFile.SaveAs(imageFullPath);
                logevt.Info("Image Saved");
                //logged on success of file upload 
                //log.Info(LogPoint.FileUploaded.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Upload Image," + jobNo + User.Identity.Name + ",File Name:" + imageFullPath);
                auditLogger.AddEvent(LogPoint.FileUploaded.ToString(), visitId, GetJobParamsString(visitId));

                return new ImageGalleryEntity() { ImageName = newImageName, ImagePath = dbImagepath, Title = newImageName };
            }
            catch (Exception)
            {
                return null;
            }
        }

        ///GetImageById Action Method        
        ///<returns>
        /// to Retrieve images
        ///</returns>       
        ///<exception cref="">        
        ///imageID cant be empty
        ///Error occurred while connecting to the database.Please try again later
        /// </exception>
        /// <remarks>this method get the image ids as a list and send them as response</remarks>
        [Description("Get Image By Id")]
        public virtual ActionResult GetImageById(int imageID)
        {
            try
            {
                logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + ",[Params=(Image Id:" + imageID + ", User Agent:" + Request.UserAgent + ")]");

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    if (imageID == null || imageID == 0)
                    {
                        throw new GenException(866, Resources.err_866);
                    }

                    vw_ImageGallery view = (from g in context.vw_ImageGallery
                                            where g.ImageId == imageID
                                            select g).FirstOrDefault();
                    if (view == null)
                    {
                        throw new GenException(860, Resources.err_860);
                    }
                    if (string.IsNullOrEmpty(view.ImagePath))
                    {
                        throw new GenException(861, Resources.err_861);
                    }

                    string filePath = ApplicationSettings.ImageGalleryPath;
                    if (string.IsNullOrEmpty(filePath))
                    {
                        throw new GenException(862, Resources.err_862_sys);
                    }

                    filePath += view.ImagePath;

                    if (!System.IO.File.Exists(filePath))
                    {
                        throw new GenException(863, Resources.err_863);
                    }

                    System.Drawing.Image img = System.Drawing.Image.FromFile(filePath, true);
                    img.Save(Response.OutputStream, img.RawFormat);
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + ",[Params=(Image Id:" + imageID + ", User Agent:" + Request.UserAgent + ")]");
                }
            }
            catch (ArgumentException e)
            {
                ModelState.AddModelError("err", new GenException(865, Resources.err_865));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Image Id:" + imageID + ")]");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Image Id:" + imageID + ")]");
            }
            catch (IOException e)
            {
                ModelState.AddModelError("err", new GenException(864, Resources.err_864));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Image Id:" + imageID + ")]");
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Image Id:" + imageID + ")]");
            }
            catch (Exception e)
            {
                ModelState.AddModelError("err", new GenException(865, Resources.err_865));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Get Image By Id," + User.Identity.Name + "," + e.Message + ",Stack Trace:" + e.StackTrace + ",[Params=(Image Id:" + imageID + ")]");
            }

            // return null;
            return GetFormatView("Image/ImageUpload.aspx");
        }

        #endregion

        #region Common

        /// <summary>
        /// 
        /// </summary>
        /// <param name="regionId"></param>
        /// <returns></returns>
        [HttpPost]
        [Description("Find Branches By Region Id")]
        public JsonResult FindBranchesByRegionId(int regionId, bool isClaimProcessed = false)
        {
            try
            {
                List<BranchDataModel> branches = new List<BranchDataModel>();

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<BranchEntity> query = from b in context.BranchEntities
                                                      where b.RegionId == regionId
                                                      && !b.IsDeleted && b.IsEnabled
                                                      select b;

                    if (isClaimProcessed)
                    {
                        query = query.Where(x => x.IsClaimProcessed == true);
                    }

                    branches = (from b in query
                                orderby b.BranchName
                                select new BranchDataModel
                                {
                                    BranchName = b.BranchName,
                                    RegionId = b.RegionId,
                                    BranchId = b.BranchId
                                }).ToList();
                }
                JsonResult result = new JsonResult { JsonRequestBehavior = JsonRequestBehavior.AllowGet };

                result.Data = branches;

                return result;
            }
            catch (Exception ex)
            {
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On FindBranchesByRegionId," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);

                return new JsonResult
                {
                    Data = Resources.err_901
                };
            }
        }

        #endregion

        #region Print

        [Description("Job Full Print Preview")]
        public ActionResult JobFullPrintPreview(string jobNo)
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview,");

            JobContainer model = new JobContainer();
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //Get SA Form
                    vw_SAFormDetails view = context.vw_SAFormDetails.FirstOrDefault(x => x.JobNo == jobNo);
                    List<vw_ImageGallery> SAImages = context.vw_ImageGallery.Where(x => x.VisitId == view.VisitId).ToList();


                    model.SAForm = new JobDataModel(view, SAImages);

                    // Get vehicle classes for SA Form
                    SAForm_level1Entity level1 = context.SAForm_level1Entity.Where(x => x.VisitId == view.VisitId).FirstOrDefault();

                    if (level1.SAForm_VehicleClasses.Any())
                    {
                        model.SAForm.VehDriverModel.VehicleClassIds = level1.SAForm_VehicleClasses.Select(x => x.VehicleClassId).ToArray();
                    }

                    if (view.VAD_License_IsNew != null)
                    {
                        model.SAForm.VehDriverModel.VehicleClasses = SetVehicleClasses((bool)view.VAD_License_IsNew, model.SAForm.VehDriverModel.VehicleClassIds);
                    }

                    //Get Comments for SA Form
                    model.SAForm.GeneralModel.Comments = GetCommentsByVisitId(context, view.VisitId).ToList().Select(x => new CommentModel(x)).ToList();

                    //Get Visits
                    List<vw_VisitDetails> visitsView = context.vw_VisitDetails.Where(x => x.JobNo == jobNo).ToList();

                    if (visitsView.Count > 0)
                    {
                        int[] visitIds = visitsView.Select(x => x.VisitId).ToArray();

                        List<vw_ImageGallery> visitImages = (from i in context.vw_ImageGallery
                                                             where visitIds.Contains(i.VisitId)
                                                             select i).ToList();

                        model.Visits = visitsView.Select(x => new VisitDetailModel(x, visitImages.Where(y => y.VisitId == x.VisitId).ToList())).ToList();

                        //Get Comments for each Visit
                        model.Visits.ForEach(x => x.Comments = GetCommentsByVisitId(context, x.VisitId).ToList().Select(y => new CommentModel(y)).ToList());
                    }

                    //Used for the footer
                    ViewData["PrintUser"] = GetUser();
                    auditLogger.AddEvent(LogPoint.Success.ToString(), GetJobParamsString(view.VisitId));
                }

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview,");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview," + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview," + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }

            return GetFormatView("Job/PrintJob_Full.aspx", model);
        }

        [Description("Job Full Print Preview with all images")]
        public ActionResult JobWithImagesPrintPreview(string jobNo)
        {
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print-Preview of Job Details with Images,");

            JobContainer model = new JobContainer();
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    //Get SA Form
                    vw_SAFormDetails view = context.vw_SAFormDetails.FirstOrDefault(x => x.JobNo == jobNo);
                    List<vw_ImageGallery> SAImages = context.vw_ImageGallery.Where(x => x.VisitId == view.VisitId).ToList();

                    model.SAForm = new JobDataModel(view, SAImages);

                    // Get vehicle classes for SA Form
                    SAForm_level1Entity level1 = context.SAForm_level1Entity.Where(x => x.VisitId == view.VisitId).FirstOrDefault();

                    if (level1.SAForm_VehicleClasses.Any())
                    {
                        model.SAForm.VehDriverModel.VehicleClassIds = level1.SAForm_VehicleClasses.Select(x => x.VehicleClassId).ToArray();
                    }

                    if (view.VAD_License_IsNew != null)
                    {
                        model.SAForm.VehDriverModel.VehicleClasses = SetVehicleClasses((bool)view.VAD_License_IsNew, model.SAForm.VehDriverModel.VehicleClassIds);
                    }

                    //Get Comments for SA Form
                    model.SAForm.GeneralModel.Comments = GetCommentsByVisitId(context, view.VisitId).ToList().Select(x => new CommentModel(x)).ToList();

                    //Get Visits
                    List<vw_VisitDetails> visitsView = context.vw_VisitDetails.Where(x => x.JobNo == jobNo).ToList();

                    if (visitsView.Count > 0)
                    {
                        int[] visitIds = visitsView.Select(x => x.VisitId).ToArray();

                        List<vw_ImageGallery> visitImages = (from i in context.vw_ImageGallery
                                                             where visitIds.Contains(i.VisitId)
                                                             select i).ToList();

                        model.Visits = visitsView.Select(x => new VisitDetailModel(x, visitImages.Where(y => y.VisitId == x.VisitId).ToList())).ToList();

                        //Get Comments for each Visit
                        model.Visits.ForEach(x => x.Comments = GetCommentsByVisitId(context, x.VisitId).ToList().Select(y => new CommentModel(y)).ToList());
                    }

                    //Used for the footer
                    ViewData["PrintUser"] = GetUser();
                    auditLogger.AddEvent(LogPoint.Success.ToString(), GetJobParamsString(view.VisitId));
                }

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview,");
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview," + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(606, Resources.err_606));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Job Details Print-Preview," + "," + ex.Message + ",Stack Trace:" + ex.StackTrace);
            }

            return GetFormatView("Job/PrintJobWithImages_Full.aspx", model);
        }

        /// <summary>Prints the Visit/Jobs </summary>        
        ///<param name="visitId">Visit Id</param>       
        ///<returns>
        ///Returns the status of the action
        ///</returns>
        ///<exception cref="">
        ///database errors
        /// </exception>        
        /// <remarks></remarks> 
        [Description("Print Visit")]
        [HttpPost]
        public ActionResult PrintVisit(int visitId)
        {
            //logged on entry
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print Job," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    VisitEntity visit = (from j in context.VisitEntities
                                         where j.VisitId == visitId && (j.Info1 != "d" || j.Info1 == null)/* Remove deleted ones*/
                                         select j).FirstOrDefault();

                    if (visit == null)
                    {
                        throw new GenException(605, Resources.err_605);
                    }

                    //Restrict Multiple copies for users except the temp printer
                    if (GetLoggedUserDetail().RoleId != new Guid("5cb24ac1-013f-4d39-98f3-0ecf810f58d4"))
                    {
                        visit.IsPrinted = true;
                    }
                    UserDataModel user = GetUser();
                    visit.IsOriginal = false;
                    visit.PrintedBy = user.FirstName + " " + user.LastName;
                    visit.PrintedBranch = user.BranchName;

                    visit.PrintedDate = DateTime.Now;
                    context.SaveChanges();
                }

                logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print Job," + User.Identity.Name + ",[Params=(Visit Id:" + visitId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                auditLogger.AddEvent(LogPoint.Success.ToString(), visitId, GetJobParamsString(visitId));
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print Job," + User.Identity.Name + "," + ex.Message + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (XmlException ex)
            {
                ModelState.AddModelError("err", new GenException(99, ex.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print Job," + User.Identity.Name + "," + ex.Message + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print Job," + User.Identity.Name + "," + ex.Message + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(99, ex.Message));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Print Job," + User.Identity.Name + "," + ex.Message + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ",[Params=(Visit Id:" + visitId + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
            }
            return GetFormatView("Jobs/PrintJobSuccess.aspx");
        }

        #endregion

        #endregion

        #region Non Actions

        ///<summary>A NonAction Method to check weather job number already exists.</summary>
        ///<param name="jobNo">Job Number</param>
        ///<returns>
        ///true/false 
        ///</returns>       
        /// <remarks></remarks> 
        [NonAction]
        [Description("Is Job Number Unique")]
        private bool IsJobNumberUnique(string jobNo)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    // The columns are set to "SQL_Latin1_General_CP1_CI_AS" Collation by default which is case insensitive

                    /* That's because you are using LINQ To Entities which is ultimately convert your Lambda Expressions into 
                     * SQL statements. That means the case sensitivity is at the mercy of your SQL Server which by default has 
                     * SQL_Latin1_General_CP1_CI_AS Collation and that is NOT case sensitive. 
                     Refer article http://stackoverflow.com/questions/3843060/linq-to-entities-case-sensitive-comparison
                     */

                    var jobs = from j in context.VisitEntities
                               where j.JobNo == jobNo
                               && j.VisitType == 0 /*Check only SA Forms */
                               && (j.Info1 != "d" || j.Info1 == null)/* Remove deleted ones*/
                               select j;

                    if (jobs.Count() == 0)
                    {
                        return true;
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }
            return false;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [NonAction]
        [Description("Get Region Data List")]
        public static List<RegionDataModel> GetRegionDataList()
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<RegionEntity> query = from r in context.RegionEntities orderby r.RegionName select r;

                    List<RegionDataModel> regions = (from r in query
                                                     where !r.IsDeleted && r.IsEnabled
                                                     select new RegionDataModel
                                                     {
                                                         RegionName = r.RegionName,
                                                         RegionId = r.RegionId,
                                                     }).ToList();
                    return regions;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Description("Get Region Data List")]
        public static List<RegionDataModel> GetRegionDataListPerf(int id)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    var users = context.vw_UserDetails;
                    var results = from myRow in users.AsEnumerable()
                                  where myRow.UserId.Equals(id)
                                  select myRow;
                    List<RegionDataModel> regionNew = new List<RegionDataModel>();
                    RegionDataModel regModel = new RegionDataModel
                                                     {
                                                         RegionName = results.ElementAt(0).RegionName,
                                                         RegionId = results.ElementAt(0).RegionId,
                                                     };
                    regionNew.Add(regModel);
                    return regionNew;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        [Description("Get User Data List")]
        public static List<UserDataModel> GetUserDataList()
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IEnumerable<UserEntity> query = from r in context.UserEntities orderby r.FirstName select r;

                    List<UserDataModel> users = (from r in query
                                                 where !r.IsDeleted && r.IsEnabled
                                                 select new UserDataModel
                                                 {
                                                     CSRCode = r.Code,

                                                 }).ToList();
                    return users;
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="searchModel"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        [NonAction]
        [Description("Get Jobs")]
        private List<GetJobs_Result> GetJobs(int dataCount, AdvancedSearch searchModel, MotorClaimEntities context)
        {
            //SP introduced 2017-01-06 by UthpalaP
            if (!searchModel.DateFrom.HasValue)
                searchModel.DateFrom = Convert.ToDateTime("1990-01-01 00:00:00.000");

            if (!searchModel.DateTo.HasValue)
                searchModel.DateTo = DateTime.Now;

            if (searchModel.DateTo.HasValue)
                searchModel.DateTo = searchModel.DateTo.Value.AddHours(23).AddMinutes(59);

            #region Get Sorting Column

            string orderBy = "";
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<vw_SAForm_GeneralNew, object> orderingFunction = c => c.GEN_VehicleNo;

            switch (sortColumnIndex)
            {
                case 0:
                    orderBy = "Vehicle No";
                    break;
                case 1:
                    orderBy = "Job No";
                    break;
                case 2:
                    orderBy = "Date of Accident";
                    break;
                case 3:
                    orderBy = "TO Code";
                    break;
                case 4:
                    orderBy = "ACR";
                    break;
                case 7:
                    orderBy = "Claim Processing Branch";
                    break;
                default:
                    orderBy = "Vehicle No";
                    break;
            }

            var sortDirection = Request["sSortDir_0"]; // asc or desc
            if (sortDirection == "asc")
                orderBy = orderBy + " asc";
            else
                orderBy = orderBy + " desc";

            #endregion

            int? regionId;
            int? branchId;
            if (searchModel.RegionId == -1)
                regionId = null;
            else
                regionId = searchModel.RegionId;

            if (searchModel.BranchId == -1)
                branchId = null;
            else
                branchId = searchModel.BranchId;

            var jobList = context.GetJobs(searchModel.DateFrom,
                                                    searchModel.DateTo,
                                                    (string.IsNullOrWhiteSpace(searchModel.JobNo)) ? null : searchModel.JobNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.VehicleNo)) ? null : searchModel.VehicleNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRCode)) ? null : searchModel.CSRCode.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRName)) ? null : searchModel.CSRName.Trim(),
                                                    regionId,
                                                    branchId,
                                                    (string.IsNullOrWhiteSpace(searchModel.EPFNo)) ? null : searchModel.EPFNo.Trim(),
                                                    orderBy,
                                                    0,
                                                    dataCount).ToList();//,param.iDisplayStart, param.iDisplayLength


            //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
            if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
            {
                branchId = GetUserBranchId();
                jobList = jobList.Where(x => x.OTH_ProcessingBranchId == branchId).ToList();
            }

            if (searchModel.RegionId != -1 && searchModel.BranchId != -1)
            {
                //Region selected and branch also selected -Select specific branch             
                jobList = jobList.Where(j => j.OTH_ProcessingBranchId == searchModel.BranchId).ToList();
            }
            else if (searchModel.RegionId != -1 && searchModel.BranchId == -1)
            {
                //Region selected and branch not selected (All) - Select all branches under that region
                int[] branchIds = context.BranchEntities.Where(x => x.RegionId == searchModel.RegionId && !x.IsDeleted && x.IsEnabled).Select(x => x.BranchId).ToArray();

                jobList = jobList.Where(j => branchIds.Contains((int)j.OTH_ProcessingBranchId)).ToList();
            }

            jobList = jobList.OrderBy(j => j.VisitId).AsQueryable().ToList();

            return jobList;
        }

        /// <summary>
        /// 2017/02/17
        /// Uthpala Pathirana
        /// </summary>
        /// <param name="searchModel"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        [NonAction]
        [Description("Get Jobs Count")]
        private int GetJobsCount(AdvancedSearch searchModel, MotorClaimEntities context)
        {
            //SP introduced 2017-01-06 by UthpalaP
            #region Get Sorting Column

            string orderBy = "";
            var sortColumnIndex = Convert.ToInt32(Request["iSortCol_0"]);
            Func<vw_SAForm_GeneralNew, object> orderingFunction = c => c.GEN_VehicleNo;

            switch (sortColumnIndex)
            {
                case 0:
                    orderBy = "Vehicle No";
                    break;
                case 1:
                    orderBy = "Job No";
                    break;
                case 2:
                    orderBy = "Date of Accident";
                    break;
                case 3:
                    orderBy = "TO Code";
                    break;
                case 4:
                    orderBy = "ACR";
                    break;
                case 7:
                    orderBy = "Claim Processing Branch";
                    break;
                default:
                    orderBy = "Vehicle No";
                    break;
            }

            var sortDirection = Request["sSortDir_0"]; // asc or desc
            if (sortDirection == "asc")
                orderBy = orderBy + " asc";
            else
                orderBy = orderBy + " desc";

            #endregion

            int? regionId;
            int? branchId;
            if (searchModel.RegionId == -1)
                regionId = null;
            else
                regionId = searchModel.RegionId;

            if (searchModel.BranchId == -1)
                branchId = null;
            else
                branchId = searchModel.BranchId;

            var totalRecordCount = context.GetJobsCount(searchModel.DateFrom,
                                                    searchModel.DateTo,
                                                    (string.IsNullOrWhiteSpace(searchModel.JobNo)) ? null : searchModel.JobNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.VehicleNo)) ? null : searchModel.VehicleNo.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRCode)) ? null : searchModel.CSRCode.Trim(),
                                                    (string.IsNullOrWhiteSpace(searchModel.CSRName)) ? null : searchModel.CSRName.Trim(),
                                                    regionId,
                                                    branchId,
                                                    (string.IsNullOrWhiteSpace(searchModel.EPFNo)) ? null : searchModel.EPFNo.Trim()
                                                   ).First().Value;

            return totalRecordCount;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="jobNo"></param>
        /// <param name="startIndex"></param>
        /// <param name="pageSize"></param>
        /// <returns></returns>
        [NonAction]
        [Description("Get Job Visits")]
        private List<VisitModel> GetJobVisits(string jobNo, int startIndex, int pageSize)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    List<vw_Visits> visits = (from v in context.vw_Visits
                                              where v.JobNo == jobNo
                                              select v).OrderBy(v => v.VisitId).Skip(startIndex).Take(pageSize).ToList();

                    List<VisitModel> visitList = new List<VisitModel>();
                    int inc = 1;
                    foreach (vw_Visits t in visits)
                    {
                        VisitModel model = new VisitModel(t);// Mapper.ToVisitObject(visits[i]);
                        model.VisitNo = inc++;

                        visitList.Add(model);
                    }
                    return visitList;
                }
            }
            catch (GenException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                //log on exception              
                throw;
            }
        }

        //Mobile App
        [NonAction]
        [Description("Search Visits")]
        private List<GroupedVisitsModel> SearchVisits(string searchText)
        {
            try
            {
                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    IQueryable<vw_SAForm_GeneralNew> jobs = context.vw_SAForm_GeneralNew.Where(v => v.JobNo.StartsWith(searchText) ||
                        v.GEN_VehicleNo.StartsWith(searchText));

                    //DATA FILTERING ACCORING TO DATA ACCESS LEVEL
                    if (GetUserDataAccessLevel() == UserDataAccessLevel.BranchOnly)
                    {
                        int? branchId = GetUserBranchId();
                        jobs = jobs.Where(x => x.OTH_ProcessingBranchId == branchId);
                    }

                    IEnumerable<KeyValuePair<string, string>> jobVehicles = jobs.ToDictionary(mc => mc.JobNo.ToString(), mc => mc.GEN_VehicleNo.ToString()).Distinct();

                    string[] jobNumbers = jobVehicles.Select(x => x.Key).ToArray();

                    List<VisitModel> visits = (from v in context.VisitEntities
                                               where jobNumbers.Contains(v.JobNo)
                                              && (v.Info1 != "d" || v.Info1 == null)/* Remove deleted ones*/
                                               select new VisitModel
                                               {
                                                   VisitId = v.VisitId,
                                                   JobNo = v.JobNo,
                                                   VisitType = v.VisitType,
                                                   VisitedDate = v.TimeVisited,
                                                   CreatedBy = v.CreatedBy,
                                                   CreatedDate = v.CreatedDate,
                                               }).ToList();

                    List<GroupedVisitsModel> groupedVisits = (from p in visits
                                                              group p by p.JobNo into grps
                                                              select new
                                                              {
                                                                  Key = grps.Key,
                                                                  Visits = grps.Distinct()
                                                              }).Select(x => new GroupedVisitsModel { JobNo = x.Key, VehNo = jobVehicles.Where(y => y.Key == x.Key).Select(y => y.Value).FirstOrDefault(), JobVisits = x.Visits }).ToList();

                    return groupedVisits;
                }
            }
            catch (GenException ex)
            {
                throw;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        [Description("Set Vehicle Classes")]
        public string SetVehicleClasses(bool isNewLicense, short[] vehicleClassIds)
        {
            List<string> classes = new List<string>();

            if (vehicleClassIds == null)
                return Resources.info_gen_noneSelected;

            foreach (short item in vehicleClassIds)
            {
                Type oType = null;
                oType = ((bool)isNewLicense) ? typeof(NewLicenseVehClasses) : typeof(OldLicenseVehClasses);
                classes.Add(Enum.GetName(oType, item));
            }

            return String.Join(",", classes);
        }

        [Description("Set Selected Vehicle Classes")]
        public List<SelectListItem> SetSelectedVehicleClasses(bool isNewLicense, short[] vehicleClassIds)
        {
            Array arr = null;
            List<SelectListItem> enums = new List<SelectListItem>();

            if (vehicleClassIds == null)
                return enums;

            if ((bool)isNewLicense)
            {
                arr = Enum.GetValues(typeof(NewLicenseVehClasses));
                int i = 0;
                foreach (NewLicenseVehClasses value in arr)
                {
                    var item = new SelectListItem();
                    item.Value = ((short)value).ToString();
                    item.Text = arr.GetValue(i).ToString();
                    item.Selected = vehicleClassIds.Contains((short)value);
                    enums.Add(item);
                    i++;
                }
            }
            else
            {
                arr = Enum.GetValues(typeof(OldLicenseVehClasses));
                int i = 0;
                foreach (OldLicenseVehClasses value in arr)
                {

                    var item = new SelectListItem();
                    item.Value = ((short)value).ToString();
                    item.Text = arr.GetValue(i).ToString();
                    item.Selected = vehicleClassIds.Contains((short)value);
                    enums.Add(item);
                    i++;
                }
            }
            return enums;
        }

        #region Mappers

        /// <summary>Convert job XML to Job Entity.</summary>
        /// <param name="jobXml">Job XML</param>
        ///<returns>
        ///JobEntity
        ///</returns>
        ///<exception cref="">
        ///Vehicle number cannot be null or empty
        ///no jobs found
        ///database errors
        ///xml parsing errors(XPATH not found)
        /// </exception>        
        /// <remarks></remarks> 
        /// 
        [Description("To Visit Entity")]
        public static VisitEntity ToVisitEntity(XmlDocument jobXml, bool isJob)
        {
            try
            {
                int userId = 0;

                //sample job xml can be found at DocRef\SampleXml\Jobs\AddJobRequest.xml
                XmlNode jobNode = jobXml.SelectSingleNode("/Request/Data/Job");

                if (jobNode == null)
                {
                    throw new GenException(632, Resources.err_632_sys);
                }

                VisitEntity jobEntity = new VisitEntity();

                #region VisitEntity

                try
                {
                    using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                    {
                        string userName = jobNode.SelectSingleNode("FieldList/CSRUserName").InnerText;
                        //jobEntity.CSR_UserName = userName;

                        AdminController admin = new AdminController();
                        userId = admin.GetUserId(userName);
                    }
                }
                catch (Exception)
                {
                    throw new GenException(633, Resources.err_633);
                }

                jobEntity.JobNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/JobNo").InnerText);
                jobEntity.CreatedBy = userId;
                //jobEntity.SAForm_level2.CSR_UserId = userId;
                jobEntity.CreatedDate = DateTime.Now;
                jobEntity.IsPrinted = false;
                jobEntity.IsOriginal = true;

                if (isJob)
                {
                    jobEntity.VisitType = 0;
                }
                else
                {
                    //FOR Visits
                    try
                    {
                        jobEntity.VisitType = short.Parse(jobNode.SelectSingleNode("FieldList/VisitType").InnerText);
                    }
                    catch (Exception)
                    {
                        throw new GenException(634, Resources.err_634_sys);
                    }
                }

                try
                {
                    jobEntity.TimeVisited = DateTime.Parse(jobNode.SelectSingleNode("FieldList/TimeVisited").InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(635, Resources.err_635);
                }

                XmlNode imageCountNode = jobNode.SelectSingleNode("FieldList/ImageCount");

                if (imageCountNode != null)
                {
                    try
                    {
                        jobEntity.ImageCount = String.IsNullOrEmpty(imageCountNode.InnerText) ? (short)0 : short.Parse(imageCountNode.InnerText);
                    }
                    catch (Exception)
                    { }
                }
                // loop for imagecount
                #endregion

                #region Images
                //VisitParam visitParamEntity = new VisitParam();
                XmlNodeList nodeList = jobNode.SelectNodes("FieldList/ImageCountList/ImageType");


                try
                {
                    if (nodeList != null)
                    {
                        foreach (XmlNode node in nodeList)
                        {
                            //Fill VisitParam entity
                            VisitParam visitParamEntity = new VisitParam();
                            //XmlNode key = node.SelectSingleNode("TypeId");
                            //XmlNode value = node.SelectSingleNode("ImageCount");
                            visitParamEntity.VisitId = jobEntity.VisitId;

                            visitParamEntity.ParamTypeId = 1;
                            visitParamEntity.ParamKey = GenUtils.CheckEmptyString(node.SelectSingleNode("TypeId").InnerText);
                            visitParamEntity.Value = GenUtils.CheckEmptyString(node.SelectSingleNode("ImageCount").InnerText);


                            jobEntity.VisitParams.Add(visitParamEntity);

                        }
                    }
                }
                catch (Exception)
                {
                    throw new GenException(652, Resources.err_652);
                }

                #endregion

                if (isJob)
                {
                    jobEntity.SAForm_level1 = ToSAForm_level1_Entity(jobNode);
                    jobEntity.SAForm_level2 = ToSAForm_level2_Entity(jobNode);
                }
                else
                {
                    //Fill Visit Detail table from XML;
                    //Add to a separate method
                    jobEntity.VisitDetail = new VisitDetailEntity();
                    jobEntity.VisitDetail.EngineNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/EngineNo").InnerText);
                    jobEntity.VisitDetail.ChassyNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/ChassisNo").InnerText);
                }

                #region Comments

                //Feature asked by SLIC for adding comments - Release v2.0.0
                XmlNode commentNode = jobNode.SelectSingleNode("FieldList/Comment");

                if (commentNode != null && !string.IsNullOrWhiteSpace(commentNode.InnerText))
                {
                    //Fill Comment entity
                    CommentEntity comment = new CommentEntity();
                    comment.Comment1 = GenUtils.CheckEmptyString(commentNode.InnerText);
                    comment.CommentedBy = jobEntity.CreatedBy;
                    comment.CommentedDate = jobEntity.CreatedDate;

                    jobEntity.Comments.Add(comment);
                }

                #endregion

                return jobEntity;
            }
            catch (GenException)
            {
                throw;
            }
            catch (XmlException)
            {
                throw new GenException(953, Resources.err_953_sys);
            }
            catch (SqlException)
            {
                throw;
            }
            catch (Exception)
            {
                throw;
            }
        }

        [Description("To SAForm level1 Entity")]
        public static SAForm_level1Entity ToSAForm_level1_Entity(XmlNode jobNode)
        {

            SAForm_level1Entity entity = new SAForm_level1Entity();

            #region SAForm_level1

            #region General
            // jobEntity.JobNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/JobNo").InnerText);
            entity.GEN_Caller_Name = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/CallerName").InnerText);
            entity.GEN_Caller_ContactNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/CallerContactNo").InnerText);
            entity.GEN_Insured_Name = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/InsuredName").InnerText);
            entity.GEN_Insured_ContactNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/InsuredContactNo").InnerText);
            try
            {
                entity.GEN_TimeReported = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/TimeReported").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/TimeReported").InnerText);

            }
            catch (Exception)
            {
                throw new GenException(636, Resources.err_636);
            }

            entity.GEN_VehicleNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/VehicleNo").InnerText.ToUpper());
            entity.GEN_VehicleDescription = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/VehicleTypeColor").InnerText);

            entity.GEN_Acc_Location = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/AccidentLocation").InnerText);
            try
            {
                entity.GEN_Acc_Time = DateTime.Parse(jobNode.SelectSingleNode("FieldList/AccidentTime").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(637, Resources.err_637);
            }            

            XmlNode OrgTimeRepNode = jobNode.SelectSingleNode("FieldList/OriginalTimeReported");

            if (OrgTimeRepNode != null && !String.IsNullOrWhiteSpace(OrgTimeRepNode.InnerText))
            {
                try
                {
                    entity.GEN_OriginalTimeReported = DateTime.Parse(OrgTimeRepNode.InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(638, Resources.err_638);
                }
            }
            else
            {
                //GEN_OriginalTimeReported is null so it is replaced with GEN_TimeReported and Info2 is updated with a text.
                #region GEN_OriginalTimeReported is null

                entity.GEN_OriginalTimeReported = entity.GEN_TimeReported;
                entity.Info2 = "GEN_OriginalTimeReported is null so it is replaced with GEN_TimeReported";

                #endregion
            }

            #endregion

            #region Policy

            entity.POL_Policy_CN_No = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/Policy_CoverNoteNo").InnerText);
            entity.POL_Policy_CN_SerialNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/Policy_CoverNoteSerialNo").InnerText);
            try
            {
                entity.POL_Policy_CN_StartDate = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/from").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/from").InnerText);

            }
            catch (Exception)
            {
                throw new GenException(639, Resources.err_639);
            }
            try
            {
                entity.POL_Policy_CN_EndDate = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/to").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/Policy_CoverNotePeriod/to").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(640, Resources.err_640);
            }


            entity.POL_CN_IssuedBy = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/CoverNoteIssuedBy").InnerText);
            entity.POL_CN_Reasons = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/CoverNoteReasons").InnerText);



            #endregion

            #region Vehicle and Driver

            entity.VAD_EngineNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/EngineNo").InnerText);
            entity.VAD_ChassyNo = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/ChassisNo").InnerText);
            entity.VAD_DriverName = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/DriverName").InnerText);
            entity.VAD_DriverNIC = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/DriverNIC").InnerText);

            try
            {
                entity.VAD_DriverIdType = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/NICType").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/NICType").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(956, Resources.err_956);
            }

            try
            {
                entity.VAD_DriverCompetence = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/DriverCompetence").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/DriverCompetence").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(641, Resources.err_641);
            }
            try
            {
                entity.VAD_DriverRelationship = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/DriverRelationship").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/DriverRelationship").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(642, Resources.err_642);
            }
            try
            {
                entity.VAD_MeterReading = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/MeterReading").InnerText) ? (int?)null : int.Parse(jobNode.SelectSingleNode("FieldList/MeterReading").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(643, Resources.err_643);
            }
            entity.VAD_License_No = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/LicenceNo").InnerText);
            try
            {
                entity.VAD_License_ExpiryDate = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenceExpiryDate").InnerText) ? (DateTime?)null : DateTime.Parse(jobNode.SelectSingleNode("FieldList/LicenceExpiryDate").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(644, Resources.err_644);
            }
            try
            {
                entity.VAD_License_TypeId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenceType").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/LicenceType").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(645, Resources.err_645);
            }
            try
            {
                entity.VAD_License_IsNew = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/LicenseNewOld/IsNew").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/LicenseNewOld/IsNew").InnerText));
            }
            catch (Exception)
            {
                throw new GenException(646, Resources.err_646);
            }

            #endregion

            #region Other

            try
            {
                entity.OTH_PavValue = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/PavValue").InnerText) ? (decimal?)null : decimal.Parse(jobNode.SelectSingleNode("FieldList/PavValue").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(647, Resources.err_647);
            }
            try
            {
                //NOTE: Old code, changed on 2017-02-03 - Suren
                //entity.OTH_ProcessingBranchId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/ClaimProcessBranch").InnerText) ? (int?)null : int.Parse(jobNode.SelectSingleNode("FieldList/ClaimProcessBranch").InnerText);

                //NOTE: This can't be null because on the tab's side it's a mandatory field
                entity.OTH_ProcessingBranchId = int.Parse(jobNode.SelectSingleNode("FieldList/ClaimProcessBranch").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(648, Resources.err_648);
            }

            //START Release v2.1.0 Changes - Onsite Estimation and Approximate Repair Cost
            XmlNode siteEstNode = jobNode.SelectSingleNode("FieldList/SiteEstimation");
            if (siteEstNode != null)
            {
                try
                {
                    entity.OTH_SiteEstimation = String.IsNullOrEmpty(siteEstNode.InnerText) ? (short?)null : short.Parse(siteEstNode.InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(649, Resources.err_649);
                }
            }
            XmlNode repairCostNode = jobNode.SelectSingleNode("FieldList/ApproxRepairCost");
            if (repairCostNode != null)
            {
                try
                {
                    entity.OTH_Approx_RepairCost = String.IsNullOrEmpty(repairCostNode.InnerText) ? (decimal?)null : decimal.Parse(repairCostNode.InnerText);
                }
                catch (Exception)
                {
                    throw new GenException(650, Resources.err_650);
                }
            }

            try
            {
                entity.OTH_CSR_Consistency = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/CSRConsistency").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/CSRConsistency").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(651, Resources.err_651);
            }


            #endregion

            #endregion

            #region VehicleClasses

            XmlNodeList nodeList = jobNode.SelectNodes("FieldList/VehicleClass/class");

            try
            {
                if (nodeList != null)
                {
                    foreach (XmlNode node in nodeList)
                    {
                        //Fill Vehicle Class entity
                        SAForm_VehicleClassesEntity jobVehicleEntity = new SAForm_VehicleClassesEntity();
                        jobVehicleEntity.VisitId = entity.VisitId;
                        jobVehicleEntity.VehicleClassId = short.Parse(node.InnerText);

                        entity.SAForm_VehicleClasses.Add(jobVehicleEntity);

                    }
                }
            }
            catch (Exception)
            {
                throw new GenException(652, Resources.err_652);
            }

            #endregion

            return entity;
        }

        [Description("To SAForm level2 Entity")]
        public static SAForm_level2Entity ToSAForm_level2_Entity(XmlNode jobNode)
        {
            SAForm_level2Entity entity = new SAForm_level2Entity();

            #region SAForm_level2

            #region Damages

            entity.DAM_DamagedItems = ComponentManager.ConvertDamagedItemsXMLtoDBstring(jobNode.SelectSingleNode("FieldList/DamagedItems"));// HttpUtility.HtmlEncode(jobNode.SelectSingleNode("FieldList/DamagedItems").InnerXml);

            entity.DAM_PossibleDR = HttpUtility.HtmlEncode(jobNode.SelectSingleNode("FieldList/PossibleDR").InnerXml);
            entity.DAM_Goods_Damage = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/GoodsDamages").InnerText);
            entity.DAM_Goods_Type = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/GoodsType").InnerText);
            try
            {
                entity.DAM_Goods_Weight = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/GoodsWeight").InnerText) ? (decimal?)null : decimal.Parse(jobNode.SelectSingleNode("FieldList/GoodsWeight").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(653, Resources.err_653);
            }
            entity.DAM_Injuries = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/Injuries").InnerText);
            try
            {
                entity.DAM_Is_OL_Contributory = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/OverWeightContributory").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/OverWeightContributory").InnerText));
            }
            catch (Exception)
            {
                throw new GenException(654, Resources.err_654);
            }
            try
            {
                entity.DAM_IsOverLoaded = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/OverLoaded").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/OverLoaded").InnerText));
            }
            catch (Exception)
            {
                throw new GenException(655, Resources.err_655);
            }

            entity.DAM_OtherVeh_Involved = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/OtherVehiclesInvolved").InnerText);

            entity.DAM_ThirdParty_Damage = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/ThirdPartyDamages").InnerText);

            XmlNode preAccNode = jobNode.SelectSingleNode("FieldList/PreAccidentDamages");

            if (preAccNode != null)
            {
                entity.DAM_PreAccidentDamages = ComponentManager.ConvertDamagedItemsXMLtoDBstring(preAccNode);// HttpUtility.HtmlEncode(preAccNode.InnerXml);
            }

            XmlNode OtherPossibleDRNode = jobNode.SelectSingleNode("FieldList/OtherPossibleDR");

            if (OtherPossibleDRNode != null)
            {
                entity.DAM_PossibleDR_Other = GenUtils.CheckEmptyString(OtherPossibleDRNode.InnerText); ;
            }

            XmlNode OtherDamagedItemsNode = jobNode.SelectSingleNode("FieldList/OtherDamagedItems");

            if (OtherDamagedItemsNode != null)
            {
                entity.DAM_DamagedItems_Other = GenUtils.CheckEmptyString(OtherDamagedItemsNode.InnerText); ;
            }

            XmlNode OtherPreAccNode = jobNode.SelectSingleNode("FieldList/OtherPreAccidentDamages");

            if (OtherPreAccNode != null)
            {
                entity.DAM_PreAccidentDamages_Other = GenUtils.CheckEmptyString(OtherPreAccNode.InnerText); ;
            }

            #endregion

            #region Tyre Condition

            try
            {
                entity.CON_Tyre_FL_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/FL").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(656, String.Format(Resources.err_656, "F/L"));
            }
            try
            {
                entity.CON_Tyre_FR_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/FR").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(656, String.Format(Resources.err_656, "F/R"));
            }
            try
            {
                entity.CON_Tyre_RLL_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RLL").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(656, String.Format(Resources.err_656, "R/L/L"));
            }
            try
            {
                entity.CON_Tyre_RLR_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RLR").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(656, String.Format(Resources.err_656, "R/L/R"));
            }
            try
            {
                entity.CON_Tyre_RRL_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RRL").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(656, String.Format(Resources.err_656, "R/R/L"));
            }
            try
            {
                entity.CON_Tyre_RRR_Status = short.Parse(jobNode.SelectSingleNode("FieldList/TyreCondition/RRR").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(656, String.Format(Resources.err_656, "R/R/R"));
            }
            try
            {
                entity.CON_Tyre_IsContributory = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/TyreContributory").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/TyreContributory").InnerText));
            }
            catch (Exception)
            {
                throw new GenException(657, Resources.err_657);
            }

            #endregion

            #region Other

            try
            {
                entity.OTH_Journey_PurposeId = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/JourneyPurpose").InnerText) ? (short?)null : short.Parse(jobNode.SelectSingleNode("FieldList/JourneyPurpose").InnerText);
            }
            catch (Exception)
            {
                throw new GenException(658, Resources.err_658);
            }

            entity.OTH_Nearest_PoliceStation = GenUtils.CheckEmptyString(jobNode.SelectSingleNode("FieldList/NearestPoliceStation").InnerText);
            entity.Further_Review_isRequired = String.IsNullOrEmpty(jobNode.SelectSingleNode("FieldList/FurtherReview").InnerText) ? (bool?)null : Convert.ToBoolean(short.Parse(jobNode.SelectSingleNode("FieldList/FurtherReview").InnerText));
            #endregion

            #endregion

            return entity;
        }

        /// <summary>Convert job entity values to dictionary list values.</summary>
        ///<param name="entity">Job Entity</param>
        ///<returns>
        ///ListDictionary containing the tags and it's values
        ///</returns>      
        /// <remarks>
        /// This result of this method is used for generating the body string of the email.
        /// The template is Content\templates\jobEmailTemplate.txt
        /// </remarks> 
        public static ListDictionary SAToDictionaryValues(VisitEntity entity)
        {
            ListDictionary replacements = new ListDictionary();

            replacements.Add("<%JobNo%>", getStringValue(entity.JobNo));
            replacements.Add("<%TimeVisited%>", getStringValue(entity.TimeVisited));

            CommentEntity comment = entity.Comments.FirstOrDefault(x => x.User.Code != null);
            replacements.Add("<%Comment%>", (comment != null ? getStringValue(comment.Comment1) : string.Empty));

            replacements.Add("<%CSR_UserName%>", getStringValue(entity.User.aspnet_Users.UserName));
            replacements.Add("<%Caller_Name%>", getStringValue(entity.SAForm_level1.GEN_Caller_Name));
            replacements.Add("<%Caller_ContactNo%>", getStringValue(entity.SAForm_level1.GEN_Caller_ContactNo));
            replacements.Add("<%Insured_Name%>", getStringValue(entity.SAForm_level1.GEN_Insured_Name));
            replacements.Add("<%Insured_ContactNo%>", getStringValue(entity.SAForm_level1.GEN_Insured_ContactNo));
            replacements.Add("<%TimeReported%>", getStringValue(entity.SAForm_level1.GEN_TimeReported));
            replacements.Add("<%VehicleNo%>", getStringValue(entity.SAForm_level1.GEN_VehicleNo));
            replacements.Add("<%VehicleDescription%>", getStringValue(entity.SAForm_level1.GEN_VehicleDescription));
            replacements.Add("<%Policy_CN_No%>", getStringValue(entity.SAForm_level1.POL_Policy_CN_No));
            replacements.Add("<%Policy_CN_SerialNo%>", getStringValue(entity.SAForm_level1.POL_Policy_CN_SerialNo));
            replacements.Add("<%Policy_CN_StartDate%>", getStringValue(entity.SAForm_level1.POL_Policy_CN_StartDate));
            replacements.Add("<%Policy_CN_EndDate%>", getStringValue(entity.SAForm_level1.POL_Policy_CN_EndDate));
            replacements.Add("<%EngineNo%>", getStringValue(entity.SAForm_level1.VAD_EngineNo));
            replacements.Add("<%ChassyNo%>", getStringValue(entity.SAForm_level1.VAD_ChassyNo));
            replacements.Add("<%DriverName%>", getStringValue(entity.SAForm_level1.VAD_DriverName));
            replacements.Add("<%DriverNIC%>", getStringValue(entity.SAForm_level1.VAD_DriverNIC));
            replacements.Add("<%DriverCompetence%>", (entity.SAForm_level1.VAD_DriverCompetence != null) ? Enum.GetName(typeof(Confirmation), entity.SAForm_level1.VAD_DriverCompetence) : string.Empty);
            replacements.Add("<%DriverRelationship%>", Enum.GetName(typeof(RelationshipType), entity.SAForm_level1.VAD_DriverRelationship));
            replacements.Add("<%Acc_Location%>", getStringValue(entity.SAForm_level1.GEN_Acc_Location));
            replacements.Add("<%Acc_Time%>", getStringValue(entity.SAForm_level1.GEN_Acc_Time));
            replacements.Add("<%MeterReading%>", getStringValue(entity.SAForm_level1.VAD_MeterReading));
            replacements.Add("<%License_No%>", getStringValue(entity.SAForm_level1.VAD_License_No));
            replacements.Add("<%License_ExpiryDate%>", getStringValue(entity.SAForm_level1.VAD_License_ExpiryDate));
            replacements.Add("<%License_Type%>", (entity.SAForm_level1.VAD_License_TypeId != null) ? Enum.GetName(typeof(LicenseType), entity.SAForm_level1.VAD_License_TypeId) : string.Empty);
            replacements.Add("<%License_IsNew%>", (entity.SAForm_level1.VAD_License_IsNew != null) ? (((bool)entity.SAForm_level1.VAD_License_IsNew) ? "New" : "Old") : null);
            replacements.Add("<%CN_IssuedBy%>", getStringValue(entity.SAForm_level1.POL_CN_IssuedBy));
            replacements.Add("<%CN_Reasons%>", getStringValue(entity.SAForm_level1.POL_CN_Reasons));
            replacements.Add("<%Goods_Damage%>", getStringValue(entity.SAForm_level2.DAM_Goods_Damage));
            replacements.Add("<%Goods_Type%>", getStringValue(entity.SAForm_level2.DAM_Goods_Type));
            replacements.Add("<%Goods_Weight%>", getStringValue(entity.SAForm_level2.DAM_Goods_Weight));
            replacements.Add("<%Injuries%>", getStringValue(entity.SAForm_level2.DAM_Injuries));
            replacements.Add("<%Is_OL_Contributory%>", (entity.SAForm_level2.DAM_Is_OL_Contributory != null) ? (((bool)entity.SAForm_level2.DAM_Is_OL_Contributory) ? "Yes" : "No") : null);
            replacements.Add("<%IsOverLoaded%>", (entity.SAForm_level2.DAM_IsOverLoaded != null) ? (((bool)entity.SAForm_level2.DAM_IsOverLoaded) ? "Yes" : "No") : null);
            replacements.Add("<%Journey_PurposeId%>", Enum.GetName(typeof(JourneyPurpose), entity.SAForm_level2.OTH_Journey_PurposeId));
            replacements.Add("<%Nearest_PoliceStation%>", getStringValue(entity.SAForm_level2.OTH_Nearest_PoliceStation));
            replacements.Add("<%OtherVeh_Involved%>", getStringValue(entity.SAForm_level2.DAM_OtherVeh_Involved));
            replacements.Add("<%PavValue%>", getStringValue(entity.SAForm_level1.OTH_PavValue));
            replacements.Add("<%ProcessingBranchId%>", getStringValue(CultureInfo.CurrentCulture.TextInfo.ToTitleCase(entity.SAForm_level1.Branch.BranchName.ToLower())));
            replacements.Add("<%ThirdParty_Damage%>", getStringValue(entity.SAForm_level2.DAM_ThirdParty_Damage));
            /*
             * TODO://Use Enum Utils
            replacements.Add("<%Tyre_FL_Status%>", Enum.GetName(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_FL_Status));
            replacements.Add("<%Tyre_FR_Status%>", Enum.GetName(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_FR_Status));
            replacements.Add("<%Tyre_RLL_Status%>", Enum.GetName(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RLL_Status));
            replacements.Add("<%Tyre_RLR_Status%>", Enum.GetName(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RLR_Status));
            replacements.Add("<%Tyre_RRL_Status%>", Enum.GetName(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RRL_Status));
            replacements.Add("<%Tyre_RRR_Status%>", Enum.GetName(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RRR_Status));*/

            replacements.Add("<%Tyre_FL_Status%>", (entity.SAForm_level2.CON_Tyre_FL_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_FL_Status.ToString()) : string.Empty);
            replacements.Add("<%Tyre_FR_Status%>", (entity.SAForm_level2.CON_Tyre_FR_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_FR_Status.ToString()) : string.Empty);
            replacements.Add("<%Tyre_RLL_Status%>", (entity.SAForm_level2.CON_Tyre_RLL_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RLL_Status.ToString()) : string.Empty);
            replacements.Add("<%Tyre_RLR_Status%>", (entity.SAForm_level2.CON_Tyre_RLR_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RLR_Status.ToString()) : string.Empty);
            replacements.Add("<%Tyre_RRL_Status%>", (entity.SAForm_level2.CON_Tyre_RRL_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RRL_Status.ToString()) : string.Empty);
            replacements.Add("<%Tyre_RRR_Status%>", (entity.SAForm_level2.CON_Tyre_RRR_Status != null) ? EnumUtils.stringValueOf(typeof(TyreConditon), entity.SAForm_level2.CON_Tyre_RRR_Status.ToString()) : string.Empty);

            replacements.Add("<%Tyre_IsContributory%>", (entity.SAForm_level2.CON_Tyre_IsContributory != null) ? (((bool)entity.SAForm_level2.CON_Tyre_IsContributory) ? "Yes" : "No") : null);
            replacements.Add("<%CSR_Consistency%>", (entity.SAForm_level1.OTH_CSR_Consistency != null) ? Enum.GetName(typeof(CSR_Consistency), entity.SAForm_level1.OTH_CSR_Consistency) : string.Empty);
            replacements.Add("<%Approx_RepairCost%>", getStringValue(entity.SAForm_level1.OTH_Approx_RepairCost));
            replacements.Add("<%SiteEstimation%>", entity.SAForm_level1.OTH_SiteEstimation != null ? Enum.GetName(typeof(OnSiteEstimation), entity.SAForm_level1.OTH_SiteEstimation) : string.Empty);
            //Other Fields
            replacements.Add("<%PossibleDR_Other%>", getStringValue(entity.SAForm_level2.DAM_PossibleDR_Other));
            replacements.Add("<%DamagedItems_Other%>", getStringValue(entity.SAForm_level2.DAM_DamagedItems_Other));
            replacements.Add("<%PreAccDamages_Other%>", getStringValue(entity.SAForm_level2.DAM_PreAccidentDamages_Other));

            replacements.Add("<%PreAccDamages%>", BuildUL(ComponentManager.GetComponantTree(entity.SAForm_level2.DAM_PreAccidentDamages), string.Empty));
            replacements.Add("<%DamagedItems%>", BuildUL(ComponentManager.GetComponantTree(entity.SAForm_level2.DAM_DamagedItems), string.Empty));
            replacements.Add("<%PossibleDR%>", BuildUL(ComponentManager.GetPossibleDR(entity.SAForm_level2.DAM_PossibleDR), string.Empty));

            //Process Vehicle classes
            StringBuilder vehicleClasses = new StringBuilder();

            if (entity.SAForm_level1.VAD_License_IsNew != null)
            {
                IEnumerable<short> ids = entity.SAForm_level1.SAForm_VehicleClasses.Select(x => x.VehicleClassId).ToList();

                foreach (short id in ids)
                {
                    if ((bool)entity.SAForm_level1.VAD_License_IsNew)
                    {
                        vehicleClasses.Append(Enum.GetName(typeof(NewLicenseVehClasses), id));
                        vehicleClasses.Append(",");
                    }
                    else
                    {
                        vehicleClasses.Append(Enum.GetName(typeof(OldLicenseVehClasses), id));
                        vehicleClasses.Append(",");
                    }
                }
            }
            if (vehicleClasses.Length > 0)
            {
                char finalchar = vehicleClasses[vehicleClasses.Length - 1];

                if (finalchar.Equals(','))
                    vehicleClasses = vehicleClasses.Remove(vehicleClasses.Length - 1, 1);
            }
            replacements.Add("<%VehicleClasses%>", vehicleClasses.ToString());

            return replacements;
        }

        /// <summary>Convert job entity values to dictionary list values.</summary>
        ///<param name="entity">Job Entity</param>
        ///<returns>
        ///ListDictionary containing the tags and it's values
        ///</returns>      
        /// <remarks>
        /// This result of this method is used for generating the body string of the email.
        /// The template is Content\templates\jobEmailTemplate.txt
        /// </remarks> 
        public static ListDictionary VisitToDictionaryValues(VisitEntity entity)
        {
            try
            {
                ListDictionary replacements = new ListDictionary();
                replacements.Add("<%JobNo%>", getStringValue(entity.JobNo));
                replacements.Add("<%TimeVisited%>", getStringValue(entity.TimeVisited));

                CommentEntity comment = entity.Comments.FirstOrDefault(x => x.User.Code != null);
                replacements.Add("<%Comment%>", (comment != null ? getStringValue(comment.Comment1) : string.Empty));
                replacements.Add("<%CSR_UserName%>", getStringValue(entity.User.aspnet_Users.UserName));
                replacements.Add("<%TimeSubmitted%>", getStringValue(entity.CreatedDate));
                replacements.Add("<%SubmissionType%>", Enum.GetName(typeof(VisitType), entity.VisitType));
                return replacements;
            }
            catch (Exception)
            {
                throw new GenException(670, Resources.err_670_sys); ;
            }
        }

        /// <summary>get string value of any job field. This is used by ModelToDictionaryValues() for email purposes.</summary>
        /// <param name="jobfield"> any job field</param>
        ///<returns>
        ///string value of any field.
        ///</returns>      
        /// <remarks>
        /// This is the inverse of getInnerTextMethod
        /// </remarks> 
        private static string getStringValue(object jobfield)
        {
            if (jobfield == null)
            {
                return string.Empty;
            }
            else
            {
                return jobfield.ToString();
            }
        }

        #endregion

        #region Send Email

        ///<summary>Send Email</summary>
        ///<param name="jobEntity">Job Entity</param>
        ///<param name="hasImages">Whether Images have been attached</param>
        /// <remarks></remarks> 
        [NonAction]
        internal void SendVisitEmail(VisitEntity entity, bool hasImages)
        {
            try
            {
                logevt.Info("Inside method SendVisitEmail - JobController");
                System.Net.Mail.MailMessage message = this.CreateVisitMessage(entity);

                //if job has images attach them.
                if (hasImages)
                {
                    this.AttachVisitImages(message, entity);
                }
                message.IsBodyHtml = true;
                logevt.Info("email body : " + message);

                logevt.Info("start sending email - JobController");
                //start sending email from a separate thread
                EmailUtils e = new EmailUtils(message);
                Thread thread = new Thread(new ThreadStart(e.SendEmail));
                thread.Start();
            }
            catch (Exception ex)
            {
                //log.Error(LogPoint.Failure.ToString() + ",SendEmail," + User.Identity.Name + ",JobNo=" + jobEntity.JobNo + "," + ex.Message);
            }
        }

        ///<summary>Create Job message for the email body</summary>
        ///<param name="jobEntity">Job Entity</param>
        /// <remarks></remarks> 
        [NonAction]
        private MailMessage CreateVisitMessage(VisitEntity entity)
        {
            logevt.Info("Inside method CreateVisitMessage - JobController");
            try
            {
                ListDictionary replacements;
                MailDefinition mail = CreateMailDefinition(entity);
                logevt.Info("entity.VisitType : " + entity.VisitType);
                if (entity.VisitType == 0)
                {
                    replacements = SAToDictionaryValues(entity);

                }
                else
                {
                    //For Visits
                    replacements = VisitToDictionaryValues(entity);
                }
                logevt.Info("Creating mail message");
                logevt.Info("PrimaryEmail : " + entity.User.PrimaryEmail);
                System.Net.Mail.MailMessage message = mail.CreateMailMessage(entity.User.PrimaryEmail, replacements, new System.Web.UI.Control());
                return message;
            }
            catch (Exception e)
            {
                logerr.Error("Error occurred in CreateVisitMessage in JobController");
                logerr.Error(e.Message);
                logerr.Info(e.Message);
                return new MailMessage();
            }
        }

        private MailDefinition CreateMailDefinition(VisitEntity entity)
        {
            MailDefinition mail = new MailDefinition();
            mail.From = ApplicationSettings.SmtpEmailUsername;

            string subject = string.Empty;
            string fileName = string.Empty;

            if (entity.VisitType == 0)
            {
                fileName = "SAEmail.txt";//TODO: Add to config
                subject = "Job Details of " + entity.JobNo;//TODO: Add to config
            }
            else
            {
                fileName = "VisitEmail.txt";//TODO: Add to config
                subject = "Visit Details of " + entity.JobNo;//TODO: Add to config
            }

            mail.BodyFileName = "~/Lang/Templates/" + CultureInfo.CurrentCulture.TwoLetterISOLanguageName + "/" + fileName;//TODO:Get path from configuration file or resource file.
            mail.Subject = subject;

            return mail;
        }

        [NonAction]
        private void AttachVisitImages(System.Net.Mail.MailMessage message, VisitEntity entity)
        {
            try
            {
                using (MotorClaimEntities entities = DataObjectFactory.CreateContext())
                {
                    //get image path list
                    List<string> lstImagePaths = (from d in entities.ImageGalleryEntities
                                                  where d.VisitId == entity.VisitId
                                                  select d.ImagePath).ToList();

                    if (lstImagePaths != null && lstImagePaths.Count > 0)
                    {
                        foreach (var path in lstImagePaths)
                        {
                            if (System.IO.File.Exists(ApplicationSettings.ImageGalleryPath + path))
                            {
                                Attachment attachment = new Attachment(ApplicationSettings.ImageGalleryPath + path);
                                message.Attachments.Add(attachment);
                            }
                        }
                    }
                    logevt.Info(LogPoint.Success.ToString() + ",SendEmail-AttachImages," + User.Identity.Name + ",[Params=(Job No:" + entity.JobNo + ")]");
                }
            }
            catch (Exception ex)
            {
                //log On Exception
                logerr.Error(LogPoint.Failure.ToString() + ",SendEmail-AttachImages," + User.Identity.Name + "," + ex.Message + ",[Params=(Job No:" + entity.JobNo + ")]");
            }
        }

        [NonAction]
        public static string BuildUL(List<com.IronOne.SLIC2.Models.Vehicle.Component> componants, string input)
        {
            string output = input;
            for (int i = 0; i < componants.Count; i++)
            {
                bool isLast = i == componants.Count - 1 ? true : false;
                output += "<li";
                if (componants[i].Components != null && componants[i].Components.Count > 0)
                {
                    output += " class=\"expandable";
                    if (isLast)
                    {
                        output += " lastExpandable";
                    }
                    output += "\"><div class=\"hitarea expandable-hitarea";
                    if (isLast)
                    {
                        output += " lastExpandable-hitarea";
                    }
                    output += "\"></div>";
                }
                else
                {
                    if (isLast)
                    {
                        output += " class=\"last\"";
                    }
                    output += ">";
                }
                output += componants[i].Description;
                if (componants[i].Components != null && componants[i].Components.Count > 0)
                {
                    output += "<ul style=\"display: none;\">";
                    output = BuildUL(componants[i].Components, output);
                    output += "</ul>";
                }
                output += "</li>";
            }
            return output;
        }

        #endregion

        #endregion

        [HttpGet]
        [Authorize]
        public ActionResult TempDeleteJob()
        {
            logerr.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job," + User.Identity.Name);

            return GetFormatView("Job/TempDeleteJob.aspx");
        }

        /// <summary>Sends mail after job completion.</summary>
        /// <param name="JobNumber">Job Number</param>
        ///<returns>
        ///Job Entity
        ///</returns>
        ///<exception cref="">
        ///Job number cannot be null or empty
        ///job not found
        ///database errors
        /// </exception>        
        /// <remarks>This method is still not used in this project</remarks> 
        [HttpPost]
        [Authorize]
        public ActionResult TempDeleteJob(string JobNumber)
        {
            //logged on entry     
            logevt.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job - Post," + User.Identity.Name + ", [Params=( Job Number:" + JobNumber + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");

            try
            {
                //check parameter if valid
                if (String.IsNullOrEmpty(JobNumber))
                {
                    throw new GenException(956, "Please enter job number");
                }

                using (MotorClaimEntities context = DataObjectFactory.CreateContext())
                {
                    // The columns are set to "SQL_Latin1_General_CP1_CI_AS" Collation by default which is case insensitive

                    /* That's because you are using LINQ To Entities which is ultimately convert your Lambda Expressions into 
                     * SQL statements. That means the case sensitivity is at the mercy of your SQL Server which by default has 
                     * SQL_Latin1_General_CP1_CI_AS Collation and that is NOT case sensitive. 
                     Refer article http://stackoverflow.com/questions/3843060/linq-to-entities-case-sensitive-comparison
                     */
                    JobNumber = JobNumber.Trim();

                    // Get the SA FORM
                    VisitEntity entity = (from j in context.VisitEntities
                                          where j.JobNo == JobNumber && (j.Info1 != "d" || j.Info1 == null)/* Remove deleted ones*/
                                          && j.VisitType == 0
                                          select j).FirstOrDefault();

                    //Get visits for the job
                    int visitsCount = (from j in context.vw_Visits
                                       where j.JobNo == JobNumber
                                       && j.VisitType != 0
                                       select j).Count();

                    if (entity == null)
                    {
                        throw new GenException(622, "Job " + JobNumber + " not found.");
                    }

                    //TODO: Set a  time threshold value!!!
                    //if (entity.ImageCount != 0 && entity.ImageGalleries.Count == 0 && visitsCount == 0)
                    if (entity.ImageCount != 0 && (entity.ImageGalleries.Count < entity.ImageCount) && visitsCount == 0)/*Allow to delete even jobs which are in progress*/
                    {
                        //Set Deleted Flag
                        entity.Info1 = "d";
                        //entity.UpdatedDate = DateTime.Now.Date;
                        entity.UpdatedDate = DateTime.Now;
                        entity.UpdatedBy = GetLoggedUserDetail().Id;
                        context.SaveChanges();

                        ViewData["SuccessMsg"] = "Job " + JobNumber + " has been successfully deleted.";
                    }
                    else
                    {
                        throw new GenException(623, "Job " + JobNumber + " cannot be deleted. This job is completed or on progress. Please contact the CSR user.");
                    }

                    //logged on success                  
                    logevt.Info(LogPoint.Success.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job - Post," + User.Identity.Name + ", [Params=( Job Number:" + JobNumber + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                }
            }
            catch (GenException ex)
            {
                ModelState.AddModelError("err", ex);
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Job Number:" + JobNumber + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                // auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            catch (SqlException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Job Number:" + JobNumber + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                //   auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            catch (EntityException ex)
            {
                ModelState.AddModelError("err", new GenException(900, Resources.err_900));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Job Number:" + JobNumber + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                //   auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("err", new GenException(901, Resources.err_901));
                logerr.Error(LogPoint.Failure.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Temp Delete Job - Post," + User.Identity.Name + "," + ex.Message + ",Stack Trace:" + ex.StackTrace + ", [Params=( Job Number:" + JobNumber + ",Client IP:" + Request.ServerVariables["REMOTE_ADDR"] + ")]");
                //   auditLogger.AddEvent(LogPoint.Failure.ToString(), ex.Message, "UserName=" + model.UserName + ",ReturnUrl=" + returnUrl);
            }

            return GetFormatView("Job/TempDeleteJob.aspx");
            //return View();
        }


       
    }
}
