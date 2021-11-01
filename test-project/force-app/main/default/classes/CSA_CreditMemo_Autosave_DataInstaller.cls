public class CSA_CreditMemo_Autosave_DataInstaller implements InstallHandler, UninstallHandler  {

	private nFORCE.LifeCycleDataProvider forceProvider;

	public void onInstall(InstallContext context){
		forceProvider = new nFORCE.LifeCycleDataProvider();
		registerTriggerPipeline(
			generateName('product-package-after-update-triggers-autosave'),
			CSA_CreditMemo_Autosave_NarrativeHandler.BEAN_NAME);

		registerTriggerHandlerBean(
			CSA_CreditMemo_Autosave_NarrativeHandler.BEAN_NAME,
			CSA_CreditMemo_Autosave_NarrativeHandler.class
		);
		new nFORCE.LifeCycleDao(forceProvider).performAllDml();
		forceProvider.clear();
	}
	private void registerTriggerPipeline(String beanName, String pipeline) {
		registerTriggerPipeline(
			beanName,
			new Map<String, Object>{
				nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
					pipeline}});
	}
	private void registerTriggerPipeline(String beanName, String pipeline1, String pipeLine2) {
		registerTriggerPipeline(
			beanName,
			new Map<String, Object>{
				nFORCE.PipelineContainer.PIPELINE_BEAN_UNIQUE_NAMES => new String[]{
					pipeline1,
					pipeLine2}});
	}
	private void registerTriggerPipeline(String beanName, Map<String, Object> pipeline) {
		nFORCE.BeanRegistry.getInstance().registerBean(
			beanName,
			nFORCE.IPipelineContainer.class,
			nFORCE.TriggerPipeline.class,
			pipeline,
			true,
			forceProvider);
	}
	private void registerTriggerHandlerBean(String beanName, Type className) {
		nFORCE.BeanRegistry.getInstance().registerBean(
			beanName,
			nFORCE.IPipelineContainer.class,
			className,
			new Map<String, Object>(),
			true,
			forceProvider);
	}
	private static String generateName(String name) {
		return nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
			nFORCE.IPipelineComponent.class,
			name);
	}
	public void onUninstall(UninstallContext context){ }
	public static final String PRODUCT_PACKAGE_AFTER_INSERT_TRIGGERS_BEAN = 
			nFORCE.BeanRegistry.getInstance().generateUniqueBeanName(
	 		nFORCE.IPipelineComponent.class, 'product-package-after-update-triggers-autosave');		
}