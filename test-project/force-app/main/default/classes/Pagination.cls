public class Pagination{
	public Integer pageSize = 4;
		
	public Integer ObjectListSize {
  		get;
  		set{
  			ObjectListSize = value;
  			RefreshPagesList();
  		}		
	}  
  
  	public List<SelectOption> pagesList{
	    get{
	    	if(pagesList==null){
	    		RefreshPagesList();
	    	}
	    	return pagesList;
	    }
	    set;
  	}
  
 	 private void RefreshPagesList(){
    	pagesList = new List<SelectOption>();
		for(Integer i=1;i<=totalPages;++i){
			pagesList.add(new Selectoption(String.valueOf(i),String.valueOf(i)));
		}
	}
  
	public Integer totalPages{
  		get{
	  		Integer realPages = Integer.valueOf(Math.ceil(Double.valueOf(ObjectListSize) / Double.valueOf(pageSize)));
	  		if(realPages < 1) return 1;
	  		return realPages;
  		}
	}
  
  public boolean hasPreviousPage{
  	get{
  		if(currentPage > 1)
  			return true;
  		else
  			return false;
  	}
  }
  
  public boolean hasNextPage{
  	get{
  		if(currentPage < totalPages)
  			return true;
  		else
  			return false;
  	}
  }
  
  public string pageNumber{
      get{
          return String.valueOf(pagePosition+1) + ' of ' + String.valueOf(totalPages);
      }
  }
  
  public String currentSelectedPage{get;set;}
  
  public Integer currentPage{
  	get{
  		return pagePosition+1;   
  	}
  }
  
  public Integer pagePosition{
    get{
    	if(pagePosition == null) pagePosition = 0;
        return pagePosition;
    }
    set;
  }
  
  public void SetPage(Integer pageNum){
  	currentSelectedPage = String.valueOf(pageNum);
    pagePosition = pageNum - 1;
  }
}