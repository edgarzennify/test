public class LoanDocPrep {
    public interface IPresenter {
        FormVm trialExport(Id loanId);
        GenerateResponseVm generateExportFile(Id loanId);
    }
    
    public interface IDataProvider {
        LLC_BI__Loan__c getLoan(Id loanId);
        List<LLC_BI__Loan_Collateral2__c> getLoanCollateral(Id loanId);
        List<LLC_BI__Account_Collateral__c> getLoanCollateralOwnerships(Id loanId);
        List<LLC_BI__Legal_Entities__c> getLoanEntities(Id loanId);
        List<LLC_BI__Fee__c> getLoanFees(Id loanId);
        EB_Team_Member__c getLoanOfficer(Id loanId);
    }

    public interface IDmBuilder {
        DmLoan build(NcinoLoanPm pm);
    }

    public interface IDmBuilderHelper {
    	DmLoan buildLoan(NcinoLoanPm pm);
        DmLoanEntityRelationship buildRelatedEntity(LLC_BI__Legal_Entities__c pm);
        DmLoanCollateralRelationship buildRelatedCollateral(LLC_BI__Loan_Collateral2__c pledge, List<LLC_BI__Account_Collateral__c> ownerships);
        DmFee buildFee(LLC_BI__Fee__c fee);
    }

    public class FormVm {
    	public string loanName {get;set;}
    	public string loanAccountNumber {get;set;}
    	public string loanRenewalFlag {get;set;}
    	public string loanId {get;set;}
    	public LaserProTransformer.LpLoan loan {get;set;}
    	public List<LaserProTransformer.LpEntity> includedEntities {get;set;}
    	public List<LaserProTransformer.LpEntity> excludedEntities {get;set;}
        public List<LaserProTransformer.LpCollateral> includedCollaterals {get;set;}
        public List<LaserProTransformer.LpCollateral> excludedCollaterals {get;set;}
    }

    public class GenerateResponseVm {
    	public string status {get;set;}
    	public string message {get;set;}
    }

    public class NcinoLoanPm {
        public LLC_BI__Loan__c loanApplication {get;set;}
        public List<LLC_BI__Loan_Collateral2__c> loanAppCollaterals {get;set;}
        public List<LLC_BI__Account_Collateral__c> loanAppCollateralOwnerships {get;set;}
        public List<LLC_BI__Legal_Entities__c> loanAppEntities {get;set;}
        public List<LLC_BI__Fee__c> loanAppFees {get;set;}
        public EB_Team_Member__c loanAppOfficer {get;set;}
    }
}