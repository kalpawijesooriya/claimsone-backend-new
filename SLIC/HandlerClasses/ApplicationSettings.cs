using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using com.IronOne.SLIC2.Lang;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.HandlerClasses
{
    public static class ApplicationSettings
    {
        #region Configurition Key Constants

        #region Page sizes & List size Settings Constants

        private static readonly string SEARCH_RESULT_PAGE_SIZE = "page_size";
        private static readonly string DEFAULT_PASSWORD = "resetPassword_defaultValue";
        private static readonly string DEFAULT_DATEONLY_FORMAT = "dateOnlyFormat";
        private static readonly string DEFAULT_DATETIME_FORMAT = "dateTimeFormat";

        #endregion

        #region Application Settings Constants

        private static readonly string IMAGE_GALLERY_PATH = "image_gallery_path";
        private static readonly string DAMAGED_ITEMS_XML_PATH = "damagedItemsXML";
        private static readonly string SUPPORTINFO_EMAIL = "supportInfo_email";
        private static readonly string SUPPORTINFO_PHONE = "supportInfo_phone";
        private static readonly string TEMPPRINTING_PERIOD = "tempPrinting_period";
        private static readonly string MAX_SYSTEM_ADMINS = "max_system_admins";
        //Email
        private static readonly string SMTP_HOST = "smtp_host";
        private static readonly string SMTP_PORT = "smtp_port";
        private static readonly string SMTP_EMAIL_USERNAME = "smtp_email_username";
        private static readonly string SMTP_EMAIL_PASSWORD = "smtp_email_password";
        private static readonly string SMTP_CLIENT_TIMEOUT = "smtp_client_timeout";
        //Diagnosis
        private static readonly string DATABASE_IP = "database_IP";
        private static readonly string PING_TIMEOUT = "ping_timeOut";

        #endregion

        public static string CurrentWebVersion = "Current Web Version";
        public static string MinimumSupportedAppVersion = "Minimum Supported App Version";
        public static string LatestAppVersioninGooglePlay = "Latest App Version in Google Play";
        public static string GooglePlayAppURL = "Google Play App URL";
        public static string ForceLatestVersionToUsers = "Force Latest Version To Users";
        public static string MaximumAllowedDraftsCount = "Maximum Allowed Drafts Count";

        //Common User Settins
        public static string COMMON_USER_USERNAME = "common_user_username";
        public static string COMMON_USER_PASSWORD = "common_user_password";
        public static string COMMON_USER_ACCESSCODE = "common_user_accesscode";

        #region Product Settings

        //E.g: product version     
        //private static readonly string WEBAPP_VERSION = "webApp_version";
        //private static readonly string MINTABAPP_VERSION = "minTabApp_version";
        private static readonly string COOPERATEID = "cooperateId";
        private static readonly string SERVERID = "serverId";
        #endregion

        #region UIStrings Constants

        private static readonly string JOB_MORE_UISTRING =
                        "<div class=\"btn-group btn-group-grid\">" +
                        "<a class=\"btn dropdown-toggle btn-small\" data-toggle=\"dropdown\" href=\"\">" +
                        "<i class=\"icon-cog\">&nbsp;</i><span class=\"caret\"></span>" +
                        "</a>" +
                        "<ul class=\"dropdown-menu pull-right\">" +
            //Elements come here
                        "<li><a class=\"jobAccesslog\">" + Resources.info_gen_accesslog + "</a></li>" +
                         "<li><a class=\"printJob\">" + "Print Record" + "</a></li>" +
                         "<li><a class=\"printJobWithImages\">" + "View Record" + "</a></li>" +
                        "<li><a class=\"viewsaform\">" + "SA Form Details View" + "</a></li>" +
                        "<li><a>" + "Visits View" + "</a></li>" +

                        "<li class=\"dropdown\">" +
                        "<a class=\"donothing\">" + "<i class=\"icon-chevron-left sub-menu-caret\"></i>" + "Images" + "</a>" +
                        "<ul class=\"dropdown-menu sub-menu\">" +
                                "<li><a class=\"saclaimform\">SA Claim Form Images</a></li>" +
                                "<li><a class=\"accidentimages\">SA Accident Images</a></li>" +
                                "<li><a class=\"visitinspection\">Visit Inspection Images</a></li>" +
            //"<li><a href=\"\">Dropdown #4</a></li>" +
                        "</ul></li>" +
            //"<li><a href=\"\">Something else here</a></li>"+
            //Elements End here
                        "</ul></div>";

        private static readonly string VISIT_MORE_UISTRING =
                        "<div class=\"btn-group btn-group-grid\">" +
                        "<a class=\"btn dropdown-toggle btn-small\" data-toggle=\"dropdown\" href=\"\">" +
                        "<i class=\"icon-cog\">&nbsp;</i><span class=\"caret\"></span>" +
                        "</a>" +
                        "<ul class=\"dropdown-menu pull-right\">" +
            //Elements come here
                        "<li><a class=\"visitAccesslog\">" + Resources.info_gen_accesslog + "</a></li>" +
                        "<li><a>" + "Visit Details View" + "</a></li>" +
                        "<li><a class=\"inspectionimages\">Visit Inspection Images</a></li>" +
                        "<li><a class=\"printVisit\">Print Record</a></li>" +
            //Elements End here
                        "</ul></div>";

        //For Common Users accessing from external application
        private static readonly string VISIT_MORE_UISTRING_EXTERNAL =
                        "<div class=\"btn-group btn-group-grid\">" +
                        "<a class=\"btn dropdown-toggle btn-small\" data-toggle=\"dropdown\" href=\"\">" +
                        "<i class=\"icon-cog\">&nbsp;</i><span class=\"caret\"></span>" +
                        "</a>" +
                        "<ul class=\"dropdown-menu pull-right\">" +
            //Elements come here                        
                        "<li><a>" + "Visit Details View" + "</a></li>" +
                        "<li><a class=\"ViewVisit\">View Record</a></li>" +
                        "<li><a class=\"printVisit\">Print Record</a></li>" +
            //Elements End here
                        "</ul></div>";

        #endregion
        #endregion

        #region Page sizes & List size Settings Constants

        /// <summary>
        /// Pagination in search results
        /// </summary>
        public static int SearchResultPageSize
        {
            get { return GetAppSettingsIntParamValue(SEARCH_RESULT_PAGE_SIZE); }
        }

        public static string GetDefaultPassword
        {
            get { return GetAppSettingsStringParamValue(DEFAULT_PASSWORD); }
        }

        public static string GetDateOnlyFormat
        {
            get { return GetAppSettingsStringParamValue(DEFAULT_DATEONLY_FORMAT); }
        }

        public static string GetDateTimeFormat
        {
            get { return GetAppSettingsStringParamValue(DEFAULT_DATETIME_FORMAT); }
        }

        #endregion

        #region Application Settings
        //E.g: Email
        /// <summary>
        /// image gallery saved path
        /// </summary>
        public static string ImageGalleryPath
        {
            get { return GetAppSettingsStringParamValue(IMAGE_GALLERY_PATH); }
        }

        public static string DamagedItemsXMLPath
        {
            get { return GetAppSettingsStringParamValue(DAMAGED_ITEMS_XML_PATH); }
        }

        public static string SupportInfoEmail
        {
            get { return GetAppSettingsStringParamValue(SUPPORTINFO_EMAIL); }
        }

        public static string SupportInfoPhone
        {
            get { return GetAppSettingsStringParamValue(SUPPORTINFO_PHONE); }
        }

        public static int TempPrintingPeriod
        {
            get { return GetAppSettingsIntParamValue(TEMPPRINTING_PERIOD); }
        }

        public static int MaxAllowedSystemAdmins
        {
            get { return GetAppSettingsIntParamValue(MAX_SYSTEM_ADMINS); }
        }

        public static string SmtpHost
        {
            get { return GetAppSettingsStringParamValue(SMTP_HOST); }
        }

        public static int SmtpPort
        {
            get { return GetAppSettingsIntParamValue(SMTP_PORT); }
        }

        public static string SmtpEmailUsername
        {
            get { return GetAppSettingsStringParamValue(SMTP_EMAIL_USERNAME); }
        }

        public static string SmtpEmailPassword
        {
            get { return GetAppSettingsStringParamValue(SMTP_EMAIL_PASSWORD); }
        }

        public static string SmtpClientTimeout
        {
            get { return GetAppSettingsStringParamValue(SMTP_CLIENT_TIMEOUT); }
        }

        public static string DatabaseIP
        {
            get { return GetAppSettingsStringParamValue(DATABASE_IP); }
        }

        public static int PingTimeout
        {
            get { return GetAppSettingsIntParamValue(PING_TIMEOUT); }
        }

        public static string GetJqueryDateOnlyFormat
        {
            get
            {
                try
                {
                    string format = ApplicationSettings.GetDateOnlyFormat;// ConfigurationManager.AppSettings["dateOnlyFormat"];
                    string dateFormat = "";

                    switch (format)
                    {
                        #region Using "d" (Special Case)
                        case "d":
                            dateFormat = "m/dd/yy";
                            return dateFormat;
                        #endregion

                        #region Using "/"
                        case "dd/MMM/yy":
                            dateFormat = "dd/M/y";
                            return dateFormat;

                        case "M/dd/yyyy":
                            dateFormat = "m/dd/yy";
                            return dateFormat;

                        case "M/d/yy":
                            dateFormat = "m/d/y";
                            return dateFormat;

                        case "MM/dd/yy":
                            dateFormat = "mm/dd/y";
                            return dateFormat;

                        case "MM/dd/yyyy":
                            dateFormat = "mm/dd/yy";
                            return dateFormat;

                        case "yy/MM/dd":
                            dateFormat = "y/mm/dd";
                            return dateFormat;

                        case "yyyy/MM/dd":
                            dateFormat = "yy/mm/dd";
                            return dateFormat;
                        #endregion

                        #region Using "-"
                        case "dd-MMM-yy":
                            dateFormat = "dd-M-y";
                            return dateFormat;

                        case "M-dd-yyyy":
                            dateFormat = "m-dd-yy";
                            return dateFormat;

                        case "M-d-yy":
                            dateFormat = "m-d-y";
                            return dateFormat;

                        case "MM-dd-yy":
                            dateFormat = "mm-dd-y";
                            return dateFormat;

                        case "MM-dd-yyyy":
                            dateFormat = "mm-dd-yy";
                            return dateFormat;

                        case "yy-MM-dd":
                            dateFormat = "y-mm-dd";
                            return dateFormat;

                        case "yyyy-MM-dd":
                            dateFormat = "yy-mm-dd";
                            return dateFormat;
                        #endregion
                    }

                    //this is a rare case, will not execute most of the time
                    //if swithch fails this format will return

                    dateFormat = "mm/dd/y";
                    return dateFormat;
                }
                catch (Exception)
                {
                    //if something went wrong this will be used as
                    //a default format of the date
                    return "mm/dd/y";  //MM/DD/YY
                }
            }
        }

        public static string CommonUserUsername
        {
            get { return GetAppSettingsStringParamValue(COMMON_USER_USERNAME); }
        }

        public static string CommonUserPassword
        {
            get { return GetAppSettingsStringParamValue(COMMON_USER_PASSWORD); }
        }

        public static string CommonUserAccessCode
        {
            get { return GetAppSettingsStringParamValue(COMMON_USER_ACCESSCODE); }
        }

        #endregion

        #region Product Settings
        //E.g: version
        /// <summary>
        /// image gallery saved path
        /// </summary>
        public static string WebAppVersion
        {
            get { return GetAppSettingsStringParamValueFromDb(CurrentWebVersion); }
        }

        public static string MinTabVersion
        {
            get { return GetAppSettingsStringParamValueFromDb(MinimumSupportedAppVersion); }
        }

        public static string LatestAppVerInGooglePlay
        {
            get { return GetAppSettingsStringParamValueFromDb(LatestAppVersioninGooglePlay); }
        }

        public static string ForceLatestVerToUsers
        {
            get { return GetAppSettingsStringParamValueFromDb(ForceLatestVersionToUsers); }
        }

        public static string GooglePlay_AppURL
        {
            get { return GetAppSettingsStringParamValueFromDb(GooglePlayAppURL); }
        }

        public static string CooperateId
        {
            get { return GetAppSettingsStringParamValue(COOPERATEID); }
        }

        public static string ServerId
        {
            get { return GetAppSettingsStringParamValue(SERVERID); }
        }

        #endregion

        #region UIStrings

        public static string JobMore_UIString
        {
            get { return JOB_MORE_UISTRING; }
        }

        public static string VisitMore_UIString
        {
            get { return VISIT_MORE_UISTRING; }
        }

        public static string VisitMoreExternal_UIString
        {
            get { return VISIT_MORE_UISTRING_EXTERNAL; }
        }

        #endregion

        #region Util

        /// <summary>
        /// Common method to get String param values
        /// </summary>
        /// <param name="appSettingParam"></param>
        /// <returns></returns>
        private static string GetAppSettingsStringParamValue(string appSettingParam)
        {
            if (ConfigurationManager.AppSettings[appSettingParam] == null)
                throw new ApplicationException(string.Format("{0} is not defined in the configuration file", appSettingParam));

            return ConfigurationManager.AppSettings[appSettingParam];
        }

        private static string GetAppSettingsStringParamValueFromDb(string appSettingParam)
        {
            using (MotorClaimEntities context = DataObjectFactory.CreateContext())
            {
                SettingEntity entity1 = context.SettingEntities.SingleOrDefault(br => br.SettingName.Equals(appSettingParam));
                return (entity1 != null) ? entity1.SettingValue : "";
            }
        }

        /// <summary>
        /// Common method to get int param values
        /// </summary>
        /// <param name="appSettingParam"></param>
        /// <returns></returns>
        private static int GetAppSettingsIntParamValue(string appSettingParam)
        {
            if (ConfigurationManager.AppSettings[appSettingParam] == null)
                throw new ApplicationException(string.Format("{0} is not defined in Config file", appSettingParam));

            return int.Parse(ConfigurationManager.AppSettings[appSettingParam]);
        }

        /// <summary>
        /// Common method to get double param values
        /// </summary>
        /// <param name="appSettingParam"></param>
        /// <returns></returns>
        private static double GetAppSettingsDoubleParamValue(string appSettingParam)
        {
            if (ConfigurationManager.AppSettings[appSettingParam] == null)
                throw new ApplicationException(string.Format("{0} is not defined in Config file", appSettingParam));

            return double.Parse(ConfigurationManager.AppSettings[appSettingParam]);
        }

        /// <summary>
        /// Common method to get double param values
        /// </summary>
        /// <param name="appSettingParam"></param>
        /// <returns></returns>
        private static bool GetAppSettingsBooleanParamValue(string appSettingParam)
        {
            if (ConfigurationManager.AppSettings[appSettingParam] == null)
                throw new ApplicationException(string.Format("{0} is not defined in Config file", appSettingParam));

            return bool.Parse(ConfigurationManager.AppSettings[appSettingParam]);
        }

        #endregion


    }
}