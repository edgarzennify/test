public with sharing class AttachmentHandlerDataProv implements AttachmentHandlerDataProv.IAttachmentHandlerDataProv {

    public interface IAttachmentHandlerDataProv {
        void insertAttachment(Attachment attach);
        List<Attachment> getAllAttachmentsForParent(Id parentId);
        List<Attachment> getAllAttachmentsForParents(List<Id> parentIds);
        List<Attachment> getAllAttachmentsForParent(Id parentId, Integer maxAttachments);
    }

    public void insertAttachment(Attachment attach){
        insert attach;
    }

    public List<Attachment> getAllAttachmentsForParent(Id parentId){
        List<Attachment> attachments = new List<Attachment>(
            [
            SELECT Id,
                    ContentType,
                    OwnerId,
                    Parent.Type,
                    Parent.Name,
                    Owner.Name,
                    Name,
                    LastModifiedDate,
                    Body,
                    BodyLength 
            FROM Attachment 
            WHERE ParentId =: parentId
            ORDER BY 
                LastModifiedDate DESC
            ]
        );
        return (attachments != null) ? attachments : new List<Attachment>();
    }

    public List<Attachment> getAllAttachmentsForParent(Id parentId, Integer maxAttachments){
        List<Attachment> attachments = new List<Attachment>(
            [
                SELECT Id,
                        ContentType,
                        OwnerId,
                        Parent.Type,
                        Parent.Name,
                        Owner.Name,
                        Name,
                        LastModifiedDate,
                        BodyLength
                FROM Attachment 
                WHERE ParentId =: parentId
                ORDER BY 
                    LastModifiedDate DESC
                LIMIT : maxAttachments
            ]
        );
        return (attachments != null) ? attachments : new List<Attachment>();
    }

    public List<Attachment> getAllAttachmentsForParents(List<Id> parentIds){
        List<Attachment> attachments = new List<Attachment>(
            [
            SELECT Id,
                    ContentType,
                    OwnerId,
                    Parent.Type,
                    Parent.Name,
                    Owner.Name,
                    Name,
                    LastModifiedDate,
                    Body,
                    BodyLength 
            FROM Attachment 
            WHERE ParentId in: parentIds
            ORDER BY 
                LastModifiedDate DESC
            ]
        );
        return (attachments != null) ? attachments : new List<Attachment>();
    }

}