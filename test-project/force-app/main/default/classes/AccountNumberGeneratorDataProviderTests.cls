@isTest
private class AccountNumberGeneratorDataProviderTests{
    private static AccountNumberGeneratorDataProvider sut;
    
    static {
        sut = new AccountNumberGeneratorDataProvider();
    }
    
    private static testMethod void it_should_get_card_information_by_the_given_id(){
        Card_Information__c c1 = new Card_Information__c();
        insert c1;
        
        Card_Information__c result = sut.getCardInformationById(c1.Id);
        
        System.assertEquals(c1.id, result.Id);
        Object wasFieldInSOQL;
        wasFieldInSOQL = result.Id;
        wasFieldInSOQL = result.Card_Type__c;
        wasFieldInSOQL = result.url__c;
        wasFieldInSOQL = result.Account_Type__c ;
    }
    
    private static testMethod void it_should_get_all_active_card_infos_for_the_given_type(){
        Card_Information__c c1 = new Card_Information__c(Account_Type__c='Deposit', Active__c=true);
        Card_Information__c c2 = new Card_Information__c(Account_Type__c='Loan', Active__c=true);
        Card_Information__c c3 = new Card_Information__c(Account_Type__c='Loan', Active__c=false);
        insert new List<Card_Information__c> {c1, c2, c3};
        
        List<Card_Information__c> result = sut.getActiveCardInformationsByType('Deposit');

        System.assertEquals(1, result.size());
        System.assertEquals(c1.Id, result[0].Id);
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].Id;
        wasFieldInSOQL = result[0].Card_Type__c;
        wasFieldInSOQL = result[0].url__c;
        wasFieldInSOQL = result[0].Account_Type__c;
    }

    private static testMethod void it_should_get_all_active_card_infos(){
        Card_Information__c c1 = new Card_Information__c(Account_Type__c='Deposit', Active__c=true,From_Tm_Request__c=false);
        Card_Information__c c2 = new Card_Information__c(Account_Type__c='Loan', Active__c=true, From_Tm_Request__c=true);
        Card_Information__c c3 = new Card_Information__c(Account_Type__c='Loan', Active__c=false);
        insert new List<Card_Information__c> {c1, c2, c3};
        
        List<Card_Information__c> result = sut.getAllActiveCardInformations();

        System.assertEquals(2, result.size());
        System.assertEquals(c1.Id, result[0].Id);
        Object wasFieldInSOQL;
        wasFieldInSOQL = result[0].Id;
        wasFieldInSOQL = result[0].Card_Type__c;
        wasFieldInSOQL = result[0].url__c;
        wasFieldInSOQL = result[0].Account_Type__c;
        wasFieldInSOQL = result[0].From_Tm_Request__c;
    }
    
    private static testMethod void it_should_update_the_given_loan(){
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        insert loan;
        
        sut.save(loan);
    }
}