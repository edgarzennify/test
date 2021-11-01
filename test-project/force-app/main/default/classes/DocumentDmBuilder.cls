public class DocumentDmBuilder implements Documents.IDocumentDmBuilder{
     public DmDocument build(Document pm){
        if(pm == null) return null;
        DmDocument dm = new DmDocument();
        dm.Id = pm.Id;
        dm.Name = pm.Name;
        dm.LastModifiedDate = pm.LastModifiedDate;
        dm.Body = pm.Body;
        dm.ContentType = pm.ContentType;
        dm.Type = pm.Type;
        dm.Description = pm.Description;
        dm.Keywords = pm.Keywords;
        return dm;
     }
     public Document build(DmDocument dm){
        if(dm == null) return null;
        Document pm = new Document();
        pm.Id = dm.Id;
        pm.AuthorId = dm.AuthorId;
        pm.Name = dm.Name;
        pm.IsInternalUseOnly = dm.IsInternalUseOnly;
        pm.Body = dm.Body;
        pm.ContentType = dm.ContentType;
        pm.Type = dm.Type;
        pm.Description = dm.Description;
        pm.Keywords = dm.Keywords;
        return pm;
     }
}