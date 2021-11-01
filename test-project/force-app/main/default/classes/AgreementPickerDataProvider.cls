public class AgreementPickerDataProvider implements Agreements.IAgreementPickerDataProvider{
    
    public Agreement__c GetAgreementFromId(Id AgreementId){
        return [SELECT Id, Name , RecordTypeId, RecordTypeDescription__c FROM Agreement__c WHERE Id =: AgreementId][0];
    }
   
    public List<Eb_Loan_Application__c> GetLoanApplicationObjectForLoanAppId(Id LoanAppId){
        return [SELECT Id,EB_Loan_Packet__r.Lead_Entity__c, Account_Number__c, Name, Closing_Date__c FROM EB_Loan_Application__c WHERE Id =: LoanAppId limit 1 ];
    }
     
    public  void SaveAgreementLoanAppRel(Id AgreementId, Id LoanAppId){               
            List<Agreement_Loan_Application_Relationship__c> findInList = [SELECT Id,Agreement__r.RecordTypeDescription__c FROM Agreement_Loan_Application_Relationship__c WHERE Agreement__c =:  AgreementId and Loan_Application__c =: LoanAppId];
            Agreement_Loan_Application_Relationship__c agmtLoanAppRel = new Agreement_Loan_Application_Relationship__c(Agreement__c = AgreementId,Loan_Application__c = LoanAppId);  
            if(findInList.size() == 0) insert agmtLoanAppRel;
    }

    public  void SaveAgreementLlcBiLoanRel(Id AgreementId, Id LlcBiLoanId){               
            List<Agreement_LLC_BI_Loan_Relationship__c> findInList = [SELECT Id,Agreement__r.RecordTypeDescription__c FROM Agreement_LLC_BI_Loan_Relationship__c WHERE Agreement__c =:  AgreementId and LLCBI_Loan__c =: LlcBiLoanId];
            Agreement_LLC_BI_Loan_Relationship__c agmtLlcBiLoanRel = new Agreement_LLC_BI_Loan_Relationship__c(Agreement__c = AgreementId,LLCBI_Loan__c = LlcBiLoanId);  
            if(findInList.size() == 0) insert agmtLlcBiLoanRel;
    }
        
    
    public List<Agreement__c> GetAgreementsForLoanApp(Id LoanAppId){
        Set<Account> entityRelSet = new Set<Account>();
        Map<Id,Agreement__c> agmtMap = new Map<Id,Agreement__c>();
        for(EB_Loan_App_Entity_Relationship__c rel : [SELECT Id,Entity_Name__c,Loan_Application_ID__c, Entity_Name__r.Name FROM EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: LoanAppId]){
        	entityRelSet.add(new Account(id=rel.Entity_Name__c,Name = rel.Entity_Name__r.Name));
        }

        Set<Id> agmtSet = new Set<Id>();
        for(Agreement__c agmt : GetAgreementsConnectedToLoanApp(LoanAppId)){
        	agmtSet.add(agmt.id);
        }
        
        for(Agreement_Client_Relationships__c clRel : [SELECT Id,Name,Agreement__c ,Agreement__r.Borrower_Name__c, Agreement__r.Name,Agreement__r.RecordTypeId FROM Agreement_Client_Relationships__c WHERE Entity__c in: entityRelSet and Agreement__r.RecordTypeDescription__c != 'Archive' and Agreement__r.RecordTypeDescription__c != '' ]){        
            if(!agmtSet.contains(clRel.Agreement__c)){
                agmtMap.put(clRel.Agreement__c,new Agreement__c(id = clRel.Agreement__c,Name = clRel.Agreement__r.Name,Borrower_Name__c = clRel.Agreement__r.Borrower_Name__c, RecordTypeId = clRel.Agreement__r.RecordTypeId ));
            }
        }
        
        List<Agreement__c> sortedList = agmtMap.Values();
        sortedList.sort();
        return sortedList;
    }
    
    private List<Agreement__c> GetAgreementsConnectedToLoanApp(Id LoanAppId){
        Map<Id,Agreement__c> agmtloanMap = new Map<Id,Agreement__c>();
        for(Agreement_Loan_Application_Relationship__c rel : [SELECT Agreement__c, Agreement__r.RecordTypeDescription__c FROM Agreement_Loan_Application_Relationship__c WHERE Loan_Application__c =: LoanAppId ]){
        	agmtloanMap.put(rel.Agreement__c,new Agreement__c(id=rel.Agreement__c));
        }
        return agmtloanMap.Values();                 
    }
}