public class EsignatureApplicationSfFieldBuilder implements EsignatureApplication.IFieldBuilder{
    
    private final string SALESFORCE_RECORD_ID = 'salesforce record id';

    private final EsignatureApplication.IFieldHelper m_fieldHelper;
    private final EsignatureApplication.IRepository m_repository;

    public EsignatureApplicationSfFieldBuilder(EsignatureApplication.IFieldHelper fieldHelper, EsignatureApplication.IRepository repository){
        m_fieldHelper = fieldHelper;
        m_repository = repository;
    }

    public Boolean handle(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
        return dm.referenceIdType.toLowerCase() == SALESFORCE_RECORD_ID &&  String.isNotBlank(dm.salesforceRecordId);
    }

    public EsignatureApplication.FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
        EsignatureApplication.FieldData fieldData =  m_fieldHelper.buildFields(dm, true);
        EsignatureApplication.FieldDefaultValueRequest request = m_fieldHelper.buildRequest(dm);
        List<Dataprovider.DynamicQueryResult> queryResults = m_repository.runQuery(request.fieldsForQuery, dm.objectNameApi, dm.salesforceRecordId);
        
        return m_fieldHelper.BuildFieldWithDefaultValues(queryResults, dm, fieldData, request.fieldMap);
    }
}