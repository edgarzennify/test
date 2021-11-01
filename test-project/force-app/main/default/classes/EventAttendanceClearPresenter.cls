public class EventAttendanceClearPresenter implements EventAttendanceClear.IPresenter{
    private final EventAttendanceClear.IEventAttendanceClearHelper m_helper;
    private final EventAttendanceClear.IEventAttendanceClearDataProvider m_dataProvider;
    private final Id seshId;
    private EventAttendanceClear.clearerVm vm;
    
    
    public EventAttendanceClearPresenter(Id eventSessionId)
    {
        m_helper = new EventAttendanceClearHelper();
        m_dataProvider = new EventAttendanceClearDataProvider();
        seshId = eventSessionId;
    }
    public EventAttendanceClearPresenter(EventAttendanceClear.IEventAttendanceClearDataProvider dataProvider
                                         ,EventAttendanceClear.IEventAttendanceClearHelper helper
                                        ,Id sessionId)
    {
        m_helper = helper;
        m_dataProvider = dataProvider;
        seshId = sessionId;
    }
    public EventAttendanceClear.clearerVm clearAttendance(){
        EventAttendanceClear.clearerVm vm = new EventAttendanceClear.clearerVm();
        List<Event_Attendance__c> relatedAttendances = m_dataProvider.getAttendancesFromSessionId(seshId);
        List<Event_Attendance__c> clearedAttendances = new List<Event_Attendance__c>();
        
        if(relatedAttendances != null && relatedAttendances.size() > 0){
            clearedAttendances = m_helper.clearAttendance(relatedAttendances);
        }
        if(clearedAttendances != null && clearedAttendances.size() > 0){
            m_dataProvider.save(clearedAttendances);
        }
        
        vm.renderOkButton = false;
        vm.renderVerify = false;
        vm.renderSuccess = true;
        vm.renderCloseButton = true;
        return vm;
    }
    public EventAttendanceClear.clearerVm buildInitialVm(){
        EventAttendanceClear.clearerVm vm = new EventAttendanceClear.clearerVm();
        vm.renderVerify = true;
        vm.renderOkButton = true;
        vm.renderCloseButton = true;
        vm.renderSuccess = false;
        return vm;
    }

}