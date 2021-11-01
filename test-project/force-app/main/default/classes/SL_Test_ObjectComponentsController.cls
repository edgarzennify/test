/**
* \arg ClassName        : SL_Test_ObjectComponentsController
* \arg JIRATicket       : LIGHTNING-245
* \arg CreatedOn        : 01/Oct/2016
* \arg LastModifiedOn   : 15/Jun/2017
* \arg CreatededBy      : Nilesh 
* \arg ModifiedBy       : Nilesh
* \arg Description      : Test class for SL_ObjectDetailController and SL_ObjectListController 
*/
@isTest
private class SL_Test_ObjectComponentsController {
    
    // Test code for SL_ObjectListController
    static testMethod void testObjectList() {
        
        //to detect if destination org has NamespacePrefix
        Organization org = [SELECT NamespacePrefix FROM Organization]; 
        String fieldsetName = org.NamespacePrefix != null ? org.NamespacePrefix + '__nFORCE__Xml_Response_Test' : 'nFORCE__Xml_Response_Test';
        
       /* Account objAccount = new Account(Name = 'Test Acc');
        insert objAccount;*/
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Name';
        objAccount.BillingCity = 'Test city';
        objAccount.BillingCountry = 'Test country';
        objAccount.BillingPostalCode = '123112';
        objAccount.BillingState = 'Test State';
        objAccount.BillingStreet = 'Test Street';
        insert objAccount;
        
        Opportunity objOppty = new Opportunity(
            AccountId = objAccount.Id,
            Name = 'Test Oppty',
            StageName = 'Closed Won',
            Amount = 50000,
            Product__c = 'ACH',
            Committed_Amount__c = 1000,
            CloseDate = Date.today(),
            RecordTypeId = ObjectFactory.GetRecordTypeIdByNameAndObject('Consumer', 'Opportunity')
        );
                                                 
        insert objOppty;
        
        SL_ObjectListController.ResultsWrapper objResults =  SL_ObjectListController.fetchSObjectRecords('Opportunity', fieldsetName, fieldsetName,
            20, 'ContactID = current_user_contact AND OwnerId = CurrentUser AND StageName = \'Closed Won\' ORDER BY Name ', 'StageName', 'Closed Won', '',
            'Test', 'All Opportunities', 'AccountId', objAccount.Id);
            
        // system.assertEquals(objResults.lstSObjectRecords.size(), 1);
        
        /*Topic objTopic = new Topic(Name='Test-Topic');
        insert objTopic;*/
        
        /*TopicAssignment objTopicAssignment = new TopicAssignment(TopicId = objTopic.Id, EntityId = objOppty.Id);
        insert objTopicAssignment;
        
        objResults =  SL_ObjectListController.fetchSObjectRecords('Opportunity', fieldsetName, fieldsetName, 20, 'ORDER BY Name', '', '', objTopic.Id, '' ,'',
                                                    'AccountId', objAccount.Id);*/

        objResults =  SL_ObjectListController.fetchSObjectRecords('Opportunity', fieldsetName, fieldsetName, 20, 'AccountId = <<Account.Id>> ORDER BY Name', '', '', '', '' ,'',
                                                    'AccountId', objAccount.Id);

        // system.assertEquals(objResults.lstSObjectRecords.size(), 1);
         SL_ObjectListController.getAttachmentAndFiles(objOppty.Id);
    }

    // Test code for SL_ObjectDetailController
    static testMethod void testObjectDetail() {
        
        //to detect if destination org has NamespacePrefix
        Organization org = [SELECT NamespacePrefix FROM Organization]; 
        String fieldsetName = org.NamespacePrefix != null ? org.NamespacePrefix + '__nFORCE__Xml_Response_Test' : 'nFORCE__Xml_Response_Test';
        
        Opportunity objOppty = new Opportunity(
            Name = 'Test Oppty',
            StageName = 'Closed Won',
            Amount = 50000, Product__c = 'ACH',
            Committed_Amount__c = 1000,
            CloseDate = Date.today(),
            RecordTypeId = ObjectFactory.GetRecordTypeIdByNameAndObject('Consumer', 'Opportunity')
        );
        
        insert objOppty;
        
        String sObjectId = objOppty.Id;
        SL_ObjectDetailController.ObjectDetail_InnerClass objResults = SL_ObjectDetailController.getSObjectDetailRecord('Opportunity', sObjectId, 
            fieldsetName, 'ContactID = current_user_contact AND OwnerId = CurrentUser AND StageName = \'Closed Won\' ORDER BY Name ', 
            'HIDDEN', true, true, 2);
            
//        system.assertEquals(objResults.sObjectDetailRecord.size(), 1);
    }
}