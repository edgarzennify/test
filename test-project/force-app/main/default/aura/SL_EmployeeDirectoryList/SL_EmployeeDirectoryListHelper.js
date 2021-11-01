({
    //toggle the class on the filters
    manageAlphabetFilters: function (component, event, updatedFilterId) {
        var currentFilter = component.find(component.get("v.selectedFilter")),
            updatedFilter = component.find(updatedFilterId);
        component.set("v.selectedFilter", updatedFilterId);
        $A.util.removeClass(currentFilter, 'filterbackground');
        $A.util.addClass(updatedFilter, 'filterbackground');
    },

    searchRecord: function (component, helper) {
        component.set("v.showSpinner", true);
        var strPreviousSearch = component.get('v.strSearchString');

        var btn = component.find("closeBTN");
        if (component.find("searchInput").get("v.value").length > 0) {
            $A.util.removeClass(btn, 'hide');
        } else {
            $A.util.addClass(btn, 'hide');
        }

        if (component.get("v.globalTimeout") != null)
            clearTimeout(component.get("v.globalTimeout"));

        component.set("v.globalTimeout", window.setTimeout($A.getCallback(function () {
            SearchFunc()
        }), 1000));

        function SearchFunc() {
            component.set("v.globalTimeout", null);
            var strSearchString = component.find("searchInput").get("v.value").trim();
            if (strSearchString != null || strSearchString != undefined) {
                var strWithoutSpecChar = strSearchString.replace(/[^\w\s]/gi, '');
                if (strPreviousSearch != strSearchString && (strSearchString == '' || strWithoutSpecChar.length >= 2)) {
                    component.set('v.strSearchString', strSearchString);
                    //helper.fetchListOfEmployees(component);
                    helper.JsSearch(component);
                }
            } else component.set("v.lstEmployees", component.get('v.lstALLEmployeeRecs'));
        }
    },

    fetchListOfEmployees: function (component) {
        var sObjectName = component.get("v.SObjectName"),
            listFieldSetName = component.get("v.ListFieldsetName"),
            detailFieldSetName = component.get("v.DetailFieldsetName"),
            pageSize = component.get("v.RecordsOnLoad"),
            filterCriteria = component.get("v.FilterCriteria"),
            searchString = component.get("v.strSearchString"),
            listViews = component.get("v.ListViews"),
            strlistViewId = component.get("v.selectedListViewId"),
            alphabeticFilterField = component.get("v.FieldForAlphabeticFilter");
        var that = this;
        var action = component.get("c.getListOfEmployees");
        action.setParams({
            "strSObjectName": sObjectName,
            "strEmpListFieldsetName": listFieldSetName,
            "strEmpDetailFieldsetName": detailFieldSetName,
            "strFilterCriteria": filterCriteria,
            "strSearchString": '',
            "strListViews": listViews,
            "strlistViewId": strlistViewId,
            "strFieldForAlphabeticFilter": alphabeticFilterField
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            var order = component.get('v.ListViews').split(',');
            if (component.isValid() && state === "SUCCESS") {
                var ret = response.getReturnValue();
                if (!ret) return;
                var sortedViews = this.sortListOfFilters(
                    ret.lstListViews, 
                    order.map(
                        Function.prototype.call, 
                        String.prototype.trim
                    )
                );
                var totalRecords = ret.lstAllEmployees.length;
                if (ret.lstAllEmployees.length > 0) {
                    component.set("v.startIndex", 0);
                    component.set("v.endIndex", pageSize);
                    component.set("v.showSpinner", false);
                    component.set("v.isValidField", ret.isValidFilterField);
                    component.set("v.FieldForAlphabeticFilter", ret.filterFieldAPI);
                    component.set("v.totalRecords", totalRecords);
                    component.set("v.lstEmployees", ret.lstAllEmployees);
                    component.set('v.lstALLEmployeeRecs', JSON.parse(JSON.stringify(ret.lstAllEmployees)));

                } else {
                    component.set("v.showSpinner", false);
                    component.set("v.lstListView", sortedViews);
                    component.set("v.totalRecords", 0);
                    component.set("v.lstEmployees", ret.lstAllEmployees);
                }
                if (!component.get("v.lstListView") || component.get("v.lstListView").length <= 0) {
                    component.set("v.lstListView", sortedViews);
                }
                if (!component.get("v.detailFieldSetResults") ||
                    component.get("v.detailFieldSetResults").length <= 0
                ) {
                    component.set('v.detailFieldSetResults', ret.detailFieldSetResults);
                }
                if (!component.get("v.listFieldSetResults") || component.get("v.listFieldSetResults").length <= 0) {
                    component.set("v.listFieldSetResults", ret.listFieldSetResults);
                    var firtField = component.get('v.listFieldSetResults');
                    if (firtField.length > 0) {
                        var firtFieldType = firtField[0].type;
                        component.set('v.firtFieldType', firtFieldType);
                    }
                }
            }


            var lengEmp = component.get('v.lstEmployees').length;
            if (lengEmp > 0) {
                component.set('v.noRecord', false);
            } else {
                component.set('v.noRecord', true);
            }
            if (!component.get('v.isFilterCall')) {
                var spinner = component.find("mySpinner");
                $A.util.toggleClass(spinner, "slds-hide");
            }
            component.set('v.isFilterCall', false);
            that.paginationSetUp(component);
        });
        $A.enqueueAction(action);
    },
    sortListOfFilters: function (originalArr, order) {
        return originalArr.sort(
            function (a, b) {
                return order.indexOf(a.listViewName) < order.indexOf(b.listViewName) ?
                    -1 : 1;
            }
        );
    },
    applyAlphabeticFilter: function (component, filterValue) {
        component.set("v.startIndex", 0);
        component.set("v.endIndex", component.get("v.RecordsOnLoad"));
        var lstSObjectRecords = component.get("v.lstALLEmployeeRecs").length > 0 ?
            component.get("v.lstALLEmployeeRecs") :
            component.get("v.lstEmployees"),
            recordsOnLoad = component.get("v.RecordsOnLoad"),
            searchField = component.get("v.FieldForAlphabeticFilter"),
            lstRecordsTemp = [],
            totalRecords = 0;
        var numberOfRcords;

        if (component.get("v.lstALLEmployeeRecs").length === 0)
            component.set("v.lstALLEmployeeRecs", lstSObjectRecords);
        if (filterValue !== 'All') {
            lstRecordsTemp = lstSObjectRecords.filter(function (record) {
                if (record[searchField]) {
                    if (filterValue === 'Other')
                        return record[searchField].toLowerCase().replace(/[^a-zA-Z]/g, '').length === 0;
                    else
                        return record[searchField].toLowerCase().startsWith(filterValue.toLowerCase());
                }
                if (filterValue === 'Other' && !record[searchField]) {
                    return true;
                }
            })
            component.set("v.lstEmployees", lstRecordsTemp);
            component.set("v.totalRecords", lstRecordsTemp.length);
            numberOfRcords = lstRecordsTemp.length;
        } else {
            if (component.get("v.lstALLEmployeeRecs").length > 0)
                component.set("v.lstEmployees", component.get("v.lstALLEmployeeRecs"));
            else
                component.set("v.lstEmployees", lstSObjectRecords);
            component.set("v.totalRecords", component.get("v.lstEmployees").length);
            numberOfRcords = component.get("v.lstEmployees").length;
        }
        setTimeout(function () {
            if (numberOfRcords != 0 && component.get("v.startIndex") == 0) {
                var pBtn = component.find('prevButton');
                var nBtn = component.find('nextButton');

                if (pBtn != null && pBtn != undefined && nBtn != null && nBtn != undefined) {
                    component.find('prevButton').getElement().setAttribute('disabled', 'true');
                    component.find('nextButton').getElement().setAttribute('disabled', 'false');
                    component.find('nextButton').getElement().removeAttribute("disabled");
                }
            }
        }, 900);
        var lengEmp = component.get('v.lstEmployees').length;
        if (lengEmp > 0) {
            component.set('v.noRecord', false);
        } else {
            component.set('v.noRecord', true);
        }
        var spinner = component.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },

    //navigate to next page
    nextPage: function (component) {
        var totalRecords = component.get("v.totalRecords"),
            pageSize = component.get("v.RecordsOnLoad"),
            startIndex = component.get("v.startIndex"),
            endIndex = component.get("v.endIndex");

        if (startIndex + pageSize < totalRecords) {
            component.set("v.startIndex", startIndex + pageSize);
            component.set("v.endIndex", endIndex + pageSize);
            component.find('prevButton').getElement().removeAttribute("disabled");
            if (component.get("v.startIndex") + pageSize > totalRecords) {
                component.find('nextButton').getElement().setAttribute('disabled', 'true');
            }
        } else {
            component.find('nextButton').getElement().setAttribute('disabled', 'true');
        }
    },

    //navigate to previous page
    previousPage: function (component) {
        var pageSize = component.get("v.RecordsOnLoad"),
            startIndex = component.get("v.startIndex"),
            endIndex = component.get("v.endIndex");

        if (startIndex - pageSize >= 0) {
            component.set("v.startIndex", startIndex - pageSize);
            component.set("v.endIndex", endIndex - pageSize);
            component.find('nextButton').getElement().removeAttribute("disabled");
            if (startIndex - pageSize === 0)
                component.find('prevButton').getElement().setAttribute('disabled', 'true');
        } else {
            component.find('prevButton').getElement().setAttribute('disabled', 'true');
        }
    },
    JsSearch: function (component) {
        var allRecs = component.get('v.lstALLEmployeeRecs');
        var tempRecs;
        var fields = component.get("v.listFieldSetResults");
        var fieldsLength = fields.length;
        var fltrVal = component.get('v.strSearchString').toString().toLowerCase();
        tempRecs = allRecs.filter(function (curRec) {
            for (var i = 0; i < fieldsLength; i++) {
                var ftype = fields[i].type;
                var val = curRec[fields[i].fieldPath];
                if (ftype === 'ID' || ftype === 'IMAGE' || ftype === 'URL') {
                    continue;
                } else if (val != null && val != '' && val != undefined) {
                    val = val.toString().toLowerCase();
                    if (val.indexOf(fltrVal) != -1) {
                        return true
                    }
                }
            }
            return false;
        }, this);
        component.set('v.lstEmployees', tempRecs);
        component.set("v.showSpinner", false);
        var lengEmp = component.get('v.lstEmployees').length;
        component.set('v.totalRecords', lengEmp);

        component.set("v.startIndex", 0);
        const pageSize = component.get("v.RecordsOnLoad");
        component.set("v.endIndex", pageSize);

        this.paginationSetUp(component);

        if (lengEmp > 0) {
            component.set('v.noRecord', false);
        } else {
            component.set('v.noRecord', true);
        }
    },
    paginationSetUp: function (component) {
        setTimeout(function () {
            var pBtn = component.find('prevButton');
            var nBtn = component.find('nextButton');
            if (pBtn != null && pBtn != undefined && nBtn != null && nBtn != undefined) {
                if (component.get("v.totalRecords") != 0 && component.get("v.startIndex") == 0) {
                    component.find('prevButton').getElement().setAttribute('disabled', 'true');
                    component.find('nextButton').getElement().setAttribute('disabled', 'false');
                    component.find('nextButton').getElement().removeAttribute("disabled");
                }
            }
        }, 1000);
    }
})