<%@ Page Language="C#" Inherits="System.Web.Mvc.ViewPage<com.IronOne.SLIC2.Models.Job.JobDataModel>" %><?xml version="1.0" encoding="utf-8" ?>
<response>
<%      /// <summary>
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
        /// </summary> %>
    <Status> 
    <% ModelState err = ViewContext.ViewData.ModelState["err"];
       com.IronOne.SLIC2.Controllers.GenException result = null;
       if (err != null)
       {
           result = (com.IronOne.SLIC2.Controllers.GenException)err.Errors.ElementAt(0).Exception;  %>
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
   <% if (Model != null)
      { %>
        <Job>
            <FieldList>
                
                <%if (Model.GeneralModel != null)
                  { %>
                <JobNo><%: Model.GeneralModel.JobNo%></JobNo>
                <TimeReported><%: Model.GeneralModel.TimeReported%></TimeReported>
                <OriginalTimeReported><%: Model.GeneralModel.OriginalTimeReported%></OriginalTimeReported>     
                <TimeVisited><%: Model.GeneralModel.VisitedDate%></TimeVisited>
                <VehicleNo><%: Model.GeneralModel.VehicleNo%></VehicleNo>
                <VehicleType><%: Model.GeneralModel.VehicleType%></VehicleType>
                <CallerName><%: Model.GeneralModel.CallerName%></CallerName>
                <CallerContactNo><%: Model.GeneralModel.CallerContactNo%></CallerContactNo>
                <InsuredName><%: Model.GeneralModel.InsuredName%></InsuredName>
                <VehicleTypeColor><%: Model.GeneralModel.VehicleDescription%></VehicleTypeColor>
                <AccidentTime><%: Model.GeneralModel.AccidentDateTime%></AccidentTime>
                <AccidentLocation><%: Model.GeneralModel.AccidentLocation%></AccidentLocation>
                <ContactNoOfTheInsured><%: Model.GeneralModel.InsuredContactNo%></ContactNoOfTheInsured>
                <ApproxRepairCost><%: Model.GeneralModel.ApproximateCostOfRepair%></ApproxRepairCost>
                <!-- Images-->      
                <Images><%=(Model.GeneralModel.ImageIds.Length > 0)? string.Empty : String.Join(",", Model.GeneralModel.ImageIds) %></Images>
                <ImageCount><%: Model.GeneralModel.ImageCount%></ImageCount>
                <TotalImageCount><%:Model.GeneralModel.ReceivedImageCount%></TotalImageCount>           
                <%}
                  if (Model.PolicyModel != null)
                  { %>
                <Policy_CoverNoteNo><%: Model.PolicyModel.PolicyCoverNoteNo%></Policy_CoverNoteNo>
                <Policy_CoverNotePeriod>
                    <from><%:String.Format("{0:dd/MM/yyyy}", Model.PolicyModel.PolicyCoverNoteStartDate)%></from>
                    <to><%: String.Format("{0:dd/MM/yyyy}", Model.PolicyModel.PolicyCoverNoteEndDate)%></to>
                </Policy_CoverNotePeriod>
                <Policy_CoverNoteSerialNo><%: Model.PolicyModel.PolicyCoverNoteSerialNo%></Policy_CoverNoteSerialNo>
                <CoverNoteIssuedBy><%: Model.PolicyModel.PolicyCoverNoteIssuedBy%></CoverNoteIssuedBy>
                <CoverNoteReasons><%: Model.PolicyModel.PolicyCoverNoteReasons%></CoverNoteReasons>
                <%}
                  if (Model.VehDriverModel != null)
                  { %>
                <ChassisNo><%: Model.VehDriverModel.ChassisNo%></ChassisNo>
                <EngineNo><%: Model.VehDriverModel.EngineNo%></EngineNo>
                <DriverName><%: Model.VehDriverModel.DriverName%></DriverName>
                <LicenceNo><%: Model.VehDriverModel.DriverLicenseNo%></LicenceNo>
                <LicenceExpiryDate><%:  String.Format("{0:dd/MM/yyyy}", Model.VehDriverModel.DriverLicenseExpiryDate)%></LicenceExpiryDate>
                <LicenceType><%: Model.VehDriverModel.DriverLicenseTypeId%></LicenceType>
                 <!--  Other=0, MTA32 =1, MTA39=2,CMT49=3, INTLIC=4-->
                <LicenseNewOld>
                    <IsNew><%if (Model.VehDriverModel.DriverLicenseIsNew != null)
                             {%><%:Convert.ToInt32(Model.VehDriverModel.DriverLicenseIsNew)%><%}%></IsNew>
                    <!--  Old=0,New =1-->
                   <%-- <Type><%:Model.License_IsNewOld_TypeId %></Type>--%>
                    <!--Refer enum-->        
                </LicenseNewOld>              
                <!--  Old=0,New =1-->
                <DriverNIC><%: Model.VehDriverModel.DriverNic%></DriverNIC>
                <DriverCompetence><%: Model.VehDriverModel.DriverCompetenceId%></DriverCompetence>
                <!--No-0,Yes-1-->
                <MeterReading><%: Model.VehDriverModel.MeterReading%></MeterReading>
                <DriverRelationship><%: Model.VehDriverModel.DriverRelationshipId%></DriverRelationship>
                <!-- Other =0,  Employee=1,  Father=2,  Son=3,  Daughter=4,  Nephew=5, Uncle=6-->

                <VehicleClass> 
                <!-- C = 1,  C1=2,   D=3 Multiple Selection!-->               
                <%if (Model.VehDriverModel.VehicleClassIds != null && Model.VehDriverModel.VehicleClassIds.Length > 0)
                  {
                      foreach (short item in Model.VehDriverModel.VehicleClassIds)
                      {%><class><%: item%></class><%}
                  }%>
                </VehicleClass>                
                 <%}
                  if (Model.DamagesModel != null)
                  { %>
                <DamagedItems>  
                <!-- Damaged items XML comes here.Stored as XML.-->
                <% if (Model.DamagesModel.DamagedItems != null)
                   {
                       string[] items = Model.DamagesModel.DamagedItems.Split(',');

                       if (items.Length > 0)
                       {
                           foreach (var item in items)
                           {%>                          
                          <item><%=item%></item>
                    <%  }
                       }
                   }
                     %>
                <!-- End Damaged items XML.-->
                </DamagedItems>
                <PossibleDR>
                <%=HttpUtility.HtmlDecode(Model.DamagesModel.PossibleDR)%>
                <!-- PossibleDR XML comes here.Stored as XML.-->          
                </PossibleDR>
                <TyreCondition>
                    <!--Fair-1,Good-2,Bad-3 -->
              <%--      <FR><%: Model.DamagesModel.Tyre_FR_Status%></FR>
                    <FL><%:  Model.DamagesModel.Tyre_FL_Status%></FL>
                    <RRL><%: Model.DamagesModel.Tyre_RRL_Status%></RRL>
                    <RLR><%:  Model.DamagesModel.Tyre_RLR_Status%></RLR>
                    <RLL><%:Model.DamagesModel.Tyre_RLL_Status%></RLL>
                    <RRR><%: Model.DamagesModel.Tyre_RRR_Status%></RRR>--%>
                    <FR><%: Model.DamagesModel.Tyre_FR_Id%></FR>
                    <FL><%:  Model.DamagesModel.Tyre_FL_Id%></FL>
                    <RRL><%: Model.DamagesModel.Tyre_RRL_Id%></RRL>
                    <RLR><%:  Model.DamagesModel.Tyre_RLR_Id%></RLR>
                    <RLL><%:Model.DamagesModel.Tyre_RLL_Id%></RLL>
                    <RRR><%: Model.DamagesModel.Tyre_RRR_Id%></RRR>
                </TyreCondition>
                <TyreContributory><%: Convert.ToInt32(Model.DamagesModel.Tyre_IsContributory)%></TyreContributory>
                <!--No-0,Yes-1-->
                <GoodsType><%: Model.DamagesModel.GoodsTypeCarried%></GoodsType>
                <GoodsWeight><%: Model.DamagesModel.GoodsWeight%></GoodsWeight><!-- in Kgs-->
                <GoodsDamages><%: Model.DamagesModel.GoodsDamage%></GoodsDamages>
                <OverLoaded><%:Convert.ToInt32(Model.DamagesModel.IsOverLoaded)%>  </OverLoaded>
                <!--No-0,Yes-1-->
                <OverWeightContributory><%: Convert.ToInt32(Model.DamagesModel.IsOLContributory)%></OverWeightContributory>
                <!--No-0,Yes-1-->
                <OtherVehiclesInvolved><%: Model.DamagesModel.OtherVehInvolved%></OtherVehiclesInvolved>
                <ThirdPartyDamages><%: Model.DamagesModel.ThirdPartyDamages%></ThirdPartyDamages>
                <Injuries><%: Model.DamagesModel.Injuries%></Injuries>
                <OtherPossibleDR><%: Model.DamagesModel.PossibleDR_Other%> </OtherPossibleDR>
                <OtherDamagedItems><%: Model.DamagesModel.DamagedItems_Other%></OtherDamagedItems>
                <OtherPreAccidentDamages><%: Model.DamagesModel.PreAccDamages_Other%></OtherPreAccidentDamages>
                <!--New Fields Phase 3-->
                <PreAccidentDamages> 
                  <%
                      if (Model.DamagesModel.PreAccDamages != null)
                      {
                          string[] preItems = Model.DamagesModel.PreAccDamages.Split(',');

                          if (preItems.Length > 0)
                          {
                              foreach (var item in preItems)
                              {%>                          
                          <item><%=item%></item>
                    <%  }
                      }
                      }
                     %>                 
                 </PreAccidentDamages>
                  <%}
                  if (Model.OtherModel != null)
                  { %>
                <NearestPoliceStation><%: Model.OtherModel.NearestPoliceStation%></NearestPoliceStation>
                <!--refer PoliceStations table(DB)-->
                <JourneyPurpose><%:Model.OtherModel.JourneyPurposeId%></JourneyPurpose>
                <!-- Other=0, Work=1,Trip=2-->

                <PavValue><%: Model.OtherModel.PavValue%></PavValue>
                <ClaimProcessBranch><%: Model.OtherModel.ClaimProcessingBranch%></ClaimProcessBranch>
                <!--refer ClaimProcessingBranches table(DB)-->                
                <CSRConsistency><%:Model.OtherModel.CsrConsistency%></CSRConsistency>
                <CSRUserName><%: Model.OtherModel.CSRName%></CSRUserName>
                  <!--UserName 0R UserId-->                           
                <SiteEstimation><%: Model.OtherModel.OnSiteEstimation%></SiteEstimation>
                <FurtherReview><%:Convert.ToInt32(Model.OtherModel.FurtherReview)%></FurtherReview>
                <%}%>               
            </FieldList>
                   <%if (Model.GeneralModel.Comments != null)
                     { %>
            <Comments>     
           <%foreach (var comment in Model.GeneralModel.Comments)
             {%>
                 <CommentItem>
                    <Comment><%=comment.Comment%></Comment>
                    <CommentedBy><%=comment.CommentedByFullName%></CommentedBy>
                    <CommentedDate><%=comment.CommentedDate%></CommentedDate>
                </CommentItem>  
            <% } %>                             
            </Comments>    
            <%} %>
            <%if (Model.GeneralModel != null && Model.GeneralModel.ImageCategories != null && Model.GeneralModel.ImageCategories.Count > 0)
              { %>
           <Images>     
           <%foreach (var category in Model.GeneralModel.ImageCategories)
             {%>
                 <ImageType>
                    <ImageTypeId><%=category.ImageTypeId%></ImageTypeId>
                    <ImageIds><%=String.Join(",", category.Images.Select(x=>x.ImageId))%></ImageIds>                  
                </ImageType>  
            <% } %>                             
            </Images>    
            <%} %>    
        </Job>  
        <%} %> 
         <Server><%=com.IronOne.SLIC2.HandlerClasses.ApplicationSettings.ServerId%></Server>
         <MachineName><%= Server.MachineName %></MachineName>
         <DateTime><%=DateTime.Now %></DateTime>
         <UTCDateTime><%=DateTime.UtcNow %></UTCDateTime>
    </Data>
</response>
