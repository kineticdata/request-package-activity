// Declare the activityTable variable that will point to the activity table
// instance in the global scope.
var activityTable;

// Here we define the configuration for the columns of the table that will
// displayed.  This is done here for two reasons: it cleans up the
// instantiation of the activity table as well as it is required twice for
// this implementation of the activity console.  Note that for each column,
// after the cell is created we wrap its contents with a div that gives us
// more styling leverage over the element.  Some of the columns also
// require formatting of the data before it is rendered (for example we
// format the date of the created at column).
var columnConfig = [
    // Create a column that acts as a table control but does not represent
    // any data.  This column will show maximize/minimize controls if the
    // record contains related child records.  This cell callback has been
    // put in another method named childrenCellCallback (see below) for
    // cleanliness.
    {mData: null,
        fnCreatedCell: function(element, sData, oData, iRow, iColumn) {
            if (oData["Has Children"] === "Has Children") {
                childrenCellCallback(element, sData, oData, iRow, iColumn);
            }
            jQuery(element).wrapInner('<div class="wrapper links">');
        }},
    // For the Id column we replace the text content with a link that has a
    // javascript click event bound to it.  This cell callback has been put
    // in another method named idCellCallback (see below) for cleanliness.
    {mData: "Id", sTitle: "Id",
        fnCreatedCell: function(element, sData, oData, iRow, iColumn) {
            idCellCallback(element, sData, oData, iRow, iColumn);
            jQuery(element).wrapInner('<div class="wrapper id">');
        }},
    {mData: "Status", sTitle: "Status",
        fnCreatedCell: function(element) {
            jQuery(element).wrapInner('<div class="wrapper status">');
        }},
    // For the Created At column we use the formatDate function to convert
    // the date to a more user-friendly format.
    {mData: "Created At", sTitle: "Created At",
        fnRender: function(o) {
            return formatDate(o.aData["Created At"]);
        },
        fnCreatedCell: function(element) {
            jQuery(element).wrapInner('<div class="wrapper createdAt">');
        }},
    {mData: "Description", sTitle: "Description",
        fnCreatedCell: function(element) {
            jQuery(element).wrapInner('<div class="wrapper description">');
        }},
    // For the Source column, there is initially no data, but we get the
    // source by using the recordSources array returned within the activity
    // table to determine which source this row belongs to.
    {mData: "Source",
        fnRender: function(o) {return activityTable.recordSources[o.iDataRow];},
        fnCreatedCell: function(element) {
            jQuery(element).addClass("source");
            jQuery(element).wrapInner('<div class="wrapper source">');
        }}
];


jQuery(document).ready(function() {
    // Here we instantiate the main activity table of the page.  This invovles
    // passing in a few configuration parameters as well as defining some
    // callback handlers that are called when requests are sent and responded to
    // as well as one for configuration of the underlying datatable.
    activityTable = new ActivityTable({
        name: "status",
        container: "#status",
        templateId: BUNDLE.config.templateId,
        // Use the column configuration defined above.
        configurationCallback: function(self, options) {
            options.aoColumns = columnConfig;
        },
        // Add a modal overlay that prevents users from clicking on other
        // controls.  Also hide any current messages and display the loading
        // message.
        loadStartCallback: function(self) {
            jQuery("#overlay").show();
            jQuery("#messages .message").hide();
            jQuery("#messages .message.loading").show();
        },
        // Remove the modal overlay.  If the request returned successfully we
        // update each of the controls with metadata from the call.  We also
        // hide the loading message and display a success message.  If the
        // request returned with an error we will display an error message.
        loadCompleteCallback: function(self) {
            jQuery("#messages .message.loading").hide();
            if (self.status === "success") {
                // If this is the first time the table has been loaded we will
                // generate a checkbox for each source in the sources control.
                // We assume that it is the first time loaded when there are no
                // source checkboxes already existing.
                if (jQuery(".tableControls .tableControl.sources .sourcesCheckboxes input[type=checkbox]").length === 0) {
                    var sources = jQuery(".tableControls .tableControl.sources .sourcesCheckboxes");
                    jQuery.each(activityTable.sources, function(index, value) {
                        var input = jQuery('<div><input type="checkbox" value="' + value + '">' + value + '</option></div>');
                        jQuery(sources).append(input);
                    });
                }
                // Here we set the value of each checkbox in the sources control
                // to reflect the sources in the metadata of the response.
                jQuery(".tableControls .tableControl.sources .sourcesCheckboxes input[type=checkbox]").each(function(index, element) {
                    if (arrayContains(self.sources, jQuery(element).val())) {
                        jQuery(element).attr("checked", "checked");
                    } else {
                        jQuery(element).attr("checked", null);
                    }
                });
                // Update the other controls to reflect the metadata of the
                // response.
                jQuery(".tableControls .tableControl.sortOrder select").val(activityTable.sortOrder);
                jQuery(".tableControls .tableControl.pageSize select").val(activityTable.pageSize);
                // Generate a success message that contains some information
                // about how many and which records are being viewed out of the
                // total.  These values are calculated using metadata of the
                // response.
                var offset = 0;
                jQuery.each(self.stack[self.stack.length-1], function(index, number) { offset += number; });
                var count = 0;
                jQuery.each(self.counts, function(index, number) { count += number; });
                var total = 0;
                jQuery.each(self.totals, function(index, number) { total += number; });
                jQuery("#messages .message.success .content").text((offset+1) + "-" + (offset+count) + " of " + total + " records");
                jQuery("#messages .message.success").show();
            } else if (self.status === "error") {
                jQuery("#messages .message.error .content").text("There was an error retrieving table data.");
                jQuery("#messages .message.error").show();
            }
            jQuery("#overlay").hide();
        }
    });
    activityTable.initialize();
    
    // Here we bind functions to the table controls.
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

// This function is a callback handler for the cells that represent record ids.
// It replaces the standard text with a link that contains the record id.  Also
// a javascript click event is bound to each link.  When clicked another
// function will be called depending on the source of record.
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
        }
    });
}

