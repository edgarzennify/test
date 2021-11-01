public with sharing class ModReqOfficerController {
	
	private ModReqOfficerControllerDataProv.IModReqOfficerControllerDataProv m_dataProv;
	private IApexPages m_apexPages;
	private Configurations.IConfigurations m_config;

	public EB_Account__c ebAccount {get; set;}
	public String modificationRequestName {
		get {
			return (ebAccount.Name != null) ? ebAccount.Name.left(MAX_LENGTH_OF_NAME) : DEFAULT_MOD_REQUEST_NAME;
		}
	}
	public String currentUnit {
		get {
			return (ebAccount.EB_Unit__c != null) ? ebAccount.EB_Unit__c : null;
		}
	}
	public String currentUnitName { 
		get {
			return (ebAccount.EB_Unit__r.Name != null) ? ebAccount.EB_Unit__r.Name : 'None';
		}
	}
	public String currentAcctLevelOfficer {
		get{
			return ebAccount.EB_Team_Member__r.User__c;
		}
	}
	public String currentAcctLevelOfficerName {
		get{
			return (ebAccount.EB_Team_Member__r.Name != null) ? ebAccount.EB_Team_Member__r.Name : 'None';
		}
	}
	public Boolean defaultModifyUnit{
		get {
			return (m_apexPages.getParameter('modUnit') == 'true');
		}
	}
	public Boolean defaultModifyAcctOfficer{
		get {
			return (m_apexPages.getParameter('modAcctOff') == 'true');
		}
	}
	public Id firstApproverId { 
		get {
			return (ebAccount.EB_Unit__r.Relationship_Oversight__c != null) ? ebAccount.EB_Unit__r.Relationship_Oversight__c : (Id)m_config.getDefaultRelationshipOversightApprover();
		}
	}

	private Integer MAX_LENGTH_OF_NAME = 80;
	private String DEFAULT_MOD_REQUEST_NAME = 'Modification Request';

	public ModReqOfficerController() {
		ModReqOfficerControllerDataProv dataProv = new ModReqOfficerControllerDataProv();
		ApexPagesWrapper apexPages = new ApexPagesWrapper();
		Configurations.IConfigurations config = Configurations.bootstrap();
		initialize(dataProv, apexPages, config);
	}

	public ModReqOfficerController(ModReqOfficerControllerDataProv.IModReqOfficerControllerDataProv dataProv, IApexPages apexPages, Configurations.IConfigurations config) {
		initialize(dataProv, apexPages, config);
	}

	public void initialize(ModReqOfficerControllerDataProv.IModReqOfficerControllerDataProv dataProv, IApexPages apexPages, Configurations.IConfigurations config) {
		m_dataProv = dataProv;
		m_apexPages = apexPages;
		m_config = config;
		String ebAccountId = m_apexPages.getParameter('AccountId');
		ebAccount = m_dataProv.getEBAccount(ebAccountId);
	}

}