public with sharing class ImagingDocument {
	public class ImagingDocumentFilter {
		private Map<String,String> conditionMap {
			get{
				if(conditionMap == null){
					conditionMap = new Map<String,String>();
				}
				return conditionMap;
			}
			set;
		}
		private List<String> conditionList {
			get{
				return conditionMap.values();
			}
		}			
		public void add(String fieldName, String operation, Date operand){
			String sOperand = FormattedDateTime(operand);
			addCondition(fieldName,operation,sOperand);
		}
		public void addOR(String fieldName, String operation, Date operand, String fieldName2, String operation2, Date operand2){
			String sOperand = FormattedDateTime(operand);
			String sOperand2 = FormattedDateTime(operand2);
			addConditionOR(fieldName,operation,sOperand,fieldName2,operation2,sOperand2);
		}
		public void add(String fieldName, String operation, String operand){
			String sOperand = '\'' + operand + '\'';
			addCondition(fieldName,operation,sOperand);			
		}
		private void addCondition(String fieldName, String operation, String operand){
			String condition = '';
			condition += ImagingDocument.ToCacheFieldName(fieldName);
			condition += ' ' + operation + ' ';
			condition += operand;			
			conditionMap.put(condition,condition);
		}
		private void addConditionOR(String fieldName, String operation, String operand, String fieldName2, String operation2, String operand2){
			String condition = '';
			condition += '(';
			condition += ImagingDocument.ToCacheFieldName(fieldName);
			condition += ' ' + operation + ' ';
			condition += operand;	
			condition += ' OR ';
			condition += ImagingDocument.ToCacheFieldName(fieldName2);
			condition += ' ' + operation2 + ' ';
			condition += operand2;	
			condition += ')';
			conditionMap.put(condition,condition);
		}
		public void clear(){
			conditionMap.clear();
		}
		private string FormattedDateTime(date dt){
	    	DateTime dDate = datetime.newInstance(dt.year(), dt.month(), dt.day());
	    	return dDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    	}
	}
	public string DocTypeName{get;set;}
    public string DocumentDate{get;set;}
    public string DocumentURL{get;set;}
    public string DrawerName{get;set;}
    public string Comment{get;set;}
    public DateTime dtDocumentDate{
    	get{
    		if(DocumentDate != null){
    			return DateTime.valueof(DocumentDate);
    		}else{
	    		return DateTime.valueof('1900-01-01 00:00:00.000');
    		}
    	}    	
    }
    public static string FormatedDateTime(date dt){
    	DateTime dDate = datetime.newInstance(dt.year(), dt.month(), dt.day());
    	return dDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    }
    public string FormattedDocumentDate{
    	get{
    		return Date.valueOf(DocumentDate).format();
    	}
    }
    
    public static List<ImagingDocument> LoadList(String listKey){
    	return LoadList(listKey,'','',0,0,'');
    }
    
    public static List<ImagingDocument> LoadList(String listKey, String sortByProperty, String sortByDirection){
    	return LoadList(listKey,sortByProperty,sortByDirection,0,0,'');
    }
    
    public static List<ImagingDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber){
    	return LoadList(listKey,sortByProperty,sortByDirection,pageSize,pageNumber,'');
    }
    
    public static List<ImagingDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions){
    	WebServiceCache.IWebServiceCache cache = new WebServiceCache();
        wsCache__c existing = cache.FindByKey(listKey);
       
        if(existing != null){     
        	return ImagingDocument.FromCacheItems(cache.LoadItems(existing, ToCacheFieldName(sortByProperty), sortByDirection, pageSize, pageNumber, conditions));	
        }else{
        	//return RetrieveList(listKey);
        	List<ImagingDocument> liveList = RetrieveList(listKey);
        	
        	if(pageSize != 0){
        		List<ImagingDocument> pagedList = new List<ImagingDocument>();
        		for(ImagingDocument i : liveList){
                    if(pagedList.size() < pageSize){
                    	if(conditions != ''){
                    		//todo: consider evaluating the conditions here
                    		//for now, we'll just do the known filter, if the list is filtered
                    		if(i.DocTypeName != null && i.DocTypeName.trim() != ''){
                    			pagedList.add(i);
                    		}
                    	}else{
                    		pagedList.add(i);
                    	}
                    }else{
                    	break;
                    }                   
                }
                liveList = pagedList;
        	}
        	
        	return liveList;         	
        }
    }
    
    public static List<ImagingDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, ImagingDocumentFilter filter){
    	return LoadList(listKey, sortByProperty, sortByDirection, pageSize, pageNumber, Conditions(filter));
    }
    public static string Conditions(ImagingDocumentFilter filter){
    	String conditionPhrase = '';
    				
    	if(filter != null){
    		for(string condition : filter.conditionList){
    			if(conditionPhrase != ''){
    				conditionPhrase += ' AND ';
    			}
    			conditionPhrase += condition;
    		}
    	}
    	
    	system.debug('######## AddConditions(): '+conditionPhrase);
    	return conditionPhrase;
    }
    public static void SaveList(List<ImagingDocument> oList, String listKey){
        WebServiceCache.IWebServiceCache cache = new WebServiceCache();
    	cache.SaveItems(ToCacheItems(oList), listKey);
    }
    
    private static List<ImagingDocument> RetrieveList(string listKey){
        List<ImagingDocument> doctypeList = new List<ImagingDocument>();
        try{
        	RestUtility.result res = FetchListFromService(listKey); 
            return FromJSON(res.response);
        }catch(exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    private static RestUtility.Result FetchListFromService(string listKey){
    	GlobalVar__c gv = GlobalVar__c.getOrgDefaults();
    	if(gv.IsSandbox__c || Test.isRunningTest()){
    		return TestList(listKey);
    	}else{
		    RestUtility.WakeupService();	                       
		    return RestUtility.EbRESTGet(listKey);
    	}
    }
    
    private static String ToCacheFieldName(String fieldName){
    	if(fieldName=='DocTypeName') return 'Text0__c';
    	if(fieldName=='DocumentDate') return 'DateTime0__c';
    	if(fieldName=='DocumentURL') return 'Text1__c';
    	if(fieldName=='DrawerName') return 'Text2__c';
    	if(fieldName=='Comment') return 'Text3__c';
    	return '';
    } 
    
    private wsCacheItem__c ToCacheItem(){
        wsCacheItem__c i = new wsCacheItem__c();
        i.Key__c = DocumentURL;
        i.Text0__c = DocTypeName;
        i.DateTime0__c = dtDocumentDate;
        i.Text1__c = DocumentURL;
        i.Text2__c = DrawerName;
        i.Text3__c = Comment; 
        return i;
    }
    
    private static ImagingDocument FromCacheItem(wsCacheItem__c i){
        ImagingDocument o = new ImagingDocument();
        o.DocTypeName = i.Text0__c;
        o.DocumentDate = String.valueOf(i.DateTime0__c);
        o.DocumentURL = i.Text1__c;
        o.DrawerName = i.Text2__c;
        o.Comment = i.Text3__c;
        return o;
    }
    
    private static List<wsCacheItem__c> ToCacheItems(List<ImagingDocument> oList){
        List<wsCacheItem__c> items = new List<wsCacheItem__c>();
        for(ImagingDocument o : oList){
            items.Add(o.ToCacheItem());
        }
        return items;
    }
    
    private static List<ImagingDocument> FromCacheItems(List<wsCacheItem__c> items){    
        List<ImagingDocument> oList = new List<ImagingDocument>();
        for(wsCacheItem__c i : items){
           oList.Add(ImagingDocument.FromCacheItem(i));
        }       
        return oList;
    }
    
    private static List<ImagingDocument> FromJSON(String jsonString){
    	List<ImagingDocument> oList = new List<ImagingDocument>();
    	JSONParser parser = JSON.createParser(jsonString);
        
        integer counterArray = 0; //break infinite loop
        integer counterObject = 0; //break infinite loop        
        
        while (parser.nextToken() != null) { //List starts here            
            counterArray = counterArray + 1;
            if(counterArray > 100000) break; //Terminate on an infinite loop
            
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {        
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) { //found an object         
                        ImagingDocument o = (ImagingDocument)parser.readValueAs(ImagingDocument.class);
                        oList.add(o);
                    }                    
                    counterObject = counterObject + 1;
                    if(counterObject > 100000) break; //Terminate on an infinite loop
                }
            }
       }      
       return oList;
    }
    
    public static RestUtility.Result TestList(String key){
    	RestUtility.Result myResult = new RestUtility.Result();
    	DateTime dt = DateTime.valueOf('2012-01-01 08:00:00');
		String response = '{"imageNowEntityDocumentResult":[';
        for(Integer i=0;i<23;++i){
        	if(i!=0) response += ',';
        	response += '{"DocTypeName":"RE_Taxes_' + String.valueOf(i) + '","DocumentDate":"' + String.valueOf(dt.addDays(i)) + '","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=' + String.valueOf(i) + '","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        }
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        response += ',{"DocTypeName":"RE_Taxes_0","DocumentDate":"1900-01-01 00:00:00.000","DocumentURL":"http://imagenowwebtest/webnow/index.jsp?action=filter&docid=0","DrawerName":"FNBO_CONVERTED_TO_BANKWAY_Success"}';
        
        response += ']}';		                       
		myResult.response = response;
        return myResult;
    }
}