// This function is a callback handler for the cells that contain child data
// controls (maximize/minimize).  It replaces the standard text with the
// maximize/minimize links and binds events to each.  When the maximize link is
// clicked we make a call to the activity.json.jsp to retrieve child data.  A
// row is then added below the current one and the new data is presented using
// a slide down animation.  Also the maximize link is then hidden and a minimize
// link will be shown.  When the minimize link is clicked the child data row is
// hidden using a slide up animation and the minimize link is hidden and the
// maximize link is redisplayed.
function childrenCellCallback(element, sData, oData, iRow, iColumn) {
    jQuery(element).empty();
    var minAnchor = jQuery('<a class="minimize hidden" href="javascript:void(0)">-</a>');
    var maxAnchor = jQuery('<a class="maximize" href="javascript:void(0)">+</a>');
    var loadingImage = jQuery('<img class="hidden" src="' + BUNDLE.packagePath + 'resources/images/spinner_00427E_FFFFFF.gif"></img>');
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
            url: BUNDLE.packagePath + "interface/callbacks/activity.json.jsp",
            data: {
                name: "children",
                requestId: oData["Id"],
                templateId: BUNDLE.config.templateId,
                pageSize: "all"
            },
            success: function(data) {
                loadingImage.hide();
                minAnchor.show();
                var response = jQuery.parseJSON(data);
                childRow = jQuery('<tr class="childRow"><td colspan="6"><div class="childContainer"><table class="childTable"></table></div></td></tr>');
                currentRow.after(childRow);
                var dataTableOptions = {
                    bPaginate: false,
                    bFilter: false,
                    bSort: false,
                    bInfo: false,
                    bAutoWidth: false,
                    aoColumns: columnConfig,
                    aaData: response["records"]
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
        data: {
            id: changeId,
            templateId: BUNDLE.config.templateId
        },
        success: function(data) {
            createDialog(data);
        }
    });
}
function getIncidentDialog(incidentId) {
    BUNDLE.ajax({
        url: BUNDLE.packagePath + "interface/callbacks/incidentDialog.html.jsp",
        data: {
            id: incidentId,
            templateId: BUNDLE.config.templateId
        },
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

/*
 * This function takes a ISO8601 date string (the exact format expected from a
 * bridge request) and converts it to a more user-friendly format.
 */
function formatDate(dateString) {
    var match = dateString.match(/(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\+0000/);
    if (match === null) {
        throw "Invalid date string given to formatDate: '" + dateString + "'";
    }
    var date = new Date();
    date.setUTCFullYear(match[1], parseInt(match[2].replace(/^0/,""))-1, match[3]);
    date.setUTCHours(match[4], match[5], match[6]);
    return date.format("mmm d yyyy h:MM:ss TT");
}

/*
 * This function takes an array and a value.  It returns true if the value
 * exists within the array otherwise it returns false.  This is useful because
 * the other way of checking this (the indexOf method) is not supported by IE7.
 */
function arrayContains(array, value) {
    for (var i=0; i<array.length; i++) {
        if (array[i] === value) { return true; }
    }
    return false;
}