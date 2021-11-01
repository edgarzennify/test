public class AgreementSummaryUpdater{
    public static boolean alreadyran = false;
    
    public static void setAlreadyRan() {
        alreadyran = true;
    }
    
    public static void updateSummaries(Id AgmtId){
        List<Id> AgmtIdList = new List<Id>();
        AgmtIdList.add(AgmtId);
        updateSummaries(AgmtIdList);
    }
    
    public static void updateSummaries(List<Agreement__c> AgmtList){
        List<Id> AgmtIdList = new List<Id>();
        for(Agreement__c agmt : AgmtList){
            AgmtIdList.add(agmt.Id);
        }
        if(AgmtIdList.size() > 0){updateSummaries(AgmtIdList);}
    }
    
    public static void updateSummaries(List<Id> AgmtIdList){      
        List<Agreement__c> agreementsToUpdate = new List<Agreement__c>();
        
        List<Agreement__c> agmtList = [SELECT 
                                           Id, Name, Borrower_Name__c, Borrower_Summary__c, Primary_Borrower__c
                                           ,(SELECT Id, Entity__c, Entity__r.Name, Entity__r.Entity_Name__c, Entity__r.EB_Client_Name__c, Relationship__c FROM Agreement_Relationships__r ORDER BY Primary_Sort_Order__c, Name)
                                           ,(SELECT Id, Name, Loan_Application__r.Name FROM Agreement_Loan_Application_Relationship__r)
                                           ,(SELECT Id, Name, Loan_Account__r.Name FROM Agreement_EB_Account_Relationship__r)
                                       FROM Agreement__c
                                       WHERE Id IN: (AgmtIdList)];
                                          
        for(Agreement__c agmt : agmtList){
            updateSummariesForAgreement(agmt, agmt.Agreement_Relationships__r, agmt.Agreement_Loan_Application_Relationship__r, agmt.Agreement_EB_Account_Relationship__r);            
            agreementsToUpdate.add(agmt);
        }
        
        if(agreementsToUpdate.size() > 0){
            AgreementSummaryUpdater.setAlreadyRan();
            update agreementsToUpdate;
        }
    }
    
    private static void updateSummariesForAgreement(Agreement__c agmt, List<Agreement_Client_Relationships__c> entityRels, List<Agreement_Loan_Application_Relationship__c> loanApps, List<Agreement_EB_Account_Relationship__c> accts){
        Id Borrower = null;
        string BorrowerSummary = '';
        string PrimaryBorrower = '';
        string PrimaryBorrowerSummary = '';
        Boolean LengthExceeded = false;
        Integer OkayClients = 3; //Starting from 1 to include primary borrower
        Integer MoreClients = 1; //Starting from 1 to include primary borrower
        String MoreClientMsg = '[' + String.valueOf(MoreClients) + '] More Relationships...';
        Boolean skipPass = true;
            
        if(entityRels != null){
            for(Agreement_Client_Relationships__c rel : entityRels){
                if(rel.Relationship__c=='Primary Borrower'){
                    Borrower = rel.Entity__r.Id;
                    PrimaryBorrower = rel.Entity__r.Entity_Name__c;
                    PrimaryBorrowerSummary = rel.Entity__r.Entity_Name__c + ' (' + rel.Relationship__c + ')\n';
                }else{
                    if((PrimaryBorrowerSummary + BorrowerSummary + rel.Entity__r.Entity_Name__c + ' (' + rel.Relationship__c + ')' + 2).length() < 255 && LengthExceeded == false){
                        BorrowerSummary += rel.Entity__r.Entity_Name__c + ' (' + rel.Relationship__c + ')\n';
                        OkayClients += 1;
                    }
                    else{
                        MoreClients += 1;
                        LengthExceeded = true;                        
                    }
                    if(LengthExceeded == true && MoreClients != 1){
                        if(skipPass == true){
                            skipPass = false;
                        }
                        else{
                            MoreClients += 1;
                        }
                    }
                }
            }
        }
        
        BorrowerSummary = PrimaryBorrowerSummary + BorrowerSummary;
        if (BorrowerSummary.length() > 255 && (BorrowerSummary + MoreClientMsg + OkayClients).length() > 255){
            //Substring being trimmed to 253 to add 2 positions for the new line character.
            BorrowerSummary = BorrowerSummary.substring(0,(255 - (MoreClientMsg.length() + OkayClients)));
            BorrowerSummary += MoreClientMsg;
        }
        
        //update agmt fields
        agmt.Borrower_Name__c = Borrower;
        agmt.Borrower_Summary__c = BorrowerSummary;
        agmt.Primary_Borrower__c = PrimaryBorrower;
        
        agmt.Loan_App_Summary__c  = getLoanApplicationsSummary(agmt, loanApps);
        agmt.Loan_Summary__c = getLoanAccountsSummary(agmt, accts);
    }
    
    private static String getLoanApplicationsSummary(Agreement__c agmt, List<Agreement_Loan_Application_Relationship__c> appRels){
        List<String>loanApplications = new List<String>();
        if(appRels != null){
            for(Agreement_Loan_Application_Relationship__c rel : appRels){
                loanApplications.add(rel.Loan_Application__r.Name);
            }
        }
        return Utility.ListToDelimitedString(loanApplications, ', ').abbreviate(255);
    }
    
    private static String getLoanAccountsSummary(Agreement__c agmt, List<Agreement_EB_Account_Relationship__c> acctRels){
        List<String>loanAccounts = new List<String>();
        if(acctRels != null){
            for(Agreement_EB_Account_Relationship__c rel : acctRels){
                loanAccounts.add(rel.Loan_Account__r.Name);
            }
        }
        return utility.ListToDelimitedString(loanAccounts, ', ').abbreviate(255);
    }
}