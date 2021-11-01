@IsTest
public class TmConfigurationMock {

	public class ofIRepository extends ApexMoq implements TmConfiguration.IRepository {
		public List<DmSection> getDetailSections(String recordTypeName, TmConfiguration.Placement placement) {
			return (List<DmSection>)handleMethodInvocation('getDetailSections', new List<Object>{recordTypeName, placement});
		}
        public List<DmSection> getDetailSections2(String record, TmConfiguration.Placement plc) {
            return (List<DmSection>)handleMethodInvocation('getDetailSections2', new List<Object>{record, plc});
        }
        public List<DmSection> getScheduleSections2(String record, TmConfiguration.Placement plc) {
            return (List<DmSection>)handleMethodInvocation('getScheduleSections2', new List<Object>{record, plc});
        }
		public List<DmSection> getScheduleSections(String recordTypeName, TmConfiguration.Placement placement) {
			return (List<DmSection>)handleMethodInvocation('getScheduleSections', new List<Object>{recordTypeName, placement });
		}
		public List<DmSection> getContactSections(String recordTypeName, TmConfiguration.Placement placement) {
			return (List<DmSection>)handleMethodInvocation('getContactSections', new List<Object>{recordTypeName, placement});
		}
        public List<DmSection> getContactSections2(String record, TmConfiguration.Placement plc) {
            return (List<DmSection>)handleMethodInvocation('getContactSections2', new List<Object>{record, plc});
        }
		public List<DmSection> getAccountSections(String recordTypeName, TmConfiguration.Placement placement) {
			return (List<DmSection>)handleMethodInvocation('getAccountSections', new List<Object>{recordTypeName, placement});
		}
        public List<DmSection> getAccountSections2(String record, TmConfiguration.Placement plc) {
            return (List<DmSection>)handleMethodInvocation('getAccountSections2', new List<Object>{record, plc});
        }
		public List<DmSection> getContactAccountSections(String recordTypeName, TmConfiguration.Placement placement) {
			return (List<DmSection>)handleMethodInvocation('getContactAccountSections', new List<OBject>{recordTypeName, placement});
		}
        public List<DmSection> getContactAccountSections2(String record, TmConfiguration.Placement plc) {
            return (List<DmSection>)handleMethodInvocation('getContactAccountSections2', new List<Object>{record, plc});
        }
		public Map<String, DmSection> getAllObjectSections() {
			return (Map<String, DmSection>)handleMethodInvocation('getAllObjectSections');
		}
		public TmBoarding.requestPm getRequest(Id requestId, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
			return (TmBoarding.requestPm)handleMethodInvocation('getRequest', new List<Object>{requestId, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields});
		}
		public TmBoarding.ProductConfig getProduct(String recordTypeName) {
			return (TmBoarding.ProductConfig)handleMethodInvocation('getProduct', new List<Object>{recordTypeName});
		}
		public String getRecordTypeName(TM_Service_Request__c record) {
			return (String)handleMethodInvocation('getRecordTypeName', new List<Object>{record});
		}
        public Blob getTemplateFromAttachment(String attachmentName, String productConfigId) {
            return (Blob)handleMethodInvocation('getTemplateFromAttachment', new List<Object>{attachmentName, productConfigId});
        }
        public List<DmField> getFields(List<DmSection> sections) {
            return (List<DmField>)handleMethodInvocation('getFields', new List<OBject>{sections});
        }
        public Map<string , TmConfiguration.ProductInfo> getProductInfos(Id packetId) {
            return (Map<string , TmConfiguration.ProductInfo>)handleMethodInvocation('getProductInfos', new List<Object>{packetId});
        }
        public Map<String,TmConfiguration.ProductInfo> getProductInfosByRequestId(Id packetId) {
            return (Map<String,TmConfiguration.ProductInfo>)handleMethodInvocation('getProductInfosByRequestId', new List<Object>{packetId});
        }
        public Map<Id, TmBoarding.requestPm> getAllRequests(List<Id> requestIds, List<string> requestFields, List<string> contactFields, List<string> accountFields, List<string> contactAccountFields, List<String> contactCoreFields, List<String> accountCoreFields) {
            return (Map<Id, TmBoarding.requestPm>)handleMethodInvocation('getAllRequests', new List<Object>{requestIds, requestFields, contactFields, accountFields, contactAccountFields, contactCoreFields, accountCoreFields});
        }
	}
	public class ofIQueryBuilder extends ApexMoq implements TmConfiguration.IQueryBuilder {
        public List<String> addRequiredRequestFields(List<String> fields) {
        	return (List<String>)handleMethodInvocation('addRequiredRequestFields', new List<Object>{fields});
        }
        public List<String> addRequiredContactFields(List<String> fields) {
        	return (List<String>)handleMethodInvocation('addRequiredContactFields', new List<Object>{fields});
        }
        public List<String> addRequiredAccountFields(List<String> fields) {
        	return (List<String>)handleMethodInvocation('addRequiredAccountFields', new List<Object>{fields});
        }
        public List<String> addRequiredContactRequestFields(List<String> fields) {
        	return (List<String>)handleMethodInvocation('addRequiredContactRequestFields', new List<Object>{fields});
        }
        public List<String> addRequiredAccountRequestFields(List<String> fields) {
        	return (List<String>)handleMethodInvocation('addRequiredContactRequestFields', new List<Object>{fields});
        }
        public List<String> addRequiredContactAccountFields(List<String> fields) {
        	return ( List<String>)handleMethodInvocation('addRequiredContactAccountFields', new List<Object>{fields});
        }
    }
    public class ofIDmBuilder extends ApexMoq implements TmConfiguration.IDmBuilder {

