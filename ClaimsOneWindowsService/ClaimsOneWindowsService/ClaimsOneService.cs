using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Net;
using System.ServiceProcess;
using System.Timers;
using System.Linq;

namespace ClaimsOneWindowsService
{
    public partial class ClaimsOneService : ServiceBase
    {
        // Note we had to add System.Timers to the using area
        private Timer timer = null;
        /// <summary>
        /// C:\\ClaimsOne-DoNotDeleteThis.CO
        /// </summary>
        static string path = @"C:\\ClaimsOne-DoNotDeleteThis.CO";
        /// <summary>
        /// yyyy-M-dd
        /// </summary>
        static string format = Properties.Settings.Default.DateFormat;
        /// <summary>
        /// 01/01/2016
        /// </summary>
        static string startDate = Properties.Settings.Default.StartDate;
        /// <summary>
        /// 30
        /// </summary>
        static int FetchPeriodInDays = Properties.Settings.Default.FetchPeriodInDays;

        /// <summary>
        /// 15
        /// </summary>
        static int DatabaseWriteBatchCount = Properties.Settings.Default.DatabaseWriteBatchCount;

        /// <summary>
        /// 11PM
        /// </summary>
        TimeSpan start = new TimeSpan(20, 30, 0); //12PM

        //http://localhost:88/MotorClaimService.svc/
        //Public URL 122.255.4.188
        //192.168.103.16
        static string URL = Properties.Settings.Default.URL;

        public ClaimsOneService()
        {
            try
            {
                InitializeComponent();
                WriteEventLogs("Entry: ClaimsOneService");

                // Set the timer to fire every sixty seconds
                // (remember the timer is in millisecond resolution,
                //  so 1000 = 1 second.)
                timer = new Timer();
                timer.Interval = Properties.Settings.Default.ServiceElapsedTimeInMiliseconds; //3600000 Every one hour

                // Now tell the timer when the timer fires
                // (the Elapsed event) call the _timer_Elapsed
                // method in our code
                timer.Elapsed += new ElapsedEventHandler(TimerElapsed);

                WriteEventLogs("Success: ClaimsOneService");
            }
            catch (Exception ex)
            {
                WriteEventLogs("ClaimsOneService", ex);
            }
        }


        protected override void OnStart(string[] args)
        {
            try
            {
                System.Diagnostics.Debugger.Launch();
                WriteEventLogs("Entry: OnStart");
                timer.Start();

                //Run once when service start running 
                TimerElapsedCommon();

                WriteEventLogs("Success: OnStart");
            }
            catch (Exception ex)
            {
                WriteEventLogs("OnStart", ex);
            }
        }

        protected override void OnStop()
        {
            try
            {
                WriteEventLogs("Entry: OnStop");
                timer.Stop();
                WriteEventLogs("Success: OnStop");
            }
            catch (Exception ex)
            {
                WriteEventLogs("OnStop", ex);
            }
        }

        protected override void OnContinue()
        {
            try
            {
                WriteEventLogs("Entry: OnContinue");
                base.OnContinue();
                timer.Start();
                WriteEventLogs("Success: OnContinue");
            }
            catch (Exception ex)
            {
                WriteEventLogs("OnContinue", ex);
            }
        }

        protected override void OnPause()
        {
            try
            {
                WriteEventLogs("Entry: OnPause");
                base.OnPause();
                timer.Stop();
                WriteEventLogs("Success: OnPause");
            }
            catch (Exception ex)
            {
                WriteEventLogs("OnPause", ex);
            }
        }

        protected override void OnShutdown()
        {
            try
            {
                WriteEventLogs("Entry: OnShutdown");
                base.OnShutdown();
                timer.Stop();
                WriteEventLogs("Success: OnShutdown");
            }
            catch (Exception ex)
            {
                WriteEventLogs("OnShutdown", ex);
            }
        }


        private void TimerElapsed(object sender, ElapsedEventArgs e)
        {
            try
            {
                //Between 11PM and 12AM
                if ((DateTime.Now.TimeOfDay >= start) && (DateTime.Now.TimeOfDay) <= (start.Add(new TimeSpan(1, 0, 0))))
                {
                    TimerElapsedCommon();
                }
            }
            catch (Exception ex)
            {
                WriteEventLogs("TimerElapsed", ex);
            }
        }

