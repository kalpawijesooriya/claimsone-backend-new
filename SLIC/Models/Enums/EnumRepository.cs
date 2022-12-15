using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.EnterpriseServices;
using System.ComponentModel.DataAnnotations;

namespace com.IronOne.SLIC2.Models.Enums
{
    public class EnumRepository
    {
        //Enums used in this application can be seen below
    }

    [AttributeUsage(AttributeTargets.Field)]
    public class JobTypesAttribute : Attribute
    {
        private JobType[] VisitType;

        public JobTypesAttribute(JobType[] visitType)
        {
            this.VisitType = visitType;
        }

        public JobType[] GetValue()
        {
            return this.VisitType;
        }
    }

    public enum LogPoint
    {
        Entry = 0,
        Success,
        [System.ComponentModel.Description("File Uploaded")]
        FileUploaded,
        Failure
    }

    public enum LicenseType
    {
        Other = 0,
        MTA32,
        MTA39,
        CMT49,
        INTLIC,
        MTA37

    }
    public enum DriverIdentificationType
    {
        [System.ComponentModel.Description("Old NIC")]
        [Display(Name = "Old NIC")]
        OldNIC = 0,
        [System.ComponentModel.Description("New NIC")]
        [Display(Name = "New NIC")]
        NewNIC = 1,
        [System.ComponentModel.Description("Passport")]
        [Display(Name = "Passport")]
        Passport = 3
    }

    public enum LicenseIsNew
    {
        Old = 0,
        New = 1
    }

    public enum OldLicenseVehClasses
    {
        A1 = 1,
        A = 2,
        B1 = 3,
        B = 4,
        C1 = 5,
        C = 6,
        D = 7,
        E = 8,
        F = 9,
        G1 = 10,
        G = 11,
        H = 12
    }

    public enum NewLicenseVehClasses
    {
        A1 = 21,
        A = 22,
        B1 = 23,
        B = 24,
        C1 = 25,
        C = 26,
        CE = 27,
        D1 = 28,
        D = 29,
        DE = 30,
        G1 = 31,
        G = 32,
        J = 33
    }

    public enum JourneyPurpose
    {
        Private = 1,
        Hiring = 2,
        [System.ComponentModel.Description("Rent a Car")]
        RentACar = 3,
        Official = 4
    }

    public enum RelationshipType
    {
        Employee = 1,
        Spouse = 2,
        Relations = 3,
        Friend = 4,
        [System.ComponentModel.Description("No Relation - Rentered Vehicle")]
        NoRelation = 5,
        Insured = 6
    }

    /*New Image Categories (from DLStatement) added by SLIC on phase 3 for resubmissions */
    /*enum name renamed from "FieldName" to "ImageType" */
    public enum ImageType : byte
    {
        [JobTypes(new JobType[] { JobType.SAForm })]
        [System.ComponentModel.Description("Points Of Impact")]
        PointsOfImpact = 1,
        /*
        [System.ComponentModel.Description("Driver Statement")]
        DriverStatement,*/
        [JobTypes(new JobType[] { JobType.SAForm })]
        [System.ComponentModel.Description("Accident Images")]
        AccidentImages = 3,
        [JobTypes(new JobType[] { JobType.SAForm })]
        [System.ComponentModel.Description("Driver Statement/ DL/ NIC")]
        DLStatement = 4,
        [JobTypes(new JobType[] { JobType.SAForm, JobType.Visit })]
        [System.ComponentModel.Description("Technical Officer Comments")]
        TechnicalOfficerComments = 5,
        [JobTypes(new JobType[] { JobType.SAForm })]
        [System.ComponentModel.Description("Claim-form Image")]
        ClaimFormImage = 6,
        /*,
        [System.ComponentModel.Description("ARI")]
        ARI,
        [System.ComponentModel.Description("D/R")]
        DR,
        [System.ComponentModel.Description("Seen Visit")]
        SeenVisit,
        [System.ComponentModel.Description("Special Report 1")]
        SpecialReport1,
        [System.ComponentModel.Description("Special Report 2")]
        SpecialReport2,
        [System.ComponentModel.Description("Special Report 3")]
        SpecialReport3,
        [System.ComponentModel.Description("Supplementary 1")]
        Supplementary1,
        [System.ComponentModel.Description("Supplementary 2")]
        Supplementary2,
        [System.ComponentModel.Description("Supplementary 3")]
        Supplementary3,
        [System.ComponentModel.Description("Supplementary 4")]
        Supplementary4,
        Acknowledgment,
        [System.ComponentModel.Description("Salvage Report")]
        SalvageReport*/

