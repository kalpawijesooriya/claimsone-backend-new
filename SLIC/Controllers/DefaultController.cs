/***************************************************************************/
/// <summary>
/// 
///  <title>SLIC DefaultController</title>
///  <description>DefaultController for Home page and Index</description>
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
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.EnterpriseServices;

#region SLICReferences
using com.IronOne.SLIC2.Models.Enums;
#endregion SLICReferences

#region ThirdPartyReferences
using log4net;
using System.Collections.Specialized;
using System.Web.UI.DataVisualization.Charting;
using System.IO;
using System.Drawing;
using SLIC.Models.Reports;
using com.IronOne.SLIC2.Models.Administration;
using com.IronOne.SLIC2.Models.Reports;
using com.IronOne.SLIC2.Models.Job;
#endregion ThirdPartyReferences

namespace com.IronOne.SLIC2.Controllers
{
    public class DefaultController : BaseController
    {
        //  protected static readonly ILog log = LogManager.GetLogger("root");
        protected static readonly ILog log = LogManager.GetLogger("EventLog");
        //
        // GET: /Default1/

        /// <summary>Direct to Home page </summary>
        /// <param name="fmt">Format of the Request</param>
        ///<returns>
        ///Direct to home page
        ///</returns>      
        /// <remarks></remarks> 
        [Description("Index")]
        public ActionResult Index(string fmt)
        {
            log4net.Config.XmlConfigurator.Configure();
            log.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",Default Index," + User.Identity.Name);

            /*ViewData["Welcome"] = "";
            try
            {
                string greeting = "";
                if (DateTime.Now.Hour < 12)
                    greeting = "Good morning";
                else if (DateTime.Now.Hour < 17)
                    greeting = "Good afternoon";
                else
                    greeting = "Good evening";

                var user = GetLoggedUserDetail();
                ViewData["Welcome"] = greeting + " " + user.FirstName + ",";
            }
            catch (Exception)
            {                
            }*/
            var user = GetUser();
            if ((user.RoleName == "Common User"))
            {
                return RedirectToAction("SearchResultsExternal", "External");
            }

            return GetFormatView("Home/Home.aspx");
        }

        /// <summary>Direct to Home page </summary>
        /// <param name="fmt">Format of the Request</param>
        ///<returns>
        ///Direct to home page
        ///</returns>      
        /// <remarks></remarks> 
        [Description("Index2")]
        public ActionResult Index2(string fmt)
        {          
            return GetFormatView("Home/Home.aspx");
        }
               

