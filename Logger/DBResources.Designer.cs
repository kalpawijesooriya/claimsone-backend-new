﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.225
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace com.IronOne.Logger {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class DBResources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal DBResources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("com.IronOne.Logger.DBResources", typeof(DBResources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to CREATE TABLE [dbo].[AuditLogs](
        ///	[EventId] [bigint] IDENTITY(1,1) NOT NULL,
        ///	[EventStatus] [varchar](25) NOT NULL,
        ///	[Description] [varchar](max) NULL,
        ///	[RefId] [int] NULL,
        ///	[Date] [datetime] NULL,
        ///	[UserName] [nvarchar](100) NULL,
        ///	[Module] [varchar](100) NOT NULL,
        ///	[Action] [varchar](100) NOT NULL,
        ///	[AccessType] [nvarchar](100) NOT NULL,
        ///	[AccessIP] [nvarchar](200) NOT NULL,
        ///	[Params] [nvarchar](max) NOT NULL,
        ///	[Info1] [nvarchar](500) NULL,
        ///	[Info2] [nvarchar](250) NULL,
        ///	[Info3] [int] NULL,        /// [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string AuditLogs {
            get {
                return ResourceManager.GetString("AuditLogs", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to CREATE PROCEDURE [dbo].[IronLogger_AuditLogs_AddLog]
        ///        @eventStatus		varchar(25),
        ///        @desciption			varchar(MAX),
        ///        @refId				int,
        ///        @userName			nvarchar(100),
        ///        @module				varchar(100),
        ///        @action				varchar(100),
        ///        @accessType			nvarchar(100),
        ///        @accessIP			nvarchar(200),
        ///        @param				nvarchar(MAX)
        ///AS
        ///BEGIN
        ///    INSERT
        ///        dbo.AuditLogs
        ///        (
        ///            EventStatus,
        ///            [Description],
        ///            RefId,
        ///            UserNam [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string IronLogger_AuditLogs_AddLog {
            get {
                return ResourceManager.GetString("IronLogger_AuditLogs_AddLog", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to CREATE PROCEDURE [dbo].[IronLogger_AuditLogs_GetLog]
        ///		@EventId			INT
        ///AS
        ///BEGIN
        ///
        ///SELECT * FROM AuditLogs
        ///WHERE EventId = @EventId
        ///
        ///END.
        /// </summary>
        internal static string IronLogger_AuditLogs_GetLog {
            get {
                return ResourceManager.GetString("IronLogger_AuditLogs_GetLog", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to CREATE PROCEDURE [dbo].[IronLogger_AuditLogs_GetLogs]
        ///        @ModuleName			varchar(100),
        ///        @ActionName			varchar(100),
        ///        @AccessType			nvarchar(100),
        ///        @AccessIP			nvarchar(200),
        ///        @UserName			nvarchar(100),
        ///        --@RefID				int,
        ///        @EventStatus		varchar(25),
        ///        @DateFrom			datetime,
        ///        @DateTo				datetime,
        ///        @Description		varchar(MAX),
        ///        @Params				nvarchar(MAX),
        ///        
        ///		@orderByCol			VARCHAR(50),		
        ///		@isAscending		BIT,
        ///		@StartIndex	 [rest of string was truncated]&quot;;.
        /// </summary>
        internal static string IronLogger_AuditLogs_GetLogs {
            get {
                return ResourceManager.GetString("IronLogger_AuditLogs_GetLogs", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to CREATE VIEW [dbo].[vw_IronLogger_AuditLogs_GetLogs]
        ///AS
        ///SELECT     TOP (100) PERCENT EventId, EventStatus, Description, RefId, Date, UserName, Module, Action, AccessType, AccessIP, Params, Info1, Info2, Info3
        ///FROM         dbo.AuditLogs
        ///ORDER BY EventId DESC.
        /// </summary>
        internal static string vw_IronLogger_AuditLogs_GetLogs {
            get {
                return ResourceManager.GetString("vw_IronLogger_AuditLogs_GetLogs", resourceCulture);
            }
        }
    }
}
