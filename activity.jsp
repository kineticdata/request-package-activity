<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>
<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc) so
    // that they are available.  Preloading all of the related objects at once
    // is more efficient than loading them individually.
    catalog.preload(context);
%>
<!DOCTYPE html>

<html>
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title><%= bundle.getProperty("catalogName")%></title>
        
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
    </head>

    <body>
        <div class="view-port">
            <%@include file="../../common/interface/fragments/navigationSlide.jspf"%>
            <div class="content-slide" data-target="div.navigation-slide">
                <%@include file="../../common/interface/fragments/header.jspf"%>
                <%@include file="../../common/interface/fragments/portalSearchForm.jspf"%>
                <div class="pointer-events">
                    <section class="container">
						<div id="contentBody">
							<div id="messages" style="display: none;">
								<div style="display:none"  class="alert alert-success" role="alert"><span class="alert-label">Viewing: </span><span class="content"></span></div>
								<div style="display:none"  class="loading alert alert-warning" role="alert"><span class="alert-label">Loading </span><span class="content"></span><img src="<%= bundle.packagePath()%>resources/images/spinner_00427E_FFFFFF.gif"></div>
								<div style="display:none"  class="alert alert-error alert-danger" role="alert"><h4>Error:</h4><div class="content"></div></div>
							</div>
							<div id="overlayContainer">
								<div id="overlay"></div>
								<%@include file="interface/fragments/defaultControls.jspf"%>
								<div id="tableContainer">
									<table id="status" class="table table-striped table-condensed table-hover"></table>
								</div>
							</div>
						</div>
                    </section>
                </div>
                <%@include file="../../common/interface/fragments/footer.jspf"%>
            </div>
        </div>
    </body>
</html>
