public class TmConfigurationStageRepository implements TmConfiguration.IStageRepository {

	private final TmBoarding.IDataProvider m_dataProvider;

	public TmConfigurationStageRepository(TmBoarding.IDataProvider dataProvider) {
		m_dataProvider = dataProvider;
	}

	public DmTmRequestStage getStageDetail(String requestId) {
		Tm_Service_Request_Stage__c parent = m_dataProvider.getStageForRequest(requestid);
		if(parent == null){return new DmTmRequestStage();}
		List<Tm_Service_Request_Stage_Relationships__c> related = m_dataProvider.getValidStages(parent);
		return buildStage(parent, related);
	}

	public DmTmRequestStage getDefaultStage() {
		Tm_Service_Request_Stage__c parent = m_dataProvider.getDefaultStage();
		return buildStage(parent, new List<Tm_Service_Request_Stage_Relationships__c>());
	}

    public List<DmTmRequestStage> getAllStages() {
        List<DmTmRequestStage> stageDms = new List<DmTmRequestStage>();
        List<Tm_Service_Request_Stage__c> stagePms = m_dataProvider.getAllStages();
        if(stagePms != null) {
            for(Tm_Service_Request_Stage__c pm : stagePms){
                stageDms.add(build(pm));
            }
        }
        return stageDms;
    }

    private DmTmRequestStage buildStage(Tm_Service_Request_Stage__c parent, List<Tm_Service_Request_Stage_Relationships__c> related) {
        DmTmRequestStage parentdm = build(parent);
        parentdm.relatedStages = new List<DmTmRequestStage>();
        if(related != null || related.size() == 0){
            for(Tm_Service_Request_Stage_Relationships__c s : related) {
                DmTmRequestStage rel = buildRelatedStage(s);
                if(rel!=null){parentdm.relatedStages.add(rel);}
            } 
        }              
        return parentdm;
    }

    private DmTmRequestStage buildRelatedStage(Tm_Service_Request_Stage_Relationships__c pm) {
        if(pm == null || pm.Child_Stage__r == null){return null;}
        DmTmRequestStage dm = build(pm.Child_Stage__r);
        dm.relatedStages = new List<DmTmRequestStage>();
        return dm;
    }

    private DmTmRequestStage build(Tm_Service_Request_Stage__c pm) {
        DmTmRequestStage dm = new DmTmRequestStage();
        dm.id = pm.id;
        dm.name = pm.name;
        dm.type = pm.type__c;
        dm.permission = pm.permission__c;        
        setAutoForwardStage(dm, pm);
        dm.relatedStages = new List<DmTmRequestStage>();
        if(pm.Tm_Service_Request_Stage_Relationships__r != null){
            for(Tm_Service_Request_Stage_Relationships__c rel : pm.Tm_Service_Request_Stage_Relationships__r){
                DmTmRequestStage relStage = buildRelatedStage(rel);
                dm.relatedStages.add(relStage);
            }
        }
        return dm;
    }
    
    private void setAutoForwardStage(DmTmRequestStage dm, Tm_Service_Request_Stage__c pm){
        if(pm.Auto_Forward_Stage__r != null){
            dm.autoForwardStage = new DmTmRequestStage();
        	dm.autoForwardStage.id = pm.Auto_Forward_Stage__c;
        	dm.autoForwardStage.Name = String.isNotBlank(pm.Auto_Forward_Stage__c) ? pm.Auto_Forward_Stage__r.Name: '';
            if(pm.Auto_Forward_Stage__r.Auto_Forward_Stage__r != null){
            	dm.autoForwardStage.autoForwardStage = new DmTmRequestStage();
            	dm.autoForwardStage.autoForwardStage.Id = pm.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Id;
            	dm.autoForwardStage.autoForwardStage.Name = pm.Auto_Forward_Stage__r.Auto_Forward_Stage__r.Name;    
            }            
        }
    }
}