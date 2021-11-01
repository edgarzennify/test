public with sharing class Entity360VmBuilder implements Entity360.IEntity360VmBuilder 
{
    private final List<Entity360.IEntity360VmDisplayCalc> m_displayCalcs;

    public Entity360VmBuilder(List<Entity360.IEntity360VmDisplayCalc> displayCalcs)
    {
        m_displayCalcs = displayCalcs;
    }

    public List<Entity360.EntityViewModel> buildEntityVms(List<DmEntity> entityDms){
        List<Entity360.EntityViewModel> entityVms = new List<Entity360.EntityViewModel>();
        for(DmEntity entityDm : entityDms)
        {
            entityVms.add(buildEntityVm(entityDm));
        }
        return entityVms;
    }
    
    public Entity360.EntityViewModel buildAggregateEntityVm(List<DmEntity> entityDms)
    {
        Entity360.EntityViewModel entityVm = new Entity360.EntityViewModel();
        entityVm.EntityId = entityDms[0].primaryRelationship.id;  
        entityVm.EntityName = entityDms[0].primaryRelationship.name;  
        entityVm.Elements = buildAggregateElements(entityDms);
        
        Decimal aggregateCm = GetAggregateCm(entityDms);
        Entity360.ElementViewModel cmElement = buildCmElement(aggregateCm);
        entityVm.Elements.Add(cmElement);
             
        Entity360.ElementViewModel roeElement = buildRoeElement(entityDms[0]);
        entityVm.Elements.Add(roeElement);

        return entityVm;
    }
	
    private Entity360.EntityViewModel buildEntityVm(DmEntity entityDm){
        Entity360.EntityViewModel entityVm = new Entity360.EntityViewModel();
        entityVm.EntityId = entityDm.id;
        entityVm.EntityName = entityDm.name;
        List<Entity360.ElementViewModel> elements = new List<Entity360.ElementViewModel>();
        if(entityDm.productOverviews != null){
            for(DmProductOverview productOverview : entityDm.productOverviews)
            {
                elements.add(buildProductElement(productOverview.type, productOverview.existingValue, productOverview.opportunityValue, productOverview.opportunityProbability));
            }
        }   

        elements.add(buildCmElement(entityDm.cm));

        entityVm.Elements = elements;
        return entityVm;
    }
    
    private List<Entity360.ElementViewModel> buildAggregateElements(List<DmEntity> entityDms)
    {
        List<Entity360.ElementViewModel> elements = new List<Entity360.ElementViewModel>();
        for(Entity360.ElementType type : productTypes(entityDms))
        {
            elements.Add(buildAggregateProductOverview(entityDms, type));
        }
        return elements;
    }
    
    private Entity360.ElementViewModel buildAggregateProductOverview(List<DmEntity> entityDms, Entity360.ElementType type){
        Decimal aggregateExistingValue = 0.0;
        Decimal aggregateOpportunityValue = 0.0;
        Decimal aggregateOpportunityProbability = 0.0;
        Decimal aggregateWeightedOpportunityValue = 0.0;    
        Entity360.EntityViewModel aggregateLoanEntityVm = new Entity360.EntityViewModel();
          
        for(DmEntity dm : entityDms)
        {          
           for(DmProductOverview ovw : dm.productOverviews)
           {
               if(ovw.type == type)
               {
                   aggregateExistingValue += ovw.existingValue;
                   aggregateOpportunityValue += ovw.opportunityValue;
                   aggregateWeightedOpportunityValue += ovw.opportunityValue * ovw.opportunityProbability;               
               }        
           }         
        }
        
        if(aggregateOpportunityValue != 0) aggregateOpportunityProbability = (aggregateWeightedOpportunityValue / aggregateOpportunityValue).setScale(2, RoundingMode.HALF_UP);
        
        return buildProductElement(type, aggregateExistingValue, aggregateOpportunityValue, aggregateOpportunityProbability);     
    }
    
    private Entity360.ElementViewModel  buildProductElement(Entity360.ElementType type, Decimal existingValue, Decimal opportunityValue, Decimal opportunityProbability){
        Entity360.ElementViewModel element = new Entity360.ElementViewModel();
        Entity360.IEntity360VmDisplayCalc display = displayLocator(type);
        element.elementSymbol = display.GetSymbol();
        element.elementType = display.GetElementType(existingValue, opportunityValue);
        element.elementSummary = display.GetElementSummary();
        element.existingValue = display.GetDisplayValue(existingValue);
        element.existingPercent = display.GetDisplayPercent(display.CalculatePercent(existingValue, opportunityValue));
        element.existingSummary = display.GetExistingSummary(existingValue);
        element.opportunityValue = display.GetDisplayValue(opportunityValue);
        element.opportunityPercent = display.GetDisplayPercent(display.CalculatePercent(opportunityValue, existingValue));
        element.opportunityProbability = display.GetDisplayPercent(opportunityProbability);
        element.opportunitySummary = display.GetOpportunitySummary(opportunityValue, opportunityProbability);
                
        return element;
    }
    
    private Entity360.ElementViewModel buildRoeElement(DmEntity entityDm){
        Entity360.ElementViewModel roe = new Entity360.ElementViewModel();
        Entity360.IEntity360VmDisplayCalc display = displayLocator(Entity360.ElementType.ROE);     
        roe.elementSymbol = display.GetSymbol();
        roe.elementType = 'roe';
        roe.existingValue = display.GetDisplayValue(entityDm.roe);
        roe.existingSummary = display.GetElementSummary();
        roe.existingPercent = '100';
        roe.opportunityPercent = '0';
        roe.opportunityValue = '0';
        roe.opportunityProbability = '0';
        return roe;
    }

    private Entity360.ElementViewModel buildCmElement(Decimal aggregateCm){
        Entity360.ElementViewModel cm = new Entity360.ElementViewModel();
        Entity360.IEntity360VmDisplayCalc display = displayLocator(Entity360.ElementType.CM);     
        cm.elementSymbol = display.GetSymbol();
        cm.elementType = 'cm';
        cm.existingValue = display.GetDisplayValue(aggregateCm);
        cm.existingSummary = display.GetElementSummary();
        cm.existingPercent = '100';
        cm.opportunityPercent = '0';
        cm.opportunityValue = '0';
        cm.opportunityProbability = '0';
        return cm;
    }
    
    private Decimal GetAggregateCm(List<DmEntity> entities)
    {
        Decimal aggregateCm = 0.0;
        for(DmEntity dm : entities)
        {
            
            aggregateCm += dm.cm;
        }
        return aggregateCm ;
    }

    private Entity360.IEntity360VmDisplayCalc displayLocator(Entity360.ElementType type)
    {
        for(Entity360.IEntity360VmDisplayCalc calc : m_displayCalcs)
        {
            if(calc.IsType(type)){return calc;}
        }
        Throw New MissingDisplayCalcException();
    }

    private List<Entity360.ElementType> productTypes(List<DmEntity> entityDms)
    {
        Set<Entity360.ElementType> productSet = new Set<Entity360.ElementType>();
        List<Entity360.ElementType> products = new List<Entity360.ElementType>();
        for(DmEntity e : entityDms)
        {
            for(DmProductOverview p : e.ProductOverviews)
            {
                if(!productSet.contains(p.type))
                {
                    products.add(p.type);
                    productSet.add(p.type);
                }
            }
        }
        return products;
    }

    private class MissingDisplayCalcException extends Exception{}

}