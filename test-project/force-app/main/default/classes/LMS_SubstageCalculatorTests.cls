@IsTest
public class LMS_SubstageCalculatorTests {
    private static final LMS_Mock.OfILMS_ConfigurationRepository mockConfigRepository;
    private static final LMS_Mock.OfLMS_SubstageCalculatorHelper mockHelper;
    private static final LMS_SubstageCalculator sut;
        
    static {        
        mockConfigRepository = new LMS_Mock.OfILMS_ConfigurationRepository();
        mockHelper = new LMS_Mock.OfLMS_SubstageCalculatorHelper();
        sut = new LMS_SubstageCalculator(mockHelper, mockConfigRepository);
    }

    @IsTest
    static void it_should_return_the_substage_when_definitions_and_all_details_match_the_loan_state() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();

        LMS_LoanMetricSubstage.LMS_Definition definition01 = new LMS_LoanMetricSubstage.LMS_Definition();
        definition01.substage = 'testSubstage1';
        LMS_LoanMetricSubstage.LMS_Definition definition02 = new LMS_LoanMetricSubstage.LMS_Definition();
        definition02.substage = 'testSubstage2';

        List<LMS_LoanMetricSubstage.LMS_Definition> definitions = new List<LMS_LoanMetricSubstage.LMS_Definition>{definition01,definition02};

        mockConfigRepository.setup('getDefinitionsWithDetails').returns(definitions);
        mockHelper.setup('definitionAndDetailsMatchLoanState', new List<Object>{loan, definition01}).returns(false);
        mockHelper.setup('definitionAndDetailsMatchLoanState', new List<Object>{loan, definition02}).returns(true);
        //act
        String results = sut.calculateSubstage(loan);
        //assert
        System.assertEquals('testSubstage2', results);
    }

    @IsTest
    static void it_should_return_the_substage_when_only_the_definition_matches_the_loan_state() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();

        LMS_LoanMetricSubstage.LMS_Definition definition01 = new LMS_LoanMetricSubstage.LMS_Definition();
        definition01.substage = 'testSubstage1';
        LMS_LoanMetricSubstage.LMS_Definition definition02 = new LMS_LoanMetricSubstage.LMS_Definition();
        definition02.substage = 'testSubstage2';

        List<LMS_LoanMetricSubstage.LMS_Definition> definitions = new List<LMS_LoanMetricSubstage.LMS_Definition>{definition01,definition02};

        mockConfigRepository.setup('getDefinitionsWithDetails').returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        mockHelper.setup('definitionAndDetailsMatchLoanState', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);
        mockConfigRepository.setup('getDefinitionsWithoutDetails').returns(definitions);
        mockHelper.setup('definitionMatchesLoanState', new List<Object>{loan, definition01}).returns(false);
        mockHelper.setup('definitionMatchesLoanState', new List<Object>{loan, definition02}).returns(true);
        //act
        String results = sut.calculateSubstage(loan);
        //assert
        System.assertEquals('testSubstage2', results);
    }

    @IsTest
    static void it_should_return_the_substage_unknown_when_no_definitions_match() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();

        mockConfigRepository.setup('getDefinitionsWithDetails').returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        mockHelper.setup('definitionAndDetailsMatchLoanState', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);
        mockConfigRepository.setup('getDefinitionsWithoutDetails').returns(new List<LMS_LoanMetricSubstage.LMS_Definition>());
        mockHelper.setup('definitionMatchesLoanState', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(false);
        //act
        String results = sut.calculateSubstage(loan);
        //assert
        System.assertEquals('Substage Unknown', results);
    }
}