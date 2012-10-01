/*
 * This is a helper function that makes it possible to use the "this" keyword
 * within callback functions and have it refer to what "this" was when the
 * callback was defined instead of the window object.
 */
var __bind = function(fn, me) {
    return function() {
        return fn.apply(me, arguments); 
    };
};

/*
 * Constructor for the ActivityTable "class".
 * Valid options are as follows:
 * 
 * container - This is a css style selector that represents the table that will
 *             be populated.
 * configurationCallback - This is a function that will be called after the
 *                         datatable configuration object is set up by default
 *                         but before the table is intialized.  This provides a
 *                         hook to customize the datatable.
 * loadStartCallback - This is a function that will be called just before an
 *                     ajax request is made.  This provides a hook to show a
 *                     loading message or spinner, disable buttons, etc.
 * loadCompleteCallback - This is a function that will be called just after an
 *                        ajax request is made.  This provides a hook to show
 *                        hide loading messages, enable buttons, etc.
 * 
 * Note that the options defined above are also stored as members of the object
 * upon construction.
 * Here are some descriptions of the members that belong to an ActivityTable
 * object:
 * 
 * table - The datatables object representing the final table being
 *         displayed.
 * sources - An array of sources that the activity console is displaying.
 *           This variable can be modified and is passed to subsequent ajax        
 *           calls to modify which sources are displayed.
 * sortOrder - A string with a value of either "ascending" or "descending".
 *             This variable can be changed and is passed to subsequent ajax
 *             calls to modify the order which records are sorted by.
 * pageSize - A number that limits how many records are shown per page.
 *            This variable can be changed and is passed to subsequent ajax
 *            calls to modify how many records are displayed per page.
 * records
 * recordSources
 * counts - An array of numbers (the same length as sources) returned from
 *          ajax calls that represents how many records of each source was
 *          returned.  It is used when calculating offsets for the next page
 *          requests.
 * totals - An array of numbers (the same length as sources) returned from
 *          ajax calls that represents how many total records exist for each
 *          source.  It is used when determining whether the current page is
 *          the last page.
 *  stack - An array of arrays, treated as a stack, that tracks the offsets
 *          used to retrieve each page.  The item on the top of the stack
 *          is an array that represents the offsets for the current page.
 *          The items below the top of the stack represnt offsets for
 *          previous pages.  Offset arrays are pushed to the stack when a
 *          next page is retrieved.
 *  status
 *  statusText
 */
function ActivityTable(options) {
    this.name = options["name"];
    this.container = options["container"];
    this.configurationCallback = options["configurationCallback"];
    this.loadStartCallback = options["loadStartCallback"];
    this.loadCompleteCallback = options["loadCompleteCallback"];
}

// This function performs the general things all ajax calls to the
// activityTable.json.jsp.  It uses the current state variables when
// building the request and it sets the proper state variables after the
// response.  It then calls a success callback function passed to it from
// the caller for more specific processing of the response.
ActivityTable.prototype.doRequest = function(offsets, callback) {
    if (this.loadStartCallback) {this.loadStartCallback(this);}
    data = {name: this.name};
    if (this.sources !== undefined) {data["sources"] = this.sources.join(",");}
    if (this.pageSize !== undefined) {data["pageSize"] = this.pageSize;}
    if (this.sortOrder !== undefined) {data["sortOrder"] = this.sortOrder;}
    if (offsets) {data["offsets"] = offsets.join(",");}
    jQuery.ajax({
        url: BUNDLE.packagePath + "interface/callbacks/activity.json.jsp",
        data: data,
        success: __bind(function(data) {
            // Parse the response object.
            var response = jQuery.parseJSON(data);
            this.status = "success";
            this.sources = response["sources"];
            this.columns = response["columns"];
            this.sortOrder = response["sortOrder"];
            this.pageSize = response["pageSize"];
            this.counts = response["counts"];
            this.totals = response["totals"];
            this.recordSources = response["recordSources"];
            if (callback) {callback(response);}
            if (this.loadCompleteCallback) {this.loadCompleteCallback(this);}
        }, this),
        error: __bind(function(data) {
            this.status = "error";
            this.statusText = data.statusText;
            if (this.loadCompleteCallback) {this.loadCompleteCallback(this);}
        }, this)
    });
}


