public class LLCBI_CollateralTriggerHandler extends TriggerHandler {

    private final DataProvider.IDataProvider m_dataProvider;
    private final LLCBI_CollateralAdapter.ILLCBI_CollateralAdapter m_adapter;

    public LLCBI_CollateralTriggerHandler(){
        m_dataProvider = new DataProvider();
        m_adapter = new LLCBI_CollateralAdapter();
    }

    public LLCBI_CollateralTriggerHandler(DataProvider.IDataProvider dataProvider, LLCBI_CollateralAdapter.ILLCBI_CollateralAdapter adapter){
        m_dataProvider = dataProvider;
        m_adapter = adapter;
    }

    public override void bulkAfterUpdate(List<Sobject> oldSos, Map<Id, SObject> newSosMap){
        updateEbCollateralFields((List<LLC_BI__Collateral__c>)newSosMap.values());        
    }

    private void updateEbCollateralFields(List<LLC_BI__Collateral__c> llcbiColls){  
        Map<String, LLC_BI__Collateral__c> llcbiCollMap = buildLLCBICollMap(llcbiColls);
        List<String> llcbiCollNames = getLLCBICollNames(llcbiColls);  
        List<EB_Collateral__c> relatedEbCollaterals = m_adapter.getEBCollateralsByName(llcbiCollNames);
        m_dataProvider.save(getEBCollsToUpdate(relatedEbCollaterals, llcbiCollMap));
    }

    private List<EB_Collateral__c> getEBCollsToUpdate(List<EB_Collateral__c> relatedEBCollaterals,  Map<String, LLC_BI__Collateral__c> llcbiCollMap){
        List<EB_Collateral__c> toUpdateEBCollaterals = new List<EB_Collateral__c>(); 
        if(relatedEBCollaterals != null){
            for(EB_Collateral__c coll : relatedEBCollaterals){
                if(llcbiCollMap.ContainsKey(coll.Name)){
                    LLC_BI__Collateral__c llcbiColl = llcbiCollMap.get(coll.Name);
                    if(m_adapter.isDifferent(llcbiColl, coll)){
                        EB_Collateral__c updated = m_adapter.updateEbCollValues(coll, llcbiColl);
                        toUpdateEBCollaterals.add(updated);    
                    }                
                }
            }
        }
        return toUpdateEBCollaterals;
    }

    private List<String> getLLCBICollNames(List<LLC_BI__Collateral__c> collaterals){           
        List<String> collNames = new List<String>();
        for (LLC_BI__Collateral__c coll : collaterals){
            collNames.add(coll.LLC_BI__Collateral_Name__c);
        }
        return collNames;
    }

    private Map<String, LLC_BI__Collateral__c> buildLLCBICollMap(List<LLC_BI__Collateral__c> colls){
        Map<String, LLC_BI__Collateral__c> newmap = new Map<String, LLC_BI__Collateral__c>();
        for(LLC_BI__Collateral__c c : colls){
            newmap.put(c.LLC_BI__Collateral_Name__c, c);
        }
        return newmap;
    }
}