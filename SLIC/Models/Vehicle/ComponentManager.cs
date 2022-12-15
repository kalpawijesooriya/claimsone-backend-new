using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Controllers;
using System.IO;
using System.Xml;
using System.Globalization;
using com.IronOne.SLIC2.HandlerClasses;

namespace com.IronOne.SLIC2.Models.Vehicle
{
    /// <summary>
    ///  <title>Component Manager</title>
    ///  <description>Manages the Damaged items (Component Class)</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2013-01-28</createdOn>
    ///  <author>Lushanthan</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description> 
    ///  </modification>
    /// </summary
    public class ComponentManager
    {
        static string fileContent = File.ReadAllText(HttpContext.Current.Server.MapPath(ApplicationSettings.DamagedItemsXMLPath));

        /// <summary>
        ///  <title>getComponents Method</title>
        ///  <description>Given the vehicle name it returns the components of that vehicle </description>
        ///  <copyRight>Copyright (c) 2012</copyRight>
        ///  <company>IronOne Technologies (Pvt) Ltd</company>
        ///  <createdOn>2013-01-28</createdOn>
        ///  <author></author>
        ///  <param name="vehicleName">Name of the Vehicle (E.g car,van,threeWheeler)</param>
        ///  <returns>
        ///  List of Components of that vehicle specified in the Damaged Items XML 
        ///  </returns>
        /// </summary
        public static List<Component> getComponents(string vehicleName)
        {
            try
            {
                //TODO:Implementation
                return new List<Component>();
            }
            catch (GenException)
            {
                throw;
            }
            catch (Exception)
            {

                throw;
            }
        }

        public static Component GetComponantDetails(string componantPath)
        {
            Component output = new Component();
            try
            {
                string[] componantIds = componantPath.Split('/');
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.LoadXml(fileContent);
                string query = "//Vehicles";
                for (int i = 0; i < componantIds.Length; i++)
                {
                    query += "/Component[@id='" + componantIds[i] + "']";
                    if (i + 1 != componantIds.Length)
                    {
                        query += "/Components";
                    }
                }
                XmlNode detailNode = xmlDoc.SelectSingleNode(query);
                output.Id = int.Parse(detailNode.Attributes["id"].Value);
                output.Name = detailNode.Attributes["name"].Value;
                output.Description = detailNode.Attributes["description"].Value;
            }
            catch (Exception)
            {
                throw;
            }
            return output;
        }

        public static List<Component> GetComponantTree(string damagedItems)
        {
            List<Component> output = new List<Component>();
            List<Component> parentList = output;
            try
            {
                if (string.IsNullOrEmpty(damagedItems)) return output;
                string[] componantArray = damagedItems.Split(',');
                foreach (string item in componantArray)
                {
                    string componantId = string.Empty;
                    try
                    {
                        string[] componantPath = item.Split('/');
                        foreach (string id in componantPath)
                        {
                            componantId += id + "/";
                            Component newItem = GetComponantDetails(componantId.Remove(componantId.Length - 1, 1));
                            newItem.Components = new List<Component>();

                            if (parentList.Where(c => c.Id == newItem.Id).Count() == 0)
                            {
                                parentList.Add(newItem);
                            }
                            parentList = parentList.Where(c => c.Id == newItem.Id).First().Components;
                        }
                        parentList = output;
                    }
                    catch (Exception)
                    {
                        parentList = output;
                        continue;
                    }
                }
            }
            catch (GenException ex)
            {
                throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return output;
        }

        public static List<string> ConvertXMLtoDBstring(string xmlString)
        {
            List<string> output = new List<string>();
            try
            {
                XmlDocument xmlData = new XmlDocument();
                xmlData.LoadXml(xmlString);
                XmlElement elememt = xmlData.DocumentElement;

                foreach (XmlNode item in elememt.SelectNodes("item"))
                {
                    output.Add(item.InnerText);
                } 
            }
            catch (Exception)
            {
                throw;
            }
            return output;
        }

        public static string ConvertDamagedItemsXMLtoDBstring(XmlNode node)
        {
            List<string> output = new List<string>();
            try
            {
                foreach (XmlNode item in node.SelectNodes("item"))
                {
                    output.Add(item.InnerText);
                }

                if (output.Count > 0)
                {
                    return String.Join(",", output);
                }

            }
            catch (Exception)
            {
                return null;
            }
           
            return null;
        }

        public static List<Component> GetPossibleDR(string possibleDRXml)
        {
            try
            {
                XmlDocument possibleDRDoc = new XmlDocument();
                possibleDRXml = "<PossibleDR>" + possibleDRXml + "</PossibleDR>";

                try
                {
                    possibleDRDoc.LoadXml(possibleDRXml);
                   return ProcessPossibleDRXML(possibleDRDoc);
                   
                }
                catch (Exception)
                {
                    throw;
                }             
            }
            catch (Exception)
            {                
                throw;
            }
          
        }

        /// <summary>Processes the possible DR XML and returns an arrayList</summary>
        /// <param name="damagedDoc">Possible DR XML Document object</param>
        ///<returns>
        ///string array of possible DR items
        ///</returns>   
        /// <remarks>
        /// Sample XML
        /// <PossibleDR>        
        /// <item>item1</item>
        /// <item>item2</item>
        /// </PossibleDR>
        /// End Sample XML
        /// </remarks>        
        public static List<Component> ProcessPossibleDRXML(XmlDocument possibleDRDoc)
        {
            //Sample XML document of Possible DR
            /*
            <PossibleDR>              
              <item>item1</item>
              <item>item2</item>
            </PossibleDR>
            */
            try
            {
                XmlNodeList nodeList = possibleDRDoc.SelectNodes("/PossibleDR/item");

                if (nodeList == null)
                    return null;
                                
                List<Component> itemList = new List<Component>();
                for (int i = 0; i < nodeList.Count; i++)
                {
                    Component component = new Component();
                    component.Description =nodeList[i].InnerText;
                    //component.Description= CultureInfo.CurrentCulture.TextInfo.ToTitleCase(nodeList[i].InnerText.ToLower());
                    itemList.Add(component);
                }
                return itemList;
            }
            catch (XmlException)
            {
                throw new GenException(626, "Error occurred while processing possible DR XML");
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}