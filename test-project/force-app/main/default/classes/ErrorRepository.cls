global class ErrorRepository implements IErrorRepository{
	public interface IErrorRepository {
        void addWarning(String warning);
        void addError(String error);
        void addErrors(List<String> errors);
        void addInfo(String info);
        void resetErrors();
        void resetWarnings();
        ErrorDetails get();
        List<String> getErrors();
        List<String> getUniqueErrors();
        List<String> getWarnings();
	}
    
    private ErrorDetails m_errors;
    
    public ErrorRepository() {
        init();
    }
    
    private void init() {
        m_errors = new ErrorDetails();
        m_errors.Errors = new List<String>();
        m_errors.Warnings = new List<String>();
        m_errors.Infos = new List<String>();
    }
    
    public void addWarning(String warning) {
        m_errors.Warnings.add(warning);
    }
    public void addError(String error) {
        m_errors.Errors.add(error);
    }
    public void addErrors(List<String> errors) {
        m_errors.Errors.addAll(errors);
    }
    public void addInfo(String info) {
        m_errors.Infos.add(info);
    }
    public void resetErrors() {
        m_errors.Errors.clear();
    }
    public void resetWarnings() {
        m_errors.Warnings.clear();
    }
    public ErrorDetails get() {
        return m_errors;
    }
    public List<String> getErrors() {
        return get() == null? new List<String>() :  get().Errors;
    }
    public List<String> getWarnings(){
        return get() == null? new List<String>() :  get().Warnings;
    }
    public List<String> getUniqueErrors() {
        Set<String> errorSet = new Set<String>();
        List<String> errors = new List<String>();
        errorSet.addAll(get().Errors);
        errors.addAll(errorSet);
        return errors;
    }
    
    global class ErrorDetails {
        public List<String> Errors {get;set;}
        public List<String> Infos {get;set;}
        public List<String> Warnings {get;set;}
    }
}