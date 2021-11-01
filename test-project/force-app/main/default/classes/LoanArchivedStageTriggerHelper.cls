public  class LoanArchivedStageTriggerHelper {
	Map<String,EB_Loan_App_Stage__c> stgMap  = null;
	Id RecTypeBooked = null;
	/*public Map<String,EB_Loan_App_Stage__c> stgMap{
		get{
			if(stgMap == null){
                stgMap = new Map<String,EB_Loan_App_Stage__c>();
                for(EB_Loan_App_Stage__c stgs : [SELECT Id, Name, Stage_Selected_Email_Notifications__c FROM EB_Loan_App_Stage__c WHERE Name =: 'Archived' or Name =:'Checkback'    order by name]){
                    stgMap.put(stgs.Name , stgs);
                }
			}
           return stgMap;		
		}
		set;
	}*/
	public Id RecTypeBookedId{
		get{
			if(RecTypeBookedId == null){
				RecTypeBookedId = [SELECT Id FROM RecordType WHERE name=:'Booked' and SobjectType =:'EB_Booked_Loan_App__c'].Id;
			}
			return RecTypeBookedId;
		}
		set;
	}
	public void insertLoanArchivedStageAfterFromList( List<EB_Booked_Loan_App__c> newList){
		/*if(stgMap == null){
                stgMap = new Map<String,EB_Loan_App_Stage__c>();
                for(EB_Loan_App_Stage__c stgs : [SELECT Id, Name, Stage_Selected_Email_Notifications__c FROM EB_Loan_App_Stage__c WHERE Name =: 'Archived' or Name =:'Checkback'    order by name]){
                    stgMap.put(stgs.Name , stgs);
                }
			}
		for(EB_Booked_Loan_App__c archivedapp : newList){
        
                if(archivedapp.Application_Stage__c == stgMap.get('Archived').Id ){
                	RecordEBLoanArchivedStageLog(archivedapp, true);
                	archivedapp.Application_Stage__c = stgMap.get('Checkback').Id;               	
                	archivedapp.Stage_Explanation__c = '';
                }else{
                	RecordEBLoanArchivedStageLog(newList, false);
                }
        }*/
        
    }
    public void RecordEBLoanArchivedStageLog(EB_Booked_Loan_App__c archivedapp , Boolean RecordStageExplaination){
    	List<EB_Booked_Loan_App__c> archivedappList = new List<EB_Booked_Loan_App__c>();
    	archivedappList.add(archivedapp);
    	RecordEBLoanArchivedStageLog(archivedappList , RecordStageExplaination);
    }
    public void RecordEBLoanArchivedStageLog( List<EB_Booked_Loan_App__c> newList , Boolean RecordStageExplaination){
    	List<EB_Loan_Application_Stage_Log__c> stagelogs = new List<EB_Loan_Application_Stage_Log__c>();
        List<EB_Booked_Loan_App__c> updateLoanApp = new List<EB_Booked_Loan_App__c>();
        for(EB_Booked_Loan_App__c archivedapp : newList){
            EB_Loan_Application_Stage_Log__c loanstage = new EB_Loan_Application_Stage_Log__c();
            loanstage.EB_Booked_Loan_App__c = archivedapp.Id;
            loanstage.Explanation__c = archivedapp.Stage_Explanation__c;
            if(archivedapp.Application_Stage__c == null){
            }else{
            	//loanstage.EB_Loan_Application__c = app.id;
                loanstage.EB_Loan_Application_Stage__c = archivedapp.Application_Stage__c;
                loanstage.stage_text__c = archivedapp.Application_Stage_Reportable__c;
                //loanstage.Explanation__c = app.Stage_Explanation__c;
                loanstage.Comment__c = archivedapp.Stage_Comment__c;
                stagelogs.add(loanstage);
                
               
               }
        }
        if(stagelogs.size() > 0) insert stagelogs;
        for(EB_Loan_Application_Stage_Log__c stageLog: stageLogs){
         if(RecordStageExplaination == true){
                	putExplanationInStageLogExplanation(stageLog.Explanation__c,stageLog.Comment__c,stageLog.Id);
         }
        }
    }
    /* public void insertLoanArchivedStageBeforeFromList( List<EB_Booked_Loan_App__c> newList){
        List<EB_Booked_Loan_App__c> updateLoanApp = new List<EB_Booked_Loan_App__c>();
         List<EB_Loan_App_Stage__c> stage = [SELECT Id FROM EB_Loan_App_Stage__c WHERE Name =: 'New' limit 1 ];
         for(EB_Booked_Loan_App__c app : newList){
                 if(stage.size() > 0 ){
                     app.Application_Stage__c = stage[0].Id;
                 }
         }
    }*/
   
    public void updateBeforeLoanArchivedStageFromList( List<EB_Booked_Loan_App__c> newList){
    	if(stgMap == null){
                stgMap = new Map<String,EB_Loan_App_Stage__c>();
                for(EB_Loan_App_Stage__c stgs : [SELECT Id, Name, Stage_Selected_Email_Notifications__c FROM EB_Loan_App_Stage__c WHERE Name =: 'Archived' or Name =:'Checkback'    order by name]){
                    stgMap.put(stgs.Name , stgs);
                }
			}
			
    	for(EB_Booked_Loan_App__c archivedapp : newList){
        //Automatically send to checkback stage
                if(archivedapp.Application_Stage__c == stgMap.get('Archived').Id && archivedapp.RecordTypeId == RecTypeBookedId  ){
                	//RecordEBLoanArchivedStageLog(archivedapp, true);
                	archivedapp.Application_Stage__c = stgMap.get('Checkback').Id;               	
                	archivedapp.Stage_Explanation__c = '';
                	archivedapp.Stage_Comment__c = '';
                }
        }
       
    }
    public void updateLoanArchivedStageFromList( List<EB_Booked_Loan_App__c> oldList,Map<Id, EB_Booked_Loan_App__c> newMap, List<EB_Booked_Loan_App__c> newList){
    	 List<EB_Loan_Application_Stage_Log__c> stageList = new List<EB_Loan_Application_Stage_Log__c>();
        for(EB_Booked_Loan_App__c dirty : oldList){
            EB_Loan_Application_Stage_Log__c loanstage = new EB_Loan_Application_Stage_Log__c();
            loanstage.EB_Booked_Loan_App__c = dirty.Id;
			
            if( dirty.Application_Stage__c == null ){
            }else{
                EB_Booked_Loan_App__c newArchivedApp = newMap.get(dirty.Id);
                
                if(newArchivedApp.Application_Stage_Reportable__c == dirty.Application_Stage_Reportable__c){
                   
                
                }else{
                   // loanstage.EB_Loan_Application__c = newLoanApp.id;
                    loanstage.EB_Loan_Application_Stage__c = newArchivedApp.Application_Stage__c;
                    loanstage.stage_text__c = newArchivedApp.Application_Stage_Reportable__c;
                    loanstage.Explanation__c = newArchivedApp.Stage_Explanation__c;
                    loanstage.Comment__c = newArchivedApp.Stage_Comment__c;
                    stageList.add(loanstage);
                   
                }
            }
        }
        if(stageList.size() > 0)
        { 
        	insert stageList;
        	
        }
        
        
        
        //////////////////
        //for loop stage get id and Explanation__c. Split Explnation__c.split(',') by comma
        //insert int loan app stage log explanation; 
       //try{
       
       
       // List<Loan_App_Stage_Explanation__c> insertlistexpl = new List<Loan_App_Stage_Explanation__c>();
            
        for(EB_Loan_Application_Stage_Log__c lg : stageList){
            putExplanationInStageLogExplanation(lg.Explanation__c, lg.Comment__c , lg.id);
         
        }
      // }catch(exception ex){}   
            
        /////////////////////////////////// 
    }
 private void putExplanationInStageLogExplanation(String Explanation,String comment, Id stageid){
    	   List<Loan_App_Stage_Explanation__c> insertlistexpl = new List<Loan_App_Stage_Explanation__c>();
            
           if(Explanation == null){}else{
                List<String>  explanations = new List<String>();//=   lg.Explanation__c.split(';');
                String explain = Explanation;
               // system.debug('explain: ' +  lg.Explanation__c);
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
                if(slowercase.contains('no error') ==true || slowercase.contains('rush') ==true) 
                    lnappstagexpl.Type__c = 'Non-First Pass Quality';
                else
                    lnappstagexpl.Type__c = 'First Pass Quality';
                
                insertlistexpl.add(lnappstagexpl);

            }
            
              }
         
        if(insertlistexpl.size() > 0 )  insert insertlistexpl;
        
       
    }

}