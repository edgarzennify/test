public class CPDocsVmBuilder implements CPDocs.IVmBuilder{

    private string STATUS_OPEN = 'Open';
    private string CONFIG_CP_DOCUMENT_REQUEST_FILE_TYPES = 'CpDocumentRequestFileTypes';

    private ISystem m_sys;
    private Configurations.IConfigurations m_config;

    public CPDocsVmBuilder(ISystem sys, Configurations.IConfigurations config){
        m_sys = sys;
        m_config = config;
    }

    public List<CPDocs.DocumentRequest> buildVm(List<DmCPDocumentRequest> dms){
        List<CPDocs.DocumentRequest> res = new List<CPDocs.DocumentRequest>();
        if(dms == null || dms.size() == 0) return res;

        for(DmCPDocumentRequest dm : dms){          
            res.add(buildOne(dm));
        }
        return res;
    }
    
    private CPDocs.DocumentRequest buildOne(DmCPDocumentRequest dm){
        String configFileType = m_config.get(CONFIG_CP_DOCUMENT_REQUEST_FILE_TYPES);
        List<string> fileTypes = String.isBlank(configFileType)?new List<string>():configFileType.split(',');
        CPDocs.DocumentRequest vm = new CPDocs.DocumentRequest();
        boolean pastDueDate = dm.DocumentDueDate < m_sys.today();
        string dueDateString = String.valueof(dm.DocumentDueDate);
        vm.documentRequestId = dm.RecordId;
        vm.objectType = dm.ObjectType;
        vm.objectId = dm.ObjectId;
        vm.objectDescription = dm.ObjectDescription;
        vm.documentName = String.isBlank(dm.DocumentPortalName)?dm.DocumentName:dm.DocumentPortalName;
        vm.documentDueDate = dueDateString;
        vm.documentDescription = String.isBlank(dm.DocumentDescription)?'':dm.DocumentDescription;
        vm.status = dm.Status;
        vm.isPastDueDate = pastDueDate;
        vm.documentDueDateLabel = pastDueDate && dm.Status.toLowerCase() == STATUS_OPEN.toLowerCase()
                                    ? String.format('{0} {1}', new List<string>{vm.documentDueDate,'Overdue!'}):dueDateString ;
        vm.fileTypes = fileTypes;
        return vm;
    }
}