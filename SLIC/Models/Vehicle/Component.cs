﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace com.IronOne.SLIC2.Models.Vehicle
{  
    /// <summary>
    ///  <title>Component Class</title>
    ///  <description>Each Damaged Item/Category (in the Damaged Items Xml) is represented by this model class </description>
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
    public class Component
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        //Child Components
        public List<Component> Components { get; set; }
    }
}