        //Version 2.0 Phase 4
        [JobTypes(new JobType[] { JobType.Visit })]
        [System.ComponentModel.Description("Inspection Photos / Seen Visits / Any Other")]
        InspectionPhotosSeenVisitsAnyOther = 20,
        [JobTypes(new JobType[] { JobType.Visit })]
        [System.ComponentModel.Description("Estimate / Any Other Comments")]
        EstimateAnyotherComments = 21,
    }

    public enum TyreConditon : byte
    {
        Good = 1,
        Fair = 2,
        Bold = 3,
        [System.ComponentModel.Description("Not Applicable")]
        NotApplicable = 4
    }

    public enum Confirmation : byte
    {
        No = 0,
        Yes = 1
    }

    public enum CSR_Consistency : byte
    {
        Pending = 0,
        Yes = 1
    }

    public enum Vehicles : byte
    {
        Bus = 1,
        Car = 2,
        Lorry = 3,
        Van = 4,
        [System.ComponentModel.Description("Three Wheeler")]
        ThreeWheeler = 5,
        Motorcycle = 6
    }

    public enum OnSiteEstimation : byte
    {
        [System.ComponentModel.Description("Not Available")]
        NotAvailable = 0,
        Available = 1
    }

    //Used to distinguish Image Type Enum (Visit OR SA)
    //Check JobTypeAttribute Class
    public enum JobType : byte
    {
        [System.ComponentModel.Description("SA Form")]
        SAForm = 0,
        [System.ComponentModel.Description("Visit")]
        Visit = 1,
    }

    public enum VisitType : byte
    {
        [System.ComponentModel.Description("SA Form")]
        SAForm = 0,
        [System.ComponentModel.Description("ARI")]
        ARI = 1,
        [System.ComponentModel.Description("DR")]
        DR = 2,
        [System.ComponentModel.Description("Seen Visit")]
        SeenVisit = 3,
        [System.ComponentModel.Description("Special Report 1")]
        SpecialReport1 = 4,
        [System.ComponentModel.Description("Special Report 2")]
        SpecialReport2 = 5,
        [System.ComponentModel.Description("Special Report 3")]
        SpecialReport3 = 6,
        [System.ComponentModel.Description("Special Report 4")]
        SpecialReport4 = 7,
        [System.ComponentModel.Description("Supplementary 1")]
        Supplementary1 = 8,
        [System.ComponentModel.Description("Supplementary 2")]
        Supplementary2 = 9,
        [System.ComponentModel.Description("Supplementary 3")]
        Supplementary3 = 10,
        [System.ComponentModel.Description("Supplementary 4")]
        Supplementary4 = 11,
        //  Acknowledgment=12,
        [System.ComponentModel.Description("Salvage Report")]
        SalvageReport = 12,
        [System.ComponentModel.Description("Garage Inspection 1")]
        GarageInspection1 = 13,
        [System.ComponentModel.Description("Garage Inspection 2")]
        GarageInspection2 = 14,
        [System.ComponentModel.Description("Garage Inspection 3")]
        GarageInspection3 = 15
    }

    public enum UserDataAccessLevel
    {
        [System.ComponentModel.Description("All Region")]
        AllRegion = 1,
        [System.ComponentModel.Description("Branch Only")]
        BranchOnly = 2
    }

    public enum DeviceTypes
    {
        WEB,
        TAB,
        UNKNOWN
    }

    public enum LogParams
    {
        GEN_VehicleNo,
        JobNo,
        VisitType,
        VisitId
    }
}