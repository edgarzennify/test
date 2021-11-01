@IsTest
private class TmBoardingPresenterDecoratorTests {
    
    private static TmBoardingPresenterDecorator sut;
    private static final TmBoardingMock.ofIPresenter mockPresenter;
    private static final Mock.ofIErrorRepository mockError;
    
    static {
        mockPresenter = new TmBoardingMock.ofIPresenter();
        mockError = new Mock.ofIErrorRepository();
        sut = new TmBoardingPresenterDecorator(mockPresenter, mockError);
    }
    
    @IsTest
    static void it_should_decorate_getformvm() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        
        TmBoarding.FormVm result =  sut.getFormVm(record);
        
        mockPresenter.verify('getFormVm', new List<Object>{record}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_getEntityformvm() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        
        TmBoarding.EntityFormVm result =  sut.getEntityFormVm(record);
        
        mockPresenter.verify('getEntityFormVm', new List<Object>{record}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_getformvm_with_errors() {
        TM_Service_Request__c record = new TM_Service_Request__c();
         mockPresenter.setup('getFormVm', new List<Object>{record}).throws(new DecoratorException());
        
        TmBoarding.FormVm result =  sut.getFormVm(record);
        
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void it_should_decorate_form_modal() {
        String contactId = 'test-contact';
        List<String> relatedAccountIds = new List<string>();
        TM_Service_Request__c record = new TM_Service_Request__c();
        
        TmBoarding.FormModalVm result =  sut.buildAccountContacts(contactId, relatedAccountIds, record);
        
         mockPresenter.verify('buildAccountContacts', new List<Object>{contactId, relatedAccountIds, record}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_form_modal_with_errors() {
        String contactId = 'test-contact';
        List<String> relatedAccountIds = new List<string>();
        TM_Service_Request__c record = new TM_Service_Request__c();
        mockPresenter.setup('buildAccountContacts', new List<Object>{contactId, relatedAccountIds, record}).throws(new DecoratorException());
        
        TmBoarding.FormModalVm result =  sut.buildAccountContacts(contactId, relatedAccountIds, record);
        
        System.assertEquals(null, result);
    }

    @IsTest
    static void it_should_decorate_contact_account() {
        Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Id relatedContactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        List<String> relatedContactIds = new List<String>{relatedContactId};
        TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);

        TmBoarding.FormModalVm result = sut.buildContactAccounts( accountId,  relatedContactIds, record);

        mockPresenter.verify('buildContactAccounts', new List<Object>{accountId,  relatedContactIds, record}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_contact_account_with_errors() {
        Id accountId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        Id relatedContactId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
        List<String> relatedContactIds = new List<String>{relatedContactId};
        TM_Service_Request__c record = new TM_Service_Request__c(Id = requestId);
        mockPresenter.setup('buildContactAccounts', new List<Object>{accountId,  relatedContactIds, record}).throws(new DecoratorException());

        TmBoarding.FormModalVm result = sut.buildContactAccounts( accountId,  relatedContactIds, record);

        System.assertEquals(null , result);
    }


    @IsTest
    static void it_should_decorate_new_number_generator_when_key_is_provided() {
        String key = 'tm-boarding-account';

        TmBoarding.AccountGeneratorResult result = sut.generateNewAccountNumber(key);

        mockPresenter.verify('generateNewAccountNumber', new List<Object>{key}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_new_number_generator_with_key_with_errors() {
        String key = 'tm-boarding-account';
        mockPresenter.setup('generateNewAccountNumber', new List<Object>{key}).throws(new DecoratorException());

        TmBoarding.AccountGeneratorResult result = sut.generateNewAccountNumber(key);

        System.assertEquals(null, result);
    }

    @IsTest
    static void it_should_decorate_getvalidations() {
        TmValidator.ValidationRequest req = new TmValidator.ValidationRequest();
        TM_Service_Request__c pm = new TM_Service_Request__c();

        List<TmValidator.ValidationResult> result = sut.getValidations(req, pm);

        mockPresenter.verify('getValidations', new List<Object>{req, pm});
    }

    @IsTest
    static void it_should_decorate_getvalidations_with_errors() {
        TmValidator.ValidationRequest req = new TmValidator.ValidationRequest();
        TM_Service_Request__c pm = new TM_Service_Request__c();
        mockPresenter.setup('getValidations', new List<Object>{req, pm}).throws(new DecoratorException());

        List<TmValidator.ValidationResult> result = sut.getValidations(req, pm);

        System.assertEquals(null , result);
    }

    @IsTest
    static void it_should_decorate_save_request() {
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TM_Service_Request__c record = new TM_Service_Request__c();

        List<string> result = sut.saveRequest( sms, record);

        mockPresenter.verify('saveRequest', new List<Object>{sms , record}, Times.Once);
    }

     @IsTest
    static void it_should_decorate_save_request_with_errors() {
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TM_Service_Request__c record = new TM_Service_Request__c();
        mockPresenter.setup('saveRequest', new List<Object>{sms , record}).throws(new DecoratorException());

        List<string> result = sut.saveRequest( sms, record);

        System.assertEquals(null , result);
    }

    @IsTest
    static void it_should_decorate_save_contact() {
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        Boolean isNew = true;
        TM_Service_Request__c record = new TM_Service_Request__c();

        List<string> result = sut.saveContact( sms, isNew, record);

        mockPresenter.verify('saveContact', new List<object>{sms, isNew, record}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_save_contact_with_errors() {
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        Boolean isNew = true;
        TM_Service_Request__c record = new TM_Service_Request__c();
        mockPresenter.setup('saveContact', new List<object>{sms, isNew, record}).throws(new DecoratorException());

        List<string> result = sut.saveContact( sms, isNew, record);

        System.assertEquals(null, result);
    }

    @IsTest
    static void it_should_decorate_save_account() {
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        Boolean isNew = true ;
        TM_Service_Request__c record = new TM_Service_Request__c();
        TmBoarding.NewAccountDetails newAccount = new TmBoarding.NewAccountDetails();

        List<String> result = sut.saveAccount(sms, isNew, record, newAccount);

        mockPresenter.verify('saveAccount', new List<Object>{sms, isNew, record, newAccount}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_save_account_with_errors() {
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        Boolean isNew = true ;
        TM_Service_Request__c record = new TM_Service_Request__c();
        TmBoarding.NewAccountDetails newAccount = new TmBoarding.NewAccountDetails();
        mockPresenter.setup('saveAccount', new List<Object>{sms, isNew, record, newAccount}).throws(new DecoratorException());

        List<String> result = sut.saveAccount(sms, isNew, record, newAccount);

        System.assertEquals(null, result);
    }

    @IsTest
    static void it_should_decorate_search_results() {
        String param = 'search-text';

        List<TmBoarding.AccountSearchResult> result = sut.getAccountSearchResult('search-text');

        mockPresenter.verify('getAccountSearchResult', new List<Object>{param}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_search_results_with_errors() {
        String param = 'search-text';
        mockPresenter.setup('getAccountSearchResult', new List<Object>{param}).throws(new DecoratorException());

        List<TmBoarding.AccountSearchResult> result = sut.getAccountSearchResult('search-text');

        System.assertEquals(null, result);
    }

    @IsTest
    static void it_should_decorate_validation_by_stage_results() {
        TM_Service_Request__c request = new TM_Service_Request__c();
        List<string> stageIds = new List<string>();

        TmBoarding.ExistingDataValidationVm result =  sut.validateTmRequest(request, stageIds);

        mockPresenter.verify('validateTmRequest', new List<Object>{request, stageIds}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_validation_by_stage_results_with_errors() {
        TM_Service_Request__c request = new TM_Service_Request__c();
        List<string> stageIds = new List<string>();
        mockPresenter.setup('validateTmRequest', new List<Object>{request, stageIds}).throws(new DecoratorException());

        TmBoarding.ExistingDataValidationVm result =  sut.validateTmRequest(request, stageIds);

        System.assertEquals(null, result);
    }

    @IsTest
    static void it_should_decorate_update_stage_method() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        string stageId = 'test-id';

        sut.updateStage(record, stageId);

        mockPresenter.verify('updateStage', new List<Object>{record, stageId}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_update_stage_with_errors() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        string stageId = 'test-id';
        mockPresenter.setup('updateStage', new List<Object>{record, stageId}).throws(new DecoratorException());

        sut.updateStage(record, stageId);
    }

    @IsTest
    static void it_should_decorate_update_stage_for_multiple_tm_requests_method() {
        List<string> tmRequests = new List<string>{ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1')};
        string stageId = 'test-id';

        sut.updateStage(tmRequests, stageId);

        mockPresenter.verify('updateStage', new List<Object>{tmRequests, stageId}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_update_stage_for_multiple_tm_requests_with_errors() {
        List<string> tmRequests = new List<string>{ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1')};
        string stageId = 'test-id';
        mockPresenter.setup('updateStage', new List<Object>{tmRequests, stageId}).throws(new DecoratorException());

        sut.updateStage(tmRequests, stageId);
    }

    @IsTest
    static void it_should_decorate_get_stage_logs_with_errors() {
        TM_Service_Request__c record = new TM_Service_Request__c();
        mockPresenter.setup('getStageLogs', new List<Object>{record}).throws(new DecoratorException());

        sut.getStageLogs(record);
    }

    @IsTest
    static void it_should_decorate_get_all_products_with_errors() {
        mockPresenter.setup('getAllProducts').throws(new DecoratorException());

        List<TmBoarding.NameValue> result = sut.getAllProducts();

    }

    @IsTest
    static void it_should_decorate_the_update_assignees() {
        mockPresenter.setup('updateOpsAssignee').throws(new DecoratorException());

        sut.updateOpsAssignee('', '');
    }
    
    @IsTest
    static void it_should_decorate_tmos(){
        sut.getTmos();
    }

    @IsTest
    static void it_should_decorate_get_stage_notes() {
        Tm_Service_Request__c req = new Tm_service_Request__c();

        string result = sut.getStageNotes(req);

        mockPresenter.verify('getStageNotes', new List<Object>{req}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_save_stage_notes() {
        Tm_Service_Request__c req = new Tm_service_Request__c();
        String notes = '';

        sut.saveStageNotes(req, notes);

        mockPresenter.verify('saveStageNotes', new List<Object>{req, notes}, Times.Once);
    }

    @IsTest
    static void it_should_decorate_validate_by_current_stage() {
        string packetId = '';
        List<string> tmRequests = new List<string>();

        List<TmValidator.ValidationResult> result = sut.validateTmRequestsByCurrentStage(packetId, tmRequests);

        mockPresenter.verify('validateTmRequestsByCurrentStage', new List<Object>{packetId, tmRequests}, Times.Once);
    }
    
    private class DecoratorException extends Exception {}
}