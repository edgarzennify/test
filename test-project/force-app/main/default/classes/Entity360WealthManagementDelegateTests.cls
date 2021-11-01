@isTest
public class Entity360WealthManagementDelegateTests {

        private static final Entity360WealthManagementDelegate sut;
        private static Entity360.ElementType wealthManagement = Entity360.ElementType.WEALTH_MANAGEMENT;

        static
        {
            sut = new Entity360WealthManagementDelegate();
        }

        private static testMethod void it_should_assemble_a_dm_product_overview_when_a_dm_entity_is_provided_for_wealth_management()
        {
                DmEntity dmEntity = new DmEntity();
                dmEntity.id = '0000000000000a';
                dmEntity.name = 'Test DmEntity';
                
                DmEbAccount acct1 = new DmEbAccount();
                acct1.application = 1;
                acct1.accountFees = 3000.00;
                acct1.coreCurrentBalance = 1000.00;

                DmEbAccount acct2 = new DmEbAccount();
                acct2.application = 1;
                acct2.accountFees = 5000.00;

                DmEbAccount acct3 = new DmEbAccount();
                acct3.application = 2;
                acct3.accountFees = 4000.00;
                acct3.currentBalance = 2000.00;
                
                dmEntity.ownedAccounts = new List<DmEbAccount>{acct1,acct2,acct3};
               
                DmRecordType wmOppRecordType = new DmRecordType();
                wmOppRecordType.description = 'Wealth Management Opportunities';

                DmRecordType loanOppRecordType = new DmRecordType();
                loanOppRecordType.description = 'Commercial Banking and Commercial Finance Lending Opportunities';

                DmOpportunity opp1 = new DmOpportunity();
                opp1.recordType = wmOppRecordType;
                opp1.potentialFeeIncome = 2000.0;
                opp1.probability = 10;

                DmOpportunity opp2 = new DmOpportunity();
                opp2.recordType = wmOppRecordType;
                opp2.potentialFeeIncome = 2000.0;
                opp2.probability = 50;

                DmOpportunity opp3 = new DmOpportunity();
                opp3.recordType = loanOppRecordType;
                opp3.committedAmount = 3000.0;
                opp3.probability = 50;

                dmEntity.opportunities = new List<DmOpportunity>{opp1,opp2,opp3};

                DmTreasuryService tmService1 = new DmTreasuryService();
                dmEntity.treasuryServices = new List<DmTreasuryService>{tmService1};

                DmProductOverview result = sut.assembleFrom(dmEntity);

                System.assertEquals(wealthManagement, result.type);
                System.assertEquals(8000.00, result.existingValue);
                System.assertEquals(4000.00, result.opportunityValue);
                System.assertEquals(30.0, result.opportunityProbability);
        }

        private static testMethod void it_should_assemble_a_dm_product_overview_when_there_are_no_owned_accounts_and_no_opps()
        {
                DmEntity dmEntity = new DmEntity();
                dmEntity.id = '0000000000000a';
                dmEntity.name = 'Test DmEntity';

                DmProductOverview result = sut.assembleFrom(dmEntity);

                System.assertEquals(wealthManagement, result.type);
                System.assertEquals(0.0, result.existingValue);
                System.assertEquals(0.0, result.opportunityValue);
                System.assertEquals(0.0, result.opportunityProbability);
        }

        private static testMethod void it_should_use_zero_for_accountFees_when_a_wealth_mgmt_owned_account_has_null_accountFees()
        {
                DmEntity dmEntity = new DmEntity();
                dmEntity.id = '0000000000000a';
                dmEntity.name = 'Test DmEntity';
                
                DmEbAccount acct1 = new DmEbAccount();
                acct1.application = 1;
                acct1.accountFees = 3000.00;

                DmEbAccount acct2 = new DmEbAccount();
                acct2.application = 1;
                
                dmEntity.ownedAccounts = new List<DmEbAccount>{acct1,acct2};
               
                DmProductOverview result = sut.assembleFrom(dmEntity);

                System.assertEquals(wealthManagement, result.type);
                System.assertEquals(3000.00, result.existingValue);
                System.assertEquals(0.0, result.opportunityValue);
                System.assertEquals(0.0, result.opportunityProbability);
        }

        private static testMethod void it_should_ignore_an_opportunity_when_its_potentialFeeIncome_is_null()
        {
                DmEntity dmEntity = new DmEntity();
                dmEntity.id = '0000000000000a';
                dmEntity.name = 'Test DmEntity';
                
                DmRecordType wmOppRecordType = new DmRecordType();
                wmOppRecordType.description = 'Wealth Management Opportunities';

                DmOpportunity opp1 = new DmOpportunity();
                opp1.recordType = wmOppRecordType;
                opp1.potentialFeeIncome = 2000.0;
                opp1.probability = 10;

                DmOpportunity opp2 = new DmOpportunity();
                opp2.recordType = wmOppRecordType;
                opp2.probability = 50;

                dmEntity.opportunities = new List<DmOpportunity>{opp1,opp2};

                DmProductOverview result = sut.assembleFrom(dmEntity);

                System.assertEquals(wealthManagement, result.type);
                System.assertEquals(0.0, result.existingValue);
                System.assertEquals(2000.00, result.opportunityValue);
                System.assertEquals(10.0, result.opportunityProbability);
        }

        private static testMethod void it_should_ignore_an_opportunity_when_its_probability_is_null()
        {
                DmEntity dmEntity = new DmEntity();
                dmEntity.id = '0000000000000a';
                dmEntity.name = 'Test DmEntity';
                
                DmRecordType wmOppRecordType = new DmRecordType();
                wmOppRecordType.description = 'Wealth Management Opportunities';

                DmOpportunity opp1 = new DmOpportunity();
                opp1.recordType = wmOppRecordType;
                opp1.potentialFeeIncome = 2000.0;
                opp1.probability = 10;

                DmOpportunity opp2 = new DmOpportunity();
                opp2.recordType = wmOppRecordType;
                opp2.potentialFeeIncome = 2000.0;

                dmEntity.opportunities = new List<DmOpportunity>{opp1,opp2};

                DmProductOverview result = sut.assembleFrom(dmEntity);

                System.assertEquals(wealthManagement, result.type);
                System.assertEquals(0.0, result.existingValue);
                System.assertEquals(2000.00, result.opportunityValue);
                System.assertEquals(10.0, result.opportunityProbability);
        }
}