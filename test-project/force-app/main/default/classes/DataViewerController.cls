public class DataViewerController {
    public DataViewer.FormVm vm{get;set;}

    public void init(){
        vm = DataViewerBootstrapper.getPresenterInstance().buildFormVm();
    }
}