/***************************************************************************/
/// <summary>
///  <title>SLIC IMembershipService Model</title>
///  <description>IMembershipService Model for I-Pad Membership service </description>
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
    public interface IMembershipService
    {
        int MinPasswordLength { get; }
        bool ValidateUser(string userName, string password);
        bool ChangePassword(string userName, string oldPassword, string newPassword);
    }
}