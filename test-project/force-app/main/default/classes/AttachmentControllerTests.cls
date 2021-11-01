@IsTest
private class AttachmentControllerTests {
	private static final Mock.ofIConfigurations mockConfigs;
    private static final Mock.ofIAttachmentHandler mockAttachmentHandler;
    private static AttachmentController sut;
    
    static {
        mockConfigs = new Mock.ofIConfigurations();
        mockAttachmentHandler = new Mock.ofIAttachmentHandler();
        sut = new AttachmentController(mockAttachmentHandler, mockConfigs);
    }
    
    @IsTest
    static void it_should_call_the_attachment_handler() {
        Id accountId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Attachment a = new Attachment();
        List<Attachment> attachments = new List<Attachment>{a};
        mockAttachmentHandler.setup('getAllAttachmentsForParent', new List<object>{accountId}).returns(attachments);
        sut.parentId = accountId;
        List<Attachment> result = sut.attachments;
        
        mockAttachmentHandler.verify('getAllAttachmentsForParent', new List<object>{accountId}, Times.Once);
    }
    
    @IsTest
    static void it_should_call_the_attachment_handler_with_max_attachment_param() {
        string maxAttachment = '2';
        Integer maxAttachmentInt = 2;
        string maxAttachmentKey = 'PricingWkstMaxAttachments';
        Id accountId = ObjectFactory.getFakeId(Account.SObjectType, '1');
        Attachment a = new Attachment();
        List<Attachment> attachments = new List<Attachment>{a};
        mockConfigs.setup('Get', new List<Object>{maxAttachmentKey}).returns(maxAttachment);
        mockAttachmentHandler.setup('getAttachmentsForParent', new List<object>{accountId, maxAttachmentInt}).returns(attachments);
        
        sut.parentId = accountId;
        List<Attachment> result = sut.attachmentsMaxLimited;
        
        mockAttachmentHandler.verify('getAttachmentsForParent', new List<object>{accountId, maxAttachmentInt}, Times.Once);
    }
}