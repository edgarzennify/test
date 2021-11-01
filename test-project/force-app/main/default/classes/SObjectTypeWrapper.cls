public class SObjectTypeWrapper implements ISObjectType{
    
    private final SObjectType m_sObjectType;
    public SObjectTypeWrapper(SObjectType sObjectType){
        m_sObjectType = sObjectType;
    }

    public IDescribeSObjectResult getDescribe(){
        List<IDescribeSObjectResult> objs = new List<IDescribeSObjectResult>();
        Schema.DescribeSObjectResult sObjectResult = m_sObjectType.getDescribe();

        return new DescribeSObjectResultWrapper(sObjectResult);
    }

    public SObject newSObject(){
        return m_sObjectType.newSObject();
    }
}