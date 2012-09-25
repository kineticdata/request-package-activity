<%@page contentType="text/html; charset=UTF-8"%>
<%@include file="../../framework/includes/packageInitialization.jspf"%>
<%
    if (context == null) {
        ResponseHelper.sendUnauthorizedResponse(response);
    } else {
        /***********************************************************************
         * LOAD AND VALIDATE THE CONFIGURATION
         **********************************************************************/
        String name = request.getParameter("name");
        JsonBase activityConfig = ConfigurationHelper.getConfiguration().getObject(name);

       /*********************************************************************** 
        * PROCESS THE REQUEST PARAMETERS
        ***********************************************************************/
        // Handle the sources parameter.  It will be converted to a string array
        // that lists each of the sources to retrieve data from.  If this
        // parameter is not specified we default to use all of the sources found
        // in the configuration object.  If the param is specified we check that
        // the length is not equal to zero, we also check that each of the
        // specified source is defined in the configuration object.
        String sourcesParam = request.getParameter("sources");
        String[] sources;
        if (sourcesParam == null) {
            List<String> keys = activityConfig.getObject("sources").getKeys();
            sources = keys.toArray(new String[keys.size()]);
        } else {
            sources = request.getParameter("sources").split(",");
            if (sources.length == 0) {
                throw new RuntimeException("The sources parameter cannot have a length of zero.");
            }
            for (String source : sources) {
                if (source == null) {
                    throw new RuntimeException("The sources parameter has invalid value '" + sources + "'.");
                } else if (!activityConfig.getObject("sources").getKeys().contains(source)) {
                    throw new RuntimeException("A source requested '" + source + "' is not configured.");
                }
            }
        }
        
        // Handle the offsets parameter.  It will be converted to a map that
        // maps the source name to the correct offset.  If this parameter is not
        // specified we default the offset for each source to 0.  If the param
        // is specified we first ensure that the length of the offsets is equal
        // to the length of the sources.  Then we iterate through the sources
        // and offsets mapping values, note that we assume that they are in the
        // same order.
        String offsetsParam = request.getParameter("offsets");
        Map<String, Integer> offsets = new HashMap<String, Integer>();
        if (offsetsParam == null) {
            for (String source : sources) {
                offsets.put(source, 0);
            }
        } else {
            String[] offsetStrings = offsetsParam.split(",");
            if (offsetStrings.length != sources.length) {
                throw new RuntimeException("The offsets parameter length (" + offsetStrings.length +
                        ") must be equal to the sources parameter length (" + sources.length + ")");
            }
            for (int i=0; i<sources.length; i++) {
                offsets.put(sources[i], Integer.parseInt(offsetStrings[i]));
            }
        }

        // Handle the pageSize parameter.  If this parameter is not specified
        // we default it to 15.  If one is specified we convert it to an int
        // variable.
        String pageSizeParam = request.getParameter("pageSize");
        int pageSize;
        if (pageSizeParam == null) {
            pageSize = 15;
        } else {
            pageSize = Integer.parseInt(pageSizeParam);
        }

        // Handle the sortOrder parameter.  If this parameter is not specified
        // we default it to descending.  If the value specified is neither
        // ascending nor descending we throw and error.
        String sortOrder = request.getParameter("sortOrder");
        if (sortOrder == null) {
            sortOrder = "descending";
        } else if (!sortOrder.equals("ascending") && !sortOrder.equals("descending")) {
            throw new RuntimeException("The sortOrder parameter specified '" + sortOrder + "' is invalid");
        }

       /************************************************************************
        * BEGIN PROCESSING THE REQUEST
        ***********************************************************************/
        // Make the bridge calls to retrieve data from each of the sources.
        // More documentation regarding this process to come.
        BridgeConnector connector = new KsrBridgeConnector(context, "KS00505696001C8HtgUA3iG5BgbqID");
        Map<String, RecordList> sourceRecords = new java.util.HashMap<String, RecordList>();
        Map<String, Integer> totals = new java.util.HashMap<String, Integer>();
        for (String source : sources) {
            JsonBase sourceConfig = activityConfig.getObject("sources").getObject(source);
            String model = sourceConfig.getString("modelName");
            String qualification = sourceConfig.getString("qualificationName");
            
            // Build parameters map
            Map<String, String> parameters = new java.util.HashMap<String, String>();
            List<String> parameterNames = sourceConfig.getStringArray("parameterNames");
            for (String parameterName : parameterNames) {
                if (parameterName.equals("Submitter")) {
                    parameters.put("Submitter", context.getUserName());
                } else if (parameterName.equals("Request Id")) {
                    parameters.put("Request Id", request.getParameter("requestId"));
                }
            }

            // Build metadata
            Map<String, String> metadata = new java.util.HashMap<String, String>();
            // Added this condition for the child records call and page size zero
            // feature.  If a pageSize of zero is specified we simple will return
            // all records that match the qualification.
            if (pageSize != 0) {
                metadata.put("offset", String.valueOf(offsets.get(source)));
                metadata.put("pageSize", String.valueOf(pageSize));
            }
            String dateTimeAttribute = sourceConfig.getString("dateTimeAttribute");
            if (sortOrder.equals("ascending")) {
                metadata.put("order", "<"+"%=attribute[\""+dateTimeAttribute+"\"]%"+">:ASC");
            } else if (sortOrder.equals("descending")) {
                metadata.put("order", "<"+"%=attribute[\""+dateTimeAttribute+"\"]%"+">:DESC");
            }
            
            // Build attribute array
            List<String> attributeList = new ArrayList<String>();
            for (String columnName : activityConfig.getStringArray("columns")) {
                String attributeName = sourceConfig.getObject("columnAttributeMappings").getString(columnName);
                if (attributeName != null) {
                    attributeList.add(attributeName);
                }
            }
            String[] attributes = attributeList.toArray(new String[attributeList.size()]);
            
            Count count = connector.count(model, qualification, parameters);
            totals.put(source, count.value());
            RecordList recordList = connector.search(model, qualification, parameters, metadata, attributes);
            sourceRecords.put(source, recordList);
        }

        // Here we build a sorted list of the resulting records.
        // Build the simple date format
        SimpleDateFormat iso8601Format = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'+0000'");
        iso8601Format.setTimeZone(java.util.TimeZone.getTimeZone("GMT"));
        List<Record> sortedRecords = new ArrayList<Record>();
        List<String> sortedRecordSources = new ArrayList<String>();
        while (true) {
            Record topRecord = null;
            String topSource = null;
            Date topDate = null;
            for (String source : sources) {
                Record record = sourceRecords.get(source).first();
                if (record != null) {
                    Date date = iso8601Format.parse(record.get("Created At"));
                    if ((topSource == null) || 
                        (sortOrder.equals("ascending") && date.before(topDate)) || 
                        (sortOrder.equals("descending") && date.after(topDate))) {
                        topRecord = record;
                        topSource = source;
                        topDate = date;
                    }
                }
            }
            if (topSource == null) {
                break;
            }
            sourceRecords.get(topSource).remove(0);
            sortedRecords.add(topRecord);
            sortedRecordSources.add(topSource);
        }
        
        // Get page size number of records from the sorted records array.  Also
        // check each record for the source updating the counts as we go along.
        Map<String, Integer> counts = new java.util.HashMap<String, Integer>();
        for (String source: sources) {
            counts.put(source, 0);
        }
        List<Record> selectedRecords = new ArrayList<Record>();
        List<String> selectedRecordSources = new ArrayList<String>();
        for (int i=0; i<pageSize && i<sortedRecords.size(); i++) {
            Record record = sortedRecords.get(i);
            String source = sortedRecordSources.get(i);
            counts.put(source, counts.get(source) + 1);
            selectedRecords.add(record);
            selectedRecordSources.add(source);
        }
        // Added this piece of code for the child records call and page size zero
        // feature.
        if (pageSize == 0) {
            selectedRecords = sortedRecords;
            selectedRecordSources = sortedRecordSources;
        }
        
        /***********************************************************************
         * BUILD AND RETURN THE RESPONSE OUTPUT
         **********************************************************************/
        org.json.simple.JSONArray columnArray = new org.json.simple.JSONArray();
        for (String columnName : activityConfig.getStringArray("columns")) {
            columnArray.add(columnName);
        }

        org.json.simple.JSONArray offsetArray = new org.json.simple.JSONArray();
        for (String source : sources) {
            offsetArray.add(offsets.get(source));
        }
        
        org.json.simple.JSONArray sourceArray = new org.json.simple.JSONArray();
        for (String source : sources) {
            sourceArray.add(source);
        }

        org.json.simple.JSONArray recordArrays = new org.json.simple.JSONArray();
        for (Record record : selectedRecords) {
            String source = selectedRecordSources.get(selectedRecords.indexOf(record));
            org.json.simple.JSONObject recordObject = new org.json.simple.JSONObject();
            for (String columnName : activityConfig.getStringArray("columns")) {
                String attributeName = activityConfig.getObject("sources").getObject(source).getObject("columnAttributeMappings").getString(columnName);
                recordObject.put(columnName, record.get(attributeName));
            }
            recordArrays.add(recordObject);            
        }
        
        org.json.simple.JSONArray recordSourceArray = new org.json.simple.JSONArray();
        for (String recordSource : selectedRecordSources) {
            recordSourceArray.add(recordSource);
        }
        
        org.json.simple.JSONArray countArray = new org.json.simple.JSONArray();
        for (String source : sources) {
            countArray.add(counts.get(source));
        }
        
        org.json.simple.JSONArray totalArray = new org.json.simple.JSONArray();
        for (String source : sources) {
            totalArray.add(totals.get(source));
        }

        // Write to output stream
        out.clear();
%>
{
    "records"       : <%= recordArrays.toJSONString() %>,
    "recordSources" : <%= recordSourceArray.toJSONString() %>,
    "columns"       : <%= columnArray.toJSONString() %>,
    "sources"       : <%= sourceArray.toJSONString() %>,
    "offsets"       : <%= offsetArray.toJSONString() %>,
    "counts"        : <%= countArray.toJSONString() %>,
    "totals"        : <%= totalArray.toJSONString() %>,
    "pageSize"      : <%= pageSize %>,
    "sortOrder"     : "<%= sortOrder %>"
}
<%
    }
%>