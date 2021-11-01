public with sharing class  AgreementTestTriggerHelper{

    public void beforeUpdate(List <Agreement_Test__c> agmtTests){                       
        updateSeniorLenderEmail(agmtTests);
    }

    private void updateSeniorLenderEmail(List<Agreement_Test__c> agmtTests){
        Map<Id,Agreement_Test__c> reQueryAgmtMap = new Map<Id,Agreement_Test__c>( [SELECT Id ,Agreement__r.Borrower_Name__r.EB_UnitID__r.Senior_Lender__r.User__r.Email FROM Agreement_Test__c WHERE ID In:agmtTests]);
        for(Agreement_Test__c test: agmtTests){
            test.Senior_Lender_Email__c = reQueryAgmtMap.get(test.Id).Agreement__r.Borrower_Name__r.EB_UnitID__r.Senior_Lender__r.User__r.Email;
        }
    }

}