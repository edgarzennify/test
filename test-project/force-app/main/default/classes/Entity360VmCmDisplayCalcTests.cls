@isTest
private class Entity360VmCmDisplayCalcTests
{
	private static final Entity360VmCmDisplayCalc sut;
	private static Entity360.ElementType m_type = Entity360.ElementType.CM;

	static{
		sut = new Entity360VmCmDisplayCalc();
	}

	private static testMethod void it_should_result_true_if_type_is_cm()
	{

		Boolean result = sut.IsType(m_type);

		system.assertEquals(true,result);
	}

	private static testMethod void it_should_get_display_value_with_dollar_sign_when_cm_is_passed()
	{
		String result = sut.GetDisplayValue(15000);

		system.assertEquals('$15,000',result);
	}

	private static testMethod void it_should_return_active_when_an_element_has_existing_value()
	{
		Decimal existingValue = 20.00;
		Decimal opportunityValue = 0.00;

		String result = sut.GetElementType(existingValue, opportunityValue);

		system.assertEquals('active', result);
	}

	private static testMethod void it_should_return_active_when_an_element_has_opportunity_value()
	{
		Decimal existingValue = 0.00;
		Decimal opportunityValue = 30.00;

		String result = sut.GetElementType(existingValue, opportunityValue);

		system.assertEquals('active', result);
	}

	private static testMethod void it_should_return_active_when_an_element_has_existing_and_opportunity_value()
	{
		Decimal existingValue = 20.00;
		Decimal opportunityValue = 30.00;

		String result = sut.GetElementType(existingValue, opportunityValue);

		system.assertEquals('active', result);
	}

	private static testMethod void it_should_return_inactive_when_an_element_has_no_existing_and_no_opportunity_value()
	{
		Decimal existingValue = 0.00;
		Decimal opportunityValue = 0.00;

		String result = sut.GetElementType(existingValue, opportunityValue);

		system.assertEquals('inactive', result);
	}

	private static testMEthod void it_should_get_the_symbol_cm_when_symbol_is_requested()
	{
		String result = sut.GetSymbol();

		system.assertEquals('CM',result);
	}

	private static testMethod void it_should_return_the_text_cm_when_get_summary_is_called()
	{
		String result = sut.GetElementSummary();

		system.assertEquals('Contribution Margin (YTD)',result);
	}

	private static testMethod void it_should_calculate_display_percent_for_the_provided_decimal_percent() {
		Decimal percentAsDecimal1 = 0.00;
		Decimal percentAsDecimal2 = 0.10;
		Decimal percentAsDecimal3 = 0.17;
		Decimal percentAsDecimal4 = 0.27;
		Decimal percentAsDecimal5 = 0.37;
		Decimal percentAsDecimal6 = 0.47;
		Decimal percentAsDecimal7 = 0.57;
		Decimal percentAsDecimal8 = 0.67;
		Decimal percentAsDecimal9 = 0.77;
		Decimal percentAsDecimal10 = 0.87;
		Decimal percentAsDecimal11 = 1.00;

		String result1 = sut.GetDisplayPercent(percentAsDecimal1);
		String result2 = sut.GetDisplayPercent(percentAsDecimal2);
		String result3 = sut.GetDisplayPercent(percentAsDecimal3);
		String result4 = sut.GetDisplayPercent(percentAsDecimal4);
		String result5 = sut.GetDisplayPercent(percentAsDecimal5);
		String result6 = sut.GetDisplayPercent(percentAsDecimal6);
		String result7 = sut.GetDisplayPercent(percentAsDecimal7);
		String result8 = sut.GetDisplayPercent(percentAsDecimal8);
		String result9 = sut.GetDisplayPercent(percentAsDecimal9);
		String result10 = sut.GetDisplayPercent(percentAsDecimal10);
		String result11 = sut.GetDisplayPercent(percentAsDecimal11);

		System.assertEquals('0' ,result1);
		System.assertEquals('10' ,result2);
		System.assertEquals('20' ,result3);
		System.assertEquals('30' ,result4);
		System.assertEquals('40' ,result5);
		System.assertEquals('50' ,result6);
		System.assertEquals('60' ,result7);
		System.assertEquals('70' ,result8);
		System.assertEquals('80' ,result9);
		System.assertEquals('90' ,result10);
		System.assertEquals('100' ,result11);
	} 
}