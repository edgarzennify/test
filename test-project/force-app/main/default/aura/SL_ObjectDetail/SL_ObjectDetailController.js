({
    doInit : function(component, event, helper) {
        var cardHeader = component.find("cardHeader");
        $A.util.addClass(cardHeader, '_open');
        var AttachmentSection = component.find("AttachmentSection");
        $A.util.addClass(AttachmentSection, '_open');
        
        var recordId = event.getParam("recordId");
        var strEvtSObjectName = event.getParam("strSObjectName");
        var strCmpSObjectName = component.get("v.SObjectName");
        if(strEvtSObjectName)
            strEvtSObjectName = strEvtSObjectName.toUpperCase();
        if(strCmpSObjectName)
            strCmpSObjectName = strCmpSObjectName.toUpperCase();
        
        if(!recordId || (recordId && strCmpSObjectName === strEvtSObjectName)) {
            component.set("v.SObjectId", recordId);
            helper.getSObjectDetail(component);
        }
    },
    openClose : function(component) {        
        var parentElement = component.find('cardHeader');
        $A.util.toggleClass(parentElement, '_open');
    },
    openCloseAttachments : function(component) {        
        var parentElement = component.find('AttachmentSection');
        $A.util.toggleClass(parentElement, '_open');
    },
    nextFuntion : function(component, event, helper) {
        helper.getNextAttachments(component);
    },
    prevFuntion : function(component, event, helper) {
        helper.getPreviousAttachments(component);
    },
    nextObjectsFuntion : function(component, event, helper) {
        helper.getNextSObjectRecords(component);
    },
    prevObjectsFuntion : function(component, event, helper) {
        helper.getPreviousSObjectRecords(component);
    },
    closeComponent : function(component, event, helper) {
        component.set("v.SObjectId", undefined);
        component.set("v.InitialState", 'HIDDEN');
    },
     showFiles : function(component,  event,  helper){
        $A.get('e.lightning:openFiles').fire({
            recordIds: [event.currentTarget.id]
        });
    }
})