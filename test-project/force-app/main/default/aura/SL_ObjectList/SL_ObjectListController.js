({
    doInit : function(component, event, helper) {
        var componentInitTime = '' + Date.now();
        component.set("v.componentTimeId", componentInitTime.slice(-5));

        var modelpopup = "Model Popup";
        var getModel = component.get("v.Attachmentsdisplay");
        if(modelpopup == getModel){
            component.set("v.BoolForModelPopup",true);
        }
        var drplist = "Card";
        var getDrplist = component.get("v.Attachmentsdisplay");
        if(drplist == getDrplist){
            component.set("v.BoolForDropDown",true);
        }
        //Helper method to load all the records for the corresponding SObject
        helper.expandCollapseMainComponent(component, helper);
        helper.getSObjectRecords(component, helper);
        component.set("v.globalTimeout", null); 
    },
    showMore : function(component, event, helper) {
        //Helper method to load More records
        helper.loadMoreRecords(component);
    },
    clearSearch : function(component, event, helper) {
        component.find("searchInput").set("v.value", '');       
        helper.searchRecord(component, helper);
    },
    searchRecords: function(component, event, helper) {
        helper.searchRecord(component, helper);
    },
    onPicklistChange: function(component, event, helper) {
        var filterContainer = component.find("picklistOptions");
        $A.util.addClass(filterContainer, 'hide');
        var name = event.currentTarget.innerText;
        if (name=="--None--") name="";
        component.set("v.SelectedPicklitsValue", name);
        helper.getSObjectRecords(component, helper);
    },
    openClose : function(component, event, helper) {
        if(component.get("v.IsMainExpEnabled")) {
            var clpDiv = component.find("collapsibleDiv"); 
            $A.util.toggleClass(clpDiv, 'hide');
            if(component.get("v.IsMainCmpExpanded"))
                component.set("v.IsMainCmpExpanded", false);
            else
                component.set("v.IsMainCmpExpanded", true);            
        }
    },
    filterRecords : function(component, event, helper) {
        var filterContainer = component.find("filter-dropdown");
        $A.util.addClass(filterContainer, 'hide');
        var name = event.currentTarget.innerText;
        if (name=="--None--") name="";
        component.set("v.filter", name);
        helper.getSObjectRecords(component, helper);
    },
    showDropDown : function(component, event, helper) {
        var filterContainer = component.find("filter-dropdown");
        $A.util.removeClass(filterContainer, 'hide');
    },
    showPickListDropDown : function(component, event, helper) {
        var filterContainer = component.find("picklistOptions");
        $A.util.removeClass(filterContainer, 'hide');
    }
})