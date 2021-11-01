public class BarcodeGeneratorRepository implements BarcodeGenerator.IRepository {
	
	private final BarcodeGenerator.IDataProvider m_dataProvider;
	private final Utility.IUtility m_util;
	private final BarcodeGenerator.IPmBuilder m_pmBuilder;
	private final BarcodeGenerator.IDmBuilder m_dmBuilder;

	public BarcodeGeneratorRepository(BarcodeGenerator.IDataProvider dataProvider,  BarcodeGenerator.IPmBuilder pmBuilder, BarcodeGenerator.IDmBuilder dmBuilder) {
		m_dataProvider = dataProvider;
		m_pmBuilder = pmBuilder;
		m_dmBuilder = dmBuilder;
	}

	public List<DmBgContext> getContexts() {
		List<BarcodeGeneratorCfgJunction__c> junctions = m_dataProvider.getJunctions();
		List<BarcodeGeneratorCfgDocType__c> docTypes = m_dataProvider.getDocTypes();
		return buildContextDms(junctions, docTypes);
	}

	public DmBgBatch createBatch(BarcodeGenerator.FormSm formSm) {

		BarcodeGeneratorBatch__c batch = m_pmBuilder.buildBatch(formSm.contextId);
		save(new List<SObject>{batch});
		
		BarcodeGenerator.BarcodeConfig config = m_pmBuilder.buildChildrenAndSiblings(batch, formSm);
		if(config != null) {
			save(config.children);
			BarcodeGenerator.BarcodeConfig updatedConfig = m_pmBuilder.updateSiblingsWithChildKeys(config);

			save(updatedConfig.siblings);
		}
        return batch.Id == null ? null: m_dmBuilder.buildBatch(batch.Id);
	}


	private List<DmBgContext> buildContextDms(List<BarcodeGeneratorCfgJunction__c> junctions, List<BarcodeGeneratorCfgDocType__c> docTypes) {
		List<DmBgContext> dms = new List<DmBgContext>();
        Map<Id, List<BarcodeGeneratorCfgJunction__c>> contexts = new Map<Id, List<BarcodeGeneratorCfgJunction__c>>();
		Map<Id, List<BarcodeGeneratorCfgDocType__c>> dtypes = new Map<Id, List<BarcodeGeneratorCfgDocType__c>>();
		for(BarcodeGeneratorCfgJunction__c j : junctions) {
            Id contextId = j.Context__r.Id;
            if(!contexts.containsKey(contextId)){
                contexts.put(contextId, new List<BarcodeGeneratorCfgJunction__c>());
            }
            contexts.get(contextId).add(j);
        }

		for(BarcodeGeneratorCfgDocType__c dt : docTypes) {
			if(!dtypes.containsKey(dt.Category__r.Id)) {
				dtypes.put(dt.Category__r.Id, new List<BarcodeGeneratorCfgDocType__c>());
			}
			dtypes.get(dt.Category__r.Id).add(dt);
		}

		for(Id contextId : contexts.keySet()) {
			DmBgContext dm = m_dmBuilder.buildDmContext(contextId, contexts.get(contextId), dTypes);
			dms.add(dm);
		}

		return dms;
	}


	private void save(List<SObject> sObjs) {
		m_dataProvider.save(sObjs);
	}
}