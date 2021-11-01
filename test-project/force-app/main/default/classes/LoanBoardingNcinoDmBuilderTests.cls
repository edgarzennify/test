@IsTest
private class LoanBoardingNcinoDmBuilderTests {
    
    private static LoanBoardingNcinoDmBuilder sut;
    private static LoanBoardingMock.ofDataProvider mockDataProvider;
    private static LoanBoardingMock.ofDmBuilderHelper mockDmBuilderHelper;

    static {
        mockDataProvider = new LoanBoardingMock.ofDataProvider();
        mockDmBuilderHelper = new LoanBoardingMock.ofDmBuilderHelper();
        sut = new LoanBoardingNcinoDmBuilder(mockDataProvider, mockDmBuilderHelper);
    }
    
    @IsTest
    static void it_should_get_ncino_sobject_type_when_is_type_is_called() {
        SObjectType expectedSO = LLC_BI__Loan__c.SObjectType;
        
        SObjectType result = sut.isType();
        
        System.assertEquals(expectedSO, result);
    }

    @IsTest
    static void it_should_call_the_data_provider_to_get_loan_pms() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        
        DmLoan dmLoan = getDmLoan();
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDataProvider.verify('getnCinoLoan', new List<Object>{loanId}, Times.Once);
        mockDataProvider.verify('getIndustryCodes', Times.Once);
        mockDataProvider.verify('getnCinoPayStreams', new List<Object>{pmLoan.Id}, Times.Once);
        mockDataProvider.verify('getnCinoRateStreams', new List<Object>{pmLoan.Id}, Times.Once);
    }    

    @IsTest
    static void it_should_call_the_dmhelper_to_build_loanEntity_dms() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        PM_LLCBI_Legal_Entities_c legEnt01 = new PM_LLCBI_Legal_Entities_c();
        legEnt01.Id = '1';
        PM_LLCBI_Legal_Entities_c legEnt02 = new PM_LLCBI_Legal_Entities_c();
        legEnt02.Id = '2';
        pmLoan.LLCBI_Legal_Entities_r = new List<PM_LLCBI_Legal_Entities_c>{legEnt01,legEnt02};

        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
       
        DmLoan dmLoan = getDmLoan();
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDmBuilderHelper.verify('buildRelatedEntities', new List<Object>{legEnt01, codes}, Times.Once);
        mockDmBuilderHelper.verify('buildRelatedEntities', new List<Object>{legEnt02, codes}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dmhelper_to_build_pledge_dms() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        PM_LLCBI_Loan_Collateral2_c pledge01 = new PM_LLCBI_Loan_Collateral2_c();
        pledge01.Id = '1';
        PM_LLCBI_Loan_Collateral2_c pledge02 = new PM_LLCBI_Loan_Collateral2_c();
        pledge02.Id = '2';
        pmLoan.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>{pledge01,pledge02};

        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        
        DmLoan dmLoan = getDmLoan();
        DmLoanCollateralRelationship dmPledge01 = new DmLoanCollateralRelationship();
        dmPledge01.Id = '1';
        DmLoanCollateralRelationship dmPledge02 = new DmLoanCollateralRelationship();
        dmPledge01.Id = '2';
        dmLoan.pledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge01,dmPledge02};
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setupSequence('buildPledgedCollateral', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE)
            .returns(dmPledge01)
            .returns(dmPledge02);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDmBuilderHelper.verify('buildPledgedCollateral', new List<Object>{pledge01}, Times.Once);
        mockDmBuilderHelper.verify('buildPledgedCollateral', new List<Object>{pledge02}, Times.Once);
    }


    @IsTest
    static void it_should_call_the_dmhelper_to_build_participation_dms() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        PM_LLCBI_Participation_c pmPart01 = new PM_LLCBI_Participation_c();
        pmPart01.Id = '1';
        PM_LLCBI_Participation_c pmPart02 = new PM_LLCBI_Participation_c();
        pmPart02.Id = '2';
        pmLoan.LLCBI_Participations_r = new List<PM_LLCBI_Participation_c>{pmPart01,pmPart02};

        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        
        DmLoan dmLoan = getDmLoan();
        DmLoanCollateralRelationship dmPledge01 = new DmLoanCollateralRelationship();
        dmPledge01.Id = '1';
        dmLoan.pledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge01};
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDmBuilderHelper.verify('buildParticipation', new List<Object>{pmPart01}, Times.Once);
        mockDmBuilderHelper.verify('buildParticipation', new List<Object>{pmPart02}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dmbuilderhelper_to_build_memos() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        PM_LLCBI_Change_Memo_c memo01 = new PM_LLCBI_Change_Memo_c();
        memo01.Id = '1';
        memo01.LLCBI_Memo_Type_c = 'Change Memo';
        PM_LLCBI_Change_Memo_c memo02 = new PM_LLCBI_Change_Memo_c();
        memo02.Id = '2';
        memo02.LLCBI_Memo_Type_c = 'adfga';
        pmLoan.LLCBI_Change_Memos_r = new List<PM_LLCBI_Change_Memo_c>{memo01,memo02};

        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        
        DmLoan dmLoan = getDmLoan();
        DmLoanCollateralRelationship dmPledge01 = new DmLoanCollateralRelationship();
        dmPledge01.Id = '1';
        dmLoan.pledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge01};
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDmBuilderHelper.verify('buildMemo', new List<Object>{memo01}, Times.Once);
        mockDmBuilderHelper.verify('buildMemo', new List<Object>{memo02}, Times.Never);
    }

    @IsTest
    static void it_should_call_the_dmbuilderhelper_to_build_payStreams(){
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        PM_LLCBI_Pricing_Payment_Component_c payStream01 = new PM_LLCBI_Pricing_Payment_Component_c();
        payStream01.Id = '1';
        PM_LLCBI_Pricing_Payment_Component_c payStream02 = new PM_LLCBI_Pricing_Payment_Component_c();
        payStream02.Id = '2';
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>{payStream01,payStream02};
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        
        DmLoan dmLoan = getDmLoan();
        DmLoanCollateralRelationship dmPledge01 = new DmLoanCollateralRelationship();
        dmPledge01.Id = '1';
        dmLoan.pledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge01};
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDmBuilderHelper.verify('buildPayStream', new List<Object>{payStream01}, Times.Once);
        mockDmBuilderHelper.verify('buildPayStream', new List<Object>{payStream02}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_dmbuilderhelper_to_buildrateStreams(){
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        PM_LLCBI_Pricing_Rate_Component_c rateStream01 = new PM_LLCBI_Pricing_Rate_Component_c();
        rateStream01.Id = '1';
        PM_LLCBI_Pricing_Rate_Component_c rateStream02 = new PM_LLCBI_Pricing_Rate_Component_c();
        rateStream02.Id = '2';
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>{rateStream01,rateStream02};
        
        DmLoan dmLoan = getDmLoan();
        DmLoanCollateralRelationship dmPledge01 = new DmLoanCollateralRelationship();
        dmPledge01.Id = '1';
        dmLoan.pledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge01};
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        mockDmBuilderHelper.verify('buildRateStream', new List<Object>{rateStream01}, Times.Once);
        mockDmBuilderHelper.verify('buildRateStream', new List<Object>{rateStream02}, Times.Once);
    }

    @IsTest
    static void it_should_return_this_dm_loan_when_relationshipType_is_Primary_Owner(){
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        PM_LLCBI_Legal_Entities_c legalEntity = new PM_LLCBI_Legal_Entities_c();
        legalEntity.Id = '1';
        PM_LLCBI_Loan_Collateral2_c pledge = new PM_LLCBI_Loan_Collateral2_c();
        pledge.Id = '1';
        PM_LLCBI_Participation_c participation = new PM_LLCBI_Participation_c();
        participation.Id = '1';
        PM_LLCBI_Change_Memo_c changeMemo = new PM_LLCBI_Change_Memo_c();
        changeMemo.Id = '1';
        changeMemo.LLCBI_Memo_Type_c = 'Change Memo';
        PM_LLCBI_Pricing_Payment_Component_c payStream = new PM_LLCBI_Pricing_Payment_Component_c();
        payStream.Id = '1';
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>{payStream};
        PM_LLCBI_Pricing_Rate_Component_c rateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        rateStream.Id = '1';
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>{rateStream};
        
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.LLCBI_Legal_Entities_r = new List<PM_LLCBI_Legal_Entities_c>{legalEntity};
        pmLoan.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>{pledge};
        pmLoan.LLCBI_Participations_r = new List<PM_LLCBI_Participation_c>{participation};
        pmLoan.LLCBI_Change_Memos_r = new List<PM_LLCBI_Change_Memo_c>{changeMemo};

        DmLoan dmLoan = getDmLoan();
        DmEntity dmEntity = new DmEntity();
        dmEntity.Id = '12';
        DmLoanEntityRelationship dmLegalEntity = new DmLoanEntityRelationship();
        dmLegalEntity.Id = '1';
        dmLegalEntity.RelationshipType = 'Primary Owner';
        dmLegalEntity.Entity = dmEntity;
        dmLoan.relatedEntities.add(dmLegalEntity);
        DmCollateral DmCollateral = new DmCollateral();
        DmCollateral.PrimaryOwner = DmEntity;
        DmLoanCollateralRelationship dmPledge = new DmLoanCollateralRelationship();
        dmPledge.Id = '1';
        dmPledge.Collateral = DmCollateral;
        dmPledge.IsOwnedByPrimaryBorrower = true;
        DmParticipation dmParticipation = new DmParticipation();
        dmParticipation.Id = '1';
        DmMemo dmChangeMemo = new DmMemo();
        dmChangeMemo.Id = '1';
        DmLoanPaymentStream dmPayStream = new DmLoanPaymentStream();
        dmPayStream.Index = 1;
        DmLoanRateStream dmRateStream = new DmLoanRateStream();
        dmRateStream.Index = 1;
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legalEntity, codes})
            .returns(dmLegalEntity);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{pledge})
            .returns(dmPledge);
        mockDmBuilderHelper.setup('buildParticipation', new List<Object>{participation})
            .returns(dmParticipation);
        mockDmBuilderHelper.setup('buildMemo', new List<Object>{changeMemo})
            .returns(dmChangeMemo);
        mockDmBuilderHelper.setup('buildPayStream', new List<Object>{payStream})
            .returns(dmPayStream);
        mockDmBuilderHelper.setup('buildRateStream', new List<Object>{rateStream})
            .returns(dmRateStream);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        System.assertEquals(dmLoan, results);
        System.assertEquals(dmLegalEntity, results.relatedEntities[0]);
        System.assertEquals(true, results.pledgedCollateral[0].IsOwnedByPrimaryBorrower);
        System.assertEquals(dmParticipation, results.participations[0]);
        System.assertEquals(dmChangeMemo, results.memos[0]);
        System.assertEquals(dmPayStream, results.payStreams[0]);
        System.assertEquals(dmRateStream, results.rateStreams[0]);
    }

    @IsTest
    static void it_should_return_this_dm_loan_when_relationshipType_is_Borrower(){
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        PM_LLCBI_Legal_Entities_c legalEntity = new PM_LLCBI_Legal_Entities_c();
        legalEntity.Id = '1';
        PM_LLCBI_Loan_Collateral2_c pledge = new PM_LLCBI_Loan_Collateral2_c();
        pledge.Id = '1';
        PM_LLCBI_Participation_c participation = new PM_LLCBI_Participation_c();
        participation.Id = '1';
        PM_LLCBI_Change_Memo_c changeMemo = new PM_LLCBI_Change_Memo_c();
        changeMemo.Id = '1';
        changeMemo.LLCBI_Memo_Type_c = 'Change Memo';
        PM_LLCBI_Pricing_Payment_Component_c payStream = new PM_LLCBI_Pricing_Payment_Component_c();
        payStream.Id = '1';
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>{payStream};
        PM_LLCBI_Pricing_Rate_Component_c rateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        rateStream.Id = '1';
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>{rateStream};
        
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.LLCBI_Legal_Entities_r = new List<PM_LLCBI_Legal_Entities_c>{legalEntity};
        pmLoan.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>{pledge};
        pmLoan.LLCBI_Participations_r = new List<PM_LLCBI_Participation_c>{participation};
        pmLoan.LLCBI_Change_Memos_r = new List<PM_LLCBI_Change_Memo_c>{changeMemo};

        DmLoan dmLoan = getDmLoan();
        DmEntity dmEntity = new DmEntity();
        dmEntity.Id = '12';
        DmLoanEntityRelationship dmLegalEntity = new DmLoanEntityRelationship();
        dmLegalEntity.Id = '1';
        dmLegalEntity.RelationshipType = 'Borrower';
        dmLegalEntity.Entity = dmEntity;
        dmLoan.relatedEntities.add(dmLegalEntity);
        DmCollateral DmCollateral = new DmCollateral();
        DmCollateral.PrimaryOwner = DmEntity;
        DmLoanCollateralRelationship dmPledge = new DmLoanCollateralRelationship();
        dmPledge.Id = '1';
        dmPledge.Collateral = DmCollateral;
        dmPledge.IsOwnedByPrimaryBorrower = true;
        DmParticipation dmParticipation = new DmParticipation();
        dmParticipation.Id = '1';
        DmMemo dmChangeMemo = new DmMemo();
        dmChangeMemo.Id = '1';
        DmLoanPaymentStream dmPayStream = new DmLoanPaymentStream();
        dmPayStream.Index = 1;
        DmLoanRateStream dmRateStream = new DmLoanRateStream();
        dmRateStream.Index = 1;
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legalEntity, codes})
            .returns(dmLegalEntity);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{pledge})
            .returns(dmPledge);
        mockDmBuilderHelper.setup('buildParticipation', new List<Object>{participation})
            .returns(dmParticipation);
        mockDmBuilderHelper.setup('buildMemo', new List<Object>{changeMemo})
            .returns(dmChangeMemo);
        mockDmBuilderHelper.setup('buildPayStream', new List<Object>{payStream})
            .returns(dmPayStream);
        mockDmBuilderHelper.setup('buildRateStream', new List<Object>{rateStream})
            .returns(dmRateStream);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        System.assertEquals(dmLoan, results);
        System.assertEquals(dmLegalEntity, results.relatedEntities[0]);
        System.assertEquals(true, results.pledgedCollateral[0].IsOwnedByPrimaryBorrower);
        System.assertEquals(dmParticipation, results.participations[0]);
        System.assertEquals(dmChangeMemo, results.memos[0]);
        System.assertEquals(dmPayStream, results.payStreams[0]);
        System.assertEquals(dmRateStream, results.rateStreams[0]);
    }

    @IsTest
    static void it_should_return_this_dm_loan_when_relationshipType_is_Guarantor(){
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        PM_LLCBI_Legal_Entities_c legalEntity = new PM_LLCBI_Legal_Entities_c();
        legalEntity.Id = '1';
        PM_LLCBI_Loan_Collateral2_c pledge = new PM_LLCBI_Loan_Collateral2_c();
        pledge.Id = '1';
        PM_LLCBI_Participation_c participation = new PM_LLCBI_Participation_c();
        participation.Id = '1';
        PM_LLCBI_Change_Memo_c changeMemo = new PM_LLCBI_Change_Memo_c();
        changeMemo.Id = '1';
        changeMemo.LLCBI_Memo_Type_c = 'Change Memo';
        PM_LLCBI_Pricing_Payment_Component_c payStream = new PM_LLCBI_Pricing_Payment_Component_c();
        payStream.Id = '1';
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>{payStream};
        PM_LLCBI_Pricing_Rate_Component_c rateStream = new PM_LLCBI_Pricing_Rate_Component_c();
        rateStream.Id = '1';
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>{rateStream};
        
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.LLCBI_Legal_Entities_r = new List<PM_LLCBI_Legal_Entities_c>{legalEntity};
        pmLoan.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>{pledge};
        pmLoan.LLCBI_Participations_r = new List<PM_LLCBI_Participation_c>{participation};
        pmLoan.LLCBI_Change_Memos_r = new List<PM_LLCBI_Change_Memo_c>{changeMemo};

        DmLoan dmLoan = getDmLoan();
        DmEntity dmEntity = new DmEntity();
        dmEntity.Id = '12';
        DmLoanEntityRelationship dmLegalEntity = new DmLoanEntityRelationship();
        dmLegalEntity.Id = '1';
        dmLegalEntity.RelationshipType = 'Guarantor';
        dmLegalEntity.Entity = dmEntity;
        dmLoan.relatedEntities.add(dmLegalEntity);
        DmCollateral DmCollateral = new DmCollateral();
        DmCollateral.PrimaryOwner = DmEntity;
        DmLoanCollateralRelationship dmPledge = new DmLoanCollateralRelationship();
        dmPledge.Id = '1';
        dmPledge.Collateral = DmCollateral;
        dmPledge.IsOwnedByPrimaryBorrower = true;
        DmParticipation dmParticipation = new DmParticipation();
        dmParticipation.Id = '1';
        DmMemo dmChangeMemo = new DmMemo();
        dmChangeMemo.Id = '1';
        DmLoanPaymentStream dmPayStream = new DmLoanPaymentStream();
        dmPayStream.Index = 1;
        DmLoanRateStream dmRateStream = new DmLoanRateStream();
        dmRateStream.Index = 1;
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        mockDmBuilderHelper.setup('buildRelatedEntities', new List<Object>{legalEntity, codes})
            .returns(dmLegalEntity);
        mockDmBuilderHelper.setup('buildPledgedCollateral', new List<Object>{pledge})
            .returns(dmPledge);
        mockDmBuilderHelper.setup('buildParticipation', new List<Object>{participation})
            .returns(dmParticipation);
        mockDmBuilderHelper.setup('buildMemo', new List<Object>{changeMemo})
            .returns(dmChangeMemo);
        mockDmBuilderHelper.setup('buildPayStream', new List<Object>{payStream})
            .returns(dmPayStream);
        mockDmBuilderHelper.setup('buildRateStream', new List<Object>{rateStream})
            .returns(dmRateStream);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        System.assertEquals(dmLoan, results);
        System.assertEquals(dmLegalEntity, results.relatedEntities[0]);
        System.assertEquals(false, results.pledgedCollateral[0].IsOwnedByPrimaryBorrower);
        System.assertEquals(dmParticipation, results.participations[0]);
        System.assertEquals(dmChangeMemo, results.memos[0]);
        System.assertEquals(dmPayStream, results.payStreams[0]);
        System.assertEquals(dmRateStream, results.rateStreams[0]);
    }

    @IsTest
    static void it_should_return_this_dm_loan_when_related_lists_are_null(){
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        EB_Industry_Code__c code = new EB_Industry_Code__c();
        List<EB_Industry_Code__c> codes = new List<Eb_Industry_Code__c>{code};
        List<PM_LLCBI_Pricing_Payment_Component_c> payStreams = new List<PM_LLCBI_Pricing_Payment_Component_c>();
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = new List<PM_LLCBI_Pricing_Rate_Component_c>();
        
        PM_LLCBI_Loan_c pmLoan = new PM_LLCBI_Loan_c();
        pmLoan.LLCBI_Legal_Entities_r = new List<PM_LLCBI_Legal_Entities_c>();
        pmLoan.LLCBI_Loan_Collateral_r = new List<PM_LLCBI_Loan_Collateral2_c>();
        pmLoan.LLCBI_Participations_r = new List<PM_LLCBI_Participation_c>();
        pmLoan.LLCBI_Change_Memos_r = new List<PM_LLCBI_Change_Memo_c>();

        DmLoan dmLoan = getDmLoan();
        DmEntity dmEntity = new DmEntity();
        dmEntity.Id = '12';
        
        mockDataProvider.setup('getnCinoLoan', new List<Object>{loanId})
            .returns(pmLoan);
        mockDataProvider.setup('getIndustryCodes')
            .returns(codes);
        mockDataProvider.setup('getnCinoPayStreams', new List<Object>{pmLoan.Id})
            .returns(payStreams);
        mockDataProvider.setup('getnCinoRateStreams', new List<Object>{pmLoan.Id})
            .returns(rateStreams);
        mockDmBuilderHelper.setup('buildLoan', new List<Object>{pmLoan})
            .returns(dmLoan);
        //act
        DmLoan results = sut.buildDmLoan(loanId);
        //assert
        System.assertEquals(dmLoan, results);
        System.assertEquals(0, results.relatedEntities.size());
        mockDmBuilderHelper.verify('buildRelatedEntities', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        System.assertEquals(0, results.pledgedCollateral.size());
        mockDmBuilderHelper.verify('buildPledgedCollateral', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        System.assertEquals(0, results.participations.size());
        mockDmBuilderHelper.verify('buildParticipation', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        System.assertEquals(0, results.memos.size());
        mockDmBuilderHelper.verify('buildMemo', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        System.assertEquals(0, results.payStreams.size());
        mockDmBuilderHelper.verify('buildPayStream', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
        System.assertEquals(0, results.rateStreams.size());
        mockDmBuilderHelper.verify('buildRateStream', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Never);
    }

    private static DmLoan getDmLoan(){
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