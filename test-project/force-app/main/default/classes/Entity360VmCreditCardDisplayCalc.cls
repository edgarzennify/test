public with sharing class Entity360VmCreditCardDisplayCalc extends Entity360VmDisplayCalc implements Entity360.IEntity360VmDisplayCalc {
    
    public Boolean IsType(Entity360.ElementType type)
    {
    	return type == Entity360.ElementType.CREDIT_CARD;
    }

    public override String GetDisplayValue(Decimal numberOfCards)
    {
    	return numberOfCards == 0.0 ? '' : String.valueof(Integer.valueof(numberOfCards));
    }

    public String GetSymbol()
    {
    	return 'CC';
	}

    public String GetElementSummary()
    {
    	return 'Credit Card';
	}

    public override String GetExistingSummary(Decimal numberOfCards)
    {
    	return 'Credit Cards: ' + FormatDecimalToNumber(numberOfCards);
	}

    public override String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability)
    {
    	return GetElementSummary() +' Opportunities: ' + GetDisplayValue(opportunityValue) + ' / ' + GetDisplayPercent(opportunityProbability) + '% weighted probability';
    }   
}