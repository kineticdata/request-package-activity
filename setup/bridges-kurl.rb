model {
  name "Activity Change"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Description"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Status Reason"
  }
  qualification {
    name "By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "By Change Id"
    result_type "Single"
    parameter {
      name "Change Id"
    }
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "By Request Id"
    result_type "Multiple"
    parameter {
      name "Request Id"
    }
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "Closed By PersonId"
    result_type "Multiple"
    parameter {
      name "PersonId"
    }
  }
  qualification {
    name "Open By PersonId"
    result_type "Multiple"
    parameter {
      name "PersonId"
    }
  }
}
model {
  name "Activity Incident"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Description"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Priority"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Status Reason"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Updated At"
  }
  qualification {
    name "By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "By Incident Id"
    result_type "Single"
    parameter {
      name "Incident Id"
    }
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "By Request Id"
    result_type "Multiple"
    parameter {
      name "Request Id"
    }
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "Closed By PersonId"
    result_type "Multiple"
    parameter {
      name "PersonId"
    }
  }
  qualification {
    name "Open By PersonId"
    result_type "Multiple"
    parameter {
      name "PersonId"
    }
  }
  qualification {
    name "By User"
    result_type "Multiple"
    parameter {
      name "Username"
    }
  }
}
model {
  name "Activity Incident Work Info"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Source"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Type"
  }
  qualification {
    name "By Incident Id"
    result_type "Multiple"
    parameter {
      name "Incident Id"
    }
  }
}
model {
  name "Activity Request"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Description"
  }
  attribute {
    name "Expected Resolution Date"
  }
  attribute {
    name "Has Children"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Instance Id"
  }
  attribute {
    name "Status"
  }
  qualification {
    name "By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "Closed By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "Open By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "Draft By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
}
model {
  name "Activity Change Work Info"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Source"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Type"
  }
  qualification {
    name "By Change Id"
    result_type "Multiple"
    parameter {
      name "Change Id"
    }
  }
}
model {
  name "Activity Work Order Work Info"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Source"
  }
  attribute {
    name "Summary"
  }
  attribute {
    name "Type"
  }
  qualification {
    name "By Work Order Id"
    result_type "Multiple"
    parameter {
      name "Work Order Id"
    }
  }
}
model {
  name "Activity Work Order"
  status "Active"
  attribute {
    name "Created At"
  }
  attribute {
    name "Description"
  }
  attribute {
    name "Id"
  }
  attribute {
    name "Status"
  }
  attribute {
    name "Status Reason"
  }
  qualification {
    name "By Submitter"
    result_type "Multiple"
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "By Work Order Id"
    result_type "Single"
    parameter {
      name "Submitter"
    }
    parameter {
      name "Work Order Id"
    }
  }
  qualification {
    name "By Request Id"
    result_type "Multiple"
    parameter {
      name "Request Id"
    }
    parameter {
      name "Submitter"
    }
  }
  qualification {
    name "Closed By PersonId"
    result_type "Multiple"
    parameter {
      name "PersonId"
    }
  }
  qualification {
    name "Open By PersonId"
    result_type "Multiple"
    parameter {
      name "PersonId"
    }
  }
}

