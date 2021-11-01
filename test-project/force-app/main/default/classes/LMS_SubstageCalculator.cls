public class LMS_SubstageCalculator implements LMS_LoanMetricSubstage.ILMS_SubstageCalculator {
    
    private static LMS_LoanMetricSubstage.ILMS_SubstageCalculatorHelper m_calculatorHelper;
    private static LMS_LoanMetricSubstage.ILMS_ConfigurationRepository m_configRepository;
    private final String SUBSTAGE_UNKNOWN = 'Substage Unknown';

    public LMS_SubstageCalculator(LMS_LoanMetricSubstage.ILMS_SubstageCalculatorHelper calculatorHelper, LMS_LoanMetricSubstage.ILMS_ConfigurationRepository configRepository) {
        m_calculatorHelper = calculatorHelper;
        m_configRepository = configRepository;
    }

    public String calculateSubstage(LLC_BI__Loan__c loan) {
        for (LMS_LoanMetricSubstage.LMS_Definition d : m_configRepository.getDefinitionsWithDetails()) {
            if (m_calculatorHelper.definitionAndDetailsMatchLoanState(loan, d)) {
                return d.substage;
            }
        }

        for (LMS_LoanMetricSubstage.LMS_Definition d : m_configRepository.getDefinitionsWithoutDetails()) {
            if (m_calculatorHelper.definitionMatchesLoanState(loan, d)) {
                return d.substage;
            }
        }

        return SUBSTAGE_UNKNOWN;
    }

    public static LMS_LoanMetricSubstage.ILMS_SubstageCalculator bootstrap() {
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SObjectFieldFactory.ISObjectFieldFactory fieldFactory = new SObjectFieldFactory();
        SchemaProvider.ISchemaProviderHelper schemaHelper = new SchemaProviderHelper(fieldFactory, cache);
        ISchema schema = new SchemaProvider(schemaHelper);
        RuleEvaluatorHelper.IRuleEvaluatorHelper ruleEvaluatorHelper = new RuleEvaluatorHelper();
        RuleEvaluator.IRuleEvaluator ruleEvaluator = new RuleEvaluator(ruleEvaluatorHelper, schema);
        LMS_LoanMetricSubstage.ILMS_SubstageCalculatorHelper calculatorHelper = new LMS_SubstageCalculatorHelper(ruleEvaluator);
        LMS_LoanMetricSubstage.ILMS_DataProvider dataProvider = new LMS_DataProvider();
        LMS_LoanMetricSubstage.ILMS_ConfigurationRepository repository = new LMS_ConfigurationRepository(dataProvider, cache);
        return new LMS_SubstageCalculator(calculatorHelper, repository);
    }
}