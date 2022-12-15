/***************************************************************************/
/// <summary>
/// 
///  <title>SLIC GenException</title>
///  <description>GenException for Exception Handling</description>
///  <copyRight>Copyright (c) 2012</copyRight>
///  <company>IronOne Technologies (Pvt) Ltd</company>
///  <createdOn>2012-00-00</createdOn>
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

namespace com.IronOne.SLIC2.Controllers
{
    public class GenException : Exception
    {
        private int code;

        public GenException(int code, string msg) : base(msg)
        {
            this.code = code;            
        }

        public int Code { get { return this.code; } set { this.code = value; } }
    }
  
}