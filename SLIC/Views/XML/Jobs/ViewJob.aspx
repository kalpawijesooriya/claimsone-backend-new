<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<SLIC2.Models.EntityModel.Job>" %><?xml version="1.0" encoding="utf-8" ?>
<response>

<%
        /// <summary>
        /// 
        ///  <title>SLIC</title>
        ///  <description>ViewJob page for XML users to view job</description>
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
                <OriginalTimeReported><%: Model.OriginalTimeReported%></OriginalTimeReported>     
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
                    <from><%:String.Format("{0:dd/MM/yyyy}", Model.Policy_CN_StartDate)%></from>
                    <to><%: String.Format("{0:dd/MM/yyyy}", Model.Policy_CN_EndDate )%></to>
                </Policy_CoverNotePeriod>
                <Policy_CoverNoteSerialNo><%: Model.Policy_CN_SerialNo%></Policy_CoverNoteSerialNo>
                <CoverNoteIssuedBy><%: Model.CN_IssuedBy%></CoverNoteIssuedBy>
                <CoverNoteReasons><%: Model.CN_Reasons%></CoverNoteReasons>
                <ChassisNo><%: Model.ChassyNo%></ChassisNo>
                <EngineNo><%: Model.EngineNo%></EngineNo>
                <DriverName><%: Model.DriverName%></DriverName>
                <LicenceNo><%: Model.License_No%></LicenceNo>
                <LicenceExpiryDate><%:  String.Format("{0:dd/MM/yyyy}", Model.License_ExpiryDate )%></LicenceExpiryDate>
                <LicenceType> <%: Model.License_TypeId%></LicenceType>
                 <!--  Other=0, MTA32 =1, MTA39=2,CMT49=3, INTLIC=4-->
                <LicenseNewOld>
                    <IsNew><%if (Model.License_IsNew != null)
                             {%><%:Convert.ToInt32(Model.License_IsNew)%><%}%></IsNew>
                    <!--  Old=0,New =1-->
                   <%-- <Type><%:Model.License_IsNewOld_TypeId %></Type>--%>
                    <!--Refer enum-->        
                </LicenseNewOld>              
                <!--  Old=0,New =1-->
                <DriverNIC> <%: Model.DriverNIC%></DriverNIC>
                <DriverCompetence><%: Model.DriverCompetence%></DriverCompetence>
                <!--No-0,Yes-1-->
                <VehicleClass>
                <!-- C = 1,  C1=2,   D=3 Multiple Selection!-->
                <%if (Model.VehicleClassIds != null && Model.VehicleClassIds.Count > 0)
                  {
                      foreach (short item in Model.VehicleClassIds)
                      {%>
                         <class><%: item%></class>
                  <%}
                  }%>
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
                    <FR><%: Model.Tyre_FR_Status%></FR>
                    <FL><%:  Model.Tyre_FL_Status%></FL>
                    <RRL><%: Model.Tyre_RRL_Status%></RRL>
                    <RLR><%:  Model.Tyre_RLR_Status%></RLR>
                    <RLL><%:Model.Tyre_RLL_Status%></RLL>
                    <RRR><%: Model.Tyre_RRR_Status%></RRR>
                </TyreCondition>
                <TyreContributory><%: Convert.ToInt32(Model.Tyre_IsContributory)%></TyreContributory>
                <!--No-0,Yes-1-->
                <GoodsType><%: Model.Goods_Type%></GoodsType>
                <GoodsWeight><%: Model.Goods_Weight%></GoodsWeight><!-- in Kgs-->
                <GoodsDamages><%: Model.Goods_Damage%></GoodsDamages>
                <OverLoaded><%:Convert.ToInt32(Model.IsOverLoaded)%>  </OverLoaded>
                <!--No-0,Yes-1-->
                <OverWeightContributory><%: Convert.ToInt32(Model.Is_OL_Contributory)%></OverWeightContributory>
                <!--No-0,Yes-1-->
                <OtherVehiclesInvolved><%: Model.OtherVeh_Involved%></OtherVehiclesInvolved>
                <ThirdPartyDamages><%: Model.ThirdParty_Damage%></ThirdPartyDamages>
                <Injuries><%: Model.Injuries%></Injuries>
                <NearestPoliceStation><%: Model.Nearest_PoliceStation%></NearestPoliceStation>
                <!--refer PoliceStations table(DB)-->
                <JourneyPurpose><%:Model.Journey_PurposeId%></JourneyPurpose>
                <!-- Other=0, Work=1,Trip=2-->
                <DriverRelationship><%: Model.DriverRelationship%></DriverRelationship>
                <!-- Other =0,  Employee=1,  Father=2,  Son=3,  Daughter=4,  Nephew=5, Uncle=6-->
                <PavValue><%: Model.PavValue%></PavValue>
                <ClaimProcessBranch><%: Model.ProcessingBranchId%></ClaimProcessBranch>
                <!--refer ClaimProcessingBranches table(DB)-->
                <ContactNoOfTheInsured><%: Model.Insured_ContactNo%></ContactNoOfTheInsured>
                <CSRConsistency><%:Model.CSR_Consistency%></CSRConsistency>
                <CSRUserName><%: Model.CSR_UserName%></CSRUserName>
                  <!--UserName 0R UserId--> 
                <Comment><%: Model.Comment%></Comment>
                <ApproxRepairCost><%: Model.Approx_RepairCost%></ApproxRepairCost>
                <SiteEstimation><%: Model.SiteEstimation%></SiteEstimation>
                 <ImageCount><%: Model.ImageCount%></ImageCount>   

                    <!--New Reason Fields-->
        <%--        <DriverNameReason><%: Model.DriverName_Reason%></DriverNameReason>        
                <ChassisNoReason><%: Model.ChassyNo_Reason%></ChassisNoReason>
                <EngineNoReason><%: Model.EngineNo_Reason%></EngineNoReason>       
                <LicenceNoReason><%: Model.License_No_Reason%></LicenceNoReason>
                <LicenceExpiryDateReason><%: Model.License_ExpiryDate_Reason%></LicenceExpiryDateReason>
                <LicenceTypeReason><%: Model.License_TypeId_Reason%></LicenceTypeReason>
                <VehicleClassReason><%: Model.VehicleClass_Reason%></VehicleClassReason>
                <DriverCompetenceReason><%: Model.DriverCompetence_Reason%></DriverCompetenceReason>
                <DriverNICReason><%: Model.DriverNIC_Reason%></DriverNICReason>   --%>  

                 <!--New Other Fields-->
          <%--      <OtherCoverNoteReasons><%: Model.CN_Reasons_Other%></OtherCoverNoteReasons>--%>
                <OtherPossibleDR><%: Model.PossibleDR_Other%> </OtherPossibleDR>
                <OtherDamagedItems><%: Model.DamagedItems_Other%></OtherDamagedItems>
                <OtherPreAccidentDamages><%: Model.PreAccidentDamages_Other%></OtherPreAccidentDamages>

                <!--New Fields Phase 3-->
                <PreAccidentDamages>  <%=HttpUtility.HtmlDecode(Model.PreAccidentDamages)%>  </PreAccidentDamages>

                <!-- Images-->
                <Images><%:Model.ImagesString%></Images>
                <TotalImageCount><%:Model.TotalImageCount%></TotalImageCount>

                <!-- ReSubmissions-->
                <Submissions>
                <%foreach (SLIC2.Models.EntityModel.Job_ReSubmissions submission in Model.Job_ReSubmissions)
                  {%>   
                  <Submission>
                <SubmissionBy><%:submission.CSR_UserName%></SubmissionBy>
                <SubmissionDate><%:submission.TimeSubmited%></SubmissionDate>
                  <VisitTime><%:submission.TimeVisited%></VisitTime>
                <newComment><%:submission.Comment%></newComment>
                <newImages><%:submission.ImagesString%></newImages>
                </Submission>                
                <% } %>
                </Submissions>
            </FieldList>          
        </Job>  
        <%
       } %>
	    <Server><%: Server.MachineName %></Server>
        <DateTime><%: DateTime.Now %></DateTime>
    </Data>
</response>
