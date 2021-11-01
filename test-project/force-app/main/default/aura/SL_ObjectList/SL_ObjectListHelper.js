({
    expandCollapseMainComponent : function(component, helper) {
        var cmpProp = component.get("v.ComponentExpandCollapse"); 
        var isExpanded = (cmpProp === 'Allow-default collapsed' || cmpProp === 'Don\'t allow-always expanded') ? false : true;
        
        component.set("v.IsMainExpEnabled", cmpProp === 'Don\'t allow-always expanded' ? false : true);
        
        if(component.get("v.IsMainExpEnabled")) {
            if(component.get("v.IsMainCmpExpanded"))
                component.set("v.IsMainCmpExpanded", isExpanded);
            else
                component.set("v.IsMainCmpExpanded", isExpanded);              
        }
        else {
            component.set("v.IsMainCmpExpanded", true);             
        }    
    },
    searchRecord: function(component, helper) {
        component.set("v.showSpinner", true);
        var strPreviousSearch = component.get('v.strSearchString');
        
        var btn = component.find("closeBTN"); 
        if(component.find("searchInput").get("v.value").length > 0) {
            $A.util.removeClass(btn, 'hide');    
        }
        else {
            $A.util.addClass(btn, 'hide');
        }
        
        if(component.get("v.globalTimeout") != null) 
            clearTimeout(component.get("v.globalTimeout"));  
        
        component.set("v.globalTimeout", window.setTimeout($A.getCallback(function() {SearchFunc()}),1000));  
        
        function SearchFunc() {  
            component.set("v.globalTimeout", null);  
            
            var strSearchString = component.find("searchInput").get("v.value").trim();
            var strWithoutSpecChar = strSearchString.replace(/[^\w\s]/gi, '');
            if(strPreviousSearch !== strSearchString && (strSearchString === '' || strWithoutSpecChar.length >= 2)) {
                component.set('v.strSearchString', strSearchString);
                //Helper method to Search the records for the corresponding Searched Term
                helper.getSObjectRecords(component);
            }
        }        
    },
    
    getSObjectRecords : function(component, helper) {
        var sObjectName = component.get("v.SObjectName"),
            fieldSetName = component.get("v.FieldsetName"),
            detailFieldSetName = component.get("v.DetailFieldsetName"),
            maxRecords = component.get("v.MaxRecords"),
            recordsOnLoad = component.get("v.RecordsOnLoad"),
            filterCriteria = component.get("v.FilterCriteria"),
            picklistFilter = component.get("v.PicklistFilter"),
            SelectedPicklitsValue = component.get("v.SelectedPicklitsValue"),
            topicId = component.get("v.TopicId"),
            searchString = component.get('v.strSearchString'),
            relationshipField = component.get('v.RelationshipField'),
            parentRecordId = component.get('v.recordId'),
            listViews = component.get('v.filter');
        if(!maxRecords)
            maxRecords = 100;
        
        var action = component.get("c.fetchSObjectRecords");
        action.setParams({
            "strSObjectName" : sObjectName,
            "strFieldsetName" : fieldSetName,
            "strDetailFieldsetName" : detailFieldSetName,
            "intMaxRecordsToQuery" : maxRecords,
            "strFilterCriteria" : filterCriteria,
            "strPicklistFieldAPIName" : picklistFilter,
            "strSelectedPicklistValue" : SelectedPicklitsValue,
            "strFilterTopicId" : topicId,
            "strSearchString" : searchString,
            "strListView" : listViews,
            "strRelationshipField" : relationshipField,
            "strParentRecordId" : parentRecordId
        });
      
        action.setCallback(this, function(response) {

            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                
                var ret = response.getReturnValue();
                if(!ret) return;
                
                component.set("v.lstSObjectRecords", ret.lstSObjectRecords);
                
                if(!component.get("v.lstFieldsetResults") || component.get("v.lstFieldsetResults").length <= 0)
                    component.set("v.lstFieldsetResults", ret.fieldSetResults);
                if(!component.get("v.lstDetailFieldsetResults") || component.get("v.lstDetailFieldsetResults").length <= 0)
                    component.set("v.lstDetailFieldsetResults", ret.detailFieldSetResults);
                
                var lstRecordsDisplayed = [];
                component.set("v.intRecordsDisplayed", 0);
                
                if(ret.lstSObjectRecords.length > 0 && ret.fieldSetResults.length > 0) {
                    
                    var totalRecords = ret.lstSObjectRecords.length;
                    for(var i = 0; i < recordsOnLoad; i++)
                        if(ret.lstSObjectRecords[i])
                            lstRecordsDisplayed.push(ret.lstSObjectRecords[i]);
                    
                    component.set("v.totalRecords", totalRecords);
                    component.set("v.lstRecordsDisplayed", lstRecordsDisplayed);
                    component.set("v.intRecordsDisplayed", lstRecordsDisplayed.length);
                     
                    if(totalRecords > recordsOnLoad)
                        component.set("v.hasMoreRecords", true);
                    else
                        component.set("v.hasMoreRecords", false);
                    
                    var optns = [];
                    var optn = {};
                    optn = { label: "", value: "--None--", selected: "true"};
                    optns.push(optn);
                    for (var key in ret.picklistOptions) {
                        if (ret.picklistOptions.hasOwnProperty(key)) {
                            if(SelectedPicklitsValue === key) {
                                optn = { label: key, value: ret.picklistOptions[key], selected: "true"};
                                optns.push(optn);
                            }
                            else {
                                optn = { label: key, value: ret.picklistOptions[key]};
                                optns.push(optn);
                            }
                        }
                    }
                    component.set("v.intPicklistOptions", optns.length);
                    component.set("v.picklistOptions",optns);
                    if(component.get("v.PicklistFilter") && component.get("v.ShowSearchBox"))
                        component.find("picklistOptions").set("v.options", optns);
                }
                else { 
                    component.set("v.totalRecords", 0);
                    component.set("v.lstRecordsDisplayed", undefined);
                    component.set("v.intRecordsDisplayed", 0);
                    component.set("v.hasMoreRecords", false);
                }

                if(component.get("v.ListViews") && (!component.get("v.lstListView") || component.get("v.lstListView").length <= 0)) {
                    var lstListViews = component.get("v.ListViews").split(',');
                    var enabledListViews = ret.enabledListViews;
                    var filteredLstListViews = [];
                    filteredLstListViews.push("--None--");

                    lstListViews.forEach(function(element, index, array) {
                        var elem = element.trim();
                        if (enabledListViews.indexOf(elem.toLowerCase())+1) {
                            filteredLstListViews.push(elem);
                        }
                    })

                    component.set("v.lstListView", filteredLstListViews);
                }

                component.set("v.showSpinner", false);
            }
        }); 
        $A.enqueueAction(action);
    },
    //Method to load more records on click of View More button
    loadMoreRecords : function(component) {
        
        var intMoreRecordsToAdd = component.get("v.RecordsOnLoad"),
            intRecordsDisplayed = component.get("v.intRecordsDisplayed"),
            lstSObjectRecords = component.get("v.lstSObjectRecords"),
            lstRecordsDisplayed = component.get("v.lstRecordsDisplayed"),
            totalRecords = component.get("v.totalRecords"),
            newTotalRecords = intRecordsDisplayed + intMoreRecordsToAdd;
        
        for(var i = intRecordsDisplayed; i < newTotalRecords; i++ ) {
            if(lstSObjectRecords[i])
                lstRecordsDisplayed.push(lstSObjectRecords[i]);
        }
        
        if(newTotalRecords >= totalRecords)
            component.set("v.hasMoreRecords", false);
        
        component.set("v.lstRecordsDisplayed", JSON.parse(JSON.stringify(lstRecordsDisplayed)));
        component.set("v.intRecordsDisplayed", newTotalRecords);
    }
})