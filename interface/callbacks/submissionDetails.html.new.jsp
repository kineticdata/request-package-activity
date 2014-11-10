<%@page contentType="text/html; charset=UTF-8"%>
<%-- Include the package initialization file. --%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        String csrv = request.getParameter("csrv");
        Submission submission = Submission.findByInstanceId(context, csrv);
        SubmissionsHelper[] tasks = SubmissionsHelper.findTasksByOriginatingId(context, csrv);

        if (submission == null) {
%>
<div class="submissionDetails">
    Unable to locate record
</div>
<%} else {
%>
<div class="submissionDetails" title="Submission Details">
    <div class="header">
        <div class="requestId">
            <a href="/kinetic/ReviewRequest?csrv=<%=submission.getId()%>&reviewPage=<%= bundle.getProperty("reviewJsp")%>&excludeByName=Review%20Page">
                <%= submission.getRequestId()%>
            </a>
        </div>
        <div class="serviceItem"><%= submission.getTemplateName()%></div>
        <div class="close"></div>
        <div class="clearfix"></div>
    </div>
    <div class="info">
        <div class="label">Status</div>
        <div class="value"><%= submission.getValiationStatus()%></div>
        <div class="clearfix"></div>
        <div class="label">Initiated</div>
        <div class="value"><%= DateHelper.formatDate(submission.getCreateDate(), request.getLocale())%></div>
        <div class="clearfix"></div>
        <% if (submission.getRequestStatus().equals("Closed")) {%>
        <div class="label">Completed</div>
        <div class="value"><%= DateHelper.formatDate(submission.getRequestClosedDate(), request.getLocale())%></div>
        <div class="clearfix"></div>
        <%}%>
        <div class="label">Notes</div>
        <div class="value"><%= submission.getNotes()%></div>
        <div class="clearfix"></div>
    </div>

    <div class="tasks">
        <% CycleHelper zebraCycle = new CycleHelper(new String[]{"odd", "even"});%>
        <% for (SubmissionsHelper task : tasks) {%>
		<% if (task.getToken() != null && task.getToken() != "" && ( task.getHandlerName().indexOf("kinetic_request_approval_create") != -1)) {
               String originatingId = csrv;  
               String tokenId = task.getToken();  
               String FIELD_ORIGINATING_ID = "600000310";    
               String FIELD_TOKEN = "700066700";   
               String FIELD_SOURCE_GUID = "740000008"; 			   
               String qualification =
                 "'"+FIELD_ORIGINATING_ID+"' = \""+originatingId+"\" AND "+
                 "'"+FIELD_TOKEN+"' = \""+tokenId+"\"";           
               Submission[] childSubmission = Submission.find(context, qualification);  
               String valStatus = childSubmission[0].getValidationStatus(); 
			if (!valStatus.equals("Bypassed")) {%>
        <div class="task <%= zebraCycle.cycle()%>">
            <div class="label">Task</div>
            <div class="value"><%= task.getName()%></div>
            <div class="clearfix"></div>
            <div class="label">Status</div>
            <div class="value"><%= task.getStatus()%></div>
            <div class="clearfix"></div>
            <div class="label">Initiated</div>
            <div class="value"><%= DateHelper.formatDate(task.getCreateDate(), request.getLocale())%></div>
            <div class="clearfix"></div>
            <% if (task.getStatus().equals("Closed")) {%>
            <div class="label">Completed</div>
            <div class="value"><%= DateHelper.formatDate(task.getModifiedDate(), request.getLocale())%></div>
            <div class="clearfix"></div>
            <%}%>
            <div class="label">Messages</div>
            <div class="value">
                <% for (TaskMessage message : task.getMessages(context)) {%>
                <div class="message"><%= message.getMessage()%></div>
                <% }%>
            </div>
            <div class="clearfix"></div>
        </div>
        <% } 
		}%>
        <% }%>
    </div>
    <div style="height: 1px;"></div>
</div>
<% }%>
<% }%>