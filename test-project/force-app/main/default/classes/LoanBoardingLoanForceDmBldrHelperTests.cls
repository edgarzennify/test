@IsTest
public class LoanBoardingLoanForceDmBldrHelperTests{
    private static final LoanBoardingLoanForceDmBuilderHelper sut;
    static{
        sut = new LoanBoardingLoanForceDmBuilderHelper();
    }

    /*private static testMethod void it_should_build_a_loan_when_load_id_is_provided(){
        Id loanId = ObjectFactory.getFakeId(Eb_Loan_Application__c.SObjectType, '1');
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        Eb_Loan_Application__c loan = new Eb_Loan_Application__c();
        loan.Id = loanId;
        loan.Account_Number_Assigned__c = '889970-11';
        loan.Loan_Type__c = 'fixed loan';
        loan.Bank_Owned_Loan_Amount__c = 1100.00;
        RecordType rec = new RecordType();
        rec.Name = 'rec type';
        loan.RecordType = rec;
        EB_Loan_Packet__c packet = new EB_Loan_Packet__c();
        packet.RM_Commentary__c = 'rm comments';
        packet.Channel__c = 'business';
        Account leadEntity = new Account();
        leadEntity.Name = 'test-entity';
        leadEntity.Id = entityId;
        User u = new User();
        u.Id = userId;
        Eb_Team_Member__c team = new Eb_Team_Member__c(Name = 'test-team', User__c = u.Id);
        leadEntity.Team_Relationship_Manager__r = team;
        packet.Lead_Entity__r = leadEntity;
        loan.EB_Loan_Packet__r = packet;
        EB_Industry_Code__c industryCode = new EB_Industry_Code__c();
        industryCode.Name = 'code-001';
        loan.EB_Account_Industry_Code__r = industryCode;
        loan.Use_of_Funds__c = 'use it';
        loan.Maturity_Term_In_Months__c = 55.0;
        LoanBoarding.LoanForceLoanPm loanPm = new LoanBoarding.LoanForceLoanPm();
        loanPm.loanApplication = loan;

        DmLoan result = sut.buildLoan(loanPm);

        System.assertEquals(loanId, result.id);
        System.assertEquals(null, result.name);
        System.assertEquals('889970-11', result.lookupKey);
        System.assertEquals('fixed loan', result.product);
        System.assertEquals(null, result.originalAmount);
        System.assertEquals(false, result.isRenewal);
        System.assertEquals('business', result.channel);
        System.assertEquals(null, result.regOLoan);
        System.assertEquals(null, result.employeeLoan);
        System.assertEquals('code-001', result.industryCode);
        System.assertEquals('use it', result.useOfFunds);
        System.assertEquals('rm comments', result.rmComments);
        System.assertEquals(55.0, result.maturityMonth);
    }

    private static testMethod void it_should_build_a_loan_with_rate_stream_and_payment_stream_info_when_load_id_is_provided(){
        Id loanId = ObjectFactory.getFakeId(Eb_Loan_Application__c.SObjectType, '1');
        Eb_Loan_Application__c loan = new Eb_Loan_Application__c();
        loan.Id = loanId;
        loan.RecordType = new RecordType(Name='Renewal');
        LoanBoarding.LoanForceLoanPm loanPm = new LoanBoarding.LoanForceLoanPm();
        loanPm.loanApplication = loan;
        EB_Loan_App_Rate_Stream__c rate = new EB_Loan_App_Rate_Stream__c();
        rate.Fixed_Interest_Rate__c = 2.0;
        rate.Interest_Rate_Floor__c = 1.00;
        rate.Interest_Rate_Ceiling__c = 2.00;
        rate.EB_Floating_Rate__r = new EB_Floating_Rate__c(Name = 'test-index');
        rate.Rate_Subject_To_Change__c = 'sub';
        rate.Rate_Index_Variance__c = 1.05;
        rate.Index_Variance_Code__c = 'basis';
        loanPm.rateStreams = new List<EB_Loan_App_Rate_Stream__c>{rate};
        EB_Loan_Application_Payment_Stream__c pay = new EB_Loan_Application_Payment_Stream__c();
        pay.Amortization_Schedule_in_Months__c = 20.00;
        pay.RecordType = new RecordType(Name='test-pay');
        pay.Frequency__c = '3';
        pay.Amount__c = 200.00;
        loanPm.paymentStreams = new List<EB_Loan_Application_Payment_Stream__c>{pay};

        DmLoan result = sut.buildLoan(loanPm);

        System.assertEquals(2.0, result.interestRate);
        System.assertEquals(1.00, result.rateFloor);
        System.assertEquals(2.00, result.rateCeiling);
        System.assertEquals('test-index', result.index);
        System.assertEquals('sub', result.interestRateAdjustmentFrequency);
        System.assertEquals(1.05, result.spread);
        System.assertEquals('basis', result.pricingBasis);

        System.assertEquals(20.00, result.amortizedMonth);
        System.assertEquals('test-pay', result.paymentType);
        System.assertEquals('3', result.paymentSchedule);
        System.assertEquals(200.00, result.monthlyPayment);
    }

    private static testMethod void it_should_build_a_related_entity(){
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id relId = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '1');
        Account entity  = new Account();
        entity.Id = entityId;
        entity.Name = 'test-name';
        entity.SSNTIN_Encrypted__c = 'test-ssn';
        entity.TIN_SSN__c = 'test-tin-ssn';
        entity.BillingStreet = 'street';
        entity.BillingCity = 'city';
        entity.BillingState = 'state';
        entity.BillingPostalCode = 'postal-code';

        EB_Loan_App_Entity_Relationship__c pm = new EB_Loan_App_Entity_Relationship__c();
        pm.Id = relId;
        pm.Relationship_Type__c = 'rel-type';
        pm.Entity_Name__r = entity;

        List<EB_Industry_Code__c> codes = new List<EB_Industry_Code__c>();

        DmLoanEntityRelationship result = sut.buildRelatedEntities(pm, codes);
        
        System.assertEquals(relId, result.id);
        System.assertEquals(null, result.name);
        System.assertEquals('test-ssn', result.entity.taxId);
        System.assertEquals('street', result.entity.billingStreet);
        System.assertEquals('city', result.entity.billingCity);
        System.assertEquals('state', result.entity.billingState);
        System.assertEquals('postal-code', result.entity.billingPostalCode);
    }

    private static testMethod void it_should_build_a_related_entity_with_ssn_when_tin_is_empty(){
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id relId = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '1');
        Account entity  = new Account();
        entity.Id = entityId;
        entity.Name = 'test-name';
        entity.SSNTIN_Encrypted__c = 'test-ssn';
        //entity.TIN_SSN__c = 'test-tin-ssn';
        entity.BillingStreet = 'street';
        entity.BillingCity = 'city';
        entity.BillingState = 'state';
        entity.BillingPostalCode = 'postal-code';

        EB_Loan_App_Entity_Relationship__c pm = new EB_Loan_App_Entity_Relationship__c();
        pm.Id = relId;
        pm.Relationship_Type__c = 'rel-type';
        pm.Entity_Name__r = entity;

        List<EB_Industry_Code__c> codes = new List<EB_Industry_Code__c>();

        DmLoanEntityRelationship result = sut.buildRelatedEntities(pm, codes);
        
        System.assertEquals(relId, result.id);
        System.assertEquals(null, result.name);
        System.assertEquals('test-ssn', result.entity.taxId);
        System.assertEquals('street', result.entity.billingStreet);
        System.assertEquals('city', result.entity.billingCity);
        System.assertEquals('state', result.entity.billingState);
        System.assertEquals('postal-code', result.entity.billingPostalCode);
    }

    private static testMethod void it_should_build_a_related_entity_with_tin_when_ssn_is_empty(){
        Id entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Id relId = ObjectFactory.getFakeId(EB_Loan_App_Entity_Relationship__c.SObjectType, '1');
        Account entity  = new Account();
        entity.Id = entityId;
        entity.Name = 'test-name';
        //entity.SSNTIN_Encrypted__c = 'test-ssn';
        entity.TIN_SSN__c = 'test-tin-ssn';
        entity.BillingStreet = 'street';
        entity.BillingCity = 'city';
        entity.BillingState = 'state';
        entity.BillingPostalCode = 'postal-code';

        EB_Loan_App_Entity_Relationship__c pm = new EB_Loan_App_Entity_Relationship__c();
        pm.Id = relId;
        pm.Relationship_Type__c = 'rel-type';
        pm.Entity_Name__r = entity;

        List<EB_Industry_Code__c> codes = new List<EB_Industry_Code__c>();

        DmLoanEntityRelationship result = sut.buildRelatedEntities(pm, codes);
        
        System.assertEquals(relId, result.id);
        System.assertEquals(null, result.name);
        System.assertEquals('test-tin-ssn', result.entity.taxId);
        System.assertEquals('street', result.entity.billingStreet);
        System.assertEquals('city', result.entity.billingCity);
        System.assertEquals('state', result.entity.billingState);
        System.assertEquals('postal-code', result.entity.billingPostalCode);
    }

    private static testMethod void it_should_build_a_related_collateral(){
        Id relId = ObjectFactory.getFakeId(EB_Loan_App_Collateral_Relationship__c.SObjectType, '1');
        EB_Loan_App_Collateral_Relationship__c pm = new EB_Loan_App_Collateral_Relationship__c();
        pm.Id = relId;
        pm.EB_Collateral_ID__r = new EB_Collateral__c();
        pm.EB_Collateral_ID__r.Collateral_Owner__r = new Account();

        DmLoanCollateralRelationship result = sut.buildPledgedCollateral(pm, pm.EB_Collateral_ID__r.Collateral_Owner__r);
        
        System.assertEquals(relId, result.id);
        System.assertEquals(null, result.Name);
    }

    private static testMethod void it_should_call_the_related_participation(){
        Id partId = ObjectFactory.getFakeId(EB_Loan_Participation__c.SObjectType, '1');

        EB_Loan_Participation__c pm = new EB_Loan_Participation__c();
        pm.id = partId;

        DmParticipation result = sut.buildPArticipation(pm);
    } 

    private static testMethod void it_should_create_an_empty_memo(){

        DmMemo result = sut.buildMemo(null);

        System.assertEquals(null,result.description);
        System.assertEquals(null, result.changes);
    }*/

}