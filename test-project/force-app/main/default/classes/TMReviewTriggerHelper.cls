public class TMReviewTriggerHelper {
	public void updateLastTMReview(Task task){
		System.assert(task !=null);
               
            	if(task.Subject == 'TM Review'){
            		
            		ID acctid = null;
            		acctid = task.AccountId;
            		
            		Account account = null;
            		account = [SELECT Id, Last_TM_Review__c FROM Account WHERE Id = :acctid limit 1];
					if(account != null){
            			//datetime t = System.now();
            			//account.Last_TM_Review__c = Date.newInstance(1900,1,1); //datet.parse('1/1/1900'+' 00:00:00');
            			account.Last_TM_Review__c = task.ActivityDate;
            			update account;
					}

              
            }
	}
	public static testMethod void verifyTMReviewTriggerCode(){
		
		test.startTest();
		
		Account acct = new Account(Name='Test', 
    	                         BillingStreet='Test Street',
    	                         BillingCity='Test city',
    	                         BillingPostalCode='UTEST1 1UT');
    	 insert acct;
    	 if (acct <> null){
    	 	
    	 	Task tsk = new Task(WhatId=acct.Id,
    	 						 Type='Email',
    	 						 Subject='Test',
    	 						 Status='Not started', 
            					 Priority='Normal'); 
          	insert tsk;
    	 	tsk.Subject = 'TM Review';
    	 	update tsk;
		 	System.assertEquals(tsk.Subject,'TM Review');
		 	
		 	delete tsk;
		 	delete acct;
		 	
    	 }
    	 test.stopTest();
    	 
		 
		//List<Task> tasks = [SELECT Id, AccountId ,ActivityDate, Subject FROM Task WHERE Subject = 'TM Review'];
		//tasks[0].Subject = 'TM Review';
		//update tasks[0];
		//System.assertEquals(tasks[0].Subject,'TM Review');
		//TMReviewTriggerHelper tmreview = new TMReviewTriggerHelper();
	 	//	tmreview.updateLastTMReview(tasks[0]);
	 	
	 	
		}
}