        static string fromDate = "";
        static string toDate = "";
        private void TimerElapsedCommon()
        {
            try
            {
                WriteEventLogs("Entry: TimerElapsedCommon");

                if (File.Exists(path))
                {
                    fromDate = ReadOrWriteToFile(false);
                    toDate = Convert.ToDateTime(fromDate).AddDays(FetchPeriodInDays).ToString(format, CultureInfo.InvariantCulture);
                }
                else
                {
                    fromDate = ReadOrWriteToFile(false);
                    toDate = DateTime.Now.ToString(format, CultureInfo.InvariantCulture);
                }

                //GetAssignedJobs
                HttpWebRequest request1 = (HttpWebRequest)WebRequest.Create(@"" + URL + "GetAssignedJobs?fromDate=" + "2020-06-12" + "&toDate=" + "2020-06-30");
                WriteEventLogs("GetAssignedJobs-RequestUrl: " + request1.RequestUri.OriginalString);
                HttpWebResponse response1 = (HttpWebResponse)request1.GetResponse();
                string content1 = new StreamReader(response1.GetResponseStream()).ReadToEnd();
                WriteEventLogs("GetAssignedJobs-Response: " + "Will be written next, if not that means its too large to write");
                WriteEventLogs("GetAssignedJobs-Response: " + content1);
                WriteEventLogs("GetAssignedJobs-Response: " + "After written");

                var obj1 = JsonConvert.DeserializeObject<RootObject>(content1);
                if (obj1.ID != 200) return;

                List<CSRDataModel> list1 = new List<CSRDataModel>();
                try
                {
                    list1 = JsonConvert.DeserializeObject<List<CSRDataModel>>(obj1.Data);
                    WriteEventLogs("GetAssignedJobs-list1 Count: " + list1.Count);
                }
                catch (Exception ex)
                {
                    WriteEventLogs("Error: GetAssignedJobs-DeserializeObject", ex);
                }

                //----------------------------------------------------------------------------

                //GetHolidays
                HttpWebRequest request2 = (HttpWebRequest)WebRequest.Create(@"" + URL + "GetHolidays?fromDate=" + fromDate + "&toDate=" + toDate);
                WriteEventLogs("GetHolidays-RequestUrl: " + request2.RequestUri.OriginalString);
                HttpWebResponse response2 = (HttpWebResponse)request2.GetResponse();
                string content2 = new StreamReader(response2.GetResponseStream()).ReadToEnd();
                WriteEventLogs("GetHolidays-Response: " + "Will be written next, if not that means its too large to write");
                WriteEventLogs("GetHolidays-Response: " + content2);
                WriteEventLogs("GetHolidays-Response: " + "After written");

                var obj2 = JsonConvert.DeserializeObject<RootObject>(content2);
                if (obj2.ID != 200) return;

                List<HolidayDataModel> list2 = new List<HolidayDataModel>();
                try
                {
                    list2 = JsonConvert.DeserializeObject<List<HolidayDataModel>>(obj2.Data);
                    WriteEventLogs("GetHolidays-list2 Count: " + list2.Count);
                }
                catch (Exception ex)
                {
                    WriteEventLogs("Error: GetHolidays-DeserializeObject", ex);
                }

                var context1 = new ClaimsOneLiveEntities();
                int count1 = 0;
                try
                {
                    foreach (var item in list1)
                    {
                        var isExist = context1.AssignedJobs.Where(x => x.JobNumber.Equals(item.JobNumber)).FirstOrDefault();
                        //Record exists so update it
                        if (isExist != null)
                        {
                            WriteEventLogs("GetHolidays-Response: " + "Record exists : " + item.JobNumber);
                            bool isUpdateNeeded = false;

                            if (!isUpdateNeeded)
                                if (isExist.AssignedDateTime != item.AssignedDateTime)
                                    isUpdateNeeded = true;

                            if (!isUpdateNeeded)
                                if (isExist.CSRCode != item.CSRCode)
                                    isUpdateNeeded = true;

                            if (!isUpdateNeeded)
                                if (isExist.VehicleNumber != item.VehicleNumber)
                                    isUpdateNeeded = true;

                            if (isUpdateNeeded)
                                context1.SaveChanges();
                        }
                        else
                        {
                            count1 = count1 + 1;
                            //Perform create operation
                            context1.AssignedJobs.Add(new AssignedJob() { AssignedDateTime = item.AssignedDateTime, CSRCode = item.CSRCode, JobNumber = item.JobNumber, VehicleNumber = item.VehicleNumber });

                            if (count1 == DatabaseWriteBatchCount)
                            {
                                count1 = 0;
                                context1.SaveChanges();
                                context1 = new ClaimsOneLiveEntities();
                                continue;
                            }
                        }
                    }
                    context1.SaveChanges();
                    context1 = new ClaimsOneLiveEntities();
                }
                catch (Exception ex)
                {
                    WriteEventLogs("Error: AssignedJobs-TimerElapsedCommon", ex);
                }
                finally
                {
                    context1.Dispose();
                }
                WriteEventLogs("GetAssignedJobs: Done execution");

                WriteEventLogs("GetHolidays: Execution started");
                var context2 = new ClaimsOneLiveEntities();
                int count2 = 0;
                try
                {
                    foreach (var item in list2)
                    {
                        var isExist = context2.Holidays.Where(x => x.Date == item.HolidayDate).Any();
                        if (isExist) continue;
                        else
                        {
                            count2 = count2 + 1;
                            //Perform create operation
                            context2.Holidays.Add(new Holiday() { Date = item.HolidayDate });

                            if (count1 == DatabaseWriteBatchCount)
                            {
                                count2 = 0;
                                context2.SaveChanges();
                                context2 = new ClaimsOneLiveEntities();
                                continue;
                            }
                        }
                    }
                    context2.SaveChanges();
                    context2 = new ClaimsOneLiveEntities();
                }
                catch (Exception ex)
                {
                    WriteEventLogs("Error: GetHolidays-TimerElapsedCommon", ex);
                }
                finally
                {
                    context2.Dispose();
                }
                WriteEventLogs("GetHolidays: Done execution");

                ReadOrWriteToFile(true);

                WriteEventLogs("Success: TimerElapsedCommon");
            }
            catch (Exception ex)
            {
                WriteEventLogs("TimerElapsedCommon", ex);
            }
        }

