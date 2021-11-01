public class EventAttendanceUpdaterController {
    private EventAttendanceUpdater.IPresenter m_presenter;
    public EventAttendanceUpdater.updaterVm vm {get;set;}
    private IApexPages m_pageWrapper;
    private Id seshId;
    public Blob fileBody{get;set;}
    public Boolean renderSummary {get;set;}
    
    public EventAttendanceUpdaterController(ApexPages.StandardController standardController){
        m_presenter = EventAttendanceUpdater.constructPresenter(); 
        m_pageWrapper = new ApexPagesWrapper();
        renderSummary = false;
    }
    public EventAttendanceUpdaterController(EventAttendanceUpdater.IPresenter presenter, IApexPages pageWrapper){
        m_presenter = presenter;
        m_pageWrapper = pageWrapper;
        renderSummary = false;
    }
    
    public void importFile(){
        seshId = m_pageWrapper.getParameters().get('Id');
        vm = m_presenter.build(fileBody, seshId);
        renderSummary = true;
    }
    
}