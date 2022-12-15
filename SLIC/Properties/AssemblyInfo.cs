using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;

// General Information about an assembly is controlled through the following 
// set of attributes. Change these attribute values to modify the information
// associated with an assembly.
[assembly: AssemblyTitle("ClaimsOne")]
[assembly: AssemblyDescription("ClaimsOne")]
[assembly: AssemblyConfiguration("")]
[assembly: AssemblyCompany("IronOne Technologies (Pvt) Ltd")]
[assembly: AssemblyProduct("ClaimsOne")]
[assembly: AssemblyCopyright("Copyright © 2017 IronOne Technologies (Pvt) Ltd")]
[assembly: AssemblyTrademark("IronOne Technologies (Pvt) Ltd")]
[assembly: AssemblyCulture("")]

// Setting ComVisible to false makes the types in this assembly not visible 
// to COM components.  If you need to access a type in this assembly from 
// COM, set the ComVisible attribute to true on that type.
[assembly: ComVisible(false)]

// The following GUID is for the ID of the typelib if this project is exposed to COM
[assembly: Guid("5e8c2171-9fd5-4ac4-9174-dda544145317")]

// Version information for an assembly consists of the following four values:
//
//      Major Version
//      Minor Version 
//      Build Number
//      Revision
//
// You can specify all the values or you can default the Revision and Build Numbers 
// by using the '*' as shown below:
[assembly: AssemblyVersion("1.2.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]

[assembly: log4net.Config.XmlConfigurator(ConfigFile = "Web.config", Watch = true)]   //For log4net 1.2.10.0