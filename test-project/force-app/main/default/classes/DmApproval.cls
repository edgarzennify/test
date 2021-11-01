public class DmApproval {
    public class Info{
        public String name{get;set;}
        public String sobjectApiName{get;set;}
        public String type{get;set;}
        public DateTime createdDate{get;set;}
        public List<DmInstance> instances{get;set;}
    }

    public class DmInstance{
        public string Id{get;set;}
        public String OverallStatus{get;set;}
        public DateTime CompletedDate{get;set;}
        public DmUser LastApprover{get;set;}
        public DateTime CreatedDate{get;set;}
        public List<DmStep> steps{get;set;}
        public List<DmWorkItem> workItems{get;set;}
        public List<DmHistory> history{get;set;}
    }
    
    public class DmStep{
        public string Id{get;set;}
        public String ProcessId{get;set;}
        public string Status{get;set;}
        public String Comments{get;set;}
    }
    
    public class DmWorkItem{
        public String Id{get;set;}
        public String ProcessId{get;set;}
        public Integer ElapsedDays{get;set;}
        public Integer ElapsedHours{get;set;}
        public Integer ElapsedMinutes{get;set;}
        public String ElapsedTime{get;set;}

    }
    
    public class DmHistory{
        public String Id{get;set;}
        public String SobjectRecordId{get;set;}
        public String ProcessId{get;set;}
        public String Comments{get;set;}
        public Boolean IsPending{get;set;}
        public Integer RemindersSent{get;set;}
        public String Step{get;set;}
        public String StepTitle{get;set;}
        public DmUser Approver{get;set;}
        public DmUser OriginalApprover{get;set;}
        public DateTime CreatedDate{get;set;}
    }
}