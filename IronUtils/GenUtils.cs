using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

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
   public class GenUtils
    {    
        #region Functions

        #region PublicFunctions

       public static string CheckEmptyString(string innertext)
        {
            if (!String.IsNullOrWhiteSpace(innertext))
            {
                return innertext.Trim();
            }
            return null;
        }

        #endregion

        #region PrivateFunctions
        #endregion

        #endregion

    }
}
