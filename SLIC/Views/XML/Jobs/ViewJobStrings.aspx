<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<SLIC2.Models.EntityModel.Job>" %>

<Response>

<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>ViewJobStrings page for XML users to View Job String</description>
        ///  <copyRight>Copyright (c) 2011</copyRight>
        ///  <company>IronOne Technologies (Pvt)Ltd</company>
        ///  <createdOn>2011-08-05</createdOn>
        ///  <author></author>
        ///  <modification>
        ///     <modifiedBy></modifiedBy>
        ///      <modifiedDate></modifiedDate>
        ///     <description></description>
        ///  </modification>
        ///
        /// </summary>                                                                                 
    %>

   <Status>
   <%
       ModelState err = ViewContext.ViewData.ModelState["err"];
       SLIC2.Controllers.GenException result = null;

       if (err != null)
       {
           result = (SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;  %>
         <code><%: result.Code%></code>
         <description><%: result.Message%></description>  
             <%
}
       else
       { %>
         <code>0</code>
         <description>Success</description> 
       <%} %> 
   </Status>
   <Data>
   <%
       if (Model != null)
       { %>
        <Job>
            <FieldList>
                <JobNo><%: Model.JobNo%></JobNo>
                <TimeReported><%: Model.TimeReported%></TimeReported>        
                <TimeVisited><%: Model.TimeVisited%></TimeVisited>
                <VehicleNo><%: Model.VehicleNo%></VehicleNo>
                <CallerName><%: Model.Caller_Name%></CallerName>
                <CallerContactNo><%: Model.Caller_ContactNo%></CallerContactNo>
                <InsuredName><%: Model.Insured_Name%></InsuredName>
                <VehicleTypeColor><%: Model.VehicleDescription%></VehicleTypeColor>
                <AccidentTime><%: Model.Acc_Time%></AccidentTime>
                <AccidentLocation><%: Model.Acc_Location%></AccidentLocation>
                <Policy_CoverNoteNo><%: Model.Policy_CN_No%></Policy_CoverNoteNo>
                <Policy_CoverNotePeriod>
                    <from><%: Model.Policy_CN_StartDate%></from>
                    <to><%: Model.Policy_CN_EndDate%></to>
                </Policy_CoverNotePeriod>
                <Policy_CoverNoteSerialNo><%: Model.Policy_CN_SerialNo%></Policy_CoverNoteSerialNo>
                <CoverNoteIssuedBy><%: Model.CN_IssuedBy%></CoverNoteIssuedBy>
                <CoverNoteReasons><%: Model.CN_Reasons%></CoverNoteReasons>
                <ChassyNo><%: Model.ChassyNo%></ChassyNo>
                <EngineNo><%: Model.EngineNo%></EngineNo>
                <DriverName><%: Model.DriverName%></DriverName>
                <LicenceNo><%: Model.License_No%></LicenceNo>
                <LicenceExpiryDate><%: Model.License_ExpiryDate%></LicenceExpiryDate>
                <LicenceType> <%: Enum.GetName(typeof(SLIC2.Models.Enums.LicenseType), Model.License_TypeId)%></LicenceType>
                 <!--  Other=0, MTA32 =1, MTA39=2,CMT49=3, INTLIC=4-->
                <LicenseNewOld>
                    <IsNew><%:Enum.GetName(typeof(SLIC2.Models.Enums.Confirmation), Convert.ToInt32(Model.License_IsNew))%></IsNew>
                    <!--  Old=0,New =1-->
                    <Type><%:Model.License_IsNewOld_TypeId %></Type>
                    <!--Refer enum-->        
                </LicenseNewOld>              
                <!--  Old=0,New =1-->
                <DriverNIC> <%: Model.DriverNIC%></DriverNIC>
                <DriverCompetence><%: Enum.GetName(typeof(SLIC2.Models.Enums.Confirmation), Model.DriverCompetence)%></DriverCompetence>
                <!--No-0,Yes-1-->
                <VehicleClass>
                <!-- C = 1,  C1=2,   D=3 Multiple Selection!-->
           <%--     <%if (Model.VehicleClassIds != null && Model.VehicleClassIds.Count > 0)
                  {
                      foreach (short item in Model.VehicleClassIds)
                      {%>
                         <class><%: Enum.GetName(typeof(SLIC2.Models.Enums.VehicleClass), item)%></class>
                  <%}
                  }%>--%>
                </VehicleClass>
                <MeterReading><%: Model.MeterReading%></MeterReading>
                <DamagedItems>      
                         
                <!-- Damaged items XML comes here.Stored as XML.-->
             <%--   <%=HttpUtility.HtmlEncode(new HtmlString(Model.DamagedItems))%>--%>
                <%=HttpUtility.HtmlDecode(Model.DamagedItems)%>
                <!-- End Damaged items XML.-->
                </DamagedItems>
                <PossibleDR>
                <%=HttpUtility.HtmlDecode(Model.PossibleDR)%>
                <!-- PossibleDR XML comes here.Stored as XML.-->          
                </PossibleDR>
                <TyreCondition>
                    <!--Fair-1,Good-2,Bad-3 -->
                    <FR><%: Enum.GetName(typeof(SLIC2.Models.Enums.TyreConditon), Model.Tyre_FR_Status)%></FR>
                    <FL><%: Enum.GetName(typeof(SLIC2.Models.Enums.TyreConditon), Model.Tyre_FL_Status)%></FL>
                    <RRL><%: Enum.GetName(typeof(SLIC2.Models.Enums.TyreConditon), Model.Tyre_RRL_Status)%></RRL>
                    <RLR><%: Enum.GetName(typeof(SLIC2.Models.Enums.TyreConditon), Model.Tyre_RLR_Status)%></RLR>
                    <RLL><%:Enum.GetName(typeof(SLIC2.Models.Enums.TyreConditon), Model.Tyre_RLL_Status)%></RLL>
                    <RRR><%: Enum.GetName(typeof(SLIC2.Models.Enums.TyreConditon), Model.Tyre_RRR_Status)%></RRR>
                </TyreCondition>
                <TyreContributory><%:Enum.GetName(typeof(SLIC2.Models.Enums.Confirmation), Convert.ToInt32(Model.Tyre_IsContributory))%></TyreContributory>
                <!--No-0,Yes-1-->
                <GoodsType><%: Model.Goods_Type%></GoodsType>
                <GoodsWeight><%: Model.Goods_Weight%></GoodsWeight><!-- in Kgs-->
                <GoodsDamages><%: Model.Goods_Damage%></GoodsDamages>
                <OverLoaded><%:Enum.GetName(typeof(SLIC2.Models.Enums.Confirmation), Convert.ToInt32(Model.IsOverLoaded))%>  </OverLoaded>
                <!--No-0,Yes-1-->
                <OverWeightContributory><%:Enum.GetName(typeof(SLIC2.Models.Enums.Confirmation), Convert.ToInt32(Model.Is_OL_Contributory))%></OverWeightContributory>
                <!--No-0,Yes-1-->
                <OtherVehiclesInvolved><%: Model.OtherVeh_Involved%></OtherVehiclesInvolved>
                <ThirdPartyDamages><%: Model.ThirdParty_Damage%></ThirdPartyDamages>
                <Injuries><%: Model.Injuries%></Injuries>
                <NearestPoliceStation><%: Model.Nearest_PoliceStation%></NearestPoliceStation>
                <!--refer PoliceStations table(DB)-->
                <JourneyPurpose><%:Enum.GetName(typeof(SLIC2.Models.Enums.JourneyPurpose), Model.Journey_PurposeId)%></JourneyPurpose>
                <!-- Other=0, Work=1,Trip=2-->
                <DriverRelationship><%:Enum.GetName(typeof(SLIC2.Models.Enums.RelationshipType), Model.DriverRelationship)%></DriverRelationship>
                <!-- Other =0,  Employee=1,  Father=2,  Son=3,  Daughter=4,  Nephew=5, Uncle=6-->
                <PavValue><%: Model.PavValue%></PavValue>
                <ClaimProcessBranch><%: Model.ProcessingBranch%></ClaimProcessBranch>
                <!--refer ClaimProcessingBranches table(DB)-->
                <ContactNoOfTheInsured><%: Model.Insured_ContactNo%></ContactNoOfTheInsured>
                <CSRConsistency><%:Enum.GetName(typeof(SLIC2.Models.Enums.CSR_Consistency), Model.CSR_Consistency)%></CSRConsistency>
                <CSRUserName><%: Model.CSR_UserName%></CSRUserName>
                <!--UserName 0R UserId--> 
            </FieldList>          
        </Job>  
        <%
            } %>
	    <Server><%: Server.MachineName %></Server>
        <DateTime><%: DateTime.Now %></DateTime>
    </Data>
</Response>