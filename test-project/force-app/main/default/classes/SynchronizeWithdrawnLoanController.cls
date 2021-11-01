public  class SynchronizeWithdrawnLoanController extends SynchronizeLoan {
	Boolean IsappstageWithdrawn = true;
	public SynchronizeWithdrawnLoanController(ApexPages.StandardController controller) {
    	   if(url == '') url = Utility.getServerUrl() + '/';
    	     initialize();   
    	     
    }
    @TestVisible
    private void initialize(){
    	try{
             this.LoanAppId = apexpages.currentpage().getparameters().get('id');
                 
        }catch(exception ex){
                this.LoanAppId = null;
        } 
        initializeHelper();
        //check if stage is withdrawn
        if(app.Application_Stage__r.Name != 'Withdrawn'){
        	 ApexPages.Message myMsgebacct = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error only withdrawn  apps can be archived');
             ApexPages.addMessage(myMsgebacct);
       		 IsappstageWithdrawn = false;
        }
       
        
    }
     
	public PageReference ArchiveWithdrawnApp(){
		   Savepoint sp = Database.setSavepoint();
		   try{
		   	
		             if(IsappstageWithdrawn == true)	{
		               RecordType ArchiveRecordType = this.getRecordTypeIdForName('EB_Booked_Loan_App__c', 'Withdrawn');
		               app.delete_Flag__c = true;
			    	   List<EB_Loan_App_Stage__c> stage = [SELECT Id, Name FROM EB_Loan_App_Stage__c WHERE Name =: 'Archived'];
			    	   app.Application_Stage__c = stage[0].Id;
			    	   update app;	 
		               CreateLoanAppBooked(app, null, 'Withdrawn', ArchiveRecordType.Id);
			    	   RewireLoanStageLogs(bookedLoanapp);
					    	   
			    	   RewireLoanSnapshots(bookedLoanapp, snapshots);
			    	   CreateNewSnapshot(null, app, bookedLoanapp, 'Withdrawn Snapshot', 'Withdrawn');
					    	  
			    	   RewireNotesAndAttachments( app, bookedLoanapp);
			    	   RewireTasks(app,bookedLoanapp);
					  
			    	    
					   ArchiveLoanPacket(packet); 	   
					    	   
					    	   
			    	   String newPageUrl = url + bookedLoanapp.Id;
			    	   PageReference newPage = new PageReference(newPageUrl);
		  			   newPage.setRedirect(true);
		  			   return newPage;       
             	
		             }
         
    	    }catch(exception ex){
    	    	
			   ApexPages.Message myMsgebacct = new ApexPages.Message(ApexPages.Severity.ERROR, 'Error archiving withdrawn app');
               ApexPages.addMessage(myMsgebacct);
               Database.rollback(sp);
		   }
		   return null;  			
	}
}