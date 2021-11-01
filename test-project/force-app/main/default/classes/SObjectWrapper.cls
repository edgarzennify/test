public class SObjectWrapper implements ISObject {
    
    public void addError(SObject sobj, String errorMessage) {
        sobj.addError(errorMessage, true);
    }
}