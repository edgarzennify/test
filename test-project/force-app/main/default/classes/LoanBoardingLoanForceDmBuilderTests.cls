@IsTest
public class LoanBoardingLoanForceDmBuilderTests {

    private static final LoanBoardingLoanForceDmBuilder sut;
    private static final LoanBoardingMock.ofDataProvider mockDataProvider;
    private static final LoanBoardingMock.ofDmBuilderHelper mockDmBuilderHelper;

    static {
        mockDataProvider = new LoanBoardingMock.ofDataProvider();
        mockDmBuilderHelper = new LoanBoardingMock.ofDmBuilderHelper();

        sut = new LoanBoardingLoanForceDmBuilder(mockDataProvider, mockDmBuilderHelper);
    }

    @IsTest
    static void it_should_get_the_objecttype_from_the_passed_id() {
        SObjectType result = sut.isType();

        System.assertEquals(EB_Loan_Application__c.SObjectType, result);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_loan_pms() {
        Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        PM_EB_Loan_Application_c pmLoan = new PM_EB_Loan_Application_c();
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        
        DmLoan dmLoan = getDmLoan();
        
        mockDataProvider.setup('getLoanForceLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDataProvider.verify('getLoanForceLoan', new List<Object>{loanId}, Times.Once);
        mockDataProvider.verify('getIndustryCodes', Times.Once);
    }

    @IsTest
    static void it_should_call_the_dm_helper_to_build_a_DmLoan() {
        Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        PM_EB_Loan_Application_c pmLoan = new PM_EB_Loan_Application_c();
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        
        DmLoan dmLoan = getDmLoan();
        
        mockDataProvider.setup('getLoanForceLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDataProvider.verify('getLoanForceLoan', new List<Object>{loanId}, Times.Once);
        mockDataProvider.verify('getIndustryCodes', Times.Once);
        mockDmBuilderHelper.verify('buildLoan', new List<Object>{pmLoan}, Times.Once);
    }

    @IsTest
    static void it_should_return_the_pledged_collateral_with_is_owned_by_primary_borrower_flag_set() {
        Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        PM_EB_Loan_Application_c pmLoan = new PM_EB_Loan_Application_c();
        PM_EB_Loan_App_Entity_Relationship_c legEnt01 = new PM_EB_Loan_App_Entity_Relationship_c();
        legEnt01.Id = '1';
        PM_EB_Loan_App_Entity_Relationship_c legEnt02 = new PM_EB_Loan_App_Entity_Relationship_c();
        legEnt02.Id = '2';
        pmLoan.EB_Loan_App_Entity_Relationships_r = new List<PM_EB_Loan_App_Entity_Relationship_c>{legEnt01,legEnt02};
        PM_EB_Loan_App_Collateral_Relationship_c colRel01 = new PM_EB_Loan_App_Collateral_Relationship_c();        
        colRel01.Id = '1';        
        PM_EB_Loan_App_Collateral_Relationship_c colRel02 = new PM_EB_Loan_App_Collateral_Relationship_c();
        colRel02.Id = '2';
        pmLoan.EB_Loan_App_Collateral_Relationships_r = new List<PM_EB_Loan_App_Collateral_Relationship_c>{colRel01,colRel02};
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        
        DmEntity dmPrimaryBorrower = new DmEntity();
        dmPrimaryBorrower.Id = 'pb1';            
        DmEntity dmOtherBorrower = new DmEntity();
        dmOtherBorrower.Id = 'ob1';
        DmLoan dmLoan = getDmLoan();        
        DmLoanEntityRelationship dmLegEnt01 = new DmLoanEntityRelationship();
        dmLegEnt01.Id = 'le1';
        dmLegEnt01.Entity = dmPrimaryBorrower;
        dmLegEnt01.RelationshipType = 'Primary Borrower';
        DmLoanEntityRelationship dmLegEnt02 = new DmLoanEntityRelationship();
        dmLegEnt02.Id = 'le2';
        dmLegEnt02.Entity = dmOtherBorrower;
        dmLegEnt02.RelationshipType = 'Other';
        DmLoanCollateralRelationship dmColRel01 = new DmLoanCollateralRelationship();
        dmColRel01.Id = 'cr1';
        dmColRel01.collateral = new DmCollateral();
        dmColRel01.collateral.primaryOwner = dmPrimaryBorrower;
        DmLoanCollateralRelationship dmColRel02 = new DmLoanCollateralRelationship();
        dmColRel02.Id = 'cr2';
        dmColRel02.collateral = new DmCollateral();
        dmColRel02.collateral.primaryOwner = dmOtherBorrower;
        
        mockDataProvider.setup('getLoanForceLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legEnt01,codes})
            .returns(dmLegEnt01);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legEnt02,codes})
            .returns(dmLegEnt02);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{colRel01})
            .returns(dmColRel01);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{colRel02})
            .returns(dmColRel02);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        System.assertEquals(2, results.relatedEntities.size());
        System.assertEquals(dmLegEnt01, results.relatedEntities[0]);
        System.assertEquals(dmLegEnt02, results.relatedEntities[1]);
        System.assertEquals(2, results.pledgedCollateral.size());
        System.assertEquals(dmColRel01, results.pledgedCollateral[0]);
        System.assertEquals(dmColRel02, results.pledgedCollateral[1]);
        System.assertEquals(true, results.pledgedCollateral[0].isOwnedByPrimaryBorrower);
        System.assertEquals(false, results.pledgedCollateral[1].isOwnedByPrimaryBorrower);
    }
    
