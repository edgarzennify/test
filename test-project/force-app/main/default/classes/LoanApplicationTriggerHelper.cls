public class LoanApplicationTriggerHelper {
	// top-level calls from trigger...
	public void doBeforeInsert(List<EB_Loan_Application__c> newList, Map<Id, EB_Loan_Application__c> newMap){
    	initializeStage(newList);
        updateRMandLCEmailAddress(newList);
    }
    public void doAfterInsert(List<EB_Loan_Application__c> newList, Map<Id, EB_Loan_Application__c> newMap){
    	recordEBLoanAppStageLog(newList, false);
    	autoInsertLoanFees(newList);
        
    }
    public void doBeforeUpdate(List<EB_Loan_Application__c> oldList, List<EB_Loan_Application__c> newList, Map<Id, EB_Loan_Application__c> newMap){
    	beforeUpdateMaintenance(newList);
        updateRMandLCEmailAddress(newList);
    }
    public void doAfterUpdate(List<EB_Loan_Application__c> oldList, List<EB_Loan_Application__c> newList, Map<Id, EB_Loan_Application__c> newMap){
   		recordEBLoanAppStageLogIfStageChanged(newList);
    }
    ///////////////////////////////////////////////////////////////////////
    
    private void autoInsertLoanFees(list<EB_Loan_Application__c> newList){
		RecordType recordTypeNew = utility.recordTypeObject('EB_Loan_Application__c','New');
		if(recordTypeNew != null){
			List<EB_Loan_Fee__c> newFeeList = new List<EB_Loan_Fee__c>();
			for(EB_Loan_Application__c app : newList){
				if(app.Business_Purpose__c=='Yes'){
    				if (app.RecordTypeId==recordTypeNew.Id){
    	 	 			newFeeList.add(recordLoanFee(app,'Loan',250,'Paid in Cash','Enterprise Bank & Trust'));
    	 	 		}else{
    	 	 			newFeeList.add(recordLoanFee(app,'Renewal Fee',250,'Paid in Cash','Enterprise Bank & Trust'));	
    	 			}				
				}
			}
			if(newFeeList.size() > 0) insert newFeeList;
		} 	
    }
    	
    private EB_Loan_Fee__c recordLoanFee(EB_Loan_Application__c newApp, String TypeOfFee , Double FeeAmount, String FeeHandling, String PayableTo ){
  		EB_Loan_Fee__c loanFee = new EB_Loan_Fee__c();
		loanFee.Loan_Application__c = newApp.id;
		loanFee.Type_of_Fee__c = TypeOfFee;
		loanFee.Fee_Amount__c=FeeAmount;
		loanFee.Fee_Handling__c = FeeHandling;
		loanFee.Payable_To__c = PayableTo;

	   	return loanFee;
    }
    
    public static Map<String,EB_Loan_App_Stage__c> m_loanAppStages{
    	get{
    		if(m_loanAppStages == null){
				m_loanAppStages = new Map<String,EB_Loan_App_Stage__c>();
				List<EB_Loan_App_Stage__c> stages = [SELECT Id, Name, Stage_Selected_Email_Notifications__c FROM EB_Loan_App_Stage__c];
				for(EB_Loan_App_Stage__c stage : stages){
					m_loanAppStages.put(stage.Name, stage);
				}
    		}
    		return m_loanAppStages;
    	}
    	set;
    }
    
	private void updateRMandLCEmailAddress(List<EB_Loan_Application__c> newApps){
		Map<Id,Id> packetIds = new Map<Id,Id>();
		
		for(EB_Loan_Application__c appl : newApps){
		  packetIds.put(appl.Id, appl.EB_Loan_Packet__c);
		}
		
		Map<Id,EB_Loan_Packet__c> packets = new Map<Id,EB_Loan_Packet__c>([SELECT Id, Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email, Loan_Coordinator__r.User__r.Email FROM EB_Loan_Packet__c WHERE Id IN: packetIds.values()]);
		
		for(EB_Loan_Application__c appl : newApps){
			if(appl.EB_Loan_Packet__c != null){ 
				EB_Loan_Packet__c pack = packets.get(appl.EB_Loan_Packet__c);
				appl.RM_Email_Address__c = pack.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email;
				appl.Loan_Coordinator_Email_Address__c = pack.Loan_Coordinator__r.User__r.Email;
			}
		} 
	}
   
    public static EB_Loan_App_Stage__c newLoanAppStage{
    	get{
    		return m_loanAppStages.get('New');
    	}
    }
    
       
    private void initializeStage(List<EB_Loan_Application__c> newList){
    	for(EB_Loan_Application__c app : newList){
        	app.Application_Stage__c = m_loanAppStages.get('New').Id;//stage[0].Id;
        }
    }
    
    private void beforeUpdateMaintenance(List<EB_Loan_Application__c> newList){
        try{   
        	//TWEAKED to make a since call in a trigger
		    List<String> hoepaEmailList = getEmailsFromQueue('HOEPA');            
		    
		    List<EB_Loan_Application__c> appsForMinutes = new List<EB_Loan_Application__c>();
			for(EB_Loan_Application__c app : newList){
				if(app.Approved_by_SFDC_Approval_Process__c == true && m_loanAppStages.containskey('Approved')){
					EB_Loan_App_Stage__c approvedStage = m_loanAppStages.get('Approved');
	                app.Application_Stage__c = approvedStage.Id;
	                app.Approved_by_SFDC_Approval_Process__c = false;
	                //appsForMinutes.add(app);
	                handleApprovedEmails(app.Id, approvedStage.Stage_Selected_Email_Notifications__c, 'Approved');
	                if(app.Possible_TDR__c=='Yes'){
	                    SendEmailForTDR(app);
	                }
	                //set loan number
	                String NewLoanNumber = LoanApplicationViewController.GetNewLoanNumber(app); 
	                if(NewLoanNumber != '') app.Account_Number_Assigned__c = NewLoanNumber;
	            }
			    
			    if(app.Rejected_by_SFDC_Approval_Process__c == true && m_loanAppStages.containskey('Denied')){
	                app.Application_Stage__c = m_loanAppStages.get('Denied').Id;
	                app.Rejected_by_SFDC_Approval_Process__c = false;
	                //HandleApprovedEmails(app.Id, approveStage[0].Stage_Selected_Email_Notifications__c , 'Rejected');
			    }
		    
			    if(app.Set_App_to_New__c == true && m_loanAppStages.containskey('New')){
	                app.Application_Stage__c = m_loanAppStages.get('New').Id;
	                app.Set_App_to_New__c = false;
			    }
			    
			    //Send HOEPA email
			    if(app.Application_Stage__c == m_loanAppStages.get('Approved').Id){
	                sendHOEPAEmail(app,hoepaEmailList);                   
			    }
		    
			    //Automatically send Documentation Complete to Booking
			    if(app.Application_Stage__c == m_loanAppStages.get('Documentation Complete').Id ){
	                RecordEBLoanAppStageLog(app, true);
	                app.Application_Stage__c = m_loanAppStages.get('Booking').Id;                 
	                app.Stage_Explanation__c = '';
			    }
		    }
        }catch(exception ex){
            System.debug('/////beforeUpdateMaintenance: Exception:' + ex);
        }       
	}
    
    private void sendHOEPAEmail(EB_Loan_Application__c app, List<String> emails){
		String serverurl = Utility.getServerUrl() + '/';
        if(app.Is_HOEPA__c == 'Yes') {
            if (app.Is_HOEPA_email_sent__c == false){
                app.Is_HOEPA_email_sent__c = true;
                if(emails != null ){
                    if(emails.size()> 0){
                        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
                        email.setSubject('Loan Application HOEPA alert - ' + app.Name );        
                        email.setReplyTo('no-reply@enterprisebank.com');
                        email.setSaveAsActivity(false); 
                        String Message ='Click the following link to view the loan application: \n'
                            + serverurl + String.valueOf(app.Id); 
                        email.setPlainTextBody(Message);
                        email.setToAddresses(emails);
                        Messaging.SendEmailResult[] sendResult; 
                        try{
                                 sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                        }catch(exception ex){
                            
                        }
                    }
                }
            }
        }
    }
    
    private void handleApprovedEmails(Id appid, String roleList, String stage){
    	List<EB_Loan_Application__c> currentApp =  [SELECT 
                                                        Id, Name, Approval_Path__c, TDR_Determination_One__c , TDR_Determination_Two__c , 
                                                        Application_Stage__c, Application_Stage_Reportable__c, Stage_Explanation__c, 
                                                        Approver_One__c, Approver_Two__c, Approver_Three__c, Application_Stage__r.Name, 
                                                        Application_Stage__r.Loan_App_Stage_Action_Controller__r.Id, Bank_Owned_Loan_Amount__c, 
                                                        EB_Loan_Packet__r.Actual_Approval_Path__c, EB_Loan_Packet__r.Lead_Entity__r.Name, 
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email,
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Name, 
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email,
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Name, 
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email,
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name, 
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id, 
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email,
                                                        EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name, 
                                                        EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email, EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Name, 
                                                        EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email, EB_Loan_Packet__r.Credit_Analyst__r.User__r.Name,
                                                        EB_Loan_Packet__r.Override_Lender__r.User__r.Email, EB_Loan_Packet__r.Override_Lender__r.User__r.Name,
                                                        DocumentationRep__r.User__r.Email, DocumentationRep__r.User__r.Name, 
                                                        Application_Stage__r.Stage_Selected_Email_Notifications__c  
                                                    FROM EB_Loan_Application__c WHERE Id =: appId limit 1];
        List<String> emailAddresses = emailNotificationList(roleList, currentApp[0]);
        sendEmail(emailAddresses, stage, currentApp[0]);
    }
    
    private void sendEmailForTDR(EB_Loan_Application__c app){
	    String serverurl = Utility.getServerUrl() + '/';

        List<String> tdrEmails = getEmailsFromQueue('TDR Notifications');
            
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        email.setSubject('Possible TDR - ' + app.Name );          
        email.setReplyTo('no-reply@enterprisebank.com');
        email.setSaveAsActivity(false);     
        
        String Message = 
            app.Name + 
	    	' has been indicated as a possible TDR. ' +
	    	'Click the following link to view the application: \n' +
	        serverurl + String.valueOf(app.Id); 
                        
        email.setPlainTextBody(Message);
        email.setToAddresses(tdrEmails);
        Messaging.SendEmailResult[] sendResult; 
        
        try{
            sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }catch(exception ex){
            System.debug('/////sendEmailForTDR: Exception:' + ex);
        }       
    }
    
    private void sendEmail(List<String> emailAddresses, String stage, EB_Loan_Application__c app){
    	String serverurl = Utility.getServerUrl() + '/';
        if(app == null || emailAddresses == null) return;
        String overrideLender = app.EB_Loan_Packet__r.Override_Lender__r.User__r.Name;
        String relationshipManager = app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name;
        String loanCoordinator = app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Name;
        String creditAnalyst = app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Name;
        String documentationRep = app.DocumentationRep__r.User__r.Name;
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        email.setSubject('Loan Application Status Update - ' + app.Name + ' - ' + stage);           
        email.setReplyTo('no-reply@enterprisebank.com');
        email.setSaveAsActivity(false);        
        String Message = 'The following loan application has moved to the ' 
                         + stage + ' stage. '
                         + 'Click on the link below to view additional details.'
                         + '\n\nLead Entity: ' + app.EB_Loan_Packet__r.Lead_Entity__r.Name
                         + '\n' + app.name
                         + '\nActual Approval Path: '+ app.Approval_Path__c
                         + '\nTDR Determination 1: ' + app.TDR_Determination_One__c
                         + '\nTDR Determination 2: ' + app.TDR_Determination_TWo__c + '\n' 
                         + '\nLoan Amount: '+ String.valueOf(app.Bank_Owned_Loan_Amount__c)
                         + '\nLink to Application: ' + serverurl + String.valueOf(app.Id)
                         + '\nPrimary RM: ' + relationshipManager
                         + ((overrideLender!=null) ? '\nOverride Lender: ' + overrideLender : '')
                         + '\nLoan Coordinator: ' + ((loanCoordinator==null) ? '' : loanCoordinator)
                         + '\nCredit Analyst: ' + ((creditAnalyst==null) ? '' : creditAnalyst)
                         + '\nDocumentation Rep: ' + ((documentationRep==null) ? '' : documentationRep);
        if(stage == 'Booked') {
            User lastModifiedUser = m_users.get(app.LastModifiedById);//[SELECT id, Name FROM User WHERE id =: app.LastModifiedById];
            Message += '\nBooked by:' + lastModifiedUser.Name;
        }
        email.setPlainTextBody(Message);       
        
        if(emailAddresses != null){         
            //send to rajiv for testing. comment these lines out
            /*List<String> toAddresses = new List<String>();
            toAddresses.add('rupadhya@enterprisebank.com');
            email.setToAddresses(toAddresses);
            Messaging.SendEmailResult[] sendResult; 
            sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });*/
               
            //uncomment these for production
            email.setToAddresses(emailAddresses);
            Messaging.SendEmailResult[] sendResult; 
            try{
            	sendResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }catch(exception ex){
                
            }
        }       
    }
    
     private List<String> emailNotificationList(String roleList, EB_Loan_Application__c app){
        if(roleList != null){
            List<String> roles = new List<String>();
            try{
                roles = roleList.split(';');
            }catch(exception ex){
                roles = null;
            }
            if(roles != null){
                if(roles.size() > 0) return emailList(roles, app);
            }
        }
        return null;     
    } 
    
    public List<String> emailList(List<String> roles, EB_Loan_Application__c app){   
        List<String> emails = new List<String>();
         
        for(String r : roles){
            if(r == 'Coordinator'){  //Packet
                if(app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email != null) 
                    emails.add(app.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email);
            }else if(r == 'Credit Analyst'){
                if(app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email != null) 
                    emails.add(app.EB_Loan_Packet__r.Credit_Analyst__r.User__r.Email);
            }else if(r == 'Documentation Rep'){
                if(app.DocumentationRep__r.User__r.Email != null) 
                    emails.add(app.DocumentationRep__r.User__r.Email);
            }else if(r == 'Relationship Manager'){  //Lead entity
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email != null) 
                    emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email);
            }else if(r == 'WM Advisor'){
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email != null) 
                    emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email);
            }else if(r == 'TM Rep'){
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email != null) 
                    emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email);
            }else if(r == 'Secondary Officer'){
                if(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email != null) 
                    emails.add(app.EB_Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email);
            }else{
                
            }
        }
        return emails;       
    }
    
    private void buildLoanAppMinutes(EB_Loan_Application__c app){
        List<EB_Loan_App_Minute__c> insertMinutes = new List<EB_Loan_App_Minute__c>();
        EB_Loan_App_Minute__c minute = new EB_Loan_App_Minute__c();
                
        //Loan Snapshot
        minute.EB_Loan_Application__c = app.Id;
        minute.Document_Type__c = utility.RecordTypeObject('EB_Loan_Application__c',app.RecordTypeId).Name;//this.getRecordTypeNameorId(app.RecordTypeId, '' , false).Name;
        minute.Type_of_Snapshot__c = 'Approval Minute';
        if(app.RecordTypeId == utility.RecordTypeObject('EB_Loan_Application__c','Renewal').Id){
            minute.Loan_Number__c = app.Account_Number__r.Name; // change this with formula
        }          
        minute.Relationship_Manager__c = app.RM__c;
        minute.Request_Date__c = app.CreatedDate;
        minute.Credit_Analyst__c = app.Credit_Analyst__c;
        Datetime dT = System.now();
        Date d = date.newinstance(dT.year(), dT.month(), dT.day()); 
                
        minute.Decision_Date__c = d;
        minute.Original_Maturity_Date__c = app.Original_Maturity_Date__c;
        minute.Maturity_Date__c = app.Maturity_Date__c;
        minute.Unit__c = app.Unit__c;
        minute.Lead_Entity__c = app.Lead_Entity__c;
        minute.Decision__c = 'Approved';
        minute.Type_of_Loan__c = app.Loan_Type__c;
        minute.Loan_Amount__c = app.Total_Loan_Amount__c;
        minute.Credit_Rating__c = app.Credit_Rating__c;
        minute.Loan_Doc_Comments__c = app.Loan_Doc_Comments__c;
                          
        //minute.Rate_Type__c = app.Rate_Type__c;
		//minute.Rate_Index__c = app.Rate_Index__c;
        //minute.Index_Rate_at_Time_of_Decision__c = app.Current_Index_Rate__c; //change this with formula
        //minute.Rate_Index_Variance__c = app.Rate_Variance__c;
        //minute.Return_on_Equity__c = app.
        //minute.Industry_Code__c = app.industry;            
                
        //System Requirement
        minute.Total_Lendable_Equity__c = app.Total_Lendable_Equity__c;
        minute.Total_Liquid_Assets__c = app.Total_Liquid_Assets__c;
        minute.Total_Participation_Amount__c = app.Participations_Total__c;
        minute.Total_Net_Worth__c = app.Total_Net_Worth__c;
        
        minute.Number_Payment_Stream_Months__c = app.Payment_Stream_Months__c;
        
        //Number of Borrower,Collateral and Payment Stream

        for(sObject  a :  [SELECT  count(Id) NumOfBorrowers FROM EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: app.Id GROUP BY Loan_Application_ID__c]){
            minute.Number_of_Related_Borrowers__c = double.valueOf(a.get('NumOfBorrowers'));
        }
        for(sObject  a :  [SELECT  count(Id) NumOfCollaterals FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Loan_Application_ID__c =: app.Id GROUP BY EB_Loan_Application_ID__c]){
            minute.Number_of_Related_Collateral__c = double.valueOf(a.get('NumOfCollaterals'));
        }
            
        // Signature /committie detail
        minute.Approval_Path__c = app.Approval_Path__c;
        
        if(app.Approval_Path__c == '2 Signatures' || app.Approval_Path__c == '3 Signatures' || app.Approval_Path__c == 'Doc Approval'){
            RecordType signerrtype =  utility.RecordTypeObject('EB_Loan_App_Minute__c','Signature');//this.getRecordTypeNameorId(null, 'Signature', true);
            minute.RecordTypeId = signerrtype.Id;
            minute.Requirements__c = '--Refresh page to see comment--';//loanapplicationtriggerhelper.getCommentsForWorkFlow(app.Id);
            minute.Signers__c = this.getSigners(app.Id);
        }else if(app.Approval_Path__c != null){
            RecordType CommitteeType = utility.RecordTypeObject('EB_Loan_App_Minute__c','Committee');//this.getRecordTypeNameorId(null, 'Committee', true);
            minute.RecordTypeId = CommitteeType.Id;            
            minute.Requirements__c = '--Refresh page to see comment--'; //loanapplicationtriggerhelper.getCommentsForWorkFlow(app.Id);
            
            minute.Signers__c = this.getSigners(app.Id);
        }
        
        insertMinutes.add(minute); 
        
        if(insertMinutes.size() > 0){
            insert insertMinutes;  
        }
        
        for(EB_Loan_App_Minute__c m : insertMinutes){
            LoanApplicationTriggerHelper.callSFDCServiceURL(m.ID);
            processminute(m.Id); 
        }
    }

    @future()
    private static void processMinute(Id minuteId){
        EB_Loan_App_Minute__c minute = [SELECT Id, requirements__c, EB_Loan_Application__c FROM EB_Loan_App_Minute__c where id =: minuteId];
        minute.requirements__c = LoanApplicationTriggerHelper.getCommentsForWorkFlow(minute.EB_Loan_Application__c);
        update minute;
    }
    
    public static HttpResponse calloutResponse(String idlong){
        
        idlong = utility.convertid15ToId18(idlong);
        
        HttpRequest req = new HttpRequest();
 		
        String url = 'https://app.enterprisebank.com/SFDCService/Service.asmx/GenerateLoanAppSnapshotForMinute?minuteId=' + idlong;
        
        req.setEndpoint(url);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = new HttpResponse();
        try{
        	 res = http.send(req);
            
        }catch(exception ex){
        }
        return res;
        
        
    }
    @future(callout=true)
    public static void callSFDCServiceURL(String idlong){
        GlobalVar__c gv = GlobalVar__c.getOrgDefaults();
        if(gv.IsSandbox__c || Test.isRunningTest()){
        	HttpResponse res = CalloutResponse(idlong);
        }
        else{
            Restutility.GenerateLoanApplicationSnapshot(idlong);
        }
            
    }

    private static String getCommentsForWorkFlow(Id LoanAppId){
        String Comments = '';    
        
        List<ProcessInstance> pinstance1 = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: LoanAppId  order by CreatedDate desc limit 1];
        //List<ProcessInstance> pinstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: LoanAppId  order by CreatedDate desc limit 1];
        if(pinstance1.size() > 0){
            //List<ProcessInstanceStep> approvalitems = [ SELECT Id, Comments, StepStatus FROM ProcessInstanceStep WHERE   ProcessInstanceId =: pinstance1[0].Id   order by createddate desc];
        
            for(ProcessInstanceStep s : [ SELECT Id, Comments, StepStatus FROM ProcessInstanceStep WHERE   ProcessInstanceId =: pinstance1[0].Id   order by createddate desc]){
                if(s.Comments != null )
                  Comments = Comments + s.Comments + ',';
                else
                   Comments = Comments + ' ';
                               
            }
        }
        
        return Comments;
    }
    
    private String getSigners(Id LoanAppId){
        String Signers = '';
        List<EB_Loan_Application__c> loanapp = [SELECT Id, Approver_One__r.alias , Approver_Two__r.alias , Approver_Three__r.alias FROM EB_Loan_Application__c WHERE Id =: LoanAppID limit 1];
        if(loanapp.size() > 0 ){
            String signerone = loanapp[0].Approver_One__r.alias;
            String signertwo = loanapp[0].Approver_Two__r.alias;
            String signerthree = loanapp[0].Approver_Three__r.alias;            
            
            if(signerone != null) Signers += signerone + ';';
            if(signertwo != null) Signers += signertwo + ';';
            if(signerthree != null) Signers += signerthree + ';';
        }
		return Signers;
    }
    
    private void recordEBLoanAppStageLog(EB_Loan_Application__c app , Boolean recordStageExplanation){
    	List<EB_Loan_Application__c> appList = new List<EB_Loan_Application__c>();
    	appList.add(app);
    	RecordEBLoanAppStageLog(appList, recordStageExplanation);
    }
    
    private void recordEBLoanAppStageLog(List<EB_Loan_Application__c> newList , Boolean recordStageExplanation){
    	List<EB_Loan_Application_Stage_Log__c> stagelogs = new List<EB_Loan_Application_Stage_Log__c>();
        for(EB_Loan_Application__c app : newList){            
            if(app.Application_Stage__c != null){
            	EB_Loan_Application_Stage_Log__c loanstage = new EB_Loan_Application_Stage_Log__c();
                loanstage.EB_Loan_Application__c = app.Id;
                loanstage.Explanation__c = app.Stage_Explanation__c;
            	loanstage.EB_Loan_Application_Stage__c = app.Application_Stage__c;
                loanstage.stage_text__c = app.Application_Stage_Reportable__c;
                loanstage.Comment__c = app.Stage_Comment__c;
                stagelogs.add(loanstage);
            }
        }
        if(stagelogs.size() > 0){
        	insert stagelogs;
        }
        
        for(EB_Loan_Application_Stage_Log__c stageLog : stagelogs){
            if(recordStageExplanation == true){
                putExplanationInStageLogExplanation(stagelog.EB_Loan_Application_Stage__c, stageLog.Explanation__c, stageLog.Comment__c,stageLog.Id);
            }
        }
    }
    
    private void recordEBLoanAppStageLogIfStageChanged(List<EB_Loan_Application__c> newList){
        List<EB_Loan_Application_Stage_Log__c> stagelogs = new List<EB_Loan_Application_Stage_Log__c>();
        Map<Id, EB_Loan_Application_Stage_Log__c> appsLastStage = new Map<Id, EB_Loan_Application_Stage_Log__c>();
        
        List<EB_Loan_Application_Stage_Log__c> stages = [SELECT Id, Stage_Text__c, EB_Loan_Application__c FROM EB_Loan_Application_Stage_Log__c WHERE EB_Loan_Application__c IN: newList ORDER BY EB_Loan_Application__c, CreatedDate DESC];
        for(EB_Loan_Application_Stage_Log__c stage : stages){
        	if(!appsLastStage.containsKey(stage.EB_Loan_Application__c)){
        		appsLastStage.put(stage.EB_Loan_Application__c,stage);
        	}
        }
        
        for(EB_Loan_Application__c app : newList){
        	EB_Loan_Application_Stage_Log__c lastStageRecorded = appsLastStage.get(app.Id);
        	if(app.Application_Stage_Reportable__c != lastStageRecorded.Stage_Text__c){
        		EB_Loan_Application_Stage_Log__c loanstage = new EB_Loan_Application_Stage_Log__c();
                loanstage.EB_Loan_Application__c = app.Id;             
                loanstage.EB_Loan_Application_Stage__c = app.Application_Stage__c;
                loanstage.stage_text__c = app.Application_Stage_Reportable__c;
                loanstage.Explanation__c = app.Stage_Explanation__c;
                loanstage.Comment__c = app.Stage_Comment__c;
                stagelogs.add(loanstage);
        	}
        }
        
        if(stagelogs.size() > 0){
            insert stagelogs;
        }
        
        for(EB_Loan_Application_Stage_Log__c lg : stagelogs){
            putExplanationInStageLogExplanation(lg.EB_Loan_Application_Stage__c ,lg.Explanation__c, lg.Comment__c , lg.id);
        }
      
        for(EB_Loan_Application__c a : newList){
            if(a.Create_Minute__c==true){
                BuildLoanAppMinutes(a);
            }
        }
    }
    
    private void putExplanationInStageLogExplanation(Id AppStage ,String Explanation,String comment, Id stageid){
        List<Loan_App_Stage_Explanation__c> insertlistexpl = new List<Loan_App_Stage_Explanation__c>();
		    
        if(Explanation != null){
            List<String>  explanations = new List<String>();//=   lg.Explanation__c.split(';');
		    String explain = Explanation;

		    if(explain.contains(';')){
		    	explanations =   explain.split(';');
            }else{
                explanations.add(explain);
            }		   
		  
		    for(String s : explanations){
		    	//create a new stage log explanation
		        //fill all the fields and insert
		        //To get type parse explanation and check if it is non-first pass
		        Loan_App_Stage_Explanation__c lnappstagexpl=new Loan_App_Stage_Explanation__c();
		        lnappstagexpl.Loan_App_Stage_Log__c=stageid;
		        lnappstagexpl.Explanation__c=s;
		        lnappstagexpl.Comment__c = comment;
		        String slowercase = s.toLowerCase();
		        lnappstagexpl.Type__c = m_fpqIndicatorMap.get(AppStage + lnappstagexpl.Explanation__c);
                /* if(slowercase.contains('no error') ==true || slowercase.contains('rush') ==true) 
                lnappstagexpl.Type__c = 'Non-First Pass Quality';
                else
                lnappstagexpl.Type__c = 'First Pass Quality';
                */
		        insertlistexpl.add(lnappstagexpl);
		    }
        }		 
		if(insertlistexpl.size() > 0 )  insert insertlistexpl;
    }
    
	private List<String> getEmailsFromQueue(String queueName){
	    List<User> users = m_queueMembers.get(queueName);
	    List<String> emails = new List<String>();
	    for(User u : users){
	        emails.add(u.email);
	    }
	    
	    return (emails==null) ? null : emails;
	}
	
	private Map<string,string> m_fpqIndicatorMap{
        get{
            if(m_fpqIndicatorMap == null){
                m_fpqIndicatorMap = new Map<String,String>();
                for(EB_Loan_App_Stage_Explanation__c stage : [SELECT id, name, FPQ_Type__c,Loan_App_Stage__c FROM EB_Loan_App_Stage_Explanation__c ]){
                    m_fpqIndicatorMap.put(stage.Loan_App_Stage__c+stage.name ,stage.FPQ_Type__c );
                    system.debug(stage.Loan_App_Stage__c+stage.name + ' : ' + stage.FPQ_Type__c);
                }
            }
            return m_fpqIndicatorMap;
        }
        set;
    }
    
	private static Map<String,Group> m_queues{
	    get{
	        if(m_queues == null){
	            m_queues = new Map<String,Group>();
	            List<Group> queues = [SELECT g.Type, g.Id, g.Name, (SELECT UserOrGroupId FROM GroupMembers) FROM Group g WHERE g.Type =: 'Queue'];
	            for(Group q : queues){
	                m_queues.put(q.Name, q);
	            }
	        }
	        return m_queues;
	    }
	    set;
	}
	
	private static Map<Id,User> m_users{
		get{
			if(m_users == null){
				m_users = new Map<Id,User>([SELECT Id, Name, Email FROM User]);
			}
			return m_users;
		}
		set;
	}
	
	private static Map<String,List<User>> m_queueMembers{
		get{
			if(m_queueMembers == null){
				m_queueMembers = new Map<String,List<User>>();
				for(Group queue : m_queues.values()){
					if(!m_queueMembers.containsKey(queue.Name)){
						m_queueMembers.put(queue.Name,new List<User>());
					}
					for(GroupMember member : queue.GroupMembers){
						m_queueMembers.get(queue.Name).add(m_users.get(member.UserOrGroupId));
					}
				}				
			}
			return m_queueMembers;
		}
		set;
	}
    
    // Unit tests are in LoanApplicationTriggerHelperTester
}