// This function initializes the activity table.  It calls the doRequest method
// without passing any offsets and adds a callback handler that configures and
// initializes the datatable.
ActivityTable.prototype.initialize = function() {
    this.doRequest(null,__bind(function(response) {
            var dataTableOptions = {
                "bPaginate": false,
                "bFilter": false,
                "bSort": false,
                "bInfo": false,
                "bDestroy": true,
                "bAutoWidth": false,
                "aoColumns": [
                    {"mData": "Id", "sTitle": "Id"},
                    {"mData": "Letter", "sTitle": "Letter"},
                    {"mData": "Created At", "sTitle": "Created At"}
                ],
                "aaData": response["records"]
            };
            if (this.configurationCallback) {this.configurationCallback(this, dataTableOptions);}
            this.table = jQuery(this.container).dataTable(dataTableOptions);
            this.stack = [];
            this.stack.push(response["offsets"]);
        }, this));
 }
 
// This method performs a general get page request.  It expects an offsets
// option to be specified and passes that to the doRequest call.  It also
// provides a callback handler that updates the data in the table.  It itself
// also takes a callback handler that it calls within the handler it defines.
// This is done so that next, previous, refresh requests can customize the
// callback behavior.
ActivityTable.prototype.paginate = function(offsets, callback) {
    this.doRequest(offsets, __bind(function(response) {
        this.table.fnClearTable(false);
        this.table.fnAddData(response["records"], true)
        if (callback) {
            callback(response);
        }
    }, this));
}

// This method calls the paginate function using the offsets second from the top
// of the offset stack.  It also adds a success callback handler that pops the
// top set of offsets from the stack.  Note that it also ensures that we are not
// on the first page before firing by using the isFirstPage method.
ActivityTable.prototype.previousPage = function() {
    if (!this.isFirstPage()) {
        this.paginate(this.stack[this.stack.length-2], __bind(function(response) {
            this.stack.pop();
        }, this));
    }
}

// This method calls the paginate function using the offsets from the top of the
// offset stack.  This will result in a query starting from the same indices as
// the ones present.
ActivityTable.prototype.refreshPage = function() {
    this.paginate(this.stack[this.stack.length-1]);
}

// This method calls the paginate method using the nextOffsets helper method to
// calculate the offsets for the next page.  It also adds a success callback
// handler that pushes these new offsets to the offset stack when complete. Also
// note that it ensures that we are not on the last page before firing by using
// the isLastPage method.
ActivityTable.prototype.nextPage = function() {
    if (!this.isLastPage()) {
        this.paginate(this.nextOffsets(), __bind(function(response) {
            this.stack.push(response["offsets"]);
        }, this));
    }
}

// This method calculates the set of offsets that will retrieve the next page.
// This is done by taking the offsets of the current page and for each adding
// the counts of the records on the current page.
ActivityTable.prototype.nextOffsets = function() {
    var result = [];
    for (var i in this.counts) {
        result[i] = this.stack[this.stack.length-1][i] + this.counts[i];
    }
    return result;
}

// This helper method returns a boolean whether or not the current page is the
// first page.  We do this by simply checking the length of the offsets stack.
ActivityTable.prototype.isFirstPage = function() {
    if (this.stack.length === 1) {
        return true;
    } else {
        return false;
    }
}

// This helper method returns a boolean whether or not the current page is the
// last page.  This is done by using the totals values returned from the ajax
// calls.  If all of the next offsets are equal to the total then we know it is
// the last page.
ActivityTable.prototype.isLastPage = function() {
    var next = this.nextOffsets();
    for (var i in this.totals) {
        if (next[i] < this.totals[i]) {
            return false;
        }
    }
    return true;
}