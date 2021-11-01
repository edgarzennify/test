@IsTest
public class LoanBoardingVmBuilderTests {

    private static final LoanBoardingMock.ofVmBuilderHelper mockVmBuilderHelper;
    private static final LoanBoardingVmBuilder sut;

    static{
        mockVmBuilderHelper = new LoanBoardingMock.ofVmBuilderHelper();
        sut = new LoanBoardingVmBuilder(mockVmBuilderHelper);
    }

    @IsTest
    static void it_should_return_this_vmLoan_when_given_this_dmLoan() {
        DmLoan dmLoan = buildTestDmLoan();
        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        vmLoan.Id = 'loan-Id';
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        System.assertEquals('loan-Id', results.Loan.Id);
    }

    @IsTest
    static void it_should_return_these_vmCustomerRelationships_in_this_order() {
        DmLoanEntityRelationship dmRel01 = new DmLoanEntityRelationship();
        dmRel01.Id = '1';
        DmLoanEntityRelationship dmRel02 = new DmLoanEntityRelationship();
        dmRel02.Id = '2';
        DmLoan dmLoan = buildTestDmLoan();
        dmLoan.RelatedEntities = new List<DmLoanEntityRelationship>{dmRel01,dmRel02};
        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        mockVmBuilderHelper.verify('buildAccountToCustomerRelationship', new List<Object>{dmRel01}, Times.Once);
        mockVmBuilderHelper.verify('buildAccountToCustomerRelationship', new List<Object>{dmRel02}, Times.Once);
        //TODO: need a set here to verify the list sort method was called.
    }

    @IsTest
    static void it_should_return_these_collateralVms_when_given_these_dms() {
        DmLoanCollateralRelationship dmPledge01 = new DmLoanCollateralRelationship();
        dmPledge01.IsPrimary = true;
        DmLoanCollateralRelationship dmPledge02 = new DmLoanCollateralRelationship();
        dmPledge02.IsPrimary = false;
        DmLoan dmLoan = buildTestDmLoan();
        dmLoan.PledgedCollateral = new List<DmLoanCollateralRelationship>{dmPledge01,dmPledge02};

        LoanBoarding.CollateralVm vmCol01 = new LoanBoarding.CollateralVm();
        vmCol01.IsPrimary = true;
        LoanBoarding.CollateralVm vmCol02 = new LoanBoarding.CollateralVm();
        vmCol02.IsPrimary = false;

        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        mockVmBuilderHelper.setup('buildVmCollateral', new List<Object>{dmPledge01}).returns(vmCol01);
        mockVmBuilderHelper.setup('buildVmCollateral', new List<Object>{dmPledge02}).returns(vmCol02);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        System.assertEquals(true, results.BorrowerCollateral[0].IsPrimary);
        System.assertEquals(false, results.OtherCollateral[0].IsPrimary);
    }

    @IsTest
    static void it_should_return_these_participationVms_when_given_these_dms() {
        DmParticipation dmPart01 = new DmParticipation();
        dmPart01.Bank = '1';
        DmParticipation dmPart02 = new DmParticipation();
        dmPart02.Bank = '2';
        DmLoan dmLoan = buildTestDmLoan();
        dmLoan.Participations = new List<DmParticipation>{dmPart01,dmPart02};

        LoanBoarding.ParticipationVm vmPart01 = new LoanBoarding.ParticipationVm();
        vmPart01.Bank = '1';
        LoanBoarding.ParticipationVm vmPart02 = new LoanBoarding.ParticipationVm();
        vmPart02.Bank = '2';

        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        mockVmBuilderHelper.setup('buildVmParticipation', new List<Object>{dmPart01}).returns(vmPart01);
        mockVmBuilderHelper.setup('buildVmParticipation', new List<Object>{dmPart02}).returns(vmPart02);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        System.assertEquals('1', results.Participations[0].Bank);
        System.assertEquals('2', results.Participations[1].Bank);
    }

