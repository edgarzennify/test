public class EventAttendanceClearController {
    private IApexPages m_pageWrapper;
    private EventAttendanceClear.IPresenter m_presenter;
    private Id seshId;
    public EventAttendanceClear.clearerVm vm {get;set;}
    
    public EventAttendanceClearController(ApexPages.StandardController standardController){
        m_pageWrapper = new ApexPagesWrapper();
        seshId = m_pageWrapper.getParameters().get('Id');
        m_presenter = new EventAttendanceClearPresenter(seshId);
    }
    public EventAttendanceClearController(Id sessionId, EventAttendanceClear.IPresenter presenter){
        seshId = sessionId;
        m_presenter = presenter;
    }
    
    public PageReference close(){
        return new PageReference('/' + seshId);
    }
    public void clearAttendance(){
        vm = m_presenter.clearAttendance();
    }
    public void init(){
        vm = m_presenter.buildInitialVm();
    }
}