        private static string ReadOrWriteToFile(bool isWrite)
        {
            try
            {
                if (!File.Exists(path))
                {
                    // Create a file to write to. 
                    DateTime dt = Convert.ToDateTime(startDate);
                    using (StreamWriter sw = File.CreateText(path))
                    {
                        sw.WriteLine(dt.ToShortDateString());
                    }
                    return dt.ToString(format, CultureInfo.InvariantCulture);
                }
                else
                {
                    if (isWrite)
                    {
                        using (StreamWriter sw = File.CreateText(path))
                        {
                            var fromDte = Convert.ToDateTime(fromDate);
                            sw.WriteLine(fromDte.AddDays(1).ToShortDateString());
                        }
                    }

                    var text = File.ReadAllText(path);
                    return Convert.ToDateTime(text).ToString(format, CultureInfo.InvariantCulture);
                }
            }
            catch (Exception)
            {
                throw;
            }
        }

        private void WriteEventLogs(string msg, Exception e = null)
        {
            try
            {
                string src = "ClaimsOneLogSrc";
                msg = "Message: " + msg + "\n";

                if (e != null)
                {
                    string eMessage = "ExceptionMessage: " + e.Message + "\n";
                    string eInnerException = "InnerException: " + e.InnerException + "\n";
                    string eStackTrace = "StackTrace: " + e.StackTrace + "\n";

                    msg += eMessage + eInnerException + eStackTrace;
                }
                msg += "Datetime: " + DateTime.Now.ToShortDateString() + " " + DateTime.Now.ToShortTimeString();

                // Create the source, if it does not already exist.
                if (!EventLog.SourceExists(src))
                {
                    // An event log source should not be created and immediately used.
                    // There is a latency time to enable the source, it should be created
                    // prior to executing the application that uses the source.
                    // Execute this sample a second time to use the new source.
                    EventLog.CreateEventSource(src, "ClaimsOneWinSvcLog");

                    // The source is created.  Exit the application to allow it to be registered.
                    return;
                }

                // Create an EventLog instance and assign its source.
                EventLog myLog = new EventLog();
                myLog.Source = src;

                // Write an informational entry to the event log.    
                if (e != null)
                    myLog.WriteEntry(msg, EventLogEntryType.Error);
                else
                    myLog.WriteEntry(msg, EventLogEntryType.Information);
            }
            catch (Exception ex)
            {
            }
        }
    }
}
