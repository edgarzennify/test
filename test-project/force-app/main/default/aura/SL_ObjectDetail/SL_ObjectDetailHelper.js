({
    getSObjectDetail : function(component) {
        var sObjectName = component.get("v.SObjectName");
        var sObjectId = component.get("v.SObjectId");
        var fieldSetName = component.get("v.FieldsetName");
        var filterCriteria = component.get("v.FilterCriteria");
        var initialState = component.get("v.InitialState");
        var showFieldLabel = component.get("v.ShowFieldLabel");
        var showAttachment = component.get("v.ShowAttachment");
        var pageSize = component.get("v.PageSize");
        var startValue = component.get("v.startValue");
        var endValue = component.get("v.endValue");
        var startObjValue = component.get("v.startObjValue");        
        var endObjValue = component.get("v.endObjValue");

        console.log("*** Show Att: "+showAttachment);
        
        if((initialState === 'HIDDEN' && sObjectId !== undefined) || initialState === 'FULL') {
            var action = component.get("c.getSObjectDetailRecord");        
            action.setParams({
                "strsObjectName": sObjectName,
                "strsObjectId" : sObjectId,
                "strFieldSetName" : fieldSetName,
                "strFilterCriteria" : filterCriteria,
                "initialState" : initialState,
                "showFieldLabel" : showFieldLabel,
                "showAttachment" : showAttachment,
                "pageSize": pageSize,
                "startValue" : startValue,
                "endValue" : endValue
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(component.isValid() && state === "SUCCESS") {
                    var ret = response.getReturnValue();                
                    if(!ret) return;
                    
                    if(ret.sObjectDetailRecord.length > 0 && ret.fieldsDetails.length > 0) {
                        component.set("v.objectDetailRecord", ret.sObjectDetailRecord);
                        component.set("v.sObjectFields", ret.fieldsDetails);
                    }
                    component.set("v.lstAttachments",ret.lstAttachment);
                    component.set("v.lstAttachmentsSize",ret.totalAttachRecords);
                    component.set("v.lstFiles",ret.lstFiles);
                    component.set("v.startValue", ret.startValue);
                    component.set("v.endValue",ret.endValue);
                    component.set("v.lstSobjectDetailRecordSize",ret.totalSobjectRecords);
                    component.set("v.endObjValue",pageSize);
                }
            });
            $A.enqueueAction(action); 
    	}
    },
    getNextAttachments : function(component) {
        var totalAttachRecords = component.get("v.lstAttachmentsSize");
        var pageSize = component.get("v.PageSize");
        var startValue = component.get("v.startValue");
        var endValue = component.get("v.endValue");
        if(startValue + pageSize < totalAttachRecords) {
            
            component.set("v.startValue", startValue+pageSize);
            component.set("v.endValue", endValue+pageSize);
            component.find("PrevButton").getElement().removeAttribute("disabled");
            if(startValue+pageSize+pageSize > totalAttachRecords)
                component.find("NextButton").getElement().setAttribute('disabled','true');
        } 
        else {
            component.find('NextButton').getElement().setAttribute('disabled','true');
        }
    },
    getPreviousAttachments : function(component) {
        var pageSize = component.get("v.PageSize");
        var startValue = component.get("v.startValue");
        var endValue = component.get("v.endValue");
        
        if(startValue - pageSize >= 0) {
            
            component.set("v.startValue", startValue-pageSize);
            component.set("v.endValue", endValue-pageSize);
            component.find('NextButton').getElement().removeAttribute("disabled");
            if(startValue - pageSize === 0)
                component.find('PrevButton').getElement().setAttribute('disabled','true');
        } else {
            component.find('PrevButton').getElement().setAttribute('disabled','true');
        }
    },
    getNextSObjectRecords : function(component) {
        
        var totalSObjectRecords = component.get("v.lstSobjectDetailRecordSize");
        var pageSize = component.get("v.PageSize");
        var startObjValue = component.get("v.startObjValue");
        var endObjValue = component.get("v.endObjValue");
        if(startObjValue + pageSize < totalSObjectRecords) {
            
            component.set("v.startObjValue", startObjValue+pageSize);
            component.set("v.endObjValue", endObjValue+pageSize);
            component.find('PrevObjectsButton').getElement().removeAttribute("disabled");
            if(startObjValue+pageSize+pageSize > totalSObjectRecords)
                component.find('NextObjectsButton').getElement().setAttribute('disabled','true');
            
        } else {
            component.find('NextObjectsButton').getElement().setAttribute('disabled','true');
        }
    },
    getPreviousSObjectRecords : function(component) {
        var pageSize = component.get("v.PageSize");
        var startObjValue = component.get("v.startObjValue");
        var endObjValue = component.get("v.endObjValue");
        if(startObjValue - pageSize >= 0) {
            
            component.set("v.startObjValue", startObjValue-pageSize);
            component.set("v.endObjValue", endObjValue-pageSize);
            component.find('NextObjectsButton').getElement().removeAttribute("disabled");
            if(startObjValue - pageSize === 0)
                component.find('PrevObjectsButton').getElement().setAttribute('disabled','true');
        } else {
            component.find('PrevObjectsButton').getElement().setAttribute('disabled','true');
        }
    }
})