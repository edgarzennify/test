global class EsignatureApplication {

    public interface IDataProvider extends DataProvider.IDataProvider{
        PM_Esignature_Configuration_c getConfigurationByAppId(string applicationId);
        List<PM_Esignature_Configuration_c> getConfigurations();
    }

    public interface IRepository{
        List<Dataprovider.DynamicQueryResult> runQuery(List<string> fieldsForQuery, string objectName, string recordId);
        DmEsignatureConfigurationInfo.DmEsignatureConfiguration buildDm(string applicationId, string salesforceId);
        void save(List<SObject> sobjs);
    }

    public interface IVmBuilder{
        FormVm build(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, boolean hasPermission);
        SignatureData Build(DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse response);
    }

    public interface IRequestBuilder{
        DigitalSignatureFormGeneratorProxy.SignatureRequest buildRequest(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm,string userId,string salesforceId, EsignatureApplication.SaveModel sm);
    }

    public interface IFieldBuilder{
        boolean handle(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm);
        FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm);
    }

    public interface IFieldHelper{
        FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, boolean isDefaultValueRequired);
        FieldData BuildFieldWithDefaultValues(List<Dataprovider.DynamicQueryResult> results, DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, 
                                    FieldData fieldData, Map<string, string> fieldMap);
        FieldDefaultValueRequest buildRequest(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm);
    }

    public interface IDocProvider extends DataProvider.IDataProvider{
        string buildDocumentForPreview(string base64Pdf);
    }

    public interface IPresenter{
        FormVm buildFormVm(string applicationId, string recordId);
        SignatureData getSignatureData(string applicationId);
        SignatureData filterData(SignatureData data, string filter);
        SignatureData filterDataByRecordId(SignatureData data, string recordId);
        string getDocumentForSignaturePreview(string applicationId, string recordId, SaveModel sm);
        void sendForSignature(string applicationId, string recordId, SaveModel sm);
    }


    global class FormVm{
        public string applicationName{get;set;}
        public string department{get;set;}
        public boolean hasPermission{get;set;}
        public boolean isTemplateDynamic{get;set;}
        public boolean isNotificationRequired{get;set;}
        public boolean isSalesforceIdAvailable{get;set;}
        public string salesforceRecordUrl{get;set;}
        public string error{get;set;}
        public List<FieldLayout> signerFields{get;set;}
        public List<FieldLayout> otherFields{get;set;}
    }

    public class FieldLayout implements Comparable{
        public string id{get;set;}
        public string label{get;set;}
        public string defaultValue{get;set;}
        public string fieldType{get;set;}
        public boolean readonly{get;set;}
        public decimal order{get;set;}
        public boolean isSignerField{get;set;}

        public Integer compareTo(Object compareTo) {
            FieldLayout other = (FieldLayout) compareTo;
            if (order == other.order) return 0;
            if (order > other.order) return 1;
            return -1;
        }
    }

    global class SaveModel{
        public List<SaveModelElement> saveData{get;set;}
        public string dynamicFileTemplateAsBase64 {get;set;}
        public string notificationEmail {get;set;}
        public string comments {get;set;}
        public string dynamicFileTemplateName {get;set;}
    }

    global class SaveModelElement{       
        public string fieldId{get;set;}
        public string fieldValue{get;set;}       
    }

    global class SignatureData{
        public List<SignatureDataItem> items{get;set;}
    }

    global class SignatureDataItem{
        public integer applicationId { get; set; }
        public string status { get; set; }
        public string name { get; set; }
        public string comments {get;set;}
        public string templateFileName{get;set;}
        public string email { get; set; }
        public string securityPin { get; set; }
        public string referenceId { get; set; }
        public string transactionId { get; set; }
        public string sentDate { get; set; }
        public string signedDate { get; set; }
        public string documentUrl { get; set; }
        public string userId { get; set; }
        public DateTime created { get; set; }
    }

    public class FieldData{
        public List<FieldLayout> SignerFields{get;set;}
        public List<FieldLayout> OtherFields{get;set;}
    }

    public class FieldDefaultValueRequest{
        public List<string> FieldsForQuery{get;set;}
        public Map<string, string> FieldMap{get;set;}
    }

    public class NoHandlerFoundForRequestException extends Exception{}
    public class RecordIdNotFoundException extends Exception{}
}