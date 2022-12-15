using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.ComponentModel;

namespace com.IronOne.IronUtils
{
    /// <summary>
    ///  <title></title>
    ///  <description></description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt)Ltd</company>
    ///  <createdOn>2012-</createdOn>
    ///  <author></author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    /// </summary>
   public class EnumUtils
    {

        #region Member Variables
        #endregion

        #region Constructors

        /// <summary>
        /// The default Constructor.
        /// </summary>
        public EnumUtils()
        {
        }

        #endregion

        #region Methods
        public static string stringValueOf(Enum value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());
            DescriptionAttribute[] attributes = (DescriptionAttribute[])fi.GetCustomAttributes(typeof(DescriptionAttribute), false);
            if (attributes != null && attributes.Length > 0)
            {
                return attributes[0].Description;
            }
            else
            {
                return value.ToString();
            }
        }

        public static string stringValueOf(Type enumType, string name)
        {
            return stringValueOf((Enum)enumValueOf(enumType, name));
        }

        public static object enumValueOf(Type enumType, string name)
        {
            //string[] names = Enum.GetNames(enumType);
            //foreach (string name in names)
            //{
            //    if (stringValueOf((Enum)Enum.Parse(enumType, name)).Equals(value))
            //    {
            //        return Enum.Parse(enumType, name);
            //    }
            //}
            //if (Enum.IsDefined(enumType, name))
            //{
            return Enum.Parse(enumType, name);
            //}

            throw new ArgumentException("The value is not member of the specified enum.");
        }

        ///Gets enumlist (Using enum and resource files)  
        ///<param name="type">Enum type</param>
        ///<returns>
        ///returns the language specific enum value list
        ///</returns>       
        ///<exception cref="">
        ///
        /// </exception>
        /// <remarks></remarks>
        public static List<KeyValuePair<int, string>> GetEnumList(Type type)
        {
            if (!type.IsEnum)
            {
                throw new System.TypeAccessException();
            }
            List<KeyValuePair<int, string>> list = new List<KeyValuePair<int, string>>();

            foreach (Enum val in Enum.GetValues(type))
            {
                int key = Convert.ToInt32(val);
                //string key = ((uint)Enum.Parse(type, Enum.GetName(type, val))).ToString();
                string value = stringValueOf(val);
                //string value = ResourceManager.GetString(val.ToString().ToLower());
                list.Add(new KeyValuePair<int, string>(key, value));
            }
            return list;
        }       
       
        #endregion

    }
}
