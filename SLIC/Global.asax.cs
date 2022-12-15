using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using com.IronOne.SLIC2.Controllers;

namespace com.IronOne.SLIC2
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Default", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );

        }

        protected void Application_Start()
        {
            log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo(Server.MapPath("log4net.xml")));
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }

        /// <summary>
        /// Suren Manawatta
        /// 2012-12-05
        /// //Catch Http Errors and redirect to HttpError action in the errors controller // Param: HttpErrorCode
        /// </summary>
        //protected void Application_Error()
        //{
        //    Exception exception = Server.GetLastError();

        //    int errCode = 0;
        //    if (exception.GetType().IsAssignableFrom(typeof(HttpException)))
        //    {
        //        HttpException httpException = (HttpException)exception;
        //        errCode = httpException.GetHttpCode();
        //    }
        //    else
        //    {
        //        errCode = 500;
        //    }

        //    Response.Clear();
        //    Server.ClearError();

        //    var routeData = new RouteData();
        //    routeData.Values["controller"] = "Error";
        //    routeData.Values["action"] = "HttpError";
        //    routeData.Values["errCode"] = errCode;
        //    Response.StatusCode = errCode;
        //    IController controller = new ErrorController();
        //    var rc = new RequestContext(new HttpContextWrapper(Context), routeData);
        //    controller.Execute(rc);
        //}
    } 
}