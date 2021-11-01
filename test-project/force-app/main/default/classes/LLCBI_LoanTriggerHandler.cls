public with sharing class LLCBI_LoanTriggerHandler extends TriggerHandler {
    
    public interface ILLCBI_LoanTriggerHandlerDataProvider extends DataProvider.IDataProvider { 
		List<LLC_BI__Loan_Collateral2__c> getPledges(List<LLC_BI__Loan__c> loans);
        List<Conditions__c> getAllRelatedConditions(Set<Id> packageIds);
        List<Account> gatherRelatedEntities(Set<Id> entityIds);
    }
    
    public interface ILLCBI_LoanTriggerHandlerHelper {
        Set<Id> gatherPackageIds(List<SObject> sos);
        Map<Id, List<Conditions__c>> mapConditions(List<Conditions__c> allRelatedConditions);
        Set<Id> gatherEntityIds(List<SObject> sos);
        Map<Id, Account> mapEntities(List<Account> relatedEntities);
        List<Account> gatherEntitiesToUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap, List<Account> relatedEntities);
    }

    private String OBJECT_NAME = 'LLC_BI__Loan__c';
	private String SUBSTAGE_UNKNOWN = 'Substage Unknown';
	private String APPLICATION = 'Loan Substage Calculator';
	private String INFO_LOCATION_DETAILS = 'Unable to find Substage for given loan';
	private String DEBUG_LOCATION_DETAILS = 'Loan Trigger Handler Debugging';
	private String LOG_LEVEL_INFO = 'info';
	private String LOG_LEVEL_DEBUG = 'debug';
    private String STAGE_LOGGING = 'Stage Logging';
    private String BOOKED_STAGE = 'Booked';
    private String COMPLETE_STAGE = 'Complete';
    private String CLOSED_STAGE = 'Closed';
    private Map<Id, Account> relatedEntityMap;

	private final ILLCBI_LoanTriggerHandlerDataProvider m_dataProvider;
	private final LMS_LoanMetricSubstage.ILMS_SubstageCalculator m_subStageCalculator;
	private final ObjectActionLogService.IObjectActionLogService m_substageLogger;
	private final EventLogWriter.IEventLogWriter m_eventLogWriter;
    private final ILLCBI_LoanTriggerHandlerHelper m_helper;
    private final LoanDefaultAppFieldCalculator.ILoanDefaultAppFieldCalculator m_defaultAppFieldCalculator;
    private final ClosingDisclosureFieldCalculator.IClosingDisclosureFieldCalculator m_closingDisclosureFieldCalculator;
    private final CheckbackDateFieldCalculator.ICheckbackDateFieldCalculator m_checkbackDateFieldCalculator;
    private final HasRealEstateColFieldCalculator.IHasRealEstateColFieldCalculator m_hasRealEstateColFieldCalculator;
    private final PolicyExceptionsFieldCalculator.IPolicyExceptionsFieldCalculator m_policyExceptionsFieldCalculator;
    private final MoreLoanObjectFactory.IMoreLoanObjectFactory m_moreLoanObjectFactory;
    private final LLCBI_ProductPackageObjectFactory.IProductPackageFactory m_productPackageObjectFactory;

	public LLCBI_LoanTriggerHandler() {
		m_dataProvider = new LLCBI_LoanTriggerHandlerDataProvider();
		m_subStageCalculator = LMS_SubstageCalculator.bootstrap();
		m_substageLogger = ObjectActionLogService.bootstrap();
        m_eventLogWriter = EventLogWriter.bootstrap();
        m_helper = new LLCBI_LoanTriggerHandlerHelper();
        m_defaultAppFieldCalculator = new LoanDefaultAppFieldCalculator();
        m_closingDisclosureFieldCalculator = new ClosingDisclosureFieldCalculator();
        m_checkbackDateFieldCalculator = new CheckbackDateFieldCalculator(new SystemWrapper());
        m_hasRealEstateColFieldCalculator = new HasRealEstateColFieldCalculator();
        m_policyExceptionsFieldCalculator = new PolicyExceptionsFieldCalculator();
        m_moreLoanObjectFactory = new MoreLoanObjectFactory();
        m_productPackageObjectFactory = new LLCBI_ProductPackageObjectFactory();
	}

	public LLCBI_LoanTriggerHandler(ILLCBI_LoanTriggerHandlerDataProvider dataProvider
			,LMS_LoanMetricSubstage.ILMS_SubstageCalculator subStageCalculator
			,ObjectActionLogService.IObjectActionLogService substageLogger
			,EventLogWriter.IEventLogWriter eventLogWriter
            ,ILLCBI_LoanTriggerHandlerHelper helper
            ,LoanDefaultAppFieldCalculator.ILoanDefaultAppFieldCalculator defaultAppCalculator
            ,ClosingDisclosureFieldCalculator.IClosingDisclosureFieldCalculator closingDisclosureFieldCalculator
            ,CheckbackDateFieldCalculator.ICheckbackDateFieldCalculator checkbackDateFieldCalculator
            ,HasRealEstateColFieldCalculator.IHasRealEstateColFieldCalculator hasRealEstateColFieldCalculator
            ,PolicyExceptionsFieldCalculator.IPolicyExceptionsFieldCalculator policyExceptionsFieldCalculator
            ,MoreLoanObjectFactory.IMoreLoanObjectFactory moreLoanObjectFactory
            ,LLCBI_ProductPackageObjectFactory.IProductPackageFactory productPackageFactory) {
		
		m_dataProvider = dataProvider;
		m_subStageCalculator = subStageCalculator;
		m_substageLogger = substageLogger;
		m_eventLogWriter = eventLogWriter;
        m_helper = helper;
        m_defaultAppFieldCalculator = defaultAppCalculator;
        m_closingDisclosureFieldCalculator = closingDisclosureFieldCalculator;
        m_checkbackDateFieldCalculator = checkbackDateFieldCalculator;
        m_hasRealEstateColFieldCalculator = hasRealEstateColFieldCalculator;
        m_policyExceptionsFieldCalculator = policyExceptionsFieldCalculator;
        m_moreLoanObjectFactory = moreLoanObjectFactory;
        m_productPackageObjectFactory = productPackageFactory;        
	}

	public override void bulkBeforeInsert(List<SObject> sos) {
        m_defaultAppFieldCalculator.calculate(sos);
        m_closingDisclosureFieldCalculator.calculate(sos);
        m_checkbackDateFieldCalculator.calculate(sos);
        defaultSBAPaycheckProtectionPlanFields(sos);
        handlePPPCRAFields(sos);
		updateLoanSubStage(sos);
	}

	public override void bulkAfterInsert(List<SObject> sos) {		
        List<SObject> objects = new List<SObject>();
        List<SObject> takedownConditions = handleTakedownConditions(sos);
        if(takedownConditions != null && takedownConditions.size() > 0) {
            objects.AddAll(takedownConditions);
        }
        objects.addAll(m_moreLoanObjectFactory.create(sos));
        objects.addAll(recordInitialLoanSubstage(sos));
        objects.addAll(recordEventLogs(sos));
        m_dataProvider.save(objects);
	}

	public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
		List<LLC_BI__Loan_Collateral2__c> pledges = m_dataProvider.getPledges(newSosMap.values());

        m_hasRealEstateColFieldCalculator.calculate(newSosMap.values(), pledges);
        m_defaultAppFieldCalculator.calculate(newSosMap.values());
        m_policyExceptionsFieldCalculator.calculate(newSosMap.values()); 
        m_closingDisclosureFieldCalculator.calculate(newSosMap.values());
        m_checkbackDateFieldCalculator.calculate(oldSos, newSosMap);
        updateLoanSubStage(newSosMap.values());

        List<SObject> objects = new List<SObject>();
        List<Account> entitiesToUpdate = handleGrossAnnualRevenueOnRelatedEntites(oldSos, newSosMap);
        if(entitiesToUpdate != null && entitiesToUpdate.size() > 0) {
            objects.addAll((List<SObject>)entitiesToUpdate);
        }
        m_dataProvider.save(objects);
	}

	public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
        List<SObject> objects = new List<SObject>();
        List<LLC_BI__Product_Package__c> packagesToUpdate = m_productPackageObjectFactory.updatePackages(oldSos, newSosMap);
        if(packagesToUpdate != null && packagesToUpdate.size() > 0){
            objects.addAll(packagesToUpdate);
        }
		objects.addAll(recordSubstageChanges(oldSos,newSosMap));
		objects.addAll(recordEventLogs(newSosMap.values()));
		m_dataProvider.save(objects);
    }
	
    private List<SObject> recordInitialLoanSubstage(List<SObject> sos) {
        for (LLC_BI__Loan__c ln : (List<LLC_BI__Loan__c>)sos) {
            m_substageLogger.log(OBJECT_NAME, ln.Id, STAGE_LOGGING, ln.Loan_Metric_Substage__c);
        }
        return m_substageLogger.getCachedLogs();
    }

	private List<SObject> recordSubstageChanges(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
        for (LLC_BI__Loan__c vOld : (List<LLC_BI__Loan__c>)oldSos) {
            LLC_BI__Loan__c vNew = (LLC_BI__Loan__c)newSosMap.get(vOld.Id);
            if (String.isNotBlank(vNew.Loan_Metric_Substage__c)) {
                if (vOld.Loan_Metric_Substage__c != null && vNew != null && vNew.Loan_Metric_Substage__c != vOld.Loan_Metric_Substage__c) {
                    m_substageLogger.log(OBJECT_NAME, vNew.Id, STAGE_LOGGING, vNew.Loan_Metric_Substage__c);
                }
            }
        }
        return m_substageLogger.getCachedLogs();
    }

	private List<SObject> recordEventLogs(List<SObject> sos) {
		List<SObject> eventLogs = new List<SObject>();
		for (LLC_BI__Loan__c ln : (List<LLC_BI__Loan__c>)sos) {
			if (ln.Loan_Metric_Substage__c == SUBSTAGE_UNKNOWN) {
				EventLog__c eLog = m_eventLogWriter.createLog(LOG_LEVEL_INFO, APPLICATION, String.ValueOf(ln), INFO_LOCATION_DETAILS);
				if (eLog != null) {
					eventLogs.add(eLog);
				}
			} else {
				EventLog__c eLog = m_eventLogWriter.createLog(LOG_LEVEL_DEBUG, APPLICATION, String.ValueOf(ln), DEBUG_LOCATION_DETAILS);
				if (eLog != null) {
					eventLogs.add(eLog);
				}
			}
        }
		return eventLogs;
	}

	private List<LLC_BI__Loan__c> updateLoanSubStage(List<LLC_BI__Loan__c> loans) {
		List<LLC_BI__Loan__c> updatedLoans = new List<LLC_BI__Loan__c>();		
		for (LLC_BI__Loan__c ln : loans) {
			String substage = m_subStageCalculator.calculateSubstage(ln);			
			if (ln.Loan_Metric_Substage__c != substage) {
				ln.Loan_Metric_Substage__c = substage;
				updatedLoans.add(ln);
			}
		}
		return updatedLoans;
	}

    private void defaultSBAPaycheckProtectionPlanFields(List<LLC_BI__Loan__c> loans) {
        for (LLC_BI__Loan__c l : loans) {
            if (l.Niche_Products_fx__c == 'SBA Paycheck Protection Program') {
                setFieldDefaults(l);
            }
        }
    }

    private void setFieldDefaults(LLC_BI__Loan__c loan) {
        loan.Attorney_Docs__c = 'N/A - Internal';
        loan.Is_Loan_to_Gov_t_Related_Entity__c = 'No';
        loan.Is_Loan_to_Financial_Institution__c = 'No';
        loan.Use_of_Funds_Purpose__c = 'Working Capital';
        loan.Is_Repayment_Reliant_on_Ag_Income__c = 'No';
        loan.Financial_Institution_Accept_Deposits__c = 'No';
        loan.Policy_Exceptions__c = 'N/A';
        loan.LLC_BI__Risk_Grade__c = '02';
        loan.Lending_Strategy__c = '2 - Maintain';
        loan.Application_Date__c = system.today();
        loan.Close_Date__c = system.today() + 2;
        loan.Provide_Documents_By__c = system.today() +2;
        loan.Projected_Funding_Date__c = system.today() + 2;
        loan.Immediate_Funding__c = true;
        loan.Centralized_Disbursing__c = 'No';
        loan.LLC_BI__Pricing_Basis__c = 'Fixed';
        loan.LLC_BI__Payment_Type__c = 'Installment';
    }

    private List<SObject> handleTakedownConditions(List<SObject> sos) {
        List<SObject> conditionsToCreate = new List<SObject>();
        List<Conditions__c> relatedConditions = new List<Conditions__c>();
        if (listContainsTakedown(sos)) {
            Set<Id> packageIds = m_helper.gatherPackageIds(sos);
            List<Conditions__c> allRelatedConditions = m_dataProvider.getAllRelatedConditions(packageIds);
            Map<Id, List<Conditions__c>> mappedConditions = m_helper.mapConditions(allRelatedConditions);
            for (LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)sos) {
                if (loanIsTakedown(loan) && loanStageIsNotBooked(loan)) {
                    if (mappedConditions != null && mappedConditions.containsKey(loan.LLC_BI__Product_Package__c)) {
                        relatedConditions = mappedConditions.get(loan.LLC_BI__Product_Package__c);
                    }
                    if (relatedConditions != null) {
                        for (Conditions__c cond : relatedConditions) {
                            Condition_Relationship__c condRel = new Condition_Relationship__c();
                            condRel.Condition__c = cond.Id;
                            condRel.Funding_Condition__c = cond.Funding_Condition__c;
                            condRel.Loan__c = loan.Id;
                            condRel.Product_Package__c = cond.Product_Package__c;
                            condRel.Status__c = cond.Status__c;
                            conditionsToCreate.add(condRel);
                        }
                    }
                }
            }
        }
        return conditionsToCreate;
    }

    private Boolean loanIsTakedown(LLC_BI__Loan__c loan) {
        return loan.LLC_BI__Structure_Hierarchy__c == 'Current Takedown';
    }

    private Boolean listContainsTakedown(List<LLC_BI__Loan__c> sos) {
        Boolean answer = false;
        for (LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)sos) {
            if (loanIsTakedown(loan)) {
                answer = true;
                break;
            }
        }
        return answer;
    }

    private List<Account> handleGrossAnnualRevenueOnRelatedEntites(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
        Set<Id> entityIds = m_helper.gatherEntityIds(newSosMap.values());
        List<Account> relatedEntities = m_dataProvider.gatherRelatedEntities(entityIds);
        List<Account> updatedEntities = m_helper.gatherEntitiesToUpdate(oldSos, newSosMap, relatedEntities);
        return updatedEntities;
    }

    private Boolean loanStageIsNotBooked(LLC_BI__Loan__c loan) {
        return loan.LLC_BI__Stage__c != BOOKED_STAGE 
            && loan.LLC_BI__Stage__c != COMPLETE_STAGE
            && loan.LLC_BI__Stage__c != CLOSED_STAGE;
    }

    private void handlePPPCRAFields(List<SObject> sos) {
        Set<Id> relatedAccountIds = getRelatedAccountIds(sos);
        List<Account> relatedAccounts = m_dataProvider.gatherRelatedEntities(relatedAccountIds);
        relatedEntityMap = buildRelatedEntityMap(relatedAccounts);
        for (LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)sos) {
            if (CRAFieldsNeedUpdate(loan)) {
                getStateCode(loan);
            }
        }
    }

    private Boolean CRAFieldsNeedUpdate(LLC_BI__Loan__c loan) {
        return loan.LLC_BI__Account__c != null 
            && loan.Niche_Products_fx__c == 'SBA Paycheck Protection Program'
            && loan.LLC_BI__isRenewal__c == false
            && loan.LLC_BI__Is_Modification__c == false;
    }

    private Set<Id> getRelatedAccountIds(List<SObject> sos) {
        Set<Id> returnSet = new Set<Id>();
        for (LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)sos) {
            if (loan.Niche_Products_fx__c == 'SBA Paycheck Protection Program') {
                returnSet.add(loan.LLC_BI__Account__c);
            }
        }
        return returnSet;
    }

    private Map<Id, Account> buildRelatedEntityMap(List<Account> relatedAccounts) {
        Map<Id, Account> returnMap = new Map<Id, Account>();
        if (relatedAccounts != null && relatedAccounts.size() > 0) {
            for (Account a : relatedAccounts) {
                returnMap.put(a.Id, a);
            }
        }
        return returnMap;
    }

    private void getStateCode(LLC_BI__Loan__c loan) {
        Account a = relatedEntityMap.get(loan.LLC_BI__Account__c);
        if (a != null) {
            switch on a.BillingState {
                when 'AL', 'Alabama' {
                    loan.Use_of_Funds_State__c = 'AL';
                }
                when 'AK', 'Alaska' {
                    loan.Use_of_Funds_State__c = 'AK';
                }
                when 'AZ', 'Arizona' {
                    loan.Use_of_Funds_State__c = 'AZ';
                }
                when 'AR', 'Arkansas' {
                    loan.Use_of_Funds_State__c = 'AR';
                }
                when 'CA', 'California' {
                    loan.Use_of_Funds_State__c = 'CA';
                }
                when 'CO', 'Colorado' {
                    loan.Use_of_Funds_State__c = 'CO';
                }
                when 'CT', 'Connecticut' {
                    loan.Use_of_Funds_State__c = 'CT';
                }
                when 'DE', 'Delaware' {
                    loan.Use_of_Funds_State__c = 'DE';
                }
                when 'DC', 'District of Columbia' {
                    loan.Use_of_Funds_State__c = 'DC';
                }
                when 'FL', 'Florida' {
                    loan.Use_of_Funds_State__c = 'FL';
                }
                when 'GA', 'Georgia' {
                    loan.Use_of_Funds_State__c = 'GA';
                }
                when 'HI', 'Hawaii' {
                    loan.Use_of_Funds_State__c = 'HI';
                }
                when 'ID', 'Idaho' {
                    loan.Use_of_Funds_State__c = 'ID';
                }
                when 'IL', 'Illinois' {
                    loan.Use_of_Funds_State__c = 'IL';
                }
                when 'IN', 'Indiana' {
                    loan.Use_of_Funds_State__c = 'IN';
                }
                when 'IA', 'Iowa' {
                    loan.Use_of_Funds_State__c = 'IA';
                }
                when 'KS', 'Kansas' {
                    loan.Use_of_Funds_State__c = 'KS';
                }
                when 'LA', 'Louisiana' {
                    loan.Use_of_Funds_State__c = 'LA';
                }
                when 'ME', 'Maine' {
                    loan.Use_of_Funds_State__c = 'ME';
                }
                when 'MD', 'Maryland' {
                    loan.Use_of_Funds_State__c = 'MD';
                }
                when 'MA', 'Massachusetts' {
                    loan.Use_of_Funds_State__c = 'MA';
                }
                when 'MI', 'Michigan' {
                    loan.Use_of_Funds_State__c = 'MI';
                }
                when 'MN', 'Minnesota' {
                    loan.Use_of_Funds_State__c = 'MN';
                }
                when 'MS', 'Mississippi' {
                    loan.Use_of_Funds_State__c = 'MS';
                }
                when 'MO', 'Missouri' {
                    loan.Use_of_Funds_State__c = 'MO';
                }
                when 'MT', 'Montana' {
                    loan.Use_of_Funds_State__c = 'MT';
                }
                when 'NE', 'Nebraska' {
                    loan.Use_of_Funds_State__c = 'NE';
                }
                when 'NV', 'Nevada' {
                    loan.Use_of_Funds_State__c = 'NV';
                }
                when 'NH', 'New Hampshire' {
                    loan.Use_of_Funds_State__c = 'NH';
                }
                when 'NJ', 'New Jersey' {
                    loan.Use_of_Funds_State__c = 'NJ';
                }
                when 'NM', 'New Mexico' {
                    loan.Use_of_Funds_State__c = 'NM';
                }
                when 'NY', 'New York' {
                    loan.Use_of_Funds_State__c = 'NY';
                }
                when 'NC', 'North Carolina' {
                    loan.Use_of_Funds_State__c = 'NC';
                }
                when 'ND', 'North Dakota' {
                    loan.Use_of_Funds_State__c = 'ND';
                }
                when 'OH', 'Ohio' {
                    loan.Use_of_Funds_State__c = 'OH';
                }
                when 'OK', 'Oklahoma' {
                    loan.Use_of_Funds_State__c = 'OK';
                }
                when 'OR', 'Oregon' {
                    loan.Use_of_Funds_State__c = 'OR';
                }
                when 'PA', 'Pennsylvania' {
                    loan.Use_of_Funds_State__c = 'PA';
                }
                when 'RI', 'Rhode Island' {
                    loan.Use_of_Funds_State__c = 'RI';
                }
                when 'SC', 'South Carolina' {
                    loan.Use_of_Funds_State__c = 'SC';
                }
                when 'SD', 'South Dakota' {
                    loan.Use_of_Funds_State__c = 'SD';
                }
                when 'TN', 'Tennessee' {
                    loan.Use_of_Funds_State__c = 'TN';
                }
                when 'TX', 'Texas' {
                    loan.Use_of_Funds_State__c = 'TX';
                }
                when 'UT', 'Utah' {
                    loan.Use_of_Funds_State__c = 'UT';
                }
                when 'VT', 'Vermont' {
                    loan.Use_of_Funds_State__c = 'VT';
                }
                when 'VA', 'Virginia' {
                    loan.Use_of_Funds_State__c = 'VA';
                }
                when 'WA', 'Washington' {
                    loan.Use_of_Funds_State__c = 'WA';
                }
                when 'WV', 'West Virginia' {
                    loan.Use_of_Funds_State__c = 'WV';
                }
                when 'WI', 'Wisconsin' {
                    loan.Use_of_Funds_State__c = 'WI';
                }
                when 'WY', 'Wyoming' {
                    loan.Use_of_Funds_State__c = 'WY';
                }
            }
        }
    }
}