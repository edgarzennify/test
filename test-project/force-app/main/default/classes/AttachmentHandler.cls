public with sharing class AttachmentHandler implements AttachmentHandler.IAttachmentHandler {

	public interface IAttachmentHandler {
		Id generateAttachmentFromPageRef(PageReference pageRef, String attachmentName, Id parentId);
		List<Attachment> getAllAttachmentsForParent(Id parentId);
		List<Attachment> getAttachmentsForParent(Id parentId, Integer maxAttachment);
		Map<Id, List<Attachment>> getAttachmentsByParents(List<Id> parentIds);
	}

	private AttachmentHandlerDataProv.IAttachmentHandlerDataProv m_dataProv;

	public AttachmentHandler() {
		AttachmentHandlerDataProv dataProv = new AttachmentHandlerDataProv();
		initialize(dataProv);
	}

	public AttachmentHandler(AttachmentHandlerDataProv.IAttachmentHandlerDataProv dataProv){
		initialize(dataProv);
	}

	public void initialize(AttachmentHandlerDataProv.IAttachmentHandlerDataProv dataProv){
		m_dataProv = dataProv;
	}


	public Id generateAttachmentFromPageRef(PageReference pageRef, String attachmentName, Id parentId){
        Blob body;
        try {
            body = pageRef.getContentAsPdf();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Error Generating File');
        }
        Attachment attach = new Attachment();
        attach.Body = body;
        attach.Name = attachmentName;
        attach.IsPrivate = false;
        attach.ParentId = parentId;
        m_dataProv.insertAttachment(attach);
        return attach.Id;
	}

	public List<Attachment> getAllAttachmentsForParent(Id parentId){
		return m_dataProv.getAllAttachmentsForParent(parentId);
	}
	public List<Attachment> getAllAttachmentsForParent(Id parentId, Integer maxAttachments){
		return m_dataProv.getAllAttachmentsForParent(parentId, maxAttachments);
	}
	public List<Attachment> getAttachmentsForParent(Id parentId, Integer maxAttachment){
		return m_dataProv.getAllAttachmentsForParent(parentId, maxAttachment);
	}
	public Map<Id, List<Attachment>> getAttachmentsByParents(List<Id> parentIds) {
        Map<Id, List<Attachment>> attachmentMap = new Map<Id, List<Attachment>>();
        List<Attachment> attachments = m_dataProv.getAllAttachmentsForParents(parentIds);
        if(attachments == null || attachments.size() > 0) { return attachmentMap;}
        
        for(Attachment a : attachments) {
            if(!attachmentMap.containsKey(a.Parent.Id)) {
                attachmentMap.put(a.Parent.Id, new List<Attachment>());
            }
            attachmentMap.get(a.Parent.Id).add(a);
        }

        return attachmentMap;
    }
}