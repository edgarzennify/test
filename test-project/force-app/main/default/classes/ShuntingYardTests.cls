@IsTest
private class ShuntingYardTests {
	
	private static final ShuntingYard.IShuntingYard sut;
	private static Mock.ofIQueueFactory m_queueFactory;
    private static Mock.ofIStackFactory m_stackFactory;

	static {
		m_queueFactory = new Mock.ofIQueueFactory();
		m_stackFactory = new Mock.ofIStackFactory();
        sut = new ShuntingYard(m_queueFactory, m_stackFactory);
    }

	// FORMULA CONVERTER METHOD START  
	// (PA reads as Parenthesis A)
	// ------------------------------
	@IsTest
    static void it_should_format_the_formula_with_A_and_B_and_C() {
		String formula = 'A and B and C';
		Map<String, Boolean> data = new Map<String, Boolean>();
		data.put('A', true);
		data.put('B', false);
		data.put('C', true);

		String expected = 'true and false and true';

		String results = sut.FormulaConverter(formula, data);

		System.assertEquals(expected, results);
	}

	@IsTest
    static void it_should_format_the_formula_with_PA_or_BP_and_C() {
		String formula = '(A or B) and C';
		Map<String, Boolean> data = new Map<String, Boolean>();
		data.put('A', true);
		data.put('B', false);
		data.put('C', true);

		String expected = ' ( true or false )  and true';

		String results = sut.FormulaConverter(formula, data);

		System.assertEquals(expected, results);
	}

	@IsTest
    static void it_should_format_the_formula_with_PPA_or_BP_and_CP() {
		String formula = '((A or B) and C)';
		Map<String, Boolean> data = new Map<String, Boolean>();
		data.put('A', true);
		data.put('B', false);
		data.put('C', true);

		String expected = ' (  ( true or false )  and true ) ';

		String results = sut.FormulaConverter(formula, data);

		System.assertEquals(expected, results);
	}

	@IsTest
    static void it_should_format_the_formula_with_PPA_or_BP_and_PC_or_DPP() {
		String formula = '((A or B) and (C or D))';
		Map<String, Boolean> data = new Map<String, Boolean>();
		data.put('A', true);
		data.put('B', false);
		data.put('C', true);
		data.put('D', true);

		String expected = ' (  ( true or false )  and  ( true or true )  ) ';

		String results = sut.FormulaConverter(formula, data);

		System.assertEquals(expected, results);
	}

	// POSTFIX METHOD START
	// --------------------
	@IsTest
    static void it_should_return_string_list_postfix_with_A_and_B_and_C() {
		String formula = 'true and true and true';
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setup('getNewInstance').returns(new Stack());

		List<String> results = sut.toPostfix(formula);

		System.assertEquals(5, results.size());
		System.assertEquals('true', results[0]);
		System.assertEquals('true', results[1]);
		System.assertEquals('true', results[2]);
		System.assertEquals('and', results[3]);
		System.assertEquals('and', results[4]);
	}

	@IsTest
    static void it_should_return_string_list_postfix_with_PA_or_BP_and_C() {
		String formula = ' ( true or false )  and true';
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setup('getNewInstance').returns(new Stack());

		List<String> results = sut.toPostfix(formula);

		System.assertEquals(5, results.size());
		System.assertEquals('true', results[0]);
		System.assertEquals('false', results[1]);
		System.assertEquals('or', results[2]);
		System.assertEquals('true', results[3]);
		System.assertEquals('and', results[4]);
	}

	@IsTest
    static void it_should_return_string_list_postfix_with_PPA_or_BP_and_CP() {
		String formula = ' (  ( false or true )  and false ) ';
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setup('getNewInstance').returns(new Stack());

		List<String> results = sut.toPostfix(formula);

		System.assertEquals(5, results.size());
		System.assertEquals('false', results[0]);
		System.assertEquals('true', results[1]);
		System.assertEquals('or', results[2]);
		System.assertEquals('false', results[3]);
		System.assertEquals('and', results[4]);
	}

	@IsTest
    static void it_should_return_string_list_postfix_with_PPA_or_BP_and_PC_or_DPP() {
		String formula = ' (  ( true or false )  and  ( true or true )  ) ';
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setup('getNewInstance').returns(new Stack());

		List<String> results = sut.toPostfix(formula);

		System.assertEquals(7, results.size());
		System.assertEquals('true', results[0]);
		System.assertEquals('false', results[1]);
		System.assertEquals('or', results[2]);
		System.assertEquals('true', results[3]);
		System.assertEquals('true', results[4]);
		System.assertEquals('or', results[5]);
		System.assertEquals('and', results[6]);
	}

