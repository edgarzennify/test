@isTest
private class AgreementTestTriggerHelperTests {
    static testMethod void code_coverage(){    	       
    	User usr = ObjectFactory.getUser();
        
        EB_Team_Member__c tm = ObjectFactory.getTeamMember('abc');
        tm.User__c = usr.Id;
        update tm;
        
        EB_Unit__c newUnit = ObjectFactory.getUnit('Bogus', 1);
        newUnit.Senior_Lender__c = tm.Id;
        update newUnit;
        
        RecordType clientRecordType = utility.recordTypeObject('Account', 'Client');
        Account priBorrower = ObjectFactory.getEntity('bogus', clientRecordType.Id, tm);
        priBorrower.EB_UnitID__c = newUnit.Id;
        update priBorrower;
    	
        Agreement__c agmt = new Agreement__c();
        agmt.Primary_Borrower__c = priBorrower.Id;
    	insert agmt;
        
        Agreement_Test__c newTest = new Agreement_Test__c();
    	newTest.Agreement__c = agmt.Id;
        
        newTest.Approver_One__c = usr.Id;        
        
    	insert newTest;
    	update newTest;
    }
    
}