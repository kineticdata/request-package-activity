<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>

<!DOCTYPE html>

<html>
    <head>
        <title><%= bundle.getProperty("catalogName")%></title>

        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/headContent.jspf"%>
        
        <!-- Page Stylesheets -->
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/activity.css" type="text/css">
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/messages.css" type="text/css">
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/dialog.css" type="text/css">
        <link rel="stylesheet" href="<%= bundle.packagePath()%>resources/css/misc.css" type="text/css">
        <!-- Page Javascript -->
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/date.format.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/activityTable.js"></script>
        <script type="text/javascript" src="<%=bundle.packagePath()%>resources/js/activity.js"></script>
        <script type="text/javascript">
            BUNDLE.config.locale = '<%= context.getContext().getLocale() %>';
        </script>
    </head>

    <body>
        <div id="bodyContainer">
            <%@include file="../../common/interface/fragments/contentHeader.jspf"%>
            <div id="contentBody">
                <div id="messages">
                    <div class="message success hidden"><span class="label">Viewing: </span><span class="content"></span></div>
                    <div class="message loading hidden"><span class="label">Loading </span><span class="content"></span><img src="<%= bundle.packagePath()%>resources/images/spinner_00427E_FFFFFF.gif"></div>
                    <div class="message error hidden"><span class="label">Error: </span><span class="content"></span></div>
                </div>
                <div id="overlayContainer">
                    <div id="overlay"></div>
                    <%@include file="interface/fragments/defaultControls.jspf"%>
                    <div id="tableContainer">
                        <table id="status"></table>
                    </div>
                </div>
            </div>
            <%@include file="../../common/interface/fragments/contentFooter.jspf"%>
        </div>
    </body>
</html>
