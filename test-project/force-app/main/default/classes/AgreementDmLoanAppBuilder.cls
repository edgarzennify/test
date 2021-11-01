public class AgreementDmLoanAppBuilder implements Agreements.IDmLoanAppBuilder {
    public List<DmLoanApp> build(List<Agreement_Loan_Application_Relationship__c> rels){
        List<DmLoanApp> dms = new List<DmLoanApp>();
        for(Agreement_Loan_Application_Relationship__c rel : rels){
            dms.add(build(rel.Loan_Application__r));      
        }      
        return dms;
    }

    public List<DmLoanApp> build(List<EB_Loan_Application__c> loanApps){
        List<DmLoanApp> dms = new List<DmLoanApp>();
        for(EB_Loan_Application__c app : loanApps){
            dms.add(build(app));      
        }      
        return dms;
    }

    public Agreements.LoanAppEntityRelationship build(DmLoanApp loanApp, Account entity){
        Agreements.LoanAppEntityRelationship dm = new Agreements.LoanAppEntityRelationship();
        dm.loanApp = loanApp;
        dm.entity = entity;
        return dm;
    }

    public List<DmLoanApp> build(List<Agreement_LLC_BI_Loan_Relationship__c> llcBiLoanRels){
        List<DmLoanApp> dms = new List<DmLoanApp>();
        for(Agreement_LLC_BI_Loan_Relationship__c loanRel : llcBiLoanRels){
            dms.add(build(loanRel.LLCBI_Loan__r));      
        }      
        return dms;
    }

    public List<DmLoanApp> build(List<LLC_BI__Loan__c> loanApps){
        List<DmLoanApp> dms = new List<DmLoanApp>();
        for(LLC_BI__Loan__c app : loanApps){
            dms.add(build(app));      
        }      
        return dms;
    }

    private DmLoanApp build(EB_Loan_Application__c loanApp){
        DmLoanApp dm = new DmLoanApp();
        if(loanApp == null) return dm;
        dm.id = String.valueOf(loanApp.Id);
        dm.name = loanApp.Name;
        dm.leadEntity = build(loanApp.EB_Loan_Packet__r.Lead_Entity__r);
        dm.packetOrPackageName = loanApp.EB_Loan_Packet__r.Name;
        dm.loanAmount = loanApp.Total_Loan_Amount__c;
        dm.isNewStage = (loanApp.Application_Stage__r.Name == 'New');
        return dm;  
    }

    private DmLoanApp build(LLC_BI__Loan__c loan){
        DmLoanApp dm = new DmLoanApp();
        if(loan == null) return dm;
        dm.id = String.valueOf(loan.Id);
        dm.name = loan.Name;
        dm.leadEntity = build(loan.LLC_BI__Account__r);
        dm.packetOrPackageName = loan.LLC_BI__Product_Package__r.Name;
        dm.loanAmount = loan.LLC_BI__Amount__c;
        dm.isNewStage = true;
        return dm;  
    }

    private DmEntity build(Account entity){
        DmEntity dm = new DmEntity();
        if(entity == null) return dm;
        dm.Id = entity.Id;
        dm.Name = entity.Name;
        return dm;
    }
}