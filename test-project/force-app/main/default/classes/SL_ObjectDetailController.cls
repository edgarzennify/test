/**
* \arg ClassName        : SL_ObjectDetailController
* \arg JIRATicket       : LIGHTNING-293
* \arg CreatedOn        : 14/Jul/2017
* \arg LastModifiedOn   : 14/Jul/2017
* \arg CreatededBy      : Nilesh 
* \arg ModifiedBy       : Nilesh
* \arg Description      : Controller class for Object detail lightning component.
*/
public with sharing class SL_ObjectDetailController {
        
	public class ObjectDetail_InnerClass {
    	@AuraEnabled
        public List<FieldSetMember> fieldsDetails { get;set; }
        @AuraEnabled
        public List<sObject> sObjectDetailRecord  { get;set; }
        @AuraEnabled
    	public List<Attachment> lstAttachment     { get;set; }
        @AuraEnabled
        public List<ContentVersion> lstFiles     { get;set; }
        @AuraEnabled
    	public Integer startValue        		  { get;set; }
        @AuraEnabled
    	public Integer endValue           		  { get;set; }
        @AuraEnabled
    	public Integer totalAttachRecords         { get;set; }
        @AuraEnabled
        public Integer totalSobjectRecords         { get;set; }
        
        public ObjectDetail_InnerClass(List<FieldSetMember> fieldsDetails1,List<sObject> sObjectDetailRecord1,List<Attachment> lstAttachment1, List<ContentVersion> lstFiles1,
                                       Integer startValue1,Integer endValue1,Integer totalAttachRecords1,Integer totalSobjectRecords1){
            this.fieldsDetails = fieldsDetails1;
            this.sObjectDetailRecord = sObjectDetailRecord1;
            this.lstAttachment = lstAttachment1;
            this.lstFiles = lstFiles1;
            this.startValue = startValue1;
            this.endValue = endValue1;
            this.totalAttachRecords = totalAttachRecords1;
            this.totalSobjectRecords = totalSobjectRecords1;
        }
    }
    
    public class FieldSetMember {
        
        @AuraEnabled
        public Boolean DBRequired { get;set; }
        @AuraEnabled
        public String fieldPath { get;set; }
        @AuraEnabled
        public String label { get;set; }
        @AuraEnabled
        public Boolean required { get;set; }
        @AuraEnabled
        public String type { get; set; }
        
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
    	@MethodName     : getSObjectDetailRecord
    	@Param          : Sobject name, sobject id, fieldset name, filter criteria, initial state of the detail component
    	                  show field label flag, show attachment flag and page size
    	@Description    : This method is fetching the object details
    **/
    @AuraEnabled
    public static ObjectDetail_InnerClass getSObjectDetailRecord(String strsObjectName, String strsObjectId, String strFieldSetName, 
                                                                 String strFilterCriteria, String initialState, Boolean showFieldLabel, 
                                                                 Boolean showAttachment, Integer pageSize){
        
        list<sObject> lstsObjectDetailRecordAfterSOQL = new list<sObject>();
        List<FieldSetMember> fieldSetMemberDetails = new List<FieldSetMember>();
        List<Attachment> lstAttachmentAfterSOQL = null; 
        List<ContentVersion> lstFilesAfterSOQL = null;
           
        Integer startValue,endValue,totalAttachRecords,totalSobjectRecords;
        
        if(String.isNotBlank(strsObjectName)){
            //Checking strsObjectName is valid object name or not.
            Set<String> setOfAllObjectNames = new Set<String>();
            List<Schema.SObjectType> lstOfAllObjects = Schema.getGlobalDescribe().Values();
            for(Schema.SObjectType objSchema : lstOfAllObjects){    
                setOfAllObjectNames.add(objSchema.getDescribe().getName().toLowerCase());
            }
            
            if(setOfAllObjectNames.contains(strsObjectName.toLowerCase())) {
                
                Set<String> setUnaccessibleFields = new Set<String>();
                set<String> setHtmlFormattedFields = new set<String>(); //Stores html formatted fields to display images in formula etc..
                
                Schema.SObjectType targetTypeForsObject = Schema.getGlobalDescribe().get(strsObjectName);
            	Schema.DescribeSObjectResult sobjResult = targetTypeForsObject.getDescribe();
                // Handling CRUD/FLS Enforcement security issue
                Map<String, Schema.SObjectField> sObjectFieldMap = sobjResult.fields.getMap();
                for (String key : sObjectFieldMap.keySet()) {
                    
                    Schema.DescribeFieldResult descField = sObjectFieldMap.get(key).getDescribe();
                    if(!descField.isaccessible())
                        setUnaccessibleFields.add(descField.getName());
                    
                    if(descField.isHtmlFormatted())
                        setHtmlFormattedFields.add(descField.getName());
                }
                
                //Checking strFieldSetName is valid fieldset of sObject.
                Map<String, Schema.FieldSet> FsMap = new Map<String, Schema.FieldSet>();
                FsMap = Schema.getGlobalDescribe().get(strsObjectName).getDescribe().fieldSets.getMap();                
                  
                String query = 'SELECT Id';
                
                if(String.isNotBlank(strFieldSetName) && FsMap.containsKey(strFieldSetName)){
                    Schema.FieldSet fieldSetObj = sobjResult.FieldSets.getMap().get(strFieldSetName);                    
                    List<Schema.FieldSetMember> fieldSetMemberList =  fieldSetObj.getFields();
                    if(!fieldSetObj.getFields().isEmpty()) {
                        for(Schema.FieldSetMember objField : fieldSetObj.getFields()) {
                            if(objField.getFieldPath() != 'Id' && !setUnaccessibleFields.contains(objField.getFieldPath())) {
                                query += ', '+ objField.getFieldPath();                                
                            }
                            
                            if(setHtmlFormattedFields.contains(objField.getFieldPath()))
                                fieldSetMemberDetails.add(new FieldSetMember(objField, 'richtext'));
                            else
                                fieldSetMemberDetails.add(new FieldSetMember(objField, ''));
                        }
                    }
                    
                    
                    //Filter criteria
                    String whereClause = ''; String strOrderBy = '';
                    if(String.isNotBlank(strFilterCriteria)){
                        strFilterCriteria = strFilterCriteria.trim();
                        String userId = (String) userinfo.getuserid();
                        list<User> lstUser = [select Id, ContactId 
                                                  From User
                                                  Where Id =: userId];
                        
                        if(strFilterCriteria.containsIgnoreCase('ORDER BY')) {
                            Integer index = strFilterCriteria.indexOfIgnoreCase('order by');
                            strOrderBy = ' ORDER BY ' + strFilterCriteria.substring(index+8, strFilterCriteria.length());
                            strFilterCriteria = strFilterCriteria.substring(0, index);
                        }
                        
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
                            else if(strFilterCriteria.startsWithIgnoreCase('OR')) {
                                Integer index = strFilterCriteria.indexOfIgnoreCase('OR');
                                String temp = strFilterCriteria.substring(index, index+3);
                                strFilterCriteria = strFilterCriteria.replaceFirst(temp, '');
                            }
                        }
                        
                        if(String.isNotBlank(strFilterCriteria.trim()))
                            whereClause += ' WHERE ' + strFilterCriteria.trim();
                    } else if(!fieldSetMemberDetails.isEmpty())
                        strOrderBy = ' ORDER BY ' + fieldSetMemberDetails[0].fieldPath;
                    
                    //Additional Where clause for the Knowledge Article Records
                    if(strsObjectName.endsWith('kav')) {
                        if(whereClause.contains(' WHERE '))
                            whereClause += ' AND PublishStatus =\'online\' and Language = \'en_US\' ';
                        else
                            whereClause += ' WHERE PublishStatus =\'online\' and Language = \'en_US\' ';
                    }
                    
                    if(String.isNotBlank(strsObjectId))
                        if(whereClause.contains(' WHERE '))
                        	whereClause += ' AND Id = \'' + strsObjectId + '\'';
                        else
                            whereClause += ' WHERE Id = \'' + strsObjectId + '\'';
                    
                    String finalQueryString = query + ' FROM '+ strsObjectName + whereClause + strOrderBy;
                    system.debug('finalQueryString::'+finalQueryString);
                    lstsObjectDetailRecordAfterSOQL = database.query(finalQueryString); 
                    system.debug('lstsObjectDetailRecordAfterSOQL::'+lstsObjectDetailRecordAfterSOQL);
                    totalSobjectRecords = lstsObjectDetailRecordAfterSOQL.size();

                    //Select id, LinkedEntityId, ContentDocumentID from ContentDocumentLink where LinkedEntityId ='00628000008yCIPAA2'
                    // Need to check both Attachment and ContentDocument records. Attachments start going away in Winter '18
                    lstAttachmentAfterSOQL = new List<Attachment>();
                    lstFilesAfterSOQL = new List<ContentVersion>();
                    totalAttachRecords = [SELECT count() FROM Attachment WHERE ParentId =: strsObjectId];
                    totalAttachRecords = totalAttachRecords + [SELECT count() FROM ContentDocumentLink WHERE LinkedEntityId =: strsObjectId];

                    startValue = 0; 
                    endValue = totalAttachRecords; 
                    if(!lstsObjectDetailRecordAfterSOQL.isEmpty() && !showAttachment) {
                        
                        lstAttachmentAfterSOQL = [SELECT Id, Name FROM Attachment WHERE ParentId =: strsObjectId ORDER BY CreatedDate DESC LIMIT 250];
                        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId =: strsObjectId ORDER BY ContentDocument.CreatedDate DESC LIMIT 250];
                        List<Id> linkIds = new List<Id>();
                        for(ContentDocumentLink cdl : links)
                            linkIds.add(cdl.ContentDocumentId);

                        lstFilesAfterSOQL = [SELECT Id, ContentDocumentId, Title, FileType from ContentVersion where ContentDocumentId in : linkIds LIMIT 250];

                        if(totalAttachRecords > 250)
                            endValue = 250;
                    }
                    else if(!lstsObjectDetailRecordAfterSOQL.isEmpty() && showAttachment){
                        
                        endValue = Integer.valueOf(pageSize);
                        lstAttachmentAfterSOQL = [SELECT Id, Name FROM Attachment WHERE ParentId =: strsObjectId ORDER BY CreatedDate DESC LIMIT 250];
                        List<ContentDocumentLink> links = [SELECT Id, ContentDocumentId from ContentDocumentLink where LinkedEntityId =: strsObjectId ORDER BY ContentDocument.CreatedDate DESC LIMIT 250];
                        List<Id> linkIds = new List<Id>();
                        for(ContentDocumentLink cdl : links)
                            linkIds.add(cdl.ContentDocumentId);

                        lstFilesAfterSOQL = [SELECT Id, ContentDocumentId, Title, FileType from ContentVersion where ContentDocumentId in : linkIds LIMIT 250];

                    }
                }
            }
        }
        ObjectDetail_InnerClass objInnerClass = new ObjectDetail_InnerClass(fieldSetMemberDetails,lstsObjectDetailRecordAfterSOQL,lstAttachmentAfterSOQL,lstFilesAfterSOQL,
                                                                            startValue,endValue,totalAttachRecords,totalSobjectRecords);
        return objInnerClass;
    }
}