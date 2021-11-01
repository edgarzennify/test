@isTest
private class EBAccountTriggerHelperTests{
	    
   static testMethod void it_should_fail_when_attempting_to_delete_an_account(){
        //assemble
    	RecordType client = Utility.recordTypeObject('Account', 'Client');
    	EB_Team_Member__c rm = ObjectFactory.getTeamMember('Test RM');
    	Account entity = ObjectFactory.getEntity('Test Entity', client.Id, rm);
        EB_Account__c account = ObjectFactory.getEBAccount('Test Account','12345', entity);
        
        //act & assert
        try{
        	delete account;
        	System.assert(false,'Deleting an account should have failed.');
        }catch(Exception e){
            System.assert(e.getMessage().contains('Error: Delete is disabled for Accounts.  Please call your System Administrator for assistance.'));
        }
    }
    
    static testMethod void it_should_NOT_fail_when_deleting_an_OREO_account(){
        //assemble
        RecordType clientEntityType = Utility.recordTypeObject('Account', 'Client');
        RecordType oreoAccountType = Utility.recordTypeObject('EB_Account__c','OREO');
        EB_Team_Member__c rm = ObjectFactory.getTeamMember('Test RM');
        Account entity = ObjectFactory.getEntity('Test Entity', clientEntityType.Id, rm);
        EB_Account__c account = ObjectFactory.getEBAccount('Test Account','12345', entity);
        account.RecordTypeId = oreoAccountType.Id;
        account.OREO_FDIC_Reference_Number__c = '0000000000000';
        update account;
        
        //act & assert
        try{
            delete account;
            System.assert(true);
        }catch(Exception e){            
            System.assert(false,'Deleting an OREO account should not have failed.');
        }
    }
    
    static testMethod void it_should_initialize_OREO_accounts_on_insert(){
    	//assemble
    	RecordType clientEntityType = Utility.recordTypeObject('Account', 'Client');
        RecordType oreoAccountType = Utility.recordTypeObject('EB_Account__c','OREO');
        EB_Team_Member__c rm = ObjectFactory.getTeamMember('Test RM');
        Account entity = ObjectFactory.getEntity('Test Entity', clientEntityType.Id, rm);
        EB_Account__c account = (EB_Account__c)SmartFactory.createSObject('EB_Account__c');
        account.RecordTypeId = oreoAccountType.Id;
        account.OREO_FDIC_Reference_Number__c = '0000000000000';
        account.Account_Line_1__c = 'this should get changed';
        account.Account_Number__c = '12345';
        account.Primary_Owner_Id__c = entity.Id;
        account.Account_Status__c = 'A';
        account.Application__c = 15;
        account.EB_Team_Member__c = rm.Id;
        
        //act
        insert account;
        
        //assert
        EB_Account__c requery = [SELECT Id, Name, Key__c, OREO_Short_Name__c, Account_Line_1__c, Application__c FROM EB_Account__c WHERE Id =: account.Id];
        System.assertEquals(requery.Name, requery.Key__c);
        System.assertEquals(requery.OREO_Short_Name__c, requery.Account_Line_1__c);
        System.assertEquals(91,requery.Application__c);
    }
    
    static testMethod void it_should_set_account_line_1_equal_to_OREO_short_name_on_an_OREO_account_when_updating(){
    	//assemble
    	RecordType clientEntityType = Utility.recordTypeObject('Account', 'Client');
        RecordType oreoAccountType = Utility.recordTypeObject('EB_Account__c','OREO');
        EB_Team_Member__c rm = ObjectFactory.getTeamMember('Test RM');
        Account entity = ObjectFactory.getEntity('Test Entity', clientEntityType.Id, rm);
        EB_Account__c account = ObjectFactory.getEBAccount('Test Account','12345', entity);
        account.RecordTypeId = oreoAccountType.Id;
        account.OREO_FDIC_Reference_Number__c = '0000000000000';
        account.Account_Line_1__c = 'this should get changed';
        
        //act
        update account;
        
        //assert
        EB_Account__c requery = [SELECT Id, Name, Account_Line_1__c, OREO_Short_Name__c FROM EB_Account__c WHERE Id =: account.Id];
        System.assertEquals(requery.OREO_Short_Name__c, requery.Account_Line_1__c);
    }
    
    static testMethod void it_should_set_the_Account_Officer_Email_field_when_inserting(){
    	//assemble
        RecordType clientEntityType = Utility.recordTypeObject('Account', 'Client');
        RecordType oreoAccountType = Utility.recordTypeObject('EB_Account__c', 'OREO');
        EB_Team_Member__c rm = ObjectFactory.getTeamMember('Test RM');
        rm.User__r.Email = 'theright@emailaddress.com';
        update rm.User__r;        
        Account entity = ObjectFactory.getEntity('Test Entity', clientEntityType.Id, rm);
        
        //act
        EB_Account__c account = ObjectFactory.getEBAccount('Test Account', '12345', entity, rm);
        
        //assert
        EB_Account__c requery = [SELECT Id, Name, Account_Officer_Email__c FROM EB_Account__c WHERE Id =: account.Id];
        System.assertEquals(rm.User__r.Email,requery.Account_Officer_Email__c);
    }
    
    static testMethod void it_should_update_the_Account_Officer_Email_field_when_updating(){
    	//assemble
        RecordType clientEntityType = Utility.recordTypeObject('Account', 'Client');
        RecordType oreoAccountType = Utility.recordTypeObject('EB_Account__c', 'OREO');
        EB_Team_Member__c rm = ObjectFactory.getTeamMember('Test RM');
        rm.User__r.Email = 'theright@emailaddress.com';
        update rm.User__r;
        Account entity = ObjectFactory.getEntity('Test Entity', clientEntityType.Id, rm);
        EB_Account__c account = ObjectFactory.getEBAccount('Test Account', '12345', entity, rm);
        
        //act
        account.Account_Officer_Email__c = 'this.field@shoulGetUpdated.com';
        update account;
        
        //assert
        EB_Account__c requery = [SELECT Id, Name, Account_Officer_Email__c FROM EB_Account__c WHERE Id =: account.Id];
        System.assertEquals(rm.User__r.Email,requery.Account_Officer_Email__c);
    }
}