	// EVALUATE METHOD START
	// ---------------------
	@IsTest
    static void it_should_return_true_on_evaluate() {
		String formula = 'true and true';
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

		Boolean result = sut.evaluate(formula);

		System.assertEquals(true, result);
	}

	// RUN METHOD START
	// ----------------
	@IsTest
    static void it_should_return_true_on_run() {
		String formula = '(A or B) and C';
		Map<String, Boolean> data = new Map<String, Boolean>();
		data.put('A', true);
		data.put('B', false);
		data.put('C', true);

		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

		Boolean result = sut.run(formula, data);

		m_queueFactory.verify('getNewInstance', Times.AtLeastOnce);
		m_stackFactory.verify('getNewInstance', Times.AtLeastOnce);

	    System.assertEquals(true, result);
	}

	@IsTest
    static void it_should_return_true_when_not_A_is_not_true() {
		string formula = 'not A';
            Map<string, Boolean> data = new Map<string, Boolean>
            {
                'A' => false
            };
			m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
			m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

            boolean result = sut.run(formula, data);

            System.assertEquals(true, result);
	}

	@IsTest
    static void it_should_return_true_when_not_A_is_not_true_not_implemented_as_exclamation() {
            string formula = '! A and !A';
            Map<string, boolean> data = new Map<string, boolean>
            {
                'A' => false
            };
		    m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
			m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

            boolean result = sut.run(formula, data);

            System.assertEquals(true, result);
    }

	@IsTest
    static void it_should_return_true_when_not_A_is_false() {
            string formula = 'not A or (A and B)';
            Map<string, boolean> data = new Map<string, boolean>
            {
                'A'=> false,
                'B'=> true
            };
			m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
			m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

            boolean result = sut.run(formula, data);

            System.assertEquals(true,result);
    }
	
	@IsTest
    static void it_should_return_true_when_not_A_is_true_and_B_is_false() {
		string formula = 'not A or (A and B)';
		Map<string, boolean> data = new Map<string, boolean>
		{
			'A' => true,
			'B' => false
		};
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

		boolean result = sut.run(formula, data);

		system.assertEquals(false, result);
	}

	@IsTest
    static void it_should_return_true_when_A_is_true_and_B_is_true() {
		string formula = 'A or (A and not B)';
		Map<string, boolean> data = new Map<string, boolean>
		{
			'A' => true,
			'B'=> true
		};
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

		boolean result = sut.run(formula, data);

		System.assertEquals(true,result);
	}

	@IsTest
    static void it_should_return_false_when_A_is_true_and_B_is_false_in_the_given_formula() {
		string formula = 'not A or (A and B) ';
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());
		Map<string, boolean> data = new Map<string, boolean>
		{
			'A' => true,
			'B'=> true
		};

		boolean result = sut.run(formula, data);

		System.assertEquals(true,result);
	}

	@IsTest
    static void it_should_return_true_when_A_amperstand_amperstand_A() {
            string formula = 'A &&A';
            Map<string, boolean> data = new Map<string, boolean>
            {
                'A' => true
            };
		    m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
			m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

            boolean result = sut.run(formula, data);

            System.assertEquals(true, result);
    }

	@IsTest
    static void it_should_return_true_when_A_pipe_pipe_B() {
            string formula = 'A ||B';
            Map<string, boolean> data = new Map<string, boolean>
            {
                'A' => true,
				'B' => false
            };
		    m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
			m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());

            boolean result = sut.run(formula, data);

            System.assertEquals(true, result);
    }

	@IsTest
    static void it_should_return_true_when_both_items_are_false_with_a_not_in_front_of_one() {
		string formula = 'not A or (A and B)';
		Map<string, boolean> data = new Map<string, boolean>
        {
        	'A' => false,
			'B' => false
        };
		m_queueFactory.setupSequence('getNewInstance').returns(new Queue()).returns(new Queue());
		m_stackFactory.setupSequence('getNewInstance').returns(new Stack()).returns(new Stack());
 			
		boolean result = sut.run(formula, data);

        System.assertEquals(true, result);
	}
}