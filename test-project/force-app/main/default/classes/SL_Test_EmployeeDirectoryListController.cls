/**
* \arg ClassName        : SL_Test_EmployeeDirectoryListController
* \arg JIRATicket       : LIGHTNING-245
* \arg CreatedOn        : 01/Oct/2016
* \arg LastModifiedOn   : 15/Jun/2017
* \arg CreatededBy      : Ritika 
* \arg ModifiedBy       : Nilesh
* \arg Description      : test class for SL_EmployeeDirectoryListController
*/
@isTest
private class SL_Test_EmployeeDirectoryListController {

    static List<User> lstUser;
    private static void createData() {
        Id profileId  = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
		lstUser = new List<User>{
		    new User(Alias = 'User1', Email='user1@user.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-01@test.com', IsActive = false),
            new User(Alias = 'User2', Email='user2@user.com', EmailEncodingKey='UTF-8', LastName='Testing2', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-02@test.com', IsActive = false),
            new User(Alias = 'User3', Email='user3@user.com', EmailEncodingKey='UTF-8', LastName='Testing3', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-03@test.com', IsActive = true),
            new User(Alias = 'User4', Email='user4@user.com', EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-04@test.com', IsActive = true),
            new User(Alias = 'User5', Email='user5@user.com', EmailEncodingKey='UTF-8', LastName='Testing5', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-05@test.com', IsActive = true),
            new User(Alias = 'User6', Email='user6@user.com', EmailEncodingKey='UTF-8', LastName='Testing6', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-06@test.com', IsActive = true),
            new User(Alias = 'User7', Email='user7@user.com', EmailEncodingKey='UTF-8', LastName='Testing7', LanguageLocaleKey='en_US', 
			         LocaleSidKey='en_US', ProfileId = profileId, TimeZoneSidKey='America/Los_Angeles', UserName='user_TEDLC-07@test.com', IsActive = true)			         
		};
    	insert lstUser;        
    }
    
    static testMethod void test_EmployeeDirectoryListController() {
        createData();
        
        //to detect if destination org has NamespacePrefix
        Organization org = [SELECT NamespacePrefix FROM Organization]; 
        String fieldsetName = org.NamespacePrefix != null ? org.NamespacePrefix + '__EmployeeList' : 'EmployeeList';
        
        SL_EmployeeDirectoryListController.ResultsWrapper objWrapper = SL_EmployeeDirectoryListController.getListOfEmployees('User', fieldsetName, fieldsetName, 'AND IsActive=false ORDER BY Name', '', 'Admin Users', '', '');
        //system.assertEquals([SELECT Count() FROM User WHERE Id IN : objWrapper.lstAllEmployees AND Id IN : lstUser], 2);
        SL_EmployeeDirectoryListController.ResultsWrapper objWrapper1 = SL_EmployeeDirectoryListController.getListOfEmployees('User', fieldsetName, fieldsetName, 'OR IsActive=True ORDER BY Name', '', 'Admin Users', '', '');
        //system.assertEquals([SELECT Count() FROM User WHERE Id IN : objWrapper1.lstAllEmployees AND Id IN : lstUser], 5);
        SL_EmployeeDirectoryListController.getListOfEmployees('User', fieldsetName, fieldsetName, 'OR IsActive=True ORDER BY Name', 'Testing', 'Admin Users', '', '');
    }
}