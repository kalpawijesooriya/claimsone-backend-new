using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using com.IronOne.IronUtils;
using com.IronOne.SLIC2.Models.Enums;

namespace com.IronOne.SLIC2.Models.Validations
{
    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    public sealed class RequiredOnConditon : ValidationAttribute
    {
        private const string _defaultErrorMessage = "ERR_120";
        private object _typeId = new object();

        public string requiredparam { get; private set; }
        public string conditionparam { get; private set; }
        public bool isRequiredOnInsert { get; private set; }
        public bool isRequiredOnUpdate { get; private set; }

        public RequiredOnConditon(string _requiedparam, string _conditionalBoolparam, bool _isRequiredOnInsert, bool _isRequiredOnUpdate)
            : base(_defaultErrorMessage)
        {
            requiredparam = _requiedparam;
            conditionparam = _conditionalBoolparam;
            isRequiredOnInsert = _isRequiredOnInsert;
            isRequiredOnUpdate = _isRequiredOnUpdate;
        }

        public override object TypeId
        {
            get
            {
                return this._typeId;
            }
        }

        public override bool IsValid(object value)
        {
            Type objectType = value.GetType();

            try
            {
                PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(value);

                bool isEdit = (bool)properties.Find(conditionparam, true).GetValue(value);

                if ((isRequiredOnInsert && !isEdit) || (isRequiredOnUpdate && isEdit))
                {
                    return IsValidValue(properties, value);
                }
                else
                    return true;

            }
            catch (Exception)
            {
                return false;
            }
        }

        private bool IsValidValue(PropertyDescriptorCollection properties, object value)
        {
            try
            {
                Type type = properties.Find(requiredparam, true).PropertyType;
                if (type == typeof(string))
                {
                    //Check for valid string
                    return IsValidString(properties, value);
                }
                else if (type == typeof(int))
                {
                    //Check for valid Interger
                    return IsValidInteger(properties, value);
                }
                //Other type checks come here
                return false;
            }
            catch (Exception)
            {
                return false;
            }
        }

        private bool IsValidString(PropertyDescriptorCollection properties, object value)
        {
            try
            {
                string val = (string)properties.Find(requiredparam, true).GetValue(value);
                return !string.IsNullOrEmpty(val);
            }
            catch (Exception)
            {
                return false;
            }
        }

        private bool IsValidInteger(PropertyDescriptorCollection properties, object value)
        {
            try
            {
                int val = (int)properties.Find(requiredparam, true).GetValue(value);
                return val > 0;
            }
            catch (Exception)
            {
                return false;
            }
        }

    }

    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    public sealed class RequiredWhenSelected : ValidationAttribute
    {
        private const string _defaultErrorMessage = "ERR_120";
        private readonly object _typeId = new object();

        public RequiredWhenSelected(string _requiedparam, string _selectedString, string _editStatusProperty, bool _isRequiredOnInsert, bool _isRequiredOnUpdate)
            : base(_defaultErrorMessage)
        {
            RequiedParam = _requiedparam;
            SelectedString = _selectedString;
            isRequiredOnInsert = _isRequiredOnInsert;
            isRequiredOnUpdate = _isRequiredOnUpdate;
            editStatusProperty = _editStatusProperty;
        }

        public string SelectedString { get; private set; }
        public string RequiedParam { get; private set; }
        public string editStatusProperty { get; private set; }
        public bool isRequiredOnInsert { get; private set; }
        public bool isRequiredOnUpdate { get; private set; }

        public override object TypeId
        {
            get
            {
                return _typeId;
            }
        }

        public override bool IsValid(object value)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(value);
            object RequiedParamValue = properties.Find(RequiedParam, true /* ignoreCase */).GetValue(value);
            object SelectedStringValue = properties.Find(SelectedString, true /* ignoreCase */).GetValue(value);

            bool isEdit = (bool)properties.Find(editStatusProperty, true /* ignoreCase */).GetValue(value);

            if ((isRequiredOnInsert && !isEdit) || (isRequiredOnUpdate && isEdit))
            {
                if (SelectedStringValue.ToString().Equals("Technical Officer"))
                    return !String.IsNullOrEmpty(RequiedParamValue.ToString());
                else
                    return true;
            }
            else
                return true;
        }
    }

    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    public sealed class ValidateAccessLevelOnRole : ValidationAttribute
    {
        private const string _defaultErrorMessage = "ERR_120";
        private readonly object _typeId = new object();

        public ValidateAccessLevelOnRole(string _roleParam, string _dataAccessLevelParam, string _editStatusProperty, bool _isRequiredOnInsert, bool _isRequiredOnUpdate)
            : base(_defaultErrorMessage)
        {
            RoleParam = _roleParam;
            DataAccessLevelParam = _dataAccessLevelParam;
            isRequiredOnInsert = _isRequiredOnInsert;
            isRequiredOnUpdate = _isRequiredOnUpdate;
            editStatusProperty = _editStatusProperty;          
        }

        public string DataAccessLevelParam { get; private set; }
        public string RoleParam { get; private set; }
        public string editStatusProperty { get; private set; }
        public bool isRequiredOnInsert { get; private set; }/*Validate On Insert */
        public bool isRequiredOnUpdate { get; private set; }/*Validate On Update */

        public override object TypeId
        {
            get
            {
                return _typeId;
            }
        }

        public override bool IsValid(object value)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(value);
            object roleValue = properties.Find(RoleParam, true /* ignoreCase */).GetValue(value);
            object DataAccessLevelValue = properties.Find(DataAccessLevelParam, true /* ignoreCase */).GetValue(value);

            bool isEdit = (bool)properties.Find(editStatusProperty, true /* ignoreCase */).GetValue(value);

            try
            {
                if ((isRequiredOnInsert && !isEdit) || (isRequiredOnUpdate && isEdit))
                {
                    base.ErrorMessage = String.Format("{0} role cannot be allocated for {1} access level",roleValue,EnumUtils.stringValueOf( typeof(UserDataAccessLevel), DataAccessLevelValue.ToString()));
                    if (roleValue == null || DataAccessLevelValue == null || string.IsNullOrWhiteSpace(roleValue.ToString()))
                    {
                        base.ErrorMessage = "Please Select role and access level for the user";
                        return false;
                    }
                    if (roleValue.ToString().ToLower().Equals("engineer") && Convert.ToInt16(DataAccessLevelValue) == 2)
                    {   
                        //Engineer cannot be allocated for Branch Only Access Level.
                        return false;
                    }
                    else
                        return true;
                }
                else
                    return true;
            }
            catch (Exception)
            {

                return false;
            }
        }
    }
}