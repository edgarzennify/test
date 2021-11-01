@isTest
public class Entity360TreasuryDelegateTests
{
    private static final Entity360TreasuryDelegate sut;
    private static Entity360.ElementType treasury = Entity360.ElementType.TREASURY;

    static
    {
        sut = new Entity360TreasuryDelegate();
    }
    
    private static testMethod void it_should_return_a_dm_product_overview_when_a_dm_entity_is_provided_for_treasury(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        DmEntity parentEntity = new DmEntity();
        parentEntity.id = '00000000000000b';
        dmEntity.parent = parentEntity;
        dmEntity.name = 'Test';
        List<DmEbAccount> accounts = new List<DmEbAccount>();
        DmEbAccount acct1 = new DmEbAccount();
        acct1.application = 2;
        acct1.coreCurrentBalance = 12000.00;
        acct1.employeeAccountFlag='No';
        acct1.currentBalance = 1000.00;
        accounts.add(acct1);
        dmEntity.ownedAccounts = accounts;
        List<DmOpportunity> opps = new List<DmOpportunity>();
        DmOpportunity opp1 = new DmOpportunity();
        opp1.potentialDeposits = 2000.0;
        opp1.probability = 10;
        DmRecordType deposit = new DmRecordType();
        deposit.description = 'Deposit'; 
        opp1.recordType = deposit;
        opps.add(opp1);

        DmOpportunity opp2 = new DmOpportunity();
        opp2.potentialDeposits = 3000.0;
        deposit.description = 'Deposit'; 
        opp2.recordType = deposit;            
        opp2.probability = 50;
        opps.add(opp2);

        DmOpportunity tmOpp1 = new DmOpportunity();
        DmRecordType treasuryRecType = new DmRecordType();
        treasuryRecType.description = 'Treasury Management Opportunities'; 
        tmOpp1.recordType = treasuryRecType;
        tmOpp1.probability = 50;
        tmOpp1.products = 'First Product;Second Product;Third Product';
        opps.add(tmOpp1);

        dmEntity.opportunities = opps;

        List<DmTreasuryService> tmServices = new List<DmTreasuryService>();
        DmTreasuryService tmService1 = new DmTreasuryService();
        tmServices.add(tmService1);
        dmEntity.treasuryServices = tmServices;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(treasury, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(3.0, result.opportunityValue);
        System.assertEquals(50.0, result.opportunityProbability);
    }

    private static testMethod void it_should_use_a_zero_product_count_when_treasury_opps_are_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        List<DmOpportunity> opps = new List<DmOpportunity>();
        DmOpportunity opp1 = new DmOpportunity();
        opp1.potentialDeposits = 2000.0;
        opp1.probability = 10;
        DmRecordType deposit = new DmRecordType();
        deposit.description = 'Deposit'; 
        opp1.recordType = deposit;
        opps.add(opp1);

        DmOpportunity opp2 = new DmOpportunity();
        opp2.potentialDeposits = 3000.0;
        deposit.description = 'Deposit'; 
        opp2.recordType = deposit;            
        opp2.probability = 50;
        opps.add(opp2);

        dmEntity.opportunities = opps;

        List<DmTreasuryService> tmServices = new List<DmTreasuryService>();
        DmTreasuryService tmService1 = new DmTreasuryService();
        tmServices.add(tmService1);
        dmEntity.treasuryServices = tmServices;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(treasury, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }  

    private static testMethod void it_should_use_a_zero_product_count_when_the_products_of_a_treasury_opp_are_null(){
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        List<DmOpportunity> opps = new List<DmOpportunity>();
        DmOpportunity opp1 = new DmOpportunity();
        opp1.potentialDeposits = 2000.0;
        opp1.probability = 10;
        DmRecordType deposit = new DmRecordType();
        deposit.description = 'Deposit'; 
        opp1.recordType = deposit;
        opps.add(opp1);

        DmOpportunity opp2 = new DmOpportunity();
        opp2.potentialDeposits = 3000.0;
        deposit.description = 'Deposit'; 
        opp2.recordType = deposit;            
        opp2.probability = 50;
        opps.add(opp2);

        DmOpportunity tmOpp1 = new DmOpportunity();
        DmRecordType treasuryRecType = new DmRecordType();
        treasuryRecType.description = 'Treasury Management Opportunities'; 
        tmOpp1.recordType = treasuryRecType;
        tmOpp1.probability = 50;
        opps.add(tmOpp1);
        
        dmEntity.opportunities = opps;

        List<DmTreasuryService> tmServices = new List<DmTreasuryService>();
        DmTreasuryService tmService1 = new DmTreasuryService();
        tmServices.add(tmService1);
        dmEntity.treasuryServices = tmServices;

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(treasury, result.type);
        System.assertEquals(1.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }

    private static testMethod void it_should_assemble_a_product_overview_when_there_are_no_treasury_services_and_no_opps()
    {
        DmEntity dmEntity = new DmEntity();
        dmEntity.id = '0000000000000a';
        dmEntity.name = 'Mr. Test';

        DmProductOverview result = sut.assembleFrom(dmEntity);

        System.assertEquals(treasury, result.type);
        System.assertEquals(0.0, result.existingValue);
        System.assertEquals(0.0, result.opportunityValue);
        System.assertEquals(0.0, result.opportunityProbability);
    }  
}