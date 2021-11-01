public class DatabaseErrorWrapper implements IDatabaseError{
    
    public interface IDatabaseError {
        List<string> getFields();
        String getMessage();
    }
    
    public interface IDatabaseErrorWrapperFactory{
        IDatabaseError create(Database.Error dbError);
    }
    
    public class DatabaseErrorWrapperFactory{
        public IDatabaseError create(Database.Error dbError){
            return new DatabaseErrorWrapper(dbError);
        }
    }
    
    private Database.Error m_dbError;
    
    public DatabaseErrorWrapper(Database.Error dbError){
        m_dbError = dbError;
    }
    
    public List<string> getFields(){
        return m_dbError.getFields();
    }
    
    public String getMessage(){
        return m_dbError.getMessage();
    }

}