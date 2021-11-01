public class Entity360VmCmDisplayCalc extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type) 
    {
    	return type == Entity360.ElementType.CM;
    }

    public override String GetDisplayValue(Decimal rawCm)
    {
        String value = (rawCm != null) ? (rawCm.setScale(0, RoundingMode.HALF_UP)).format() : '0';
        return '$' + value;
    }

    public String GetSymbol()
    {
    	return 'CM';
	}

	public String GetElementSummary()
    {
    	return 'Contribution Margin (YTD)';
	}  
}