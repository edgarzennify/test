public with sharing class Entity360VmDebitCardDisplayCalc extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type)
    {
    	return type == Entity360.ElementType.DEBIT_CARD;
    }

    public override String GetDisplayValue(Decimal numberOfCards)
    {
    	return numberOfCards == 0.0 ? '' : FormatDecimalToNumber(numberOfCards);
    }

    public String GetSymbol()
    {
    	return 'DC';
	}

    public String GetElementSummary()
    {
    	return 'Debit Card';
	}

    public override String GetExistingSummary(Decimal numberOfCards)
    {
    	return 'Debit Cards: ' + FormatDecimalToNumber(numberOfCards);
	}

    public override String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability)
    {
    	return GetElementSummary() +' Opportunities: ' + GetDisplayValue(opportunityValue) + ' / ' + GetDisplayPercent(opportunityProbability) + '% weighted probability';
    }   
}