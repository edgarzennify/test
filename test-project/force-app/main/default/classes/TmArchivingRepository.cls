public class TmArchivingRepository implements TmArchiving.IRepository {
    private final TmArchiving.IDataProvider m_dataProvider;

    public TmArchivingRepository(TmArchiving.IDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }

    public DmIndustryCode getIndustryIdFromCode(String industryCode){      
        return buildDm( m_dataProvider.getIndustryIdFromCode(industryCode));
    }

    public List<DmTmArchive> getArchives(String tmRequestId){
        List<DmTmArchive> archives = new List<DmTmArchive>();
        List<Tm_Service_Request_Archive__c> pms = m_dataProvider.getArchives(tmRequestId);
        if(pms == null){return archives;}

        for(Tm_Service_Request_Archive__c pm : pms){
            archives.add(buildDm(pm));
        }
        return archives;
    }

    private DmIndustryCode buildDm(EB_Industry_Code__c pm){      
        DmIndustryCode dm = new DmIndustryCode();
        if(pm == null){return dm;}
        dm.id = pm.Id;
        dm.name = pm.Name;
        dm.code = pm.Industry_Code__c;
        dm.industryGroup = pm.Industry_Group__c;
        return dm;
    }

    private DmTmArchive buildDm(Tm_Service_Request_Archive__c pm){
        DmTmArchive dm = new DmTmArchive();
        if(pm == null){ return dm;}
        dm.TreasuryService = new DmTreasuryService();
        if(pm.Treasury_Management_Service__r != null){
            dm.TreasuryService.id = pm.Treasury_Management_Service__r.Id;
            dm.TreasuryService.name = pm.Treasury_Management_Service__r.name;
        }

        dm.TreasuryService.recordType = new DmRecordType();
        if(pm.Treasury_Management_Service__r != null && pm.Treasury_Management_Service__r.RecordType != null){
            dm.TreasuryService.recordType.id = pm.Treasury_Management_Service__r.RecordType.Id;
            dm.TreasuryService.recordType.name = pm.Treasury_Management_Service__r.RecordType.name;
            dm.TreasuryService.product = pm.Treasury_Management_Service__r.Product_Pl__c == null?'':pm.Treasury_Management_Service__r.Product_Pl__c;
        }
        dm.TmRequest = new DmTmRequest();
        if(pm.Tm_Service_Request__r != null){
            dm.TmRequest.id = pm.Tm_Service_Request__r.id;
            dm.TmRequest.name = pm.Tm_Service_Request__r.name;
        }
        dm.CreatedBy = new DmUser();
        dm.CreatedBy.id = pm.CreatedById;
        if(pm.CreatedBy != null){
            dm.CreatedBy.name = pm.CreatedBy.Name;
        }

        dm.createdDate = pm.createdDate;

        return dm;
    }
}