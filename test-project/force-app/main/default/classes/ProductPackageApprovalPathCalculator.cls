public class ProductPackageApprovalPathCalculator implements IProductPackageApprovalPathCalculator{
    public interface IProductPackageApprovalPathCalculator{
        void calculate(List<SObject> objects);
    }
    
    public void calculate(List<SObject> objects){
        for(LLC_BI__Product_Package__c pack : (List<LLC_BI__Product_Package__c>)objects){
            handleRecommendedApprovalPath(pack);
            materialExceptionBumper(pack);
        }
    }
    private void handleRecommendedApprovalPath(LLC_BI__Product_Package__c pack){
        if(pack.Package_Contains_Reg_O_Loans__c == true){
            pack.Recommended_Approval_Path_Apex__c = 'Reg-O Loan(s)';
        }else if(pack.Ready_for_Takedown_Approval__c == true){
            pack.Recommended_Approval_Path_Apex__c = 'Takedown Approval - RM Only';
        }else if(pack.IsAdminRenewal__c == true){
            pack.Recommended_Approval_Path_Apex__c = 'Admin Renewal';
        }else if(pack.Contains_Employee_Loans__c == true){
            pack.Recommended_Approval_Path_Apex__c = 'Employee Loan(s)';
        }else if(pack.Apply_10_Rule_Override__c == true){
            pack.Recommended_Approval_Path_Apex__c = '10% Rule';
        }else if(recordMeetsTwoSignatureCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = '2 Signature';
        }else if(recordMeetsThreeSignatureCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = '3 Signature';
        }else if(recordMeetsRLCCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'RLC';
        }else if(recordMeetsRMG2SigCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'RMG 2 Sig';
        }else if(recordMeetsRMG3SigCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'RMG 3 Sig';
        }else if(recordMeetsRMGPLCCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'RMG PLC';
        }else if(recordMeetsNonRMGPLCCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Non-RMG PLC';
        }else if(recordMeetsELCCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = '2 Signature + ELC';
        }else if(recordMeets1SignatureCriteria(pack)){
            pack.Recommended_Approval_Path_Apex__c = '1 Signature';
        }else if(recordMeetsBBGreenApproval(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Green';
        }else if(recordMeetsBBYellowApproval(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Yellow';
        }else if(recordMeetsBBOrangeApproval(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Orange';
        }else if(recordMeetsBBRedApproval(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Red';
        }else if(recordIsAwaitingPASSRecommendation(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Awaiting PASS Recommendation';
        }else if(recordRecommendedApprove(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Recommend Approve';
        }else if(recordRecommendedDeny(pack)){
            pack.Recommended_Approval_Path_Apex__c = 'Recommend Deny';
        }else{
            pack.Recommended_Approval_Path_Apex__c = 'No Approval Path Found';
        }
    }
    private Boolean recordMeetsTwoSignatureCriteria(LLC_BI__Product_Package__c pack){
        if(pack.num_of_Committee_Approved_Modifications__c != 0 && pack.num_of_Committee_Approved_Modifications__c == pack.LLC_BI__Loan_Facilities_Count__c){
            return true;
        }
        if(pack.New_Money_Renewal__c == 'New Money' && pack.Channel__c == 'Business Banking' && pack.LLC_BI__TCE__c > 150000 && pack.LLC_BI__TCE__c <= 500000){
            return true;
        }
        if(pack.Channel__c == 'Commercial Banking' && pack.LLC_BI__TCE__c <= 3000000 && pack.Risk_Rating_Num__c <= 6){
            return true;
        }
        if((pack.Channel__c == 'Consumer Banking' || pack.Channel__c == 'Private Banking') && pack.LLC_BI__TCE__c <= 7000000){
            return true;
        }
        if(pack.Channel__c == 'Business Banking' && pack.LLC_BI__TCE__c <= 150000 && pack.Contains_Policy_Exceptions__c == true){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsThreeSignatureCriteria(LLC_BI__Product_Package__c pack){
        if(pack.New_Money_Renewal__c == 'New Money' && pack.Channel__c == 'Business Banking' && pack.LLC_BI__TCE__c > 500000){
            return true;
        }
        if(pack.Channel__c == 'Commercial Banking' && pack.LLC_BI__TCE__c > 3000000 && pack.LLC_BI__TCE__c <= 5000000 && pack.Risk_Rating_Num__c <= 6){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsRLCCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Commercial Banking' && pack.LLC_BI__TCE__c >  5000000 && pack.Risk_Rating_Num__c <= 6 && (pack.LLC_BI__TCE__c <= 15000000 || pack.Officer_Region__c == 'CA')){
            return true;
        }
           return false;
    }
    private Boolean recordMeetsRMG2SigCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Resolution Management Group (RMG)' && pack.LLC_BI__TCE__c <= 750000){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsRMG3SigCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Resolution Management Group (RMG)' && pack.LLC_BI__TCE__c > 750000 && pack.LLC_BI__TCE__c <= 4000000){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsRMGPLCCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Resolution Management Group (RMG)' && pack.LLC_BI__TCE__c > 4000000){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsNonRMGPLCCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c != 'Resolution Management Group (RMG)' && pack.Risk_Rating_Num__c > 6){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsELCCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Commercial Banking' && pack.LLC_BI__TCE__c > 15000000 && pack.Risk_Rating_Num__c <= 6 && !pack.Officer_Region__c.contains('CA') && !pack.Officer_Region__c.contains('NV')){
            return true;
        }
        if((pack.Channel__c == 'Consumer Banking' || pack.Channel__c == 'Private Banking') && pack.LLC_BI__TCE__c > 7000000 && pack.Risk_Rating_Num__c <= 6){
            return true;
        }
        if(pack.Niche_Products_Require_ELC__c == true){
            return true;
        }
        return false;
    }
    private Boolean recordMeets1SignatureCriteria(LLC_BI__Product_Package__c pack){
        if(pack.Officer_is_Level_A_or_B__c == true && pack.New_Money_Renewal__c == 'Renewal' && pack.BB_Approval_Path__c == 'Green' && pack.Risk_Rating_Num__c <= 6){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsBBGreenApproval(LLC_BI__Product_Package__c pack){
        if(pack.BB_Approval_Path__c == 'Green' && pack.New_Money_Renewal__c == 'Renewal' && pack.LLC_BI__TCE__c > 150000){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsBBYellowApproval(LLC_BI__Product_Package__c pack){
        if(pack.BB_Approval_Path__c == 'Yellow' && pack.New_Money_Renewal__c == 'Renewal' && pack.LLC_BI__TCE__c > 150000){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsBBOrangeApproval(LLC_BI__Product_Package__c pack){
        if(pack.BB_Approval_Path__c == 'Orange' && pack.New_Money_Renewal__c == 'Renewal' && pack.LLC_BI__TCE__c > 150000){
            return true;
        }
        return false;
    }
    private Boolean recordMeetsBBRedApproval(LLC_BI__Product_Package__c pack){
        if(pack.BB_Approval_Path__c == 'Red' && pack.New_Money_Renewal__c == 'Renewal' && pack.LLC_BI__TCE__c > 150000){
            return true;
        }
        return false;
    }
    private Boolean recordIsAwaitingPASSRecommendation(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Business Banking' && pack.LLC_BI__TCE__c <= 150000 && pack.PASS_Recommendation__c == null && pack.Contains_Policy_Exceptions__c == false){
            return true;
        }
        return false;
    }
    private Boolean recordRecommendedApprove(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Business Banking' && pack.LLC_BI__TCE__c <= 150000 && pack.PASS_Recommendation__c == 'Approve' && pack.Contains_Policy_Exceptions__c == false){
            return true;
        }
        return false;
    }
    private Boolean recordRecommendedDeny(LLC_BI__Product_Package__c pack){
        if(pack.Channel__c == 'Business Banking' && pack.LLC_BI__TCE__c <= 150000 && pack.PASS_Recommendation__c == 'Deny' && pack.Contains_Policy_Exceptions__c == false){
            return true;
        }
        return false;
    }
    private void materialExceptionBumper(LLC_BI__Product_Package__c pack){
        Map<String, String> pathMap;
        if(pack.Channel__c != null && pack.Channel__c == 'Commercial Banking' && pack.Material_Exceptions_Approval_Required__c == true){
            if(pathMap == null){
                pathMap = buildPathMap();
            }
            pack.Recommended_Approval_Path_Apex__c = pathMap.get(pack.Recommended_Approval_Path_Apex__c);
        }
    }
    private Map<String, String> buildPathMap(){
        Map<String, String> returnMap = new Map<String, String>();
        returnMap.put('2 Signature', '3 Signature');
        returnMap.put('3 Signature', 'RLC');
        returnMap.put('RLC', '2 Signature + ELC');
        returnMap.put('2 Signature + ELC', '2 Signature + ELC');
        return returnMap;
    }
}