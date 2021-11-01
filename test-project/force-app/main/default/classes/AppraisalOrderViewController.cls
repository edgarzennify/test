public class AppraisalOrderViewController {
    private AppraisalOrderViewDataProvider.IAppraisalOrderViewDataProvider m_appraisalOrderViewDataProvider;
    private EB_Appraisal_Order__c m_appraisalOrder;
    private IApexPages m_apexPages;
    private IUserInfoService m_userInfoSvc;
    private string collateralOwner{get;set;}
   
   
    public EB_Appraisal_order__c appraisalOrder{
        get{
            return m_appraisalOrder;
        }
        set{
            m_appraisalOrder = value;
        }
    }

    public AppraisalOrderViewController(){
        AppraisalOrderViewDataProvider dataProv = new AppraisalOrderViewDataProvider();
        ApexPagesWrapper apexPages = new ApexPagesWrapper();
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        initialize(dataProv, apexPages,userInfoService);
        
    }
    
    public AppraisalOrderViewController(AppraisalOrderViewDataProvider.IAppraisalOrderViewDataProvider dataProv, IApexPages apexPages, IUserInfoService userInfoService){
        initialize(dataProv, apexPages,userInfoService);
    }
    private void initialize(AppraisalOrderViewDataProvider.IAppraisalOrderViewDataProvider dataProv, IApexPages apexPages, IUserInfoService userInfoService){
        m_appraisalOrderViewDataProvider = dataProv;
        m_apexPages = apexPages;
        Id appOrdId = m_apexPages.getParameter('id');
        m_userInfoSvc = userInfoService;
        m_appraisalOrder = m_appraisalOrderViewDataProvider.getAppraisalOrderForId(appOrdId);
        collateralOwner=m_appraisalOrderViewDataProvider.collateralOwner(m_appraisalOrder);    
    }

    public PageReference save(){
        if(canEdit){
            m_appraisalOrderViewDataProvider.save(m_appraisalOrder);
            return getDestinationLocation();    
        }
        return getDestinationLocation();   
    }
    public PageReference cancel(){
        return getDestinationLocation();   
    }
    public PageReference getDestinationLocation(){
        PageReference newPage = new PageReference('/'+ appraisalOrder.ID);
        newPage.setRedirect(true);
        return newPage;    
    }

    private Boolean m_canEdit;

    public Boolean canEdit{
        get{
            if (m_canEdit == null){
                m_canEdit = m_userInfoSvc.isSystemAdministrator(m_userInfoSvc.getCurrentUserId());
                if(hasMassModifyPermission()){
                    m_canEdit = true;
                }
            }
            return m_canEdit;
        }
        set{
            m_canEdit = value;
        }
    }

 private Boolean hasMassModifyPermission(){
        return m_userInfoSvc.hasPermissionSet(m_userInfoSvc.getCurrentUserId(), 'Function - Appraisal Request Admin');
    }

 public String Collateral_Owner{
        get{
            return collateralOwner;
        }
    }   
}