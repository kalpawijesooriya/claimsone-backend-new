/***************************************************************************/
/// <summary>
///  <title>SLIC JobDriverModel</title>
///  <description>Job Driver Details</description>
///  <copyRight>Copyright (c) 2012</copyRight>
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
using System.Collections.Generic;
using System.Linq;
using System.Web;
using com.IronOne.SLIC2.Models.Enums;
using com.IronOne.SLIC2.Models.EntityModel;
using System.ComponentModel.DataAnnotations;

namespace com.IronOne.SLIC2.Models.Job
{
    public class JobVehDriverModel
    {
        #region Constructors

        public JobVehDriverModel()
        { }

        public JobVehDriverModel(vw_SAForm_VehDriverDetails view)
        {
            this.VisitId = view.VisitId;
            this.ChassisNo = view.VAD_ChassyNo;
            this.EngineNo = view.VAD_EngineNo;
            this.MeterReading = view.VAD_MeterReading;
            this.DriverCompetenceId = view.VAD_DriverCompetence;
            this.DriverLicenseExpiryDate = view.VAD_License_ExpiryDate;
            this.DriverLicenseIsNew = view.VAD_License_IsNew;
            this.DriverLicenseIsNewOldTypeId = view.VAD_License_IsNewOld_TypeId;
            this.DriverLicenseNo = view.VAD_License_No;
            this.DriverLicenseTypeId = view.VAD_License_TypeId;
            this.DriverName = view.VAD_DriverName;
            
            this.DriverNic = view.VAD_DriverNIC;
            this.DriverRelationshipId = view.VAD_DriverRelationship;
            /*Set Properties from Enum */
            this.DriverIdentificationType = (view.VAD_DriverIdType != null) ? Enum.GetName(typeof(DriverIdentificationType), view.VAD_DriverIdType) : null; 
            this.DriverRelationship = (view.VAD_DriverRelationship != null) ? Enum.GetName(typeof(RelationshipType), view.VAD_DriverRelationship) : null;
            this.DriverLicenseType = (view.VAD_License_TypeId != null) ? Enum.GetName(typeof(LicenseType), view.VAD_License_TypeId) : null;
            this.DriverLicenseIsNewOldType = (view.VAD_License_IsNewOld_TypeId != null) ? Enum.GetName(typeof(LicenseIsNew), view.VAD_License_IsNewOld_TypeId) : null;
            this.DriverCompetence = (view.VAD_DriverCompetence != null) ? Enum.GetName(typeof(Confirmation), view.VAD_DriverCompetence) : null;
        }

        public JobVehDriverModel(vw_SAFormDetails view)
        {
            this.VisitId = view.VisitId;
            this.ChassisNo = view.VAD_ChassyNo;
            this.EngineNo = view.VAD_EngineNo;
            this.MeterReading = view.VAD_MeterReading;
            this.DriverCompetenceId = view.VAD_DriverCompetence;
            this.DriverLicenseExpiryDate = view.VAD_License_ExpiryDate;
            this.DriverLicenseIsNew = view.VAD_License_IsNew;
            this.DriverLicenseIsNewOldTypeId = view.VAD_License_IsNewOld_TypeId;
            this.DriverLicenseNo = view.VAD_License_No;
            this.DriverLicenseTypeId = view.VAD_License_TypeId;
            this.DriverName = view.VAD_DriverName;
            
            this.DriverNic = view.VAD_DriverNIC;
            this.DriverRelationshipId = view.VAD_DriverRelationship;
            
            if (view.VAD_DriverIdType != null)
            {
                try
                {
                    var enumType = typeof(DriverIdentificationType);
                    string name = Enum.GetName(typeof(DriverIdentificationType), view.VAD_DriverIdType);                    
                    var attributes = (DisplayAttribute[])enumType.GetField(name).GetCustomAttributes(typeof(DisplayAttribute), false);
                    this.DriverIdentificationType = attributes[0].Name;
                }
                catch (Exception)
                {
                    this.DriverIdentificationType = (view.VAD_DriverIdType != null) ? Enum.GetName(typeof(DriverIdentificationType), view.VAD_DriverIdType) : null;
                }
            }
            else
                this.DriverIdentificationType = null;

            this.DriverRelationship = (view.VAD_DriverRelationship != null) ? Enum.GetName(typeof(RelationshipType), view.VAD_DriverRelationship) : null;
            this.DriverLicenseType = (view.VAD_License_TypeId != null) ? Enum.GetName(typeof(LicenseType), view.VAD_License_TypeId) : null;
            this.DriverLicenseIsNewOldType = (view.VAD_License_IsNewOld_TypeId != null) ? Enum.GetName(typeof(LicenseIsNew), view.VAD_License_IsNewOld_TypeId) : null;
            this.DriverCompetence = (view.VAD_DriverCompetence != null) ? Enum.GetName(typeof(Confirmation), view.VAD_DriverCompetence) : null;
            this.DriverLicenseIsNew_Val = (view.VAD_License_IsNew != null && (bool)view.VAD_License_IsNew) ? LicenseIsNew.New.ToString() : LicenseIsNew.Old.ToString();
        }

        #endregion

        #region Properties
        public int VisitId { get; set; }

        public string ChassisNo { get; set; }

        public string EngineNo { get; set; }

        public int? MeterReading { get; set; }

        public string DriverName { get; set; }

        public string DriverIdentificationType { get; set; }

        public string DriverNic { get; set; }

        public short? DriverCompetenceId { get; set; }

        public int? DriverRelationshipId { get; set; }

        public string DriverLicenseNo { get; set; }

        public DateTime? DriverLicenseExpiryDate { get; set; }

        public int? DriverLicenseTypeId { get; set; }

        public bool? DriverLicenseIsNew { get; set; }

        public int? DriverLicenseIsNewOldTypeId { get; set; }

        //Extra Properties - Each Id property will also have a string property to store its value (Get from Enum)
        public string DriverCompetence { get; set; }

        public string DriverRelationship { get; set; }

        public string DriverLicenseType { get; set; }

        public string DriverLicenseIsNewOldType { get; set; }

        public short[] VehicleClassIds { get; set; }

        public string VehicleClasses { get; set; }//Vehicle Classes Seperated by Comma

        public string DriverLicenseIsNew_Val { get; set; }
        #endregion
    }
}