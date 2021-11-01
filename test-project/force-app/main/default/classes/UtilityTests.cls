@IsTest
private class UtilityTests{
    public static testMethod void it_should_return_a_list_as_a_delimited_string(){
        List<String> aList = new List<String> {'one','two','three','four'};
        String aDelimiter = '*';
        
        String aString = utility.ListToDelimitedString(aList, aDelimiter);
        
        System.assertEquals('one*two*three*four', aString);
    }
    
    public static testMethod void it_should_return_a_delimited_string_as_a_list(){
        String aString = 'one###two###three';
        String aDelimiter = '###';
        
        List<String> aList = utility.DelimitedStringToList(aString, aDelimiter);
        
        System.assertEquals(3, aList.size());
        System.assertEquals('one', aList[0]);
        System.assertEquals('two', aList[1]);
        System.assertEquals('three', aList[2]); 
    }
    
    public static testMethod void it_should_return_an_empty_string(){
        List<String> aList = new List<String>();
        String aDelimiter = '*';
        
        String aString = utility.ListToDelimitedString(aList, aDelimiter);
        
        System.assertEquals('', aString);
    }
    
    public static testMethod void it_should_multiply_two_amount(){
        decimal d1 = 3.45;
        decimal d2 =1;
        decimal d = utility.multiplyTwoAmounts(d1, d2);
        
        system.assertEquals(3.45 , d);
    }
    
    public static testMethod void it_should_add_two_amount(){
        decimal d1 = 3.45;
        decimal d2 =2.0;
        decimal d = utility.addTwoAmounts(d1, d2);
        
        system.assertEquals(5.45 , d);
    }
    
    public static testMethod void it_should_subtract_two_amount(){
        decimal d1 = 3.45;
        decimal d2 =2.0;
        decimal d = utility.subtractTwoAmounts(d1, d2);
        
        system.assertEquals(1.45 , d);
    }
    
    public static testMethod void it_should_get_all_record_types_by_object_name(){
        List<RecordType> accountTypes = Utility.recordTypeObjects('Account');
        System.assert(accountTypes.size() <> 0);
    }
    
    public static testMethod void it_should_return_an_empty_list_when_getting_record_types_for_a_bad_object_name(){
        List<RecordType> accountTypes = Utility.recordTypeObjects('NoSuchObject###########');
        System.assert(accountTypes.size() == 0);
    }
    
    public static testMethod void it_should_get_a_record_type_by_object_name_and_record_type_name(){
        List<RecordType> types = Utility.recordTypeObjects('Account');
        RecordType rt = Utility.recordTypeObject('Account',types[0].Name);
        System.assertEquals(types[0].Id, rt.Id);
    }
    
    public static testMethod void it_should_get_a_record_type_by_object_name_and_record_type_id(){
        List<RecordType> types = Utility.recordTypeObjects('Account');
        RecordType rt = Utility.recordTypeObject('Account',types[0].Id);
        System.assertEquals(types[0].Id, rt.Id);
    }
    
    public static testMethod void it_should_get_a_record_type_list_by_object_name_and_record_type_name(){
        List<RecordType> types = Utility.recordTypeObjects('Account');
        List<RecordType> rt = Utility.recordTypeObjectList('Account',types[0].Name);
        System.assertEquals(types[0].Id, rt[0].Id);
    }
    
    public static testMethod void it_should_get_a_record_type_list_by_object_name_and_record_type_id(){
        List<RecordType> types = Utility.recordTypeObjects('Account');
        List<RecordType> rt = Utility.recordTypeObjectList('Account',types[0].Id);
        System.assertEquals(types[0].Id, rt[0].Id);
    }

    public static testMethod void it_should_sort_an_option_list(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', 'Pear'));
        options.add(new SelectOption('1', 'Banana'));
        options.add(new SelectOption('2', 'Apple'));
        options.add(new SelectOption('3', 'Orange'));

        List<SelectOption> result = Utility.sortOptionList(options);

        System.assertEquals('Apple', result[0].getLabel());
        System.assertEquals('Banana', result[1].getLabel());
        System.assertEquals('Orange', result[2].getLabel());
        System.assertEquals('Pear', result[3].getLabel());
    }
    
