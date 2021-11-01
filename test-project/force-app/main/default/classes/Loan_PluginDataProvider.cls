public with sharing class Loan_PluginDataProvider implements Plugin.ILoan_PluginDataProvider{
    
    public LLC_BI__Loan__c getNcinoLoanById(Id recordId){
        return [
            SELECT 
                 Id
                ,Name
                ,LLC_BI__lookupKey__c
                ,LLC_BI__ParentLoan__r.LLC_BI__lookupKey__c 
            FROM 
                LLC_BI__Loan__c 
            WHERE 
                Id=:recordId 
            LIMIT 1
        ]; 
    }

    public List<PM_EB_Account_c> getEbAccountByKey(String key){
        List<EB_Account__c> sobs = [
            SELECT 
                 Id
                ,Name
                ,Key__c 
                ,(
                    SELECT
                        Id
                        ,Name
                    FROM
                        Agreement_EB_Account_Relationship__r
                )
            FROM 
                EB_Account__c 
            WHERE 
                Key__c =: key 
                AND Key__c != null 
                AND Key__c != ''
            LIMIT 1
        ];

        List<PM_EB_Account_c> pms = new List<PM_EB_Account_c>();
        for (EB_Account__c sob : sobs) {
            PM_EB_Account_c pm = new PM_EB_Account_c();
            pm.Id = sob.Id;
            pm.Name = sob.Name;
            pm.Key_c = sob.Key__c;
            pm.OriginalSObject = sob;
            pm.Agreement_EB_Account_Relationship_r = new List<PM_Agreement_EB_Account_Relationship_c>();
            for (Agreement_EB_Account_Relationship__c relSob : sob.Agreement_EB_Account_Relationship__r) {
                PM_Agreement_EB_Account_Relationship_c relPm = new PM_Agreement_EB_Account_Relationship_c();
                relPm.Id = relSob.Id;
                pm.Agreement_EB_Account_Relationship_r.add(relPm);
            }
            pms.add(pm);
        }
        
        return pms;
    }

    public List<LLC_BI__LoanRenewal__c> getParentLoanRelationship(Id loanId){
        return [
            SELECT
                 Id
                ,LLC_BI__ParentLoanId__c
                ,LLC_BI__ParentLoanId__r.LLC_BI__lookupKey__c
                ,LLC_BI__RenewalLoanId__c
            FROM
                LLC_BI__LoanRenewal__c
            WHERE
                LLC_BI__RenewalLoanId__c =: loanId
                AND LLC_BI__ParentLoanId__c !=: loanId
            LIMIT 1
        ];
    }
    
}