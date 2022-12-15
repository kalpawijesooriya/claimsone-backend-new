<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<dynamic>" %>
<head>
    <%
    /// <summary>
    /// 
    ///  <title>SLIC2</title>
    ///  <description>user control for the map</description>
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
    <script type="text/javascript" src="../../../Scripts/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="../../../Scripts/MicrosoftMvcAjax.js"></script>
    <%--<script src="../../../Scripts/jquery-1.7.2.min.js" type="text/javascript"></script>--%>
    <script src="../../../Content/js/Slate/Map/plugins/raphael-min.js" type="text/javascript"></script>
    <script src="../../../Content/js/Slate/Map/plugins/jquery.qtip-1.0.0-rc3.min.js"
        type="text/javascript"></script>
    <script src="../../../Content/js/Slate/Map/DrawMap.js" type="text/javascript"></script>
</head>
<body>
    <div id="canvas">
        <div id="paper">
        </div>
        <label id="info">
        </label>
    </div>
    <script type="text/javascript">
        drawMap(new Array("#333", "blue", "yellow", "green", "red", "blue", "yellow", "green", "red", "blue", "yellow", "green"));
    </script>
</body>
