public class LMS_SubstageCalculatorHelper implements LMS_LoanMetricSubstage.ILMS_SubstageCalculatorHelper {

    private final RuleEvaluator.IRuleEvaluator m_ruleEvaluator;
    private final String LOAN_OBJECT_NAME = 'LLC_BI__Loan__c';

    public LMS_SubstageCalculatorHelper(RuleEvaluator.IRuleEvaluator ruleEvaluator) {
        m_ruleEvaluator = ruleEvaluator;
    }
    
    public Boolean definitionMatchesLoanState(LLC_BI__Loan__c loan, LMS_LoanMetricSubstage.LMS_Definition definition){
        String loanStage = loan.LLC_BI__Stage__c;
        String loanStatus = loan.LLC_BI__Status__c;
        String definitionStage = definition.loanStage;
        String definitionStatus = definition.loanStatus;
        
        if (String.isBlank(loanStage)) { loanStage = ''; }
        if (String.isBlank(loanStatus)) { loanStatus = ''; }
        if (String.isBlank(definitionStage)) { definitionStage = ''; }
        if (String.isBlank(definitionStatus)) { definitionStatus = ''; }
        
        if (loanStage.equalsIgnoreCase(definitionStage) && loanStatus.equalsIgnoreCase(definitionStatus)) {
            return true;
        }
        return false;
    }

    public Boolean definitionAndDetailsMatchLoanState(LLC_BI__Loan__c loan, LMS_LoanMetricSubstage.LMS_Definition definition) {
        if (definitionMatchesLoanState(loan, definition) && dmDetailsAreValid(definition.details)) {
            return allDetailsMatchLoanState(loan, definition.details);
        }
        return false;
    }
    
    private Boolean allDetailsMatchLoanState(LLC_BI__Loan__c loan, List<LMS_LoanMetricSubstage.LMS_Definition_Detail> details) {
        for (LMS_LoanMetricSubstage.LMS_Definition_Detail detail : details) {
            Object subjectOperand = loan.get(detail.FieldReference);
            if (!m_ruleEvaluator.evaluate(LOAN_OBJECT_NAME, detail.FieldReference, subjectOperand, detail.Operator, detail.Operand)) {
                return false;
            }
        }
        return true;
    }

    private Boolean dmDetailsAreValid(List<LMS_LoanMetricSubstage.LMS_Definition_Detail> details){
        return (details == null || details.isEmpty()) ? false : true;
    }
}