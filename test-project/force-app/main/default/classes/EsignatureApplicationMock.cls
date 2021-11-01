@IsTest
public class EsignatureApplicationMock {
    
    public class ofIDataProvider extends Mock.ofIDataProvider implements EsignatureApplication.IDataprovider{
        public PM_Esignature_Configuration_c getConfigurationByAppId(string applicationId){
            return (PM_Esignature_Configuration_c)handlemethodinvocation('getConfigurationByAppId', new List<Object>{applicationId});
        }
        public List<PM_Esignature_Configuration_c> getConfigurations(){
            return (List<PM_Esignature_Configuration_c>)handlemethodinvocation('getConfigurations');
        }
    }
    public class ofIRepository extends ApexMoq implements EsignatureApplication.IRepository{
        public List<Dataprovider.DynamicQueryResult> runQuery(List<string> fieldsForQuery, string objectName, string recordId){
            return (List<Dataprovider.DynamicQueryResult>)handlemethodinvocation('runQuery', new List<Object>{fieldsForQuery,objectName,recordId});
        }
        public DmEsignatureConfigurationInfo.DmEsignatureConfiguration buildDm(string applicationId, string salesforceId){
            return (DmEsignatureConfigurationInfo.DmEsignatureConfiguration)handleMethodInvocation('buildDm', new List<object>{applicationId, salesforceId});
        }
        public void save(List<SObject> sobjs){
            handleMethodInvocation('save', new List<Object>{sobjs});
        }
    }
    public class ofIVmBuilder extends ApexMoq implements EsignatureApplication.IVmBuilder{
        public EsignatureApplication.FormVm build(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, boolean hasPermission){
            return (EsignatureApplication.FormVm)handlemethodinvocation('build', new List<Object>{dm, hasPermission});
        }
    	public EsignatureApplication.SignatureData build(DigitalSignatureFormGeneratorProxy.SignatureStatusDataResponse response){
            return (EsignatureApplication.SignatureData)handlemethodinvocation('build', new List<Object>{response});
    	}
	}
    public class ofIRequestBuilder extends ApexMoq implements EsignatureApplication.IRequestBuilder{
        public DigitalSignatureFormGeneratorProxy.SignatureRequest buildRequest(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm,string userId,string salesforceId, EsignatureApplication.SaveModel sm){
            return (DigitalSignatureFormGeneratorProxy.SignatureRequest)handlemethodinvocation('buildRequest', new List<Object>{dm,userid,salesforceId,sm});
        }
    }
    public class ofIFieldBuilder extends ApexMoq implements EsignatureApplication.IFieldBuilder{
        public Boolean handle(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
            return (boolean)handleMethodInvocation('handle', new List<object>{dm});
        }
        public EsignatureApplication.FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
            return (EsignatureApplication.FieldData)handlemethodinvocation('buildFields', new List<object>{dm});
        }
    }
    public class ofIFieldHelper extends ApexMoq implements EsignatureApplication.IFieldHelper{
        public EsignatureApplication.FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, boolean isDefaultValueRequired){
            return (EsignatureApplication.FieldData)handleMethodInvocation('buildFields', new List<object>{dm,isDefaultValueRequired});
        }
        public EsignatureApplication.FieldData BuildFieldWithDefaultValues(List<Dataprovider.DynamicQueryResult> results, DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, 
                                                EsignatureApplication.FieldData fieldData, Map<string, string> fieldMap){
            return (EsignatureApplication.FieldData)handleMethodInvocation('BuildFieldWithDefaultValues', new List<object>{results,dm,fieldData, fieldMap});
        }
        public EsignatureApplication.FieldDefaultValueRequest buildRequest(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
            return (EsignatureApplication.FieldDefaultValueRequest)handleMethodInvocation('buildRequest', new List<object>{dm});
        }
    }
}