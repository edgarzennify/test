public with sharing class AccountActionController {

    public AccountActionController() {

    }
    public AccountActionController(ApexPages.StandardController controller) {

    }
    private Map<id,Recordtype> RecordTypeMap{
        get{
            if(RecordTypeMap == null){
                RecordTypeMap = new  Map<id,Recordtype>();
                RecordTypeMap = new Map<Id,Recordtype>([SELECT Name, Id FROM RecordType WHERE SobjectType =: 'EB_Loan_Action__c' ]);
                
            }
            return RecordTypeMap;
        }
        set;
                
    }
    private Map<id,Recordtype> RecordTypeLoanTransMap{
        get{
            if(RecordTypeLoanTransMap == null){
                RecordTypeLoanTransMap = new Map<id,Recordtype>();
                List<RecordType> recs =  RecordTypeMap.values();
                for(RecordType rec : recs){
                    if(rec.name== 'Loan Credit' || rec.name == 'Loan Debit')
                    RecordTypeLoanTransMap.put(rec.id,rec);
                }
                
            }
            return RecordTypeLoanTransMap;
        }
        set;
    }
    public String getReportView(){
        
        return 'http://ebatwork/d2k/ReportViewer.aspx?rpt=yL8Tr5NjsQc%3d';

    }
    public class TransactionSummary{
        public integer TotalRecords{get;set;}   
        public decimal TotalTransactionAmount{get;set;}
        
                public String TotalTransactionAmountAsString{
                        get{
                                 List<String> args = new String[]{'0','number','###,###,##0.00'};
                                 return String.format(TotalTransactionAmount.format(), args);
                        }
                }
    }
        
    public TransactionSummary TotalProcessed{
        get{
                TransactionSummary processed = new TransactionSummary();
                processed.TotalRecords = 0;
                processed.TotalTransactionAmount = 0;
                List<TransactionSummary> processedList = new List<TransactionSummary>();
                Datetime dT = System.now();
            Date d = date.newinstance(dT.year(), dT.month(), dT.day());
            
                for(EB_Loan_Action__c action : [SELECT id, Transaction_Amount__c  FROM EB_Loan_Action__c WHERE  RecordTypeId in: RecordTypeLoanTransMap.keyset() and ATE_Status__c =: 'Processed' and ATE_Processed_Date__c =:d and ATE_Processed_Date__c !=: null]){
                        processed.TotalRecords = processed.TotalRecords + 1;
                        if(action.Transaction_Amount__c != null) processed.TotalTransactionAmount = processed.TotalTransactionAmount + action.Transaction_Amount__c;                    
                }               
                return processed;
        }
    }
    public TransactionSummary TotalUnprocessed{
        get{
                TransactionSummary Unprocessed = new TransactionSummary();
                Unprocessed.TotalRecords = 0;
                Unprocessed.TotalTransactionAmount = 0;
                Datetime dT = System.now();
            Date d = date.newinstance(dT.year(), dT.month(), dT.day());
                for(EB_Loan_Action__c action : [SELECT id, Transaction_Amount__c  FROM EB_Loan_Action__c WHERE ATE_Status__c =: 'Unprocessed' and RecordTypeId in: RecordTypeLoanTransMap.keyset() ]){
                        Unprocessed.TotalRecords = Unprocessed.TotalRecords + 1;
                        if(action.Transaction_Amount__c != null) Unprocessed.TotalTransactionAmount = Unprocessed.TotalTransactionAmount + action.Transaction_Amount__c;                
                }
                return Unprocessed;
        }
    }
     public TransactionSummary Totalexcluded{
        get{
                TransactionSummary Totalexcluded = new TransactionSummary();
                Totalexcluded.TotalRecords = 0;
                Totalexcluded.TotalTransactionAmount = 0;
                Datetime dT = System.now();
            Date d = date.newinstance(dT.year(), dT.month(), dT.day());
                for(EB_Loan_Action__c action : [SELECT id, Transaction_Amount__c  FROM EB_Loan_Action__c WHERE ATE_Status__c =: 'Exclude' and RecordTypeId in: RecordTypeLoanTransMap.keyset() ]){
                        Totalexcluded.TotalRecords = Totalexcluded.TotalRecords + 1;
                        if(action.Transaction_Amount__c != null) Totalexcluded.TotalTransactionAmount = Totalexcluded.TotalTransactionAmount + action.Transaction_Amount__c;                    
                }
                return Totalexcluded;
        }       
    }
    public PageReference ProcessDataForReport(){
       datetime dT = system.now();
           Date d = date.newinstance(dT.year(), dT.month(), dT.day());
       List<EB_Loan_Action__c> updateList = new List<EB_Loan_Action__c>();
       for(Eb_Loan_action__c action : [SELECT id, Ate_status__c FROM EB_Loan_Action__c
                                             where Transaction_Effective_Date__c =:d
                                             and ate_status__c =:'Unprocessed'
                                             and Subordination_Stages__c =:'Completed'
                                             and Transaction_Effective_Date__c <> null
                                             and ate_status__c <> null
                                             and Subordination_Stages__c <> null
                                             and recordtypeid in: RecordTypeLoanTransMap.keyset() ]){
                                                
            action.ATE_Status__c = 'Processed';
            action.ATE_Processed_Date__c = d;
            action.Status__c = action.Subordination_Stages__c  ; //keep the generic status field in Sync                            
            updateList.add(action);                                  
                                             
        }
        if(updateList.size() > 0) update updateList;
       
       return null;
    }
    public String HasPermissionAdmin{
        get{
                Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
                if(pr.Name == 'System Administrator' || HasPermissionAdmin == 'true') return 'true';
                List<PermissionSet> psetList = [select id, Label from PermissionSet where Label=:'Function - Loan Transaction Admin' ];
                        if(psetList.size() > 0){
                                List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :psetList[0].id];            
                if(permissionsetassignList.size() > 0) return 'true';
                        }
            return 'false';
        }

    }
    public static testMethod void verifyAccountNumberMethods(){ 
        
                EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);
                EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
                Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
                
            Account LeadEntity = objectFactory.getEntity('Test Entity',ClientRecordTypeId, team);
            EB_Account__c account = objectFactory.getEBAccount('Test account', '1234', leadEntity);
            account.EB_Unit__c = branch.Id;
                        Collateral_Code__c CollateralCode = ObjectFactory.getCollateralCode('test', '9990' );
                        account.Collateral_Code__c = CollateralCode.Collateral_Code_ID__c;
                        account.Account_Class_Code__c = '99';
                        account.Account_Status__c = 'A';
                        update account;
                        RecordType rectype = ObjectFactory.getRecordTypeObjByNameAndObject('Loan Credit', 'EB_Loan_Action__c');
                        EB_Loan_Action__c action = ObjectFactory.getAccountActionObj(account,rectype);
                        action.ate_status__c ='Unprocessed';
            action.Subordination_Stages__c ='Completed';
            datetime dT = system.now();
            Date d = date.newinstance(dT.year(), dT.month(), dT.day());
            action.Transaction_Effective_Date__c = d;
                update action;
                        
            AccountActionController testcontroller = new AccountActionController();
            String permission = testcontroller.HasPermissionAdmin;
            String urlpost = testcontroller.getReportView();     
            TransactionSummary record =  testcontroller.TotalProcessed;
            record = testcontroller.Totalexcluded;
            record = testcontroller.TotalUnprocessed;
            PageReference p = testcontroller.ProcessDataForReport();           
    }

}