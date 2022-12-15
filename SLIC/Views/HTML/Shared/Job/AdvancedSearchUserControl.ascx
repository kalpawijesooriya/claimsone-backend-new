<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<com.IronOne.SLIC2.Models.Job.AdvancedSearch>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Lang" %>
<%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>Advanced search control page</description>
    ///  <copyRight>Copyright (c) 2012</copyRight>
    ///  <company>IronOne Technologies (Pvt) Ltd</company>
    ///  <createdOn>2012-12-20</createdOn>
    ///  <author>Suren Manawatta</author>
    ///  <modification>
    ///     <modifiedBy></modifiedBy>
    ///      <modifiedDate></modifiedDate>
    ///     <description></description>
    ///  </modification>
    ///
    /// </summary>                                                                                 
%>
<% using (Html.BeginForm("AdvancedSearch", "Job", null, FormMethod.Post, new { @id = "contact-form", @class = "form-actions-full", @novalidate = "novalidate" }))
   {%>
<%: Html.ValidationSummary(true)%>
<script type="text/javascript">
    $(document).ready(function () {
        $('#istriggered').hide();

        $('#Error').hide();

        if ($('#BranchId option[value!="-1"]').length == 0) {
            $("#BranchId").attr('disabled', 'disabled');
        }
        $("#xc").hide();

        $("select#RegionId").change(function () {

            var regionid = $("#RegionId > option:selected").attr("value");

            $.ajax({
                type: "POST",
                url: "/Job/FindBranchesByRegionId?regionId=" + regionid + "&isClaimProcessed=true",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: 'true',
                cache: 'false',
                beforeSend: function () {
                    $('#istriggered').show();
                },
                success: function (data) {
                    $("#istriggered").hide();
                    $('#Error').hide();
                    if (data && data.length > 0) {

                        if (data instanceof Array) {

                            var options = "<option value='-1'>" + INFO_GEN_ALL_EN_RESOURCE + "</option>";
                            for (p in data) {
                                var product = data[p];
                                options += "<option value='" + product.BranchId + "'>" + product.BranchName + "</option>";
                            }
                            $("#BranchId").removeAttr('disabled').html(options);
                        } else {
                            //alert(data);

                            $('#Error').show();
                            $("#ErrorMessage").text(data);

                            $("#BranchId").attr('disabled', true).html('');
                            $('#istriggered').hide();
                        }

                    } else {
                        $("#BranchId").attr('disabled', true).html('');
                        $('#istriggered').hide();
                    }
                },
                error: function (request, status, error) {
                    alert(request);
                    $("#BranchId").attr('disabled', true).html('');
                    $('#istriggered').hide();
                }
            });
        });
    });

    function onSubmit() {
        //$('#AllJobsTableView_processing').show();        
        if ($("#JobNo").val() == '' && $("#VehicleNo").val() == '') {
            if (!$("#contact-form").valid()) {
                return false;
            }
        }
        showLoadingImage('AllJobsTableView_processing');      
        jobSearchCall();  
        hideLoadingImage('AllJobsTableView_processing');
    }

    //    function showLoadingImage(img) {
    //        document.getElementById(img).style.display = "block";
    //        document.getElementById(img).style.visibility = "visible";
    //    }

    //    function hideLoadingImage(img) {
    //        //document.getElementById(img).style.visibility = "hidden";
    //        document.getElementById(img).style.display = "none";
    //    }
      
</script>
<fieldset class="form-horizontal control-group-width-full" style="border-bottom: 1px dotted #CCC;">
    <div class="control-group-width-half">
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_dateFrom%></label>
            <div class="controls">
                <%: Html.TextBoxFor(model => model.DateFrom, new { @class = "idatepicker-basic"})%></div>
        </div>
    </div>
    <div class="control-group-width-half">
        <div class="control-group">
            <label class="control-label" for="name">
                <%: Resources.info_gen_dateTo%></label>
            <div class="controls">
                <%: Html.TextBoxFor(model => model.DateTo, new { @class = "idatepicker-basic" })%></div>
        </div>
    </div>
</fieldset>
<fieldset class="form-horizontal control-group-width-half">
    <div class="control-group">
        <label class="control-label" for="name">
            <%:Resources.info_gen_jobNo%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.JobNo, new { @class = "input-large" })%></div>
    </div>
    <div class="control-group">
        <label class="control-label" for="name">
            <%:Resources.info_gen_csrCode%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.CSRCode, new { @class = "input-large" })%></div>
    </div>
    <div class="control-group">
        <label class="control-label" for="name">
            <%:Resources.info_gen_engineerRegion%></label>
        <div class="controls">
            <%: Html.DropDownListFor(model => model.RegionId, (IEnumerable<SelectListItem>)(ViewData["Regions"]), new { @id = "RegionId" })%></div>
    </div>
    <div class="control-group">
        <label class="control-label" for="name">
            <%:Resources.info_gen_epfNo%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.EPFNo, new { @class = "input-large" })%></div>
    </div>
</fieldset>
<fieldset class="form-horizontal control-group-width-half">
    <div class="control-group">
        <label class="control-label" for="name">
            <%:Resources.info_gen_vehicleNo%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.VehicleNo, new { @class = "input-large" })%></div>
    </div>
    <div class="control-group">
        <label class="control-label" for="name">
            <%:Resources.info_gen_csrName%></label>
        <div class="controls">
            <%: Html.TextBoxFor(model => model.CSRName, new { @class = "input-large" })%></div>
    </div>
    <div class="control-group">
        <label class="control-label" for="name">
            Claim Process Branch</label>
        <div class="controls">
            <%: Html.DropDownListFor(model => model.BranchId, (IEnumerable<SelectListItem>)(ViewData["Branches"]), new { @id = "BranchId" })%>
            <img src="../../../../Content/img/loading.gif" alt="Loading..." width="20" height="20"
                id="istriggered" />
        </div>
        <div id="xc">
        </div>
    </div>
    <div class="control-group">
    </div>
</fieldset>
<%--<fieldset class="form-horizontal form-actions-full">
    <div class="control-group pagination-centered" id="AllJobsTableView_processing">
        <img src="../../../../Content/img/loading.gif" alt="Loading..." width="20" height="20" />
    </div>
    <div>
        <input type="hidden" id="Hidden1" value="">
    </div>
</fieldset>--%>
<fieldset class="form-horizontal form-actions-full">
    <div class="control-group pagination-centered" id="AllJobsTableView_processing" style="display: none;">
        <img src="../../../../Content/img/loading.gif" />
    </div>
    <div>
        <input type="hidden" id="Hidden2" value="">
    </div>
</fieldset>
<fieldset class="form-horizontal form-actions-full">
    <div class="form-actions">
        <input type="button" class="btn btn-primary" onclick="onSubmit()" value="<%:Resources.info_gen_search%>" />
        <input type="button" class="btn btn-secondary reset" value="<%: Resources.info_gen_reset %>" />
    </div>
</fieldset>
<% } %>