model_mapping {
  name "Activity Approval"
  model_name "Activity Approval"
  bridge_name "Local ARS Server"
  structure "KS_SRV_CustomerSurvey_base"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Create Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Survey_Template_Name\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"CustomerSurveyID\"]%>"
  }
  attribute_mapping {
    attribute_name "Instance Id"
    field_mapping "<%=field[\"instanceId\"]%>"
  }
  attribute_mapping {
    attribute_name "Originating Form"
    field_mapping "<%=field[\"Form\"]%>"
  }
  attribute_mapping {
    attribute_name "Originating ID"
    field_mapping "<%=field[\"OriginatingID_Display\"]%>"
  }
  attribute_mapping {
    attribute_name "Requester"
    field_mapping "<%=field[\"Attribute5\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"ValidationStatus\"]%>"
  }
  qualification_mapping {
    qualification_name "Closed By Approver"
    query "'ApplicationName'=\"Kinetic Request\"  AND 'Submit Type' = \"Approval\" AND 'Submitter' = \"<%=parameter[\"Approver\"]%>\" AND 'Status' = \"Completed\""
  }
  qualification_mapping {
    qualification_name "Pending by Approver"
    query "'ApplicationName'=\"Kinetic Request\"  AND 'Submit Type' = \"Approval\" AND 'Submitter' = \"<%=parameter[\"Approver\"]%>\" AND 'Status' < \"Completed\""
  }
}
model_mapping {
  name "Activity Change"
  model_name "Activity Change"
  bridge_name "Remedy Server - Local"
  structure "CHG:Infrastructure Change"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Infrastructure Change ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Change Request Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status Reason\"]%>"
  }
  qualification_mapping {
    qualification_name "By Change Id"
    query "'Infrastructure Change ID'=\"<%=parameter[\"Change Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Request Id"
    query "'SRID'=\"<%=parameter[\"Request Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Submitter"
    query "'SRID'=$\\NULL$"
  }
  qualification_mapping {
    qualification_name "Closed By PersonId"
    query "'Customer Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Change Request Status' >= \"Completed\" AND 'SRID' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "Open By PersonId"
    query "'Customer Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Change Request Status'< \"Completed\" AND 'SRID' = $\\NULL$"
  }
}
model_mapping {
  name "Activity Change Work Info"
  model_name "Activity Change Work Info"
  bridge_name "Remedy Server - Local"
  structure "CHG:WorkLog"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Work Log Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Source"
    field_mapping "<%=field[\"Communication Source\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Type"
    field_mapping "<%=field[\"Work Log Type\"]%>"
  }
  qualification_mapping {
    qualification_name "By Change Id"
    query "'Infrastructure Change ID'=\"<%=parameter[\"Change Id\"]%>\""
  }
}
model_mapping {
  name "Activity Incident"
  model_name "Activity Incident"
  bridge_name "Remedy Server - Local"
  structure "HPD:Help Desk"
  status "Inactive"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Incident Number\"]%>"
  }
  attribute_mapping {
    attribute_name "Priority"
    field_mapping "<%=field[\"Priority\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status_Reason\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Updated At"
    field_mapping "<%=field[\"Last Modified Date\"]%>"
  }
  qualification_mapping {
    qualification_name "By Incident Id"
    query "'Incident Number'=\"<%=parameter[\"Incident Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Request Id"
    query "'SRID'=\"<%=parameter[\"Request Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Submitter"
    query "'301572100' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "By User"
    query "'Person ID' = \"<%=parameter[\"Username\"]%>\" AND 'Status' < \"Resolved\" AND 'SRID' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "Closed By PersonId"
    query "'Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Status' >= \"Resolved\" AND 'SRID' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "Open By PersonId"
    query "'Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Status' < \"Resolved\" AND 'SRID' = $\\NULL$"
  }
}
model_mapping {
  name "Activity Incident - Amway ARS"
  model_name "Activity Incident"
  bridge_name "BMC Remedy Server - Amway"
  structure "HPD:Help Desk"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Incident Number\"]%>"
  }
  attribute_mapping {
    attribute_name "Priority"
    field_mapping "<%=field[\"Priority\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status_Reason\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Updated At"
    field_mapping "<%=field[\"Last Modified Date\"]%>"
  }
  qualification_mapping {
    qualification_name "By Incident Id"
    query "'Incident Number'=\"<%=parameter[\"Incident Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Request Id"
    query "'SRID'=\"<%=parameter[\"Request Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Submitter"
    query "'301572100' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "By User"
    query "'Person ID' = \"<%=parameter[\"Username\"]%>\" AND 'Status' < \"Resolved\" AND 'SRID' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "Closed By PersonId"
    query "'Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Status' >= \"Resolved\" AND 'SRID' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "Open By PersonId"
    query "'Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Status' < \"Resolved\" AND 'SRID' = $\\NULL$"
  }
}
model_mapping {
  name "Activity Incident Work Info"
  model_name "Activity Incident Work Info"
  bridge_name "Remedy Server - Local"
  structure "HPD:WorkLog"
  status "Inactive"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Work Log Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Source"
    field_mapping "<%=field[\"Communication Source\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Type"
    field_mapping "<%=field[\"Work Log Type\"]%>"
  }
  qualification_mapping {
    qualification_name "By Incident Id"
    query "'Incident Number'=\"<%=parameter[\"Incident Id\"]%>\""
  }
}
model_mapping {
  name "Activity Incident Work Info - Amway ARS"
  model_name "Activity Incident Work Info"
  bridge_name "BMC Remedy Server - Amway"
  structure "HPD:WorkLog"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Work Log Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Source"
    field_mapping "<%=field[\"Communication Source\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Type"
    field_mapping "<%=field[\"Work Log Type\"]%>"
  }
  qualification_mapping {
    qualification_name "By Incident Id"
    query "'Incident Number'=\"<%=parameter[\"Incident Id\"]%>\""
  }
}
model_mapping {
  name "Activity Request"
  model_name "Activity Request"
  bridge_name "Remedy Server - Local"
  structure "KS_SRV_CustomerSurvey_base"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Create Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Survey_Template_Name\"]%>"
  }
  attribute_mapping {
    attribute_name "Expected Resolution Date"
    field_mapping "<%=field[\"Attribute63\"]%>"
  }
  attribute_mapping {
    attribute_name "Has Children"
    field_mapping "<%=field[\"Attribute64\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"CustomerSurveyID\"]%>"
  }
  attribute_mapping {
    attribute_name "Instance Id"
    field_mapping "<%=field[\"instanceId\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"ValidationStatus\"]%>"
  }
  qualification_mapping {
    qualification_name "By Submitter"
    query "1=1"
  }
  qualification_mapping {
    qualification_name "Closed By Submitter"
    query "'ApplicationName'=\"Kinetic Request\" AND ('Submitter' = \"<%=parameter[\"Submitter\"]%>\" OR 'Attribute6' = \"<%=parameter[\"Submitter\"]%>\")AND 'Submit Type' = $\\NULL$ AND 'Request_Status' = \"Closed\" AND NOT 'Survey_Template_Name' LIKE \"Process%\" AND NOT 'Survey_Template_Name' LIKE \"Feedback Form\""
  }
  qualification_mapping {
    qualification_name "Draft By Submitter"
    query "'ApplicationName'=\"Kinetic Request\" AND 'Submitter' = \"<%=parameter[\"Submitter\"]%>\" AND 'Submit Type' = $\\NULL$ AND 'Status' = \"In Progress\""
  }
  qualification_mapping {
    qualification_name "Open By Submitter"
    query "'ApplicationName'=\"Kinetic Request\" AND ('Submitter' = \"<%=parameter[\"Submitter\"]%>\" OR 'Attribute6'=\"<%=parameter[\"Submitter\"]%>\")AND 'Submit Type' = $\\NULL$ AND 'Request_Status' = \"Open\" AND NOT 'Survey_Template_Name' LIKE \"Process%\" AND NOT 'Survey_Template_Name' LIKE \"Feedback Form\" AND 'Status' = \"Completed\""
  }
}
model_mapping {
  name "Activity Work Order"
  model_name "Activity Work Order"
  bridge_name "Remedy Server - Local"
  structure "WOI:WorkOrder"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Submit Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Description"
    field_mapping "<%=field[\"Summary\"]%>"
  }
  attribute_mapping {
    attribute_name "Id"
    field_mapping "<%=field[\"Work Order ID\"]%>"
  }
  attribute_mapping {
    attribute_name "Status"
    field_mapping "<%=field[\"Status\"]%>"
  }
  attribute_mapping {
    attribute_name "Status Reason"
    field_mapping "<%=field[\"Status Reason\"]%>"
  }
  qualification_mapping {
    qualification_name "By Request Id"
    query "1=1 AND 'SRID'=\"<%=parameter[\"Request Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "By Submitter"
    query "1=1"
  }
  qualification_mapping {
    qualification_name "By Work Order Id"
    query "1=1 AND 'Work Order ID'=\"<%=parameter[\"Work Order Id\"]%>\""
  }
  qualification_mapping {
    qualification_name "Closed By PersonId"
    query "'Customer Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Status' >= \"Completed\" AND 'SRID' = $\\NULL$"
  }
  qualification_mapping {
    qualification_name "Open By PersonId"
    query "'Customer Person ID' = \"<%=parameter[\"PersonId\"]%>\" AND 'Status' < \"Completed\" AND 'SRID' = $\\NULL$"
  }
}
model_mapping {
  name "Activity Work Order Work Info"
  model_name "Activity Work Order Work Info"
  bridge_name "Remedy Server - Local"
  structure "WOI:WorkInfo"
  status "Active"
  attribute_mapping {
    attribute_name "Created At"
    field_mapping "<%=field[\"Work Log Date\"]%>"
  }
  attribute_mapping {
    attribute_name "Source"
    field_mapping "<%=field[\"Communication Source\"]%>"
  }
  attribute_mapping {
    attribute_name "Summary"
    field_mapping "<%=field[\"Description\"]%>"
  }
  attribute_mapping {
    attribute_name "Type"
    field_mapping "<%=field[\"Work Log Type\"]%>"
  }
  qualification_mapping {
    qualification_name "By Work Order Id"
    query "'Work Order ID'=\"<%=parameter[\"Work Order Id\"]%>\""
  }
}


bridge {
  name "Remedy Server - Local"
  bridge_url "http://localhost/kineticArsBridge/api/1.0/"
  status "Active"
}
bridge {
  name "Remote Remedy Server - ITSM"
  bridge_url "http://remotehost/kineticArsBridgeRemoteARS01/api/1.0/"
  status "Active"
}