public class DescribeSObjectResultWrapper implements IDescribeSObjectResult{
	private final Schema.DescribeSObjectResult m_sObjectResult;
    public DescribeSObjectResultWrapper(Schema.DescribeSObjectResult sObjectResult){
        m_sObjectResult = sObjectResult;
    }

    public IDescribeFieldResult getFieldResult(String fieldName){
        return new DescribeFieldResultWrapper(m_sObjectResult.fields.getMap().get(fieldName).getDescribe());
    }

    public String getName(){
        return m_sObjectResult.getName();
    }
}