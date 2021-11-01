@IsTest
public class LMS_SubstageCalculatorHelperTests {

    private static final LMS_SubstageCalculatorHelper sut;
    private static final Mock.ofIRuleEvaluator mockRuleEvaluator;

    static {
        mockRuleEvaluator = new Mock.ofIRuleEvaluator();
        sut = new LMS_SubstageCalculatorHelper(mockRuleEvaluator);
    }

    @IsTest
    static void it_should_return_true_when_the_definition_matches_the_loan_state_regardless_of_case() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'TeSt StAtUs';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'tEsT sTaGe';
        definition.loanStatus = 'test status';
        
        Boolean results = sut.definitionMatchesLoanState(loan, definition);
        
        System.assertEquals(true, results);
    }
    
    @IsTest
    static void it_should_return_true_if_loan_string_values_are_null() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = null;
        loan.LLC_BI__Status__c = null;
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = '';
        definition.loanStatus = '';
        
        Boolean results = sut.definitionMatchesLoanState(loan, definition);
        
        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_true_if_definition_string_values_are_null() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = '';
        loan.LLC_BI__Status__c = '';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = null;
        definition.loanStatus = null;
        
        Boolean results = sut.definitionMatchesLoanState(loan, definition);
        
        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_true_if_all_string_values_are_null() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = null;
        loan.LLC_BI__Status__c = null;
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = null;
        definition.loanStatus = null;
        
        Boolean results = sut.definitionMatchesLoanState(loan, definition);
        
        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_true_if_all_string_values_are_blank() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = '';
        loan.LLC_BI__Status__c = '';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = '';
        definition.loanStatus = '';
        
        Boolean results = sut.definitionMatchesLoanState(loan, definition);
        
        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_false_when_the_definition_does_not_match_the_loan_state() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'test status';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'foo stage';
        definition.loanStatus = 'bar status';
        
        Boolean results = sut.definitionMatchesLoanState(loan, definition);
        
        System.assertEquals(false, results);
    }

    @IsTest
    static void it_should_return_true_when_the_loan_state_matches_the_definition_and_all_of_the_definitions_details() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'test status';
        loan.Ready_for_Underwriting__c = true;
        loan.Ready_for_Approval__c = false;
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'test stage';
        definition.loanStatus = 'test status';
        LMS_LoanMetricSubstage.LMS_Definition_Detail detail01 = new LMS_LoanMetricSubstage.LMS_Definition_Detail();
        detail01.fieldReference = 'Ready_for_Underwriting__c';
        detail01.operand = 'true';
        detail01.operator = '=';
        LMS_LoanMetricSubstage.LMS_Definition_Detail detail02 = new LMS_LoanMetricSubstage.LMS_Definition_Detail();
        detail02.fieldReference = 'Ready_for_Approval__c';
        detail02.operand = 'false';
        detail02.operator = '=';
        List<LMS_LoanMetricSubstage.LMS_Definition_Detail> details = new list<LMS_LoanMetricSubstage.LMS_Definition_Detail>{detail01,detail02};
        definition.details = details;

        mockRuleEvaluator.setup('evaluate', new List<Object>{'LLC_BI__Loan__c', detail01.fieldReference, true, '=', 'true'}).returns(true);
        mockRuleEvaluator.setup('evaluate', new List<Object>{'LLC_BI__Loan__c', detail02.fieldReference, false, '=', 'false'}).returns(true);

        Boolean results = sut.definitionAndDetailsMatchLoanState(loan, definition);
        
        System.assertEquals(true, results);
    }

    @IsTest
    static void it_should_return_false_when_the_definition_matches_the_loan_state_and_not_all_details_match_the_loan_state() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'test status';
        loan.Ready_for_Underwriting__c = true;
        loan.Ready_for_Approval__c = true;
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'test stage';
        definition.loanStatus = 'test status';
        LMS_LoanMetricSubstage.LMS_Definition_Detail detail01 = new LMS_LoanMetricSubstage.LMS_Definition_Detail();
        detail01.fieldReference = 'Ready_for_Underwriting__c';
        detail01.operand = 'true';
        detail01.operator = '=';
        LMS_LoanMetricSubstage.LMS_Definition_Detail detail02 = new LMS_LoanMetricSubstage.LMS_Definition_Detail();
        detail02.fieldReference = 'Ready_for_Approval__c';
        detail02.operand = 'false';
        detail02.operator = '=';
        List<LMS_LoanMetricSubstage.LMS_Definition_Detail> details = new list<LMS_LoanMetricSubstage.LMS_Definition_Detail>{detail01,detail02};
        definition.details = details;

        mockRuleEvaluator.setup('evaluate', new List<Object>{'LLC_BI__Loan__c', detail01.fieldReference, true, '=', 'true'}).returns(true);
        mockRuleEvaluator.setup('evaluate', new List<Object>{'LLC_BI__Loan__c', detail02.fieldReference, true, '=', 'false'}).returns(false);

        Boolean results = sut.definitionAndDetailsMatchLoanState(loan, definition);
        
        System.assertEquals(false, results);
    }

    @IsTest
    static void it_should_return_false_when_the_definition_does_not_match_the_loan_state_before_checking_details_against_loan() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'test status';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'foo stage';
        definition.loanStatus = 'bar status';
        
        Boolean results = sut.definitionAndDetailsMatchLoanState(loan, definition);
        
        System.assertEquals(false, results);
    }

    @IsTest
    static void it_should_return_false_when_a_definitions_details_are_empty() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'test status';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'test stage';
        definition.loanStatus = 'test status';
        definition.details = new list<LMS_LoanMetricSubstage.LMS_Definition_Detail>();
        
        Boolean results = sut.definitionAndDetailsMatchLoanState(loan, definition);
        
        System.assertEquals(false, results);
    }

    @IsTest
    static void it_should_return_false_when_a_definitions_details_are_null() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Stage__c = 'test stage';
        loan.LLC_BI__Status__c = 'test status';
        LMS_LoanMetricSubstage.LMS_Definition definition = new LMS_LoanMetricSubstage.LMS_Definition();
        definition.loanStage = 'test stage';
        definition.loanStatus = 'test status';
        definition.details = null;
        
        Boolean results = sut.definitionAndDetailsMatchLoanState(loan, definition);
        
        System.assertEquals(false, results);
    }
}