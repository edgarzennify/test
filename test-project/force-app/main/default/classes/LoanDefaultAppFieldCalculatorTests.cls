@IsTest
private class LoanDefaultAppFieldCalculatorTests {

    private static LoanDefaultAppFieldCalculator sut;

    static {
        sut = new LoanDefaultAppFieldCalculator();
    }

    @IsTest
    static void it_should_set_the_correct_default_app_when_product_is_credit_card_and_stage_is_booked_complete_or_closed() {
        LLC_BI__Loan__c lnBooked = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Booked'
        );
        LLC_BI__Loan__c lnComplete = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Complete'
        );
        LLC_BI__Loan__c lnClosed = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = 'Closed'
        );
		
        sut.calculate(lnBooked);
        sut.calculate(lnComplete);
        sut.calculate(lnClosed);
        
        String expected = 'credit-booked-ui.dashboard-credit-booked-ui-loan';
        System.assertEquals(expected, lnBooked.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnComplete.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnClosed.LLC_BI__Default_App__c);   
    }

    @IsTest
    static void it_should_set_the_correct_default_app_when_product_is_credit_card_and_stage_is_NOT_booked_complete_or_closed() {
		LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product__c = 'Credit Card',
            LLC_BI__Stage__c = null
        );
		
        sut.calculate(loan);
        
        System.assertEquals('Credit-ui.dashboard-credit-Loan', loan.LLC_BI__Default_App__c);
    }

    @IsTest
    static void it_should_set_the_correct_default_app_when_product_line_is_commercial_and_stage_is_booked_complete_or_closed() {
        LLC_BI__Loan__c lnBooked = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product_Line__c = 'Commercial/Business',
            LLC_BI__Stage__c = 'Booked'
        );
        LLC_BI__Loan__c lnComplete = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product_Line__c = 'Commercial/Business',
            LLC_BI__Stage__c='Complete'
        );
        LLC_BI__Loan__c lnClosed = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3'),
            LLC_BI__Product_Line__c = 'Commercial/Business',
            LLC_BI__Stage__c = 'Closed'
        );
        
        sut.calculate(lnBooked);
        sut.calculate(lnComplete);
        sut.calculate(lnClosed);

        String expected = 'commercial-booked-ui.dashboard-commercial-booked-ui-loan';
        System.assertEquals(expected, lnBooked.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnComplete.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnClosed.LLC_BI__Default_App__c); 
    }

    @IsTest
    static void it_should_set_the_correct_default_app_when_product_line_is_commercial_and_stage_is_NOT_booked_complete_or_closed() {
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product_Line__c = 'Commercial/Business',
            LLC_BI__Stage__c = null
        );
        
        sut.calculate(loan);

        System.assertEquals('commercial-ui.dashboard-loan-ui', loan.LLC_BI__Default_App__c);
    }

    @IsTest
    static void it_should_set_the_correct_default_app_when_product_line_is_ehl_or_consumer_and_stage_is_booked_complete_or_closed() {
        LLC_BI__Loan__c lnEhlBooked = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product_Line__c = 'Mortgage',
            LLC_BI__Stage__c = 'Booked'
        );
        LLC_BI__Loan__c lnEhlComplete = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product_Line__c = 'Mortgage',
            LLC_BI__Stage__c = 'Complete'
        );
        LLC_BI__Loan__c lnEhlClosed = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '3'),
            LLC_BI__Product_Line__c = 'Mortgage',
            LLC_BI__Stage__c = 'Closed'
        );
        LLC_BI__Loan__c lnConsumerBooked = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '4'),
            LLC_BI__Product_Line__c = 'Consumer',
            LLC_BI__Stage__c = 'Booked'
        );
        LLC_BI__Loan__c lnConsumerComplete = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '5'),
            LLC_BI__Product_Line__c = 'Consumer',
            LLC_BI__Stage__c = 'Complete'
        );
        LLC_BI__Loan__c lnConsumerClosed = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '6'),
            LLC_BI__Product_Line__c = 'Consumer',
            LLC_BI__Stage__c = 'Closed'
        );

        sut.calculate(lnEhlBooked);
        sut.calculate(lnEhlComplete);
        sut.calculate(lnEhlClosed);
        sut.calculate(lnConsumerBooked);
        sut.calculate(lnConsumerComplete);
        sut.calculate(lnConsumerClosed);
        
        String expected = 'consumer-booked-ui.dashboard-consumer-booked-ui-loan';
        System.assertEquals(expected, lnEhlBooked.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnEhlComplete.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnEhlClosed.LLC_BI__Default_App__c); 
        System.assertEquals(expected, lnConsumerBooked.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnConsumerComplete.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnConsumerClosed.LLC_BI__Default_App__c); 
    }

    @IsTest
    static void it_should_set_the_correct_default_app_when_product_line_is_ehl_or_consumer_and_stage_is_NOT_booked_complete_or_closed() {
        LLC_BI__Loan__c lnLoan1 = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product_Line__c = 'Mortgage',
            LLC_BI__Stage__c = null
        );
        LLC_BI__Loan__c lnLoan2 = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product_Line__c = 'Consumer',
            LLC_BI__Stage__c = null
        );

        sut.calculate(lnLoan1);
        sut.calculate(lnLoan2);
        
        String expected = 'consumer-ui.dashboard-consumer-ui-loan';
        System.assertEquals(expected, lnLoan1.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnLoan2.LLC_BI__Default_App__c);        
    }

    @IsTest
    static void it_should_set_the_default_value_of_default_app_when_product_and_product_lines_are_not_valid() {
		LLC_BI__Loan__c lnProduct = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product__c = 'Bogus Product'
        );
        LLC_BI__Loan__c lnProdLine = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product_Line__c = 'Bogus'
        );

        sut.calculate(lnProduct);
        sut.calculate(lnProdLine);
    
        String expected = 'Please contact IT Helpdesk.';
        System.assertEquals(expected, lnProduct.LLC_BI__Default_App__c);
        System.assertEquals(expected, lnProdLine.LLC_BI__Default_App__c);
    }

    @IsTest
    static void it_should_set_the_default_app_field_when_given_multiple_loans() {
		LLC_BI__Loan__c ln1 = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1'),
            LLC_BI__Product__c = 'Bogus Product'
        );
        LLC_BI__Loan__c ln2 = new LLC_BI__Loan__c(
            Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '2'),
            LLC_BI__Product_Line__c = 'Bogus'
        );

        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{ln1, ln2};

        sut.calculate(loans);
    
        String expected = 'Please contact IT Helpdesk.';
        System.assertEquals(expected, ln1.LLC_BI__Default_App__c);
        System.assertEquals(expected, ln2.LLC_BI__Default_App__c);
    }
}