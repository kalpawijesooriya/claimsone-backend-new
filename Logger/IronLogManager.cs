using System.Diagnostics;
using System.Reflection;
using System.Data.SqlClient;
using System;
using System.Threading;
using System.Configuration;
using System.Xml;
using System.Collections.Generic;
using System.IO;
using System.Data;

namespace com.IronOne.Logger
{
    public interface ILogManager
    {
        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <returns></returns>
        void AddEvent(string EventStatus);
        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="Description">Entry Description</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        void AddEvent(string EventStatus, string Description, string Param);
        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="RefId">Reference ID of action.</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        void AddEvent(string EventStatus, int RefId, string Param);
        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="RefId">Reference ID of action.</param>
        /// <returns></returns>
        void AddEvent(string EventStatus, int RefId);
        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        void AddEvent(string EventStatus, string Param);
        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="Description">Entry Description</param>
        /// <param name="RefId">Reference ID of action.</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        void AddEvent(string EventStatus, string Description, int RefId, string Param);
        /// <summary>
        /// Get all log entries from Database
        /// </summary>
        /// <returns>XML string of log events</returns>
        string GetAllEvents();
        /// <summary>
        /// Get all log entries from Database
        /// </summary>
        /// <param name="ModuleName">Search string for Module Name</param>
        /// <param name="ActionName">Search string for Action Name</param>
        /// <param name="AccessType">Search string for Access Type</param>
        /// <param name="AccessIP">Search string for Access IP</param>
        /// <param name="UserName">Search string for User Name</param>
        /// <param name="EventStatus">Search string for Event Status</param>
        /// <param name="DateFrom">Search value for Date From</param>
        /// <param name="DateTo">Search value for Date To</param>
        /// <param name="Description">Search string for Description</param>
        /// <param name="Params">Search string for Parameters</param>
        /// <param name="OrderByCol">Order By Column</param>
        /// <param name="IsAscending">Is Ascending</param>
        /// <param name="StartIndex">Start Index of result set</param>
        /// <param name="PageSize">No. of items per page</param>
        /// <param name="TotalCount">Output variable Total item Count</param>
        /// <returns>object list of log events</returns>
        List<KeyValuePair<string, string>[]> GetEvents(string ModuleName, string ActionName, string AccessType, string AccessIP, string UserName, string EventStatus, DateTime? DateFrom, DateTime? DateTo, string Description, string Params, string ParamCol1, string ParamCol2, string ParamCol3, string ParamCol4, string ParamCol5, string ParamCol6, string ParamCol7, string ParamCol8, string ParamCol9, string ParamCol10, string OrderByCol, bool IsAscending, int StartIndex, int PageSize, out int TotalCount);
        /// <summary>
        /// Get log details from Database
        /// <param name="EventID">Event ID</param>
        /// </summary>
        /// <returns>Key Value array of log event</returns>
        KeyValuePair<string, string>[] GetLogItem(int EventID);
    }

    /// <summary>
    ///  <title></title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2012-02-22</createdOn>
    ///  <author>MadurangaG</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary>
    public class IronLogManager : ILogManager
    {

        #region Member Variables
        private string _connectionString = ConfigurationManager.ConnectionStrings["ApplicationServices"].ConnectionString;
        private int _userID = 0;
        private string _userName = string.Empty;
        private string _accessType = string.Empty;
        private string _accessIP = string.Empty;
        #endregion

        #region Properties
        #endregion

        #region Constructors

        /// <summary>
        ///  <description>The default Constructor.</description>
        ///  <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        ///  <param name="Description">Entry Description</param>
        ///  <param name="RefId">Reference ID of action.</param>
        ///  <param name="Param">Action Parameters</param>
        ///  <returns>
        ///  </returns>       
        ///  <exception>
        ///  </exception>
        ///  <remarks></remarks>
        /// </summary>
        public IronLogManager(int UserID, string UserName, string AccessType, string AccessIP)
        {
            _userID = UserID;
            _userName = UserName;
            _accessType = AccessType;
            _accessIP = AccessIP;
        }

        #endregion

        #region Functions

        #region PublicFunctions

        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <returns></returns>
        public void AddEvent(string EventStatus)
        {
            AddEvent(EventStatus, string.Empty, 0, string.Empty);
        }

