/**
* \arg ClassName        : SL_EmployeeDirectoryListController
* \arg JIRATicket       : LIGHTNING-245
* \arg CreatedOn        : 01/Oct/2016
* \arg LastModifiedOn   : 08/Jan/2018
* \arg CreatededBy      : Ritika 
* \arg ModifiedBy       : Prakash
* \arg Description      : Apex class to fetch all the required server-side data for Employee Directory list Lightning Component.
*/

public with sharing class SL_EmployeeDirectoryListController {
	
    /* Start - Wrapper class for the complete results returned back to the component controller */
    public class ResultsWrapper {
        
        @AuraEnabled
        public List<SObject> lstAllEmployees                { get;set; }
        @AuraEnabled
        public List<FieldSetMember> listFieldSetResults     { get;set; }
        @AuraEnabled
        public List<FieldSetMember> detailFieldSetResults   { get;set; }
        @AuraEnabled
        public List<ListViewWrapper> lstListViews           { get;set; }
        @AuraEnabled
        public Boolean isValidFilterField                   { get;set; }
        @AuraEnabled
        public String filterFieldAPI                        { get;set; }
        
        /* Start - Constructor */
        public ResultsWrapper(List<SObject> lstAllEmployees, List<FieldSetMember> listFieldSetResults, List<FieldSetMember> detailFieldSetResults, 
                              List<ListViewWrapper> lstListViews, Boolean isValidFilterField, String filterFieldAPI) {
            this.lstAllEmployees = lstAllEmployees;
            this.listFieldSetResults = listFieldSetResults;
            this.detailFieldSetResults = detailFieldSetResults;
            this.lstListViews = lstListViews;
            this.isValidFilterField = isValidFilterField;
            this.filterFieldAPI = filterFieldAPI;
        }
        /* End - Constructor */
    }
    /* End - Wrapper class for the complete results returned back to the component controller */
    
    /* Start - Inner class for ListViewWrapper */
    public class ListViewWrapper {
        
        @AuraEnabled
        public Id listViewId        { get;set; }
        @AuraEnabled
        public String listViewName  { get;set; }
        
        /* Start - Constructor */
        public ListViewWrapper(Id listViewId, String listViewName) {

            this.listViewId = listViewId;
            this.listViewName = listViewName;
        }
        /* End - Constructor */
    }
    /* End - Inner class for ListViewWrapper */
    
    /* Start - Inner class for FieldSetMember */
    public class FieldSetMember {
        
        @AuraEnabled
        public Boolean DBRequired       { get;set; }
        @AuraEnabled
        public String fieldPath         { get;set; }
        @AuraEnabled
        public String label             { get;set; }
        @AuraEnabled
        public Boolean required         { get;set; }
        @AuraEnabled
        public String type              { get; set; }
        
        /* Start - Constructor */
        public FieldSetMember(Schema.FieldSetMember fsm, String type) {
            
            this.DBRequired = fsm.DBRequired;
            this.fieldPath = fsm.fieldPath;
            this.required = fsm.required;
            this.type = String.isBlank(type) ? '' + fsm.getType() : type;
            
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
        }
        /* End - Constructor */
    }
    /* End - Inner class for FieldSetMember */
    
    /**
    	@MethodName     : getListOfEmployees
    	@Param          : list fieldsetname, detail fieldsetname, filter criteria, search term, list view names and list view id 
    	@Description    : getting all the Employee records
    **/
    @AuraEnabled
    public static ResultsWrapper getListOfEmployees(String strSObjectName, String strEmpListFieldsetName, String strEmpDetailFieldsetName, 
                                                    String strFilterCriteria, String strSearchString, String strListViews, String strlistViewId,
                                                    String strFieldForAlphabeticFilter) {
        
        Schema.DescribeSObjectResult describedUserObject = Schema.getGlobalDescribe().get(strSObjectName).getDescribe();
        Set<String> setUnaccessibleFields = new Set<String>();	//Stores the Set of Unaccessable fields for User object
        Set<String> setHtmlFormattedFields = new Set<String>(); //Stores html formatted fields to display images in formula etc..
        Set<String> setSearchFields = new Set<String>();       // Store all fields
        Map<String, Schema.SObjectField> fieldMap = describedUserObject.fields.getMap();
        Boolean isValid = fieldMap.containsKey(strFieldForAlphabeticFilter);
        String strFieldAPI = isValid ? fieldMap.get(strFieldForAlphabeticFilter).getDescribe().getName() : '';
        
        //Checking if all the fields in the User Object are accessible (Security Review check)
        for (String fieldName : fieldMap.keySet()) {
            Schema.DescribeFieldResult descField = fieldMap.get(fieldName).getDescribe();  
            if(!descField.isaccessible())
                setUnaccessibleFields.add(descField.getName());
            
            if(descField.isHtmlFormatted())
                setHtmlFormattedFields.add(descField.getName());
        }
        
        Set<String> setFields = new Set<String>{'Id'};
        String strQuery = 'SELECT ';
        List<FieldSetMember> listFieldSetResults = new List<FieldSetMember>();
        List<FieldSetMember> detailFieldSetResults = new List<FieldSetMember>();
        if(describedUserObject.FieldSets.getMap().containsKey(strEmpListFieldsetName)) {
            List<Schema.FieldSetMember> fieldSetMemberList =  describedUserObject.FieldSets.getMap().get(strEmpListFieldsetName).getFields();

            for(Schema.FieldSetMember objField : fieldSetMemberList) {
                if(fieldMap.containsKey(objField.getFieldPath()) && !setUnaccessibleFields.contains(objField.getFieldPath()) 
                   && !setFields.contains(objField.getFieldPath()))
                    setFields.add(objField.getFieldPath());
                
                if(setHtmlFormattedFields.contains(objField.getFieldPath()))
                	listFieldSetResults.add(new FieldSetMember(objField, 'RICHTEXT'));
                else
                    listFieldSetResults.add(new FieldSetMember(objField, ''));

                if(fieldMap.containsKey(objField.getFieldPath())){
                    Schema.DescribeFieldResult descField = fieldMap.get(objField.getFieldPath()).getDescribe();
                    Schema.DisplayType fieldType = objField.getType();
                    if(! descField.isSearchPrefilterable() && !descField.isCalculated() 
                       							 && fieldType != Schema.DisplayType.DateTime
                                                 && fieldType != Schema.DisplayType.TextArea 
                                                 && fieldType != Schema.DisplayType.Integer 
                                                 && fieldType != Schema.DisplayType.ENCRYPTEDSTRING
                                                 && fieldType != Schema.DisplayType.MULTIPICKLIST 
                                                 && fieldType != Schema.DisplayType.Boolean 
                                                 && fieldType != Schema.DisplayType.Double 
                                                 && fieldType != Schema.DisplayType.PERCENT ){
                        setSearchFields.add(objField.getFieldPath());                
                    }
                }
            }
        }
        
        if(describedUserObject.FieldSets.getMap().containsKey(strEmpDetailFieldsetName)) {
            List<Schema.FieldSetMember> fieldSetMemberList =  describedUserObject.FieldSets.getMap().get(strEmpDetailFieldsetName).getFields();
            for(Schema.FieldSetMember objField : fieldSetMemberList) {
                if(fieldMap.containsKey(objField.getFieldPath()) && !setUnaccessibleFields.contains(objField.getFieldPath()) 
                   && !setFields.contains(objField.getFieldPath()))
                    setFields.add(objField.getFieldPath());
                
                if(setHtmlFormattedFields.contains(objField.getFieldPath()))
                	detailFieldSetResults.add(new FieldSetMember(objField, 'RICHTEXT'));
                else
                    detailFieldSetResults.add(new FieldSetMember(objField, ''));
            }
        }
        if(isValid) setFields.add(strFieldAPI);
        String strRunningQuery = strQuery + String.join(new List<String>(setFields), ', ') + ' From ' + strSObjectName;
        String strOrderBy = '';
        
        //Adding the filter criteria(if any)
        if(String.isNotBlank(strFilterCriteria)) {
            strFilterCriteria = strFilterCriteria.trim();
            
            if(strFilterCriteria.containsIgnoreCase('ORDER BY')) {
                Integer index = strFilterCriteria.indexOfIgnoreCase('order by');
                strOrderBy = ' ORDER BY ' + strFilterCriteria.substring(index+8, strFilterCriteria.length());
                strFilterCriteria = strFilterCriteria.substring(0, index);
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
        }
        if(!listFieldSetResults.isEmpty() && String.isBlank(strOrderBy))
            strOrderBy = ' ORDER BY ' + listFieldSetResults[0].fieldPath;
        
        Set<String> setListViewName = new Set<String>();
        String strDefaultView = '';
        
        if(!String.isBlank(strListViews)) {
            for(String strView : strListViews.split(',')) {
                setListViewName.add(strView.toLowerCase().trim()); 
                if(strView.containsIgnoreCase('All'))
                    strDefaultView = strView.toLowerCase().trim();                     
            }
        }
        
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(database.getQueryLocator(strRunningQuery));

        List<ListViewWrapper> listViews = new List<ListViewWrapper>();
        String selectedListViewId = strlistViewId;
        for(SelectOption objSS : setCon.getListViewOptions()) {
            if(setListViewName.contains(objSS.getLabel().toLowerCase()))
                listViews.add(new ListViewWrapper(objSS.getValue(), objSS.getLabel())); 
            if(String.isBlank(selectedListViewId)){
                if(strDefaultView == objSS.getLabel().toLowerCase() || objSS.getLabel().containsIgnoreCase('All'))  
                    selectedListViewId = objSS.getValue();
            }            
        }

        final Integer MAX_PAGE_SIZE = 2000;
        setCon.setPageSize(MAX_PAGE_SIZE);

        Set<Id> filteredIds = new Set<Id>();
        do{
            Set<Id> pageFilteredIds = getFilteredIdsForPage(setCon, strSearchString, setSearchFields, strFilterCriteria, strSObjectName, selectedListViewId);
            filteredIds.addAll(pageFilteredIds);
            if(setCon.getHasNext()) setCon.next();
            else break;
        }while(true);

        String strFinalQuery = strRunningQuery + ' WHERE Id IN: filteredIds ' + strOrderBy;
        return new ResultsWrapper(Database.query(strFinalQuery), listFieldSetResults, detailFieldSetResults, listViews, isValid, strFieldAPI); 
    }
    /* End */

    private static Set<Id> getFilteredIdsForPage(ApexPages.StandardSetController setCon, String strSearchString, Set<String> setSearchFields, String strFilterCriteria, String strSObjectName, string strlistViewId){
        Set<Id> filteredIds = new Set<Id>();
        Set<Id> setUserQueryFiltered = new Set<Id>();
        Set<Id> setDesignFiltered = new Set<Id>();
        Set<Id> setViewFiltered = new Set<Id>();    
 
        if(String.isNotBlank(strlistViewId)) {
            setCon.setFilterId(strlistViewId);
        }

        for(Sobject o : setCon.getRecords()) {
            setViewFiltered.add(o.Id);            
        }
        
        if(String.isNotBlank(strSearchString))
            setUserQueryFiltered.addAll(searchFilterRecords(strSearchString, strSObjectName, setSearchFields));

        if(String.isNotBlank(strFilterCriteria))
            setDesignFiltered.addAll(applyDesignFilters(strFilterCriteria, strSObjectName)); 
        
        for(Id oid : setViewFiltered) {     
            if(setUserQueryFiltered.contains(oid))
                filteredIds.add(oid);
            else if(setDesignFiltered.contains(oid))
                filteredIds.add(oid);
            else if(String.isBlank(strSearchString) && String.isBlank(strFilterCriteria))           
                filteredIds.add(oid);            
        }

        return filteredIds;
    }
    
    /**
    	@MethodName     : applyDesignFilters
    	@Param          : String strFilterCriteria
    	@Description    : collecting all the ids based on the filter defined in the design attribute of the component
    **/
    public static Set<Id> applyDesignFilters(String strFilterCriteria, String targetObject) {
        String query = 'SELECT Id, Name FROM ' + targetObject + ' WHERE ' + strFilterCriteria;
        Set<Id> setFilteredIds = new Set<Id>();
        for(sObject objUser : Database.query(query)) {
            setFilteredIds.add(objUser.Id);            
        }
        return setFilteredIds; 
    }
    /* End */

    /**
    	@MethodName     : searchFilterRecords
    	@Param          : String strSearchTerm, String sObjectName
    	@Description    : Filter all the records that matches the search terms and returns list of such records
    **/
    public static set<Id> searchFilterRecords(String strSearchTerm, String sObjectName, set<String> setSearchFields) {

        String strQuery = 'SELECT Id FROM '+sObjectName+' WHERE ';
        String strBody='';
        set<Id> setsObjectFilteredIds = new set<Id>();
        String strSearchTerm1 = '\''+ strSearchTerm + '*\'';

        for(String strField : setSearchFields){
            if(String.isBlank(strBody))
                strBody += strField + ' like ' +'\'%'+strSearchTerm+'%\' ';
            else
                strBody +=' OR ' +strField + ' like ' +'\'%'+strSearchTerm+'%\' ';
        }
        strQuery += strBody;
        
        System.debug('Search Final Query ==>'+strQuery);
        list<sObject> lstUser = new list<sObject>();
        try{
            lstUser = Database.query(strQuery);
        }
        Catch(Exception e){
            System.debug('Error ::'+ e);
        }
        for(sObject objSobject : lstUser) {
            setsObjectFilteredIds.add(objSobject.Id);
        }
        return  setsObjectFilteredIds;
    }
    /* End */
}
/* End */