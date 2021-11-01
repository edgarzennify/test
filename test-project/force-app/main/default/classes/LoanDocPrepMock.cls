public class LoanDocPrepMock {
    public class MockofIPresenter extends ApexMoq implements LoanDocPrep.IPresenter {
        public LoanDocPrep.FormVm trialExport(Id loanId) {
            return (LoanDocPrep.FormVm)handleMethodInvocation('trialExport', new List<Object>{loanId});
        }
        public LoanDocPrep.GenerateResponseVm generateExportFile(Id loanId) {
            return (LoanDocPrep.GenerateResponseVm)handleMethodInvocation('generateExportFile', new List<Object>{loanId});
        }
    }
    public class MockOfIDmBuilderHelper extends ApexMoq implements LoanDocPrep.IDmBuilderHelper {
	public DmLoan buildLoan(LoanDocPrep.NcinoLoanPm pm) {
	    return (DmLoan)handleMethodInvocation('buildLoan', new List<Object>{pm});
	}
        public DmLoanEntityRelationship buildRelatedEntity(LLC_BI__Legal_Entities__c pm) {
            return (DmLoanEntityRelationship)handleMethodInvocation('buildRelatedEntity', new List<Object>{pm});
        }
        public DmLoanCollateralRelationship buildRelatedCollateral(LLC_BI__Loan_Collateral2__c pledge, List<LLC_BI__Account_Collateral__c> ownerships) {
            return (DmLoanCollateralRelationship)handleMethodInvocation('buildRelatedCollateral', new List<Object> {pledge, ownerships});
        }
        public DmFee buildFee(LLC_BI__Fee__c fee) {
            return (DmFee)handleMethodInvocation('buildFee', new List<Object> {fee});
        }
    }

    public class MockOfIDmBuilder extends ApexMoq implements LoanDocPrep.IDmBuilder {
        public DmLoan build(LoanDocPrep.NcinoLoanPm pm) {
            return (DmLoan)handleMethodInvocation('build', new List<Object>{pm});
        }
    }

    public class MockOfIDataProvider extends ApexMoq implements LoanDocPrep.IDataProvider {
        public LLC_BI__Loan__c getLoan(Id loanId) {
            return (LLC_BI__Loan__c)handleMethodInvocation('getLoan', new List<Object>{loanId});
        }
        public List<LLC_BI__Loan_Collateral2__c> getLoanCollateral(Id loanId) {
            return (List<LLC_BI__Loan_Collateral2__c>)handleMethodInvocation('getLoanCollateral', new List<Object>{loanId});
        }
        public List<LLC_BI__Account_Collateral__c> getLoanCollateralOwnerships(Id loanId) {
            return (List<LLC_BI__Account_Collateral__c>)handleMethodInvocation('getLoanCollateralOwnerships', new List<Object>{loanId});
        }
        public List<LLC_BI__Legal_Entities__c> getLoanEntities(Id loanId) {
            return (List<LLC_BI__Legal_Entities__c>)handleMethodInvocation('getLoanEntities', new List<Object>{loanId});
        }
        public List<LLC_BI__Fee__c> getLoanFees(Id loanId) {
            return (List<LLC_BI__Fee__c>)handleMethodInvocation('getLoanFees', new List<Object>{loanId});
        }
        public EB_Team_Member__c getLoanOfficer(Id loanId) {
            return (EB_Team_Member__c)handleMethodInvocation('getLoanOfficer', new List<Object>{loanId});
        }
    }
}