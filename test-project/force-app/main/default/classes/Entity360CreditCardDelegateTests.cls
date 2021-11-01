@isTest
public class Entity360CreditCardDelegateTests
{
    private static final Entity360CreditCardDelegate sut;
    private static Entity360.ElementType creditCard = Entity360.ElementType.CREDIT_CARD;
    
    static
    {
        sut = new Entity360CreditCardDelegate();
    }
    
    private static testMethod void it_should_assemble_a_dm_product_overview_for_credit_cards_when_a_dm_entity_is_provided_with_one_credit_card_account(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 50;
        acct1.accountType = '50';
        accounts.add(acct1);
        dmEntity.ownedAccounts = accounts;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(creditCard, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_dm_product_overview_for_credit_cards_when_a_dm_entity_is_provided_with_more_than_one_credit_card_account(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 50;
        acct1.accountType = '50';
        accounts.add(acct1);
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 50;
        acct2.accountType = '50';
        accounts.add(acct2);
        DmEbAccount acct3 = new DmEbAccount();
        acct3.application = 50;
        acct3.accountType = '50';
        accounts.add(acct3);
        dmEntity.ownedAccounts = accounts;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(creditCard, result.type);
        System.assertEquals(3.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_dm_product_overview_when_there_are_no_owned_accounts_and_no_opps()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(creditCard, result.type);
        System.assertEquals(0.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_dm_product_overview_for_credit_cards_when_a_dm_entity_is_provided_and_ignore_an_application_of_50_if_account_type_is_not_50(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 50;
        acct1.accountType = '1 ';
        accounts.add(acct1);
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 50;
        acct2.accountType = '50';
        accounts.add(acct2);
        DmEbAccount acct3 = new DmEbAccount();
        acct3.application = 50;
        acct3.accountType = '1-';
        accounts.add(acct3);
        dmEntity.ownedAccounts = accounts;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(creditCard, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_dm_product_overview_for_credit_cards_when_a_dm_entity_is_provided_with_an_account_type_10_credit_card(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 50;
        acct1.accountType = '10';
        accounts.add(acct1);
        dmEntity.ownedAccounts = accounts;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(creditCard, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }
}