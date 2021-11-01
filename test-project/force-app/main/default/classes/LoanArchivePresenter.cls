public class LoanArchivePresenter implements LoanArchive.IPresenter {
   
    private final LoanArchive.IVmBuilder m_vmBuilder;
    private final LoanArchive.IDataProvider m_dataProvider;
    private final LoanArchive.IProcessor m_processor;
    private final LoanArchive.IValidator m_validator;

    public LoanArchivePresenter(LoanArchive.IVmBuilder vmBuilder, LoanArchive.IDataProvider dataProvider, LoanArchive.IProcessor processor, LoanArchive.IValidator validator){
        m_vmBuilder = vmBuilder;
        m_dataProvider = dataProvider;
        m_processor = processor;
        m_validator = validator;
    }

    public LoanArchive.FormVm buildFormVm(Id loanId){
        LLC_BI__loan__c loan= m_dataProvider.getLoanForVm(loanId);
        return buildFormVm(loan);       
    }
    
    public void save(LoanArchive.FormVm formVm){
        try{
            List<LoanArchive.SObjectMergeRequest> requests = buildMergeRequests(formVm);
            m_processor.process(formVm.loanId, requests);
        }catch(Exception ex){
            throw new LoanArchive.SaveException(ex.getMessage());
        }
    }

    public void saveCollateral(LoanArchive.FormVm formVm){
        try{
            List<LoanArchive.SObjectMergeRequest> requests = buildCollateralMergeRequests(formVm);
            m_processor.process(formVm.loanId, requests);
        }catch(Exception ex){
            throw new LoanArchive.SaveException(ex.getMessage());
        }
    }

    public List<String> getValidationErrors(LoanArchive.FormVm formVm){
        List<String> errors = new List<String>();
        
        errors.addAll(m_validator.validateCoreMerge(formVm.entityMergeList, 'Entity'));
        errors.addAll(m_validator.validateCoreMerge(formVm.collateralMergeList, 'Collateral'));
        errors.addAll(m_validator.validateCoreAge(formVm.entityMergeList, formVm.entityCoreMergeList, 'Entity'));
        errors.addAll(m_validator.validateCoreAge(formVm.collateralMergeList, formVm.collateralCoreMergeList, 'Collateral'));

        return errors;
    }
    
    private LoanArchive.FormVm buildFormVm(LLC_BI__Loan__c loan){
        LoanArchive.FormVm vm = new LoanArchive.FormVm();
        vm.loanId = loan.Id;    
        vm.entityMergeList = m_vmBuilder.buildEntityMergeList(loan.LLC_BI__Legal_Entities__r);
        vm.collateralMergeList = m_vmBuilder.buildCollateralMergeList(loan.LLC_BI__Loan_Collateral__r);
        vm.coreEntityOptions = m_vmBuilder.buildCoreEntityOptions(loan.LLC_BI__Legal_Entities__r);
        vm.coreCollateralOptions = m_vmBuilder.buildCoreCollateralOptions(loan.LLC_BI__Loan_Collateral__r);
        vm.entityCoreMergeList = m_vmBuilder.buildEntityCoreMergeList(vm.coreEntityOptions, loan.LLC_BI__Legal_Entities__r);
        vm.collateralCoreMergeList = m_vmBuilder.buildCollateralCoreMergeList(vm.coreCollateralOptions, loan.LLC_BI__Loan_Collateral__r);
        return vm;
    }   

    private List<LoanArchive.SObjectMergeRequest> buildMergeRequests(LoanArchive.FormVm formVm){
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        
        requests.add(buildLoanRequest(formVm.loanId));
        requests.addAll(buildMergeRequests(formVm.entityMergeList));
        requests.addAll(buildMergeRequests(formVm.collateralMergeList));

        return requests;
    }

    private List<LoanArchive.SObjectMergeRequest> buildCollateralMergeRequests(LoanArchive.FormVm formVm){
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        requests.addAll(buildMergeRequests(formVm.collateralMergeList));
        return requests;
    }

    private LoanArchive.SObjectMergeRequest buildLoanRequest(Id loanId){
        LoanArchive.SObjectMergeRequest request = new LoanArchive.SObjectMergeRequest();
        request.prospectObjectId = loanId;
        request.coreObjectId = loanId;
        return request;
    }

    private List<LoanArchive.SObjectMergeRequest> buildMergeRequests(List<LoanArchive.MergeObjectVm> merges){
        List<LoanArchive.SObjectMergeRequest> requests = new List<LoanArchive.SObjectMergeRequest>();
        if(merges != null) {
            for(LoanArchive.MergeObjectVm m : merges){
                if(m.selectedOptionId != '0'){
                    LoanArchive.SObjectMergeRequest request = new LoanArchive.SObjectMergeRequest();
                    request.prospectObjectId = m.objectId;
                    request.coreObjectId = m.selectedOptionId;
                    requests.add(request);
                }
            }
        }
        return requests;
    }   
}