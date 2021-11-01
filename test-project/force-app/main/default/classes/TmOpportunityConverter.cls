global class TmOpportunityConverter {

    public interface IPresenter {
        OpportunityDetails getOpportunityDetails(String opportunityId);
        String save(ConvertRequest request);
    }
    public interface IVmBuilder {
        OpportunityDetails buildOpportunityVm(DmOpportunity opp, List<DmTmPacket> packets, List<DmRecordType> products, Map<String, Set<String>> productMapping);
    }
    public interface IDmBuilder {
        DmRecordType build(RecordType pm);
        DmOpportunity build(Opportunity pm);
        DmTmPacket build(Tm_Service_Request_Packet__c pm);
    }
    public interface IRepository {
        DmOpportunity getOpportunity(String opportunityId);
        List<DmTmPacket> getExistingTmPackets(String entityId);
        List<DmRecordType> getRequestRecordTypes();
        Map<String, Set<String>> getOpportunityProducts(List<DmRecordType>  products);
        Opportunity updateOpportunityOnPacket(TM_Service_Request__c record, String product);
        void updateOpportunityForWithdrawnProduct(TmBoarding.RequestPm requestPm);
        String save(ConvertRequest request);
    }
    public interface IOpportunityBuilder {
        Map<String, Set<String>> getOpportunityProducts(List<String>  products, Map<String,TmBoarding.RequestConfigPm> cfgMap);
        Opportunity getUpdatedOpportunity(DmOpportunity opportunityDm, Map<String, Set<String>> productMap, List<string> selectedProducts);
    }

    public interface IMapper {
        string handle();
        TM_Service_Request__c updateTmObject(TM_Service_Request__c request, List<string> opportunityProducts, Set<string> subProductsByProduct);
    }

    public interface IOpportunityMapper{
        string handle();
        TM_Service_Request__c updateTmObject(TM_Service_Request__c request, DmOpportunity oppDm);
    }

    global class OpportunityDetails {
        public String OpportunityName {get;set;}
        public String OpportunityId {get;set;}
        public Double PotentialIncome {get;set;}
        public String ServerUrl{get;set;}
        public LayoutComponent EntityDetail {get;set;}
        public LayoutComponent EntityRecordType {get;set;}
        public List<LayoutComponent> ExistingPacketDetails{get;set;}
        public List<LayoutComponent> BankProducts{get;set;}
        public List<LayoutComponent> SelectedBankProducts {get;set;}
        public List<String> BundleTypes{get;set;}
        public List<string> ClientTypes{get;set;}
    }

    public class LayoutComponent implements Comparable {
        public String Identifier{get;set;}
        public String Name{get;set;}
        public List<String> SubProducts{get;set;}

        public Integer compareTo(Object compareTo) {
            LayoutComponent other = (LayoutComponent) compareTo;
            if (Name <other.Name) return - 1;
            if (Name == other.Name) return 0;
            return 1;
        }
    }

    global class ConvertRequest {
        public List<String> Products {get;set;}
        public String PacketId {get;set;}
        public String PacketName {get;set;}
        public String EntityId {get;set;}
        public String OpportunityId {get;set;}
        public String BundleType {get;set;}
        public String ClientType {get;set;}
    }

    public interface IConfiguration {
        String RECORDTYPE_ACH_DEBIT_FILTER();
        String RECORDTYPE_LOCKBOX();
        String RECORDTYPE_ONLINE_BANKING();
        String RECORDTYPE_CONTROLLED_DISBURSEMENT();
        String RECORDTYPE_EDI();
        String RECORDTYPE_EB_ROM();
        String RECORDTYPE_ENTERPRISE_AUTOMATED_PAYABLES();
        String RECORDTYPE_INVESTMENT_SWEEP();
        String RECORDTYPE_LOAN_SWEEP();
        String RECORDTYPE_POSITIVE_PAY();
        String RECORDTYPE_REMIT_PLUS();
        String RECORDTYPE_REMOTE_DEPOSIT();
        String RECORDTYPE_ZBA();

        String SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE();
        String SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE();
        String SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE();
        String SUBTYPE_ONLINE_BANKING_ACH_MODULE();
        String SUBTYPE_ONLINE_BANKING_WIRE_MODULE();
        String SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS();
        String SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET();
        String SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS();
        String SUBTYPE_INVESTMENT_SWEEP_REPO();

        String OPP_RECORDTYPE_BUSINESS_BANKING();
    } 
}