        /// <summary>
        /// shows inquery reports
        /// </summary>
        /// <returns></returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Authorize]
        [Description("Report Inquiry")]
        public ActionResult ReportInquery()
        {
            log.Info(LogPoint.Entry.ToString() + "," + this.ControllerContext.Controller.ToString() + ",On Authorization," + User.Identity.Name);

            InqueryModel model = new InqueryModel();

            //adding dummy values to the branch code/name list
            List<SelectListItem> branchList = new List<SelectListItem>();
            branchList.Add(new SelectListItem
            {
                Text = "Branch 1",
                Value = "1",
                Selected = true
            }
            );
            branchList.Add(new SelectListItem
            {
                Text = "Branch 2",
                Value = "2",
            }
            );
            branchList.Add(new SelectListItem
            {
                Text = "Branch 3",
                Value = "3",
            }
            );
            ViewData["Branches"] = branchList;

            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = "Region 1",
                Value = "1",
                Selected = true
            }
            );
            regionList.Add(new SelectListItem
            {
                Text = "Region 2",
                Value = "2"
            }
            );
            regionList.Add(new SelectListItem
            {
                Text = "Region 3",
                Value = "3"
            }
            );
            ViewData["Regions"] = regionList;


            return GetFormatView("Reports/ReportInquery.aspx", model);

        }

        [Description("Access Logs")]
        public ActionResult AccessLogs()
        {
            AccessLogModel model = new AccessLogModel();

            List<SelectListItem> branchList = new List<SelectListItem>();
            branchList.Add(new SelectListItem
            {
                Text = "All",
                Value = "",
                Selected = true
            });
            ViewData["Branches"] = branchList;

            List<SelectListItem> regionList = new List<SelectListItem>();
            regionList.Add(new SelectListItem
            {
                Text = "Select a region",
                Value = "",
                Selected = true
            });
            regionList.AddRange(ConvertRegionsToSelectList(JobController.GetRegionDataList()));
            ViewData["Regions"] = regionList;

            return GetFormatView("Reports/AccessLogs.aspx", model);
        }

        //To be implemented
        [Description("Advanced Access Logs Ajax Handler")]
        public ActionResult AdvancedAccessLogsAjaxHandler(JQueryDataTableParamModel param, AccessLogModel model)
        {
            int totalCount = 0;
            List<String[]> jsonData = new List<string[]>();

            try { 
            
            
            }
            catch (GenException ex)
            {
                //log on exception
                ModelState.AddModelError("err", ex);

            }
            catch (Exception ex)
            { 
                //log on exception
                ModelState.AddModelError("err", new GenException(111, ex.Message));
            }
            return Json(new
            {
                sEcho = param.sEcho,
                iTotalRecords = totalCount,
                iTotalDisplayRecords = totalCount,
                aaData = jsonData.Skip(param.iDisplayStart).Take(param.iDisplayLength)
            },
        JsonRequestBehavior.AllowGet);


        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="chartType"></param>
        /// <returns></returns>
        /// <exception cref=""></exception>
        /// <remarks></remarks>
        [Description("Create Chart")]
        public FileResult CreateChart(SeriesChartType chartType)
        {
            IList<ResultModel> peoples = GetResults();
            Chart chart = new Chart();
            chart.Width = 1150;
            chart.Height = 500;
            chart.BackColor = Color.FromArgb(255, 255, 255);
            chart.BorderlineDashStyle = ChartDashStyle.Solid;
            chart.BackSecondaryColor = Color.White;
            chart.BackGradientStyle = GradientStyle.TopBottom;
            chart.BorderlineWidth = 1;
            chart.Palette = ChartColorPalette.SemiTransparent;
            chart.BorderlineColor = Color.FromArgb(56, 56, 56);
            chart.RenderType = RenderType.BinaryStreaming;
            //chart.BorderSkin.SkinStyle = BorderSkinStyle.Emboss;
            chart.AntiAliasing = AntiAliasingStyles.All;
            chart.TextAntiAliasingQuality = TextAntiAliasingQuality.Normal;
            chart.Titles.Add(CreateTitle());
            chart.Legends.Add(CreateLegend());
            chart.Series.Add(CreateSeries(peoples, chartType));
            chart.ChartAreas.Add(CreateChartArea());

            MemoryStream ms = new MemoryStream();
            chart.SaveImage(ms);
            return File(ms.GetBuffer(), @"image/png");
        }

        [Description("Get Results")]
        private List<ResultModel> GetResults()
        {
            List<ResultModel> results = new List<ResultModel>();

            ResultModel r = new ResultModel();
            r.ID = "1";
            r.GPA = "420";
            results.Add(r);

            ResultModel r1 = new ResultModel();
            r1.ID = "2";
            r1.GPA = "220";
            results.Add(r1);

            ResultModel r2 = new ResultModel();
            r2.ID = "3";
            r2.GPA = "567";
            results.Add(r2);

            ResultModel r3 = new ResultModel();
            r3.ID = "4";
            r3.GPA = "298";
            results.Add(r3);

            ResultModel r4 = new ResultModel();
            r4.ID = "5";
            r4.GPA = "380";
            results.Add(r4);

            ResultModel r5 = new ResultModel();
            r5.ID = "6";
            r5.GPA = "420";
            results.Add(r5);

            ResultModel r6 = new ResultModel();
            r6.ID = "7";
            r6.GPA = "690";
            results.Add(r6);

            //for (int i = 0; i < 10; i++)
            //{
            //    ResultModel r = new ResultModel();
            //    r.ID = (i + 1).ToString();
            //    if (i != 5)
            //        r.GPA = ((i + 1) * (101 + (17 * i + 30))).ToString();
            //    else
            //        r.GPA = "420";
            //    results.Add(r);
            //}

            return results;
        }

        [Description("Create Title")]
        public Title CreateTitle()
        {
            Title title = new Title();
            title.Text = "Result Chart";
            //title.ShadowColor = Color.FromArgb(32, 0, 0, 0);
            title.Font = new Font("Trebuchet MS", 14F, FontStyle.Bold);
            //title.ShadowOffset = 3;
            title.ForeColor = Color.FromArgb(26, 59, 105);
            return title;
        }

        [Description("Create Legend")]
        public Legend CreateLegend()
        {
            Legend title = new Legend();
            title.Title = "Result Chart";
            // title.ShadowColor = Color.FromArgb(32, 0, 0, 0);
            title.Font = new Font("Trebuchet MS", 14F, FontStyle.Bold);
            //title.ShadowOffset = 3;
            title.ForeColor = Color.FromArgb(26, 59, 105);
            return title;
        }

        [Description("Create Series")]
        public Series CreateSeries(IList<ResultModel> results, SeriesChartType chartType)
        {
            Series seriesDetail = new Series();
            seriesDetail.Name = "Result Chart";
            seriesDetail.IsValueShownAsLabel = false;
            seriesDetail.Color = Color.FromArgb(26, 38, 49);
            seriesDetail.ChartType = chartType;
            seriesDetail.BorderWidth = 2;
            DataPoint point;

            foreach (ResultModel result in results)
            {
                point = new DataPoint();
                point.AxisLabel = result.ID;
                point.YValues = new double[] { double.Parse(result.GPA) };
                seriesDetail.Points.Add(point);
            }
            seriesDetail.ChartArea = "Result Chart";
            return seriesDetail;
        }

        [Description("Create Chart Area")]
        public ChartArea CreateChartArea()
        {
            ChartArea chartArea = new ChartArea();
            chartArea.Name = "Result Chart";
            chartArea.BackColor = Color.Transparent;
            chartArea.AxisX.IsLabelAutoFit = false;
            chartArea.AxisY.IsLabelAutoFit = false;
            chartArea.AxisX.LabelStyle.Font =
               new Font("Verdana,Arial,Helvetica,sans-serif",
                        8F, FontStyle.Regular);
            chartArea.AxisY.LabelStyle.Font =
               new Font("Verdana,Arial,Helvetica,sans-serif",
                        8F, FontStyle.Regular);
            chartArea.AxisY.LineColor = Color.FromArgb(64, 64, 64, 64);
            chartArea.AxisX.LineColor = Color.FromArgb(64, 64, 64, 64);
            chartArea.AxisY.MajorGrid.LineColor = Color.FromArgb(64, 64, 64, 64);
            chartArea.AxisX.MajorGrid.LineColor = Color.FromArgb(64, 64, 64, 64);
            chartArea.AxisX.Interval = 1;
            return chartArea;
        }
    }

    public class ResultModel
    {
        public string ID { get; set; }
        public string GPA { get; set; }
    }
}
