@IsTest
private class CreditRelationshipControllerTests {

	private static SObject record;
	private static final Mock.ofIStandardController mockStandardController;
	private static final MockofICreditRelationshipService mockService;
	private static final CreditRelationshipController sut;

	static {
		mockStandardController = new Mock.ofIStandardController();
		mockService = new MockofICreditRelationshipService();
		record = (SObject) new Credit_Relationship__c();
		mockStandardController.setup('getRecord').returns(record);
		sut = new CreditRelationshipController(mockStandardController , mockService);
		sut.selectedRelatedEntityId = '000000000001';
		sut.selectedPossibleRelatedEntityId = '000000000';
		sut.selectedExcludedAccountId = '0000003';
		sut.selectedRelatedAccountId = '00000005';
		sut.selectedNoteId = '00000006';
	}

	@IsTest
    static void it_should_call_the_controller_to_get_a_record_and_pass_it_to_the_service_to_get_vm() {
		CreditRelationship.CreditRelationshipVm testVm = new CreditRelationship.CreditRelationshipVm();
		testVm.minutes = new List<CreditRelationship.NoteVm>();
		mockService.setup('getCreditRelationshipViewModel', new List<Object>{record.Id}).returns(testVm);

		CreditRelationship.CreditRelationshipVm result = sut.vm;

		mockStandardController.verify('getRecord', Times.Once);
		mockService.verify('getCreditRelationshipViewModel', new List<Object>{record.Id}, Times.Once);
		system.assertEquals(testVm.minutes, result.minutes);
	}

