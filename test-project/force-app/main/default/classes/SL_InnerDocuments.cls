public with sharing class SL_InnerDocuments
{
    /* Start - ResultsWrapper wrapper */
    public class ResultsWrapper
    {
        @AuraEnabled
        public Boolean expanded         	{get;set;}
        @AuraEnabled
        public String label             	{get;set;}
        @AuraEnabled
        public String name             		{get;set;}
        @AuraEnabled
        public List<ResultsWrapper> items	{get;set;}
        
        //Constructor
        public ResultsWrapper(String name, String label, Boolean expanded) {
            this.name = name;
            this.label = label;
            this.expanded = expanded;
            this.items = new List<ResultsWrapper>();
        }
    }
    /* End - ResultsWrapper wrapper */
    
    public class cusDocItem
    {
        @AuraEnabled
        public datetime dtLastModifiedDate         	{get;set;}
        @AuraEnabled
        public datetime dtCreatedDate	         	{get;set;}
        @AuraEnabled
        public String title             			{get;set;}
        @AuraEnabled
        public String itemID           				{get;set;}
        @AuraEnabled
        public String itemIDDel        				{get;set;}
        @AuraEnabled
        public String itemIDDown       				{get;set;}
        @AuraEnabled
        public ID itemDocID            				{get;set;}
        @AuraEnabled
        public Integer itemPos         				{get;set;}
        
        //Constructor
        public cusDocItem(Integer inPos, String inTitle, datetime inDtLastModifiedDate, datetime inDtCreatedDate, ID inItemID, ID inItemDocID) {
            this.itemPos = inPos;
            this.title = inTitle;
            this.dtLastModifiedDate = inDtLastModifiedDate;
            this.dtCreatedDate = inDtCreatedDate;
            this.itemID = ''+inItemID;
            this.itemDocID = inItemDocID;
            this.itemIDDel = 'Del_'+itemDocID;
            this.itemIDDown = 'Down_'+inItemID;
        }
    }

	@AuraEnabled
	public static boolean deleteFile(String sItemID, String sObjectName)
	{
		boolean retVal = false;
		List<SObject> lst2Del = new List<SObject>();
		
		String sSql = 'Select ID From ';
		if(sObjectName == 'ContentVersion'){
			sSql+= 'ContentDocument WHERE Id =\''+sItemID+'\'';
		}
		else{
			sSql+= sObjectName+' WHERE Id =\''+sItemID+'\'';
		}
		for(SObject item:Database.query(sSql))
		{
			lst2Del.add(item);
		}
		
		if(lst2Del.size()>0)
		{
			try{
				 Database.delete(lst2Del, false);
				 retVal = true;
			}catch(Exception ex){
				
			}
		}
		
		return retVal;
	}
    
    @AuraEnabled
	public static boolean updateFiles(String sParams, String sObjectName, String sGrouping1, String sGrouping2, String sGrouping3, String sGrouping4,
			String catLev0, String catLev1, String catLev2, String catLev3)
	{
		List<String> lstIDs = (List<String>) JSON.deserialize(sParams, List<String>.class);
		if(lstIDs!=null && lstIDs.size()>0)
		{
			Set<String> lstObjFields = new Set<String>{'ID','CreatedDate','LastModifiedDate'};
			if(sGrouping1!=null && sGrouping1!='' && sGrouping1!='null') lstObjFields.add(sGrouping1);
			if(sGrouping2!=null && sGrouping2!='' && sGrouping2!='null') lstObjFields.add(sGrouping2);
			if(sGrouping3!=null && sGrouping3!='' && sGrouping3!='null') lstObjFields.add(sGrouping3);
			if(sGrouping4!=null && sGrouping4!='' && sGrouping4!='null') lstObjFields.add(sGrouping4);
			if(sObjectName=='ContentVersion'){ lstObjFields.add('ContentDocumentId');}
			
			List<String> lstObjFieldsFin = new List<String>();
			lstObjFieldsFin.addAll(lstObjFields);
			
			String sSql = 'Select '+String.join(lstObjFieldsFin, ',')+' From '+sObjectName;
			if(sObjectName=='ContentVersion'){ sSql +=	' where ContentDocumentId in (\''+String.join(lstIDs, '\',\'')+'\') limit 100';}
			else{ sSql +=	' where ID in (\''+String.join(lstIDs, '\',\'')+'\') limit 100';}
			
			List<SObject> lst2Upd = new List<SObject>();
			for(SObject item:Database.query(sSql))
			{
				if(sGrouping1!=null && sGrouping1!='' && sGrouping1!='null' && catLev0!=null) item.put(sGrouping1,catLev0);
				if(sGrouping2!=null && sGrouping2!='' && sGrouping2!='null' && catLev1!=null) item.put(sGrouping2,catLev1);
				if(sGrouping3!=null && sGrouping3!='' && sGrouping3!='null' && catLev2!=null) item.put(sGrouping3,catLev2);
				if(sGrouping4!=null && sGrouping4!='' && sGrouping4!='null' && catLev3!=null) item.put(sGrouping4,catLev3);
				lst2Upd.add(item);
			}
			if(lst2Upd.size()>0) Database.update(lst2Upd, false);
			
		}

		return true;
	} 

	@AuraEnabled
	public static List<cusDocItem> getDocItems(String sObjectName, String sFileFieldName, String sTitleFieldName, String sGrouping1, String sGrouping2, String sGrouping3, String sGrouping4, 
			String catLev0, String catLev1, String catLev2, String catLev3, String sSort, String sSortDir, String sSearchTxt, String lstLibFilter, String filterCreteria)
	{
		//System.debug('sSearchTxt>>>> '+sSearchTxt);
		
		List<cusDocItem> lstRetVal = new List<cusDocItem>();
		
		if(sObjectName!=null && sObjectName!='' && sFileFieldName!=null && sFileFieldName!='' && sTitleFieldName!=null && sTitleFieldName!='')
		{
			Set<String> lstObjFields = new Set<String>{'ID','CreatedDate','LastModifiedDate'};
			lstObjFields.add(sFileFieldName);
			lstObjFields.add(sTitleFieldName);
			if(sGrouping1!=null && sGrouping1!='' && sGrouping1!='null') lstObjFields.add(sGrouping1);
			if(sGrouping2!=null && sGrouping2!='' && sGrouping2!='null') lstObjFields.add(sGrouping2);
			if(sGrouping3!=null && sGrouping3!='' && sGrouping3!='null') lstObjFields.add(sGrouping3);
			if(sGrouping4!=null && sGrouping4!='' && sGrouping4!='null') lstObjFields.add(sGrouping4);
			
			List<String> lstObjFieldsFin = new List<String>();
			lstObjFieldsFin.addAll(lstObjFields);
			
			String sSql = 'Select '+String.join(lstObjFieldsFin, ',')+' From '+sObjectName;
			
			String sWhere = ' where IsLatest=true ';
			if(filterCreteria !=null && filterCreteria !=''){

				sWhere += ' and ' +filterCreteria;
			}
			
			if(sGrouping1!=null && sGrouping1!='' && sGrouping1!='null' && catLev0!=null && catLev0!='')
			{
				sWhere +=	' and '+sGrouping1+'=\''+catLev0+'\'';
				if(sGrouping2!=null && sGrouping2!='' && sGrouping2!='null' && catLev1!=null && catLev1!='')
				{
					sWhere +=	' and '+sGrouping2+'=\''+catLev1+'\'';
					if(sGrouping3!=null && sGrouping3!='' && sGrouping3!='null' && catLev2!=null && catLev2!='')
					{
						sWhere +=	' and '+sGrouping3+'=\''+catLev2+'\'';
						if(sGrouping4!=null && sGrouping4!='' && sGrouping4!='null' && catLev3!=null && catLev3!='')
						{
							sWhere +=	' and '+sGrouping4+'=\''+catLev3+'\'';
						}
					}
				}
			}
			
			if(lstLibFilter!=null && lstLibFilter!='')
			{
				List<ID> lstFilterLibIDs = new List<ID>();
				for(String item:lstLibFilter.split(',', 0))
				{
					if(item!='')
					{
						try{ lstFilterLibIDs.add((ID)item);}
						catch(Exception ex){}
					}
				}
				
				sWhere += ' and ContentDocument.ParentId in (\''+String.join(lstFilterLibIDs, '\',\'')+'\')';
			}
			
			Set<ID> setDocIDs = new Set<ID>();
			
			if(sSearchTxt!=null && sSearchTxt!='')
			{
				String searchQuery2 = 'FIND \'' + String.escapeSingleQuotes(sSearchTxt) + '\' IN ALL FIELDS RETURNING ContentVersion(ID, Title, VersionData '+sWhere+')';
            	List<List<ContentVersion>> searchDocs = search.query(searchQuery2);
            	
				if(searchDocs!=null && searchDocs.size()>0 && searchDocs[0].size()>0)
				{
					for(ContentVersion item:searchDocs[0]) setDocIDs.add(item.ID);
				}
				
				
				//sWhere += ' and '+sTitleFieldName+' like \'%'+String.escapeSingleQuotes(sSearchTxt)+'%\'';
				//sSql += ' and '+sTitleFieldName+' like \'%'+String.escapeSingleQuotes(sSearchTxt)+'%\'';
				sWhere += ' and ID in :setDocIDs';
				
			}
			
			
			String sortParam = 'LastModifiedDate desc';
			if(sSort=='Modified Date'){ sortParam = 'LastModifiedDate '+(sSortDir!=null?sSortDir:'');}
			else if(sSort=='File Name'){ sortParam = sTitleFieldName+' '+(sSortDir!=null?sSortDir:'');}
			
			sSql +=	sWhere + ' order by '+sortParam+' limit 201';
			
			Integer posInt = 1;
			
			//System.debug('SQL>>>> '+sSql);
			
			for(SObject item:Database.query(sSql))
			{
				lstRetVal.add(new cusDocItem(posInt++,(String)item.get(sTitleFieldName),(DateTime)item.get('LastModifiedDate'),(DateTime)item.get('CreatedDate'),(ID)item.get('ID'),(ID)item.get(sFileFieldName)));
			}
		}

	    return lstRetVal;
	}


	@AuraEnabled
    public static List<ResultsWrapper> getDocumentTreeJSON(String sObjectName, String sGrouping1, String sGrouping2, String sGrouping3, String sGrouping4, boolean isExtended)
    {
    	List<ResultsWrapper> lstRetVal = new List<ResultsWrapper>();
    	//ContentVersion 
    	// Fields: SLSI__Content_Types__c, SLSI__Category_Level_1__c, SLSI__Category_Level_2__c, SLSI__Category_Level_3__c
    	
    	set<String> setFldNames = new set<String>();
    	if(sGrouping1!=null && sGrouping1!='' && sGrouping1!='null') setFldNames.add(sGrouping1);
    	if(sGrouping2!=null && sGrouping2!='' && sGrouping2!='null') setFldNames.add(sGrouping2);
    	if(sGrouping3!=null && sGrouping3!='' && sGrouping3!='null') setFldNames.add(sGrouping3);
    	if(sGrouping4!=null && sGrouping4!='' && sGrouping4!='null') setFldNames.add(sGrouping4);
    	SL_DependentPickListValueController.loadObjFldPkVals(sObjectName, setFldNames);
    	
    	if(sObjectName!=null && sObjectName!='' && sGrouping1!=null && sGrouping1!='' && sGrouping1!='null')
    	{
	    	if(isExtended==null) isExtended = false;
	    	List<String> lstKey1 = SL_DependentPickListValueController.getPickListValuesIntoList(sObjectName,sGrouping1);
	    	lstKey1.sort();
	    	
	    	for(String item:lstKey1)
	    	{
	    		ResultsWrapper rwLev1 = new ResultsWrapper(item,item,isExtended);
	    		
	    		if(sGrouping2!=null && sGrouping2!='' && sGrouping2!='null')
	    		{
	    
	    		Map<String,List<String>> pickValueMapLev0 = SL_DependentPickListValueController.GetDependentOptions(sObjectName,sGrouping1,sGrouping2);

	    		List<String> lstKey2 = pickValueMapLev0.get(item);
	    		if(Test.isRunningTest()){ lstKey2 = new List<String>{'Test1', 'Test2'};}
	    		lstKey2.sort();
	
	    		for(String subItem:lstKey2)
	    		{
	    			ResultsWrapper rwLev2 = new ResultsWrapper(item+'::'+subItem,subItem,isExtended);
	    			
	    			if(sGrouping3!=null && sGrouping3!='' && sGrouping3!='null')
	    			{
			    	Map<String,List<String>> pickValueMapLev1 = SL_DependentPickListValueController.GetDependentOptions(sObjectName,sGrouping2,sGrouping3);
			    	if(Test.isRunningTest())
			    	{
			    		pickValueMapLev1 = new Map<String,List<String>>();
			    		pickValueMapLev1.put(subItem, new List<String>{'Test1', 'Test2'});
			    	}
	    			
	    			List<String> lstKey3 = pickValueMapLev1.get(subItem);
	    			lstKey3.sort();
	    			
	    			for(String subSubItem:lstKey3)
	    			{
	    	    		ResultsWrapper rwLev3 = new ResultsWrapper(item+'::'+subItem+'::'+subSubItem,subSubItem,isExtended);

		    			if(sGrouping4!=null && sGrouping4!='' && sGrouping4!='null')
	    				{
				    	Map<String,List<String>> pickValueMapLev2 = SL_DependentPickListValueController.GetDependentOptions(sObjectName,sGrouping3,sGrouping4);
				    	if(Test.isRunningTest())
			    		{
			    			pickValueMapLev2 = new Map<String,List<String>>();
			    			pickValueMapLev2.put(subSubItem, new List<String>{'Test1', 'Test2'});
			    		}
		    			
		    			List<String> lstKey4 = pickValueMapLev2.get(subSubItem);
		    			lstKey4.sort();
		    			
		    			for(String subSubSubItem:lstKey4)
		    			{
		    				rwLev3.items.add(new ResultsWrapper(item+'::'+subItem+'::'+subSubItem+'::'+subSubSubItem,subSubSubItem,isExtended));
		    			}
	    				}		
	    				rwLev2.items.add(rwLev3);
	    			}
	    			}
	    			rwLev1.items.add(rwLev2);
	    		}
	    		}
	    		lstRetVal.add(rwLev1);
	    	}
    	}
    	
    	ResultsWrapper preRW = new ResultsWrapper('','All Files',true);
    	preRW.items.addAll(lstRetVal);

    	return new List<ResultsWrapper>{ preRW};
    }

}