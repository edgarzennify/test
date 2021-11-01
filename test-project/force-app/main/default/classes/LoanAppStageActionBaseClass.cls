public virtual class LoanAppStageActionBaseClass{
	public String baseURL = '';
	String ObjectType = '';
    
    String withdrawnText = 'Withdrawn';
    String pendingApprovalText = 'Pending Approval';
    String underwritingText = 'Underwriting';
    protected String backOfficeModificationPendingApprovalText = 'Back Office Modification - Pending Approval';
    public String ddExplanationDefault = '#';
    public String ddApprovalPathDefault = '#';
    public String debugPrefix = '####';
    
    public String oneSignaturePathText = '1 Signature';
    public String twoSignaturePathText = '2 Signatures';
    public String rmPlusOnePathText = 'RM + 1';
    public String threeSignaturePathText = '3 Signatures';
    public String regionalLoanCommittee = 'Regional Loan Committee';
    public String regionalLoanCommitteeAndBoard = 'Regional Loan Committee & Board';
    public String executiveLoanCommittee = 'Executive Loan Committee';
    public String executiveLoanCommitteeAndBoard = 'Executive Loan Committee & Board';
    public String lossShareCommittee = 'Loss Share Committee';
    public String twoSignatureBoardPath = '2 Signatures & Board';
    public String threeSignatureBoardPath = '3 Signatures & Board';
    
    public String docApproval = 'Doc Approval';
    public String documentation = 'Documentation';
    public String documentationComplete = 'Documentation Complete';
    
    public Id appId;
    public String[] selectedReasons = new String[]{};
    
    public String err{get;set;}
    
    public EB_Loan_Application__c app{get;set;}
    public EB_Booked_Loan_App__c archivedapp{get;set;}
    public Agreement__c agmt{get;set;}
    public EB_Loan_App_Stage__c currentStage {get;set;}
    public EB_Stage_Action_Controller__c stageController {get;set;}
    public EB_Loan_Packet__c packet {get;set;}
    public String StageLogComment{get;set;}
    public Id ddNextStatusId {get;set;}
    public String ddExplanation {get;set;}
    public String ddApprovalPath {get;set;}
    public String ShowHideSubmitButton{get;set;}
    protected List<EB_Loan_App_Stage_Allowed_Action__c> allowedActions {get;set;}
    private EB_Loan_App_Stage__c nextStage {get;set;}
    protected EB_Loan_App_Stage__c pendingApprovalStage {get;set;}
    protected EB_Loan_App_Stage__c backOfficeModificationApprovalStage {get;set;}
        
    public String[] getSelectedReasons() {
        return selectedReasons;
    }  
    
    public void setSelectedReasons(String[] reasons) {
        this.selectedReasons = reasons;
    }
    
    //my krapp km
    private EB_Loan_App_Stage__c withdrawnStage {get;set;}
     
    public boolean EnableLogging = false;
    
    public boolean IsValidationRequired{
    	get{             
    		if(app != null && IsValidationRequired == null) {
                RecordType appType = Utility.recordTypeObject('EB_Loan_Application__c',app.recordTypeId);
                if((appType.name.tolowercase().contains('modification -') && appType.name.tolowercase() != 'modification - full') || appType.name == utility.NewGuidanceLineAdvance() ) 
                    IsValidationRequired = false;
                else
                    IsValidationRequired = true;
        	}
            
        	if(this.archivedapp != null) IsValidationRequired = true;
            if(agmt != null) IsValidationRequired = false;
            
        	return IsValidationRequired;
    	}
    	set;
    }
    
    public LoanAppStageActionBaseClass(){
    	Initialize(apexpages.currentpage().getparameters().get('id'));     
    }   
     
    public virtual void LoadObject(){
    	//must inherit
    }
    
    private List<EB_Loan_App_Stage__c> m_stages;
    
    protected EB_Loan_App_Stage__c GetStageByDescription(String stageDescription){
        if(m_stages == null){
            m_stages = [SELECT Id, Name FROM EB_Loan_App_Stage__c ORDER BY Name];
        }
        for(EB_Loan_App_Stage__c s : m_stages){
            if(s.Name == stageDescription){
                return s;
            }
        }
        return null;
    }
    
    private boolean IsAgreement{
    	get{
    		if(agmt != null){
    			return true;
    		}
    		return false;
    	}
    }
    
    public void Initialize(String queryParameter){
    	if(baseURL == '')  baseURL = getServerUrl();
    	appId = queryParameter;
        nextStage = null;
        
        if(appId != null){
            try{
            	LoadObject();

                this.stageController = this.currentStage.Loan_App_Stage_Action_Controller__r;
                this.allowedActions = [SELECT Id, Name, Type__c, Stage__r.Id, Stage__r.Name,Auto_Forward_Stage__r.Id,Auto_Forward_Stage__r.Name, (SELECT Id, Object_Name__c, Field_Name__c, New_Value__c FROM EB_Loan_App_Action_Field_Updates__r) FROM EB_Loan_App_Stage_Allowed_Action__c WHERE Controller__c =: this.stageController.Id AND Stage__r.Id !=: this.currentStage.Id ORDER BY Type__c, Stage__r.Sort_Order__c LIMIT 500];
                this.allowedActions = RemoveBackOfficeWhenAppropriate(this.allowedActions);
                this.pendingApprovalStage = GetStageByDescription(pendingApprovalText);//[SELECT Id FROM EB_Loan_App_Stage__c WHERE Name =: pendingApprovalText LIMIT 1];
                this.withdrawnStage = GetStageByDescription(withdrawnText);//[SELECT Id FROM EB_Loan_App_Stage__c WHERE Name =: withdrawnText LIMIT 1];
                if(IsAgreement){this.backOfficeModificationApprovalStage = GetStageByDescription(backOfficeModificationPendingApprovalText);}
                this.ddApprovalPath = this.packet.Actual_Approval_Path__c; 
                         
            }catch(exception ex){
                this.app = null;
                system.debug(debugPrefix + ex.getMessage());
            }
        }else{
            this.app = null;
        }
    }
    
    private List<EB_Loan_App_Stage_Allowed_Action__c>  RemoveBackOfficeWhenAppropriate(List<EB_Loan_App_Stage_Allowed_Action__c> allowed_Actions){
    	if(!IsAgreement){
	    	List<EB_Loan_App_Stage_Allowed_Action__c> allowedActionsWithoutBackOffice = new List<EB_Loan_App_Stage_Allowed_Action__c>(); 	
	    	for(EB_Loan_App_Stage_Allowed_Action__c action: allowed_Actions ){
	    		if(action.Stage__r.Name.contains('Back Office')){}
	   			else{
	    			allowedActionsWithoutBackOffice.add(action);
	    		}
	    	}
	    	return allowedActionsWithoutBackOffice;
    	}
    	return allowed_Actions;
    }
        
    public virtual List<SelectOption> getAllowedActions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(this.currentstage.Id,'-- Please select a status --'));
        
        for(EB_Loan_App_Stage_Allowed_Action__c aa: allowedActions){
        	options.add(new SelectOption(aa.Stage__r.Id,aa.Stage__r.Name));
        }
        return options;
    }
    
    public List<EB_Loan_App_Stage_Explanation__c> getStageExplanations(){
    	try{
            EB_Loan_App_Stage_Explanation__c testexplain = [SELECT Id, Name FROM EB_Loan_App_Stage_Explanation__c WHERE Loan_App_Stage__c =: ddNextStatusId AND Type__c =: NextStageType() ORDER BY Name LIMIT 500];
        }catch(exception ex) {
    		
    	}
        return [SELECT Id, Name FROM EB_Loan_App_Stage_Explanation__c WHERE Loan_App_Stage__c =: ddNextStatusId AND Type__c =: NextStageType() ORDER BY Name LIMIT 500];
    }
       
    public List<SelectOption> getStageExplanationOptions(){
        List<SelectOption> options = new List<SelectOption>();             
                
        for(EB_Loan_App_Stage_Explanation__c exp: getStageExplanations()){
                options.add(new SelectOption(exp.Name,exp.Name));
        }
                    
        return options;
    }
    
    public String getExplanationNeeded(){
        if(ExplanationNeeded() == true) return 'true';
        return 'false';
    }
    
    public String getButtonStatus(){
    	if(ExplanationNeeded()==true || ddNextStatusId != null) return 'true';
    	return 'false';
    }
    
    public Boolean ExplanationNeeded(){
        if(getStageExplanations().size() > 0) return true;
        return false;
    }
    
    //my krapp km
    public String getShowWithdrawnPanel(){
        if(WithdrawnSelected() == true) return 'true';
        return 'false';
    }
    
    public String getShowWithdrawnExplanation(){
        if(WithdrawnSelected() == true && ExplanationNeeded() == true) return 'true';
        return 'false';
    }
    
    private Boolean WithdrawnSelected(){
        if(ddNextStatusId == withdrawnStage.Id) return true;
        return false;
    }
   
    public String CommentsHelpText{
    	get{
    		if(WithdrawnSelected()){
    			return 'Please, include a brief comment related to why the application was withdrawn by the applicant.';
    		}else{
    			return EB_Loan_Application__c.Stage_Comment__c.getDescribe().getInlineHelpText();    			
    		}
    	}
    }   
    
    ////
    
    public String getShowPendingApprovalPanel(){
        if(PendingApprovalSelected() == true) return 'true';
        return 'false';
    }
    
    public virtual Boolean PendingApprovalSelected(){
    	if(ddNextStatusId == pendingApprovalStage.Id) return true;
        return false;
    }

    //////
    
    public Boolean UnderwritingSelected(){
        if(ddNextStatusId == GetStageByDescription(underwritingText).Id) return true;
        return false;
    }
      
    public String NextStageType(){
      for(EB_Loan_App_Stage_Allowed_Action__c aa: allowedActions){
      	   if(aa.Stage__r.Id == ddNextStatusId){
	          
	          return aa.Type__c;
	        }
        }
        return '';
    }
    
    public EB_Loan_App_Stage__c NextStage(){    	
        if(nextStage == null){
            List<EB_Loan_App_Stage__c> stage = [SELECT Id, Name, Stage_Selected_Email_Notifications__c,Email_Queue__c, (Select Id, Name, LastModifiedDate, Field_Name__c, Object_Name__c, Operand__c, Operation__c, Error_Text__c From EB_Loan_App_Stage_Validation_Rules__r ) FROM EB_Loan_App_Stage__c WHERE Id =: ddNextStatusId limit 1 ];
                
            if(stage.size() > 0) nextStage = stage[0]; 
        }        
        return nextStage;
    }
    
    public EB_Loan_App_Stage__c AutoForwardStage{
    	get{    		
            for(EB_Loan_App_Stage_Allowed_Action__c aa: allowedActions){		      	  
                if(aa.Stage__r.Id == ddNextStatusId){			          
                    if( aa.Auto_Forward_Stage__r.Id != null) 
                        return [SELECT id,Name FROM EB_Loan_App_Stage__c WHERE id =: aa.Auto_Forward_Stage__r.Id][0];
                }
            }
            return null;
    	}
    }
    
    public List<String> EmailNotificationList(){
        String roleList = NextStage().Stage_Selected_Email_Notifications__c;
        List<String> roles = GetSplitList(roleList);
        if(roles != null){
            if(roles.size() > 0) return EmailList(roles);
        }
        return null;     
    }
     
    public List<String> EmailQueueNotificationList(){
    	try{
            String queueList = NextStage().Email_Queue__c;
            
            List<String> queues = GetSplitList(queueList);
            List<String> emails = new List<String>();
            
            if(queues != null){
	            for(String que_ue : queues){
	                List<String> emailsFromQueue = GetEmailsFromQueue(que_ue);
	                for(String child : emailsFromQueue){
	                    emails.add(child);
	                }
	            }
            }
            if(emails.size() > 0) return emails;
    	}catch(exception ex){}
    	return null;
    }
    
    public List<String> GetEmailsFromQueue(String qu_eue){
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
    
    public List<String> GetSplitList(String DelimitedList){
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
    
    public virtual List<String> EmailList(List<String> roles){   
        List<String> Emails = new List<String>();
        return Emails;           
    }
    
    public String getQuotes(){
        return '"';
    }
        
	public void DoActionFieldUpdates(){
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
                    }else if(objectName=='EB_Booked_Loan_App__c'){
                        objID = archivedapp.Id;
                    }
                    else if(objectName=='Agreement__c'){
                        objID = agmt.Id;
                    }
					
                    
                    UpdateRecord(objID,objectName,fieldName,newValue);      
                }                	 
            }
        }              
    }
        
    public void UpdateRecord(Id i, String obj, String fld, String val){                     
        String query = 'SELECT ' + fld + ' FROM ' + obj + ' WHERE Id = ' + '\'' + i + '\' limit 1';
        sObject o = Database.query(query);
        o.put(fld,val);
        
        update o;
    }
     
    public virtual String ValidateForm(){
        return '';
    }
    
    protected virtual void Save(){
        
    }
    
    public virtual PageReference SaveClicked(){
        return null;
    }
    
    public PageReference CancelClicked(){
        return BackToMainAppPage();
    }
    
    public virtual PageReference GotoNextPage(){
        return BackToMainAppPage();
    }
    
    public PageReference BackToMainAppPage(){
        Id retId;
        
        if(appId != null){
            retId = appId;
        }
        
        String newPageUrl = baseURL + '/' + retId;  
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        
        return newPage;
    }
    
    protected virtual String SendEmailHelper(){
        return '';
    }
    
    public void SendEmail(String subject, String lastModifiedByName){
        try{
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
            email.setSubject(subject);            
            email.setReplyTo('no-reply@enterprisebank.com');
            email.setSaveAsActivity(false);         
            
            String Message = SendEmailHelper();
            if(NextStage().Name == 'Booking Complete') {
                try{
                    Message += '\nBooked by:' + lastModifiedByName;
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
                if(emailsFromQueue != null){
	                for(string em : emailsFromQueue){                    
	                    if(!emailMap.containskey(em)) emailaddresses.add(em);
	                }    
                }            
            }catch(exception ex){
                
            }
            
            if(emailAddresses != null){
                for(string s : emailAddresses){
                    Utility.debug_RecordLog('LoanAppStageActionBaseClass', s, '');
                }
            }
            
            if(emailaddresses != null && emailaddresses.size() > 0){             
                //uncomment these for production
                email.setToAddresses(emailaddresses);
                Messaging.SendEmailResult[] sendResult; 
                sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }      
        }catch(exception ex){}         
    }
    
    public void SubmitForApproval(){

	        Approval.Processsubmitrequest req1 = new Approval.Processsubmitrequest();
	        req1.setObjectId(this.app.Id);
	        Approval.Processresult result = Approval.process(req1);
    }
    
    public void AutoApproveWorkflow(){
    	List<ProcessInstance> currentApprovalInstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:appId ORDER BY CreatedDate DESC LIMIT 1];
		List<ProcessInstanceWorkitem> currentApprovalWorkItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: currentApprovalInstance.get(0).Id]; 
    	Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
    	req2.setWorkitemId(currentApprovalWorkItem.get(0).Id);
		req2.setComments('');
		req2.setAction('Approve');    
		Approval.ProcessResult result2 =  Approval.process(req2);
    }
    
    public void RecallApprovalRequest(){

    		List<ProcessInstance> currentApprovalInstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId=:appId ORDER BY CreatedDate DESC LIMIT 1];
    		List<ProcessInstanceWorkitem> currentApprovalWorkItem = [SELECT Id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: currentApprovalInstance.get(0).Id]; 
	    	Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
	    	req2.setWorkitemId(currentApprovalWorkItem.get(0).Id);
			req2.setComments('');
			req2.setAction('Removed');    
			Approval.ProcessResult result2 =  Approval.process(req2);			
    }
    
    public PageReference Bogus(){
        return null;
    }
        
    public String StageActionValidation(){                 
        List<String> invalidFields = New List<String>();
        String sReturn = '';
        String sDelimiter = ' / ';
        system.debug('##:StageActionValidation 1');
        if(IsValidationRequired){
            for(EB_Loan_App_Stage_Validation_Rule__c rule : NextStage().EB_Loan_App_Stage_Validation_Rules__r){             
                String objectName = rule.Object_Name__c;
                String fieldName = rule.Field_Name__c;                  
                String operator = rule.Operation__c;
                String operand = rule.Operand__c;
                system.debug('##:StageActionValidation 2');
                //Code is used to override rule name with a custom description
                String ruleName = '';
                if(rule.Error_Text__c == '' || rule.Error_Text__c == null )
                    ruleName = rule.Name;
                else
                    ruleName = rule.Error_Text__c;
                
                Id objID = null; 
                system.debug('##:StageActionValidation 3');                              
                if(objectname=='EB_Loan_Packet__c'){
                    objID = packet.Id;
                }else if(objectname=='EB_Loan_Application__c'){
                    objID = app.Id;
                }else if(objectname=='EB_Booked_Loan_App__c'){
                    objID = app.Id;
                }
                
                system.debug('##:StageActionValidation 4');
                if(objID != null){
                    String isValid = IsStageActionFieldValid(objID,objectName,fieldName,operator,operand,ruleName);                         
                    system.debug('##:StageActionValidation 5');
                    if(isValid != ''){
                        invalidFields.Add(isValid);
                    }
                }
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
        
    public String IsStageActionFieldValid(Id i, String obj, String fld, String operator, String operand, String rule){
        try{
            String query = 'SELECT ' + fld + ' FROM ' + obj + ' WHERE Id = ' + '\'' + i + '\' limit 1';
            sObject o = Database.query(query);              
            String fieldValue = String.valueOf(o.get(fld));
            if(fieldValue==null) fieldValue='';
            if(operand==null) operand='';
            Boolean isValid = EvaluateExpression(fieldValue, operator, operand);
            system.debug('###EvaluateExpression()=' + isValid);
            if(isValid == true){
                return '';
            }else{
                return rule;
            }   
        }catch(exception ex){
            
        }  
        return '';
        //debug_RecordLog('IsOperationValid: fieldValue='+fieldValue+' operand='+operand+' operation='+operator);
    }
    
    public boolean EvaluateExpression(String operand1, String operation, String operand2){
        system.debug('###EvaluateExpression()');
        system.debug('####operand1=' + operand1);
        system.debug('####operation=' + operation);
        system.debug('####operand2=' + operand2);
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
                   
        }
        return false;
    }
        
    public static String  getServerUrl(){
        return Utility.getServerUrl();
    }
    
}