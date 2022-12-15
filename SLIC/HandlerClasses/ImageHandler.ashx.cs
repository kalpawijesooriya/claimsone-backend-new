using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;

namespace com.IronOne.SLIC2.HandlerClasses
{
    /// <summary>
    /// Summary description for imagehandler
    /// </summary>
    public class ImageHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");
            string path = context.Request.Params.Get("path");
            byte[] img = FileManager.GetBytesFromFile(path);//"E:\\image\\as.jpg");
            if (img != null)
            {
                context.Response.OutputStream.Write(img, 0, img.Length);
                context.Response.ContentType = "image/pjpeg";
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }

    /// <summary>
    /// this class is for read the image from the local hard drive to a byte array
    /// </summary>
    public static class FileManager 
    {
        public static byte[] GetBytesFromFile(string fullFilePath)
        {
            // this method is limited to 2^32 byte files (4.2 GB)

            if (!File.Exists(fullFilePath))
            {
                return null;
            }
            FileStream fs = File.OpenRead(fullFilePath);
            try
            {
                byte[] bytes = new byte[fs.Length];
                fs.Read(bytes, 0, Convert.ToInt32(fs.Length));
                fs.Close();
                return bytes;
            }
            finally
            {
                fs.Close();
            }

        }

        /// <summary>Create Folder</summary>        
        ///<param name="path">Path of the Folder</param>        
        ///<returns>
        ///</returns>
        ///<exception cref="">
        /// </exception>        
        /// <remarks></remarks>       
        public static void CreateFolder(string path)
        {
            if (!Directory.GetParent(path).Exists)
            {
                CreateFolder(Directory.GetParent(path).FullName);
            }
            if (!System.IO.Directory.Exists(path))
            {
                System.IO.Directory.CreateDirectory(path);
            }
        }
    }
}