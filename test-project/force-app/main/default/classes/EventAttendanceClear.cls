public class EventAttendanceClear {
    public interface IPresenter{
        clearerVm clearAttendance();
        EventAttendanceClear.clearerVm buildInitialVm();
    }
    public interface IEventAttendanceClearHelper{
        List<Event_Attendance__c> clearAttendance(List<Event_Attendance__c> attendancesToClear); 
    }
    public interface IEventAttendanceClearDataProvider{
        List<Event_Attendance__c> getAttendancesFromSessionId(Id seshId);
        void save(List<SObject> objs);
    }
    
    public class clearerVm{
        public Boolean renderVerify {get;set;}
        public Boolean renderSuccess {get;set;}
        public Boolean renderCloseButton {get;set;}
        public Boolean renderOkButton {get;set;}
    }
}