@isTest
public class Entity360LoanDelegateTests
{
    private static final Entity360LoanDelegate sut;
    private static Entity360.ElementType loan = Entity360.ElementType.Loan;
    
    static
    {
        sut = new Entity360LoanDelegate();
    }
    
    private static testMethod void it_should_assemble_a_dm_product_overview_when_a_dm_entity_is_provided_for_loans(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 11;
        acct1.averageBalance = 1000.00;
        accounts.add(acct1);
        dmEntity.ownedAccounts = accounts;
        List<DmOpportunity> opps = new List<DmOpportunity>();
        DmOpportunity opp1 = new DmOpportunity();
        opp1.committedAmount = 2000.0;
        opp1.probability = 10;
        opps.add(opp1);
        DmOpportunity opp2 = new DmOpportunity();
        opp2.committedAmount = 2000.0;
        opp2.probability = 50;
        opps.add(opp2);
        dmEntity.opportunities = opps;
        List<DmTreasuryService> tmServices = new List<DmTreasuryService>();
        DmTreasuryService tmService1 = new DmTreasuryService();
        tmServices.add(tmService1);
        dmEntity.treasuryServices = tmServices;

        DmProductOverview result = sut.assembleFrom(dmEntity);
        
        System.assertEquals(loan, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(4000.00, result.opportunityValue);
        System.assertEquals(30.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_dm_product_overview_when_there_are_no_owned_accounts_and_no_opps()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(loan, result.type);
        System.assertEquals(0.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_use_zero_for_average_balance_when_a_loan_owned_account_has_a_null_core_current_balance(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 11;
        acct1.averageBalance = 1000.00;
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 11;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1, acct2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(loan, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_ignore_an_opportunity_when_its_committed_amount_is_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 11;
        acct1.averageBalance = 1000.00;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1};

        DmOpportunity opp1 = new DmOpportunity();
        opp1.committedAmount = 2000.0;
        opp1.probability = 10;
        DmOpportunity opp2 = new DmOpportunity();
        opp2.probability = 50;
        dmEntity.opportunities = new List<DmOpportunity>{opp1,opp2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(loan, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(2000.00, result.opportunityValue);
        System.assertEquals(10.0, result.opportunityProbability);
    }  

    private static testMethod void it_should_ignore_an_opportunity_when_its_probability_is_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 11;
        acct1.averageBalance = 1000.00;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1};

        DmOpportunity opp1 = new DmOpportunity();
        opp1.committedAmount = 2000.0;
        opp1.probability = 10;
        DmOpportunity opp2 = new DmOpportunity();
        opp2.committedAmount = 5000.0;
        dmEntity.opportunities = new List<DmOpportunity>{opp1,opp2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(loan, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(2000.00, result.opportunityValue);
        System.assertEquals(10.0, result.opportunityProbability);
    }  
}