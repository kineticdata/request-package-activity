<%-- Set the page content type, ensuring that UTF-8 is used. --%>
<%@page contentType="text/html; charset=UTF-8"%>

<%-- Include the package initialization file. --%>
<%@include file="framework/includes/packageInitialization.jspf"%>
<%-- Retrieve the Catalog --%>
<%
    // Retrieve the main catalog object
    Catalog catalog = Catalog.findByName(context, customerRequest.getCatalogName());
    // Preload the catalog child objects (such as Categories, Templates, etc)
    catalog.preload(context);
    // Retrieve objects
    Template currentTemplate = catalog.getTemplateById(customerSurvey.getSurveyTemplateInstanceID()); 

%>
<%
    List<String> status = new ArrayList<String>();
    status.add("Open");
    status.add("Closed");
    status.add("Draft");
    status.add("Pending Approval");
    status.add("Closed Approval");
	status.add("Pending Survey");
%>
<!DOCTYPE html>
<html>
    <head>
        <%-- Include the common content. --%>
        <%@include file="../../common/interface/fragments/head.jspf"%>
        <title><%= bundle.getProperty("catalogName")%></title>
        <%-- Include the application head content. --%>
        <%@include file="../../core/interface/fragments/applicationHeadContent.jspf"%>
        <%@include file="../../core/interface/fragments/displayHeadContent.jspf"%>
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
						<header>
							<div class="container">
								<h1 class="pageTitle">
									<%= ThemeLocalizer.getString(packageResourceBundle, "Activity")%>:
									<% if(request.getParameter("status") != null) {%>
										<%= ThemeLocalizer.getString(packageResourceBundle, request.getParameter("status"))%>
									<%}else{%>
										<%= ThemeLocalizer.getString(packageResourceBundle, status.get(0))%>
									<%}%>
								</h1>
							</div>
						</header>
						<div class="container clearfix borderBottom">
							<div class="mainColumn">
								<div id="messages">
									<div class="message success hidden"><span class="label"><%= ThemeLocalizer.getString(packageResourceBundle, "viewing_text")%>: </span><span class="content"></span></div>
									<div class="message loading hidden"><span class="label"><%= ThemeLocalizer.getString(packageResourceBundle, "loading_text")%> </span><span class="content"></span><img src="<%= bundle.packagePath()%>resources/images/spinner_00427E_FFFFFF.gif"></div>
									<div class="message error hidden"><span class="label"><%= ThemeLocalizer.getString(packageResourceBundle, "error_text")%>: </span><span class="content"></span></div>
								</div>
								<div id="overlayContainer">
									<div id="overlay"></div>
									<%@include file="interface/fragments/defaultControls.jspf"%>
									<div class="clearfix"></div>
									<div id="tableContainer">
										<table id="status"></table>
									</div>
								</div>
							</div>
							<div class="sideColumn">
									<h2 class="subheader">
										<%=ThemeLocalizer.getString(packageResourceBundle,"My Activity Items")%>
									</h2>
									<%-- SUBMISSION TABLE LINKS --%>
									<ul class="">
										<% for(String statusGroup : status) {%>
											<li>
												<a data-group-name="<%=statusGroup%>" href="<%= bundle.getProperty("activityUrl")%>&status=<%=statusGroup%>">
													<%=ThemeLocalizer.getString(packageResourceBundle, statusGroup)%>
												</a>
											</li>
										<%}%>
									</ul> 
									<h2 class="subheader">
									   <%=ThemeLocalizer.getString(commonResourceBundle,"My Service Desk")%>
									</h2>
									<ul class="sideNavigation">
										<li>
											 <a href="<%= bundle.getProperty("serviceLinesUrl")%>">
												<%=ThemeLocalizer.getString(commonResourceBundle,"My Service Desk")%>
											</a>
										</li>
									</ul>
									<%--@include file="../../common/interface/fragments/sidebar.jspf"--%>
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
