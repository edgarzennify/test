@IsTest
public class CreditRelationshipServiceTests {

    private static String OREO_RECORD_TYPE_NAME = 'Credit Relationship OREO';
    private static String MINUTE_RECORD_TYPE_NAME ='Minute';
	private static final MockofICreditRelationshipVmBuilder m_mockOfVMBuilder;
	private static final MockofICreditRelationshipData m_mockOfDataProvider;
	private static final MockofICreditRelationshipReportManager m_reportManager;
	private static final Mock.ofIReportUrlProvider m_mockOfReportUrlProvider;
	private static final Mock.ofIUserInfoService m_mockOfUserInfoService;
	private static final CreditRelationshipService sut;

	static{
		m_mockOfVMBuilder = new MockofICreditRelationshipVmBuilder();
		m_mockOfDataProvider = new MockofICreditRelationshipData();
		m_reportManager = new MockofICreditRelationshipReportManager();
		m_mockOfReportUrlProvider = new Mock.ofIReportUrlProvider();
		m_mockOfUserInfoService = new Mock.ofIUserInfoService();
		sut = new CreditRelationshipService(
			m_mockOfVMBuilder
			,m_mockOfDataProvider
			,m_reportManager
			,m_mockOfReportUrlProvider
			,m_mockOfUserInfoService
		);
	}
    
