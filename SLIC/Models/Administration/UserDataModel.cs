using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using com.IronOne.SLIC2.Models.Validations;
using com.IronOne.SLIC2.Models.EntityModel;

namespace com.IronOne.SLIC2.Models.Administration
{
    /// <summary>
    ///  <title>User Data model</title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2012-mm-dd</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary>

    [DropdownValidationOnRole("Engineer"/*For multiple roles seperate by comma e.g: "Engineer,admin" */, "RoleName", "BranchId", ErrorMessage = "Please select branch")]
    [RequiredOnConditon("Password", "IsEdit", true /*Validate On Insert */, false/*Validate On Update */, ErrorMessage = "Password is required")]
    [RequiredOnConditon("ConfirmPassword", "IsEdit", true /*Validate On Insert */, false/*Validate On Update */, ErrorMessage = "Confirm Password is required")]
    [PropertiesMustMatchOnCondition("Password", "ConfirmPassword", "IsEdit", true /*Validate On Insert */, false /*Validate On Update */)]
    [RequiredWhenSelected("CSRCode", "RoleName", "IsEdit", true /*Validate On Insert */, true/*Validate On Update */)]
    [ValidateAccessLevelOnRole("RoleName", "DataAccessLevel", "IsEdit", true /*Validate On Insert */, true/*Validate On Update */)]
    public class UserDataModel
    {
        #region Constrcutors

        public UserDataModel()
        {
        }

        public UserDataModel(vw_UserLoginDetails view)
        {
            this.Username = view.UserName;
            this.Id = view.UserId;
            this.UserId = view.UserGUID;
            this.FirstName = view.FirstName;
            this.LastName = view.LastName;
            this.RoleId = view.RoleId;
            this.RoleName = view.RoleName;
            this.DataAccessLevel = view.DataAccessLevel;
            this.IsEnabled = view.IsEnabled;
            this.IsDeleted = view.IsDeleted;
            this.CSRCode = view.Code;
            this.RolePermissions = view.Description;
            this.BranchId = view.BranchId;
            this.RegionId = view.RegionId;
            //For TempPrinting- re-allocating to previous role
            this.PreviousRoleId = view.PreviousRoleId;
            this.PreviousRoleChangedDate = view.PreviousRoleChangedDate;
        }

        public UserDataModel(vw_UserDetails view)
        {
            this.Username = view.UserName;
            this.Id = view.UserId;
            this.UserId = view.UserGUID;
            this.FirstName = view.FirstName;
            this.LastName = view.LastName;
            this.IsEnabled = view.IsEnabled;
            this.IsDeleted = view.IsDeleted;
            this.CSRCode = view.Code;
            this.Email = view.PrimaryEmail;
            this.ContactNo = view.ContactNo;
            //TODO: PrimaryEmail, Secondary Email, Contact No 2
            this.EPFNo = view.EPFNo;
            this.DataAccessLevel = view.DataAccessLevel;
            this.RegionId = view.RegionId;
            this.RegionName = view.RegionName;
            this.BranchId = view.BranchId;
            this.BranchName = view.BranchName;
            this.RoleName = view.RoleName;
            this.RoleId = view.RoleId;
            this.CurrentRoleName = view.RoleName;
            //For TempPrinting- re-allocating to previous role
            this.PreviousRoleId = view.PreviousRoleId;
            this.PreviousRoleChangedDate = view.PreviousRoleChangedDate;
        }

      

        #endregion

        #region Properties

        public int Id { get; set; }

        public Guid UserId { get; set; }

        [Required]
        [DisplayName("username")]
        public string Username { get; set; }

        [Required]
        [DisplayName("first name")]
        public string FirstName { get; set; }

        [Required]
        [DisplayName("last name")]
        public string LastName { get; set; }

        [DisplayName("CSR code")]
        public string CSRCode { get; set; }

        [Required]
        [DisplayName("EPF no")]
        [StringLength(4, MinimumLength = 4, ErrorMessage = "The {0} must be {1} characters.")]    
        public string EPFNo { get; set; }

        /*[DropdownValidation(ErrorMessage = "Please select data access level")]
        [DisplayName("data access level")]
        public short DataAccessLevel { get; set; }*/

        [DropdownValidation(ErrorMessage = "Please select access level")]
        [DisplayName("data access level")]
        public short DataAccessLevel { get; set; }

        public Guid RoleId { get; set; } 

        [RoleDropdownValidation(ErrorMessage = "Please select user role")]
        [DisplayName("user role")]
        public string RoleName { get; set; }

        public string CurrentRoleName { get; set; }//For manupulating wherther the role has changed on user update

        public string RolePermissions { get; set; }

        [DropdownValidation(ErrorMessage = "Please select region")]
        [DisplayName("region")]
        public int RegionId { get; set; }

        public string RegionName { get; set; }

        [DisplayName("branch")]
        public int? BranchId { get; set; }

        public string BranchName { get; set; }

        public bool IsEnabled { get; set; }

        public bool IsDeleted { get; set; }

        [Required]
        [DisplayName("email")]
        [RegularExpression(@"^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$", ErrorMessage = "Please enter a valid email address.")]
        public string Email { get; set; }

        public string Password { get; set; }

        public string ConfirmPassword { get; set; }

        public string SecondaryEmail { get; set; }
        
        //[Required]
        [DisplayName("ContactNo")]
        [DataType(DataType.PhoneNumber)]
        [RegularExpression(@"^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$", ErrorMessage = "Not a valid Phone number")]
        public string ContactNo { get; set; }

        public string AlternativeContactNo { get; set; }

        public bool IsEdit { get; set; }

        //For TempPrinting- re-allocating to previous role
        public Guid? PreviousRoleId { get; set; }

        public DateTime? PreviousRoleChangedDate { get; set; }

        public string WelcomeMsg { get; set; }
        #endregion

        #region Methods

        public UserEntity ToUserEntity()
        {
            return new UserEntity
            {
                UserId = this.Id,
                UserGUID = this.UserId,
                FirstName = this.FirstName,
                LastName = this.LastName,
                Code = this.CSRCode,
                EPFNo = this.EPFNo,
                DataAccessLevel = this.DataAccessLevel,
                PrimaryEmail = this.Email,
                ContactNo = this.ContactNo,
                BranchId = this.BranchId,
                RegionId = this.RegionId,
                // IsEnabled = this.IsEnabled,
                // IsDeleted = this.IsDeleted                
            };
        }

        #endregion

    }

}
