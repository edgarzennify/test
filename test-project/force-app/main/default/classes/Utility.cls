public class Utility implements IUtility {
    public interface IUtility {
        String getServerUrl();
        String getUrlFor(Id objId);
        List<SelectOption> ListValuesFromObject(String SObjectType, String PicklistName);
        String DefaultPicklistValue(String SObjectType, String PicklistName);
        RecordType recordTypeObject(String SObjectType, Id recordTypeId);
        RecordType recordTypeObject(String SObjectType, String recordTypeName);
        List<RecordType> recordTypeObjects(String SObjectType);
        List<RecordType> recordTypeObjectList(String SObjectType, Id recordTypeId);
        List<RecordType> recordTypeObjectList(String SObjectType, String recordTypeName);
        boolean IsMiniModification (Id LoanAppRecordTypeId);
        PageReference testhelper(String url);
        List<SelectOption> sortOptionList(List<SelectOption> options);
        Boolean isFieldEmpty(Schema.DisplayType typeOfField, Object fieldValue);
        Object getValidFieldValue(Schema.DisplayType typeOfField);
        Map<String,String> IsStageActionFieldValid(string parentobject, Map<string , Utility.QueryParam> QueryParamMap);
        boolean EvaluateExpression(String operand1, String operation, String operand2);
        String NewGuidanceLineAdvance();
        String LoanTypeGuidanceLine();
        String LoanTypeGuidanceLineFixed();
        String LoanTypeGuidanceLineRevolving();
        String convertid15ToId18(String id15);
        string RemoveLastTextFromString(String text,string CharToBeRemoved);
        String ListToDelimitedString(List<String> strings, String delimiter);
        List<String> DelimitedStringToList(String delimited, String delimiter);
        string escape( string value );
        string unescape( string value );
        string getObjectNameFromId(String recordId);
        void submitForApproval(Id objId);
        void approveNextStep(Id objId);
        void approveNextStep(Id objId, Id userId);
        void approveWorkflow(Id objId);
        Integer pendingApprovalSteps(Id objId);
        void recallApprovalRequest(Id objId);
        Date ApproveDate(Id objId);
        void DeleteCache();
        void DeleteExpiredCache();
        void DeleteCache(Id wscacheId);
        decimal subtractTwoAmounts(decimal amount1 , decimal amount2);
        decimal addTwoAmounts(decimal amount1, decimal amount2);
        decimal multiplyTwoAmounts(decimal amount1 , decimal amount2);
        void debug_RecordLog(String application, String event, String sourceCodeLocationDetails);
        EventLog__c createEventLog(String application, Object obj, String sourceCodeLocationDetails);
        void debug_DisplayInfo(Object output);
        void debug_Log(Object output);
        void debug_Log(String debugHeader, Object output);
        Blob getBase64(String content);
        Set<Id> convertToIdSet(List<SObject> sObjectList, String field);
        List<Id> convertToIdList(List<SObject> sObjectList, String field);
        Set<Id> convertToIdSet(List<SObject> sObjectList);
        Map<Id, SObject> convertToMap(List<SObject> sObjectList);
    }

    public static String getServerUrl(){
        return system.URL.getSalesforceBaseUrl().toExternalForm().replace('-api','').replace('https','http').replace('http','https');
    }
    public static String getUrlFor(Id objId){
        return getServerUrl() + '/' + string.valueOf(objId);
    }
    public static Map<String,List<RecordType>> recordTypeMap{
        get{
            if(recordTypeMap==null){
                recordTypeMap = new Map<String,List<RecordType>>();
                for(RecordType rt : [SELECT Id, Name, SobjectType, DeveloperName, IsActive FROM RecordType]){
                    if(!recordTypeMap.containsKey(rt.SobjectType)){
                        List<RecordType>newList = new List<RecordType>();
                        recordTypeMap.put(rt.SobjectType,newList);
                    }
                    recordTypeMap.get(rt.SObjectType).add(rt);
                }
                system.debug('#####Utility.recordTypeMap built : ' + String.valueOf(recordTypeMap.size()));
            }
            return recordTypeMap;
        }
        set;
    }
    public static List<SelectOption> ListValuesFromObject(String SObjectType, String PicklistName){
        List<SelectOption> plValues = new List<SelectOption>();
        plValues.add(new SelectOption('','--None--'));
        SObjectType objType = Schema.getGlobalDescribe().get(SObjectType);
        DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult field = objDescribe.Fields.getMap().get(PicklistName).getDescribe();  
        if(field.getType() == Schema.DisplayType.Picklist){
            List<Schema.PicklistEntry> plvals = field.getPicklistValues();
            for(Schema.Picklistentry plval : plvals){
                if(plval.isActive()){
                   plValues.add(new SelectOption(plval.getValue(), plval.getValue()));
                }
            }
        }
        else{
            //Not a picklist, return null;
            return null;
        }
        
        return plValues;
    }
    public static String DefaultPicklistValue(String SObjectType, String PicklistName){
        String defaultValue = null;
        SObjectType objType = Schema.getGlobalDescribe().get(SObjectType);
        DescribeSObjectResult objDescribe = objType.getDescribe();
        Schema.DescribeFieldResult field = objDescribe.Fields.getMap().get(PicklistName).getDescribe();  
        if(field.getType() == Schema.DisplayType.Picklist){
            List<Schema.PicklistEntry> plvals = field.getPicklistValues();
            for(Schema.Picklistentry plval : plvals){
                if(plval.isDefaultValue() && plval.isActive()){
                    defaultValue = plval.getValue();
                }
            }
        }
        else{
            //Not a picklist, return null;
            return null;
        }
        
        return defaultValue;
    }
    public static RecordType recordTypeObject(String SObjectType, Id recordTypeId){
        for(RecordType r : recordTypeMap.get(SObjectType)){
            if( r.Id == recordTypeId ) return r;
        }
        return null;
    }
    public static RecordType recordTypeObject(String SObjectType, String recordTypeName){
        for(RecordType r : recordTypeMap.get(SObjectType)){
            if(r.Name == recordTypeName) return r;
        }
        return null;
    }
    public static List<RecordType> recordTypeObjects(String SObjectType){
    	if(recordTypeMap.get(SObjectType) != null){
    		return recordTypeMap.get(SObjectType);
    	}
    	return new List<RecordType>();
    }
    public static List<RecordType> recordTypeObjectList(String SObjectType, Id recordTypeId){
        List<RecordType> recordTypes = new List<RecordType>();
        recordTypes.add(recordTypeObject(SObjectType,recordTypeId));
        return recordTypes;
    }    
    public static List<RecordType> recordTypeObjectList(String SObjectType, String recordTypeName){
        List<RecordType> recordTypes = new List<RecordType>();
        recordTypes.add(recordTypeObject(SObjectType,recordTypeName));
        return recordTypes;
    }
    public static boolean IsMiniModification (Id LoanAppRecordTypeId){
        RecordType appType = Utility.recordTypeObject('EB_Loan_Application__c',LoanAppRecordTypeId);
        if(appType.name.tolowercase().contains('modification -') && appType.name.tolowercase() != 'modification - full' )
            return true;            
        return false;
    }
    
    public static PageReference testhelper(String url){
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }
      
    public static List<SelectOption> sortOptionList(List<SelectOption> options)  {
        
        if(options == null || options.size() <= 1) {
            return options;                  
        }

        Map<String, SelectOption> labelMap = new Map<String, SelectOption>();
        for(SelectOption o : options){
            labelMap.put(o.getLabel(), o);
        }
        
        List<String> labels = new List<String>(labelMap.keySet());
        labels.sort();

        List<SelectOption> sorted = new List<SelectOption>();
        for(String label : labels){
            sorted.add(labelMap.get(label));
        }

        return sorted;
    }

    public static Boolean isFieldEmpty(Schema.DisplayType typeOfField, Object fieldValue){
        if (typeOfField == Schema.DisplayType.String || typeOfField == Schema.DisplayType.TextArea) {
            if(fieldValue == ''){
                return true;
            }
        }
        return (fieldValue == null);
    }

    public static Object getValidFieldValue(Schema.DisplayType typeOfField){
            if (typeOfField == Schema.DisplayType.base64) {
                return blob.valueOf('1');
            } else if (typeOfField == Schema.DisplayType.Boolean) {
                return false;
            } else if (typeOfField == Schema.DisplayType.Combobox) {
                return '1';
            } else if (typeOfField == Schema.DisplayType.Currency) {
                return 1;
            } else if (typeOfField == Schema.DisplayType.Date) {
                return Date.today();
            } else if (typeOfField == Schema.DisplayType.DateTime) {
                return DateTime.now();
            } else if (typeOfField == Schema.DisplayType.Double) {
                return 1;
            } else if (typeOfField == Schema.DisplayType.Email) {
                return 'test1@test.com';
            } else if (typeOfField == Schema.DisplayType.EncryptedString) {
                return 's';
            } else if (typeOfField == Schema.DisplayType.Integer) {
                return 1;
            } else if (typeOfField == Schema.DisplayType.MultiPicklist) {
                return '1';
            } else if (typeOfField == Schema.DisplayType.Percent) {
                return 1;
            } else if (typeOfField == Schema.DisplayType.Phone) {
                return '123-456-7890';
            } else if (typeOfField == Schema.DisplayType.Picklist) {
                return '1';
            } else if (typeOfField == Schema.DisplayType.String) {
                return '1'; 
            } else if (typeOfField == Schema.DisplayType.TextArea) {
                return '1'; 
            } else if (typeOfField == Schema.DisplayType.Time) {
                return Time.newInstance(0, 0, 0, 0); 
            } else if (typeOfField == Schema.DisplayType.URL) {
                return 'http://test.com'; 
            } else {
                return null;
            }
    }

    
    //============ used for creating reflectin object and dynamic soql==============
    public class QueryParam{
            public QueryParam(id iobjID,string iobjectName,string ifieldName,string ioperator,string ioperand,string iruleName){
                objID = iobjID;
                objectName = iobjectName;
                fieldName = ifieldName;
                operator = ioperator;
                operand = ioperand;
                ruleName = iruleName;
            }
            public id objID{get;set;}
            public string objectName{get;set;}
            public string fieldName{get;set;}
            public string operator{get;set;}
            public string operand{get;set;}
            public string ruleName{get;set;}
     }
     public static Map<String,String> IsStageActionFieldValid(string parentobject, Map<string , Utility.QueryParam> QueryParamMap){
      
                Id i ;
                string queryFields = '';
                string fldinitial = '';
                string obj = '';
                Map<string,string> fldMap = new Map<string,string>();
                for(utility.QueryParam qp : QueryParamMap.values()){
                    fldinitial = fldinitial + qp.fieldName + ',';
                    obj = qp.objectName;
                    i = qp.objID;
                }
                system.debug('%%fld 1 ' + fldinitial);
                if(fldinitial.length() > 1)  queryFields = fldinitial.substring(0,fldinitial.length() - 1);
                system.debug('%%fld 2 ' + queryFields);
                String query = 'SELECT ' + queryFields + ' FROM ' + obj + ' WHERE Id = ' + '\'' + i + '\' limit 1';
                system.debug('%%query' + query);
                sObject o = Database.query(query);
                
                for(utility.QueryParam qp : QueryParamMap.values()){
                    String fieldValue = '';
                    system.debug('%% fldname' + qp.fieldname);
                    if(qp.fieldname.contains(parentobject + '.') ){
                        SObject entity = o.getSObject(parentobject);
                        system.debug('sobjectfld' + string.valueof(entity.get(qp.fieldname.replace(parentobject + '.',''))));
                        fieldValue = string.valueof(entity.get(qp.fieldname.replace(parentobject + '.','')));
                        
                    }else{
                         fieldValue = String.valueOf(o.get(qp.fieldname));
                         system.debug('sobjectfld2' + fieldValue);
                    }
                    fldMap.put(qp.ruleName,fieldvalue); 
               }
                              
               //run through list to find rules
                Map<string,string> errorMap = new  Map<string,string>();
                system.debug('##MapSize' + string.valueof(fldMap.values().size()));
                for(string ruleName : fldMap.keyset()){
                    utility.QueryParam param = QueryParamMap.get(ruleName);
                    string fieldvalue = fldMap.get(param.ruleName);
                    string operand = param.operand;   
                    system.debug('%%%queryparam' + param.ruleName);              
                    if(fieldValue==null) fieldValue='';
                    if(operand==null) operand='';
                    if(Utility.EvaluateExpression(fieldValue, param.operator, operand)){
                            system.debug('%% allgood: ' + param.ruleName); 
                    }else{
                            errorMap.put(ruleName, param.ruleName);
                            system.debug('%% errortrap1a: ' + param.ruleName); 
                    }  
                   
                }
                system.debug('%% errortrap1b: ' + string.valueOf(errorMap.values().size())); 
                return errorMap;

                        
        }
                
     public static boolean EvaluateExpression(String operand1, String operation, String operand2){
                try{                    
                    double dOperand1 = 0;
                    double dOperand2 = 0;
                    if(operation == '='){
                            if(operand1 == operand2) return true;
                    }else if(operation == '<>'){
                        system.debug('## operand1: ' + operand1 + ' / operand2: ' + operand2);
                            if(operand1 != operand2) return true;
                    }else if(operation == '<'){
                             dOperand1 = double.valueOf(operand1);
                             dOperand2 = double.valueOf(operand2);
                            if(dOperand1 < dOperand2) return true;
                    }else if(operation == '>'){
                             dOperand1 = double.valueOf(operand1);
                             dOperand2 = double.valueOf(operand2);
                            if(dOperand1 > dOperand2) return true;
                    }else if(operation == '>='){
                            dOperand1 = double.valueOf(operand1);
                            dOperand2 = double.valueOf(operand2);
                            if(dOperand1 >= dOperand2) return true;                      
                    }else if(operation == '<='){
                            dOperand1 = double.valueOf(operand1);
                            dOperand2 = double.valueOf(operand2);
                            if(dOperand1 <= dOperand2) return true;                      
                    }else if(operation == 'regex'){
                            Pattern cpattern = Pattern.compile(operand2);
                            Matcher cmatcher = cpattern.matcher(operand1);
                            return cmatcher.find();
                    }else if(operation == 'in'){
                            List<String> ins = operand2.split(',');
                            if(ins.size() > 0){                          
                                    for(String s : ins){
                                            if(s == operand1) return true;
                                    }
                            }
                    }else if(operation == 'not in'){
                            List<String> ins = operand2.split(',');
                            if(ins.size() > 0){                          
                                    for(String s : ins){
                                            if(s == operand1) return false;
                                    }
                            }
                    }                       
                }catch(Exception ex){
                        //something went wrong
                        //debug_RecordLog(ex.getMessage());                     
                }
                return false; 
        }
        public static String NewGuidanceLineAdvance(){
            return 'New - Guidance Line Advance';
        }
        public static String LoanTypeGuidanceLine(){
            return 'Guidance Line';
        }
        public static String LoanTypeGuidanceLineFixed(){
            return 'Guidance Line - Fixed';
        }
        public static String LoanTypeGuidanceLineRevolving(){
            return 'Guidance Line - Revolving';
        }
         public static String convertid15ToId18(String id15) {
            if (id15.length() != 15) return id15;
            Id currentId = id15;
            String id18 = currentId;
            return id18;
        }
        
    //=========================String utilities==============================
    public static string RemoveLastTextFromString(String text,string CharToBeRemoved){
        if(text.length() < 2 && CharToBeRemoved.length()!= 1) return text;
        if(text.endsWith(CharToBeRemoved)){
            Integer index = text.lastindexof(CharToBeRemoved);
            text = text.substring(0, index);
        }
        return text;
    }
    public static String ListToDelimitedString(List<String> strings, String delimiter){
        String delimitedString = '';
        for(String s : strings){
            delimitedString += (delimitedString != '') ? delimiter : '';
            delimitedString += s;
        }
        return delimitedString;
    }
    public static List<String> DelimitedStringToList(String delimited, String delimiter){
        return delimited.split(delimiter,0);
    }
        
    //String utilities - Escape
    public static string escape( string value ){
        return value.replace('\\', '\\\\').replace('/', '\\/').replace('"', '\\"');
    }

    public static string unescape( string value ){
        return value.replace('\\"', '"').replace('\\/', '/').replace('\\\\', '\\');
    }
        
    //Object utilities
    public static string getObjectNameFromId(String recordId){
        if(recordId != null) recordId = recordId.substring(0,3);
        String Prefix = null;
        final Map<String,Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        for(String Key : globalDescribe.keySet()){
            Prefix = globalDescribe.get(Key).getDescribe().getKeyPrefix();
            if(Prefix != null && Prefix.equals(recordId)){
              return Key;
            }   
        }
        return '';
    }
    
    public static void submitForApproval(Id objId){
        Approval.Processsubmitrequest req1 = new Approval.processSubmitRequest();
        req1.setObjectId(objId);
        Approval.ProcessResult result = Approval.process(req1);
    }
    
    public static void approveNextStep(Id objId){
    	List<ProcessInstance> processInstances = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:objId ORDER BY CreatedDate DESC LIMIT 1];
		List<ProcessInstanceWorkitem> workItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstanceId in: processInstances];
        Approval.ProcessWorkItemRequest wReq = new Approval.ProcessWorkItemRequest();
    	wReq.setWorkitemId(workItems[0].Id);
		wReq.setComments('');
		wReq.setAction('Approve');    
		Approval.process(wReq);
    }
    
    public static void approveNextStep(Id objId, Id userId){
        List<ProcessInstance> currentApprovalInstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:objId ORDER BY CreatedDate DESC LIMIT 1];
        List<ProcessInstanceWorkitem> currentApprovalWorkItem = [SELECT Id, ActorId FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: currentApprovalInstance.get(0).Id and ActorId =: userId]; 
        Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
        req2.setWorkitemId(currentApprovalWorkItem.get(0).Id);
        req2.setComments('');
        req2.setAction('Approve');    
        Approval.ProcessResult result2 =  Approval.process(req2);        
    }
    
    public static void approveWorkflow(Id objId){
        List<ProcessInstance> processInstances = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:objId ORDER BY CreatedDate DESC];
        List<ProcessInstanceWorkitem> workItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstanceId in: processInstances];
        for(ProcessInstanceWorkItem w : workItems){     
            Approval.ProcessWorkItemRequest wReq = new Approval.ProcessWorkItemRequest();
            wReq.setWorkitemId(w.Id);
            wReq.setComments('');
            wReq.setAction('Approve');    
            Approval.process(wReq);
        }
    }

    public static Integer pendingApprovalSteps(Id objId){
        List<ProcessInstance> processInstances = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:objId ORDER BY CreatedDate DESC];
        List<ProcessInstanceWorkitem> workItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstanceId in: processInstances];
        if(workItems != null){
            return workItems.size();
        }
        return 0;
    }
    
    public static void recallApprovalRequest(Id objId){
        List<ProcessInstance> processInstances = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:objId ORDER BY CreatedDate DESC LIMIT 1];
		List<ProcessInstanceWorkitem> workItems = [SELECT Id FROM ProcessInstanceWorkItem WHERE ProcessInstanceId in: processInstances];
        Approval.ProcessWorkItemRequest wReq = new Approval.ProcessWorkItemRequest();
    	wReq.setWorkitemId(workItems[0].Id);
		wReq.setComments('');
		wReq.setAction('Removed');    
		Approval.process(wReq);
    }
    
    public static Date ApproveDate(Id objId){
    	List<ProcessInstance> processInstances = [SELECT Id, SystemModstamp FROM ProcessInstance WHERE TargetObjectId=:objId and status =:'Approved' ORDER BY CreatedDate DESC LIMIT 1];
		if(processInstances != null && processInstances.size() == 1){
			DateTime approveTimeStamp = processInstances[0].SystemModstamp;
			return date.newinstance(approveTimeStamp.year(), approveTimeStamp.month(), approveTimeStamp.day());
		}
		return null;		
    }    
    
    //Cache methods
    public static void DeleteCache(){
        for(List<wscache__c> ws : [SELECT id FROM wscache__c]){
            delete ws;
        }
    }
     public static void DeleteExpiredCache(){
        for(List<wscache__c> ws : [SELECT id FROM wscache__c WHERE IsExpired__c=1]){
            delete ws;
        }
    }
    public static void DeleteCache(Id wscacheId){
        wscache__c ws = new wscache__c(Id = wscacheId );
        delete ws;
    }
    //=======================================================================
    public static decimal subtractTwoAmounts(decimal amount1 , decimal amount2){
    	if(amount1 == null) amount1 = 0;
    	if(amount2 == null) amount2 = 0;
    	return amount1 - amount2;
    }
    
    public static decimal addTwoAmounts(decimal amount1, decimal amount2){
    	if(amount1 == null) amount1 = 0;
    	if(amount2 == null) amount2 = 0;
    	return amount1 + amount2;
    }
     
    public static decimal multiplyTwoAmounts(decimal amount1 , decimal amount2){
    	if(amount1 == null) amount1 = 0;
    	if(amount2 == null) amount2 = 0;
    	return amount1 * amount2;
    }
    
    // debugging tools
    public static void debug_RecordLog(String application, String event, String sourceCodeLocationDetails){
        EventLog__c log = new EventLog__c();
        log.Message__c = event.left(131072);
        log.Application__c = application;
        log.Location_Details__c = sourceCodeLocationDetails;
        insert log;
    }

    public static EventLog__c createEventLog(String application, Object obj, String sourceCodeLocationDetails){
        EventLog__c log = new EventLog__c();
        log.Message__c = String.valueOf(obj);
        log.Application__c = application;
        log.Location_Details__c = sourceCodeLocationDetails;
        return log;
    }
    
    public static void debug_DisplayInfo(Object output){
        String debugHeader = '##DEBUGGING MESSAGE##';
        String debugOutput = JSON.serialize(output);
        if(debugOutput == debugHeader){debugHeader = '#' + debugHeader + '#';}
		System.assertEquals(debugHeader, debugOutput);
	}
    
    public static void debug_Log(Object output){
        debug_Log('###', output);
    }
    
    public static void debug_Log(String debugHeader, Object output){
    	debugHeader = '###' + debugHeader;
        String debugOutput = String.valueOf(output);
        System.debug(debugHeader + debugOutput);
    }

    public Blob getBase64(String content){
        return EncodingUtil.base64Decode(content);
    }

    //Collection utilities
    public static Set<Id> convertToIdSet(List<SObject> sObjectList, String field) {
        return new Set<Id>(convertToIdList(sObjectList, field));
    }

    public static List<Id> convertToIdList(List<SObject> sObjectList, String field) {
        List<Id> output = new List<Id>();
        for (SObject o : sObjectList) {
            output.add((Id) o.get(field));
        }
        return output;
    }

    public static Set<Id> convertToIdSet(List<SObject> sObjectList) {
        return new Set<Id>(convertToMap(sObjectList).keySet());
    }

    public static Map<Id, SObject> convertToMap(List<SObject> sObjectList) {
        Map<Id, SObject> output = new Map<Id, SObject>();
        if (sObjectList.isEmpty()) { return output; }
        for (SObject so : sObjectList) {
            if (!output.containsKey(so.Id)) {
                output.put(so.Id, so);
            }
        }
        return output;
    }
}