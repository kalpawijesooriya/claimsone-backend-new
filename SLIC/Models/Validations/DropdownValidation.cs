using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;

namespace com.IronOne.SLIC2.Models.Validations
{
    public sealed class DropdownValidation : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            try
            {
                if (value == null)
                    return false;

                int originalValue = Convert.ToInt32(value);
                if (originalValue > 0)
                {
                    return true;
                }
            }
            catch (Exception)
            { }
            return false;
        }
    }

    public sealed class RoleDropdownValidation : ValidationAttribute
    {
        public override bool IsValid(object value)
        {
            try
            {
                if (value.ToString() == "-1")
                    return false;

                return true;
            }
            catch (Exception)
            { }
            return false;
        }

    }

    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    public sealed class DropdownValidationOnRole : ValidationAttribute
    {
        private const string _defaultErrorMessage = "ERR_120";

        public string roles { get; private set; }
        public string roleparam { get; private set; }
        public string branchparam { get; private set; }

        public DropdownValidationOnRole(string _roles, string _roleparam, string _branchparam)
            : base(_defaultErrorMessage)
        {
            roles = _roles;
            roleparam = _roleparam;
            branchparam = _branchparam;
        }

        public override bool IsValid(object value)
        {
            Type objectType = value.GetType();

            try
            {
                PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(value);

                string Role = (string)properties.Find(roleparam, true).GetValue(value);

                if (roles.Contains(Role))
                    return true;

                int dropdownVal = (int)properties.Find(branchparam, true).GetValue(value);

                if (!roles.Contains(Role) && dropdownVal > 0)
                    return true;
                else
                    return false;

            }
            catch (Exception)
            {
                return false;
            }
        }

    }

}