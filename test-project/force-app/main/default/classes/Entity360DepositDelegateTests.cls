@isTest
public class Entity360DepositDelegateTests
{
    private static final Entity360DepositDelegate sut;
    private static Entity360.ElementType deposit = Entity360.ElementType.DEPOSIT;

    static
    {
        sut = new Entity360DepositDelegate();
    }
    
    private static testMethod void it_should_return_a_dm_product_overview_when_a_dm_entity_is_provided_for_deposits()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.employeeAccountFlag='No';
        acct1.averageBalance = 1000.00;
        accounts.add(acct1);
        dmEntity.ownedAccounts = accounts;
        List<DmOpportunity> opps = new List<DmOpportunity>();
        DmOpportunity opp1 = new DmOpportunity();
        opp1.potentialDeposits = 2000.0;
        opp1.probability = 10;
        opps.add(opp1);
        DmOpportunity opp2 = new DmOpportunity();
        opp2.potentialDeposits = 3000.0;
        opp2.probability = 50;
        opps.add(opp2);
        dmEntity.opportunities = opps;
        List<DmTreasuryService> tmServices = new List<DmTreasuryService>();
        DmTreasuryService tmService1 = new DmTreasuryService();
        tmServices.add(tmService1);
        dmEntity.treasuryServices = tmServices;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(5000.00, result.opportunityValue);
        System.assertEquals(34.0, result.opportunityProbability);
    }

    private static testMethod void it_should_not_include_a_loan_account_in_the_deposit_totals()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.employeeAccountFlag='No';
        acct1.averageBalance = 1000.00;
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 11;
        acct2.employeeAccountFlag='No';
        acct2.averageBalance = 2000.00;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1, acct2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_product_overview_when_there_are_no_owned_accounts_and_no_opps()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(0.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }   

    private static testMethod void it_should_use_a_zero_balance_for_employee_accounts()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Test';
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.employeeAccountFlag='Yes';
        acct1.averageBalance = 1000.00;
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 2;
        acct2.employeeAccountFlag='No';
        acct2.averageBalance = 2000.00;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1, acct2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(2000.00, result.existingValue);
        System.assertEquals(0.00, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }   

    private static testMethod void it_should_ignore_an_opportunity_when_its_potential_deposits_is_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.employeeAccountFlag = 'No';
        acct1.averageBalance = 1000.00;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1};

        DmOpportunity opp1 = new DmOpportunity();
        opp1.potentialDeposits = 2000.0;
        opp1.probability = 10;
        DmOpportunity opp2 = new DmOpportunity();
        opp2.probability = 50;
        dmEntity.opportunities = new List<DmOpportunity>{opp1,opp2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(2000.00, result.opportunityValue);
        System.assertEquals(10.0, result.opportunityProbability);
    }   

    private static testMethod void it_should_ignore_an_owned_account_when_its_employee_account_flag_is_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.employeeAccountFlag='No';
        acct1.averageBalance = 1000.00;
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 2;
        acct2.averageBalance = 2000.00;
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1, acct2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    } 

    private static testMethod void it_should_ignore_an_owned_account_when_its_average_balance_is_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.employeeAccountFlag='No';
        acct1.averageBalance = 1000.00;
        DmEbAccount acct2 = new DmEbAccount();
        acct2.application = 2;
        acct2.employeeAccountFlag='No';
        dmEntity.ownedAccounts = new List<DmEbAccount>{acct1, acct2};

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(deposit, result.type);
        System.assertEquals(1000.00, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    } 
}