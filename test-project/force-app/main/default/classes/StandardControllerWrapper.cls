public class StandardControllerWrapper implements IStandardController {
    private ApexPages.StandardController m_controller;

    public StandardControllerWrapper(ApexPages.StandardController controller){
        m_controller = controller;
    }

    public SObject getRecord(){
        return m_controller.getRecord();
    }

    public String getId(){
        return m_controller.getId();
    }
}