    @IsTest
    static void it_should_get_the_view_model_when_creditrelationshipid_is_provided() {
        String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
        DmCreditRelationship dmCreditRelationship = new DmCreditRelationship();
        dmCreditRelationship.id = creditRelationshipId;
        dmCreditRelationship.recordType = DmRecordTypeBy(OREO_RECORD_TYPE_NAME);
        DmCreditRelationshipRelatedEntity related = new DmCreditRelationshipRelatedEntity();
        dmCreditRelationship.relatedEntities = new List<DmCreditRelationshipRelatedEntity>{related};
        DmArchivedReport dmReport = new DmArchivedReport();
        List<DmArchivedReport> dmReports = new List<DmArchivedReport>{dmReport};
        dmCreditRelationship.archivedReports = dmReports;
        DmEbAccount dmRelatedEbAccount = new DmEbAccount();
        List<DmEbAccount> dmRelatedEbAccounts = new List<DmEbAccount>{dmRelatedEbAccount};
        DmCreditRelationshipExcludedAccount dmAccountExcluded = new DmCreditRelationshipExcludedAccount();
        List<DmCreditRelationshipExcludedAccount> dmExcludedAccounts = new List<DmCreditRelationshipExcludedAccount>{dmAccountExcluded};
        DmCreditRelationshipRelatedEntity dmEntityExcluded = new DmCreditRelationshipRelatedEntity();
        List<DmCreditRelationshipRelatedEntity> dmEntityExcludes = new List<DmCreditRelationshipRelatedEntity>{dmEntityExcluded};
        dmCreditRelationship.excludedAccounts = dmExcludedAccounts;
        DmEntity dmEntity = new DmEntity();
        List<DmEntity> dmPossibleEntities = new List<DmEntity>{dmEntity};
        List<DmEntity> dmRelatedEntities = new List<DmEntity>{dmEntity};
        List<DmEntity> dmExcludedEntities = new List<DmEntity>{dmEntity};
        dmCreditRelationship.excludedAccounts = dmExcludedAccounts;
        dmCreditRelationship.relatedEntities = dmEntityExcludes;
        DmCreditRelationshipNote note = new DmCreditRelationshipNote();
        note.recordType = DmRecordTypeBy(MINUTE_RECORD_TYPE_NAME);
        List<DmCreditRelationshipNote> notes = new List<DmCreditRelationshipNote>{note};
        dmCreditRelationship.notes = notes;

        CreditRelationship.CreditRelationshipVm vm = new CreditRelationship.CreditRelationshipVm();
        vm.archivedReports = new List<CreditRelationship.ArchivedReportVm>();
        vm.relatedEntities = new List<CreditRelationship.RelatedEntityVm>();
        vm.relatedAccounts = new List<CreditRelationship.RelatedAccountVm>();
        vm.excludedAccounts = new List<CreditRelationship.ExcludedAccountVm>();
        vm.possibleRelatedEntities = new List<CreditRelationship.PossibleRelatedEntityVm>();
        vm.minutes = new List<CreditRelationship.NoteVm>();
        vm.situationAnalysis = new List<CreditRelationship.NoteVm>();

        m_mockOfDataProvider.setup('getCreditRelationshipById', new List<Object>{creditRelationshipId}).returns(dmCreditRelationship);
        m_mockOfDataProvider.setup('getRelatedAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(dmRelatedEbAccounts);
        m_mockOfDataProvider.setup('getPossibleRelatedEntities', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(dmPossibleEntities);
      
        m_mockOfVMBuilder.setup('buildArchivedReportVms', new List<Object>{dmReports}).returns(vm.archivedReports);
        m_mockOfVMBuilder.setup('buildRelatedEntityVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(vm.relatedEntities);
        m_mockOfVMBuilder.setup('buildRelatedAccountVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(vm.relatedAccounts);
        m_mockOfVMBuilder.setup('buildExcludedAccountVms', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(vm.excludedAccounts);
        m_mockOfVMBuilder.setup('buildPossibleRelatedEntityVms', new List<Object>{dmPossibleEntities}).returns(vm.possibleRelatedEntities);
        m_mockOfVMBuilder.setup('buildNoteVms', new List<Object>{notes}).returns(vm.minutes);

        sut.getCreditRelationshipViewModel(creditRelationshipId);

        m_mockOfDataProvider.verify('getCreditRelationshipById', new List<Object>{creditRelationshipId}, Times.Once);
        m_mockOfDataProvider.verify('getRelatedAccounts', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfDataProvider.verify('getPossibleRelatedEntities', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
      
        m_mockOfVMBuilder.verify('buildArchivedReportVms', new List<Object>{dmReports}, Times.Once);
        m_mockOfVMBuilder.verify('buildRelatedEntityVms',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfVMBuilder.verify('buildRelatedAccountVms', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfVMBuilder.verify('buildExcludedAccountVms',  ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfVMBuilder.verify('buildPossibleRelatedEntityVms', new List<Object>{dmPossibleEntities}, Times.Once);
        m_mockOfVMBuilder.verify('buildNoteVms', new List<Object>{notes}, Times.Once);
    }

    @IsTest
    static void it_should_add_an_archived_report_by_calling_the_dataProvider_when_a_creditrelationshipid_is_passed() {
    	String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
    	String archivedReportId =  ObjectFactory.getFakeId(Archived_Report__c.SObjectType, '1');
    	String noteId =  ObjectFactory.getFakeId(Credit_Relationship_note__c.SObjectType, '1');
    	String reportName = 'Watch Credit OREO Report';
    	Boolean isOreo = true;
    	DmCreditRelationship dmCreditRelationship = new DmCreditRelationship();
    	dmCreditRelationship.id = creditRelationshipId;
    	dmCreditRelationship.RecordType = DmRecordTypeBy('Credit Relationship OREO');
        DmCreditRelationshipExcludedAccount dmExcluded = new DmCreditRelationshipExcludedAccount();
        dmExcluded.ebAccount = new DmEbAccount();
        dmExcluded.ebAccount.id = '1111111';
        dmCreditRelationship.excludedAccounts = new List<DmCreditRelationshipExcludedAccount>{dmExcluded};
    	DmCreditRelationshipNote note = new DmCreditRelationshipNote();
    	note.id = noteId;
    	note.creditRelationship = new DmCreditRelationship();
    	note.creditRelationship.id = creditRelationshipId;
    	note.RecordType = DmRecordTypeBy('Analysis');
    	note.situationFlag = false;
    	dmCreditRelationship.notes = new List<DmCreditRelationshipNote>{note};
    	CreditRelationship.ArchivedReportSm reportSm = new CreditRelationship.ArchivedReportSm();
    	reportSm.name = reportName;
    	reportSm.creditRelationshipId = creditRelationshipId;
    	DmArchivedReport reportDm = new DmArchivedReport();
    	reportDm.name = reportName;
    	reportDm.creditRelationship = new DmCreditRelationship();
    	reportDm.creditRelationship.Id = creditRelationshipId;
    	List<String> noteIds = new List<String>{noteId};

    	m_mockOfDataProvider.Setup('getCreditRelationshipById' , new List<Object>{creditRelationshipId}).returns(dmCreditRelationship);
    	m_mockOfDataProvider.Setup('addArchivedReport', new List<Object>{reportSm}).returns(archivedReportId);
    	m_reportManager.Setup('buildArchivedReportSm', new List<Object>{reportDm}).returns(reportSm);
    	m_reportManager.Setup('getArchiveReportName', new List<Object>{isOreo}).returns(reportName);

    	sut.addArchivedReport(creditRelationshipId);

    	m_mockOfDataProvider.verify('getCreditRelationshipById' , new List<Object>{creditRelationshipId}, Times.AtLeastOnce);
    	m_reportManager.verify('getArchiveReportName', new List<Object>{isOreo}, Times.Once);
    	m_reportManager.verify('buildArchivedReportSm', new List<Object>{reportDm}, Times.Once);
    	m_reportManager.verify('generateReportOutput', new List<Object>{archivedReportId, isOreo}, Times.Once);
    	m_mockOfDataProvider.verify('addArchivedReport', new List<Object>{reportSm}, Times.Once);
    	m_mockOfDataProvider.verify('lockNotesById', new List<Object>{noteIds}, Times.Once);
    }

    public static testMethod void it_should_add_a_related_entity_when_a_related_entity_sm_is_provided() {
    	String entityId = ObjectFactory.getFakeId(Account.SObjectType, '1');
	    String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
    	CreditRelationship.RelatedEntitySm sm = new CreditRelationship.RelatedEntitySm();
		sm.entityId = entityId;
		sm.creditRelationshipId = creditRelationshipId;

    	sut.addRelatedEntity(sm);

    	m_mockOfDataProvider.verify('addRelatedEntity', new List<Object>{sm}, Times.Once);
    }

    public static testMethod void it_should_add_a_note_when_a_note_sm_is_provided() {
    	String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
    	String noteId =  ObjectFactory.getFakeId(Credit_Relationship_note__c.SObjectType, '1');
    	CreditRelationship.NoteSm sm = new CreditRelationship.NoteSm();
		sm.type = CreditRelationship.NoteType.minute;
		sm.creditRelationshipId = creditRelationshipId;
		sm.diary = 'testDiary';

    	sut.addNote(sm);

    	m_mockOfDataProvider.verify('addNote', new List<Object>{sm}, Times.Once);
    }

    public static testMethod void it_should_delete_related_entity_when_id_is_provided() {
    	String recordId =  ObjectFactory.getFakeId(Credit_Relationship_Related_Client__c.SObjectType, '1');

    	sut.deleteRelatedEntity(recordId);

    	m_mockOfDataProvider.verify('deleteRelatedEntity', new List<Object>{recordId}, Times.Once);
    }

    public static testMethod void it_should_delete_excluded_entity_when_id_is_provided() {
    	String recordId =  ObjectFactory.getFakeId(Credit_Relationship_Excluded_Account__c.SObjectType, '1');

    	sut.deleteExcludedEbAccount(recordId);

    	m_mockOfDataProvider.verify('deleteExcludedEbAccount', new List<Object>{recordId}, Times.Once);
    }

    public static testMethod void it_should_delete_note_when_recordid_is_provided() {
    	String recordId =  ObjectFactory.getFakeId(Credit_Relationship_note__c.SObjectType, '1');

    	sut.deleteNote(recordId);

    	m_mockOfDataProvider.verify('deleteNote', new List<Object>{recordId}, Times.Once);
    }

    public static testMethod void it_should_get_a_oreo_report_url_when_credit_relationshipid_is_passed() {
    	String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
    	String archivedReportId =  ObjectFactory.getFakeId(Archived_Report__c.SObjectType, '1');
    	String noteId =  ObjectFactory.getFakeId(Credit_Relationship_note__c.SObjectType, '1');
    	String reportName = 'Watch Credit OREO Report';
    	Boolean isOreo = true;
    	DmCreditRelationship dmCreditRelationship = new DmCreditRelationship();
    	dmCreditRelationship.id = creditRelationshipId;
    	dmCreditRelationship.RecordType = DmRecordTypeBy('Credit Relationship OREO');
    	DmCreditRelationshipNote note = new DmCreditRelationshipNote();
    	note.id = noteId;
    	note.creditRelationship = new DmCreditRelationship();
    	note.creditRelationship.id = creditRelationshipId;
    	note.RecordType = DmRecordTypeBy('Analysis');
    	note.situationFlag = false;
    	dmCreditRelationship.notes = new List<DmCreditRelationshipNote>{note};
    	List<String> parameters = new List<String>{creditRelationshipId};
    	String url = 'http:test.com';
    	Integer reportId= 1234;
    	m_mockOfDataProvider.Setup('getCreditRelationshipById' , new List<Object>{creditRelationshipId}).returns(dmCreditRelationship);
    	m_mockOfReportUrlProvider.setup('getReportUrl', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(url);
    	m_reportManager.setup('getReportIdForUrl', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(reportid);

    	String result = sut.getReportUrl(creditRelationshipId);

    	m_mockOfReportUrlProvider.verify('getReportUrl', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	m_reportManager.verify('getReportIdForUrl', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	m_mockOfDataProvider.verify('getCreditRelationshipById' , new List<Object>{creditRelationshipId}, Times.Once);
    	List<Object> arguments = (List<Object>)m_mockOfReportUrlProvider.getArgumentsFromCall('getReportUrl');
    	String resultReportId = String.valueof(arguments[0]);
    	List<String> reportParameters = (List<String>)arguments[1];
    	String reportParameter = reportParameters[0];
    	system.assertEquals(creditRelationshipId, reportParameter);
    	system.assertEquals(String.valueOf(reportId), resultReportId);
    }

    public static testMethod void it_should_get_a_non_oreo_report_url_when_credit_relationshipid_is_passed() {
        String creditRelationshipId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
        String archivedReportId =  ObjectFactory.getFakeId(Archived_Report__c.SObjectType, '1');
        String noteId =  ObjectFactory.getFakeId(Credit_Relationship_note__c.SObjectType, '1');
        String reportName = 'Watch Credit OREO Report';
        Boolean isOreo = false;
        DmCreditRelationship dmCreditRelationship = new DmCreditRelationship();
        dmCreditRelationship.id = creditRelationshipId;
        dmCreditRelationship.RecordType = DmRecordTypeBy('Credit Relationship OREO');
        DmCreditRelationshipNote note = new DmCreditRelationshipNote();
        note.id = noteId;
        note.creditRelationship = new DmCreditRelationship();
        note.creditRelationship.id = creditRelationshipId;
        note.RecordType = DmRecordTypeBy('Analysis');
        note.situationFlag = false;
        dmCreditRelationship.notes = new List<DmCreditRelationshipNote>{note};
        List<String> parameters = new List<String>{creditRelationshipId};
        String url = 'http:test.com';
        Integer reportId= 1234;
        m_mockOfDataProvider.Setup('getCreditRelationshipById' , new List<Object>{creditRelationshipId}).returns(dmCreditRelationship);
        m_mockOfReportUrlProvider.setup('getReportUrl', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(url);
        m_reportManager.setup('getReportIdForUrl', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(reportId);

        String result = sut.getReportUrl(creditRelationshipId);

        m_mockOfReportUrlProvider.verify('getReportUrl', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_reportManager.verify('getReportIdForUrl', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfDataProvider.verify('getCreditRelationshipById' , new List<Object>{creditRelationshipId}, Times.Once);
        List<Object> arguments = (List<Object>)m_mockOfReportUrlProvider.getArgumentsFromCall('getReportUrl');
        String resultReportId = String.valueof(arguments[0]);
        List<String> reportParameters = (List<String>)arguments[1];
        String reportParameter = reportParameters[0];
        system.assertEquals(creditRelationshipId, reportParameter);
        system.assertEquals(String.valueOf(reportId), resultReportId);
    }

    @IsTest
    static void it_should_return_true_if_user_have_admin_permission() {
    	String userId = ObjectFactory.getFakeId(User.SObjectType, '1');
    	m_mockOfUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

    	Boolean result = sut.hasPermissionAdmin();

    	m_mockOfUserInfoService.verify('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	system.assertEquals(true,result);
    }

    @IsTest
    static void it_should_return_false_if_user_has_admin_permission_and_is_not_admin() {
    	String userId = ObjectFactory.getFakeId(User.SObjectType, '1');
    	String permissionSetLabel = 'Function - Credit Relationship Admin';
    	m_mockOfUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
    	m_mockOfUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

    	Boolean result = sut.hasPermissionAdmin();

    	m_mockOfUserInfoService.verify('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	m_mockOfUserInfoService.verify('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	system.assertEquals(true,result);
    }

    @IsTest
    static void it_should_return_true_if_user_has_edit_permission_and_is_admin() {
    	String userId = ObjectFactory.getFakeId(User.SObjectType, '1');
    	String permissionSetLabel = 'Function - Credit Relationship Editor';
    	m_mockOfUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
    	m_mockOfUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

    	Boolean result = sut.hasPermissionToEdit();

    	m_mockOfUserInfoService.verify('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	m_mockOfUserInfoService.verify('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	system.assertEquals(true,result);
    }

    @IsTest
    static void it_should_return_true_if_user_is_has_edit_permission_and_is_not_admin() {
        String userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        String permissionSetLabel = 'Function - Credit Relationship Editor';
        m_mockOfUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        m_mockOfUserInfoService.setup('hasPermissionSet', new List<Object>{'Function - Credit Relationship Admin'}).returns(false);
        m_mockOfUserInfoService.setup('hasPermissionSet', new List<Object>{'Function - Credit Relationship Editor'}).returns(true);

        Boolean result = sut.hasPermissionToEdit();

        m_mockOfUserInfoService.verify('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfUserInfoService.verify('hasPermissionSet', new List<Object>{'Function - Credit Relationship Admin'}, Times.Once);
        m_mockOfUserInfoService.verify('hasPermissionSet', new List<Object>{'Function - Credit Relationship Editor'}, Times.Once);
        system.assertEquals(true,result);
    }

    @IsTest
    static void it_should_return_true_if_user_has_view_permission_and_is_not_admin() {
    	String userId = ObjectFactory.getFakeId(User.SObjectType, '1');
    	String permissionSetLabel = 'Function - Credit Relationship View';
    	m_mockOfUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
    	m_mockOfUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(true);

    	Boolean result = sut.hasPermissionToView();

    	m_mockOfUserInfoService.verify('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	m_mockOfUserInfoService.verify('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    	system.assertEquals(true,result);
    }

    @IsTest
    static void it_should_return_false_if_user_does_not_have_view_permission_and_is_not_admin() {
        String userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        String permissionSetLabel = 'Function - Credit Relationship View';
        m_mockOfUserInfoService.setup('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);
        m_mockOfUserInfoService.setup('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(false);

        Boolean result = sut.hasPermissionToView();

        m_mockOfUserInfoService.verify('isSystemAdministrator', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
        m_mockOfUserInfoService.verify('hasPermissionSet', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Twice);
        system.assertEquals(false,result);
    }

    @IsTest
    static void it_should_call_the_dataprovider_when_excluded_account_is_added() {
        CreditRelationship.ExcludedAccountSm sm = new CreditRelationship.ExcludedAccountSm();

        sut.addExcludedAccount(sm);

        m_mockOfDataProvider.verify('addExcludedAccount', new List<Object>{sm}, Times.Once);
    }

    @IsTest
    static void it_should_not_call_the_dataprovider_to_add_excluded_account_when_it_already_exists() {
        CreditRelationship.ExcludedAccountSm sm = new CreditRelationship.ExcludedAccountSm();
        sm.creditRelationshipId = '0000001';
        sm.accountId = '00000002';
        DmCreditRelationshipExcludedAccount dmExcludedAccount = new DmCreditRelationshipExcludedAccount();
        dmExcludedAccount.ebAccount = new DmEbAccount();
        dmExcludedAccount.ebAccount.id = sm.accountId;
        DmCreditRelationship dmCreditRelationship = new DmCreditRelationship();     
        dmCreditRelationship.excludedAccounts = new List<DmCreditRelationshipExcludedAccount>{dmExcludedAccount};
        m_mockOfDataProvider.setup('getCreditRelationshipById', new List<Object>{sm.creditRelationshipId}).returns(dmCreditRelationship);

        sut.addExcludedAccount(sm);

        m_mockOfDataProvider.verify('addExcludedAccount', new List<Object>{sm}, Times.Never);
    }



    private static DmRecordType DmRecordTypeBy(String name) {
    	DmRecordType dm = new DmRecordType();
    	dm.name = name;
    	return dm;
    }


	//Mocks
	public class MockofICreditRelationshipVmBuilder extends ApexMoq implements CreditRelationship.ICreditRelationshipVmBuilder{
		public List<CreditRelationship.ArchivedReportVm> buildArchivedReportVms(List<DmArchivedReport> dms){
			return (List<CreditRelationship.ArchivedReportVm>)handleMethodInvocation('buildArchivedReportVms', new List<Object>{dms});
		}
		public List<CreditRelationship.RelatedEntityVm> buildRelatedEntityVms(List<DmCreditRelationshipRelatedEntity> dms){
			return (List<CreditRelationship.RelatedEntityVm>)handleMethodInvocation('buildRelatedEntityVms', new List<Object>{dms});
		}
		public List<CreditRelationship.RelatedAccountVm> buildRelatedAccountVms(List<DmEbAccount> dms){
			return (List<CreditRelationship.RelatedAccountVm>)handleMethodInvocation('buildRelatedAccountVms', new List<Object>{dms});
		}
		public List<CreditRelationship.ExcludedAccountVm> buildExcludedAccountVms(List<DmCreditRelationshipExcludedAccount> dms){
			return (List<CreditRelationship.ExcludedAccountVm>)handleMethodInvocation('buildExcludedAccountVms', new List<Object>{dms});
		}
		public List<CreditRelationship.NoteVm> buildNoteVms(List<DmCreditRelationshipNote> dms){
			return (List<CreditRelationship.NoteVm>)handleMethodInvocation('buildNoteVms', new List<Object>{dms});
		}
		public List<CreditRelationship.PossibleRelatedEntityVm> buildPossibleRelatedEntityVms(List<DmEntity> dms){
			return (List<CreditRelationship.PossibleRelatedEntityVm>)handleMethodInvocation('buildPossibleRelatedEntityVms', new List<Object>{dms});
		}
	}

	public class MockofICreditRelationshipData extends ApexMoq implements CreditRelationship.ICreditRelationshipData{
		public DmCreditRelationship getCreditRelationshipById(String creditRelationshipId){
			return (DmCreditRelationship)handleMethodInvocation('getCreditRelationshipById', new List<Object>{creditRelationshipId});
		}
		public List<DmEbAccount> getRelatedAccounts(List<DmCreditRelationshipRelatedEntity> relatedEntities){
			return (List<DmEbAccount>)handleMethodInvocation('getRelatedAccounts', new List<Object>{relatedEntities});
		}
		public List<DmEntity> getPossibleRelatedEntities(List<DmEbAccount> relatedAccounts, List<DmCreditRelationshipRelatedEntity> relatedEntities){
			return (List<DmEntity>)handleMethodInvocation('getPossibleRelatedEntities', new List<Object>{relatedAccounts, relatedEntities});
		}
		public String addArchivedReport(CreditRelationship.ArchivedReportSm sm){
			return (String)handleMethodInvocation('addArchivedReport', new List<Object>{sm});
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
		public void lockNotesById(List<String> ids){
			handleMethodInvocation('lockNotesById', new List<Object>{ids});
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
	}

	public class MockofICreditRelationshipReportManager extends ApexMoq implements CreditRelationship.ICreditRelationshipReportManager{
		public void generateReportOutput(String archivedReportId, Boolean isOreo){
			handleMethodInvocation('generateReportOutput', new List<Object>{archivedReportId, isOreo});
		}
		public Integer getReportIdForUrl(Boolean isOreo){
			return (Integer)handleMethodInvocation('getReportIdForUrl', new List<Object>{isOreo});
		}
		public String getArchiveReportName(Boolean isOreo){
			return (String)handleMethodInvocation('getArchiveReportName', new List<Object>{isOreo});
		}
		public CreditRelationship.ArchivedReportSm buildArchivedReportSm(DmArchivedReport dm){
			return (CreditRelationship.ArchivedReportSm)handleMethodInvocation('buildArchivedReportSm', new List<Object>{dm});
		}
	}
}