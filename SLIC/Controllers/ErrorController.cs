using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.EnterpriseServices;
using com.IronOne.SLIC2.Lang;
using com.IronOne.SLIC2.Models.Enums;

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
    public class ErrorController : BaseController
    {
	
		#region Actions

        /// <summary>
        /// general errors
        /// </summary>
        /// <param name="exception">Exception details</param>
        /// <returns>Shared/ErrorView.aspx</returns>
        [Description("General")]
        public ActionResult General(Exception exception)
        {
            auditLogger.AddEvent(LogPoint.Failure.ToString(), exception.ToString(), string.Empty);
            return View("~/Views/HTML/Errors/Error.aspx");
        }

        /// <summary>
        /// Suren Manawatta
        /// 2012-12-05
        /// Common Error Action
        /// </summary>
        /// <returns>Shared/Errors/HttpError.aspx</returns>
        //[Authorize]
        [Description("Http Error")]
        public ActionResult HttpError()
        {
            string errCode = ControllerContext.RouteData.Values["errCode"].ToString();
            string heading = "";
            string body = "";
            string preBody = Resources.info_gen_errorOccurred;

            if (errCode == "500")
            {
                heading = Resources.info_error500_heading;
                body = preBody + Resources.info_gen_tryAgainLater;
            } 
            else
            {
                heading = Resources.ResourceManager.GetString("info_error" + errCode + "_heading");
                body = preBody + Resources.ResourceManager.GetString("info_error" + errCode + "_body");
            }
            
            dynamic model = new System.Dynamic.ExpandoObject();
            model.heading = heading;
            model.body = body;

            auditLogger.AddEvent(LogPoint.Failure.ToString(), body, "ErrCode=" + errCode);
            //TODO:Add to a model and send to the view
            return View("~/Views/HTML/Errors/HttpError.aspx", model);
        }
              
		#endregion 
    }
}
