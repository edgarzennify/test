public with sharing class CollateralTriggerHandler extends TriggerHandler {

	private final DataProvider.IDataProvider m_dataProvider;
	private final LLCBI_CollateralAdapter.ILLCBI_CollateralAdapter m_adapter;

	public CollateralTriggerHandler(){
		m_dataProvider = new DataProvider();
		m_adapter =  new LLCBI_CollateralAdapter();
	}

	public CollateralTriggerHandler(DataProvider.IDataProvider dataProvider, LLCBI_CollateralAdapter.ILLCBI_CollateralAdapter adapter){
		m_dataProvider = dataProvider;
		m_adapter = adapter;
	}

	public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
		updateLLCBICollateralFields((List<EB_Collateral__c>)newSosMap.values());
	}

	private void updateLLCBICollateralFields(List<EB_Collateral__c> ebCollaterals){  
        Map<String, EB_Collateral__c> ebCollMap = buildEbCollMap(ebCollaterals);
        List<String> ebCollateralNames = getEbCollNames(ebCollaterals);  
        List<LLC_BI__Collateral__c> llcbiColls = m_adapter.getLLCBICollateralsByName(ebCollateralNames);
        m_dataProvider.save(getLLCBICollsToUpdate(llcbiColls, ebCollMap));
    }

    private List<LLC_BI__Collateral__c> getLLCBICollsToUpdate(List<LLC_BI__Collateral__c> llcbiColls,  Map<String, EB_Collateral__c> ebCollMap){
        List<LLC_BI__Collateral__c> updates = new List<LLC_BI__Collateral__c>(); 
        if(llcbiColls != null){
            for(LLC_BI__Collateral__c llcbiColl : llcbiColls){
                if(ebCollMap.ContainsKey(llcbiColl.LLC_BI__Collateral_Name__c)){
                    EB_Collateral__c ebColl = ebCollMap.get(llcbiColl.LLC_BI__Collateral_Name__c);
                    if(m_adapter.isDifferent(llcbiColl, ebColl)){
                        LLC_BI__Collateral__c updated = m_adapter.updateLLCBICollValues(llcbiColl, ebColl);
                        updates.add(updated);    
                    }                
                }
            }
        }
        return updates;
    }

    private Map<String, EB_Collateral__c> buildEbCollMap(List<EB_Collateral__c> colls){
        Map<String, EB_Collateral__c> newmap = new Map<String, EB_Collateral__c>();
        for(EB_Collateral__c c : colls){
            newmap.put(c.Name, c);
        }
        return newmap;
    }

    private List<String> getEbCollNames(List<EB_Collateral__c> collaterals){           
        List<String> collNames = new List<String>();
        for (EB_Collateral__c coll : collaterals){
            collNames.add(coll.Name);
        }
        return collNames;
    }
  
}