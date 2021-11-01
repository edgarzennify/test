public with sharing class Entity360VmTreasuryDisplayCalc extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type)
    {
    	return type == Entity360.ElementType.TREASURY;
    }

    public String GetSymbol()
    {
    	return 'TM';
	}

    public String GetElementSummary()
    {
    	return 'Treasury Management';
	}

    public override String GetExistingSummary(Decimal existingValue)
    {
        return GetElementSummary() + ' Services: ' + GetDisplayValue(existingValue);
	}

    public override String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability)
    {
    	return GetElementSummary() +' Opportunities (Num of Products): ' + GetDisplayValue(opportunityValue) + ' / ' + GetDisplayPercent(opportunityProbability) + '% weighted probability';
    }   
}