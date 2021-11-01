public class LoanArchiveController {

    private final IStandardController m_standardController;
    private final IApexPages m_apexPages;
    private final LoanArchive.IPresenter m_presenter;
    private final IUserInfoService m_userInfo;

    private LoanArchive.FormVm m_vm;

    public LoanArchiveController(ApexPages.StandardController controller) {
        m_standardController = new StandardControllerWrapper(controller);
        m_apexPages = new ApexPagesWrapper();
        m_presenter = LoanArchiveBootstrapper.getInstanceOfIPresenter();
        m_userInfo = UserInfoService.bootstrap();
    }

    public LoanArchiveController(IStandardController standardController, IApexPages apexPages, LoanArchive.IPresenter presenter, IUserInfoService userInfo){
        m_standardController = standardController;
        m_apexPages = apexPages;
        m_presenter = presenter;
        m_userInfo = userInfo;
    }

    public List<LoanArchive.MergeObjectVm> entityMergeList { get { return m_vm.entityMergeList; } }
    public List<LoanArchive.MergeObjectVm> collateralMergeList { get { return m_vm.collateralMergeList; } }  
    public List<SelectOption> coreEntityOptions { get { return m_vm.coreEntityOptions; } }
    public List<SelectOption> coreCollateralOptions { get { return m_vm.coreCollateralOptions; } }
    public boolean isAdmin{get{return m_userInfo.isSystemAdministrator();} }
    
    public void initialize(){
        m_vm = m_presenter.buildFormVm(m_standardController.getId()); 
    }

 
    
    public PageReference saveClicked(){
        try {
            List<String> errors = m_presenter.getValidationErrors(m_vm);
            if(errors.size() > 0){
                displayErrors(errors);
            }else{
                m_presenter.save(m_vm);
                return getLoanPageReference();
            }            
        }catch(Exception ex){
            m_apexPages.addMessage(ApexPages.Severity.ERROR, ex.getMessage());
        }
        return null;       
    }

    public PageReference saveCollateralClicked(){
        try {
            m_presenter.saveCollateral(m_vm);
            return getArchivePageReference();     
        }catch(Exception ex){
            m_apexPages.addMessage(ApexPages.Severity.ERROR, ex.getMessage());
        }
        return null;       
    }
    
    public PageReference cancelClicked(){
        return getLoanPageReference();
    }

    private void displayErrors(List<String> errors){
        for(String e : errors){
            m_apexPages.addMessage(ApexPages.Severity.ERROR, e);
        }
    }

    private PageReference getLoanPageReference(){
        return new PageReference('/' + m_standardController.getId());
    }

    private PageReference getArchivePageReference() {
        return new PageReference('/apex/LoanArchive?id=' + m_standardController.getId());
    }
}