	@IsTest
    static void it_should_call_the_controller_to_get_a_record_and_pass_it_to_the_service_to_save_archiveReport() {
		CreditRelationship.CreditRelationshipVm testVm = new CreditRelationship.CreditRelationshipVm();
		testVm.minutes = new List<CreditRelationship.NoteVm>();
		mockService.setup('addArchivedReport', new List<Object>{record.Id}).returns(testVm);

		sut.saveReport();

		mockStandardController.verify('getRecord');
		mockService.verify('addArchivedReport', new List<Object>{record.Id}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_controller_to_get_a_record_and_pass_it_to_the_service_to_get_reportUrl() {
		String url = 'test.com';
		mockService.setup('getReportUrl', new List<Object>{record.Id}).returns(url);

		String result = sut.reportUrl;

		mockStandardController.verify('getRecord', Times.Once);
		mockService.verify('getReportUrl', new List<Object>{record.Id}, Times.Once);
		system.assertEquals(url, result);
	}

	@IsTest
    static void it_should_call_the_service_to_delete_related_entity_when_the_selectedentity_is_set() {
		PageReference pg = sut.deleteRelatedEntity();

		mockService.verify('deleteRelatedEntity', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = (List<Object>)mockService.getArgumentsFromCall('deleteRelatedEntity');
		String calledSelectedEntityId = String.valueof(arguments[0]);
		system.assertEquals(sut.selectedRelatedEntityId, calledSelectedEntityId);
		system.assertEquals( true , pg.getUrl().contains('apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_call_the_service_to_add_entityrelationship() {
		PageReference pg  = sut.addEntityToRelationship();

		mockService.verify('addRelatedEntity', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = (List<Object>)mockService.getArgumentsFromCall('addRelatedEntity');
		CreditRelationship.RelatedEntitySm calloutSm = (CreditRelationship.RelatedEntitySm) arguments[0];
		system.assertEquals(sut.selectedPossibleRelatedEntityId, calloutSm.entityId);
		system.assertEquals(record.Id, calloutSm.creditRelationshipId);
		system.assertEquals( true , pg.getUrl().contains('apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_call_the_service_to_delete_an_excluded_account_when_selectedexcludedaccount_is_set() {
		PageReference pg = sut.deleteAccountExclusion();

		mockService.verify('deleteExcludedEbAccount', new List<Object>{sut.selectedExcludedAccountId}, Times.Once);
		system.assertEquals( true , pg.getUrl().contains('apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_call_the_service_to_add_excluded_account_when_selectedrelatedaccountid_is_set() {
		PageReference pg  = sut.excludeRelatedAccount();

		mockService.verify('addExcludedAccount', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = (List<Object>)mockService.getArgumentsFromCall('addExcludedAccount');
		CreditRelationship.ExcludedAccountSm calloutSm = (CreditRelationship.ExcludedAccountSm) arguments[0];
		system.assertEquals(sut.selectedRelatedAccountId, calloutSm.accountId);
		system.assertEquals(record.Id, calloutSm.creditRelationshipId);
		system.assertEquals( true , pg.getUrl().contains('apex/CreditRelationships?id='));

	}

	@IsTest
    static void it_should_call_the_service_to_add_excluded_account_when_selected_related_account_id_is_set() {
		sut.excludeRelatedAccount();

		mockService.verify('addExcludedAccount', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
		List<Object> arguments = (List<Object>)mockService.getArgumentsFromCall('addExcludedAccount');
		CreditRelationship.ExcludedAccountSm calloutSm = (CreditRelationship.ExcludedAccountSm) arguments[0];
		system.assertEquals(sut.selectedRelatedAccountId, calloutSm.accountId);
		system.assertEquals(record.id, calloutSm.creditRelationshipId);
	}

	private static testMethod  void it_should_set_the_analysis_diary_rendered_to_true_when_newanalysis_is_called() {
		PageReference result = sut.NewAnalysis();

		system.assertEquals('true', sut.AnalysisDiaryRendered);
		system.assertEquals(null, result);
	}

	@IsTest
    static void it_should_call_the_standard_controllor_and_create_the_new_related_entity_url_when_newCreditRelationshipRelatedClient_is_called() {
		String expectedUrl = '/a1J/e?CF00N30000007h4av=CrRel000000&CF00N30000007h4av_lkid=null&core.apexpages.devmode.url=1&retURL=%2Fapex%2FCreditRelationships%3Fid%3Dnull&sfdc.override=1';

		PageReference result = sut.NewCreditRelationshipRelatedClient();

		system.assertEquals(expectedUrl , result.getUrl());
	}

	@IsTest
    static void it_should_set_the_minute_diary_rendered_to_true_when_new_minute_is_called() {
		PageReference result = sut.NewMinute();

		system.assertEquals( 'true' , sut.minuteDiaryRendered);
		system.assertEquals(null, result );
	}

	@IsTest
    static void it_should_reset_the_minute_diary_and_analysis_diary_rendered_when_reset_diary_panel_is_called() {
		sut.resetDiaryPanel();

		system.assertEquals('false' , sut.minuteDiaryRendered);
		system.assertEquals('false' , sut.analysisDiaryRendered);
	}

	@IsTest
    static void it_should_call_the_service_to_save_a_minute() {
		CreditRelationship.NoteSm sm = new CreditRelationship.NoteSm();
		sut.noteSm = sm;

		PageReference result = sut.saveMinute();

		mockService.verify('addNote', new List<Object>{sm}, Times.Once);
		system.assertEquals(true, result.getUrl().contains('/apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_call_the_sevice_to_save_an_analysis() {
		CreditRelationship.NoteSm sm = new CreditRelationship.NoteSm();
		sut.noteSm = sm;

		PageReference result = sut.saveAnalysis();

		mockService.verify('addNote', new List<Object>{sm}, Times.Once);
		system.assertEquals(true, result.getUrl().contains('/apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_reset_diary_panel_when_cancel_record_is_called() {
		PageReference result = sut.cancelRecord();

		system.assertEquals('false', sut.AnalysisDiaryRendered);
		system.assertEquals('false' , sut.MinuteDiaryRendered);
		system.assertEquals(true , result.getUrl().contains('/apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_call_the_service_when_delete_note_is_called() {
		PageReference result = sut.deleteNote();

		mockService.verify('deleteNote', new List<Object>{sut.selectedNoteId}, Times.Once);
		system.assertEquals(true , result.getUrl().contains('/apex/CreditRelationships?id='));
	}

	@IsTest
    static void it_should_call_the_service_to_verify_if_user_has_admin_permission() {
		Boolean result = sut.hasPermissionAdmin;

		mockService.verify('hasPermissionAdmin', Times.Once);
	}

	@IsTest
    static void it_should_call_the_service_to_verify_if_user_has_edit_permission() {
		Boolean result = sut.hasPermissionToEdit;

		mockService.verify('hasPermissionToEdit', Times.Once);
	}

	@IsTest
    static void it_should_call_the_service_to_verify_if_user_has_view_permission() {
		Boolean result = sut.hasPermissionToView;

		mockService.verify('hasPermissionToView', Times.Once);
	}

	@IsTest
    static void it_should_call_the_service_to_verify_if_user_has_permission() {
		mockService.setup('hasPermissionAdmin').returns(true);

		Boolean result = sut.hasPermission;

		mockService.verify('hasPermissionAdmin', Times.Once);
		system.assertEquals(true, result);
	}

	@IsTest
    static void it_should_do_an_integration_test_by_calling_the_production_constructor() {
		Credit_Relationship__c ctrl = new Credit_Relationship__c();
		PageReference pr = Page.CreditRelationships;
        test.setCurrentPage(pr);       
        ApexPages.currentPage().getParameters().put('Id', ctrl.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(ctrl);

        CreditRelationshipController result  = new CreditRelationshipController(sc);    
	}

	public class MockofICreditRelationshipService extends ApexMoq implements CreditRelationship.ICreditRelationshipService {
		public CreditRelationship.CreditRelationshipVm getCreditRelationshipViewModel(String creditRelationshipId){
			return (CreditRelationship.CreditRelationshipVm)handleMethodInvocation('getCreditRelationshipViewModel', new List<Object>{creditRelationshipId});
		}
		public void addArchivedReport(String creditRelationshipId){
			handleMethodInvocation('addArchivedReport', new List<Object>{creditRelationshipId});
		}
		public void addRelatedEntity(CreditRelationship.RelatedEntitySm sm){
			handleMethodInvocation('addRelatedEntity', new List<Object>{sm});
		}
		public void addExcludedAccount(CreditRelationship.ExcludedAccountSm sm){
			handleMethodInvocation('addExcludedAccount', new List<Object>{sm});
		}
		public void addNote(CreditRelationship.NoteSm sm){
			handleMethodInvocation('addNote', new List<Object>{sm});
		}
		public void deleteRelatedEntity(String recordId){
			handleMethodInvocation('deleteRelatedEntity', new List<Object>{recordId});
		}
		public void deleteExcludedEbAccount(String recordId){
			handleMethodInvocation('deleteExcludedEbAccount', new List<Object>{recordId});
		}
		public void deleteNote(String recordId){
			handleMethodInvocation('deleteNote', new List<Object>{recordId});
		}
		public String getReportUrl(String creditRelationshipId){
			return (String)handleMethodInvocation('getReportUrl', new List<Object>{creditRelationshipId});
		}
		public Boolean hasPermissionAdmin(){
			return (Boolean)handleMethodInvocation('hasPermissionAdmin');
		}
		public Boolean hasPermissionToEdit(){
			return (Boolean)handleMethodInvocation('hasPermissionToEdit');
		}
		public Boolean hasPermissionToView(){
			return (Boolean)handleMethodInvocation('hasPermissionToView');
		}
	}
}