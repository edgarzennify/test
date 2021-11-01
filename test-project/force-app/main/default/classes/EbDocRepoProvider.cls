public class EbDocRepoProvider implements IEbDocRepoProvider {
	private final AttachmentHandler.IAttachmentHandler m_attachmentProvider;
    private final IDataProvider m_dataProvider;
    
    public interface IEbDocRepoProvider {
        DmDocument GetFileByEbDocId(Id fileId);
        DmDocument GetFileByEbDocName(string docName);
        Boolean FileExistsByEbDocId(Id fileId);
    }
    
    public interface IDataProvider {
        EBDocRepo__c GetRepoFileByName(string fileName);
        EBDocRepo__c GetRepoFileById(Id fileId);
        List<EBDocRepo__c> GetRepoFilesByNames(List<string> fileNames);
        List<EBDocRepo__c> GetRepoFilesByIds(List<Id> fileIds);
    }
    
    public EbDocRepoProvider(AttachmentHandler.IAttachmentHandler attachmentProvider, IDataProvider dataProvider) {
        m_attachmentProvider = attachmentProvider;
        m_dataProvider = dataProvider;
    }
    
    public DmDocument GetFileByEbDocId(Id fileId) {
        EBDocRepo__c repoFile = m_dataProvider.GetRepoFileById(fileId);
        return getTemplateFromAttachment(repoFile.FileName__c, fileId);
    }

    public DmDocument GetFileByEbDocName(string docName){
        EBDocRepo__c repoFile = m_dataProvider.GetRepoFileByName(docName);
        return getTemplateFromAttachment(repoFile.FileName__c, repoFile.Id);
    }
    
    public boolean FileExistsByEbDocId(Id fileId) {
        EBDocRepo__c repoFile = m_dataProvider.GetRepoFileById(fileId);
        DmDocument d = getTemplateFromAttachment(repoFile.FileName__c, fileId);
        return d.Body.size() > 0;
    }

    public DmDocument getTemplateFromAttachment(String attachmentName, Id fileId) {
        DmDocument d = new DmDocument();
		for(Attachment a : m_attachmentProvider.getAllAttachmentsForParent(fileId)) {
            if (String.isBlank(attachmentName)) {
                d.body = a.Body;
                d.Id = a.Id;
                return d;
            }
			if(a.name == attachmentName) {
                d.name = a.name;
                d.Id = a.Id;
                d.body = a.body;
				return d;
			}
		}
        d.body = Blob.valueOf('');
		return d;
	}

    public Map<Id, List<DmDocument>> getTempatesForFileIds(List<Id> fileIds) {
        Map<Id, List<DmDocument>> documentDms = new Map<Id, List<DmDocument>>();
        Map<Id, List<Attachment>> attachmentMap = m_attachmentProvider.getAttachmentsByParents(fileIds);

        for(Id key : attachmentMap.keySet()) {
            List<Attachment> attachments = attachmentMap.get(key);
            if(attachments != null) {
                for(Attachment a : attachments) {
                    if(!documentDms.containsKey(key)) {
                        documentDms.put(key, new List<DmDocument>());
                    }
                    DmDocument d = new DmDocument();
                    d.name = a.Name;
                    d.id = a.Id;
                    d.Body = a.Body;
                    documentDms.get(key).add(d);
                }
            } 
        }

        return documentDms;
    }
}