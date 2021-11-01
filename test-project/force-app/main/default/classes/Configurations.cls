public class Configurations implements IConfigurations{

	public interface IConfigurations { 
        String get(String key);
        Object get(Schema.sObjectType soType, String key);
		Integer getRelationshipReviewRequiredGracePeriod();
		String getDefaultRelationshipOversightApprover();
		Boolean isSandbox();
		Integer creditRelationshipReportId();
		Integer creditRelationshipOreoReportId();
		String baseReportUrl();
		String certificateName();		
		String restServiceBaseUrl();        
        String creditRelationshipSaveReportBaseUrl();
        String creditRelationshipOreoSaveReportBaseUrl();
        String barcodeGeneratorUploadDrawerName();
	}

    private final KeyValueDataProvider.IKeyValueDataProvider m_dataProvider;

    public Configurations(KeyValueDataProvider.IKeyValueDataProvider dataProvider) {
        m_dataProvider = dataProvider;
    }

    public String get(String key){
        return (String)get(AppSetting__mdt.sObjectType, key);
    }

    public Object get(Schema.sObjectType soType, String key) {
        return m_dataProvider.get(soType, key);
    }

    public static IConfigurations bootstrap() {
        CachedMap.ICachedMap cache = CachedMap.getInstance();
        KeyValueDataProvider.IKeyValueDataProvider dataProvider = new KeyValueDataProvider(cache);
        return new Configurations(dataProvider);
    }
    
    public class ConfigurationKeyNotFoundException extends Exception {}

    //LEGACY METHODS
	public Integer getRelationshipReviewRequiredGracePeriod() {
		return Integer.valueOf(get('RelationshipReviewReqdGracePeriod'));
	}

	public String getDefaultRelationshipOversightApprover() {
		return get('DefaultRelationshipOversightApprover');
	}

	public Boolean isSandbox() {
        return Boolean.valueOf(get('IsSandbox'));
    }

    public Integer creditRelationshipReportId() {
        return Integer.valueOf(get('CreditRelationshipReportId'));
    }

    public Integer creditRelationshipOreoReportId() {
        return Integer.valueOf(get('CreditRelationshipOREOReportId'));
    }

    public String baseReportUrl() {
        return get('BaseReportUrl');
    }

    public String certificateName() {
    	return get('clientCertificateName');
    }

    public String creditRelationshipSaveReportBaseUrl() {
        return RESTUtility.CreditRelationshipUrl;
    }

    public String creditRelationshipOreoSaveReportBaseUrl() {
        return RESTUtility.CreditRelationshipUrlOREO;
    }

    public String restServiceBaseUrl() {
        return get('serviceBaseUrl');
    }

    public String barcodeGeneratorUploadDrawerName() {
        return get('barcodeGeneratorUploadDrawerName');
    }
}