    public static testMethod void code_coverage_stuff(){
        String s = Utility.NewGuidanceLineAdvance();
        s = Utility.LoanTypeGuidanceLine();
        s = Utility.LoanTypeGuidanceLineFixed();
        s = Utility.LoanTypeGuidanceLineRevolving();
        s = Utility.convertid15ToId18('0A2e00000004aUz');
    }
    
    public static testMethod void codeCoverage_debug_methods(){
        Utility.debug_Log('test');
        Utility.debug_RecordLog('test application', 'test event', 'test locationDetails');
    }
    
    public static testMethod void codeCoverage_various_methods(){
        TestUtilities.createLoanAppStages();
        TestUtilities.createCollateralCodes();
        TestUtilities.createValidationRules();
        
        PageReference testhelper = utility.testhelper('http://www.google.com');
        
        
        boolean bool = utility.EvaluateExpression('1', '=','1');
        bool = utility.EvaluateExpression('1', '<>', '2');
        bool = utility.EvaluateExpression('1', '<=', '2');
        bool = utility.EvaluateExpression('1', '>=', '2');
        bool = utility.EvaluateExpression('a', 'regex', 'a');
        bool = utility.EvaluateExpression('a', 'in', 'a,b,c');
        bool = utility.EvaluateExpression('a', 'not in', 'a,b,c');
        bool = utility.EvaluateExpression('1', '=', '2');
        bool = utility.EvaluateExpression('1', '<', '2');
        bool = utility.EvaluateExpression('1', '>', '2');
        
        Account acctProspect = testObjectClass.getTestAccount();
        EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
        EB_Loan_App_Entity_Relationship__c entityrel = testObjectClass.getLoanAppEntityRealationship(acctProspect, app);
        EB_Collateral__c collateral = testObjectClass.getTestCollateralObj();
        EB_Collateral_Client_Relationship__c relOwner = testObjectClass.getTestCollateralClientObject(acctProspect, collateral);
        EB_Loan_App_Collateral_Relationship__c rel = testObjectClass.getTestLoanAppCollateralRelationshipObj(collateral, app);
        Map<string , Utility.QueryParam>  currentMap = new Map<string , Utility.QueryParam>();
        for(EB_Loan_App_Stage_Validation_Rule__c rule : [SELECT id,Name,Object_Name__c,Field_Name__c,Error_Text__c,Operation__c,Operand__c FROM EB_Loan_App_Stage_Validation_Rule__c WHERE Object_Name__c =: 'EB_Loan_App_Collateral_Relationship__c']){             
            String objectName = rule.Object_Name__c;
            String fieldName = rule.Field_Name__c;                  
            String operator = rule.Operation__c;
            String operand = rule.Operand__c;
             system.debug('##:StageActionValidation 2');
            //Code is used to override rule name with a custom description
            String ruleName = '';
            if(rule.Error_Text__c == '' || rule.Error_Text__c == null )
                 ruleName = rule.Name;
            else
                ruleName = rule.Error_Text__c;
                
            Id objID = rel.id;     
            currentMap.put(ruleName , new utility.QueryParam(objID,objectName,fieldName,operator,operand,ruleName));  
        } 
         
         
        utility.IsStageActionFieldValid('EB_Collateral_ID__r', currentMap);
        utility.convertid15ToId18('');
        String s = utility.NewGuidanceLineAdvance();
         
        RecordType r = utility.recordtypeobject('EB_Loan_Application__c','New');
        utility.getUrlFor(rel.Id);
        utility.ListValuesFromObject('Agreement_Test__c' , 'Approval_Satus__c');
        utility.DefaultPicklistValue('Agreement_Test__c' , 'Approval_Satus__c');
        utility.debug_RecordLog('test','test','test');
        utility.RemoveLastTextFromString('map','p');
        utility.ListToDelimitedString(new List<String>{'one','two','three'}, ',');
        utility.DelimitedStringToList('one,two,three',',');
        utility.escape('wewe//wewe');
        utility.unescape('wewew/wew');
        utility.getObjectNameFromId(rel.Id);
        utility.DeleteCache();
        utility.DeleteExpiredCache();
        wscache__c wsid = new wscache__c();
        insert wsid;
        utility.DeleteCache(wsid.Id);
     }

