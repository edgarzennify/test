@isTest
public class Entity360DebitCardDelegateTests
{
    private static final Entity360DebitCardDelegate sut;
    private static Entity360.ElementType debitCard = Entity360.ElementType.DEBIT_CARD;

    static
    {
        sut = new Entity360DebitCardDelegate();
    }
    
    private static testMethod void it_should_assemble_a_dm_product_overview_for_debit_cards_when_a_dm_entity_is_provided_with_one_debit_card_account(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 83;
        accounts.add(acct1);
        dmEntity.ownedAccounts = accounts;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(debitCard, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_dm_product_overview_for_debit_cards_when_a_dm_entity_is_provided_with_more_than_one_debit_card_account(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 83;
        accounts.add(acct1);
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 83;
        accounts.add(acct2);
        DmEbAccount acct3 = new DmEbAccount();
        acct3.application = 83;
        accounts.add(acct3);
        dmEntity.ownedAccounts = accounts;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(debitCard, result.type);
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

        System.assertEquals(debitCard, result.type);
        System.assertEquals(0.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }
}