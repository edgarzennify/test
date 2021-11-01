@isTest
private class Entity360VmCreditCardDisplayCalcTests
{
	private static final Entity360VmCreditCardDisplayCalc sut;
	private static Entity360.ElementType m_type = Entity360.ElementType.CREDIT_CARD;

	static{
		sut = new Entity360VmCreditCardDisplayCalc();
	}

	private static testMethod void it_should_result_true_if_type_is_credit_card()
	{

		Boolean result = sut.IsType(m_type);

		system.assertEquals(true,result);
	}

	private static testMethod void it_should_not_format_an_amount_when_decimal_amount_is_passed_is_greater_than_ten_thousand_and_less_that_million()
	{
		Decimal amount = 200000.00;

		String result = sut.GetDisplayValue(amount);

		system.assertEquals('200000', result);
	}

	private static testMethod void it_should_not_format_an_amount_when_decimal_amount_is_passed_is_greater_than_million()
	{
		Decimal amount = 2000000.00;

		String result = sut.GetDisplayValue(amount);

		system.assertEquals('2000000', result);
	} 

	private static testMethod void it_should_calculate_the_closest_value_when_roe_is_passed()
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

	private static testMEthod void it_should_get_the_symbol_CC_when_symbol_is_requested()
	{
		String result = sut.GetSymbol();

		system.assertEquals('CC',result);
	}

	private static testMethod void it_should_return_the_text_Credit_card_when_get_summary_is_called()
	{
		String result = sut.GetElementSummary();

		system.assertEquals('Credit Card',result);
	} 

	private static testMethod void it_should_get_a_existing_summary_for_tool_tip_when_an_existing_value_is_passed()
	{
		Decimal existingValue = 3000000.00;

		String result = sut.GetExistingSummary(existingValue);

		system.assertEquals('Credit Cards: 3000000', result);
	}

	private static testMethod void it_should_get_a_opportunity_summary_for_tooltip_when_an_opportunity_value_is_passed()
	{
		Decimal opportunityValue = 10.00;
		Decimal opportunityProbability = .80;

		String result = sut.GetOpportunitySummary(opportunityValue, opportunityProbability);

		system.assertEquals( 'Credit Card Opportunities: 10 / 80% weighted probability', result);
	}
}