@IsTest
public class LoanDocPrepPresenterTests {
	
	private static final LoanDocPrepPresenter sut;
    private static final LoanDocPrepMock.MockOfIDataProvider mockDataProvider;
    private static final LaserProTransformerMock.MockOfIService mockLpService;
    private static final LoanDocPrepMock.MockOfIDmBuilder mockDmBuilder;

    static {
    	mockDataProvider = new LoanDocPrepMock.MockOfIDataProvider();
    	mockLpService = new LaserProTransformerMock.MockOfIService();
    	mockDmBuilder = new LoanDocPrepMock.MockOfIDmBuilder();
        sut = new LoanDocPrepPresenter(mockDataProvider, mockLpService, mockDmBuilder);
    }

    @IsTest
    static void it_should_call_the_service_to_get_trial_export_when_renewal() {
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
    	LaserProTransformer.LpLoan lpLoan = new LaserProTransformer.LpLoan();
    	LaserProTransformer.LpEntity lpEntity1 = new LaserProTransformer.LpEntity();
    	lpEntity1.ExcludeFromExtract = false;
    	LaserProTransformer.LpEntity lpEntity2 = new LaserProTransformer.LpEntity();
    	lpEntity2.ExcludeFromExtract = true;
    	lpLoan.Entities = new List<LaserProTransformer.LpEntity>{lpEntity1,lpEntity2};
    	DmLoan dm = new DmLoan();
    	dm.id = loan.Id;
    	dm.isRenewal = true;
    	dm.isModification = false;
    	mockdmBuilder.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dm);
    	mocklpService.setup('trialExport', new List<Object>{dm}).returns(lpLoan);

    	sut.trialExport(loan.Id);

    	mocklpService.verify('trialExport', new List<Object>{dm}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_service_to_get_trial_export_when_modification() {
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
    	LaserProTransformer.LpLoan lpLoan = new LaserProTransformer.LpLoan();
    	DmLoan dm = new DmLoan();
    	dm.id = loan.Id;
    	dm.isRenewal = false;
    	dm.isModification = true;
    	mockdmBuilder.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dm);
    	mocklpService.setup('trialExport', new List<Object>{dm}).returns(lpLoan);

    	sut.trialExport(loan.Id);

    	mocklpService.verify('trialExport', new List<Object>{dm}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_service_to_get_export_file() {
    	LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
    	insert loan;
    	LaserProTransformer.ExportResponse exportResponse = new LaserProTransformer.ExportResponse();
    	exportResponse.Status = 'OK';
    	DmLoan dm = new DmLoan();
    	dm.id = loan.Id;
    	dm.isRenewal = true;
    	dm.isModification = false;
    	mockdmBuilder.setup('build', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dm);
    	mocklpService.setup('export', new List<Object>{dm}).returns(exportResponse);

    	sut.generateExportFile(loan.Id);

    	mocklpService.verify('export', new List<Object>{dm}, Times.Once);
    }
}