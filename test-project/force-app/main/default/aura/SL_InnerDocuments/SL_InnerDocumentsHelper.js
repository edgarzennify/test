({
	getDocumentTree : function(component, helper) {
	 
		var action = component.get("c.getDocumentTreeJSON");
        action.setParams({
        	"sObjectName" 	: component.get("v.SObjectName"),
        	"sGrouping1" 	: component.get("v.Grouping1"),
        	"sGrouping2" 	: component.get("v.Grouping2"),
        	"sGrouping3" 	: component.get("v.Grouping3"),
        	"sGrouping4" 	: component.get("v.Grouping4"),
        	"isExtended"	: component.get("v.ShowExtendedTree")
        });
        
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                
                var ret = response.getReturnValue();
                if(!ret) return;

                component.set('v.treeItems', ret);
            }
        }); 
        $A.enqueueAction(action);
	},
	preDoSearch : function(component, event, helper){
		var sText =  component.find("stext").getElement().value;
        component.set('v.pSearchTxt', sText);
        var params = new Array(4);
        helper.setCatLevels(component, helper, params);
        var objNavListItems = component.find("navListItems").getElement();
        var strVals = '<li class="slds-item">All Files</li>';
        objNavListItems.innerHTML = strVals;
	},
	delDocCatItem : function(component, helper, inParam){
		var action = component.get("c.deleteFile");

		action.setParams({
        	"sObjectName" 	 : component.get("v.SObjectName"),
        	"sItemID"   	 : inParam
        });
        
        component.set('v.IsSpinner', true);

        action.setCallback(this, function(response) {

            component.set('v.IsSpinner', false);
            
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                
                var ret = response.getReturnValue();
                if(!ret) return;
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                	"title": "Success!",
                	"message": "Records has been deleted successfully."
                });
                toastEvent.fire();
                
                

               	helper.getDocumentItems(component, helper);
            }
            
        }); 
        $A.enqueueAction(action);
        
	},
	updDocCatItems : function(component, helper, inParams){
		var action = component.get("c.updateFiles");

		action.setParams({
        	"sObjectName" 	 : component.get("v.SObjectName"),
        	"sGrouping1" 	 : component.get("v.Grouping1"),
        	"sGrouping2" 	 : component.get("v.Grouping2"),
        	"sGrouping3" 	 : component.get("v.Grouping3"),
        	"sGrouping4" 	 : component.get("v.Grouping4"),
        	
        	"catLev0" 		 : component.get("v.catLev0"),
        	"catLev1" 		 : component.get("v.catLev1"),
        	"catLev2" 		 : component.get("v.catLev2"),
        	"catLev3" 		 : component.get("v.catLev3"),
        	"sParams"   	 : JSON.stringify(inParams)
        });
        
        component.set('v.IsSpinner', true);

        action.setCallback(this, function(response) {

            component.set('v.IsSpinner', false);
            
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                
                var ret = response.getReturnValue();
                if(!ret) return;
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                	"title": "Success!",
                	"message": "Records has been inserted successfully."
                });
                toastEvent.fire();
                
                

               	helper.getDocumentItems(component, helper);
            }
            
        }); 
        $A.enqueueAction(action);
        
	},
	getDocumentItems : function(component, helper) {
		var action = component.get("c.getDocItems");
        
        var sSearchTxt = component.get("v.pSearchTxt");
        //var sSearchTxt = component.find("stext").value;
        //alert(sSearchTxt);
        
        action.setParams({
        	"sObjectName" 	 : component.get("v.SObjectName"),
        	"sFileFieldName" : component.get("v.SFileFieldName"),
        	"sTitleFieldName" : component.get("v.STitleFieldName"),
        	"sGrouping1" 	 : component.get("v.Grouping1"),
        	"sGrouping2" 	 : component.get("v.Grouping2"),
        	"sGrouping3" 	 : component.get("v.Grouping3"),
        	"sGrouping4" 	 : component.get("v.Grouping4"),
        	
        	"catLev0" 		 : component.get("v.catLev0"),
        	"catLev1" 		 : component.get("v.catLev1"),
        	"catLev2" 		 : component.get("v.catLev2"),
        	"catLev3" 		 : component.get("v.catLev3"),
        	"sSort"   		 : component.get("v.pSort"),
        	"sSortDir"   	 : component.get("v.pSortDir"),
        	"sSearchTxt" 	 : sSearchTxt,
        	"lstLibFilter"	 : component.get("v.lstGlobalLibIDs"),
            "filterCreteria" : component.get("v.filterCreteria")
        });

        component.set('v.IsSpinner', true);

        action.setCallback(this, function(response) {

            component.set('v.IsSpinner', false);
            
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS") {
                
                var ret = response.getReturnValue();
                if(!ret) return;

                component.set('v.docItems', ret);
                component.set('v.HeadSubText', ret.length);
            }
        }); 
        $A.enqueueAction(action);
	},
	setCatLevels : function(component, helper, inParams){
		var params = new Array(4);
		var fLen = inParams.length;
        for (var i = 0; i < fLen; i++) {
        	params[i] = inParams[i];
        }
        component.set('v.catLev0', params[0]);
        component.set('v.catLev1', params[1]);
        component.set('v.catLev2', params[2]);
        component.set('v.catLev3', params[3]);
	}
})