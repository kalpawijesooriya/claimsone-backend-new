using System;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.IronUtils;
using com.IronOne.SLIC2.Models.Job;
using System.Collections.Generic;
using System.Linq;

namespace com.IronOne.SLIC2.Models.Visit
{
    public class VisitModel
    {
        #region Constructors

        public VisitModel()
        { }

        public VisitModel(vw_Visits view)
        {
            this.JobNo = view.JobNo;
            this.VisitId = view.VisitId;
            this.VisitType = view.VisitType;
            this.InspectionType = EnumUtils.stringValueOf(typeof(VisitType), view.VisitType.ToString());
            this.VisitedDate = view.TimeVisited;
            this.CreatedByFullName = view.CreatedByFullName;
            this.IsPrinted = view.IsPrinted;
            this.IsOriginal = view.IsOriginal;
            this.ImageCount = view.ImageCount;
            this.Code = view.Code;
        }     

        public VisitModel(vw_SAFormDetails view)
        {
            this.JobNo = view.JobNo;
            this.VisitId = view.VisitId;
            this.VisitType = view.VisitType;
            this.InspectionType = EnumUtils.stringValueOf(typeof(VisitType), view.VisitType.ToString());
            this.VisitedDate = view.TimeVisited;
            this.IsPrinted = view.IsPrinted;
            this.IsOriginal = view.IsOriginal;
            this.ImageCount = view.ImageCount;
            this.Code = view.CSRCode;
        }

        public VisitModel(vw_SAFormDetails view, List<vw_ImageGallery> images)
            : this(view)
        {
            this.ImageCategories = SetImageCategories(images);
        }

        public VisitModel(vw_VisitDetails view)
        {
            this.JobNo = view.JobNo;
            this.VisitId = view.VisitId;
            this.VisitType = view.VisitType;
            this.InspectionType = EnumUtils.stringValueOf(typeof(VisitType), view.VisitType.ToString());
            this.VisitedDate = view.TimeVisited;
            this.CreatedByFullName = view.CreatedByFullName;
            this.IsPrinted = view.IsPrinted;
            this.IsOriginal = view.IsOriginal;
            this.ImageCount = view.ImageCount;
        }

        public VisitModel(vw_VisitDetails view, List<vw_ImageGallery> images)
            : this(view)
        {
            this.ImageCategories = SetImageCategories(images);
        }

        #endregion

        #region Properties

        public int VisitId { get; set; }

        public string JobNo { get; set; }

        public int VisitNo { get; set; }//Application Generated No

        public short VisitType { get; set; }

        public string InspectionType { get; set; }

        public int CreatedBy { get; set; }

        public string CreatedByFullName { get; set; }

        public short ImageCount { get; set; }

        public int ReceivedImageCount { get; set; }

        public bool IsPrinted { get; set; }

        public string Code { get; set; }

        public DateTime VisitedDate { get; set; }//Visit Date

        public DateTime CreatedDate { get; set; }//Submitted Date

        public List<CommentModel> Comments { get; set; }

        //XML - Used to send image Ids of a visit to the TAB
        public int[] ImageIds { get; set; }

        //Used for print preview of job - Print Images Categorized
        public List<ImageCategoryModel> ImageCategories { get; set; }
               
        //public List<ImageModel> Images { get; set; }

        public bool IsOriginal { get; set; }

        #endregion

        #region methods

        private List<ImageCategoryModel> SetImageCategories(List<vw_ImageGallery> images)
        {
            if (images != null && images.Count > 0)
            {
                List<ImageModel> imageList = images.Select(x => new ImageModel(x)).ToList();

                return (from p in imageList
                        group p by p.ImageTypeId into grps
                        select new
                        {
                            Key = grps.Key,
                            Images = grps
                        }).Select(x => new ImageCategoryModel { ImageTypeId = x.Key, ImageType = EnumUtils.stringValueOf(typeof(ImageType), x.Key.ToString()), Images = x.Images }).ToList();
            }
            return null;
        }

        #endregion
    }
}