    @IsTest
    static void it_should_return_these_memoVms_when_given_these_dms() {
        DmMemo dmMemo01 = new DmMemo();
        dmMemo01.Changes = '1';
        DmMemo dmMemo02 = new DmMemo();
        dmMemo02.Changes = '2';
        DmLoan dmLoan = buildTestDmLoan();
        dmLoan.Memos = new List<DmMemo>{dmMemo01,dmMemo02};

        LoanBoarding.MemoVm vmMemo01 = new LoanBoarding.MemoVm();
        vmMemo01.Changes = '1';
        LoanBoarding.MemoVm vmMemo02 = new LoanBoarding.MemoVm();
        vmMemo02.Changes = '2';

        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        mockVmBuilderHelper.setup('buildVmMemo', new List<Object>{dmMemo01}).returns(vmMemo01);
        mockVmBuilderHelper.setup('buildVmMemo', new List<Object>{dmMemo02}).returns(vmMemo02);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        System.assertEquals('1', results.ChangeMemos[0].Changes);
        System.assertEquals('2', results.ChangeMemos[1].Changes);
    }

    @IsTest
    static void it_should_return_these_LoanPaymentStreamVms_when_given_these_dms() {
        DmLoanPaymentStream dmStream01 = new DmLoanPaymentStream();
        dmStream01.Index = 1;
        DmLoanPaymentStream dmStream02 = new DmLoanPaymentStream();
        dmStream02.Index = 2;
        DmLoan dmLoan = buildTestDmLoan();
        dmLoan.PayStreams = new List<DmLoanPaymentStream>{dmStream01,dmStream02};

        LoanBoarding.LoanPaymentStreamVm vmStream01 = new LoanBoarding.LoanPaymentStreamVm();
        vmStream01.Index = 1;
        LoanBoarding.LoanPaymentStreamVm vmStream02 = new LoanBoarding.LoanPaymentStreamVm();
        vmStream02.Index = 2;

        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        mockVmBuilderHelper.setup('buildVmPayStream', new List<Object>{dmStream01}).returns(vmStream01);
        mockVmBuilderHelper.setup('buildVmPayStream', new List<Object>{dmStream02}).returns(vmStream02);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        System.assertEquals(1, results.PayStreams[0].Index);
        System.assertEquals(2, results.PayStreams[1].Index);
    }

    @IsTest
    static void it_should_return_these_LoanRateStreamVms_when_given_these_dms() {
        DmLoanRateStream dmStream01 = new DmLoanRateStream();
        dmStream01.Index = 1;
        DmLoanRateStream dmStream02 = new DmLoanRateStream();
        dmStream02.Index = 2;
        DmLoan dmLoan = buildTestDmLoan();
        dmLoan.RateStreams = new List<DmLoanRateStream>{dmStream01,dmStream02};

        LoanBoarding.LoanRateStreamVm vmStream01 = new LoanBoarding.LoanRateStreamVm();
        vmStream01.Index = 1;
        LoanBoarding.LoanRateStreamVm vmStream02 = new LoanBoarding.LoanRateStreamVm();
        vmStream02.Index = 2;

        LoanBoarding.LoanVm vmLoan = new LoanBoarding.LoanVm();
        mockVmBuilderHelper.setup('buildVmLoan', new List<Object>{dmLoan}).returns(vmLoan);
        mockVmBuilderHelper.setup('buildVmRateStream', new List<Object>{dmStream01}).returns(vmStream01);
        mockVmBuilderHelper.setup('buildVmRateStream', new List<Object>{dmStream02}).returns(vmStream02);
        //act
        LoanBoarding.FormVm results = sut.buildFormVm(dmLoan);
        //assert
        System.assertEquals(1, results.RateStreams[0].Index);
        System.assertEquals(2, results.RateStreams[1].Index);
    }

    private static DmLoan buildTestDmLoan() { //TODO: clean this up, don't need all the field assignments here
        DmLoan dm = new DmLoan();
        dm.Unit = new DmUnit();
        dm.OriginationOfficer = new DmUser(); 
        dm.ServicingOfficer = new DmUser();
        dm.CreatedBy = new DmUser();
        dm.LoanCoordinator = new DmUser();
        dm.RelatedEntities = new List<DmLoanEntityRelationship>();
        dm.PledgedCollateral = new List<DmLoanCollateralRelationship>();
        dm.Participations = new List<DmParticipation>();
        dm.Memos = new List<DmMemo>();
        dm.Fees = new List<DmFee>();
        dm.PayStreams = new List<DmLoanPaymentStream>();
        dm.RateStreams = new List<DmLoanRateStream>();
        
        return dm;
    }
}