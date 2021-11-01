public class ShuntingYard implements IShuntingYard {
    public interface IShuntingYard {
        Boolean run(String formula, Map<String, Boolean> data);
        Boolean evaluate(String formula);
        String formulaConverter(String formula, Map<String, Boolean> data);
        List<String> toPostfix(String formula); 
    }
    private QueueFactory.IQueueFactory m_queueFactory;
    private StackFactory.IStackFactory m_stackFactory;

    public ShuntingYard(QueueFactory.IQueueFactory queue, StackFactory.IStackFactory stack) {
        m_queueFactory = queue;
        m_stackFactory = stack;
    }

    public Boolean run(String formula, Map<String, Boolean> data) {
        formula = formulaConverter(formula, data);
        return evaluate(formula);
    }

    public Boolean evaluate(String formula) {
        List<String> postFix = toPostfix(formula);        
        IStack stack = m_stackFactory.getNewInstance();

        for(String t: postFix) {
            if (isOperator(t)) {
                Boolean op1 = Boolean.valueOf(stack.pop());
                Boolean op2 = Boolean.valueOf(stack.pop());
                Boolean e = VerifyTwoOperands(op1, op2, t);
                stack.push(VerifyTwoOperands(op1, op2, t));
            } else {
                stack.push(t);
            }
        }
        return !stack.isEmpty() && stack.size() == 1 && Boolean.valueOf(stack.peek());
    }

    public String formulaConverter(String formula, Map<String, Boolean> data) {
        formula = formula.replaceAll('\\(', ' ( ');
        formula = formula.replaceAll('\\)', ' ) ');
        formula = formula.replaceAll('\\!', ' not ');
        formula = formula.replaceAll('\\&\\&', ' and ');
        formula = formula.replaceAll('\\|\\|', ' or ');
        //formula = formula.toLowerCase();
        List<String> formulaTokens = formula.split(' ');
        for (String t: formulaTokens) {
            if (!IsOperator(t) && String.isNotBlank(t)) {
                formula = formula.replaceAll(t, String.valueOf(data.get(t)));
            }
        }
        return formula;
    }

    public List<String> toPostfix(String formula) {
        List<String> formulaTokens = formula.split(' ');
        IQueue tokens = m_queueFactory.getNewInstance();

        for(String t: formulaTokens) {
            while (t.contains('(') || t.contains(')')) {
                tokens.enqueue(t.substring(0, 1).trim());
                t = t.substring(1);
            }
            if (String.isNotBlank(t)) {
                tokens.enqueue(t.trim());
            }
        }

        IQueue outputQueue = m_queueFactory.getNewInstance();
        IStack operatorStack  = m_stackFactory.getNewInstance();

        while (!tokens.isEmpty()) {
            String token = String.valueOf(tokens.dequeue());
            if (isOperator(token)) {
                if (token == ')' || token.toLowerCase() == 'or') {
                    while (!operatorStack.isEmpty() && operatorStack.peek() != '(') {
                        outputQueue.enqueue(operatorStack.pop());
                    }
                    if (token.toLowerCase() == 'or') {
                        operatorStack.push(token);
                    } else {
                        operatorStack.pop();
                    }
                }else if(token.toLowerCase() == 'not'){
                    String tokenResult = (String)tokens.dequeue();
                    Boolean tokenResultBoolean = Boolean.valueof(tokenResult);
                    token = String.valueOf(!tokenResultBoolean);
                    outputQueue.enqueue(token);
                } else {
                    operatorStack.push(token);
                }
            } else {
                outputQueue.enqueue(token);
            }
        }


        while (!operatorStack.isEmpty()) {
            outputQueue.enqueue(operatorStack.pop());
        }

        List<String> postFix = new List<String>();
        
        while (!outputQueue.isEmpty()) {
            postFix.add(String.valueOf(outputQueue.dequeue()));
        }

        return postFix;
    }

    private Boolean isOperator(String o) {
        String lowerO = o.toLowerCase();
        if (lowerO == 'and' || lowerO == 'or' || lowerO == 'not' || lowerO == '(' || lowerO == ')') {
            return true;
        }
        return false;
    }

    private Boolean VerifyTwoOperands(Boolean op1, Boolean op2, String operation) {
        if (operation.toLowerCase() == 'and') {
            return op1 == op2;
        }
        return op1 || op2;
    }
}