public class SObjectFieldWrapper implements ISObjectField {
    private Schema.SObjectField m_sobjectField;
    
    public SObjectFieldWrapper(Schema.SObjectField sobjectField) {
        m_sobjectField = sobjectField;
    }
    
    public IDescribeFieldResult getDescribe() {       
        return new DescribeFieldResultWrapper(m_sobjectField.getDescribe());
    }
    
    public Boolean isUpdateable() {
        return getDescribe().isUpdateable();
    }

    public Boolean isCreatable() {
        return getDescribe().isCreateable();
    }

    public Boolean isCalculated() {
        return getDescribe().isCalculated();
    }

    public Boolean isAccessible() {
        return getDescribe().isAccessible();
    }

    public DescribeFieldResultWrapper.Type getType() {
        return getDescribe().getType();
    }

    public List<IPicklistEntry> getPicklistValues() {
        return getDescribe().getPicklistValues();
    }

    public String getInlineHelpText() {
        return getDescribe().getInlineHelpText();
    }

    public String getName() {
        return getDescribe().getName();
    }

    public String getLabel() {
        return getDescribe().getLabel();
    }
}