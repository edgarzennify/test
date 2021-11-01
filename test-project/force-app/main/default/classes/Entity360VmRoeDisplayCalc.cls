public with sharing class Entity360VmRoeDisplayCalc  extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type) 
    {
    	return type == Entity360.ElementType.ROE;
    }

    public override String GetDisplayValue(Decimal decimalRoe)
    {
        Decimal rawRoe = (decimalRoe != null) ? decimalRoe * 100 : 0;
        return String.ValueOf(rawRoe.setScale(0, RoundingMode.HALF_UP)) + '%';
    }

    public String GetSymbol()
    {
    	return 'ROE';
	}

	public String GetElementSummary()
    {
    	return 'Return on Equity (Previous Month)';
	} 
}