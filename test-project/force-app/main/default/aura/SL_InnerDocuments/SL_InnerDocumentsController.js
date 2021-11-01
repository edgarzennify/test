({
    doInit : function(component, event, helper) {
         helper.getDocumentTree(component, helper);
         var params = new Array(4);
         helper.getDocumentItems(component, helper);
         
         var widthLeft = component.get("v.widthLeft");
         if(widthLeft<10){widthLeft = 10; }
         else if(widthLeft>100) {widthLeft = 100; }
         
         var ShowCategoryArea = component.get("v.ShowCategoryArea");
         if(ShowCategoryArea==false){widthLeft = 0; } 
         
         component.set('v.widthLeftStr', widthLeft+'%');
         //var widthRight = component.get("v.widthRight");
         component.set('v.widthRight', (100-widthLeft));
         component.set('v.widthRightStr', (100-widthLeft)+'%');
         
    },
    handleChangeView : function (component, event, helper) {
    	var selectedMenuItemValue = event.getParam("value");
    	var menuItemBox = component.find("menuView");
    	var menuItemTable = component.find("iMenuViewTable");
    	var menuItemTile = component.find("iMenuViewTile");
        menuItemTable.set("v.checked", false);
        menuItemTile.set("v.checked", false);
        if(selectedMenuItemValue=="Tile")
        {
        	menuItemTile.set("v.checked", true);
        	menuItemBox.set("v.iconName", "utility:tile_card_list");
        	menuItemBox.set("v.alternativeText", "Display As Tile");
        	menuItemBox.set("v.title", "Display As Tile");
        	component.set('v.pViewMode', "Tile");
        }else if(selectedMenuItemValue=="Table")
        {
        	menuItemTable.set("v.checked", true);
        	menuItemBox.set("v.iconName", "utility:table");
        	menuItemBox.set("v.alternativeText", "Display As Table");
        	menuItemBox.set("v.title", "Display As Table");
        	component.set('v.pViewMode', "Table");
        }
        
    },
    handleScrollingDiv : function (component, event, helper) {
    	var curElem = event.getSource();
    	var sDiv = component.find("ScrollDiv").getElement();
    	var iNumbRecords = component.get("v.NumbRecords");
    	var lstItems = component.get("v.docItems");
    	var scrollPos = sDiv.scrollTop;
    	var blockH = 67;
    	
    	//alert(curElem.get("v.class"));
    	if(lstItems.length>1*iNumbRecords){
	    	
	    	if((1*curElem.get("v.name") - (scrollPos/blockH)<(iNumbRecords-1)) && curElem.get("v.class")=='cusMenuBtn')
	    	{
	    		curElem.set("v.class","");
	    	}
	    	
	    	if(curElem.get("v.class")!='cusMenuBtn' && (1*curElem.get("v.name") - (scrollPos/blockH)>=(iNumbRecords-1)))
	    	{
	    		 curElem.set("v.class","cusMenuBtn");
	    	}
	    }
    },
    handleSelectMAction : function (component, event, helper) {
    	var selectedMenuItemValue = event.getParam("value");
    	var splits = selectedMenuItemValue.split('_', 2);
    	if(splits.length==2)
    	{
    		if(splits[0]=='Down')
    		{
    			document.location.href = '/sfc/servlet.shepherd/version/download/'+splits[1];
    		}
    		else if(splits[0]=='Del')
    		{
    			if (confirm("Do you want to delete this Document?")) {
    				helper.delDocCatItem(component, helper, splits[1]);
    			}
    			
    		}
    	}
    },
    handleClickEvnt : function (component, event, helper) {
    	if(event.keyCode==13){
    		helper.preDoSearch(component, event, helper);
    		helper.getDocumentItems(component, helper);
    	}
    },
    handleSelect : function (component, event, helper) {
        //return name of selected tree item
        var myName = event.getParam('name');
        var objNavListItems = component.find("navListItems").getElement();
        var strVals = '<li class="slds-item"><b>All Files</b></li>';
        var params = new Array(4);
        component.set('v.pSearchTxt', '');
        
        if(myName!='')
        {
        	var splits = myName.split('::', 4);
        	var fLen = splits.length;
        	for (var i = 0; i < fLen; i++) {
        		if(splits[i]!='')
        		{
        			strVals += '<li class="slds-item"><b>' + splits[i] + '</b></li>';
        			params[i] = splits[i];
        		} 
        	}
        }
        objNavListItems.innerHTML = strVals;

        helper.setCatLevels(component, helper, params);
        helper.getDocumentItems(component, helper);
    },
    handleUploadFinished : function (component, event, helper) {
        // This will contain the List of File uploaded data and status
        var uploadedFiles = event.getParam("files");
        
        if(uploadedFiles.length>0)
        {
        	 var params = new Array();
        	 
        	 for (var i = 0; i < uploadedFiles.length; i++) {
        		 params[i] = uploadedFiles[i].documentId;
        	 }
        	 
        	 //helper.getDocumentItems(component, helper);
        	 helper.updDocCatItems(component, helper, params);
        }
    },
	doSearch : function(component, event, helper) {
		helper.preDoSearch(component, event, helper);
        helper.getDocumentItems(component, helper);
    },
    doSortName : function (component, event, helper) {       
        var pSort = component.get("v.pSort");
        var pSortDir = component.get("v.pSortDir");
        if(pSort!='File Name')
        {
        	component.set('v.pSort', 'File Name');
        	component.set('v.pSortDir', 'ASC');
        }
        else
        {
        	component.set('v.pSortDir', pSortDir=='ASC'?'DESC':'ASC');
        }

        helper.getDocumentItems(component, helper);
        //alert("Button label: " + selectedButtonLabel);
    },
    doSortDate : function (component, event, helper) {       
    	var pSort = component.get("v.pSort");
        var pSortDir = component.get("v.pSortDir");
        if(pSort!='Modified Date')
        {
        	component.set('v.pSort', 'Modified Date');
        	component.set('v.pSortDir', 'DESC');
        }
        else
        {
        	component.set('v.pSortDir', pSortDir=='ASC'?'DESC':'ASC');
        }

        helper.getDocumentItems(component, helper);
        //alert("Button label: " + selectedButtonLabel);
    }
})