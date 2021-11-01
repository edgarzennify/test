@IsTest
private class LoanDocPrepControllerTests {

    private static final LoanDocPrepController sut;
    private static final Mock.ofIApexPages mockApexPages;
    private static final LoanDocPrepMock.MockOfIPresenter mockPresenter;

    static {
    	mockApexPages = new Mock.ofIApexPages();
    	mockPresenter = new LoanDocPrepMock.MockOfIPresenter();
        sut = new LoanDocPrepController(mockPresenter, mockApexPages);
    }

    @IsTest
    static void it_should_call_the_init() {
    	Id paramId = ObjectFactory.getFakeId(LLC_Bi__Loan__c.SObjectType, '1');
    	mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(paramId);

    	sut.initialize();

    	mockPresenter.verify('trialExport', new List<Object>{paramId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_presenter_to_generate_export_file() {
    	Id paramId = ObjectFactory.getFakeId(LLC_Bi__Loan__c.SObjectType, '1');
    	LoanDocPrep.GenerateResponseVm response = new LoanDocPrep.GenerateResponseVm();
    	response.Status = 'Success';
    	mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(paramId);
    	mockPresenter.setup('generateExportFile', new List<Object>{paramId}).returns(response);
    	
    	sut.generate();

    	mockPresenter.verify('generateExportFile', new List<Object>{paramId}, Times.Once);
    }

    @IsTest
    static void it_should_return_a_url_when_cancel_is_called() {
    	Id loanId = ObjectFactory.getFakeId(LLC_Bi__Loan__c.SObjectType, '1');
    	mockApexPages.setup('getParameter', new List<Object>{'id'}).returns(loanId);

    	PageReference result = sut.cancel();

    	system.assertEquals('/' + loanId , result.getUrl());
    }

    @IsTest
    static void it_should_call_the_default_controller() {
    	LoanDocPrepController sutDefault = new LoanDocPrepController();
    }
}