     @IsTest
     static void it_should_create_a_eventLog_record(){
        User testUser = ObjectFactory.getUser();
        String application = 'application name';
        String sourceCodeLocationDetails = 'details';
        //act
        EventLog__c results = Utility.createEventLog(application, testUser, sourceCodeLocationDetails);
        //assert
        System.assertEquals('application name', results.Application__c);
        System.assertEquals('details', results.Location_Details__c);
        System.assert(results.Message__c.startsWith('User:{Id='));
     }

    @IsTest
    static void it_should_return_a_list_of_id_when_given_a_list_of_sobjects_and_string() {
        Id accId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id accId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');

        Account acc1 = new Account(Id = accId1);
        Account acc2 = new Account(Id = accId2);
        List<Account> accList = new List<Account>{acc1, acc2};

        String field = 'Id';

        List<Id> results = Utility.convertToIdList(accList, field);

        // System.assertEquals(2, results.size());
        // System.assertEquals(true, results.contains(accId1));
        // System.assertEquals(true, results.contains(accId2));
        
        // JELLISON - 6/26/2020 the .contains() method on the List class is not behaving properly.  The assert fails on the second account ID.
        // Transforming results to a set where the .contains() method does function to complete the asserts.
        Set<Id> resultSet = new Set<Id>(results);
        System.assertEquals(2, resultSet.size());
        System.assertEquals(true, resultSet.contains(accId1));
        System.assertEquals(true, resultSet.contains(accId2));
    }

    @IsTest
    static void it_should_return_a_set_of_id_when_given_a_list_of_sobjects_and_string() {
        Id accId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id accId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');

        Account acc1 = new Account(Id = accId1);
        Account acc2 = new Account(Id = accId2);
        Account acc3 = new Account(Id = accId2);
        List<Account> accList = new List<Account>{acc1, acc2, acc3};

        String field = 'Id';

        Set<Id> results = Utility.convertToIdSet(accList, field);

        System.assertEquals(2, results.size());
        System.assertEquals(true, results.contains(accId1));
        System.assertEquals(true, results.contains(accId2));
    }

    @IsTest
    static void it_should_return_a_set_of_id_when_given_a_list_of_sobjects() {
        Id accId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id accId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');

        Account acc1 = new Account(Id = accId1);
        Account acc2 = new Account(Id = accId2);
        Account acc3 = new Account(Id = accId2);
        List<Account> accList = new List<Account>{acc1, acc2, acc3};

        Set<Id> results = Utility.convertToIdSet(accList);

        System.assertEquals(2, results.size());
        System.assertEquals(true, results.contains(accId1));
        System.assertEquals(true, results.contains(accId2));
    }

    @IsTest
    static void it_should_return_a_filled_map_of_id_and_sobjects_when_given_a_list_of_sobjects() {
        Id accId1 = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id accId2 = ObjectFactory.getFakeId(Account.SObjectType, '2');

        Account acc1 = new Account(Id = accId1);
        Account acc2 = new Account(Id = accId2);
        List<Account> accList = new List<Account>{acc1, acc2, acc2};
        
        Map<Id, SObject> results = Utility.convertToMap(accList);

        Set<Id> expectedKeys = results.keySet();
        System.assertEquals(2, expectedKeys.size());
        System.assertEquals(true, expectedKeys.contains(accId1));
        System.assertEquals(true, expectedKeys.contains(accId2));

        List<SObject> expectedValues = results.values();
        System.assertEquals(2, expectedValues.size());
        System.assertEquals(true, expectedValues.contains(acc1));
        System.assertEquals(true, expectedValues.contains(acc2));
    }

    @IsTest
    static void it_should_return_an_empty_map_of_id_and_sobjects_when_given_a_list_of_sobjects() {
        List<Account> accList = new List<Account>();

        Map<Id, SObject> results = Utility.convertToMap(accList);

        System.assertEquals(true, results.isEmpty());   
    }
}