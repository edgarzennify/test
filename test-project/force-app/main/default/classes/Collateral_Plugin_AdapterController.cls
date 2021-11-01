public class Collateral_Plugin_AdapterController {
    private final Plugin.ICollateral_PluginDataProvider m_dataProvider;
    private final IApexPages m_apexPages;
       
    public Collateral_Plugin_AdapterController(Plugin.ICollateral_PluginDataProvider dataProvider, IApexPages apexPages ) {
         m_dataProvider = dataProvider;
         m_apexPages = apexPages;
    }
    
    public Collateral_Plugin_AdapterController() {
        m_dataProvider = new Collateral_PluginDataProvider();     
        m_apexPages = new ApexPagesWrapper();
    }
 
    public PageReference GetEbCollateralAndForwardToAppraisalOrder(){     
        LLC_BI__Collateral__c collateral = getCollateral();
        Id primaryOwnerId = getCollateralPrimaryOwner(collateral);

        if(primaryOwnerId == null){
            String url = '/apex/Collateral_Plugin_No_Owner_Error';
            return redirectReference(url);
        }
        
        EB_Collateral__c ebCollateral = getEbCollateralTwin(collateral, primaryOwnerId);     

        String url = String.Format('/apex/AppraisalOrder?collateralId={0}&scontrolCaching=1&retURL=%2F{1}&sfdc.override=1',new string[]{ebCollateral.Id, collateral.Id});
        return redirectReference(url);
    }

    private EB_Collateral__c getEbCollateralTwin(LLC_BI__Collateral__c collateral, Id primaryOwnerId){
        EB_Collateral__c twin = new EB_Collateral__c();
        List<EB_Collateral__c> ebColl = m_dataProvider.getEbCollateralByNameOrKey(collateral.Name, collateral.Sync_Key__c);
        
        if(ebColl == null || ebColl.size() == 0){ 
            twin.Name = collateral.Name; 
            twin.Collateral_Number__c = collateral.Name;  
            twin.Collateral_Owner__c = primaryOwnerId; 
        } else {
            twin = ebColl[0];
        }

        Id coreCollateralCodeId = getCoreCollateralCodeId(collateral);
        Id collateralCodeId = getCollateralCodeId(collateral);
        
        twin.Core_Collateral_Code__c = coreCollateralCodeId;
        twin.Collateral_Code__c = collateralCodeId == null ? coreCollateralCodeId : collateralCodeId;
        twin.Street__c = collateral.LLC_BI__Street_Address__c;
        twin.City__c = collateral.LLC_BI__City__c;
        twin.State__c = collateral.LLC_BI__State__c;
        twin.Zip_Code__c = collateral.LLC_BI__Zip_Code__c;

        m_dataProvider.save(twin);
        return twin;
    }

    private Id getCoreCollateralCodeId(LLC_BI__Collateral__c collateral){
        return m_dataProvider.getCollateralCode(collateral.LLC_BI__Collateral_Type__r.LLC_BI__Collateral_Code__c).Id;            
    }

    private Id getCollateralCodeId(LLC_BI__Collateral__c collateral){
        try{
            return m_dataProvider.getCollateralCode(collateral.Modified_Collateral_Type__r.LLC_BI__Collateral_Code__c).Id; 
        }catch(Exception ex){
            return null;
        }        
    }

    private LLC_BI__Collateral__c getCollateral(){
        String id = m_apexPages.getParameter('collateralId');
        return m_dataProvider.getNcinoCollateralById(id); 
    }

    private Id getCollateralPrimaryOwner(LLC_BI__Collateral__c collateral){     
        for(LLC_BI__Account_Collateral__c relColl : collateral.LLC_BI__Account_Collateral__r){
            if(relColl.LLC_BI__Primary_Owner__c == true){
                return relColl.LLC_BI__Account__c;
            } 
        } 
        for(LLC_BI__Account_Collateral__c relColl : collateral.LLC_BI__Account_Collateral__r){
            if(relColl.LLC_BI__Account__c != null){
                return relColl.LLC_BI__Account__c;
            }           
        }
        return null;
    }

    private static PageReference redirectReference(String url){
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }
}