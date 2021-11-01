public class TmValidatorBootstrapper {

    public static TmValidator.IRepository getRepositoryInstance() {
        TmValidator.IDataProvider dataProvider = new TmValidatorDataProvider();
        TmValidator.IDmBuilder dmBuilder = new TmValidatorDmBuilder();
        return new TmValidatorRepository(dataProvider, dmBuilder);
    }
    
	public static TmValidator.IRuleRunnerProvider getRuleRunnerProviderInstance(ErrorRepository.IErrorRepository errors) {
        Utility.IUtility util = new Utility();
        TmValidator.IRepository repository = getRepositoryInstance();
        QueueFactory.IQueueFactory queueFactory = new QueueFactory();
        StackFactory.IStackFactory stackFactory = new StackFactory();
        ShuntingYard.IShuntingYard algorithm = new ShuntingYard(queueFactory, stackFactory);
        RuleEvaluatorHelper.IRuleEvaluatorHelper ruleHelper = new RuleEvaluatorHelper();
        SObjectFieldFactory.ISObjectFieldFactory schemaFactory= new SObjectFieldFactory();
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        SchemaProvider.ISchemaProviderHelper schHelper = new SchemaProviderHelper(schemaFactory, cache);
        ISchema schema = new SchemaProvider(schHelper);
        RuleEvaluator.IRuleEvaluator ruleEvaluator = new RuleEvaluator(ruleHelper, schema);
        TmValidator.IRuleRunner ruleRunner = new TmValidatorRuleRunner(algorithm, errors, ruleEvaluator);
        TmValidator.IRuleManager ruleManager = new TmValidatorRuleManager();
        return new TmValidatorRuleRunnerProvider(ruleRunner, repository, ruleManager, util);
    }
}