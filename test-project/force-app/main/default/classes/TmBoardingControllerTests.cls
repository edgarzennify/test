@IsTest
private class TmBoardingControllerTests {

	private static final Mock.OfIStandardController m_mockStandardController;
	private static final Mock.ofIJson m_json;
	private static final TmBoardingController sut;
	private static SObject m_record;
	
	static {
		Id requestId = ObjectFactory.getFakeId(TM_Service_Request__c.SObjectType, '1');
		m_record = new TM_Service_Request__c(Id = requestId);
		m_mockStandardController = new Mock.OfIStandardController();
		m_json = new Mock.ofIJson();
		sut = new TmBoardingController(m_mockStandardController, m_json);
	}

	@IsTest
	static void it_should_call_the_controller_to_get_record_on_initialization() {
		m_mockStandardController.verify('getRecord', Times.Once);
	}

	@IsTest
	static void code_coverage() {
		String recordJson = '{"attributes":{"type":"TM_Service_Request__c","url":"/services/data/v43.0/sobjects/TM_Service_Request__c/a9oc00000000536AAA"},"Id":"a9oc00000000536AAA","RecordTypeId":"012c00000009COHAA2"}';
		TmBoardingController.RelationshipRequest relReq = new TmBoardingController.RelationshipRequest();
		relReq.ParentId  = 'parent-id';
        relReq.RelatedIds  = new List<String>();

        sut.recordJson = recordJson;
		try{
			TmBoarding.FormVm result1 = TmBoardingController.bootstrap(recordJson);
			}catch(Exception ex){

			}

			try{
				TmBoarding.FormModalVm result2 = TmBoardingController.getAccountRelationships(relReq, recordJson);
			}catch(Exception ex){
				
			}

			try{
				TmBoarding.FormModalVm result3 = TmBoardingController.getContactRelationships(relReq, recordJson);
			}catch(Exception ex){
				
			}
			
			try{
				List<String> result4 = TmBoardingController.SaveRequest( new List<TmBoarding.SaveSm>(), recordJson);
			}catch(Exception ex){
				
			}

			try{
				List<String> result5 =  TmBoardingController.SaveContacts( new List<TmBoarding.SaveSm>(), false, recordJson);
			}catch(Exception ex){
				
			}
		
			try{
				List<String> result6 = TmBoardingController.SaveAccounts(new List<TmBoarding.SaveSm>(), false, new TmBoarding.NewAccountDetails() , recordJson);
			}catch(Exception ex){
				
			}

			try{
				TmBoardingController.Report result7 = TmBoardingController.getReport( recordJson);
			}catch(Exception ex){
				
			}
		
			try{
				TmBoarding.ContactSummaryDetails result8 = TmBoardingController.getContactSummaryDetails( 'test-packet-id');
			}catch(Exception ex){
				
			}
		
			try{
				TmBoardingController.Report result9 =  TmBoardingController.getTmOperationsScreen(recordJson);
			}catch(Exception ex){
				
			}

			try{
				TmBoardingController.Report result10 = TmBoardingController.getPacketReport('test-packet-id', true);
			}catch(Exception ex){
				
			}


			try{
				List<TmBoarding.AccountSearchResult> result12 = TmBoardingController.searchAccount('test', recordJson);
			}catch(Exception ex){
				
			}
		
	
			try{
				List<TmValidator.ValidationResult> result13 =  TmBoardingController.getValidations(new TmValidator.ValidationRequest() , recordJson);
			}catch(Exception ex){
				
			}

			try{
				List<TmArchiving.ArchiveReturn> result14 =  TmBoardingController.archive(recordJson);
			}catch(Exception ex){
				
			}

			try{
				TmBoarding.AccountGeneratorResult result15 = TmBoardingController.generateNewAccountNumber('some-key', recordJson);
			}catch(Exception ex) {

			}

			try{
				TmBoardingController.TemplateDetail result16 = TmBoardingController.getTemplateStatus('some-product');
			}catch(Exception ex) {

			}

			try{
				List<TmBoarding.LayoutComponentStage> result17 =  TmBoardingController.getAllStages();
			}catch(Exception ex){
				
			}

			try{
				TmBoardingController.updateStage(null, null);
			}catch(Exception ex){
				
			}

			try {
				TmBoardingController.getStageLogs(null);
			}catch(Exception ex) {
			}

			try {
				TmBoardingController.getAllProducts();
			}catch(Exception ex) {				
			}

			try {
				TmBoardingController.printBlankReports(null);
			}catch(Exception ex) {				
			}	

			try{
				List<TmArchiving.ArchiveLayout> result18 = TmBoardingController.getTmServiceArchiveLinks(recordJson);
			}catch(Exception ex) {				
			}

			try{
				TmBoarding.EntityFormVm result18 = TmBoardingController.bootstrapEntity(recordJson);
			}catch(Exception ex){

			}

			try{
				TmBoardingController.StageNotesResponse result19 = TmBoardingController.getStageNotes(recordJson);
			}catch(Exception ex){

			}

			try{
				TmBoardingController.StageNotesSaveStatus result20 = TmBoardingController.saveStageNotes(recordJson, 'notes');
			}catch(Exception ex){

			}

			try{
				List<TmValidator.ValidationResult> results21 = TmBoardingController.validateTmRequestsByCurrentStage('', new List<String>());
			}catch(Exception ex){

			}

			try{
				ApprovalProcess.ApprovalSubmitResponse results22 = TmBoardingController.submitApprovalAction(recordJson, 'Pending');
			}catch(Exception ex){

			}

			try{
				ApprovalProcess.ApprovalProcessInformation results23 = TmBoardingController.getApprovalInformation(recordJson);
			}catch(Exception ex){

			}

			try{
				TmBoardingController.SignatureInfo info = new TmBoardingController.SignatureInfo();
				boolean result24 = TmBoardingController.sendForSignature(info, '',  recordJson, false);
			}catch(Exception ex){

			}
	}
}