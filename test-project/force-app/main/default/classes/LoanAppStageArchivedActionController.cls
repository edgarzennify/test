public with sharing class LoanAppStageArchivedActionController extends LoanAppStageActionBaseClass{
    
    public LoanAppStageArchivedActionController(ApexPages.StandardController controller) {                  
        //nothing to do, base class handles everything
    }  
    
    public override void LoadObject(){
        this.archivedapp = [SELECT Id, Name, Approval_Path__c, Application_Stage__c, TDR_Determination_One__c , TDR_Determination_Two__c, Application_Stage_Reportable__c, Stage_Explanation__c,Stage_Comment__c, Approver_One__c, Approver_Two__c, Approver_Three__c, Application_Stage__r.Name, Application_Stage__r.Loan_App_Stage_Action_Controller__r.Id, EBT_Loan_Amount__c, Loan_Packet__r.Name, Loan_Packet__r.Committee_Date__c, Loan_Packet__r.Actual_Approval_Path__c, Loan_Packet__r.Lead_Entity__r.Name, Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Email,Loan_Packet__r.Lead_Entity__r.Team_Wealth_Management_Advisor__r.User__R.Name, Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Email,Loan_Packet__r.Lead_Entity__r.Team_Treasury_Management_Representative__r.User__r.Name, Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email,Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Name, Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Id, Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Id, Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Email,Loan_Packet__r.Lead_Entity__r.Team_Private_Banker__r.User__r.Name, Loan_Packet__r.Loan_Coordinator__r.User__r.Email,Loan_Packet__r.Loan_Coordinator__r.User__r.Name , Loan_Packet__r.Credit_Analyst__r.User__r.Email,Loan_Packet__r.Credit_Analyst__r.User__r.Name, DocumentationRep__r.User__r.Email, DocumentationRep__r.User__r.Name, Application_Stage__r.Stage_Selected_Email_Notifications__c , Application_Stage__r.Email_Queue__c FROM EB_Booked_Loan_App__c WHERE Id =: appId limit 1];
        this.packet = this.archivedapp.Loan_Packet__r;
        this.currentStage = this.archivedapp.Application_Stage__r;
        system.debug('Application_Stage__r: ' + this.archivedapp.Application_Stage__r.Name);
        system.debug('##:LoadObject'); 
    }
 
    public override String ValidateForm(){
            system.debug('##:ValidateForm 1');
            try{
                system.debug('##:ValidateForm 2');
                if(ddNextStatusId == this.currentstage.Id){
                    
                    return 'Please select a new status';
                }
                system.debug('##:ValidateForm 3');
                if(ExplanationNeeded() == true && ddExplanation == ddExplanationDefault){
                    return 'Please select a reason';
                }
                system.debug('##:ValidateForm 4');                
                return StageActionValidation();                                                         
            }catch(Exception ex){
               // debug_RecordLog(ex.getMessage());
               system.debug('##:ValidateForm ex ' + ex.getMessage());
                return 'Validation error';
            }
        }
    public override void Save(){            
                DoActionFieldUpdates();
                
                //Change Name as required             
                //if(currentStage.Name != 'Checkback' ){
                
                system.debug('SAVE: Stage_Explanation__c ' + String.valueof(archivedapp.Stage_Explanation__c));
                system.debug('SAVE: ExplanationNeeded ' +string.valueof(ExplanationNeeded()));
                
               
                
                archivedapp.Application_Stage__c = ddNextStatusId;
                //Logic for using Auto Forward
                
               
                
                archivedapp.Stage_Explanation__c = '';
                archivedapp.stage_comment__c = '';
                    
                if(ExplanationNeeded()){
                    
                    if(StageLogComment != null){
                        archivedapp.stage_comment__c = StageLogComment;
                    }
                    for(String s: selectedReasons){
                        if(s == null || s == ''){}else{
                            archivedapp.Stage_Explanation__c += s + ';';
                        }
                    }
                    
                    //Handle no error case if no option is selected 12/19/2011
                    if( archivedapp.Stage_Explanation__c == ''){
                        //archivedapp.Stage_Explanation__c = 'No Errors' + ';' ;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an Explanation');
                        ApexPages.addMessage(myMsg);
                    }
                    
                    if(archivedapp.Stage_Explanation__c.length() > 1){
                        archivedapp.Stage_Explanation__c = archivedapp.Stage_Explanation__c.substring(0,archivedapp.Stage_Explanation__c.length()-1);
                    }
                }
                
                
                update this.archivedapp;
                 if(AutoForwardStage != null){
                    archivedapp.Application_Stage__c = AutoForwardStage.Id;
                    archivedapp.Stage_Explanation__c = '';
                    archivedapp.stage_comment__c = '';
                    update this.archivedapp;
                }
                
        }
    public override string SendEmailHelper(){
             return 'The following Archived loan application has moved to the ' + NextStage().Name
                                                 + ' stage. Click on the link below to view additional details.\n\nLead Entity:' + archivedapp.Loan_Packet__r.Lead_Entity__r.Name
                                                 + '\n'+ archivedapp.name
                                                 + '\nStage Explanation:' + archivedapp.Stage_Explanation__c + '\n'                      
                                                 + '\nLoan Amount:'+ String.valueOf(archivedapp.EBT_Loan_Amount__c) + '\n'
                                                 + 'Link to Application: ' + baseURL + '/' + String.valueOf(archivedapp.Id);
                                                
        }
    public override PageReference SaveClicked(){      
                system.debug('##:SaveClicked 1');       
                Savepoint sp = Database.setSavepoint();
                try{
                    if(this.appId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                        ApexPages.addMessage(myMsg);
                    }else if(ValidateForm() == ''){
                        system.debug('##:SaveClicked 2'); 
                        Save();
                        String subject = 'Loan Application Status Update - ' + archivedapp.Name + ' - ' + NextStage().Name;
                        List<User> lastModifiedBy = [SELECT id, Name FROM User WHERE id =: archivedapp.LastModifiedById];
                        if(lastModifiedBy.size() > 0){          
                            SendEmail(subject,lastModifiedBy[0].Name);
                        }else{
                            SendEmail(subject,'N/A');
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
    
      
}