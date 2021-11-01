@Istest
private class TmBoardingValidationEngineTests {
    
    private static TmBoardingValidationEngine sut;
    
    static {
        sut = new TmBoardingValidationEngine();
    }
    
    private static testMethod void it_should_build_validations_vm_from_pms() {
        string objectName = 'Tm_service_Request__c';
        string fieldName = 'field-name';
        TmBoarding.FormMetadata meta = new TmBoarding.FormMetadata();
        TmBoarding.FormSection section = new TmBoarding.FormSection();
        TmBoarding.Field fld1 = new TmBoarding.Field();
        fld1.objectName = objectName;
        fld1.Name = fieldName ;
        section.Fields = new List<TmBoarding.Field>{fld1};
        TmBoarding.DependentFields df = new TmBoarding.DependentFields();
        df.Name = 'df-name';
        df.KeyFieldName = 'key-name';
        TmBoarding.Field dfld = new TmBoarding.Field();
        dfld.ObjectName = objectName;
        dfld.Name = 'df-field';
        df.Fields = new List<TmBoarding.Field>{dfld};
        section.DependentFields = new List<TmBoarding.DependentFields>{df};
        meta.Sections = new List<TmBoarding.FormSection>{section};
        TmValidator.ValidationResults vResults = new TmValidator.ValidationResults();
        Map<string, TmValidator.ValidationResults> validationLookup = 
            new Map<string, TmValidator.ValidationResults>{fieldName => vResults};
        
        TmBoarding.FormMetadata result = sut.addValidation(objectName, meta, validationLookup);

        System.assertEquals(fieldName, result.sections[0].fields[0].name);
    }
}