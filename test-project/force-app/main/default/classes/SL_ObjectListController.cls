/**
* \arg ClassName        : SL_ObjectListController
* \arg JIRATicket       : LIGHTNING-293
* \arg CreatedOn        : 14/Jul/2017
* \arg LastModifiedOn   : 14/Jul/2017
* \arg CreatededBy      : Nilesh 
* \arg ModifiedBy       : Nilesh
* \arg Description      : Controller class for Object list lightning component.
*/
public with sharing class SL_ObjectListController {
    
    public class ResultsWrapper {
        
        @AuraEnabled
        public List<SObject> lstSObjectRecords              {get;set;}
        @AuraEnabled
        public List<FieldSetMember> fieldSetResults         {get;set;}
        @AuraEnabled
        public List<FieldSetMember> detailFieldSetResults   {get;set;}
        @AuraEnabled
        public map<String, String> picklistOptions          {get;set;}
        @AuraEnabled
        public List<String> enabledListViews                {get;set;}
        
        //Constructor
        public ResultsWrapper(List<SObject> lstSObjectRecords, List<FieldSetMember> fieldSetResults, List<FieldSetMember> detailFieldSetResults, map<String, String> picklistOptions, List<String> enabledListViews) {
            this.lstSObjectRecords = lstSObjectRecords;
            this.fieldSetResults = fieldSetResults;
            this.detailFieldSetResults = detailFieldSetResults;
            this.picklistOptions = picklistOptions;
            this.enabledListViews = enabledListViews;
        }
    }
    
    public class FieldSetMember {
        
        @AuraEnabled
        public Boolean DBRequired       {get;set;}
        @AuraEnabled
        public String fieldPath         {get;set;}
        @AuraEnabled
        public String label             {get;set;}
        @AuraEnabled
        public Boolean required         {get;set;}
        @AuraEnabled
        public String type              {get;set;}
        
        public FieldSetMember(Schema.FieldSetMember fsm, String type) {
            this.DBRequired = fsm.DBRequired;
            this.fieldPath = fsm.fieldPath;
            this.required = fsm.required;
            this.type = '' + fsm.getType();
            
            String strHierarchyLabel = '';
            list<String> lstHierarchy = fsm.fieldPath.split('\\.');
            
            if(lstHierarchy.size() > 1) {
                lstHierarchy.remove(lstHierarchy.size() - 1);
                for(String strObjName : lstHierarchy) {
                    if(Schema.getGlobalDescribe().containsKey(strObjName)) {
                        Schema.DescribeSObjectResult describedSObject = Schema.getGlobalDescribe().get(strObjName).getDescribe();
                        strHierarchyLabel += describedSObject.getLabel() + '>';
                    }
                    else
                        strHierarchyLabel += strObjName + '>';
                }
            }
            this.label = strHierarchyLabel + fsm.label;
            
            if(this.fieldPath.containsIgnoreCase('PHOTO') && this.type == 'URL')
                this.type = 'IMAGE';
            
            if(type.containsIgnoreCase('richtext'))
                this.type = 'TEXTAREA';
        }
    }
    
    /**
        @MethodName     : fetchSObjectRecords
        @Param          : String strSObjectName, String strFieldsetName, String strDetailFieldsetName, Integer intMaxRecordsToQuery, 
                          String strFilterCriteria, String strPicklistFieldAPIName, String strSelectedPicklistValue, 
                          String strFilterTopicId, String strSearchString, String strListView, String strRelationshipField, String strParentRecordId
        @Description    : Returns all the reqired information that is Queried and required for the Object List widget
    **/
    @AuraEnabled
    public static ResultsWrapper fetchSObjectRecords(String strSObjectName, String strFieldsetName, String strDetailFieldsetName, 
        Integer intMaxRecordsToQuery, String strFilterCriteria, String strPicklistFieldAPIName, String strSelectedPicklistValue, 
        String strFilterTopicId, String strSearchString, String strListView, String strRelationshipField, String strParentRecordId) {
   
        Schema.DescribeSObjectResult describedSObject = Schema.getGlobalDescribe().get(strSObjectName).getDescribe();
        
        set<String> setUnaccessibleFields = new set<String>();  //Stores the Set of Unaccessable fields for the Object
        set<String> setHtmlFormattedFields = new set<String>(); //Stores html formatted fields to display images in formula etc..
        //Checking if all the fields in the Object are accessible (Security Review check)
        Map<String, Schema.SObjectField> fieldMap = describedSObject.fields.getMap();
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult descField = fieldMap.get(fieldName).getDescribe();
            if(!descField.isaccessible())
                setUnaccessibleFields.add(descField.getName());
            
            if(descField.isHtmlFormatted())
                setHtmlFormattedFields.add(descField.getName());
        }
        
        Set<String> setFields = new Set<String>{'ID'};
        String strQuery = 'SELECT ';
        List<FieldSetMember> fieldSetResults = new List<FieldSetMember>();
        if(describedSObject.FieldSets.getMap().containsKey(strFieldsetName)) {
            List<Schema.FieldSetMember> fieldSetMemberList =  describedSObject.FieldSets.getMap().get(strFieldsetName).getFields();
            for(Schema.FieldSetMember objField : fieldSetMemberList) {
                if(!setUnaccessibleFields.contains(objField.getFieldPath()) && objField.getFieldPath() != 'ID')
                    setFields.add(objField.getFieldPath());
                
                if(setHtmlFormattedFields.contains(objField.getFieldPath()))
                    fieldSetResults.add(new FieldSetMember(objField, 'richtext'));
                else
                    fieldSetResults.add(new FieldSetMember(objField, ''));
            }
        }
        
        List<FieldSetMember> detailFieldSetResults = new List<FieldSetMember>();
        if(describedSObject.FieldSets.getMap().containsKey(strDetailFieldsetName)) {
            List<Schema.FieldSetMember> fieldSetMemberList =  describedSObject.FieldSets.getMap().get(strDetailFieldsetName).getFields();
            for(Schema.FieldSetMember objField : fieldSetMemberList) {
                if(!setUnaccessibleFields.contains(objField.getFieldPath()) && objField.getFieldPath() != 'ID')
                    setFields.add(objField.getFieldPath());
                
                if(setHtmlFormattedFields.contains(objField.getFieldPath()))
                    detailFieldSetResults.add(new FieldSetMember(objField, 'richtext'));
                else
                    detailFieldSetResults.add(new FieldSetMember(objField, ''));
            }
        }
        
        
        String strFinalQuery = strQuery + String.join(new List<String>(setFields), ', ') +' From ' + strSObjectName;
        String strOrderBy = '';
        
        //Adding the filter criteria(if any)
        if(String.isNotBlank(strFilterCriteria)) {
            strFilterCriteria = strFilterCriteria.trim();

            strFilterCriteria = handlePlaceHolderFields(strFilterCriteria, strParentRecordId, strSObjectName);
            
            if(strFilterCriteria.containsIgnoreCase('ORDER BY')) {
                Integer index = strFilterCriteria.indexOfIgnoreCase('order by');
                strOrderBy = ' ORDER BY ' + strFilterCriteria.substring(index+8, strFilterCriteria.length());
                strFilterCriteria = strFilterCriteria.substring(0, index);
            }
            
           
            String userId = (String) userinfo.getuserid();
            list<User> lstUser = [select Id, ContactId 
                                  From User
                                  Where Id =: userId];
            
            //Supporting CurrentUser in filtercriteria
            while(strFilterCriteria.containsIgnoreCase('currentuser')) {
                Integer index = strFilterCriteria.indexOfIgnoreCase('currentuser');
                String temp = strFilterCriteria.substring(index, index+11);
                strFilterCriteria = strFilterCriteria.replaceFirst(temp, '\''+userId+'\'');
            }
            
            //Supporting CurrentUserContact in filtercriteria
            while(strFilterCriteria.containsIgnoreCase('current_user_contact')) {
                String strContactId = '';
                if(! lstUser.isEmpty() && lstUser[0].ContactId != null) {
                    strContactId = lstUser[0].ContactId;
                    Integer index = strFilterCriteria.indexOfIgnoreCase('current_user_contact');
                    String temp = strFilterCriteria.substring(index, index+20);
                    strFilterCriteria = strFilterCriteria.replaceFirst(temp, '\''+strContactId+'\'');
                }
                else
                    strFilterCriteria = strFilterCriteria.substringAfter('current_user_contact');
            }
            
            if(String.isNotBlank(strFilterCriteria.trim())) {
                strFilterCriteria = strFilterCriteria.trim();
                
                if(strFilterCriteria.startsWithIgnoreCase('AND')) {
                    Integer index = strFilterCriteria.indexOfIgnoreCase('AND');
                    String temp = strFilterCriteria.substring(index, index+4);
                    strFilterCriteria = strFilterCriteria.replaceFirst(temp, '');
                }
                else if(strFilterCriteria.startsWithIgnoreCase(' OR ')) {
                     
                    Integer index = strFilterCriteria.indexOfIgnoreCase(' OR ');
                    String temp = strFilterCriteria.substring(index, index+3);
                    strFilterCriteria = strFilterCriteria.replaceFirst(temp, '');
                }
            }
            
            if(String.isNotBlank(strFilterCriteria.trim()))
            {
                if(!strFilterCriteria.containsIgnoreCase('WITH DATA CATEGORY')) 
                 {
                     strFinalQuery += ' WHERE ' + strFilterCriteria.trim();
                 }
            }
        }
        if(!fieldSetResults.isEmpty() && String.isBlank(strOrderBy))
            strOrderBy = ' ORDER BY ' + fieldSetResults[0].fieldPath;
        
        //Picklist Filtering
        map<String, String> mapPicklistOptions = new map<String, String>();
        if(String.isNotBlank(strPicklistFieldAPIName) && fieldMap.containsKey(strPicklistFieldAPIName) && !setUnaccessibleFields.contains(strPicklistFieldAPIName)) {
            mapPicklistOptions.put('--None--', '');
            Schema.DescribeFieldResult fieldResult = fieldMap.get(strPicklistFieldAPIName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            for( Schema.PicklistEntry f : ple)
                mapPicklistOptions.put(f.getLabel(), f.getValue());
            
            if(String.isNotBlank(strSelectedPicklistValue)) {
                if(strFinalQuery.contains(' WHERE '))
                    strFinalQuery += (' AND ' + strPicklistFieldAPIName + ' = \'' + strSelectedPicklistValue + '\'');
                else
                    strFinalQuery += (' WHERE ' + strPicklistFieldAPIName + ' = \'' + strSelectedPicklistValue + '\'');
            }
        }


        //ListView strListView
        List<String> enabledListViews = new List<String>();
        if (strSObjectName!=null) {
            try {

                string filterId;
                string soqlQL = 'Select Id FROM '+ strSObjectName + ' limit 1';
                ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soqlQL));
                System.SelectOption[] lstViewVals = setCon.getListViewOptions();

                for(System.SelectOption item: lstViewVals ){
                    if (item.getLabel() == strListView) {
                        filterId = item.getValue();
                    }
                    if (item.getValue()!=null) {
                        enabledListViews.add(item.getLabel().toLowerCase());            
                    }
                }
                if (filterId!=null) {
                    setCon.setPageSize(1000);//externally setting the page size as its default value is 20    
                    setCon.setFilterId(filterId);
                    list<SObject> lstRecords = (list<SObject>)setCon.getRecords(); 
                    if(strFinalQuery.contains(' WHERE '))
                            strFinalQuery += (' AND ID IN :lstRecords'); 
                        else
                            strFinalQuery += (' WHERE ID IN :lstRecords'); 
                }
            } catch(exception e) {
                system.debug('>>>'+e.getMessage());
            }

        }

        
        //Broadcasted Chatter Topic Id filtering
        /*List<Id> topicEntitiesIds = new list<Id>();
        if(String.isNotBlank(strFilterTopicId)) {
            for(TopicAssignment obj : [SELECT Id, EntityId FROM TopicAssignment WHERE TopicId =: strFilterTopicId AND EntityKeyPrefix =: describedSObject.getKeyPrefix()])
                topicEntitiesIds.add(obj.EntityId);
            
            if(! topicEntitiesIds.isEmpty())
                if(strFinalQuery.contains(' WHERE '))
                    strFinalQuery += ' AND Id IN : topicEntitiesIds';
                else
                    strFinalQuery += ' WHERE Id IN : topicEntitiesIds';
        }
        */
        //Filtering the records via searched String
        set<Id> setSearchFilteredIds = new set<Id>();
        if(String.isNotBlank(strSearchString)) {
            setSearchFilteredIds = searchFilterRecords(strSearchString, strSObjectName);
            if(strFinalQuery.contains(' WHERE '))
                strFinalQuery += ' AND Id IN : setSearchFilteredIds';
            else
                strFinalQuery += ' WHERE Id IN : setSearchFilteredIds';
        }
        
        if(String.isNotBlank(strParentRecordId) && String.isNotBlank(strRelationshipField)) {
            strFinalQuery += strFinalQuery.contains(' WHERE ') 
                             ? ' AND ' + strRelationshipField + '=\'' + strParentRecordId + '\''
                             : ' WHERE ' + strRelationshipField + '=\'' + strParentRecordId + '\'';
        }
        
        //Additional Where clause for the Knowledge Article Records
        if(strSObjectName.endsWith('kav')) {
            if(strFinalQuery.contains(' WHERE ') && !strFilterCriteria.containsIgnoreCase('WITH DATA CATEGORY'))
            {
                strFinalQuery += ' AND PublishStatus =\'online\' and Language = \'en_US\' ';
            }
            else if(strFinalQuery.contains(' WHERE ') && strFilterCriteria.containsIgnoreCase('WITH DATA CATEGORY'))
            {
                if(strFilterCriteria.trim().indexOfIgnoreCase('WITH DATA CATEGORY') == 0){
                    strFinalQuery += ' AND PublishStatus =\'online\' and Language = \'en_US\' '+strFilterCriteria+'';
                }else {
                     strFinalQuery += ' AND PublishStatus =\'online\' and Language = \'en_US\' AND '+strFilterCriteria+'';
                }
                
            }
            else if(!strFinalQuery.contains(' WHERE ') && strFilterCriteria.containsIgnoreCase('WITH DATA CATEGORY'))
            {
                if(strFilterCriteria.trim().indexOfIgnoreCase('WITH DATA CATEGORY') == 0){
                    strFinalQuery += ' WHERE PublishStatus =\'online\' and Language = \'en_US\' '+strFilterCriteria+'';
                }else{
                    strFinalQuery += ' WHERE PublishStatus =\'online\' and Language = \'en_US\' AND '+strFilterCriteria+'';
                }
                 
            }
            else
                strFinalQuery += ' WHERE PublishStatus =\'online\' and Language = \'en_US\' ';
        }
        strFinalQuery += strOrderBy + ' NULLS LAST LIMIT ' + intMaxRecordsToQuery;
            system.debug('------strFinalQuery='+strFinalQuery);
        List<SObject> lstSObjectRecords = Database.query(strFinalQuery);

        return new ResultsWrapper(lstSObjectRecords, fieldSetResults, detailFieldSetResults, mapPicklistOptions, enabledListViews);
    }
    
    /**
        @MethodName     : searchFilterRecords
        @Param          : String strSearchTerm, String sObjectName
        @Description    : Filter all the records that matches the search terms and returns list of such records
    **/
    public static set<Id> searchFilterRecords(String strSearchTerm, String sObjectName) {
        
        final set<String> setValidLikeOperatorDataTypes = new Set<String> {'URL', 'PHONE', 'EMAIL', 'PICKLIST', 'STRING'};
        set<Id> setsObjectFilteredIds = new set<Id>();
        String strSearchQuery = '';
        
        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap();
        
        for(Schema.SObjectField objField : fieldMap.Values()) {
            Schema.describefieldresult field = objField.getDescribe();
            
            if(String.ValueOf(field.getType()) == 'MULTIPICKLIST' && field.isFilterable())
                strSearchQuery += (strSearchQuery == '' ? field.getName() + ' Includes (\'' +String.escapeSingleQuotes(strSearchTerm)+ '\')' : ' OR ' +field.getName() + ' Includes (\'' +String.escapeSingleQuotes(strSearchTerm)+ '\')');
            else if(setValidLikeOperatorDataTypes.contains(String.ValueOf(field.getType())) && field.getName() != 'Id' && String.ValueOf(field.getType()) != 'MULTIPICKLIST' && field.isFilterable())
                strSearchQuery += (strSearchQuery == '' ? field.getName() + ' LIKE \'%' + String.escapeSingleQuotes(strSearchTerm) + '%\'' : ' OR ' + field.getName() + ' LIKE \'%' + String.escapeSingleQuotes(strSearchTerm) + '%\'');
        }
        String stringToQuery = 'Select Id From ' + String.escapeSingleQuotes(sObjectName);
        
        if(String.isNotBlank(strSearchQuery) && !sObjectName.contains('__x') && !sObjectName.contains('__kav')) {
            strSearchQuery = ' Where ' + strSearchQuery;
            list<sObject> lstSearchResultsAfterSOQL = database.query(stringToQuery + strSearchQuery);
            for(sObject objSobject : lstSearchResultsAfterSOQL)
                setsObjectFilteredIds.add(objSobject.Id);
        }
        
        //Performing and SOSL for searching in all fields that are not covered in SOQL
        strSearchTerm = '\''+ strSearchTerm + '*\'';
        String strSosl = 'Find ' + strSearchTerm +  ' in ALL FIELDS '+ 'RETURNING ' + String.escapeSingleQuotes(sObjectName);
        
        List<list<sObject>> lstSearchResultsAfterSOSL = new list<list<sObject>>();
        lstSearchResultsAfterSOSL = search.query(strSosl);
        
        for(sObject objSobject : lstSearchResultsAfterSOSL[0]) {
            setsObjectFilteredIds.add(objSobject.Id);
        }
        return setsObjectFilteredIds;
    }

    private static String handlePlaceHolderFields(String filtercriteria,String recordId,String objName)
    {        
        if(recordId == null) 
            return filtercriteria;

        pattern myPattern = pattern.compile('<<([a-zA-Z0-9_]+)\\.([a-zA-Z0-9_]+)(__c)?>>');
        matcher myMatcher = myPattern.matcher(filtercriteria);
        if(!myMatcher.find()) 
            return filtercriteria;

        String expression;
        Set<String> fields = new Set<String>();
        Set<String> sObjects = new Set<String>();

        do
        {
            Integer startIdx = myMatcher.start();
            Integer endIdx = myMatcher.end();
            expression = filtercriteria.substring(startIdx, endIdx);
            
            Integer IndexOfDot = expression.indexOf('.');
            Integer IndexOfClose = expression.indexOf('>>');
            fields.add(expression.substring(IndexOfDot + 1, IndexOfClose));
            sObjects.add(expression.substring(2, IndexOfDot));
        }
        while(myMatcher.find());

        if(sObjects.size() > 1) 
            return filtercriteria;

        List<String> fieldsList = new List<String>();
        fieldsList.addAll(fields);
        String fieldsCS = String.join(fieldsList, ',');

        for(String obj : sObjects)
        {           
            sObject record =  Database.query('SELECT ' + fieldsCS + ' FROM ' +  obj + 
                                                ' WHERE Id=\'' + recordId + '\' LIMIT 1');
            for(String field : fields)
            {
                String exprToReplace = '<<' + obj + '.' + field + '>>';
                String replacingVal = '\''+ (String)record.get(field) + '\'';
                filtercriteria = filtercriteria.replaceFirst(exprToReplace, replacingVal);
            }            
            break;
        }   
        return filtercriteria;
    }
    
     public class filesAndAttachments_InnClass {
        @AuraEnabled
        public List<Attachment> lstAttachmentAfterSOQL       {get;set;}
        @AuraEnabled
        public List<ContentVersion> lstFilesAfterSOQL        {get;set;} 

        public filesAndAttachments_InnClass(List<Attachment> lstAttachmentAfterSOQL, List<ContentVersion> lstFilesAfterSOQL){
            this.lstAttachmentAfterSOQL = lstAttachmentAfterSOQL;
            this.lstFilesAfterSOQL = lstFilesAfterSOQL;
        }
    }
    /**
        @MethodName     : getAttachmentAndFiles
        @Param          : recordId of Object
        @Description    : return all attachments and files related to that record
    **/
     @AuraEnabled
    public static filesAndAttachments_InnClass getAttachmentAndFiles(String recordID){

        List<Attachment> lstAttachmentAfterSOQL = new List<Attachment>();
        List<ContentVersion> lstFilesAfterSOQL = new List<ContentVersion>();
        Integer totalAttachRecords = [SELECT count() FROM Attachment WHERE ParentId =: recordID];
        totalAttachRecords = totalAttachRecords + [SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId =: recordID ]; 
            
        lstAttachmentAfterSOQL = [SELECT Id, Name FROM Attachment WHERE ParentId =: recordID ORDER BY CreatedDate DESC LIMIT 250];
        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId =: recordID ORDER BY ContentDocument.CreatedDate DESC LIMIT 250];
        List<Id> linkIds = new List<Id>();
        for(ContentDocumentLink cdl : links)
            linkIds.add(cdl.ContentDocumentId);

        lstFilesAfterSOQL = [SELECT Id, ContentDocumentId, ContentModifiedDate, Title, FileType from ContentVersion where ContentDocumentId in : linkIds LIMIT 250];

        return new filesAndAttachments_InnClass(lstAttachmentAfterSOQL, lstFilesAfterSOQL);

    }
}