    	public List<DmSection> buildSections(List<TM_Service_Configuration_Field__c> serviceOptionPms, Map<Id,TM_Service_Configuration_Section__c> sectionOptionPms, TmConfiguration.Placement placement) {
    		return (List<DmSection>)handleMethodInvocation('buildSections', new List<Object>{serviceOptionPms, sectionOptionPms, placement});
    	}
    	public DmSection buildObjectFields(List<ISobjectField> fields, String objectName) {
    		return (DmSection)handleMethodInvocation('buildObjectFields', new List<Object>{fields, objectName});
    	}
        public List<DmSection> buildSections(TmConfiguration.DmBuildRequest req) {
            return (List<DmSection>)handleMethodInvocation('buildSections', new List<Object>{req});
        }
        public TmConfiguration.ProductInfo buildProductInfo(Tm_Service_Request__c pm, TM_Service_Configuration__c cfg) {
            return (TmConfiguration.ProductInfo)handleMethodInvocation('buildProductInfo', new List<Object>{pm, cfg});
        }
    }
    public class ofIVmBuilder extends ApexMoq implements TmConfiguration.IVmBuilder {
    	public TmConfiguration.FormComponent build(String objectName, List<DmSection> sectionDms, List<DmSection> objectSections) {
    		return (TmConfiguration.FormComponent)handleMethodInvocation('build', new List<Object>{objectName, sectionDms, objectSections});
    	}
    	public TmConfiguration.FormComponent buildDetails(String objectName, List<DmSection> detailSections, List<DmSection> scheduleSections, List<DmSection> objectSections) {
    		return (TmConfiguration.FormComponent)handleMethodInvocation('buildDetails', new List<Object>{objectName, detailSections, scheduleSections, objectSections});
    	}
    }
    public class ofIPresenter extends ApexMoq implements TmConfiguration.IPresenter {
    	public TmConfiguration.FormVm build(String productName) {
    		return (TmConfiguration.FormVm)handleMethodInvocation('build', new List<Object>{productName});
    	}
    }
    public class ofIVmMetadataBuilder extends ApexMoq implements TmConfiguration.IVmMetadataBuilder {
    	public  List<TmConfiguration.FormSection> build(List<DmSection> sections) {
    		return (List<TmConfiguration.FormSection>)handleMethodInvocation('build', new List<Object>{sections});
    	}
    	public List<TmConfiguration.FormSection> buildDetails(String objectName , List<DmSection> detailSections, List<DmSection> scheduleSections) {
    		return (List<TmConfiguration.FormSection>)handleMethodInvocation('buildDetails', new List<Object>{objectName, detailSections, scheduleSections});
    	}
	    public List<TmConfiguration.ObjectField> getObjectFields(String objectName, DmSection allFieldsSection) {
	    	return (List<TmConfiguration.ObjectField>)handleMethodInvocation('getObjectFields', new List<Object>{objectName, allFieldsSection});
	    }
    }
    public class ofIFieldBuilder extends ApexMoq implements TmConfiguration.IFieldBuilder {
    	public TmConfiguration.Placement handle() {
    		return (TmConfiguration.Placement)handleMethodInvocation('handle');
    	}
    	public List<DmField> build(List<TM_Service_Configuration_Field__c> pms) {
    		return (List<DmField>)handleMethodInvocation('build', new List<Object>{pms});
    	}
        public List<DmField> build(TmConfiguration.DmBuildRequest req) {
            return (List<DmField>)handleMethodInvocation('build', new List<Object>{req});
        }
    }
    public class ofISectionBuilder extends ApexMoq implements TmConfiguration.ISectionBuilder {
    	public List<DmSection> build(List<DmField> fieldDms, Map<Id,TM_Service_Configuration_Section__c> lookup) {
    		return (List<DmSection>)handleMethodInvocation('build', new List<Object>{fieldDms, lookup});
    	}
        public List<DmSection> build(List<DmField> fieldDms, TmConfiguration.DmBuildRequest req) {
            return (List<DmSection>)handleMethodInvocation('build', new List<OBject>{fieldDms, req});
        }
    }
    public class ofIStageRepository extends ApexMoq implements TmConfiguration.IStageRepository {
        public DmTmRequestStage getStageDetail(String request) {
            return (DmTmRequestStage)handleMethodInvocation('getStageDetail', new List<Object>{request});
        }
        public DmTmRequestStage getDefaultStage() {
            return (DmTmRequestStage)handleMethodInvocation('getDefaultStage');
        }
        public List<DmTmRequestStage> getAllStages() {
            return (List<DmTmRequestStage>)handleMethodInvocation('getAllStages');
        }
    }
}