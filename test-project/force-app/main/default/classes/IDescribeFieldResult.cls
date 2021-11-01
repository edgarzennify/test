public interface IDescribeFieldResult {
    String getLabel();
    String getName();
    String getInlineHelpText();
    List<ISObjectType> getReferenceTo();
    DescribeFieldResultWrapper.Type getType();
    Boolean isUpdateable();
    Boolean isCreateable();
    Boolean isCalculated();
    Boolean isAccessible();
    List<IPicklistEntry> getPicklistValues();
}