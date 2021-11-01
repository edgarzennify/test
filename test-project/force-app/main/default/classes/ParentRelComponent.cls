public with sharing class ParentRelComponent {
	public String renderComponent {get;set;}
    public String pageBlockTitle {get;set;}

    public Id parentId{get;set;}
    public Id childId{get;set;}
    public String relationshipToParent {get;set;}
    public Boolean existingRelationships {get;set;}

    private ParentRelationships.IParentRelTreeBuilder m_parentRelationshipTreeBuilder;


    public ParentRelComponent() {
        m_parentRelationshipTreeBuilder = new ParentRelTreeBuilder(); 
    }

    public ParentRelComponent(ParentRelationships.IParentRelTreeBuilder relationshipbuilder)
    {
        m_parentRelationshipTreeBuilder = relationshipbuilder;
    }
   
    public List<ParentRelationships.RelatedEntity> relationshipTree{
        get
        {
            List<Map<Id, Account>> relTree = new List<Map<Id, Account>>();
            if (existingRelationships){
            	relTree = m_parentRelationshipTreeBuilder.getRelationshipTreeForEntity(childId, false, null);
            }else if(parentId == null){
            	relTree = m_parentRelationshipTreeBuilder.getRelationshipTreeForEntity(childId, true, null);
            }else {
            	relTree = m_parentRelationshipTreeBuilder.addChildToRelationshipTreeOfParent(parentId, childId, relationshipToParent);
            }
            return m_parentRelationshipTreeBuilder.getRelationshipTreeListForDisplay(relTree, childId);
         }
    }
}