///----------------------------------------------------------------------------
///   Class:          <DataObjectFactory.cs>
///   Description:    <DataObjectFactory caches the connectionstring so that the context can be created quickly.>
///
///   Original Author:         <Prabath Fonseka>                          Date: <30th Aug 2010>
///
///   Notes:          <Notes>
///
///   Revision History:
///   Name:           Date:        Description:
///
///----------------------------------------------------------------------------


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.Configuration;
using com.IronOne.SLIC2.Lang;

namespace com.IronOne.SLIC2.Models.EntityModel
{
    /// <summary>
    /// DataObjectFactory caches the connectionstring so that the context can be created quickly.
    /// </summary>
    public static class DataObjectFactory
    {
        private static readonly string _connectionString;

        /// <summary>
        /// Static constructor. Reads the connectionstring from web.config just once.
        /// </summary>
        static DataObjectFactory()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["MotorClaimEntities"].ToString();
            //EncryptConfig();
            //DecryptConfig();
        }

        /// <summary>
        /// Create the Context using current ConnectionString
        /// </summary>
        /// <returns>MotorClaimEntities</returns>
        public static MotorClaimEntities CreateContext()
        {
            var context = new MotorClaimEntities(_connectionString);
            // Specify a timeout for queries in this context, in seconds.
            context.CommandTimeout = int.Parse(Resources.info_commandtimeout); //600
            return context;
        }


        private static void EncryptConfig()
        {
            Configuration config = WebConfigurationManager.OpenWebConfiguration("/");
            ConfigurationSection connSection = config.GetSection("connectionStrings");

            if (!connSection.SectionInformation.IsProtected)
            {
                connSection.SectionInformation.ProtectSection("RsaProtectedConfigurationProvider");
                config.Save();
            }

        }

        private static void DecryptConfig()
        {
            Configuration config = WebConfigurationManager.OpenWebConfiguration("/");
            ConfigurationSection connSection = config.GetSection("connectionStrings");

            if (connSection.SectionInformation.IsProtected)
            {
                connSection.SectionInformation.UnprotectSection();
                config.Save();
            }

        }
    }
}