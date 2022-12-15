<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<string>" %>
<%@ Import Namespace="com.IronOne.SLIC2.Models.Vehicle" %>
<% long uniqeId = DateTime.Now.Ticks; %>
<title></title>
<% if (!string.IsNullOrEmpty(Model))
   { %>
<ul class="treeview" id="tree<%: uniqeId %>">
    <% List<Component> componants = null;
       if (ViewData["TreeFor"] != null && ViewData["TreeFor"].ToString().Equals("DamagedItems"))
       {
           componants = ComponentManager.GetComponantTree(Model);
       }
       else if (ViewData["TreeFor"] != null && ViewData["TreeFor"].ToString().Equals("PossibleDR"))
       {
           componants = ComponentManager.GetPossibleDR(Model);
       }
    %>
    <% Response.Write(BuildUL(componants, string.Empty)); %>
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
                output += "<ul>";
                output = BuildUL(componants[i].Components, output);
                output += "</ul>";
            }
            output += "</li>";
        }
        return output;
    }
</script>