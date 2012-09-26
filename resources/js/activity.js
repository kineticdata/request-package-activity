var activityTable;
jQuery(document).ready(function() {
    activityTable = new ActivityTable({
        name: "activity",
        container: "#activity",
        configurationCallback: function(self, options) {
            options.aoColumns = [
                {mData: null, sWidth: "25px",
                    fnCreatedCell: function(element, sData, oData, iRow, iColumn) {
                        //if (oData["Has Children"] === "Has Children") {
                            childrenCellCallback(element, sData, oData, iRow, iColumn);
                        //}
                    }
                },
                {mData: "Id", sTitle: "Id", sWidth: "125px",
                    fnCreatedCell: function(element, sData, oData, iRow, iColumn) {
                        idCellCallback(element, sData, oData, iRow, iColumn);
                    }
                },
                {mData: "Status", sTitle: "Status", sWidth: "100px"},
                {mData: "Created At", sTitle: "Created At", sWidth: "150px",
                    fnRender: function(o) {return formatDate(o.aData["Created At"]);}
                },
                {mData: "Description", sTitle: "Description", sWidth: "405px"},
                {mData: "Source", sWidth: "75px",
                    fnRender: function(o) {return self.recordSources[o.iDataRow];},
                    fnCreatedCell: function(element) {jQuery(element).addClass("source");}
                }
            ];
        },
        loadStartCallback: function(self) {
            jQuery("#overlay").show();
            jQuery("#messages .message").hide();
            jQuery("#messages .message.loading").show();
        },
        loadCompleteCallback: function(self) {
            jQuery("#messages .message.loading").hide();
            if (self.status === "success") {
                if (jQuery(".tableControls .tableControl.sources .sourcesCheckboxes input[type=checkbox]").length === 0) {
                    var sources = jQuery(".tableControls .tableControl.sources .sourcesCheckboxes");
                    jQuery.each(activityTable.sources, function(index, value) {
                        var input = jQuery('<div><input type="checkbox" value="' + value + '">' + value + '</option></div>');
                        jQuery(sources).append(input);
                    });
                }
                
                jQuery(".tableControls .tableControl.sources .sourcesCheckboxes input[type=checkbox]").each(function(index, element) {
                    if (self.sources.indexOf(jQuery(element).val()) >= 0) {
                        jQuery(element).attr("checked", "checked");
                    } else {
                        jQuery(element).attr("checked", null);
                    }
                });
                jQuery(".tableControls .tableControl.sortOrder select").val(activityTable.sortOrder);
                jQuery(".tableControls .tableControl.pageSize select").val(activityTable.pageSize);
                
                var offset = 0;
                jQuery.each(self.stack[self.stack.length-1], function(index, number) { offset += number; });
                var count = 0;
                jQuery.each(self.counts, function(index, number) { count += number; });
                var total = 0;
                jQuery.each(self.totals, function(index, number) { total += number; });
                jQuery("#messages .message.success .content").text((offset+1) + "-" + (offset+count) + " of " + total + " records");
                jQuery("#messages .message.success").show();
            } else if (self.status === "error") {
                jQuery("#messages .message.error .content").text(self.statusText);
                jQuery("#messages .message.error").show();
            }
            jQuery("#overlay").hide();
        }
    });
    activityTable.initialize();
    
    jQuery(".tableControls .tableControl.nextPage").click(function() {
        activityTable.nextPage();
    });
    jQuery(".tableControls .tableControl.previousPage").click(function() {
        activityTable.previousPage();
    });
    jQuery(".tableControls .tableControl.refresh").click(function() {
        activityTable.refreshPage();
    });
    jQuery(".tableControls .tableControl.sources input.modify").click(function() {
        jQuery(this).parents(".tableControl.sources").find(".sourcesSelector").slideToggle();
    });
    jQuery(".tableControls .tableControl.sources input.save").click(function() {
        jQuery(this).parents(".sourcesSelector").slideUp();
        activityTable.sources = [];
        jQuery(this).parents(".tableControl.sources").find(".sourcesCheckboxes input:checked").each(function(index, element) {
            activityTable.sources.push(jQuery(element).val());
        });
        activityTable.initialize();
    });
    
    jQuery(".tableControls .tableControl.sortOrder select").change(function() {
        activityTable.sortOrder = jQuery(this).val();
        activityTable.initialize();
    });
    jQuery(".tableControls .tableControl.pageSize select").change(function() {
        activityTable.pageSize = jQuery(this).val();
        activityTable.initialize();
    });
});

function idCellCallback(element, sData, oData, iRow, iColumn) {
    jQuery(element).empty();
    var anchorElement = jQuery('<a href="javascript:void(0)">'+oData["Id"]+'</a>');
    jQuery(element).append(anchorElement);
    jQuery(anchorElement).click(function() {
        if (oData["Source"] === "Request") {
            getRequestDialog(oData["Instance Id"]);
        } else if (oData["Source"] === "Change") {
            getChangeDialog(oData["Id"]);
        } else if (oData["Source"] === "Incident") {
            getIncidentDialog(oData["Id"]);
        } else if (oData["Source"] === "Work Order") {
            getWorkOrderDialog(oData["Id"]);
        }
    });
}

