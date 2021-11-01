@isTest
public class AgreementStageActionControllerTests {
	private static testMethod void it_should_set_the_backofficeStartStage_to_previous_stage_if_backoffice_is_selected() {
		
		TestUtilities.createLoanAppStages();
		EB_Loan_App_Stage__c approvedStage = TestUtilities.getStageByName('Approved');
		EB_Loan_App_Stage__c backOfficeModificationStage = TestUtilities.getStageByName('Back Office Modification');
		
    	Account entity = ObjectFactory.getValidEntity('test entity');
    	Agreement__c testAgreement = new Agreement__c();
    	testAgreement.name = 'testAgreement';
    	testAgreement.Primary_Borrower__c = entity.Id;
    	testAgreement.RecordTypeId = Utility.RecordTypeObject('Agreement__c', 'Pending').Id;
    	insert testAgreement;
    	testAgreement.Stage__c = approvedStage.id;
    	update testAgreement;
    	
        PageReference pr = Page.AgreementStageAction;
    	test.setCurrentPage(pr);    	
    	ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
    	TeamRoleMatrix.ITeamRoleMatrix teamRoleMatrix = new TeamRoleMatrix.TeamRoleMatrixImplementation(); 
        IUserInfoService userInfoService = new UserInfoService(Configurations.bootstrap(), new UserInfoServiceDataProv());
        MockOfAgreementStatusManager mockAgreementStatusManager = new MockOfAgreementStatusManager();  
    	AgreementStageActionController sut  = new AgreementStageActionController(teamRoleMatrix, userInfoService, mockAgreementStatusManager);
    	sut.ddNextStatusId = backOfficeModificationStage.Id;

    	PageReference pg = sut.SaveClicked();

    	Agreement__c reQueryAgreement = [SELECT Id, Stage__c, Back_Office_Start_Stage__c FROM Agreement__c WHERE Id =: testAgreement.Id];
    	
    	EB_Loan_App_Stage__c requeryStage = TestUtilities.getStageById(requeryAgreement.Stage__c);
    	System.assertEquals(1, mockAgreementStatusManager.enterBackOfficeModification_TimesCalled);
    	System.assertEquals(testAgreement.Id, mockAgreementStatusManager.enterBackOfficeModification_Param_agreement.Id);
	}
	
	private static testMethod void it_should_only_allow_backofficemodificationpendingapproval_when_the_stage_is_backofficemodification(){
		TestUtilities.createLoanAppStages();
        EB_Loan_App_Stage__c backOfficeModification = TestUtilities.getStageByName('Back Office Modification');
        EB_Loan_App_Stage__c backOfficeModificationPendingApproval = TestUtilities.getStageByName('Back Office Modification - Pending Approval');
        
		Agreement__c testAgreement = new Agreement__c();
		insert testAgreement;
		
		testAgreement.Stage__c = backOfficeModification.Id;
		update testAgreement;
		
		PageReference pr = Page.AgreementStageAction;
        test.setCurrentPage(pr);        
        ApexPages.currentPage().getParameters().put('Id', testAgreement.Id);
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testAgreement);  
        AgreementStageActionController sut  = new AgreementStageActionController(sc);
        
		List<SelectOption> options = sut.getAllowedActions();
		
		System.assertEquals(2, options.size());
		System.assertEquals(backOfficeModificationPendingApproval.Name, options[1].getLabel());
	}
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public class MockOfAgreementStatusManager implements Agreements.IAgreementStatusManager{
		public Integer enterBackOfficeModification_TimesCalled {get;private set;}
        public Agreement__c enterBackOfficeModification_Param_agreement {get;private set;}
		public Integer exitBackOfficeModification_TimesCalled {get;private set;}
		
		public Integer isAgreementEditable_TimesCalled {get; private set;}
		public Agreement__c isAgreementEditable_param_agreement {get;private set;}
		public Boolean isAgreementEditable_Return {get;private set;}
		
		public MockOfAgreementStatusManager(){
			enterBackOfficeModification_TimesCalled = 0;
			exitBackOfficeModification_TimesCalled = 0;
			isAgreementEditable_TimesCalled = 0;
		}
		
		public void MakeActiveAdminBackdoor(Id agmtId){}
        public void MakePendingAdminBackdoor(Id agmtId){}
        public void MakeArchiveAdminBackdoor(Id agmtId){}
        public void MakeNewAdminBackdoor(Id agmtId){}
        public void MakeActive(Id agmtId){}
        public void attachLoanAppAgreementsToAccount(Id appId, Id acctId){}
        public void MakeArchive(Id agmtId){}
        
        public void enterBackOfficeModification(Agreement__c agreement){
        	enterBackOfficeModification_TimesCalled += 1;
        	enterBackOfficeModification_Param_agreement = agreement;
        }
        public void exitBackOfficeModification(Agreement__c agreement){
        	exitBackOfficeModification_TimesCalled += 1;
        }        
        public boolean isAgreementEditable(Agreement__c agmt, Id userId){
        	isAgreementEditable_TimesCalled += 1;
        	isAgreementEditable_param_agreement = agmt;
        	return isAgreementEditable_Return;
        }        
        public boolean hasLoanApps(Agreement__c agmt){
            return null;
        }
        public RecordType getRecordType(Agreement__c agreement){
        	return null;
        }
	}
}