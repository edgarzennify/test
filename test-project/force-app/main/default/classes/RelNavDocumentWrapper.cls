public class RelNavDocumentWrapper implements Documents.IRelNavDocument {

	public void SaveList(List<RelNavDocument> oList, String listKey){
		RelNavDocument.SaveList(oList, listKey);
	}

	public List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection){
		return RelNavDocument.LoadList(listKey, sortByProperty, sortByDirection);
	}

	public List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions){
		return RelNavDocument.LoadList(listKey, sortByProperty, sortByDirection, pageSize, pageNumber, conditions);
	}

	public List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, RelNavDocument.RelNavDocumentFilter filter){
		return RelNavDocument.LoadList(listKey, sortByProperty, sortByDirection, pageSize, pageNumber, filter);
	}
}