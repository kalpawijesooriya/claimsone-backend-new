using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.ComponentModel;

namespace com.IronOne.SLIC2.Models.Validations
{
    public class ComparisonValidation
    {
    }

    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    public sealed class PropertiesMustMatchAttribute : ValidationAttribute
    {
        private const string _defaultErrorMessage = "ERR_141";
        private readonly object _typeId = new object();

        public PropertiesMustMatchAttribute(string originalProperty, string confirmProperty)
            : base(_defaultErrorMessage)
        {
            OriginalProperty = originalProperty;
            ConfirmProperty = confirmProperty;
        }

        public string ConfirmProperty { get; private set; }
        public string OriginalProperty { get; private set; }

        public override object TypeId
        {
            get
            {
                return _typeId;
            }
        }

        public override string FormatErrorMessage(string name)
        {
            return String.Format(CultureInfo.CurrentUICulture, ErrorMessageString,
                OriginalProperty, ConfirmProperty);
        }

        public override bool IsValid(object value)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(value);
            object originalValue = properties.Find(OriginalProperty, true /* ignoreCase */).GetValue(value);
            object confirmValue = properties.Find(ConfirmProperty, true /* ignoreCase */).GetValue(value);
            return Object.Equals(originalValue, confirmValue);
        }
    }

    [AttributeUsage(AttributeTargets.Class, AllowMultiple = true, Inherited = true)]
    public sealed class PropertiesMustMatchOnCondition : ValidationAttribute
    {
        private const string _defaultErrorMessage = "{0} and {1} does not match";
        private readonly object _typeId = new object();

        public PropertiesMustMatchOnCondition(string originalProperty, string confirmProperty, string _editStatusProperty, bool _isRequiredOnInsert, bool _isRequiredOnUpdate)
            : base(_defaultErrorMessage)
        {
            OriginalProperty = originalProperty;
            ConfirmProperty = confirmProperty;
            isRequiredOnInsert = _isRequiredOnInsert;
            isRequiredOnUpdate = _isRequiredOnUpdate;
            editStatusProperty = _editStatusProperty;
        }

        public string ConfirmProperty { get; private set; }
        public string OriginalProperty { get; private set; }
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

        public override string FormatErrorMessage(string name)
        {
            return String.Format(CultureInfo.CurrentUICulture, ErrorMessageString,
                OriginalProperty, ConfirmProperty);
        }

        public override bool IsValid(object value)
        {
            PropertyDescriptorCollection properties = TypeDescriptor.GetProperties(value);
            object originalValue = properties.Find(OriginalProperty, true /* ignoreCase */).GetValue(value);
            object confirmValue = properties.Find(ConfirmProperty, true /* ignoreCase */).GetValue(value);

            bool isEdit = (bool)properties.Find(editStatusProperty, true /* ignoreCase */).GetValue(value);

            if ((isRequiredOnInsert && !isEdit) || (isRequiredOnUpdate && isEdit))
            {
                return Object.Equals(originalValue, confirmValue);
            }
            else
                return true;
        }
    }      
}