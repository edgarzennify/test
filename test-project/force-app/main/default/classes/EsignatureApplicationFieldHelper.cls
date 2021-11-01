public class EsignatureApplicationFieldHelper implements EsignatureApplication.IFieldHelper{

    public EsignatureApplication.FieldData buildFields(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, boolean isDafaultValueRequired){
        EsignatureApplication.FieldData fieldData = new EsignatureApplication.FieldData();
        fieldData.SignerFields = new List<EsignatureApplication.FieldLayout>();
        fieldData.OtherFields = new List<EsignatureApplication.FieldLayout>();
        for(DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f : dm.fields){
            EsignatureApplication.FieldLayout l = new EsignatureApplication.FieldLayout();
            l.id = f.identifier;
            l.label = f.fieldName;
            l.fieldType = f.fieldType;
            l.defaultValue = '';
            l.readonly = false;
            l.order = f.sortOrder == null?0:f.sortOrder;
            if(String.isBlank(f.roleCode)){            
                fieldData.OtherFields.add(l);
            }else{
                fieldData.SignerFields.add(l);
            } 
        }
        return fieldData;
    }

    public EsignatureApplication.FieldData BuildFieldWithDefaultValues(List<Dataprovider.DynamicQueryResult> results, DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm, 
                                    EsignatureApplication.FieldData fieldData, Map<string, string> fieldMap){
        EsignatureApplication.FieldData newFieldData = new EsignatureApplication.FieldData();
        newFieldData.SignerFields = new List<EsignatureApplication.FieldLayout>();
        newFieldData.OtherFields = new List<EsignatureApplication.FieldLayout>();
        Map<string, string> fieldDefaultValues = new Map<string, string>();

        for(Dataprovider.DynamicQueryResult dqr: results){
            for(DataProvider.DynamicQueryFieldResult dqfr: dqr.fieldValues){               
                string fieldId = fieldMap.get(dqfr.fieldName);
                fieldDefaultValues.put(fieldId, string.valueof(dqfr.fieldValue));
            }
        }
      
        newFieldData.SignerFields.addAll(setDefaultValues(fieldData.SignerFields, fieldDefaultValues));
        newFieldData.OtherFields.addAll(setDefaultValues(fieldData.OtherFields, fieldDefaultValues));
        return newFieldData;
    }

    public EsignatureApplication.FieldDefaultValueRequest buildRequest(DmEsignatureConfigurationInfo.DmEsignatureConfiguration dm){
        EsignatureApplication.FieldDefaultValueRequest request = new EsignatureApplication.FieldDefaultValueRequest();
        request.fieldsForQuery = new List<string>();
        request.fieldMap = new Map<string, string>();

        for (DmEsignatureConfigurationInfo.DmEsignatureConfigurationField f : dm.fields) {
            if(string.isNotBlank(f.salesforceNameApi)){
                request.fieldsForQuery.add(f.salesforceNameApi);
                request.fieldMap.put(f.salesforceNameApi,f.identifier);
            }
        }
        return request;
    }

    private List<EsignatureApplication.FieldLayout> setDefaultValues(List<EsignatureApplication.FieldLayout> fields, Map<string, string> fieldDefaultValues){
        List<EsignatureApplication.FieldLayout> updateFields = new List<EsignatureApplication.FieldLayout>();
        for(EsignatureApplication.FieldLayout f : fields){
            EsignatureApplication.FieldLayout newfl = f;
            if(fieldDefaultValues.containsKey(f.id)){
                newfl.defaultValue = fieldDefaultValues.get(f.id);
                newfl.readonly = true;
            }else{
                newfl.defaultValue = '';
                newfl.readonly = false;
            }
            updateFields.add(newFl);
        }
        return updateFields;
    }
}