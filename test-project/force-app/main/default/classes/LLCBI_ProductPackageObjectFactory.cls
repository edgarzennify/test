public class LLCBI_ProductPackageObjectFactory implements IProductPackageFactory{
    public interface IProductPackageFactory{
        List<LLC_BI__Product_Package__c> updatePackages(List<SObject> oldSos, Map<Id, SObject> newSosMap);
        void updatePackageApprovers(List<SObject> oldSos, Map<Id, SObject> newSosMap);
        void setGuidanceLineTakedownApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap);
        void setAllFacilitiesApproved(Map<Id, SObject> newSosMap);
        List<Approval.ProcessSubmitRequest> gatherPackagesAndLoansThatNeedAutoApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap);
    }
    public interface IProductPackageFactoryDataProvider{
        List<LLC_BI__Product_Package__c> getProductPackages(Set<Id> packageIds);
        List<LLC_BI__Loan__c> getLoansRelatedToPackages(Set<Id> packageIds);
    }
    private final IProductPackageFactoryDataProvider m_dataProv;
    
    public LLCBI_ProductPackageObjectFactory(){
        m_dataProv = new LLCBI_ProductPackageFactoryDataProvider();
    }
    public LLCBI_ProductPackageObjectFactory(IProductPackageFactoryDataProvider dataProv){
        m_dataProv = dataProv;
    }
    
    private static Set<Id> packageIds;
    private static Map<Id, LLC_BI__Product_Package__c> packageMap;
    private static Map<Id, List<LLC_BI__Loan__c>> m_loansToPackageMap;
    
    public List<LLC_BI__Product_Package__c> updatePackages(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<LLC_BI__Product_Package__c> packagesToReturn = new List<LLC_BI__Product_Package__c>();
        if(packageIds == null){
            packageIds = getPackageIds(newSosMap.values());
        }
        if(packageMap == null){
            packageMap = mapProductPackages(packageIds);
        }
        if(m_loansToPackageMap == null){
            m_loansToPackageMap = getLoansRelatedToPackages(packageIds);
        }
        packagesToReturn.addAll(updatePackageExceptionsAndApprovals(oldSos, newSosMap));
        return packagesToReturn != null && packagesToReturn.size() >0 ? packagesToReturn : null;
    }
    public void updatePackageApprovers(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        setRMGApprovers((List<LLC_BI__Product_Package__c>)newSosMap.values());
        setApproverType((List<LLC_BI__Product_Package__c>) oldSos, newSosMap );
    }
    public void setGuidanceLineTakedownApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        if(m_loansToPackageMap == null){
            m_loansToPackageMap = getLoansRelatedToPackages(newSosMap.keySet());
        }
        for(LLC_BI__Product_Package__c oldPack : (List<LLC_BI__Product_Package__c>)oldSos){
            LLC_BI__Product_Package__c newPack = (LLC_BI__Product_Package__c)newSosMap.get(oldPack.Id);
            List<LLC_BI__Loan__c> relatedLoans = m_loansToPackageMap.get(newPack.Id);
            if(hasStatusChanged(oldPack, newPack) && newPack.LLC_BI__Status__c == 'Approved' && relatedLoans != null){
                for(LLC_BI__Loan__c l : relatedLoans){
                    if(l.LLC_BI__Structure_Hierarchy__c == 'Main'){
                        newPack.Ready_for_Takedown_Approval__c = true;
                        break;
                    }
                }
            }
        }
    }
    public void setAllFacilitiesApproved(Map<Id, SObject> newSosMap){
        if(m_loansToPackageMap == null){
            m_loansToPackageMap = getLoansRelatedToPackages(newSosMap.keySet());
        }
        if(m_loansToPackageMap != null){
            for(LLC_BI__Product_Package__c pack : (List<LLC_BI__Product_Package__c>) newSosMap.values()){
                List<LLC_BI__Loan__c> relatedLoans = m_loansToPackageMap.get(pack.Id);
                if(relatedLoans != null && relatedLoans.size() > 0){
                    for(LLC_BI__Loan__c l : relatedLoans){
                        if(l.LLC_BI__Stage__c == 'Credit Request' || l.LLC_BI__Stage__c == 'Credit Underwriting'){
                            pack.All_Facilities_Approved__c = false;
                            break;
                        }else{
                            pack.All_Facilities_Approved__c = true;
                        }
                    }
                }
            }
        }
    }
    public List<Approval.ProcessSubmitRequest> gatherPackagesAndLoansThatNeedAutoApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        if(m_loansToPackageMap == null){
            m_loansToPackageMap = getLoansRelatedToPackages(newSosMap.keySet());
        }
        List<SObject> objectsToReturn = new List<SObject>();
        for(LLC_BI__Product_Package__c oldPack : (List<LLC_BI__Product_Package__c>)oldSos){
            LLC_BI__Product_Package__c newPack = (LLC_BI__Product_Package__c)newSosMap.get(oldPack.Id);
            if(packageReadyForAutoApproval(oldPack, newPack)){
                objectsToReturn.add(newPack);
                objectsToReturn.addAll(m_loansToPackageMap.get(newPack.Id));
            }
        }
        if(objectsToReturn != null && objectsToReturn.size() > 0){
            return getApprovalSubmitRequests(objectsToReturn);
        }
        return null;
    }

    private Set<Id> getPackageIds(List<LLC_BI__Loan__c> loans) {
        Set<Id> packageIds = new Set<Id>();
        for (LLC_BI__Loan__c ln : loans) {
            if (ln.LLC_BI__Product_Package__c != null) {
                packageIds.add(ln.LLC_BI__Product_Package__c);
            }
        }
        return packageIds;
    }
    private Map<Id, LLC_BI__Product_Package__c> mapProductPackages(Set<Id> packageIds) {
        List<LLC_BI__Product_Package__c> packages = m_dataProv.getProductPackages(packageIds);
        Map<Id,LLC_BI__Product_Package__c> packageMap = new Map<Id, LLC_BI__Product_Package__c>();
        if (packages != null && packages.size() > 0) {
            for (LLC_BI__Product_Package__c pack : packages) {
                packageMap.put(pack.Id, pack);
            }
        }
        return packageMap;
    }
    private Map<Id, List<LLC_BI__Loan__c>> getLoansRelatedToPackages(Set<Id> packageIds) {
        Map<Id, List<LLC_BI__Loan__c>> returnMap = new Map<Id, List<LLC_BI__Loan__c>>();
        List<LLC_BI__Loan__c> allLoansRelatedToPackages = m_dataProv.getLoansRelatedToPackages(packageIds);
        if (allLoansRelatedToPackages != null && allLoansRelatedToPackages.size() >0) {
            for (LLC_BI__Loan__c loan : allLoansRelatedToPackages) {
                if (returnMap.containsKey(loan.LLC_BI__Product_Package__c)) {
                    returnMap.get(loan.LLC_BI__Product_Package__c).add(loan);
                }
                else {
                    returnMap.put(loan.LLC_BI__Product_Package__c, new List<LLC_BI__Loan__c>());
                    returnMap.get(loan.LLC_BI__Product_Package__c).add(loan);
                }
            }
        }
        return returnMap;
    }
    private List<LLC_BI__Product_Package__c> updatePackageExceptionsAndApprovals(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<LLC_BI__Product_Package__c> packagesToUpdate = new List<LLC_BI__Product_Package__c>();
        Set<Id> updatedPackageIds = new Set<Id>();
        for (LLC_BI__Loan__c oldLoan : (List<LLC_BI__Loan__c>)oldSos) {
            LLC_BI__Loan__c newLoan = (LLC_BI__Loan__c)newSosMap.get(oldLoan.Id);
            List<LLC_BI__Loan__c> loansRelatedToPackage = m_loansToPackageMap.get(newLoan.LLC_BI__Product_Package__c);
            if(loanHasPolicyExceptions(newLoan, packageMap.get(newLoan.LLC_BI__Product_Package__c))){
                packageMap.get(newLoan.LLC_BI__Product_Package__c).Contains_Policy_Exceptions__c = true;
                updatedPackageIds.add(newLoan.LLC_BI__Product_Package__c);
            }
            if(packageNeedsPASSRecommendationUpdated(packageMap.get(newLoan.LLC_BI__Product_Package__c), oldLoan, newLoan, loansRelatedToPackage)){
                packageMap.get(newLoan.LLC_BI__Product_Package__c).PASS_Recommendation__c = newLoan.PASS_Recommendation__c;
                updatedPackageIds.add(newLoan.LLC_BI__Product_Package__c);
            }
            if(loanHasMaterialUnderwritingExceptions(newLoan)){
                packageMap.get(newLoan.LLC_BI__Product_Package__c).Material_Exceptions_Approval_Required__c = true;
                updatedPackageIds.add(newLoan.LLC_BI__Product_Package__c);
            }else if(packageMap.get(newLoan.LLC_BI__Product_Package__c) != null && packageMap.get(newLoan.LLC_BI__Product_Package__c).Material_Exceptions_Approval_Required__c == true){
                packageMap.get(newLoan.LLC_BI__Product_Package__c).Material_Exceptions_Approval_Required__c = false;
                updatedPackageIds.add(newLoan.LLC_BI__Product_Package__c);
            }
        }
        if(updatedPackageIds != null && updatedPackageIds.size()>0){
            for(Id i : updatedPackageIds){
                packagesToUpdate.add(packageMap.get(i));
            }
        }
        return packagesToUpdate;
    }
    private Boolean loanHasPolicyExceptions(LLC_BI__Loan__c newLoan, LLC_BI__Product_Package__c pack){
        return pack != null
            && newLoan.Policy_Exceptions__c != null 
            && !newLoan.Policy_Exceptions__c.contains('N/A')
            && pack.Contains_Policy_Exceptions__c == false;
    }
    private Boolean packageNeedsPASSRecommendationUpdated(LLC_BI__Product_Package__c pack, LLC_BI__Loan__c oldLoan, LLC_BI__Loan__c newLoan, List<LLC_BI__Loan__c> loansRelatedToPackage){
        return pack != null
            && underwritingCompleteChanged(oldLoan, newLoan)
            && bbAutoDecisionCriteria(pack, newLoan)
            && allLoansInPackageReadyForPassUpdate(pack, newLoan, loansRelatedToPackage)
            && newLoan.PASS_Recommendation__c != pack.PASS_Recommendation__c;
    }
    private Boolean underwritingCompleteChanged(LLC_BI__Loan__c oldLoan, LLC_BI__Loan__c newLoan) {
        return oldLoan.Underwriting_Complete__c == false && newLoan.Underwriting_Complete__c == true;
    }
    private Boolean bbAutoDecisionCriteria(LLC_BI__Product_Package__c pack, LLC_BI__Loan__c loan) {
        List<String> policyExceptions = new List<String>();
        if(loan.Policy_Exceptions__c != null){
            policyExceptions = loan.Policy_Exceptions__c.split(';');
        }
        return policyExceptions != null
            	&& policyExceptions.contains('N/A')
            	&& (pack.LLC_BI__TCE__c <= 150000 && pack.Channel__c == 'Business Banking' 
                ||	pack.LLC_BI__TCE__c <= 150000 && pack.New_Money_Renewal__c == 'New Money' && loan.LLC_BI__Product__c == 'Credit Card');
    }
    private Boolean allLoansInPackageReadyForPassUpdate(LLC_BI__Product_Package__c pack, LLC_BI__Loan__c newLoan, List<LLC_BI__Loan__c> loansRelatedToPackage){
        if(loansRelatedToPackage != null && loansRelatedToPackage.size() > 0){
            if(loansRelatedToPackage.size() == 1){
                return true;
            }else if(loansRelatedToPackage.size() > 1){
                Integer count = 0;
                for(LLC_BI__Loan__c l : loansRelatedToPackage){
                    if(l.Underwriting_Complete__c == false){
                        break;
                    }
                    count += 1;
                    if(count == loansRelatedToPackage.size() && pack.PASS_Recommendation__c != newLoan.PASS_Recommendation__c){
                        return true;
                    }
                }
            }
        }
        return false;
    }
    private void setRMGApprovers(List<LLC_BI__Product_Package__c> packageList){
        for(LLC_BI__Product_Package__c pk : packageList){
            if(firstApproverShouldUpdate(pk)){
                pk.First_Approver__c = pk.Originating_Officer__c;
            }
            if(secondApproverShouldUpdate(pk)){
                pk.Second_Approver__c = '005a00000089F93';
            }
        }
    }
    private Boolean firstApproverShouldUpdate(LLC_BI__Product_Package__c pk){
        return (pk.Channel__c == 'Resolution Management Group (RMG)' || pk.Actual_Approval_Path__c == 'Non-RMG PLC')
            && pk.Originating_Officer__c != null 
            && (pk.First_Approver__c == null || pk.First_Approver__c != pk.Originating_Officer__c);
    }
    private Boolean secondApproverShouldUpdate(LLC_BI__Product_Package__c pk){
        String firstApprover = pk.First_Approver__c;
        String secondApprover = pk.Second_Approver__c;
        return (pk.Channel__c == 'Resolution Management Group (RMG)' || pk.Actual_Approval_Path__c == 'Non-RMG PLC')
            && firstApprover != null
            && !firstApprover.contains('005a00000089F93')
            && (secondApprover == null || !secondApprover.contains('005a00000089F93'));
    }
    private void setApproverType(List<LLC_BI__Product_Package__c> oldList, Map<Id, SObject> newMap){
        for(LLC_BI__Product_Package__c oldPack : oldList){
            LLC_BI__Product_Package__c newPack = (LLC_BI__Product_Package__c)newMap.get(oldPack.Id);
            if(relevantValuesChanged(oldPack, newPack)){
                updateApproverType(newPack);
            }
        }
    }
    private Boolean relevantValuesChanged(LLC_BI__Product_Package__c oldPack, LLC_BI__Product_Package__c newPack){
        return oldPack.Channel__c != newPack.Channel__c 
            || oldPack.LLC_BI__TCE__c != newPack.LLC_BI__TCE__c
            || oldPack.Underwriting_Score__c != newPack.Underwriting_Score__c
            || oldPack.Contains_Employee_Loans__c != newPack.Contains_Employee_Loans__c
            || oldPack.Override_Recommended_Approval_Path__c != newPack.Override_Recommended_Approval_Path__c;
    }
    private void updateApproverType(LLC_BI__Product_Package__c newPack){
        if(newPack.Contains_Employee_Loans__c == true){
            newPack.Approver_Type__c = 'Level A';
        }else if((newPack.Channel__c == 'Consumer Banking' || newPack.Channel__c == 'Private Banking') && newPack.LLC_BI__TCE__c <= 1000000){
            newPack.Approver_Type__c = 'Level B';
        }else if((newPack.Channel__c == 'Consumer Banking' || newPack.Channel__c == 'Private Banking') && newPack.LLC_BI__TCE__c > 1000000){
            newPack.Approver_Type__c = 'Level A';
        }else if(newPack.Channel__c == 'Business Banking' && newPack.BB_Approval_Path__c == 'Orange' && newPack.Override_Recommended_Approval_Path__c == false){
            newPack.Approver_Type__c = 'Level A';
        }else if(newPack.Channel__c == 'Business Banking' && (newPack.BB_Approval_Path__c != 'Orange' || newPack.Override_Recommended_Approval_Path__c == true)){
            newPack.Approver_Type__c = 'Level B';
        }else if(newPack.Channel__c == 'Resolution Management Group (RMG)'){
            newPack.Approver_Type__c = 'RMGApprover';
        }else if(newPack.Channel__c == 'Commercial Banking'){
            newPack.Approver_Type__c = 'Level B';
        }else newPack.Approver_Type__c = 'N/A';
    }
    
    private Boolean hasStatusChanged(LLC_BI__Product_Package__c oldPack, LLC_BI__Product_Package__c newPack){
        return oldPack.LLC_BI__Status__c != newPack.LLC_BI__Status__c;            
    }
    private Boolean packageReadyForAutoApproval(LLC_BI__Product_Package__c oldPack, LLC_BI__Product_Package__c newPack){
        return oldPack.PASS_Recommendation__c != newPack.PASS_Recommendation__c 
            && newPack.PASS_Recommendation__c == 'Approve'
            && newPack.LLC_BI__TCE__c <= 150000;
    }
    private List<Approval.ProcessSubmitRequest> getApprovalSubmitRequests(List<SObject> objects){
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        for(SObject obj : objects){
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('PASS Auto Approval');
            req.setObjectId(obj.Id);
            requests.add(req);
        }
        return requests;
    }
    private Boolean loanHasMaterialUnderwritingExceptions(LLC_BI__Loan__c loan){
        Integer numOfMaterialExceptions = 0;
        List<String> policyExceptions = new List<String>();
        if(loan != null && loan.Policy_Exceptions__c != null && loan.Channel__c == 'Commercial Banking'){
            policyExceptions = loan.Policy_Exceptions__c.split(';');
        }
        for(String s : policyExceptions){
            if(policyExceptionsIsMaterialException(s)){
                numOfMaterialExceptions += 1;
            }
        }
        if(numOfMaterialExceptions >= 2){
            return true;
        }
        return false;
    }
    private Boolean policyExceptionsIsMaterialException(String s){
        if(  s.contains('Advance Rate')  
          || s.contains('Loan to Value')
          || s.contains('Term')
          || s.contains('Amortization')
          || s.contains('Out of market collateral / borrower'))
        {
            return true;
        }
        return false;
    }
}