public class TmOpportunityConverterMock {
    public class ofIVmBuilder extends ApexMoq implements TmOpportunityConverter.IVmBuilder {
        public TmOpportunityConverter.OpportunityDetails buildOpportunityVm(DmOpportunity opp, List<DmTmPacket> packets, List<DmRecordType> products, Map<String,Set<String>> opportunityProducts) {
            return (TmOpportunityConverter.OpportunityDetails)handleMethodInvocation('buildOpportunityVm', new List<Object>{opp, packets, products});
        }
    }
    public class ofIDmBuilder extends ApexMoq implements TmOpportunityConverter.IDmBuilder {
        public DmRecordType build(RecordType recordTypePm) {
            return (DmRecordType)handleMethodInvocation('build', new List<Object>{recordTypePm});
        }
        public DmOpportunity build(Opportunity opportunityPm) {
            return (DmOpportunity)handleMethodInvocation('build', new List<Object>{opportunityPm});
        }
        public DmTmPacket build(Tm_Service_Request_Packet__c requestPm) {
            return (DmTmPacket)handleMethodInvocation('build', new List<Object>{requestPm});
        }
    }
    public class ofIRepository extends ApexMoq implements TmOpportunityConverter.IRepository {
        public DmOpportunity getOpportunity(String opportunityId) {
            return (DmOpportunity)handleMethodInvocation('getOpportunity', new List<Object>{opportunityId});
        }
        public List<DmTmPacket> getExistingTmPackets(String entityId) {
            return (List<DmTmPacket>)handleMethodInvocation('getExistingTmPackets', new List<Object>{entityId});
        }
        public List<DmRecordType> getRequestRecordTypes(){
            return (List<DmRecordType>)handleMethodInvocation('getRequestRecordTypes');
        }
        public String save(TmOpportunityConverter.ConvertRequest request) { 
            return (String)handleMethodInvocation('save', new List<Object>{request});
        }
        public Map<String,Set<String>> getOpportunityProducts(List<DmRecordType> products) {
            return (Map<String,Set<String>>)handleMethodInvocation('getOpportunityProducts', new List<Object>{products});
        }
        public Opportunity updateOpportunityOnPacket(TM_Service_Request__c record, String product) {
            return (Opportunity)handleMethodInvocation('updateOpportunityOnPacket', new List<Object>{record, product});
        }
        public void updateOpportunityForWithdrawnProduct(TmBoarding.RequestPm requestPm) {
            handleMethodInvocation('updateOpportunityForWithdrawnProduct', new List<Object>{requestPm});
        }
    }
    public class ofIOpportunityBuilder extends ApexMoq implements TmOpportunityConverter.IOpportunityBuilder {
        public Map<String, Set<String>> getOpportunityProducts(List<String>  products, Map<String,TmBoarding.RequestConfigPm> cfgMap) {
            return (Map<String, Set<String>>)handleMethodInvocation('getOpportunityProducts', new List<Object>{products, cfgMap});
        }
        public Opportunity getUpdatedOpportunity(DmOpportunity opportunityDm, Map<String, Set<String>> productMap, List<string> selectedProducts) {
            return (Opportunity)handleMethodInvocation('getUpdatedOpportunity', new List<Object>{opportunityDm, productMap, selectedProducts});
        }
    }
    public class ofIMapper extends ApexMoq implements TmOpportunityConverter.IMapper {
        public string handle(){
            return (string)handleMethodInvocation('handle');
        }
        public TM_Service_Request__c updateTmObject(TM_Service_Request__c request, List<string> opportunityProducts, Set<string> subProductsByProduct){
            return (TM_Service_Request__c)handleMethodInvocation('updateTmObject', new List<Object>{request, opportunityProducts, subProductsByProduct});
        }
    }
    public class ofIOpportunityMapper extends ApexMoq implements TmOpportunityConverter.IOpportunityMapper {
        public string handle(){
            return (string)handleMethodInvocation('handle');
        }
        public TM_Service_Request__c updateTmObject(TM_Service_Request__c request, DmOpportunity opportunityDm){
            return (TM_Service_Request__c)handleMethodInvocation('updateTmObject', new List<Object>{request,opportunityDm});
        }
    }
    public class ofIConfiguration extends ApexMoq implements TmOpportunityConverter.IConfiguration {
        public String RECORDTYPE_ACH_DEBIT_FILTER() {
            return (String)handleMethodInvocation('RECORDTYPE_ACH_DEBIT_FILTER');
        }
        public String RECORDTYPE_LOCKBOX() {
            return (String)handleMethodInvocation('RECORDTYPE_LOCKBOX');
        }
        public String RECORDTYPE_ONLINE_BANKING(){
            return (String)handleMethodInvocation('RECORDTYPE_ONLINE_BANKING');
        }
        public String RECORDTYPE_CONTROLLED_DISBURSEMENT(){
            return (String)handleMethodInvocation('RECORDTYPE_CONTROLLED_DISBURSEMENT');
        }
        public String RECORDTYPE_EDI(){
            return (String)handleMethodInvocation('RECORDTYPE_EDI');
        }
        public String RECORDTYPE_EB_ROM(){
            return (String)handleMethodInvocation('RECORDTYPE_EB_ROM');
        }
        public String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES(){
            return (String)handleMethodInvocation('RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES');
        }
        public String RECORDTYPE_INVESTMENT_SWEEP(){
            return (String)handleMethodInvocation('RECORDTYPE_INVESTMENT_SWEEP');
        }
        public String RECORDTYPE_LOAN_SWEEP(){
            return (String)handleMethodInvocation('RECORDTYPE_LOAN_SWEEP');
        }
        public String RECORDTYPE_POSITIVE_PAY(){
            return (String)handleMethodInvocation('RECORDTYPE_POSITIVE_PAY');
        }
        public String RECORDTYPE_REMIT_PLUS(){
            return (String)handleMethodInvocation('RECORDTYPE_REMIT_PLUS');
        }
        public String RECORDTYPE_REMOTE_DEPOSIT(){
            return (String)handleMethodInvocation('RECORDTYPE_REMOTE_DEPOSIT');
        }
        public String RECORDTYPE_ZBA(){
            return (String)handleMethodInvocation('RECORDTYPE_ZBA');
        }

        public String SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE(){
            return (String)handleMethodInvocation('SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE');
        }
        public String SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE(){
            return (String)handleMethodInvocation('SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE');
        }
        public String SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE(){
            return (String)handleMethodInvocation('SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE');
        }
        public String SUBTYPE_ONLINE_BANKING_ACH_MODULE(){
            return (String)handleMethodInvocation('SUBTYPE_ONLINE_BANKING_ACH_MODULE');
        }
        public String SUBTYPE_ONLINE_BANKING_WIRE_MODULE(){
            return (String)handleMethodInvocation('SUBTYPE_ONLINE_BANKING_WIRE_MODULE');
        }
        public String SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS(){
            return (String)handleMethodInvocation('SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS');
        }
        public String SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET(){
            return (String)handleMethodInvocation('SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET');
        }
        public String SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS(){
            return (String)handleMethodInvocation('SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS');
        }
        public String SUBTYPE_INVESTMENT_SWEEP_REPO(){
            return (String)handleMethodInvocation('SUBTYPE_INVESTMENT_SWEEP_REPO');
        }
        public String OPP_RECORDTYPE_BUSINESS_BANKING(){
            return (String)handleMethodInvocation('OPP_RECORDTYPE_BUSINESS_BANKING');
        }
    }

}