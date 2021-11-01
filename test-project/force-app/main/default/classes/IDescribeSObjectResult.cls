public interface IDescribeSObjectResult {
    IDescribeFieldResult getFieldResult(String fieldName);
    String getName();
}