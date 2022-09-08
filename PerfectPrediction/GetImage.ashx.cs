using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

namespace PerfectPrediction
{
    /// <summary>
    /// Summary description for GetImage
    /// </summary>
    public class GetImage : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            string g = HttpContext.Current.Request.QueryString["g"];

            string filePath = ImageUtility.imagesFolder + "/game/" + g + ".png";
            if (!File.Exists(filePath))
            {
                string apiKey = ConfigurationManager.AppSettings["thumbnail.ws api key"];
                string thumbnailUrl = string.Format("https://api.thumbnail.ws/api/{0}/thumbnail/get?url=https://perfectprediction.aa5jc.com/default_social.aspx?g={1}&width=1200", apiKey, g);

                using (WebClient client = new WebClient())
                {
                    client.DownloadFile(new Uri(thumbnailUrl), filePath);
                }
            }

            System.Drawing.Image img = System.Drawing.Image.FromFile(filePath);
            byte[] arrImg = ImageToByteArray(img);
            context.Response.ContentType = "image/png";
            context.Response.OutputStream.Write(arrImg, 0, arrImg.Length);
        }

        public byte[] ImageToByteArray(System.Drawing.Image imageIn)
        {
            using (var ms = new MemoryStream())
            {
                imageIn.Save(ms, imageIn.RawFormat);
                return ms.ToArray();
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
}