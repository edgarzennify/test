public interface ISObjectField {
	IDescribeFieldResult getDescribe();
    Boolean isUpdateable();
    String getName();
    String getLabel();
    String getInlineHelpText();
    Boolean isCreatable();
    Boolean isCalculated();
    Boolean isAccessible();
    DescribeFieldResultWrapper.Type getType();
    List<IPicklistEntry> getPicklistValues();
}