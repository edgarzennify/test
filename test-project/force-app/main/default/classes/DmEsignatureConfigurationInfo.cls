public class DmEsignatureConfigurationInfo{
    public class DmEsignatureConfiguration {
        public string applicationId{get;set;}
        public string salesforceRecordId{get;set;}
        public string referenceIdType{get;set;}
        public string appUrl{get;set;}
        public string objectNameApi{get;set;}
        public string recordTypeName{get;set;}
        public string permissionSet{get;set;}
        public string name{get;set;}
        public boolean isPdf {get;set;}
        public boolean isTemplateDynamic{get;set;}
        public boolean isSignerAttachmentRequired{get;set;}
        public boolean IsNotificationRequired{get;set;}
        public string templateFileName {get;set;}
        public string signerTemplateFileName {get;set;}
        public string signatureDocumentName{get;set;}
        public string department{get;set;}
        public string statusFieldName{get;set;}
        public string statusValue{get;set;}
        public List<DmEsignatureConfigurationField> fields{get;set;}
	}
    
    public class DmEsignatureConfigurationField{
        public string identifier{get;set;}
        public string fieldName{get;set;}
        public string fieldNameApi{get;set;}
        public string fieldType{get;set;}
        public string salesforceNameApi{get;set;}
        public decimal sortOrder{get;set;}
        public string roleCode{get;set;}
        public integer roleOrder{get;set;}
    }
}