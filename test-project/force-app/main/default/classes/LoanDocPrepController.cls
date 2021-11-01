public class LoanDocPrepController {
    
    private IApexPages m_apexPages;
    private LoanDocPrep.IPresenter m_presenter;

    public LoanDocPrep.FormVm vm {get;set;}
    public LoanDocPrep.GenerateResponseVm generateResponseVm {get;set;}

    public LoanDocPrepController(){
    	m_apexPages = LoanDocPrepBootstrapper.getInstanceOfIApexPages();
    	m_presenter = LoanDocPrepBootstrapper.getInstanceOfIPresenter();
    }

    public LoanDocPrepController(LoanDocPrep.IPresenter presenter, IApexPages apexPages){
        m_presenter = presenter;
        m_apexPages = apexPages;
    }

    public void initialize(){
        vm = m_presenter.trialExport(m_apexPages.getParameter('id'));
    }

    public void generate(){
        generateResponseVm = m_presenter.generateExportFile(m_apexPages.getParameter('id'));
        ApexPages.Severity s = generateResponseVm.status == 'Success' ? ApexPages.Severity.INFO : ApexPages.Severity.ERROR;
        m_apexPages.addMessage(s, generateResponseVm.message);     
    }

    public PageReference cancel(){
        String url = '/' + m_apexPages.getParameter('id');
        return new PageReference(url);
    }
}