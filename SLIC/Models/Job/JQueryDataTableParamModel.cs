/***************************************************************************/
/// <summary>
///  <title>SLIC JQueryDataTableParamModel</title>
///  <description>JQueryDataTableParam Model for Ajax Job Details Request</description>
///  <copyRight>Copyright (c) 2012</copyRight>
///  <company>IronOne Technologies (Pvt) Ltd</company>
///  <createdOn>2012-11-29</createdOn>
///  <author>Suren Manawatta</author>
///  <modification>
///     <modifiedBy></modifiedBy>
///      <modifiedDate></modifiedDate>
///     <description></description>
///  </modification>
///
/// </summary>
/***************************************************************************/


namespace com.IronOne.SLIC2.Models.Job
{

    /// <summary>
    /// Class that encapsulates most common parameters sent by DataTables plug-in
    /// </summary>
    public class JQueryDataTableParamModel
    {
        /// <summary>
        /// Request sequence number sent by DataTable, same value must be returned in response
        /// </summary>       
        public string sEcho{ get; set; }

        /// <summary>
        /// Text used for filtering
        /// </summary>
        public string sSearch{ get; set; }

        /// <summary>
        /// Number of records that should be shown in table
        /// </summary>
        public int iDisplayLength{ get; set; }

        /// <summary>
        /// First record that should be shown(used for paging)
        /// </summary>
        public int iDisplayStart{ get; set; }

        /// <summary>
        /// Number of columns in table
        /// </summary>
        public int iColumns{ get; set; }

        /// <summary>
        /// Number of columns that are used in sorting
        /// </summary>
        public int iSortingCols{ get; set; }

        /// <summary>
        /// Comma separated list of column names
        /// </summary>
        public string sColumns{ get; set; }

    }
}