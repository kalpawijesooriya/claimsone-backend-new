using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Net;
using System.Linq;

namespace ConsoleApplication2
{
    class Program
    {
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
        TimeSpan start = new TimeSpan(23, 0, 0); //11PM
        static string URL = "http://122.255.4.188/iron/MotorClaimService/MotorClaimService.svc/";

        static string fromDate = "";
        static string toDate = "";
        static void Main(string[] args)
        {
            try
            {
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
                HttpWebRequest request1 = (HttpWebRequest)WebRequest.Create(@"" + URL + "GetAssignedJobs?fromDate=" + fromDate + "&toDate=" + toDate);

                HttpWebResponse response1 = (HttpWebResponse)request1.GetResponse();
                string content1 = new StreamReader(response1.GetResponseStream()).ReadToEnd();

                var obj1 = JsonConvert.DeserializeObject<RootObject>(content1);
                if (obj1.ID != 200) return;

                List<CSRDataModel> list1 = new List<CSRDataModel>();
                try
                {
                    list1 = JsonConvert.DeserializeObject<List<CSRDataModel>>(obj1.Data);
                }
                catch (Exception ex)
                {
                }

                //----------------------------------------------------------------------------

                //GetHolidays
                HttpWebRequest request2 = (HttpWebRequest)WebRequest.Create(@"" + URL + "GetHolidays?fromDate=" + fromDate + "&toDate=" + toDate);

                HttpWebResponse response2 = (HttpWebResponse)request2.GetResponse();
                string content2 = new StreamReader(response2.GetResponseStream()).ReadToEnd();

                var obj2 = JsonConvert.DeserializeObject<RootObject>(content2);
                if (obj2.ID != 200) return;

                List<HolidayDataModel> list2 = new List<HolidayDataModel>();
                try
                {
                    list2 = JsonConvert.DeserializeObject<List<HolidayDataModel>>(obj2.Data);
                }
                catch (Exception ex)
                {
                }

                var context1 = new ClaimsOneLiveEntitiesS();
                int count1 = 0;
                try
                {
                    foreach (var item in list1)
                    {
                        var isExist = context1.AssignedJobs.Where(x => x.JobNumber.Equals(item.JobNumber)).FirstOrDefault();
                        //Record exists so update it
                        if (isExist != null)
                        {                            
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
                            context1.AssignedJobs.AddObject(new AssignedJob() { AssignedDateTime = item.AssignedDateTime, CSRCode = item.CSRCode, JobNumber = item.JobNumber, VehicleNumber = item.VehicleNumber });

                            if (count1 == DatabaseWriteBatchCount)
                            {
                                count1 = 0;
                                context1.SaveChanges();
                                context1 = new ClaimsOneLiveEntitiesS();
                                continue;
                            }
                        }
                    }
                    context1.SaveChanges();
                    context1 = new ClaimsOneLiveEntitiesS();
                }
                catch (Exception ex)
                {
                }
                finally
                {
                    context1.Dispose();
                }

                var context2 = new ClaimsOneLiveEntitiesS();
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
                            context2.Holidays.AddObject(new Holiday() { Date = item.HolidayDate });

                            if (count1 == DatabaseWriteBatchCount)
                            {
                                count2 = 0;
                                context2.SaveChanges();
                                context2 = new ClaimsOneLiveEntitiesS();
                                continue;
                            }
                        }
                    }
                    context2.SaveChanges();
                    context2 = new ClaimsOneLiveEntitiesS();
                }
                catch (Exception ex)
                {
                }
                finally
                {
                    context2.Dispose();
                }

                ReadOrWriteToFile(true);
            }
            catch (Exception ex)
            {
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
    }
}