public with sharing class AttachmentController {

	private final String MAX_ATTACHMENTS_KEY = 'PricingWkstMaxAttachments';
	public String parentId {get; set;}
	public Boolean refreshAttachments {get;set;}

	private List<Attachment> m_attachments; 

	private AttachmentHandler.IAttachmentHandler m_attachmentHandler;
	private Configurations.IConfigurations m_configs;

	public AttachmentController(AttachmentHandler.IAttachmentHandler attachmentHandler, Configurations.IConfigurations configs) {
		m_attachmentHandler = attachmentHandler;
		m_configs = configs;
	}	

	public AttachmentController() {
		m_attachmentHandler = new AttachmentHandler();
		m_configs = Configurations.bootstrap();
	}

	public List<Attachment> attachments {
		get{
			if(m_attachments == null || refreshAttachments){
				m_attachments = m_attachmentHandler.getAllAttachmentsForParent(parentId);
			}
			return m_attachments;
		} 
		set;
	}

	public List<Attachment> attachmentsMaxLimited {
		get{
			if(m_attachments == null || refreshAttachments){
				String attachmentCount = m_configs.Get(MAX_ATTACHMENTS_KEY);
				Integer maxAttachments = Integer.valueof(attachmentCount);
				m_attachments = m_attachmentHandler.getAttachmentsForParent(parentId, maxAttachments);
			}
			return m_attachments;
		} 
		set;
	}
}