<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<List<com.IronOne.SLIC2.Models.Vehicle.Component>>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Vehicle" %>
<% long uniqeId = DateTime.Now.Ticks; %>
<title></title>
<link rel="stylesheet" href="../../../../Content/css/treeView/jquery.treeview.css" />
<script src="../../../../Scripts/jquery.cookie.js" type="text/javascript"></script>
<script src="../../../../Content/js/treeView/jquery.treeview.js" type="text/javascript"></script>
<script type="text/javascript">        
    $(function () {
        $("#tree<%: uniqeId %>").treeview({
            collapsed: true,
            animated: "fast",
            control: "#sidetreecontrol",
            prerendered: true,
            persist: "location"
        });
    })
    var o = $("#tree<%: uniqeId %> li div").click(function () {

        var ua = window.navigator.userAgent;
        var msie = ua.indexOf("MSIE ");

        if (msie > 0) // If Internet Explorer, return version number
        {
            var value = $(this).siblings().css("display");
            if (value == "none") {
                $(this).siblings().css("display", "block");
            }
            else {
                $(this).siblings().css("display", "none");

            }
        }
    });
    
</script>

<% if (Model != null)
   { %>
<ul class="treeview" id="tree<%: uniqeId %>">
    <% Response.Write(BuildUL(Model, string.Empty)); %>
</ul>
<% } %>
<script runat="server" type="text/C#">
    public string BuildUL(List<Component> componants, string input)
    {
        string output = input;
        for (int i = 0; i < componants.Count; i++)
        {
            bool isLast = i == componants.Count - 1 ? true : false;
            output += "<li";
            if (componants[i].Components != null && componants[i].Components.Count > 0)
            {
                output += " class=\"expandable";
                if (isLast)
                {
                    output += " lastExpandable";
                }
                output += "\"><div class=\"hitarea expandable-hitarea";
                if (isLast)
                {
                    output += " lastExpandable-hitarea";
                }
                output += "\"></div>";
            }
            else
            {
                if (isLast)
                {
                    output += " class=\"last\"";
                }
                output += ">";
            }
            output += componants[i].Description;
            if (componants[i].Components != null && componants[i].Components.Count > 0)
            {
                output += "<ul style=\"display: none;\">";
                output = BuildUL(componants[i].Components, output);
                output += "</ul>";
            }
            output += "</li>";
        }
        return output;
    }
</script>
