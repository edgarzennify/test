trigger MinuteTrigger on EB_Loan_App_Minute__c (before insert) {
	try{
	for(EB_Loan_App_Minute__c min : trigger.new){
		
			
		/*List<ProcessInstance> pinstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: min.EB_Loan_Application__c  order by CreatedDate desc limit 1];
		//List<ProcessInstance> pinstance = [SELECT Id FROM ProcessInstance WHERE TargetObjectId =: LoanAppId  order by CreatedDate desc limit 1];
		if(pinstance.size() > 0){
			
			//List<ProcessInstanceStep> approvalitems = [ SELECT Id, Comments, StepStatus, ProcessInstanceId, createddate FROM ProcessInstanceStep WHERE  ProcessInstanceId =: pinstance[0].Id   order by createddate desc limit 500];
			//Integer counter = 0;
			for(integer i=0; i<6; i++){
			for(ProcessInstanceStep s : [ SELECT Id, Comments, StepStatus, ProcessInstanceId, createddate FROM ProcessInstanceStep WHERE  ProcessInstanceId =: pinstance[0].Id   order by createddate desc limit 1]){
				if(s.Comments != null )
				  min.Requirements__c = s.Comments;
				else
					min.Requirements__c = 'N/A';
				
			}
			}
		}*/
       
        EB_Loan_Application__c app = [SELECT Id, Create_Minute__c FROM EB_Loan_Application__c WHERE ID =: min.EB_Loan_Application__c];
		 if(app.Create_Minute__c == true) {app.Create_Minute__c = false; update app;}
		
		
	}
	}catch(exception ex){
		
	}
}