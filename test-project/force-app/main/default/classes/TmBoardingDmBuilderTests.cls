@IsTest
public class TmBoardingDmBuilderTests {

	private static final TmBoardingDmBuilder sut;
	private static final TmBoardingMock.ofIFieldMetadataBuilder m_mockOfFieldMetadataBuilder;
	private static final TmBoardingMock.ofIFieldMapManager m_mockFieldMapManager;
	private static final Mock.ofIErrorRepository m_errors;
	private static final Mock.ofIUtility m_utility;

	static{
		m_mockOfFieldMetadataBuilder = new TmBoardingMock.OfIFieldMetadataBuilder();
		m_mockFieldMapManager = new TmBoardingMock.ofIFieldMapManager();
		m_errors = new Mock.ofIErrorRepository();
		m_utility = new Mock.ofIUtility();
		sut = new TmBoardingDmBuilder(m_mockOfFieldMetadataBuilder, m_mockFieldMapManager, m_errors, m_utility);
	}

	private static testMethod void it_should_split_key_from_object() {
		String KEY_DELIM = '\\.'; 
		String key = 'Tm_Service_Request_Contact__c.Account_Title__c';
		List<String> relationshipIds = key.split(KEY_DELIM);

		System.assertEquals('Account_Title__c' ,relationshipIds[1]);
	}

	private static testMethod void it_should_call_the_build_a_dm_account() {
		Eb_Account__c acct = new Eb_Account__c(Application__c = 2);

		DmEbAccount result = sut.getEbAccount(acct);

		System.assertEquals(2, result.application);
	}

	private static testMethod void it_should_get_record_types_for_request_object() {
		String objectName = 'TM_Service_Request__c';
		String product1 = 'Lockbox';
		String product2 = 'Online Banking';
		RecordType record1 = new RecordType(Name=product1);
		RecordType record2 = new RecordType(NAme=product2);
		List<RecordType> records = new List<RecordType>{record1, record2};
		m_utility.setup('recordTypeObjects', new List<OBject>{objectName}).returns(records);

		List<DmRecordType> result = sut.getRequestRecordTypes();

		System.assertEquals(product1 ,result[0].Name);
		System.assertEquals(product2 ,result[1].Name);
	}

	private static testMethod void it_should_build_configurations() {
		TmBoarding.RequestConfigPm configPm = new TmBoarding.RequestConfigPm();
		TM_Service_Configuration_Field__c serviceOptionPm = new TM_Service_Configuration_Field__c();
		Map<Id, TM_Service_Configuration_Section_Group__c> sectionGroupOptionPms = new Map<Id, TM_Service_Configuration_Section_Group__c>(); 
		configPm.serviceOptionPms = new List<TM_Service_Configuration_Field__c>{serviceOptionPm};
		configPm.contactOptionPms = new List<TM_Service_Configuration_Field__c>{new TM_Service_Configuration_Field__c()};
		configPm.accountOptionPms = new List<TM_Service_Configuration_Field__c>{new TM_Service_Configuration_Field__c()};
		configPm.sectionGroupOptionPms = sectionGroupOptionPms;
		configPm.sectionOptionPms = new Map<Id, TM_Service_Configuration_Section__c>();
		configPm.schedulePms = new List<TmBoarding.RequestScheduleConfigPm>{new TmBoarding.RequestScheduleConfigPm()};  

		TmBoarding.ServiceMetadata result = sut.getConfigurationsByService(configPm);

		m_mockOfFieldMetadataBuilder.verify('getFieldMetadata', new List<Object>{serviceOptionPm, TmBoarding.Placement.Edit, sectionGroupOptionPms});

	} 
}