    @IsTest
    static void it_should_return_the_pledged_collateral_when_primary_owner_cannot_be_determined() {
        Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        PM_EB_Loan_Application_c pmLoan = new PM_EB_Loan_Application_c();
        PM_EB_Loan_App_Entity_Relationship_c legEnt01 = new PM_EB_Loan_App_Entity_Relationship_c();
        legEnt01.Id = '1';
        PM_EB_Loan_App_Entity_Relationship_c legEnt02 = new PM_EB_Loan_App_Entity_Relationship_c();
        legEnt02.Id = '2';
        pmLoan.EB_Loan_App_Entity_Relationships_r = new List<PM_EB_Loan_App_Entity_Relationship_c>{legEnt01,legEnt02};
        PM_EB_Loan_App_Collateral_Relationship_c colRel01 = new PM_EB_Loan_App_Collateral_Relationship_c();        
        colRel01.Id = '1';        
        PM_EB_Loan_App_Collateral_Relationship_c colRel02 = new PM_EB_Loan_App_Collateral_Relationship_c();
        colRel02.Id = '2';
        pmLoan.EB_Loan_App_Collateral_Relationships_r = new List<PM_EB_Loan_App_Collateral_Relationship_c>{colRel01,colRel02};
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        
        DmEntity dmPrimaryBorrower = new DmEntity();
        dmPrimaryBorrower.Id = 'pb1';            
        DmEntity dmOtherBorrower = new DmEntity();
        dmOtherBorrower.Id = 'ob1';
        DmLoan dmLoan = getDmLoan();        
        DmLoanEntityRelationship dmLegEnt01 = new DmLoanEntityRelationship();
        dmLegEnt01.Id = 'le1';
        dmLegEnt01.Entity = dmPrimaryBorrower;
        dmLegEnt01.RelationshipType = 'Not Primary Borrower';
        DmLoanEntityRelationship dmLegEnt02 = new DmLoanEntityRelationship();
        dmLegEnt02.Id = 'le2';
        dmLegEnt02.Entity = dmOtherBorrower;
        dmLegEnt02.RelationshipType = 'Other';
        DmLoanCollateralRelationship dmColRel01 = new DmLoanCollateralRelationship();
        dmColRel01.Id = 'cr1';
        dmColRel01.collateral = new DmCollateral();
        DmLoanCollateralRelationship dmColRel02 = new DmLoanCollateralRelationship();
        dmColRel02.Id = 'cr2';
        dmColRel02.collateral = new DmCollateral();        
        
        mockDataProvider.setup('getLoanForceLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legEnt01,codes})
            .returns(dmLegEnt01);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legEnt02,codes})
            .returns(dmLegEnt02);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{colRel01})
            .returns(dmColRel01);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{colRel02})
            .returns(dmColRel02);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert        
        System.assertEquals(2, results.pledgedCollateral.size());
        System.assertEquals(dmColRel01, results.pledgedCollateral[0]);
        System.assertEquals(dmColRel02, results.pledgedCollateral[1]);
        System.assertEquals(false, results.pledgedCollateral[0].isOwnedByPrimaryBorrower);
        System.assertEquals(false, results.pledgedCollateral[1].isOwnedByPrimaryBorrower);
    }

    @IsTest
    static void it_should_call_the_dmhelper_to_build_participation_dms() {
        Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        PM_EB_Loan_Application_c pmLoan = new PM_EB_Loan_Application_c();
        PM_EB_Loan_Participation_c pmPart01 = new PM_EB_Loan_Participation_c();
        pmPart01.Id = '1';
        PM_EB_Loan_Participation_c pmPart02 = new PM_EB_Loan_Participation_c();
        pmPart02.Id = '2';
        pmLoan.EB_Loan_Participations_r = new List<PM_EB_Loan_Participation_c>{pmPart01,pmPart02};
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        
        DmLoan dmLoan = getDmLoan();
        DmParticipation dmPart01 = new DmParticipation();
        dmPart01.Id = 'p1';
        DmParticipation dmPart02 = new DmParticipation();
        dmPart02.Id = 'p2';
        
        mockDataProvider.setup('getLoanForceLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setup('buildParticipation', new List<Object>{pmPart01}).returns(dmPart01);
        mockDmBuilderHelper.setup('buildParticipation', new List<Object>{pmPart02}).returns(dmPart02);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        System.assertEquals(2, results.participations.size());
        System.assertEquals(dmPart01, results.participations[0]);
        System.assertEquals(dmPart02, results.participations[1]);
    }

    private static DmLoan getDmLoan() {
        DmLoan dm = new DmLoan();
        dm.RelatedEntities = new List<DmLoanEntityRelationship>();
        dm.PledgedCollateral = new List<DmLoanCollateralRelationship>();
        dm.Participations = new List<DmParticipation>();
        dm.Memos = new List<DmMemo>();
        dm.PayStreams = new List<DmLoanPaymentStream>();
        dm.RateStreams = new List<DmLoanRateStream>();
        return dm;
    }
}