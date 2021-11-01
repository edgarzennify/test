public with sharing class LoanAppStageAppActionController extends LoanAppStageActionBaseClass{
    
    String numberGenerationPage = '/apex/LoanAppStageNumberGenerator';
        
    String synchronizeBookedLoanAppPage = '/apex/SynchronizeBookedLoan';
    String synchronizeWithdrawnLoanAppPage = '/apex/SynchronizeWithdrawnLoan';
    String withdrawnText = 'Withdrawn';
    
    private TeamRoleMatrix.ITeamRoleMatrix teamRoleMatrix;
    
    public String dropdownApproverOneId{get;set;}
    private List<SelectOption> m_approverOneList = null;
     
    public LoanAppStageAppActionController(ApexPages.StandardController controller) {                
        SetTeamRoleMatrix(new TeamRoleMatrix.TeamRoleMatrixImplementation());   
        InitializeSignerOne();      
    }
    
    public void SetTeamRoleMatrix(TeamRoleMatrix.ITeamRoleMatrix roleMatrix){
        teamRoleMatrix = roleMatrix;
    }

    private EB_Loan_App_Stage__c withdrawnStage {get;set;}
        
    public override void LoadObject(){
        this.app = [SELECT  
                     Id, Name, Original_Withdrawn_Date__c, Approval_Path__c, Application_Stage__c,RecordTypeId, RecordType.Name
                    ,TDR_Determination_One__c, TDR_Determination_Two__c, TDR_Concession_Justification__c, TDR_Detail_Justification__c
                    ,Appraisal_Question_One__c, Appraisal_Question_Two__c, Evaluation_Appraisal_in_File_is_Used__c
                    ,Application_Stage_Reportable__c, Stage_Explanation__c, Stage_Comment__c
                    ,Approver_One__c, Approver_Two__c, Approver_Three__c, Application_Stage__r.Name
                    ,Application_Stage__r.Loan_App_Stage_Action_Controller__r.Id, Bank_Owned_Loan_Amount__c
                    ,EB_Loan_Packet__r.Name, EB_Loan_Packet__r.Committee_Date__c
                    ,EB_Loan_Packet__r.Actual_Approval_Path__c, EB_Loan_Packet__r.Lead_Entity__r.Name
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Name
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Name
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Id
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email
                    ,EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name
                    ,EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email
                    ,EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Name 
                    ,EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email,EB_Loan_Packet__r.Credit_Analyst__r.User__r.Name
                    ,DocumentationRep__r.User__r.Email, DocumentationRep__r.User__r.Name
                    ,Application_Stage__r.Stage_Selected_Email_Notifications__c , Application_Stage__r.Email_Queue__c, LastModifiedById
                    FROM EB_Loan_Application__c 
                    WHERE Id =: appId limit 1];
        this.packet = this.app.EB_Loan_Packet__r;
        this.currentStage = this.app.Application_Stage__r;
    }
     
    @TestVisible
    private void InitializeSignerOne(){
        try{
            if(getApproverOneList().size() == 2){
                dropdownApproverOneId = getApproverOneList().get(1).getValue();
            }
        }catch(exception ex){
                
        } 
    }
    
    public String getShowAppraisalQuestions(){
        if(PendingApprovalSelected()==true && this.app.Evaluation_Appraisal_in_File_is_Used__c > 0 ) return 'true';
        return 'false';
    }
    
    public String getShowTDRquestions(){
        if(PendingApprovalSelected() == true && isTDRRequiredRecordType()) return 'true';
        return 'false';
    }

    private Boolean isTDRRequiredRecordType(){
        RecordType appType = Utility.recordTypeObject('EB_Loan_Application__c',this.app.RecordTypeId);
        if(app.RecordType.Name == 'New' || app.RecordType.Name == 'New - Guidance Line Advance') return false;
        return true;
    }
    
    public String getShowCommittee(){
        if(PendingApprovalSelected() == true && getShowSignerOne() == 'true' && ddApprovalPath != docApproval && ddApprovalPath != oneSignaturePathText) return 'true';
        return 'false';
    }
   
    public String getShowSignerOne(){
        if(PendingApprovalSelected() == true && getShowSignerOneAndTwo() == 'false' ){
            return 'true';
        }
        return 'false';
    }
    
    public String getShowSignerOneAndTwo(){     
        if(PendingApprovalSelected() == true){
            if(ddApprovalPath == twoSignaturePathText 
                || ddApprovalPath == threeSignaturePathText 
                || ddApprovalPath == twoSignatureBoardPath  
                || ddApprovalPath == threeSignatureBoardPath  ) return 'true';
        }
        return 'false';
    }
    
    public String getShowSignerOneAndTwoForSave(){     
        if(PendingApprovalSelected() == true){
            if(ddApprovalPath == twoSignaturePathText) return 'true';
        }
        return 'false';
    }
    
    public String getShowSignerThree(){
        if(PendingApprovalSelected() == true){
            if(ddApprovalPath == threeSignaturePathText 
                || ddApprovalPath == threeSignatureBoardPath ) return 'true';
        }
        return 'false';
    }
    
    public List<SelectOption> getApproverOneList(){
        if(m_approverOneList == null){
            m_approverOneList = teamRoleMatrix.GetSigners(app.EB_Loan_Packet__r.Lead_Entity__c);
        }  
        return m_approverOneList;                
    }
    
    public List<SelectOption> getApprovalPaths(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(ddApprovalPathDefault,'-- None --'));
        Schema.Describefieldresult fieldResult = EB_Loan_Packet__c.Actual_Approval_Path__c.getDescribe();
        List<Schema.PicklistEntry> plist = fieldResult.getPicklistValues();
        for(Schema.Picklistentry p : plist){
                options.add(new SelectOption(p.getLabel(),p.getValue()));
        }
        return options;
    }
    
    private Boolean IsRMSameAsSingleSigner(){
        if(dropdownApproverOneId == userinfo.getUserId()) return true;
        return false;
    }

    public Boolean IsTDR_DetailJustificationRequired(){
        if(app.TDR_Determination_One__c!=null || app.TDR_Determination_One__c!='') return true;
        return false;
    }

    public Boolean IsTDR_ConcessionJustificationRequired(){
        if(app.TDR_Determination_TWo__c!=null || app.TDR_Determination_TWo__c!='') return true;
        return false;
    }
    
    public override String ValidateForm(){
        app.Approver_One__c = this.dropdownApproverOneId;
        try{
            if(ddNextStatusId == this.currentstage.Id){
                return 'Please select a new status';
            }
            if(ExplanationNeeded() == true && ddExplanation == ddExplanationDefault){
                return 'Please select a reason';
            }
            if(PendingApprovalSelected() == true){
                if(ddApprovalPath == ddApprovalPathDefault){
                    return 'Please select an approval path';
                }
                if(ddApprovalPath == twoSignaturePathText || ddApprovalPath == threeSignaturePathText){
                    if(this.app.Approver_One__c == this.app.Approver_Two__c && this.app.Approver_One__c != null){
                        return 'Cannot assign the same signer more than once.';
                    }                        
                }
                if(ddApprovalPath == twoSignaturePathText ){
                    if(this.app.Approver_One__c == null || this.app.Approver_Two__c == null ){
                        return 'All Signers need to be filled'; 
                    }
                }
                if(ddApprovalPath == threeSignaturePathText){                              
                    if(this.app.Approver_One__c == this.app.Approver_Three__c && this.app.Approver_One__c != null){
                        return 'Cannot assign the same signer more than once.';
                    }
                    if(this.app.Approver_Two__c == this.app.Approver_Three__c && this.app.Approver_Two__c != null){
                        return 'Cannot assign the same signer more than once.';
                    }
                    if(this.app.Approver_One__c == null || this.app.Approver_Three__c == null || this.app.Approver_Two__c == null){
                        return 'All Signers need to be filled';
                    }
                }
                if(isTDRRequiredRecordType() && (app.TDR_Determination_One__c == null || app.TDR_Determination_One__c == '')){
                    return 'TDR Determination 1 needs to be filled out';  
                }
                if(isTDRRequiredRecordType() && (app.TDR_Detail_Justification__c == null || app.TDR_Detail_Justification__c == '')){
                    return 'TDR Detail justification needs to be filled out';  
                }
                if(isTDRDeterminationTwoRequired() && String.isBlank(app.TDR_Concession_Justification__c)){
                    return 'TDR Concession Justification needs to be filled out';
                }
            }
            return StageActionValidation();                                                         
        }catch(Exception ex){
            Utility.debug_Log(ex.getMessage());
            return '?';
        }
    }

    private boolean isTDRDeterminationTwoRequired(){
        return app.TDR_Determination_One__c == 'Borrower is experiencing financial difficulty';
    }

    public override string SendEmailHelper(){
        String SecondaryOfficer = '';
        if (app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name == null) {
        } 
        else{
            SecondaryOfficer = app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name;
        }
        return 'The following loan application has moved to the ' + NextStage().Name
                + ' stage. Click on the link below to view additional details.\n\nLead Entity:' + app.EB_Loan_Packet__r.Lead_Entity__r.Name
                + '\n'+ app.name
                + '\nActual Approval Path:' + app.Approval_Path__c + '\n'
                + '\nTDR Determination 1: ' + app.TDR_Determination_One__c
                + '\nTDR Detail Justification: ' + app.TDR_Detail_Justification__c
                + '\nTDR Determination 2: ' + app.TDR_Determination_TWo__c
                + '\nTDR Concession Justification: ' + app.TDR_Concession_Justification__c + '\n'
                + '\nLoan Amount:'+ String.valueOf(app.Bank_Owned_Loan_Amount__c) + '\n'
                + 'Link to Application: ' + baseURL + '/' + String.valueOf(app.Id)
                + '\nRelationship Manager:' + app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name
                + '\nSecondary Officer:' + SecondaryOfficer
                + '\nLoan Coordinator:' + app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Name
                + '\nCredit Analyst:' + app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Name
                + '\nDocumentation Rep:' + app.DocumentationRep__r.User__r.Name;
    }
    
    public override List<String> EmailList(List<String> roles){
        List<String> Emails = new List<String>();
                 
        for(String r : roles){
            if(r == 'Coordinator'){  //Packet
                if(app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email != null) Emails.add(app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email);
            }else if(r == 'Credit Analyst'){
                if(app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email != null) Emails.add(app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email);
            }else if(r == 'Documentation Rep'){
                if(app.DocumentationRep__r.User__r.Email != null) Emails.add(app.DocumentationRep__r.User__r.Email);
            }else if(r == 'Relationship Manager'){  //Lead entity
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email != null) Emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email);
            }else if(r == 'WM Advisor'){
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email != null) Emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email);
            }else if(r == 'TM Rep'){
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email != null) Emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email);
            }else if(r == 'Secondary Officer'){
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email != null) Emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email);
            }else{
                
            }
        }
        return Emails;     
    }
    
    public override void Save(){            
        DoActionFieldUpdates();
        
        if(currentStage.Name == 'Pending Approval' && NextStage().Name == 'Recall Approval Request'){
            RecallApprovalRequest();
            return;
        }
             
        if(currentStage.Name != 'Booking Complete' && NextStage().Name != 'Archived'){          
            //Logic for using Auto Forward stage
            if(AutoForwardStage != null){                            
                app.Application_Stage__c = AutoForwardStage.Id;
                update app;
            }
                        
            app.Application_Stage__c = ddNextStatusId;
            app.Approver_One__c = dropdownApproverOneId;
            app.Stage_Explanation__c = '';
            app.stage_comment__c = '';
            if(StageLogComment != null){
                app.stage_comment__c = StageLogComment;
            }
            for(String s: selectedReasons){
                if(s == null || s == ''){}else{
                    app.Stage_Explanation__c += s + ';';
                }
            }
                        
            //Handle no error case if no option is selected 12/19/2011
            if(currentStage.Name == documentationcomplete  && app.Stage_Explanation__c == ''){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Explanation');
                ApexPages.addMessage(myMsg);
            }
            
            if(app.Stage_Explanation__c.length() > 1){
                app.Stage_Explanation__c = app.Stage_Explanation__c.substring(0,app.Stage_Explanation__c.length()-1);
            }
        }
                
        if(PendingApprovalSelected() == true){
            this.packet.Actual_Approval_Path__c = ddApprovalPath;
            update this.packet;
        }
        if(this.getShowSignerOne() == 'true'){
            this.app.Approver_One__c  = this.dropdownApproverOneId;
            this.app.Approver_Two__c = null;
            this.app.Approver_Three__c = null;
        }
        if(this.getShowSignerOneAndTwoForSave() == 'true'){
            this.app.Approver_One__c  = this.dropdownApproverOneId;
            this.app.Approver_Three__c = null;
        }
        if(this.getShowSignerThree() == 'true'){
            this.app.Approver_One__c  = this.dropdownApproverOneId;
        }
        update this.app;
                
        //Logic for using Auto Forward stage
        if(AutoForwardStage != null){                            
            app.Application_Stage__c = AutoForwardStage.Id;
            app.Stage_Explanation__c = '';
            app.stage_comment__c = '';
            update app;
        }   
    }
    public override PageReference SaveClicked(){             
        Savepoint sp = Database.setSavepoint();
        try{
            if(this.appId == null){ 
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                ApexPages.addMessage(myMsg);
            }else if(ValidateForm() == ''){
                Save();
                String subject = 'Loan Application Status Update - ' + app.Name + ' - ' + NextStage().Name;
                List<User> lastModifiedBy = [SELECT id, Name FROM User WHERE id =: app.LastModifiedById];  
                if(lastModifiedBy.size() > 0){          
                    SendEmail(subject,lastModifiedBy[0].Name);
                }else{
                	SendEmail(subject,'N/A');
                }         
                
                if(PendingApprovalSelected() == true){                    
                    SubmitForApproval();                    
                    if(IsRMSameAsSingleSigner() == true) AutoApproveWorkflow();                    
                }   
                
                return GotoNextPage();
            }else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ValidateForm());
                ApexPages.addMessage(myMsg);
            }
        }catch(exception ex){
            ApexPages.addMessages(ex);
            Database.rollback(sp);
        }
        return null; 
    }
    
    @TestVisible    
    public override PageReference GotoNextPage(){
        if(currentStage.Name == 'Booking Complete' && NextStage().Name == 'Archived') {
            return GotoPage('Booked');
        }else if(NextStage().Name == 'Withdrawn'){
            return GotoPage('Withdrawn');
        }else if( NextStage().Name == documentation && app.Loan_Type__c != utility.LoanTypeGuidanceLine() && app.Loan_Type__c != utility.LoanTypeGuidanceLineFixed() && app.Loan_Type__c != utility.LoanTypeGuidanceLineRevolving() ) {
            return GotoPage('GenerateNumber');
        }else{
            return BackToMainAppPage();
        }
        return null;
    }
    
    @TestVisible   
    private PageReference GotoPage(String PageType){
        Id retId;
        
        if(AppId != null){
            retId = AppId;
        }
        
        String newPageUrl = '';
        if(PageType == 'Booked') newPageUrl = baseUrl +  synchronizeBookedLoanAppPage + '?id=' + retId;
        if(PageType == 'Withdrawn') newPageUrl = baseUrl +  synchronizeWithdrawnLoanAppPage + '?id=' + retId;
        if(PageType == 'GenerateNumber') newPageUrl = baseUrl + numberGenerationPage + '?id=' + retId;

        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        
        return newPage;
    }
}