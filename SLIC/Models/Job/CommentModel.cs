/***************************************************************************/
/// <summary>
///  <title>SLIC CommentModel</title>
///  <description>Comment Model for Comment Details</description>
///  <copyRight>Copyright (c) 2010</copyRight>
///  <company>IronOne Technologies (Pvt)Ltd</company>
///  <createdOn>2013-01-07</createdOn>
///  <author>Suren Manawatta</author>
///  <modification>
///     <modifiedBy></modifiedBy>
///      <modifiedDate></modifiedDate>
///     <description></description>
///  </modification>
///
/// </summary>
/***************************************************************************/

using System;
using System.ComponentModel.DataAnnotations;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Job
{
    public class CommentModel
    {
        public CommentModel(vw_Comments view)
        {
            this.VisitId = view.VisitId;
            this.Comment = view.Comment;
            this.CommentedByFullName = view.CommentedBy;
            this.CommentedDate = view.CommentedDate;            
        }

        public CommentModel(vw_AllComments view)
        {
            this.VisitId = view.VisitId;           
            this.Comment = view.Comment;
            this.CommentedByFullName = view.CommentedBy;
            this.CommentedDate = view.CommentedDate;
            this.VisitType = view.VisitType;
            this.VisitDate = view.TimeVisited;
        }

        public int VisitId { get; set; }      
        [Required]       
        public string Comment { get; set; }    
        public int CommentedBy { get; set; }
        public string CommentedByFullName { get; set; }
        public DateTime CommentedDate { get; set; }

        public DateTime VisitDate { get; set; }
        public short VisitType { get; set; }       
    }
}