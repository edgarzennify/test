public class TmBoardingValidationEngine implements TmBoarding.IValidationEngine {

	private final string DELIM = '.';

    public TmBoarding.FormMetadata addValidation(string objectName, TmBoarding.FormMetadata meta, Map<string, TmValidator.ValidationResults> validationLookup) {
        for(TmBoarding.FormSection section : meta.Sections) {
            if(section.Fields != null) {
                for(TmBoarding.Field fld : section.Fields) {
                    string fieldName = fld.name;
                    string key = getKey(objectName, fieldName);
                    TmValidator.ValidationResults vr = validationLookup.get(key);
                    if(vr != null) {          
                        updateField(fld, vr, fieldName);
                    }
                    if( section.DependentFields != null) {
                        for(TmBoarding.DependentFields df : section.DependentFields) {
                            for(TmBoarding.Field fld1 : df.fields) {
                                string fieldName1 = fld1.name;
                                string key1 = getKey(objectName, fieldName1);
                                TmValidator.ValidationResults vr1 = validationLookup.get(key1);
                                if(vr1 != null) {          
                                    updateField(fld1, vr1, fieldName1);
                                }

                            }
                        }
                    }
                }
            }
        }

        return meta;
    }

    private void updateField(TmBoarding.Field fld, TmValidator.ValidationResults vr, string fieldName) {
        fld.Validation = new TmBoarding.FieldValidation();
        fld.Validation.ErrorDescription = vr.Error;
        fld.Validation.FieldName = fieldName;
        fld.Validation.Immediate = vr.IsCurrentStage;
        fld.Validation.Correlated = vr.Correlated;
        fld.Validation.Id = vr.Id;
        fld.Validation.ParentId = String.IsBlank(vr.ParentId) ? '' : vr.ParentId; 
    }

    private string getKey(string objectName, string field) {
        if(String.isBlank(field)){return '';}
    	string key = field.replace(objectName, '');
        string nkey = key.replace(DELIM, '');
    	return nkey;
    }
}