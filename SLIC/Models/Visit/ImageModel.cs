using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.EntityModel;
using com.IronOne.SLIC2.Models.Enums;

namespace com.IronOne.SLIC2.Models.Visit
{
    public class ImageModel
    {
        public ImageModel() { }

        public ImageModel(vw_ImageGallery view)
        {
            this.ImageId = view.ImageId;
            this.VisitId = view.VisitId;
            this.ImageName = view.ImageName;
            this.ImagePath = view.ImagePath;
            this.Title = view.Title;
            this.ImageTypeId = view.FieldId;
            this.ImageType = Enum.GetName(typeof(ImageType), view.FieldId);
            this.IsPrinted = view.IsPrinted;
        }

        public int ImageId { get; set; }
        public int VisitId { get; set; }
        public int ImageTypeId { get; set; }
        public string ImageType { get; set; }
        public string ImageName { get; set; }
        public string ImagePath { get; set; }
        public string Title { get; set; }
        public int UploadedBy { get; set; }
        public DateTime UploadedDate { get; set; }
        public bool IsPrinted { get; set; }
    }
}