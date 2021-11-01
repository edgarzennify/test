@isTest
public class EbAccount_InterstitialDataProviderTests {

    private static EbAccount_InterstitialDataProvider sut;
    
    static{
        sut = new EbAccount_InterstitialDataProvider();
    }
    
    private static testMethod void it_should_getEbAccountById(){
        EB_Team_Member__c testRM = ObjectFactory.getTeamMember('TestRM');
        Id testRecordTypeId = Objectfactory.getRecordTypeIdByNameAndObject('Client', 'Account');
        Account testEntity = ObjectFactory.getEntity('TestEntityName', testRecordTypeId, testRM);
        EB_Account__c testEbAcct = ObjectFactory.getEBAccount('TestLoan', '12345', testEntity);
        testEbAcct.Key__c = 'TestKey';
        update testEbAcct;

        List<EB_Account__c> result = sut.getEbAccountById(testEbAcct.Id);
        
        System.assertEquals('TestKey', result[0].Key__c);
    }
    
}