function childrenCellCallback(element, sData, oData, iRow, iColumn) {
    jQuery(element).empty();
    var minAnchor = jQuery('<a class="minimize hidden" href="javascript:void(0)">-</a>');
    var maxAnchor = jQuery('<a class="maximize" href="javascript:void(0)">+</a>');
    var loadingImage = jQuery('<img class="hidden" src="' + BUNDLE.bundlePath + 'common/resources/images/spinner_00427E_FFFFFF.gif"></img>');
    jQuery(element).addClass("links");
    jQuery(element).append(maxAnchor);
    jQuery(element).append(minAnchor);
    jQuery(element).append(loadingImage);
    var currentRow = jQuery(element).parent("tr");
    var childRow, childContent;
    maxAnchor.click(function() {
        maxAnchor.hide();
        loadingImage.show();
        BUNDLE.ajax({
            url: "/kinetic/themes/edge/packages/activity/interface/callbacks/activity.json.jsp",
            data: {
                name: "children",
                requestId: oData["Id"],
                pageSize: 0
            },
            success: function(data) {
                loadingImage.hide();
                minAnchor.show();
                var response = jQuery.parseJSON(data);
                childRow = jQuery('<tr class="child"><td colspan="6"><div class="childContainer"><table class="childTable"></table></div></td></tr>');
                currentRow.after(childRow);
                var dataTableOptions = {
                    bPaginate: false,
                    bFilter: false,
                    bSort: false,
                    bInfo: false,
                    bAutoWidth: false,
                    aoColumns: [
                        {mData: "Id", sWidth: "125px",
                         fnCreatedCell: function(element, sData, oData, iRow, iColumn) {
                             idCellCallback(element, sData, oData, iRow, iColumn);
                         }},
                        {mData: "Status", sWidth: "100px"},
                        {mData: "Created At", sWidth: "150px",
                         fnRender: function(o) {return formatDate(o.aData["Created At"]);}},
                        {mData: "Description", sWidth: "405px"},
                        {mData: "Source", sWidth: "75px",
                         fnRender: function(o) {return "Incident";},
                         fnCreatedCell: function(element) {jQuery(element).addClass("source");}
                        }
                    ],
                    aaData: [
                        {"Source" : "Incident", "Status" : "Closed","Description":"User needs access to specific applications.","Instance Id":null,"Has Children":null,"Id":"INC_CAL_1000001","Created At":"2008-11-07T05:14:15+0000"},
                        {"Source" : "Incident", "Status" : "Closed","Description":"User needs access to specific applications.","Instance Id":null,"Has Children":null,"Id":"INC_CAL_1000001","Created At":"2008-11-07T05:14:15+0000"}
                    ]
                    //aaData: response["records"]
                };
                childRow.find(".childTable").dataTable(dataTableOptions);
                childRow.find(".childContainer").slideDown(200);
            }
        });
    });
    minAnchor.click(function() {
        childRow.find(".childContainer").slideUp(200, function() {
            childRow.remove();
            minAnchor.hide();
            maxAnchor.show();
        });
    });
}
function getRequestDialog(submissionInstanceId) {
    BUNDLE.ajax({
        url: BUNDLE.bundlePath + "packages/submissions/interface/callbacks/submissionDetails.html.jsp",
        data: {csrv: submissionInstanceId},
        success: function(data) {
            createDialog(data);
        }
    });
}
function getChangeDialog(changeId) {
    BUNDLE.ajax({
        url: BUNDLE.packagePath + "interface/callbacks/changeDialog.html.jsp",
        data: {id: changeId},
        success: function(data) {
            createDialog(data);
        }
    });
}
function getIncidentDialog(incidentId) {
    BUNDLE.ajax({
        url: BUNDLE.packagePath + "interface/callbacks/incidentDialog.html.jsp",
        data: {id: incidentId},
        success: function(data) {
            createDialog(data);
        }
    });
}
function getWorkOrderDialog(workOrderId) {
    BUNDLE.ajax({
        url: BUNDLE.packagePath + "interface/callbacks/workOrderDialog.html.jsp",
        data: {id: workOrderId},
        success: function(data) {
            createDialog(data);
        }
    });
}
function createDialog(content) {
    var element = jQuery(content);
    element.find(".value.dateTime").each(function(index, value) {
       jQuery(value).text(formatDate(jQuery(value).text())); 
    });
    jQuery('body').append(element);
    element.dialog({
        closeText: 'close',
        width: 500
    });
    $(element).parent().append('<div class="kd-shadow"></div>');
}

function formatDate(dateString) {
    var match = dateString.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\+0000/);
    if (match === null) {
        throw "Invalid date string given to formatDate: '" + dateString + "'";
    }
    var date = new Date();
    date.setUTCFullYear(match[1], parseInt(match[2].replace(/^0/,""))-1, match[3]);
    date.setUTCHours(match[4], match[5], match[6]);
    if (BUNDLE.config.locale === "EN") {
        return date.format("mmm d yyyy h:MM:ss TT");
    } else {
        return date.format("isoDateTime");
    }
}