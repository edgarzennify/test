public class SObjectFieldFactory implements ISObjectFieldFactory {
    public interface ISObjectFieldFactory {
        ISObjectField getInstance(Schema.SObjectField fld);
    }
    
    public ISObjectField getInstance(Schema.SObjectField fld) {
        return new SObjectFieldWrapper(fld);
    }
}