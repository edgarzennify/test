public  class DocumentData {
    public string DocTypeName{get;set;}
    public string DocumentDate{get;set;}
    public string DocumentURL{get;set;}
    public string DrawerName{get;set;}
    public string Comment{get;set;}
    public Date sortDocumentDate{
        get{
            if(DocumentDate != null)
            return Date.valueof(DocumentDate);
            return Date.valueof('1900-1-1');
        }
        
    }
}