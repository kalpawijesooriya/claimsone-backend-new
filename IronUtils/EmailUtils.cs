using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Configuration;
using System.Net;

namespace com.IronOne.IronUtils
{
    /// <summary>
    ///  <title></title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2012-</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary>
    public class EmailUtils
    {

        #region Member Variables
        #endregion

        #region Properties
        #endregion

        #region Constructors

        /// <summary>
        ///  <description>The default Constructor.</description>
        ///  <param></param>
        ///  <returns>
        ///  </returns>       
        ///  <exception>
        ///  </exception>
        ///  <remarks></remarks>
        /// </summary>
        public EmailUtils()
        {
        }

        #endregion

        #region Functions

        #region PublicFunctions
        #endregion

        #region PrivateFunctions
        #endregion

        #endregion
        
        // protected static readonly ILog log = LogManager.GetLogger("root");

        public System.Net.Mail.MailMessage mailMsg { get; set; }

        public EmailUtils(System.Net.Mail.MailMessage jobMail)
        {
            mailMsg = jobMail;
        }

        public void SendEmail()
        {
            try
            {
                //   log.Info(LogPoint.Entry.ToString() + ",StartMailThread,Subject=" + mailMsg.Subject);
                SmtpClient client = new SmtpClient();
                client.Timeout = 300000;//default is  100,000 - 100 seconds
                try
                {
                    //Set from web config
                    client.Timeout = Convert.ToInt32(ConfigurationManager.AppSettings["smtp_client_timeout"]);
                }
                catch (Exception)
                {
                    //  throw;
                }
 
                client.Host = ConfigurationManager.AppSettings["smtp_host"].ToString(); //Set your smtp host address
                client.Port = int.Parse(ConfigurationManager.AppSettings["smtp_port"].ToString()); // Set your smtp port address
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                client.Credentials = new NetworkCredential(ConfigurationManager.AppSettings["smtp_email_username"].ToString(), ConfigurationManager.AppSettings["smtp_email_password"].ToString()); //account name and password
               
                if (ConfigurationManager.AppSettings["smtp_ssl"]!=null)
                {
                    client.EnableSsl = Boolean.Parse(ConfigurationManager.AppSettings["smtp_ssl"].ToString());// true; // Set SSL = true  
                }
                     
                client.Send(mailMsg);
                //log.Info(LogPoint.Success.ToString() + ",StartMailThread,Subject=" + mailMsg.Subject);

            }
            catch (Exception ex)
            {
                //log.Error(LogPoint.Failure.ToString() + ",StartMailThread,Subject=" + mailMsg.Subject + "," + ex.Message);
                //throw;
            }
            finally {
                if (mailMsg!=null) { mailMsg.Dispose(); }
            }           
        }
    }
}
