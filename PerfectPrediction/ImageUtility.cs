using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;

namespace PerfectPrediction
{
    public static class ImageUtility
    {
        public static string imagesFolder = HttpContext.Current.Server.MapPath("~/images");

        public static bool loadTeamImage(string teamID, Image teamImage)
        {
            string[] files = Directory.GetFiles(imagesFolder + "/team/", teamID + ".*");
            if (files.Length > 0)
            {
                teamImage.Visible = true;
                teamImage.ImageUrl = "~/images/team/" + Path.GetFileName(files[0]);
                return true;
            }
            else
            {
                teamImage.Visible = false;
                return false;
            }
        }

        public static void StoreNewImage(FileUpload fileUpload, int teamID)
        {
            if (fileUpload.HasFile)
            {
                // Delete any existing image for that team
                string[] files = Directory.GetFiles(imagesFolder + "/team/", teamID + ".*");
                foreach (string file in files)
                {
                    File.Delete(file);
                }

                string fileext = Path.GetExtension(fileUpload.FileName);
                byte[] filedata = fileUpload.FileBytes;
                string newFilePath = String.Format(imagesFolder + "/team/{0}{1}", teamID, fileext);
                File.WriteAllBytes(newFilePath, filedata);
            }
        }
    }
}