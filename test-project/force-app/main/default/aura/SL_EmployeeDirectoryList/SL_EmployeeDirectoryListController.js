({
    init: function (component, event, helper) {
        // override expand
        component.set('v.IsExpanded', true);
        // override expand

        var objName = component.get('v.SObjectName');
        var objFieldSet = component.get('v.ListFieldsetName');

        if (
            objName != null &&
            objName != undefined &&
            objName != '' &&
            objFieldSet != null &&
            objFieldSet != undefined &&
            objFieldSet != ''
        ) {
            helper.fetchListOfEmployees(component);
        } else {
            component.set('v.requiredFields', true);
        }
    },
    openClose: function (component, event, helper) {
        var clpDiv = component.find("collapsibleDiv");
        $A.util.toggleClass(clpDiv, 'hide');
        if (component.get("v.IsExpanded"))
            component.set("v.IsExpanded", false);
        else
            component.set("v.IsExpanded", true);
    },
    clearSearch: function (component, event, helper) {
        component.find("searchInput").set("v.value", '');
        helper.searchRecord(component, helper);
    },
    searchRecords: function (component, event, helper) {
        helper.manageAlphabetFilters(component, event, 'All');
        helper.searchRecord(component, helper);
    },
    filterRecords: function (component, event, helper) {
        var clearText = component.find("searchInput");
        if (clearText != null && clearText != undefined) {
            clearText.set("v.value", '');
        }
        component.set('v.isFilterCall', true);
        component.set('v.showSpinner', true);
        var filterContainer = component.find("filter-dropdown");
        $A.util.addClass(filterContainer, 'hide');
        var selectedViewId = event.currentTarget.id;
        var name = event.currentTarget.innerText;
        component.set("v.filter", name);
        component.set("v.selectedListViewId", selectedViewId);
        helper.manageAlphabetFilters(component, event, 'All');
        helper.fetchListOfEmployees(component);
    },
    filterByAlphabets: function (component, event, helper) {
        if (!component.get("v.isValidField"))
            component.set("v.isShowModal", true);
        else {
            var spinner = component.find("mySpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            helper.manageAlphabetFilters(component, event, event.currentTarget.id);
            helper.applyAlphabeticFilter(component, event.currentTarget.id);
        }
    },
    showDropDown: function (component, event, helper) {
        var filterContainer = component.find("filter-dropdown");
        $A.util.removeClass(filterContainer, 'hide');
    },
    next: function (component, event, helper) {
        component.find('foucusOnClick').getElement().focus();
        helper.nextPage(component);
    },
    prev: function (component, event, helper) {
        component.find('foucusOnClick').getElement().focus();
        helper.previousPage(component);
    },
    closeModal: function (component, event, helper) {
        component.set("v.isShowModal", false);
    }
})