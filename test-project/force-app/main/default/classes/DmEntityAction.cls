public class DmEntityAction {
    public string Id{get;set;} 
    public DmRecordType RecordType{get;set;}
    public DmEbAccount AccountNumber{get;set;}
    public DmUser AccountOfficer{get;set;}
    public string AttentionToAddress{get;set;}
    public string ChargeStatus{get;set;}
    public Date ActionDate{get;set;}
    public DmEntity Entity{get;set;}
    public string EsignatureStatus{get;set;}
    public string LeadAccountNumber{get;set;}
    public string OnlineBankingIDs{get;set;}
    public string OtherAnalysisRequest{get;set;}
    public string PaperStatementAddressOrUsers{get;set;}
    public string StatementType{get;set;}
    public string SubsidiaryAccounts{get;set;}
    public DmUnit Unit{get;set;}
    public Date WaiveExpirationDate{get;set;}
}