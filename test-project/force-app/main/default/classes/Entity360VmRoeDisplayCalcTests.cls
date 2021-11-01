@isTest
private class Entity360VmRoeDisplayCalcTests
{
	private static final Entity360VmRoeDisplayCalc sut;
	private static Entity360.ElementType m_type = Entity360.ElementType.ROE;

	static{
		sut = new Entity360VmRoeDisplayCalc();
	}

	private static testMethod void it_should_result_true_if_type_is_roe()
	{

		Boolean result = sut.IsType(m_type);

		system.assertEquals(true,result);
	}

	private static testMethod void it_should_get_display_value_with_percent_when_roe_is_passed()
	{
		String result = sut.GetDisplayValue(.15);

		system.assertEquals('15%',result);
	}

	private static testMethod void it_should_format_percent_when_roe_is_passed()
	{
		Decimal roe = .15;

		String result = sut.GetDisplayPercent(roe);

		system.assertEquals('20', result);
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

	private static testMEthod void it_should_get_the_symbol_roe_when_symbol_is_requested()
	{
		String result = sut.GetSymbol();

		system.assertEquals('ROE',result);
	}

	private static testMethod void it_should_return_the_text_roe_when_get_summary_is_called()
	{
		String result = sut.GetElementSummary();

		system.assertEquals('Return on Equity (Previous Month)',result);
	} 
}