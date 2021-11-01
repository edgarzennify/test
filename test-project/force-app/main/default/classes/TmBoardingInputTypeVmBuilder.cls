public class TmBoardingInputTypeVmBuilder implements TmBoarding.IInputTypeVmBuilder {

	public String build(DescribeFieldResultWrapper.Type fieldType, String overrideType) {
		return String.IsBlank(overrideType) 
			   ? getInputType(fieldType)
			   : overrideType;
	}

	private string getInputType(DescribeFieldResultWrapper.Type fldType) {
        if(fldType == null){return 'Blank';}
    	if(fldType == DescribeFieldResultWrapper.Type.TypePhone) {
    		return 'Phone';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypeTextArea) {
    		return 'TextArea';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypeCurrency) {
    		return 'Currency';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypeDate || fldType == DescribeFieldResultWrapper.Type.TypeDateTime) {
    		return 'Date';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypeInteger || fldType == DescribeFieldResultWrapper.Type.TypeDouble) {
    		return 'Numeric';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypePicklist) {
    		return 'Dropdown';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypeBoolean) {
    		return 'Checkbox';
    	} else if(fldType == DescribeFieldResultWrapper.Type.TypeMultipicklist) {
            return 'MultiPicklist';
        } else if(fldType == DescribeFieldResultWrapper.Type.TypeReference){
            return 'Lookup';
        }
    	return 'Text';
    }
}