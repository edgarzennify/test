public class LLCBI_CollateralAdapter implements ILLCBI_CollateralAdapter {
    public interface ILLCBI_CollateralAdapter {
        Boolean isDifferent(LLC_BI__Collateral__c llcbiColl, EB_Collateral__c ebCollateral);
        EB_Collateral__c updateEbCollValues(EB_Collateral__c ebCollateral, LLC_BI__Collateral__c llcbiColl);
        LLC_BI__Collateral__c updateLLCBICollValues(LLC_BI__Collateral__c llcbiColl, EB_Collateral__c ebCollateral);
        List<EB_Collateral__c> getEBCollateralsByName(List<String> llcbiCollNames);
        List<LLC_BI__Collateral__c> getLLCBICollateralsByName(List<String> ebCollateralNames);
    }
    
    public Boolean isDifferent(LLC_BI__Collateral__c llcbiColl, EB_Collateral__c ebCollateral){
        return ebCollateral.Comments__c != llcbiColl.Comments__c ||
            ebCollateral.Advance_Rate__c != llcbiColl.Actual_Advance_Rate__c ||
            ebCollateral.Market_Value__c != llcbiColl.LLC_BI__Value__c ||
            ebCollateral.Non_RE_Valuation_Date__c != llcbiColl.Non_RE_Valuation_Date__c ||
            ebCollateral.Existing_Debt__c != llcbiColl.Existing_Debt__c;
    }
    
    public EB_Collateral__c updateEbCollValues(EB_Collateral__c ebCollateral, LLC_BI__Collateral__c llcbiColl){
        ebCollateral.Comments__c = llcbiColl.Comments__c;
        ebCollateral.Advance_Rate__c = llcbiColl.Actual_Advance_Rate__c;
        ebCollateral.Market_Value__c = llcbiColl.LLC_BI__Value__c;
        ebCollateral.Non_RE_Valuation_Date__c = llcbiColl.Non_RE_Valuation_Date__c;
        ebCollateral.Existing_Debt__c = llcbiColl.Existing_Debt__c;
        return ebCollateral;
    }
    
    public LLC_BI__Collateral__c updateLLCBICollValues(LLC_BI__Collateral__c llcbiColl, EB_Collateral__c ebCollateral){
        llcbiColl.Comments__c = ebCollateral.Comments__c;
        llcbiColl.Actual_Advance_Rate__c = ebCollateral.Advance_Rate__c;
        llcbiColl.LLC_BI__Value__c = ebCollateral.Market_Value__c;
        llcbiColl.Non_RE_Valuation_Date__c = ebCollateral.Non_RE_Valuation_Date__c;
        llcbiColl.Existing_Debt__c = ebCollateral.Existing_Debt__c;
        return llcbiColl;
    }
    
    public List<EB_Collateral__c> getEBCollateralsByName(List<String> llcbiCollNames){
         return [
            SELECT 
                Id
                ,Name
                ,Comments__c
                ,Advance_Rate__c
                ,Market_Value__c
                ,Non_RE_Valuation_Date__c
                ,Existing_Debt__c                         
            FROM
                EB_Collateral__c  
            WHERE
                (Name IN: llcbiCollNames AND Name != null AND Name != '')            
        ];        
    }
    
    public List<LLC_BI__Collateral__c> getLLCBICollateralsByName(List<String> ebCollateralNames){
         return [
            SELECT
                Id
                ,LLC_BI__Collateral_Name__c
                ,Comments__c
                ,Actual_Advance_Rate__c
                ,LLC_BI__Value__c
                ,Non_RE_Valuation_Date__c
                ,Existing_Debt__c                         
            FROM
                LLC_BI__Collateral__c  
            WHERE
                (LLC_BI__Collateral_Name__c IN: ebCollateralNames AND LLC_BI__Collateral_Name__c != null AND LLC_BI__Collateral_Name__c != '')            
        ];        
    }
}