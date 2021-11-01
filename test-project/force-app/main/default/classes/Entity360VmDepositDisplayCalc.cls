public with sharing class Entity360VmDepositDisplayCalc extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type)
    {
    	return type == Entity360.ElementType.DEPOSIT;
    }

    public String GetSymbol()
    {
    	return 'DP';
	}

    public String GetElementSummary()
    {
    	return 'Deposit';
	}

    public override String GetExistingSummary(Decimal existingValue)
    {
        return GetElementSummary() + ' Accounts (Prev Month Avg Bal): ' + GetDisplayValue(existingValue);
	}

    public override String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability)
    {
    	return GetElementSummary() +' Opportunities: ' + GetDisplayValue(opportunityValue) + ' / ' + GetDisplayPercent(opportunityProbability) + '% weighted probability';
    }
}