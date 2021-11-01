public class TmBoardingDmBuilder implements TmBoarding.IDmBuilder {

    private string CONTACT_OBJ = 'Contact';
    private string ACCOUNT_OBJ = 'Eb_Account__c';
	private string SERVICE_REQUEST_OBJ = 'TM_Service_Request__c';
	private string SERVICE_REQUEST_CONTACT_OBJ = 'TM_Service_Request_Contact__c';
	private string SERVICE_REQUEST_ACCOUNT_OBJ = 'TM_Service_Request_Account__c';
	private string SERVICE_REQUEST_CONTACT_ACCOUNT_OBJ = 'TM_Service_Request_Contact_Account__c';
    private string PROSPECTIVE_MARKED = '\\*';

	private final TmBoarding.IFieldMetadataBuilder m_fieldMetadataBuilder;
	private final TmBoarding.IFieldMapManager m_fieldMapManager;
    private final ErrorRepository.IErrorRepository m_errors;
    private final Utility.IUtility m_util;

	public TmBoardingDmBuilder(TmBoarding.IFieldMetadataBuilder fieldMetadataBuilder, TmBoarding.IFieldMapManager fieldMapManager, ErrorRepository.IErrorRepository errors, Utility.IUtility util) {
		m_fieldMetadataBuilder = fieldMetadataBuilder;
		m_fieldMapManager = fieldMapManager;
        m_errors = errors;
        m_util = util;
	}

    public TmBoarding.ServiceMetadata getConfigurationsByService(TmBoarding.RequestConfigPm configPm) {
        
    	TmBoarding.ServiceMetadata metadata = new TmBoarding.ServiceMetadata();
    	List<string> errors = new List<string>();

    	metadata.Name = configPm.productPm.Product_Name__c;
    	metadata.Fields = buildServiceFields(filterInvalid(configPm.serviceOptionPms, errors), configPm.sectionGroupOptionPms);
		metadata.ContactFields = buildContactFields(filterInvalid(configPm.contactOptionPms, errors), filterInvalid(configPm.contactAccountOptionPms, errors),  configPm.sectionGroupOptionPms);
    	metadata.AccountFields = buildAccountFields(filterInvalid(configPm.accountOptionPms, errors), filterInvalid(configPm.contactAccountOptionPms, errors),  configPm.sectionGroupOptionPms);
    	metadata.ServiceOptions = buildServiceOptions(configPm.schedulePms, errors, configPm.sectionGroupOptionPms);
    	metadata.Errors = errors;
    	return metadata;
    }

    public DmEbAccount getEbAccount(Eb_Account__c acct) {
        if(acct == null) return null;
        DmEbAccount dm = new DmEbAccount();
        dm.id = acct.Id;
        dm.application = Integer.valueOf(acct.Application__c);
        dm.accountNumber = acct.Account_Number__c;

        return dm;
    }

    public List<DmRecordType> getRequestRecordTypes() {
        List<DmRecordType> dmRecTypes = new List<DmRecordType>();
        for(RecordType r : m_util.recordTypeObjects('TM_Service_Request__c')){
            DmRecordType dm = new DmRecordType();
            dm.id = r.Id;
            dm.name = r.Name;
            dmRecTypes.add(dm);
        }
        return dmRecTypes;
    }

    private List<TmBoarding.Field> buildServiceFields(List<TM_Service_Configuration_Field__c> serviceOptions, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
 
    	List<TmBoarding.Field> fields = new List<TmBoarding.Field>();
    	if(serviceOptions == null || serviceOptions.size() == 0) return fields;
    	for(TM_Service_Configuration_Field__c option : serviceOptions) {
    		TmBoarding.Field fld = m_fieldMetadataBuilder.getFieldMetadata(option, TmBoarding.Placement.Edit, sectionGroups);
    		if(fld != null) fields.add(fld);
    	}
    	return fields;
    }

    private TmBoarding.FieldCategory buildContactFields(List<TM_Service_Configuration_Field__c> contactOptionPms, List<TM_Service_Configuration_Field__c> contactAccountPms, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
    	return m_fieldMetadataBuilder.getCategoryMetadata(contactOptionPms, contactAccountPms, sectionGroups);
    }

    private  TmBoarding.FieldCategory buildAccountFields(List<TM_Service_Configuration_Field__c> accountOptionPms, List<TM_Service_Configuration_Field__c> accountcontactPms, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {
    	return m_fieldMetadataBuilder.getCategoryMetadata(accountOptionPms, accountcontactPms, sectionGroups);
    }

    private List<TmBoarding.ServiceOption> buildServiceOptions(List<TmBoarding.RequestScheduleConfigPm> schedulePms, List<string> errors, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {

    	List<TmBoarding.ServiceOption> serviceOptions = new List<TmBoarding.ServiceOption>();

    	for(TmBoarding.RequestScheduleConfigPm schedule : schedulePms) {
    		serviceOptions.add(buildServiceOption(schedule, errors, sectionGroups));
    	}

    	return serviceOptions;
    }

    private TmBoarding.ServiceOption buildServiceOption(TmBoarding.RequestScheduleConfigPm schedule, List<string> errors, Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroups) {

    	TmBoarding.ServiceOption serviceOption = new TmBoarding.ServiceOption();
    	serviceOption.label = schedule.scheduleLabel;
    	serviceOption.name = schedule.scheduleName;
        serviceOption.section = schedule.scheduleSection;
		serviceOption.type = schedule.scheduleType;
    	serviceOption.fields = buildServiceFields(filterInvalid(schedule.serviceSchedulePms, errors), sectionGroups);
    	serviceOption.accountFields = m_fieldMetadataBuilder.getCategoryMetadata(filterInvalid(schedule.accountServiceSchedulePms, errors), sectionGroups);
    	serviceOption.contactFields = new TmBoarding.FieldCategory();

    	return serviceOption;
    }

    private List<TM_Service_Configuration_Field__c> filterInvalid(List<TM_Service_Configuration_Field__c> fields, List<string> errors) {
    	return fields;
    }
}