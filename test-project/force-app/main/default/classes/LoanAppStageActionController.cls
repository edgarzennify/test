public with sharing class LoanAppStageActionController  {
    @testVisible
    String baseURL = '';
    @testVisible
    String pendingApprovalText = 'Pending Approval';
    @testVisible
    String ddExplanationDefault = '#';
    @testVisible
    String ddApprovalPathDefault = '#';
    @testVisible
    String twoSignaturePathText = '2 Signatures';
    @testVisible
    String threeSignaturePathText = '3 Signatures';
    @testVisible
    String regionalLoanCommittee = 'Regional Loan Committee';
    @testVisible
    String executiveLoanCommittee = 'Executive Loan Committee';
    @testVisible
    String executiveLoanCommitteeAndBoard = 'Executive Loan Committee & Board';
    @testVisible
    String lossShareCommittee = 'Loss Share Committee';
    @testVisible
    String docApproval = 'Doc Approval';
    @testVisible
    String documentation = 'Documentation';
    @testVisible
    String documentationComplete = 'Documentation Complete';
    @testVisible
    String synchronizeBookedLoanAppPage = '/apex/SynchronizeBookedLoan';
    @testVisible
    String synchronizeWithdrawnLoanAppPage = '/apex/SynchronizeWithdrawnLoan';
    @testVisible
    String numberGenerationPage = '/apex/LoanAppStageNumberGenerator';
    @testVisible
    String debugPrefix = '####';
    @testVisible
    Id LoanAppId;
    @testVisible
    String[] selectedReasons = new String[]{};
    
    public String err{get;set;}
    
    public EB_Loan_Application__c app {get;set;}
    public EB_Loan_App_Stage__c currentStage {get;set;}
    public EB_Stage_Action_Controller__c stageController {get;set;}
    public EB_Loan_Packet__c packet {get;set;}
    public String StageLogComment{get;set;}
    public Id ddNextStatusId {get;set;}
    public String ddExplanation {get;set;}
    public String ddApprovalPath {get;set;}
    public String[] getSelectedReasons() {
        return selectedReasons;
    }    
    public void setSelectedReasons(String[] reasons) {
        this.selectedReasons = reasons;
    }
    
    private List<EB_Loan_App_Stage_Allowed_Action__c> allowedActions {get;set;}
    private EB_Loan_App_Stage__c nextStage {get;set;}
    private EB_Loan_App_Stage__c pendingApprovalStage {get;set;}
      
    private boolean EnableLogging = false;
    @testVisible
    private void debug_RecordLog(String event){
        if(EnableLogging = true){
            utility.debug_RecordLog('LoanAppStageActionController',event,'');
        }
    }
        
    public LoanAppStageActionController(ApexPages.StandardController controller) {                  
                if(baseURL == '')  baseURL = getServerUrl();
                LoanAppId = apexpages.currentpage().getparameters().get('id');  
                Initialize(LoanAppId);
    }
    @testVisible
    private void Initialize(Id appId){
        LoanAppId = appId;
        nextStage = null;
        
        if(appId != null){
            try{
            	
                this.app = [SELECT Id, Name, Loan_Type_For_Number_Generation__c ,Account_Number_Assigned__c,Record_Type_Description__c,Loan_Type__c, Approval_Path__c, Application_Stage__c, TDR_Determination_One__c , TDR_Determination_Two__c, Application_Stage_Reportable__c, Stage_Explanation__c,Stage_Comment__c, Approver_One__c, Approver_Two__c, Approver_Three__c, Application_Stage__r.Name, Application_Stage__r.Loan_App_Stage_Action_Controller__r.Id, Bank_Owned_Loan_Amount__c, EB_Loan_Packet__r.Name, EB_Loan_Packet__r.Committee_Date__c, EB_Loan_Packet__r.Actual_Approval_Path__c, EB_Loan_Packet__r.Lead_Entity__r.Name, EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email,EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Name, EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email,EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Name, EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email,EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name, EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id, EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Id, EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email,EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name, EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email,EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Name , EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email,EB_Loan_Packet__r.Credit_Analyst__r.User__r.Name, DocumentationRep__r.User__r.Email, DocumentationRep__r.User__r.Name, Application_Stage__r.Stage_Selected_Email_Notifications__c , Application_Stage__r.Email_Queue__c FROM EB_Loan_Application__c WHERE Id =: appId limit 1];
                this.packet = this.app.EB_Loan_Packet__r;
                this.currentStage = this.app.Application_Stage__r;
                this.stageController = this.currentStage.Loan_App_Stage_Action_Controller__r;                               
                this.allowedActions = [SELECT Id, Name, Type__c, Stage__r.Id, Stage__r.Name, (SELECT Id, Object_Name__c, Field_Name__c, New_Value__c FROM EB_Loan_App_Action_Field_Updates__r) FROM EB_Loan_App_Stage_Allowed_Action__c WHERE Controller__c =: this.stageController.Id AND Stage__r.Id !=: this.currentStage.Id ORDER BY Type__c, Stage__r.Sort_Order__c LIMIT 500];
                this.pendingApprovalStage = [SELECT Id FROM EB_Loan_App_Stage__c WHERE Name =: pendingApprovalText LIMIT 1];
                       
                InitializeSignerOne(); 
                this.ddApprovalPath = this.packet.Actual_Approval_Path__c; 
                
            }catch(exception ex){
                this.app = null;
                system.debug(debugPrefix + ex.getMessage());
            }
        }else{
            this.app = null;
        }
    }
  
    @testVisible
    private void InitializeSignerOne(){         
        //this.app.Approver_One__c = this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id;
        dropdownApproverOneId = this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id;
    }
        
    public List<SelectOption> getAllowedActions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(this.currentstage.Id,'-- Please select a status --'));
        
        for(EB_Loan_App_Stage_Allowed_Action__c aa: allowedActions){
                        options.add(new SelectOption(aa.Stage__r.Id,aa.Stage__r.Name));
        }
        return options;
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
    @testVisible
    private List<EB_Loan_App_Stage_Explanation__c> getStageExplanations(){
        return [SELECT Id, Name FROM EB_Loan_App_Stage_Explanation__c WHERE Loan_App_Stage__c =: ddNextStatusId AND Type__c =: NextStageType() ORDER BY Name LIMIT 500];
    }
       
    public List<SelectOption> getStageExplanationOptions(){
        List<SelectOption> options = new List<SelectOption>();
       // options.add(new SelectOption(ddExplanationDefault,'-- Please select an explanation --'));                
                
        for(EB_Loan_App_Stage_Explanation__c exp: getStageExplanations()){
                options.add(new SelectOption(exp.Name,exp.Name));
        }
                    
        return options;
    }
    
   
    
    public String getExplanationNeeded(){
        if(ExplanationNeeded() == true) return 'true';
                return 'false';
    }
    @testVisible
    private Boolean ExplanationNeeded(){
        if(getStageExplanations().size() > 0) return true;
                return false;
    }
    
    public String getShowPendingApprovalPanel(){
        if(PendingApprovalSelected() == true) return 'true';
        return 'false';
    }
    @testVisible
    private Boolean PendingApprovalSelected(){
        if(ddNextStatusId == pendingApprovalStage.Id) return true;
        return false;
    }
    
    public String getShowCommittee(){
        if(getShowSignerOne() == 'true' && ddApprovalPath != docApproval) return 'true';
        return 'false';
    }
    
    public String getShowSignerOne(){
        if(PendingApprovalSelected() == true && getShowSignerOneAndTwo() == 'false' ){
                if(ddApprovalPath == docApproval || ddApprovalPath == regionalLoanCommittee  || ddApprovalPath == executiveLoanCommittee  || ddApprovalPath == executiveLoanCommitteeAndBoard || ddApprovalPath == this.lossShareCommittee) return 'true';
        }
        return 'false';
    }
    
    public String getShowSignerOneAndTwo(){     
        if(PendingApprovalSelected() == true){
                if(ddApprovalPath == twoSignaturePathText || ddApprovalPath == threeSignaturePathText ) return 'true';
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
                if(ddApprovalPath == threeSignaturePathText) return 'true';
        }
        return 'false';
    }
    public String dropdownApproverOneId{get;set;}
    public List<SelectOption> getApproverOneList(){
                List<SelectOption> options = new List<SelectOption>();
                 options.add(new SelectOption('', '--None--'));
                 options.add(new SelectOption(this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id,this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name));
                 if(this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Id != null) options.add(new SelectOption(this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Id,this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name));
                return options;
    }
    @testVisible
    private Boolean IsRMSameAsSingleSigner(){
    	//if( dropdownApproverOneId == this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id) return true;
    	if( dropdownApproverOneId == userinfo.getUserId()) return true;
    	
    	return false;
    	 
    }
    @testVisible
    private String NextStageType(){
      for(EB_Loan_App_Stage_Allowed_Action__c aa: allowedActions){
        if(aa.Stage__r.Id == ddNextStatusId) return aa.Type__c;
        }
        return '';
    }
    @testVisible
    private EB_Loan_App_Stage__c NextStage(){
    	
        if(nextStage == null){
                List<EB_Loan_App_Stage__c> stage = [SELECT Id, Name, Stage_Selected_Email_Notifications__c,Email_Queue__c, (Select Id, Name, LastModifiedDate, Field_Name__c, Object_Name__c, Operand__c, Operation__c, Error_Text__c From EB_Loan_App_Stage_Validation_Rules__r) FROM EB_Loan_App_Stage__c WHERE Id =: ddNextStatusId limit 1 ];
                if(stage.size() > 0) nextStage = stage[0];
                
        }
        
        return nextStage;
    }
    @testVisible
    private List<String> EmailNotificationList(){
        String roleList = NextStage().Stage_Selected_Email_Notifications__c;
        List<String> roles = GetSplitList(roleList);
        if(roles != null){
        	 if(roles.size() > 0) return EmailList(roles);
        }
               
        return null;     
    }
      /*  private List<String> EmailNotificationList(){
        String roleList = NextStage().Stage_Selected_Email_Notifications__c;
        
                if(roleList != null){
                        List<String> roles = new List<String>();
                        try{
                                roles = roleList.split(';');
                        }catch(exception ex){
                                roles = null;
                        }
                        if(roles != null){
                                if(roles.size() > 0) return EmailList(roles);
                        }
                }
        return null;     
    } */
    @testVisible
    private List<String> EmailQueueNotificationList(){
    	try{
    	String queueList = NextStage().Email_Queue__c;
    	
    	List<String> queues = GetSplitList(queueList);
    	List<String> emails = new List<String>();
    	
    	for(String que_ue : queues){
    		List<String> emailsFromQueue = GetEmailsFromQueue(que_ue);
    		for(String child : emailsFromQueue){
    			emails.add(child);
    		}
    	}
    	if(emails.size() > 0) return emails;
    	}catch(exception ex){}
    	return null;

    }
    @testVisible
    private List<String> GetEmailsFromQueue(String qu_eue){
    	list<Group> groups =[Select g.Type, g.Id,g.Name, (Select UserOrGroupId  From GroupMembers) From Group g WHERE g.Type =: 'Queue' and g.Name =: qu_eue];
	        Map<id,id> groupMap = new Map<id,id>();
	        for(Group g : groups){
	        	for(GroupMember gm : g.GroupMembers ){
	        		groupMap.put(gm.UserOrGroupId,gm.UserOrGroupId);
	        	}
	        }
	        List<User> users = [Select Email, Id From User Where Id in : groupMap.keyset()];
	        List<String> emails = new List<String>();
	        for(user u : users){
	        	emails.add(u.email);
	        }
	        
	        if(app==null ||emails==null) return null;
	        return emails;
    }  
    @testVisible        
    private List<String> GetSplitList(String DelimitedList){
    	if(DelimitedList != null){
    		           
                        List<String> members = new List<String>();
                        try{
                                members = DelimitedList.split(';');
                        }catch(exception ex){
                                members = null;
                        }
                        if(members != null){
                                if(members.size() > 0) return members;
                        }
                     
                }
        return null;
    }

    @testVisible
    private List<String> EmailList(List<String> roles){   
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
    
    public String getQuotes(){
        return '"';
        }
        
        private void Save(){       
        	       
                DoActionFieldUpdates();
                // List<EB_Loan_App_Stage__c> stages = [SELECT Id,Name FROM EB_Loan_App_Stage__c WHERE id =:ddNextStatusId];
	               // if(app.Application_Stage_Reportable__c == 'Approved' && stages[0].Name == documentation ){
	                	
	                	//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Test 1 '+ currentStage.Name + ' ' + NextStage().Name);
                        //ApexPages.addMessage(myMsg);
		                //	String loannumber = LoanApplicationViewController.GetNewLoanNumber(app);
		                //	if(loannumber != '') app.Account_Number_Assigned__c = loannumber; 
   
	               
	              //  }
                if(currentStage.Name == 'Pending Approval' && NextStage().Name == 'Recall Approval Request'){
                	RecallApprovalRequest();
               		return;
                }
                
                if(currentStage.Name != 'Booking Complete' && NextStage().Name != 'Archived'){
                	
	                app.Application_Stage__c = ddNextStatusId;
	                //app.Stage_Explanation__c = ddExplanation;
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
	                	app.Stage_Explanation__c = 'No Errors' + ';' ;
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
             
                
                //Just to be sure we have an RM
                //if(this.app.Approver_One__c == null) this.app.Approver_One__c = this.app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id;
                
                
                update this.app;
        }
       /* @future
        private static void GenerateLoanNumber(Id Loan_Id){
        	 LoanApplicationViewController.GenerateNumberFromId(Loan_id);
		                	
        }*/
       @testVisible
        private void DoActionFieldUpdates(){
               
                for(EB_Loan_App_Stage_Allowed_Action__c aa : allowedActions){
                	 
                if(aa.Stage__r.Id == ddNextStatusId ){
                	 
                        for(EB_Loan_App_Action_Field_Update__c upd: aa.EB_Loan_App_Action_Field_Updates__r){
                        	   //err = aa.Stage__r.Id + '==' + ddNextStatusId ;
                                String objectName = upd.Object_Name__c;
                                String fieldName = upd.Field_Name__c;
                                String newValue = upd.New_Value__c;
                                Id objID;
                                
                                if(objectName=='EB_Loan_Packet__c'){
                                        objID = packet.Id;
                                }else if(objectName=='EB_Loan_Application__c'){
                                        objID = app.Id;
                                }
                               
                                UpdateRecord(objID,objectName,fieldName,newValue);      
                        }
                	 
               		 }
       			 }
              
        }
        @testVisible
        private void UpdateRecord(Id i, String obj, String fld, String val){            
                
                String query = 'SELECT ' + fld + ' FROM ' + obj + ' WHERE Id = ' + '\'' + i + '\' limit 1';
                sObject o = Database.query(query);
                o.put(fld,val);
                
                update o;  
                          
        }
     
        public PageReference SaveClicked(){   
        	              
                Savepoint sp = Database.setSavepoint();
                try{
                    if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                        ApexPages.addMessage(myMsg);
                    }else if(ValidateForm() == ''){
                        Save();
                        
                        
                        SendEmail();
                           
                           
                        if(PendingApprovalSelected() == true){
                        	
                        		 SubmitForApproval();
                        		 
                        		 if( IsRMSameAsSingleSigner() == true) AutoApproveWorkflow();
             

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
        
        public PageReference CancelClicked(){
                return BackToMainAppPage();
        }
        @testVisible
        private PageReference GotoNextPage(){
                if(currentStage.Name == 'Booking Complete' && NextStage().Name == 'Archived') {
                    return GotoPage('Booked');
                }else if(NextStage().Name == 'Withdrawn'){
                	return GotoPage('Withdrawn');
                }else if(currentStage.Name == 'Approved' && NextStage().Name == documentation && app.Loan_Type__c != utility.LoanTypeGuidanceLine() && app.Loan_Type__c != utility.LoanTypeGuidanceLineFixed() && app.Loan_Type__c != utility.LoanTypeGuidanceLineRevolving() ) {
                	return GotoPage('GenerateNumber');
                }else{
                    return BackToMainAppPage();
                }
                return null;
        }
        @testVisible
        private PageReference BackToMainAppPage(){
                Id retId;
                                
                if(LoanAppId != null){
                  retId = LoanAppId;
                }
                
                String newPageUrl = baseURL + '/' + retId;  
                PageReference newPage = new PageReference(newPageUrl);
                newPage.setRedirect(true);
                
                return newPage;
        }
        @testVisible
        private PageReference GotoPage(String PageType){
                Id retId;
                                
                if(LoanAppId != null){
                  retId = LoanAppId;
                }
                
                String newPageUrl = '';
                if(PageType == 'Booked') newPageUrl = baseUrl +  synchronizeBookedLoanAppPage + '?id=' + retId;
                if(PageType == 'Withdrawn') newPageUrl = baseUrl +  synchronizeWithdrawnLoanAppPage + '?id=' + retId;
                if(PageType == 'GenerateNumber') newPageUrl = baseUrl + numberGenerationPage + '?id=' + retId;
                // + synchronizeLoanAppPage + '?id=' + retId;  
                PageReference newPage = new PageReference(newPageUrl);
                newPage.setRedirect(true);
                
               
                return newPage;
        }
        @testVisible
        private String ValidateForm(){
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
                    if(this.packet.Actual_Approval_Path__c == twoSignaturePathText || this.packet.Actual_Approval_Path__c == threeSignaturePathText){
                        if(this.app.Approver_One__c == this.app.Approver_Two__c && this.app.Approver_One__c != null){
                            return 'Cannot assign the same signer more than once.';
                        }
                        
                    }
                    if(this.packet.Actual_Approval_Path__c == twoSignaturePathText ){
                        	if(this.app.Approver_One__c == null || this.app.Approver_Two__c == null ){
                        		return 'All Signers need to be filled'; 
                        	}
                    }
                    if(this.packet.Actual_Approval_Path__c == threeSignaturePathText){                              
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
                    if(app.TDR_Determination_One__c == null || app.TDR_Determination_One__c == ''){
                    	return 'TDR Determination 1 needs to be filled out';
                    	
                    }
                }
                return StageActionValidation();                                                         
            }catch(Exception ex){
                debug_RecordLog(ex.getMessage());
                return '?';
            }
        }
        @testVisible
        private void SendEmail(){
        	try{
                Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                email.setSubject('Loan Application Status Update - ' + app.Name + ' - ' + NextStage().Name);            
                email.setReplyTo('no-reply@enterprisebank.com');
                email.setSaveAsActivity(false);         
               
                String Message = 'The following loan application has moved to the ' + NextStage().Name
                                                 + ' stage. Click on the link below to view additional details.\n\nLead Entity:' + app.EB_Loan_Packet__r.Lead_Entity__r.Name
                                                 + '\n'+ app.name
                                                 + '\nStage Explanation:' + app.Stage_Explanation__c + '\n'
                                                 + '\nActual Approval Path:' + app.Approval_Path__c + '\n'
                                                 + '\nTDR Determination 1: ' + app.TDR_Determination_One__c
                                                 + '\nTDR Determination 2: ' + app.TDR_Determination_TWo__c + '\n'
                                                 + '\nLoan Amount:'+ String.valueOf(app.Bank_Owned_Loan_Amount__c) + '\n'
                                                 + 'Link to Application: ' + baseURL + '/' + String.valueOf(app.Id)
                                                 + '\nRelationship Manager:' + app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name
                                                 + '\nLoan Coordinator:' + app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Name
                                                 + '\nCredit Analyst:' + app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Name
                                                 + '\nDocumentation Rep:' + app.DocumentationRep__r.User__r.Name
                                                 + '\nPrimary Collateral Code:' + app.Primary_Collateral_Code__c
                         						 + '\nIndustry Code:' + app.EB_Account_Industry_Code__r.Name;
              
                if(NextStage().Name == 'Booking Complete') {
                	try{
                        List<User> usr = [SELECT id, Name FROM User WHERE id =: app.LastModifiedById];
                        Message += '\nBooked by:' + usr[0].Name;
                	}catch(exception ex){
                		Message += '\nBooked by:' + 'N/A';
                	}
                }
               
                email.setPlainTextBody(Message);                
                List<String> emailaddresses = EmailNotificationList();
                Map<String, string> emailMap = new Map<String,String>();
                try{
                	if(emailaddresses == null) emailaddresses = new List<String>();
	                if(emailaddresses.size()> 0) {
	                  for(String s : emailaddresses){
	                    if(!emailMap.containskey(s)) emailMap.put(s,s);
	                  }
	                  
	                }
                
	                List<String> emailsFromQueue = EmailQueueNotificationList();
	                for(string em : emailsFromQueue){
	                 
	                  if(!emailMap.containskey(em)) emailaddresses.add(em);
	                }
	                
                }catch(exception ex){
                	
                }
                
                if(emailAddresses != null){
                for(string s : emailAddresses){
                	this.debug_RecordLog(s);
                }}
            
        		if(emailaddresses != null){             
                //send to rajiv for testing comment these lines out
                /*List<String> toAddresses = new List<String>();
                        toAddresses.add('rupadhya@enterprisebank.com');
                        email.setToAddresses(toAddresses);
                        Messaging.SendEmailResult[] sendResult; 
                    sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });*/
               
                //uncomment these for production
                        email.setToAddresses(emailaddresses);
                        Messaging.SendEmailResult[] sendResult; 
                sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        		
        }      
        }catch(exception ex){}         
    }
    @testVisible
    private void SubmitForApproval(){
    	//try{
	        Approval.Processsubmitrequest req1 = new Approval.Processsubmitrequest();
	        req1.setObjectId(this.app.Id);
	        Approval.Processresult result = Approval.process(req1);
	        
	        
    	//}catch(exception ex){
    		//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ValidateForm());
            //ApexPages.addMessage(myMsg);
    	//}
    }
    @testVisible
    private void AutoApproveWorkflow(){
    	List<ProcessInstance> currentApprovalInstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:loanappid ORDER BY CreatedDate DESC LIMIT 1];
		List<ProcessInstanceWorkitem> currentApprovalWorkItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: currentApprovalInstance.get(0).Id]; 
    	Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
    	req2.setWorkitemId(currentApprovalWorkItem.get(0).Id);
		req2.setComments('');
		req2.setAction('Approve');    
		Approval.ProcessResult result2 =  Approval.process(req2);
    }
    @testVisible
    private void RecallApprovalRequest(){
    	//try{
    		List<ProcessInstance> currentApprovalInstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:loanappid ORDER BY CreatedDate DESC LIMIT 1];
    		List<ProcessInstanceWorkitem> currentApprovalWorkItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: currentApprovalInstance.get(0).Id]; 
	    	Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
	    	req2.setWorkitemId(currentApprovalWorkItem.get(0).Id);
			req2.setComments('');
			req2.setAction('Removed');    
			Approval.ProcessResult result2 =  Approval.process(req2);			
		//}catch(exception ex){
    		//ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ValidateForm());
            //ApexPages.addMessage(myMsg);
    	//}
    }
    
        public PageReference Bogus(){
        return null;
        }
       @testVisible 
        private String StageActionValidation(){                 
            List<String> invalidFields = New List<String>();
            String sReturn = '';
            String sDelimiter = ' / ';
            for(EB_Loan_App_Stage_Validation_Rule__c rule : NextStage().EB_Loan_App_Stage_Validation_Rules__r){             
                String objectName = rule.Object_Name__c;
                String fieldName = rule.Field_Name__c;                  
                String operator = rule.Operation__c;
                String operand = rule.Operand__c;
                
                //Code is used to override rule name with a custom description
                String ruleName = '';
                if(rule.Error_Text__c == '' || rule.Error_Text__c == null )
                	 ruleName = rule.Name;
                else
                	ruleName = rule.Error_Text__c;
                	
                Id objID;                               
                if(objectname=='EB_Loan_Packet__c'){
                        objID = packet.Id;
                }else if(objectname=='EB_Loan_Application__c'){
                        objID = app.Id;
                }// add eb_booked_loan_App__c
                
                String isValid = IsStageActionFieldValid(objID,objectName,fieldName,operator,operand,ruleName);                         
                if(isValid != ''){
                        invalidFields.Add(isValid);
                }
        	}
	        for(String s : invalidFields){
	                if(s != '') sReturn += s + sDelimiter;
	        }
	        try{
	                if(sReturn!='') sReturn = sReturn.substring(0, sReturn.length()-sDelimiter.length());
	        }catch(exception ex){
	                
	        }        
	        return sReturn;
        }
        @testVisible
        private String IsStageActionFieldValid(Id i, String obj, String fld, String operator, String operand, String rule){
                String query = 'SELECT ' + fld + ' FROM ' + obj + ' WHERE Id = ' + '\'' + i + '\' limit 1';
                sObject o = Database.query(query);              
                String fieldValue = String.valueOf(o.get(fld));
                if(fieldValue==null) fieldValue='';
                if(operand==null) operand='';
                
        //      debug_RecordLog('IsOperationValid: fieldValue='+fieldValue+' operand='+operand+' operation='+operator);
                if(EvaluateExpression(fieldValue, operator, operand)){
                        return '';
                }else{
                        return rule;
                }               
        }
        @testVisible
        private boolean EvaluateExpression(String operand1, String operation, String operand2){
                try{                    
                        double dOperand1 = 0;
                        double dOperand2 = 0;
                        if(operation == '='){
                                if(operand1 == operand2) return true;
                        }else if(operation == '<>'){
                                if(operand1 != operand2) return true;
                        }else if(operation == '<'){
                                 dOperand1 = double.valueOf(operand1);
                                 dOperand2 = double.valueOf(operand2);
                                if(dOperand1 < dOperand2) return true;
                        }else if(operation == '>'){
                                 dOperand1 = double.valueOf(operand1);
                                 dOperand2 = double.valueOf(operand2);
                                if(dOperand1 > dOperand2) return true;
                        }else if(operation == '>='){
                                dOperand1 = double.valueOf(operand1);
                                dOperand2 = double.valueOf(operand2);
                                if(dOperand1 >= dOperand2) return true;                      
                        }else if(operation == '<='){
                                dOperand1 = double.valueOf(operand1);
                                dOperand2 = double.valueOf(operand2);
                                if(dOperand1 <= dOperand2) return true;                      
                        }else if(operation == 'regex'){
                                Pattern cpattern = Pattern.compile(operand2);
                                Matcher cmatcher = cpattern.matcher(operand1);
                                return cmatcher.find();
                        }else if(operation == 'in'){
                                List<String> ins = operand2.split(',');
                                if(ins.size() > 0){                          
                                        for(String s : ins){
                                                if(s == operand1) return true;
                                        }
                                }
                        }else if(operation == 'not in'){
                                List<String> ins = operand2.split(',');
                                if(ins.size() > 0){                          
                                        for(String s : ins){
                                                if(s == operand1) return false;
                                        }
                                }
                        }                       
                }catch(Exception ex){
                        //something went wrong
                        //debug_RecordLog(ex.getMessage());                     
                }
                return false;
        }
        
        private static String  getServerUrl(){
                
            return Utility.getServerUrl();
        }
        
}