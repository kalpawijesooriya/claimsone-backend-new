using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Visit
{
    public class ImageCategoryModel
    {
        public int ImageTypeId { get; set; }
        public string ImageType { get; set; }
        public IEnumerable<ImageModel> Images { get; set; }
    }
}