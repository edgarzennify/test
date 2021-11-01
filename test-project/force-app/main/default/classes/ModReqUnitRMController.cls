public with sharing class ModReqUnitRMController {

	private ModReqUnitRMControllerDataProv.IModReqUnitRMControllerDataProv m_dataProv;
	private IApexPages m_apexPages;
	private Configurations.IConfigurations m_config;

	public Account entity {get; set;}
	public String modificationRequestName {
		get {
			return (entity.Name != null) ? entity.Name.left(MAX_LENGTH_OF_NAME) : DEFAULT_MOD_REQUEST_NAME;
		}
	}
	public String currentBranch {
		get {
			return (entity.EB_UnitID__c != null) ? entity.EB_UnitID__c : null;
		}
	}
	public String currentBranchName { 
		get {
			return (entity.EB_UnitID__r.Name != null) ? entity.EB_UnitID__r.Name : 'None';
		}
	}
	public String currentRelationshipManager {
		get{
			return (entity.Owner.Name != null) ? entity.Owner.Name : 'None';
		}
	}
	public Boolean defaultModifyBranch{
		get {
			return (m_apexPages.getParameter('modBranch') == 'true');
		}
	}
	public Boolean defaultModifyRM{
		get {
			return (m_apexPages.getParameter('modRM') == 'true');
		}
	}
	public Id firstApproverId { 
		get {
			return (entity.EB_UnitID__r.Relationship_Oversight__c != null) ? entity.EB_UnitID__r.Relationship_Oversight__c : (Id)m_config.getDefaultRelationshipOversightApprover();
		}
	}
	
	private Integer MAX_LENGTH_OF_NAME = 80;
	private String DEFAULT_MOD_REQUEST_NAME = 'Modification Request';


	public ModReqUnitRMController() {
		ModReqUnitRMControllerDataProv dataProv = new ModReqUnitRMControllerDataProv();
		ApexPagesWrapper apexPages = new ApexPagesWrapper();
		Configurations.IConfigurations config = Configurations.bootstrap();
		initialize(dataProv, apexPages, config);
	}

	public ModReqUnitRMController(ModReqUnitRMControllerDataProv.IModReqUnitRMControllerDataProv dataProv, IApexPages apexPages, Configurations.IConfigurations config) {
		initialize(dataProv, apexPages, config);
	}

	public void initialize(ModReqUnitRMControllerDataProv.IModReqUnitRMControllerDataProv dataProv, IApexPages apexPages, Configurations.IConfigurations config) {
		m_dataProv = dataProv;
		m_apexPages = apexPages;
		m_config = config;
		String entityId = m_apexPages.getParameter('EntityId');
		entity = m_dataProv.getEntity(entityId);
	}

}