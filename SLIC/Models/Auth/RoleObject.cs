/***************************************************************************/
/// <summary>
///  <title>SLIC RoleObject Model</title>
///  <description>RoleObject Model for Role Details </description>
///  <copyRight>Copyright (c) 2010</copyRight>
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

namespace com.IronOne.SLIC2.Models.Auth
{
    public class RoleObject
    {
        public RoleObject(string rname, string descrip)
        {
            roleName = rname;
            description = descrip;
        }

        public string roleName { get; set; }
        public string description { get; set; }        
        
    }
}