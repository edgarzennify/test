public class LoanBoardingController {

    private IApexPages m_apexPages;
    private LoanBoarding.IPresenter m_presenter;

    public LoanBoarding.FormVm vm{get;set;}

    public LoanBoardingController(){
    	m_apexPages = ApexPagesWrapper.bootstrap();
    	m_presenter = LoanBoarding.bootstrapIPresenter();
    }

    public LoanBoardingController(LoanBoarding.IPresenter presenter, IApexPages apexPages){
        m_presenter = presenter;
        m_apexPages = apexPages;
    }

    public void initialize(){
        vm = m_presenter.build(m_apexPages.getParameter('id'));
    }
}