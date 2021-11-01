public class DmDocument{
    public string Id {get;set;}
    public string Name{get;set;}
    public string Description {get;set;}
    public string Type{get;set;}
    public boolean IsInternalUseOnly{get;set;}
    public string Keywords{get;set;}
    public string AuthorId{get;set;}
    public string ContentType{get;set;}
    public Blob Body{get;set;}
    public DateTime LastModifiedDate{get;set;}
}