        /// <summary>
        /// Create new logger instance.
        /// </summary>
        /// <param name="UserID">Loggin username.</param>
        /// <param name="AccessType">Login type. Ex: Web, Tab...</param>
        /// <param name="AccessIP">Client IP address</param>
        /// <returns>Logger Instance</returns>
        public static IronLogManager GetLogger(int UserID, string UserName, string AccessType, string AccessIP)
        {
            return new IronLogManager(UserID, UserName, AccessType, AccessIP);
        }

        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="Description">Entry Description</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        public void AddEvent(string EventStatus, string Description, string Param)
        {
            AddEvent(EventStatus, Description, 0, Param);
        }

        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="RefId">Reference ID of action.</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        public void AddEvent(string EventStatus, int RefId, string Param)
        {
            AddEvent(EventStatus, string.Empty, RefId, Param);
        }

        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="RefId">Reference ID of action.</param>
        /// <returns></returns>
        public void AddEvent(string EventStatus, int RefId)
        {
            AddEvent(EventStatus, string.Empty, RefId, string.Empty);
        }

        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        public void AddEvent(string EventStatus, string Param)
        {
            AddEvent(EventStatus, string.Empty, 0, Param);
        }

        /// <summary>
        /// Add Log entry to Database
        /// </summary>
        /// <param name="EventStatus">Event Status. Ex: Error, Info...</param>
        /// <param name="Description">Entry Description</param>
        /// <param name="RefId">Reference ID of action.</param>
        /// <param name="Param">Action Parameters</param>
        /// <returns></returns>
        public void AddEvent(string EventStatus, string Description, int RefId, string Param)
        {
            MethodBase methodBase = new StackTrace().GetFrame(1).GetMethod();
            if (methodBase.DeclaringType.Name.Equals(MethodBase.GetCurrentMethod().DeclaringType.Name))
            {
                methodBase = new StackTrace().GetFrame(2).GetMethod();
            }
            string actionName = methodBase.Name;
            try
            {
                //  methodBase.GetCustomAttributesData().Count

                foreach (CustomAttributeData item in methodBase.GetCustomAttributesData())
                {
                    if (item.ToString().Contains("DescriptionAttribute"))
                    {
                         //actionName = methodBase.GetCustomAttributesData()[0].ConstructorArguments[0].Value.ToString();
                        actionName = item.ConstructorArguments[0].Value.ToString();
                         break;
                    }
                }
                //actionName = methodBase.GetCustomAttributesData()[0].ConstructorArguments[0].Value.ToString();
            }
            catch (Exception)
            { }
            ThreadPool.QueueUserWorkItem(CreateLog, new string[] { methodBase.DeclaringType.Name, actionName, EventStatus, Description, RefId.ToString(), _userID.ToString(), _userName, _accessType, _accessIP, Param });
        }

