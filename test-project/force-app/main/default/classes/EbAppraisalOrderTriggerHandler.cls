public with sharing class EbAppraisalOrderTriggerHandler extends TriggerHandler
{   
    public interface IEbAppraisalOrderTrigHandlerDataProv {
        List<EB_Collateral__c> getRelatedEbCollateralsByIds(List<Id> apprOrderRelCollIds);
        List<LLC_BI__Collateral__c> getNcinoCollateralsByNameOrKey(List<String> relEbCollNames, List<String> relEbCollKeys);
        void updateNcinoCollateralsAppraisalFields(List<LLC_BI__Collateral__c> nCinoColls);
    }

    private final IEbAppraisalOrderTrigHandlerDataProv m_dataProvider;
    private List<EB_Collateral__c> m_relatedEbCollaterals;
    private List<LLC_BI__Collateral__c> m_ncinoCollaterals;
    
    public EbAppraisalOrderTriggerHandler()
    {
        m_dataProvider = new EbAppraisalOrderTrigHandlerDataProvider();
    }

    public EbAppraisalOrderTriggerHandler(IEbAppraisalOrderTrigHandlerDataProv dataProvider)
    {
        m_dataProvider = dataProvider;
    }
       
    public override void bulkAfterInsert(List<SObject> sos){
        updateNcinoCollAppraisalFields((List<EB_Appraisal_Order__c>)sos);     
    }
    
    public override void bulkAfterUpdate(List<Sobject> oldSos, Map<Id, SObject> newSosMap){
        updateNcinoCollAppraisalFields((List<EB_Appraisal_Order__c>)newSosMap.values());  
    }
               
    private void updateNcinoCollAppraisalFields(List<EB_Appraisal_Order__c> appraisals){         
        List<Id> apprOrderRelCollIds = getApprOrderRelCollIds(appraisals);     
        
        m_relatedEbCollaterals = m_dataProvider.getRelatedEbCollateralsByIds(apprOrderRelCollIds);
      
        Map<Id, EB_Collateral__c> ebCollMap = buildEbCollMap(m_relatedEbCollaterals);
               
        List<String> relEbCollNames = new List<String>();
        List<String> relEbCollKeys = new List<String>();
        for(EB_Collateral__c ebColl : m_relatedEbCollaterals){
            relEbCollNames.add(ebColl.Name );
            relEbCollKeys.add(ebColl.Key__c );
        }        
        m_ncinoCollaterals = m_dataProvider.getNcinoCollateralsByNameOrKey(relEbCollNames,relEbCollKeys); 
        
        Map<String, LLC_BI__Collateral__c> ncinoCollMap = buildNcinoCollMap(m_ncinoCollaterals);
        
        List<LLC_BI__Collateral__c> toUpdateNcinoCollaterals = getNcinoCollsToUpdate(appraisals, ebCollMap, ncinoCollMap);
                        
        m_dataProvider.updateNcinoCollateralsAppraisalFields(toUpdateNcinoCollaterals);     
    }
    
    private List<LLC_BI__Collateral__c> getNcinoCollsToUpdate(List<EB_Appraisal_Order__c> appraisals, Map<Id, EB_Collateral__c> ebCollMap, Map<String, LLC_BI__Collateral__c> ncinoCollMap){
        List<LLC_BI__Collateral__c> toUpdateNcinoCollaterals = new List<LLC_BI__Collateral__c>();        
        for(EB_Appraisal_Order__c appr :appraisals){
            if(ebCollMap.containsKey(appr.Related_Collateral__c)){
                EB_Collateral__c coll = ebCollMap.get(appr.Related_Collateral__c);                   
                String mapkey = '';
                if(ncinoCollMap.containsKey(coll.Name)){
                    mapkey=coll.Name;  
                } else if(ncinoCollMap.containsKey(coll.Key__c)){
                    mapkey=coll.Key__c;
                }                    
                if(!String.isBlank(mapkey)){
                    LLC_BI__Collateral__c ncinoColl = ncinoCollMap.get(mapkey);
                    toUpdateNcinoCollaterals.add(updateOneNcinoCollAppraisalValues(appr,ncinoColl));
                }
            }    
        }
        return toUpdateNcinoCollaterals;
    }    
    
    private List<Id> getApprOrderRelCollIds(List<EB_Appraisal_Order__c> appraisals){           
        List<Id> apprOrderRelCollIds = new List<Id>();
        for (EB_Appraisal_Order__c appOrd : appraisals){
           apprOrderRelCollIds.add(appOrd.Related_Collateral__c);
        }
        return apprOrderRelCollIds;
    }
    
    private LLC_BI__Collateral__c updateOneNcinoCollAppraisalValues(EB_Appraisal_Order__c appraisal, LLC_BI__Collateral__c ncinoCollateral){       
            ncinoCollateral.USPAP_Compliant__c = appraisal.USPAP_Compliant__c;
            ncinoCollateral.FDIC_Valuation_Type__c = appraisal.FDIC_Valuation_Type__c;
            ncinoCollateral.Valuation_Date__c = appraisal.Valuation_Date__c;
            ncinoCollateral.As_Completed_Value__c = appraisal.As_Completed_Value__c; 
            ncinoCollateral.As_Is_Value__c = appraisal.As_Is_Value__c;
            ncinoCollateral.As_Liquidated_Value__c = appraisal.As_Liquidated_Value__c;
            ncinoCollateral.As_Stabilized_Value__c = appraisal.As_Stabilized_Value__c;
            ncinoCollateral.Appraisal_Company_Used__c = appraisal.Appraisal_Company_Used__c;
            ncinoCollateral.Oasis_Order_Number__c = appraisal.Oasis_Order_Number__c;
            ncinoCollateral.Appraised_Value_reviewed__c = appraisal.Appraised_Value_reviewed__c;
            return ncinoCollateral;
    }  
    
    private Map<Id, EB_Collateral__c> buildEbCollMap(List<EB_Collateral__c> ebColls){
        Map<Id, EB_Collateral__c> ebCollMap = new Map<Id, EB_Collateral__c>();
        for(EB_Collateral__c ebColl : ebColls){
            ebCollMap.put(ebColl.Id, ebColl);
        }
        return ebCollMap;
    }
    
    private Map<String, LLC_BI__Collateral__c> buildNcinoCollMap(List<LLC_BI__Collateral__c> colls){
        Map<String, LLC_BI__Collateral__c> newmap = new Map<String, LLC_BI__Collateral__c>();
        for(LLC_BI__Collateral__c c : colls){
            newmap.put(c.Name, c);
            newmap.put(c.Sync_Key__c, c);
        }
        return newmap;
    }
}