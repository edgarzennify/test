public class AgreementStageActionController extends LoanAppStageActionBaseClass{
  
    private TeamRoleMatrix.ITeamRoleMatrix m_teamRoleMatrix;
    private IUserInfoService m_userInfoSvc;
    private Agreements.IAgreementStatusManager m_agmtStatusManager;    

    public AgreementStageActionController(ApexPages.StandardController controller) {
		m_teamRoleMatrix = new TeamRoleMatrix.TeamRoleMatrixImplementation(); 
		m_userInfoSvc = new UserInfoService(Configurations.bootstrap(), new UserInfoServiceDataProv());
        m_agmtStatusManager = new AgreementStatusManager(m_userInfoSvc, new AgreementEntityManager(new AgreementEntityManagerDataProvider()), new AgreementStatusManagerDataProvider());  
		InitializeSignerOne();      
    }
    
    public AgreementStageActionController(TeamRoleMatrix.ITeamRoleMatrix teamRoleMatrix, IUserInfoService userInfoSvc, Agreements.IAgreementStatusManager statusActionManager){
    	m_teamRoleMatrix = teamRoleMatrix; 
        m_userInfoSvc = userInfoSvc;
        m_agmtStatusManager = statusActionManager;  
        InitializeSignerOne();      
    }

    public override void LoadObject(){
        this.agmt = [SELECT 
                        Id, Name, Committee_Date__c,Stage_Explanation__c,stage_comment__c,Actual_Approval_Process__c,Approver_One__c, 
                        Approver_Two__c,Approver_Three__c,Borrower_Name__c,Borrower_Name__r.Name, Stage_Reportable__c, Stage__c,Stage__r.Id,
                        Stage__r.Name, Stage__r.Loan_App_Stage_Action_Controller__r.Id, Borrower_Name__r.Team_Relationship_Manager__r.User__r.Id,
                        Back_Office_Start_Stage__c, LastModifiedById, 
                        Loan_Coordinator__r.User__r.Email, Credit_Analyst__r.User__r.Email, DocumentationRep__r.User__r.Email, 
                        Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email, Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__r.Email,
                        Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Email, Borrower_Name__r.Team_Private_Banker__r.User__r.Email
                     FROM Agreement__c
                     WHERE Id =: appId limit 1];
        this.currentStage = agmt.Stage__r;
    }
    
    public override List<SelectOption> getAllowedActions(){
    	Boolean userHasBackOfficeMod = m_userInfoSvc.hasPermissionSet(UserInfo.getUserId(), 'Function - Lending Agreement System - Back Office Modification');
    	Boolean userIsSystemAdmin = m_userInfoSvc.isSystemAdministrator(UserInfo.getUserId());
    	
    	List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(this.currentstage.Id,'-- Please select a status --'));
        
        for(EB_Loan_App_Stage_Allowed_Action__c aa: allowedActions){
            if(aa.Stage__r.Name == 'Back Office Modification' && userHasBackOfficeMod == false && userIsSystemAdmin == false){
                // don't add Back Office Mod
            }else{
                options.add(new SelectOption(aa.Stage__r.Id,aa.Stage__r.Name));
            }
        }
        return options;    	
    }
    
    public override String ValidateForm(){
    	//Utility.displayDebugInfo(Actual_Approval_Process__c);
        try{
            if(ddNextStatusId == this.currentstage.Id){                
                return 'Please select a new status';
            }
            if(PendingApprovalSelected() == true){
                if(ddApprovalPath == ddApprovalPathDefault){
                    return 'Please select an approval path';
                }
                if(ddApprovalPath == rmPlusOnePathText || ddApprovalPath == threeSignaturePathText){
                    if(dropdownApproverOneId == this.agmt.Approver_Two__c && dropdownApproverOneId != null){
                        return 'Cannot assign the same signer more than once.';
                    }                        
                }
                if(ddApprovalPath == rmPlusOnePathText ){
                    if(dropdownApproverOneId == null || this.agmt.Approver_Two__c == null ){
                        return 'All Signers need to be filled'; 
                    }
                }
                if(ddApprovalPath == threeSignaturePathText){                              
                    if(dropdownApproverOneId == this.agmt.Approver_Three__c && dropdownApproverOneId != null){
                        return 'Cannot assign the same signer more than once.';
                    }
                    if(this.agmt.Approver_Two__c == this.agmt.Approver_Three__c && this.agmt.Approver_Two__c != null){
                        return 'Cannot assign the same signer more than once.';
                    }
                    if(dropdownApproverOneId == null || this.agmt.Approver_Three__c == null || this.agmt.Approver_Two__c == null){
                        return 'All Signers need to be filled';
                    }
                }
            }
            return StageActionValidation();                                                         
        }catch(Exception ex){
            system.debug('##:ValidateForm ex ' + ex.getMessage());
            return 'Validation error';
        }
    }
    
    public override void Save(){   
        try{
            DoActionFieldUpdates();
        }catch(exception ex){}
        
        if((currentStage.Name == 'Pending Approval' || currentStage.Name == backOfficeModificationPendingApprovalText) 
                && NextStage().Name == 'Recall Approval Request'){
            Utility.RecallApprovalRequest(agmt.Id);
            return;
        }
        
        handleBackOfficeModification();

        if(currentStage.Name != 'Booking Complete' && NextStage().Name != 'Archived'){
            
            //Logic for using Auto Forward stage
            if(AutoForwardStage != null){                            
                agmt.Stage__c = AutoForwardStage.Id;
                update agmt;
            }
                   
            ResetCommentAndExplanation();
            if(StageLogComment != null){
                agmt.stage_comment__c = StageLogComment;
            }
            for(String s: selectedReasons){
                if(s == null || s == ''){}else{
                    agmt.Stage_Explanation__c += s + ';';
                }
            }
                        
            //Handle no error case if no option is selected 12/19/2011
            if(currentStage.Name == documentationcomplete  && agmt.Stage_Explanation__c == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Explanation');
                ApexPages.addMessage(myMsg);
            }
            
            if(agmt.Stage_Explanation__c.length() > 1){
                agmt.Stage_Explanation__c = agmt.Stage_Explanation__c.substring(0,agmt.Stage_Explanation__c.length()-1);
            } 
        }
        if(PendingApprovalSelected()){
            agmt.Approver_One__c = dropdownApproverOneId;
        }
        agmt.Stage__c = ddNextStatusId;
        if(NextStage().Name == backOfficeModificationPendingApprovalText){
            agmt.Actual_Approval_Process__c = 'Back Office Modification';
        }else{
            agmt.Actual_Approval_Process__c = ddApprovalPath;	
        }
        RecordStage();
       
        update agmt;
        if(AutoForwardStage != null){
            agmt.Stage__c = AutoForwardStage.Id;
            ResetCommentAndExplanation();
            update agmt;
        }               
    }
    
    private void handleBackOfficeModification(){
    	if(NextStage().Name == 'Back Office Modification'){
            m_agmtStatusManager.enterBackOfficeModification(agmt);
    	}
    }
    
    private Boolean IsRMSameAsSingleSigner(){
        if(dropdownApproverOneId == userinfo.getUserId()) return true;
        return false;
    }
    
    public override PageReference SaveClicked(){
        //Savepoint sp = Database.setSavepoint();
        //try{
            if(ValidateForm() == ''){
                system.debug('##:SaveClicked 2'); 
                Save();            
                String subject = 'Lending Agreement Status Update - ' + agmt.Name + ' - ' + NextStage().Name;
                List<User> lastModifiedBy = [SELECT id, Name FROM User WHERE id =: agmt.LastModifiedById];   
                SendEmail(subject,lastModifiedBy[0].Name);
                if(PendingApprovalSelected() == true){
                      utility.SubmitForApproval(agmt.Id);                    
                                       
                    if(IsRMSameAsSingleSigner() == true) utility.ApproveNextStep(agmt.Id);                    
                }                   
                return GotoNextPage();
            }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ValidateForm());
                    ApexPages.addMessage(myMsg);
            }
         // }catch(exception ex){
          //      ApexPages.addMessages(ex);
           //     Database.rollback(sp);
         // }
        return null;
    }
    
    public override PageReference GotoNextPage(){          
        String newPageUrl = baseUrl + '/' + agmt.Id;  
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);               
        return newPage;
    }
    
    public List<SelectOption> getApprovalPaths(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(ddApprovalPathDefault,'-- None --'));
        Schema.Describefieldresult fieldResult = Agreement__c.Actual_Approval_Process__c.getDescribe();
        List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
        for(Schema.Picklistentry p : plist){
                options.add(new SelectOption(p.getLabel(),p.getValue()));
        }
        return options;
    }
    
    public String getShowApprovalPath(){
        if(PendingApprovalSelected() == true
            && ddNextStatusId != backOfficeModificationApprovalStage.Id){
            	return 'true';
        }
        return 'false';
    }
    
    public override Boolean PendingApprovalSelected(){
        if(ddNextStatusId == pendingApprovalStage.Id || ddNextStatusId == backOfficeModificationApprovalStage.Id) return true;
        return false;
    }
    
    private void InitializeSignerOne(){
        try{
          if(getApproverOneList().size() == 2){
            dropdownApproverOneId = getApproverOneList().get(1).getValue();
          }
        }catch(exception ex){
                
        } 
    }
    
    public String getShowCommittee(){
        if(PendingApprovalSelected() == true 
            && getShowSignerOne() == 'true' 
            && ddNextStatusId != backOfficeModificationApprovalStage.Id){
                return 'true';
        }
        return 'false';
    }
   
    public String getShowSignerOne(){
        if(PendingApprovalSelected() == true && getShowSignerOneAndTwo() == 'false' ){
            if(ddApprovalPath == docApproval 
            || ddApprovalPath == regionalLoanCommittee  
            || ddApprovalPath == executiveLoanCommittee  
            || ddApprovalPath == executiveLoanCommitteeAndBoard 
            || ddApprovalPath == this.lossShareCommittee 
            || ddApprovalPath == twoSignatureBoardPath  
            || ddApprovalPath == threeSignatureBoardPath
            || ddNextStatusId == backOfficeModificationApprovalStage.Id){
                return 'true';
            }
        }
        return 'false';
    }
    
    public String getShowSignerOneAndTwo(){     
        if(PendingApprovalSelected() == true){
            if(ddApprovalPath == rmPlusOnePathText || ddApprovalPath == threeSignaturePathText || ddApprovalPath == twoSignatureBoardPath  || ddApprovalPath == threeSignatureBoardPath  ) return 'true';
        }
        return 'false';
    }
    
    public String getShowSignerOneAndTwoForSave(){     
        if(PendingApprovalSelected() == true){
            if(ddApprovalPath == rmPlusOnePathText) return 'true';
        }
        return 'false';
    }
    
    public String getShowSignerThree(){
        if(PendingApprovalSelected() == true){
            if(ddApprovalPath == threeSignaturePathText || ddApprovalPath == threeSignatureBoardPath ) return 'true';
        }
        return 'false';
    }

    public List<SelectOption> getApproverOneList(){
    	if(ddNextStatusId == backOfficeModificationApprovalStage.Id){
    		List<User> approvers = m_userInfoSvc.getUsersWithPermissionSet('Function - Lending Agreement System - Back Office Modification Approver');
    		return getSelectOptionsForUsers(approvers);
    	}
    	return m_teamRoleMatrix.GetSigners(agmt.Borrower_Name__c);               
    }
    
    private List<SelectOption> getSelectOptionsForUsers(List<User> users){
		List<SelectOption> options = new List<SelectOption>();
		users.sort();
		options.add(new SelectOption('', '--None--'));
		for(User u: users){
            options.add(new SelectOption(u.Id,u.Name));               
		}
		return options;
    }
        
    public String dropdownApproverOneId{get;set;}
    private void ResetCommentAndExplanation(){
        agmt.Stage_Explanation__c = '';
        agmt.stage_comment__c = '';
    }
    
    private void RecordStage(){
        ResetCommentAndExplanation();
        
        if(ExplanationNeeded()){ 
            
            if(StageLogComment != null){
                agmt.stage_comment__c = StageLogComment;
            }
            for(String s: selectedReasons){
                if(s == null || s == ''){}else{
                    agmt.Stage_Explanation__c += s + ';';
                }
            }            
            //Handle no error case if no option is selected 12/19/2011
            if( agmt.Stage_Explanation__c == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Explanation');
                ApexPages.addMessage(myMsg);
            }            
            if(agmt.Stage_Explanation__c.length() > 1){
                agmt.Stage_Explanation__c = agmt.Stage_Explanation__c.substring(0,agmt.Stage_Explanation__c.length()-1);
            }
        }
    }
    
    public override string SendEmailHelper(){
		return 'The following Agreement has moved to the ' + NextStage().Name 
		+ ' stage. Click on the link below to view additional details.'
		+ '\n'+ agmt.name
		+ '\n Link to Agreement: ' + baseURL + '/' + String.valueOf(agmt.Id);                                                
    }
    
    public override List<String> EmailList(List<String> roles){
        List<String> Emails = new List<String>();
                 
        for(String r : roles){
            if(r == 'Coordinator'){  //Packet
                if(agmt.Loan_Coordinator__r.User__r.Email != null) Emails.add(agmt.Loan_Coordinator__r.User__r.Email);
            }else if(r == 'Credit Analyst'){
                if(agmt.Credit_Analyst__r.User__r.Email != null) Emails.add(agmt.Credit_Analyst__r.User__r.Email);
            }else if(r == 'Documentation Rep'){
                if(agmt.DocumentationRep__r.User__r.Email != null) Emails.add(agmt.DocumentationRep__r.User__r.Email);
            }else if(r == 'Relationship Manager'){  //Lead entity
                if(agmt.Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email);
            }else if(r == 'WM Advisor'){
                if(agmt.Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__R.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Wealth_Management_Advisor__r.User__R.Email);
            }else if(r == 'TM Rep'){
                if(agmt.Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Treasury_Management_Representative__r.User__r.Email);
            }else if(r == 'Secondary Officer'){
                if(agmt.Borrower_Name__r.Team_Private_Banker__r.User__r.Email != null) Emails.add(agmt.Borrower_Name__r.Team_Private_Banker__r.User__r.Email);
            }else{
                
            }
        }
        return Emails;     
    }
}