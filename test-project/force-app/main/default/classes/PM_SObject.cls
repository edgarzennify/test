public virtual class PM_SObject {
    public String Id {get;set;}
    public String Name {get;set;}
    public Datetime CreatedDate {get;set;}
    public PM_User CreatedBy {get;set;}
    public PM_User LastModifiedBy {get;set;}
    public PM_RecordType RecordType {get;set;}
    public SObject OriginalSObject {get;set;}    
}