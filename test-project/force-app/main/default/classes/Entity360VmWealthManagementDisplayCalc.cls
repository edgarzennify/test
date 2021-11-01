public class Entity360VmWealthManagementDisplayCalc extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type)
    {
    	return type == Entity360.ElementType.WEALTH_MANAGEMENT;
    }

    public String GetSymbol()
    {
    	return 'WM';
	}

    public String GetElementSummary()
    {
    	return 'Wealth Management';
	}

    public override String GetExistingSummary(Decimal existingValue)
    {
        return GetElementSummary() + ' Accounts (Account Fees): ' + GetDisplayValue(existingValue);
	}

    public override String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability)
    {
    	return GetElementSummary() +' Opportunities (Potential Fees): '+ GetDisplayValue(opportunityValue) + ' / ' + GetDisplayPercent(opportunityProbability) + '% weighted probability';
    }   
}