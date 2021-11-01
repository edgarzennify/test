public with sharing class WithdrawLoanApplicationProcess extends SynchronizeLoan {
	
	public static Map<String,EB_Loan_App_Stage__c> LoanAppStageMap{
		get{
			if( LoanAppStageMap == null){
				LoanAppStageMap = new Map<String, EB_Loan_App_Stage__c>();
				for(EB_Loan_App_Stage__c stage : [SELECT Id, Name FROM EB_Loan_App_Stage__c]){
					LoanAppStageMap.put(stage.Name,stage); 
				}				
			}
			return LoanAppStageMap;
		}
	}
	public static Id ArchivedLoanAppStageId(){
			return LoanAppStageMap.get('Archived').Id ;
	}

	public EB_Loan_Application__c Load(Id LoanAppId){
		this.LoanAppId = LoanAppId;
		initializeHelper();
		return app;
	}
	public static boolean IsAppWithdrawn(EB_Loan_Application__c app){
		if(app.Application_Stage__r	== null) return false;	
		return (app.Application_Stage__r.Name == 'Withdrawn')?true:false ;
	}
	
	public static void updateApp(EB_Loan_Application__c withdrawnapp){ update withdrawnapp;}

	public void CreateBookedApp(Id LoanAppId){
		this.LoanAppId = LoanAppId;
		CreateLoanAppBooked(app, null, 'Withdrawn', utility.RecordTypeObject('EB_Booked_Loan_App__c', 'Withdrawn').Id);
	}
	public void MoveStageLogFromAppToBookedApp(Id LoanAppId){
		if(app == null ) CreateBookedApp(LoanAppId);
		RewireLoanStageLogs(bookedLoanapp);
	}
	public void MoveSnapsotsFromAppToBookedApp(Id LoanAppId){
		if(app == null ) CreateBookedApp(LoanAppId);
		 RewireLoanSnapshots(bookedLoanapp, snapshots);
	}
	public void ArchiveAppStatus(String comment){
		 app.Application_Stage__c = ArchivedLoanAppStageId();
	     app.delete_Flag__c = true;
	     app.Stage_Comment__c = comment;
	     update app;	
	}

	public Boolean Withdraw(Id LoanAppId){
		try{
			EB_Loan_Application__c withdrawApp = Load(LoanAppId);
			ArchiveAppStatus('Auto-Withdrawn by system');	
			CreateBookedApp(app.Id);
			MoveStageLogFromAppToBookedApp(app.Id);
			MoveSnapsotsFromAppToBookedApp(app.Id);			
			RewireNotesAndAttachments( app, bookedLoanapp);
			RewireTasks(app,bookedLoanapp);		    	    
		    ArchiveLoanPacket(packet);
		}catch(exception ex){
			return false;
		}
		return true;
	}
		
	
}