        /// <summary>
        /// Get all log entries from Database
        /// </summary>
        /// <returns>XML string of log events</returns>
        public string GetAllEvents()
        {
            string document = string.Empty;
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    SqlCommand command = new SqlCommand()
                    {
                        CommandType = System.Data.CommandType.Text,
                        Connection = connection,
                        CommandText = "select * from dbo.vw_IronLogger_AuditLogs_GetLogs FOR XML AUTO, ELEMENTS"
                    };
                    connection.Open();
                    XmlReader xmlReader = command.ExecuteXmlReader();
                    xmlReader.Read();
                    document = "<?xml version=\"1.0\" encoding=\"utf-8\" ?><Events>";
                    while (xmlReader.ReadState != ReadState.EndOfFile)
                    {
                        document += xmlReader.ReadOuterXml();
                    }
                    document += "</Events>";
                    connection.Close();
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 208 || ex.Number == 2812)
                {
                    CreateDatasource();
                }
            }
            catch (Exception ex)
            {
                //   EventLog.WriteEntry("IronLogger", ex.ToString(), EventLogEntryType.Error);
            }
            return document;
        }

        /// <summary>
        /// Get all log entries from Database
        /// </summary>
        /// <param name="ModuleName">Search string for Module Name</param>
        /// <param name="ActionName">Search string for Action Name</param>
        /// <param name="AccessType">Search string for Access Type</param>
        /// <param name="AccessIP">Search string for Access IP</param>
        /// <param name="UserName">Search string for User Name</param>
        /// <param name="EventStatus">Search string for Event Status</param>
        /// <param name="DateFrom">Search value for Date From</param>
        /// <param name="DateTo">Search value for Date To</param>
        /// <param name="Description">Search string for Description</param>
        /// <param name="Params">Search string for Parameters</param>
        /// <param name="OrderByCol">Order By Column</param>
        /// <param name="IsAscending">Is Ascending</param>
        /// <param name="StartIndex">Start Index of result set</param>
        /// <param name="PageSize">No. of items per page</param>
        /// <param name="TotalCount">Output variable Total item Count</param>
        /// <returns>object list of log events</returns>
        public List<KeyValuePair<string, string>[]> GetEvents(string ModuleName, string ActionName, string AccessType, string AccessIP, string UserName, string EventStatus, DateTime? DateFrom, DateTime? DateTo, string Description, string Params, string ParamCol1, string ParamCol2, string ParamCol3, string ParamCol4, string ParamCol5, string ParamCol6, string ParamCol7, string ParamCol8, string ParamCol9, string ParamCol10, string OrderByCol, bool IsAscending, int StartIndex, int PageSize, out int TotalCount)
        {
            List<KeyValuePair<string, string>[]> eventObj = new List<KeyValuePair<string, string>[]>();
            TotalCount = 0;

            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    SqlCommand command = new SqlCommand()
                    {
                        CommandType = System.Data.CommandType.StoredProcedure,
                        Connection = connection,
                        CommandTimeout = 6000000, /* This value and SLIC2 project lang file's 'info_commandtimeout' are same */
                        CommandText = "dbo.IronLogger_AuditLogs_GetLogs"
                    };
                    command.Parameters.AddWithValue("@ModuleName", string.IsNullOrEmpty(ModuleName) ? string.Empty : ModuleName);
                    command.Parameters.AddWithValue("@ActionName", string.IsNullOrEmpty(ActionName) ? string.Empty : ActionName);
                    command.Parameters.AddWithValue("@AccessType", string.IsNullOrEmpty(AccessType) ? string.Empty : AccessType);
                    command.Parameters.AddWithValue("@AccessIP", string.IsNullOrEmpty(AccessIP) ? string.Empty : AccessIP);
                    command.Parameters.AddWithValue("@UserName", string.IsNullOrEmpty(UserName) ? string.Empty : UserName.Trim());
                    command.Parameters.AddWithValue("@EventStatus", string.IsNullOrEmpty(EventStatus) ? string.Empty : EventStatus);
                    command.Parameters.AddWithValue("@DateFrom", DateFrom);
                    command.Parameters.AddWithValue("@DateTo", DateTo);
                    command.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(Description) ? string.Empty : Description);
                    command.Parameters.AddWithValue("@Params", string.IsNullOrEmpty(Params) ? string.Empty : Params);
                    command.Parameters.AddWithValue("@ParaCol1", string.IsNullOrEmpty(ParamCol1) ? string.Empty : ParamCol1.Trim());
                    command.Parameters.AddWithValue("@ParaCol2", string.IsNullOrEmpty(ParamCol2) ? string.Empty : ParamCol2);
                    command.Parameters.AddWithValue("@ParaCol3", string.IsNullOrEmpty(ParamCol3) ? string.Empty : ParamCol3);
                    command.Parameters.AddWithValue("@ParaCol4", string.IsNullOrEmpty(ParamCol4) ? string.Empty : ParamCol4.Trim());
                    command.Parameters.AddWithValue("@ParaCol5", string.IsNullOrEmpty(ParamCol5) ? string.Empty : ParamCol5.Trim());
                    command.Parameters.AddWithValue("@ParaCol6", string.IsNullOrEmpty(ParamCol6) ? string.Empty : ParamCol6.Trim());
                    command.Parameters.AddWithValue("@ParaCol7", string.IsNullOrEmpty(ParamCol7) ? string.Empty : ParamCol7);
                    command.Parameters.AddWithValue("@ParaCol8", string.IsNullOrEmpty(ParamCol8) ? string.Empty : ParamCol8);
                    command.Parameters.AddWithValue("@ParaCol9", string.IsNullOrEmpty(ParamCol9) ? string.Empty : ParamCol9);
                    command.Parameters.AddWithValue("@ParaCol10", string.IsNullOrEmpty(ParamCol10) ? string.Empty : ParamCol10);
                    command.Parameters.AddWithValue("@orderByCol", string.IsNullOrEmpty(OrderByCol) ? "Module" : OrderByCol);
                    command.Parameters.AddWithValue("@isAscending", IsAscending ? 1 : 0);
                    command.Parameters.AddWithValue("@StartIndex", StartIndex < 1 ? 1 : StartIndex);
                    command.Parameters.AddWithValue("@pageSize", PageSize < 1 ? 10 : PageSize);
                    command.Parameters.Add("@rowCount", System.Data.SqlDbType.Int).Direction = System.Data.ParameterDirection.Output;

                    if (connection.State != ConnectionState.Open)
                    {
                        connection.Open();
                    }

                    SqlDataReader sqlReader = command.ExecuteReader();
                    KeyValuePair<string, string>[] eventItem;

                    while (sqlReader.Read())
                    {
                        eventItem = new KeyValuePair<string, string>[sqlReader.FieldCount];
                        for (int i = 0; i < sqlReader.FieldCount; i++)
                        {
                            eventItem[i] = new KeyValuePair<string, string>(sqlReader.GetName(i), sqlReader.GetValue(i).ToString());
                        }
                        eventObj.Add(eventItem);
                    }
                    if (connection.State != ConnectionState.Closed)
                    {
                        connection.Close();
                    }

                    TotalCount = int.Parse(command.Parameters["@rowCount"].Value.ToString());
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 208 || ex.Number == 2812)
                {
                    CreateDatasource();
                }
            }
            catch (Exception ex)
            {
                //   EventLog.WriteEntry("IronLogger", ex.ToString(), EventLogEntryType.Error);
            }

            return eventObj;
        }

        /// <summary>
        /// Get log details from Database
        /// <param name="EventID">Event ID</param>
        /// </summary>
        /// <returns>Key Value array of log event</returns>
        public KeyValuePair<string, string>[] GetLogItem(int EventID)
        {
            KeyValuePair<string, string>[] logItem = new KeyValuePair<string, string>[0];
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    SqlCommand command = new SqlCommand()
                    {
                        CommandType = System.Data.CommandType.StoredProcedure,
                        Connection = connection,
                        CommandText = "IronLogger_AuditLogs_GetLog"
                    };
                    command.Parameters.AddWithValue("@EventID", EventID);

                    connection.Open();
                    SqlDataReader sqlReader = command.ExecuteReader();
                    logItem = new KeyValuePair<string, string>[sqlReader.FieldCount];
                    while (sqlReader.Read())
                    {
                        for (int i = 0; i < sqlReader.FieldCount; i++)
                        {
                            logItem[i] = new KeyValuePair<string, string>(sqlReader.GetName(i), sqlReader.GetValue(i).ToString());
                        }
                    }
                    connection.Close();
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 208 || ex.Number == 2812)
                {
                    CreateDatasource();
                }
            }
            catch (Exception ex)
            { }
            return logItem;
        }

        #endregion

        #region PrivateFunctions

        private void CreateLog(object logData)
        {
            string[] dataArray = (string[])logData;
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    SqlCommand command = new SqlCommand()
                    {
                        CommandType = System.Data.CommandType.StoredProcedure,
                        Connection = connection,
                        CommandText = "dbo.IronLogger_AuditLogs_AddLog"
                    };
                    command.Parameters.AddWithValue("module", dataArray[0]);
                    command.Parameters.AddWithValue("action", dataArray[1]);
                    command.Parameters.AddWithValue("eventStatus", dataArray[2]);
                    command.Parameters.AddWithValue("desciption", dataArray[3]);
                    command.Parameters.AddWithValue("refId", dataArray[4]);
                    command.Parameters.AddWithValue("userID", dataArray[5]);
                    command.Parameters.AddWithValue("userName", dataArray[6]);
                    command.Parameters.AddWithValue("accessType", dataArray[7]);
                    command.Parameters.AddWithValue("accessIP", dataArray[8]);
                    command.Parameters.AddWithValue("param", dataArray[9]);
                    connection.Open();
                    command.ExecuteNonQuery();
                    connection.Close();
                }
            }
            catch (SqlException ex)
            {
                if (ex.Number == 208 || ex.Number == 2812)
                {
                    CreateDatasource();
                }
            }
            catch (Exception ex)
            {
                //   EventLog.WriteEntry("IronLogger", ex.ToString(), EventLogEntryType.Error);
            }
        }

        private void CreateDatasource()
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    string[] sqlList = new string[] { DBResources.AuditLogs, DBResources.IronLogger_AuditLogs_AddLog, DBResources.IronLogger_AuditLogs_GetLogs, DBResources.vw_IronLogger_AuditLogs_GetLogs, DBResources.IronLogger_AuditLogs_GetLog };
                    connection.Open();
                    foreach (string query in sqlList)
                    {
                        SqlCommand command = new SqlCommand()
                        {
                            CommandType = System.Data.CommandType.Text,
                            Connection = connection,
                            CommandText = query
                        };
                        try
                        {
                            command.ExecuteNonQuery();
                        }
                        catch (Exception)
                        {
                            continue;
                        }
                    }
                    connection.Close();
                }
            }
            catch (Exception ex)
            {

            }
        }

        #endregion

        #endregion

    }
}
