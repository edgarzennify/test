public virtual class Entity360VMDisplayCalc
{
    public virtual String GetDisplayValue(Decimal rawAmount)
    {
        return formatAmount(rawAmount);
    }

    public String GetDisplayPercent(Decimal percentAsDecimal)
    {
        return calculateDisplayPercent(percentAsDecimal);      
    }

    public Decimal CalculatePercent(Decimal thisPart, Decimal theRest)
    {
       if((thisPart + theRest) == 0.0) return 0.0; 
       return (thisPart / (thisPart + theRest)).setScale(2, RoundingMode.HALF_UP);    
    }

    public String GetElementType(Decimal existingValue, Decimal opportunityValue){
        Boolean hasValue = existingValue != 0 || opportunityValue != 0;
        return hasValue ? 'active' : 'inactive';
    }   

    public virtual String GetExistingSummary(Decimal existingValue){return '';}

    public virtual String GetOpportunitySummary(Decimal opportunityValue, Decimal opportunityProbability){return '';}

    protected String FormatDecimalToNumber(Decimal value)
    {
        return String.ValueOf(Integer.ValueOf(value));
    }

    private String formatAmount(Decimal rawAmount)
    {
        if (rawAmount >= 1000 && rawAmount < 1000000)
        {
            return String.ValueOf((rawAmount / 1000).setScale(1, RoundingMode.HALF_UP)).replace('.0','') + 'K';
        }

        if (rawAmount >= 1000000)
        {
            return String.ValueOf((rawAmount / 1000000).setScale(1, RoundingMode.HALF_UP)).replace('.0','')  + 'MM';
        }
        return String.ValueOf(rawAmount.setScale(0, RoundingMode.HALF_UP));
    }

    private  String calculateDisplayPercent(Decimal percentAsDecimal)
    {
        Decimal rawPercent = percentAsDecimal * 100;
        
        if(rawPercent<= 0){
            return '0';
        }else if(rawPercent> 0 && rawPercent< 15){
            return '10';
        }else if(rawPercent>= 15 && rawPercent< 25){
            return '20';
        }else if(rawPercent>= 25 && rawPercent< 35){
            return '30';
        }else if(rawPercent>= 35 && rawPercent<= 45){
            return '40';
        }else if(rawPercent> 45 && rawPercent< 55){
            return '50';
        }else if(rawPercent>= 55 && rawPercent<= 65){
            return '60';
        }else if(rawPercent> 65 && rawPercent<= 75){
            return '70';
        }else if(rawPercent> 75 && rawPercent<= 85){
            return '80';
        }else if(rawPercent> 85 && rawPercent< 100){
            return '90';
        }
        return '100';
    }
}