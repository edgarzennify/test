public class EventRegistrationVmBuilder implements EventRegistration.IVmBuilder {
    
    private final String OPTION_ALL = 'All';
    private final String OPTION_ALL_LABEL = 'All Enterprise Regions';
    private final String OPTION_ALL_LABEL_ALL_TRACK = 'All tracks';

    private final EventRegistration.IVmBuilderHelper m_helper;

    public EventRegistrationVmBuilder(EventRegistration.IVmBuilderHelper helper) {
        m_helper = helper;
    }
    
    public EventRegistration.FormVm build(EventRegistration.VmBuilderParams p) {        
        EventRegistration.FormVm vm = new EventRegistration.FormVm();
        vm.Attendee = m_helper.buildAttendee(p.attendance.attendee, p.lastName, p.email);
        vm.Locations = buildLocations(p.allClasses);
        vm.Industries = m_helper.buildIndustries(p.industries);
        vm.HowDidYouHear = m_helper.buildPickList(p.ebtAwareness);
        vm.YearInSchool = m_helper.buildPickList(p.YearInSchool);
        vm.Classes = buildClasses(p.attendance.classes, p.allClasses, p.instructorDocuments); 
        vm.ClassesGroupedByCategory = buildClassesByCategory(vm.Classes);
        vm.LoginExists = findIfAnyClassIsRegistered(vm.Classes);
        return vm;
    }

    public EventRegistration.EventInstructor buildInstructorVm(DmEventInstructor dm, Map<String, DmDocument> docs) {
        return m_helper.buildInstructor(dm, docs);
    }

    private List<EventRegistration.EventClassVm> buildClasses(List<DmEventClass> selected, List<DmEventClass> all, Map<String, DmDocument> docs) {
        Set<Id> selectedSessions = new Set<Id>();
        for(DmEventClass cls : selected) {
            for(DmEventSession s : cls.sessions) {
                    selectedSessions.add(s.id);
            }
        }
        
        List<EventRegistration.EventClassVm> vms = new List<EventRegistration.EventClassVm>();
        for(DmEventClass cls : all) {
            for(DmEventSession sdm : cls.sessions) {
                Boolean isSelected = selectedSessions.contains(sdm.id);
                if (sdm.capacity != 0) {
                    vms.add(m_helper.buildSession(sdm, cls, isSelected, docs));
                }
            }
        }
        
        for(DmEventClass cls : all) {
            for(DmEventSession sdm : cls.sessions) {
                Boolean isSelected = selectedSessions.contains(sdm.id);
                if (sdm.capacity == 0) {
                    vms.add(m_helper.buildSession(sdm, cls, isSelected, docs));
                }
            }
        }
        return vms;
    }
    
    private List<EventRegistration.EventClassByCategoryVm> buildClassesByCategory(List<EventRegistration.EventClassVm> classVms) {
    	Map<String , List<EventRegistration.EventClassVm>> grouped = new Map<String , List<EventRegistration.EventClassVm>>();
    	List<EventRegistration.EventClassByCategoryVm> groupedItems = new List<EventRegistration.EventClassByCategoryVm>();
    	grouped.put(OPTION_ALL, new List<EventRegistration.EventClassVm>());

    	for(EventRegistration.EventClassVm vm : classVms) {
    		String lookup = vm.SelectedClass.Category;
    		if(!grouped.containsKey(lookup)) {
    			grouped.put(lookup, new List<EventRegistration.EventClassVm>());
    		}

    		grouped.get(lookup).add(vm);
    		grouped.get(OPTION_ALL).add(vm);
    	}

    	for(String key : grouped.keySet()) {
    		EventRegistration.EventClassByCategoryVm c = new EventRegistration.EventClassByCategoryVm();
    		c.categoryName = key;
    		c.classes = grouped.get(key);
    		groupedItems.add(c);
    	}
        
		if(groupedItems != null){groupedItems.sort();}
    	return groupedItems;
    }

    private Boolean findIfAnyClassIsRegistered(List<EventRegistration.EventClassVm> classVms) {
        Boolean isAnyRegistration = false;
        for(EventRegistration.EventClassVm vm : classVms) {
            if(vm.Selected) {
                isAnyRegistration = true;
            }
        }

        return isAnyRegistration;
    }

    private List<EventRegistration.PickList> buildLocations(List<DmEventClass> classDms) {
        Map<String, EventRegistration.PickList> locations = new Map<String, EventRegistration.PickList>();
        locations.put(OPTION_ALL, m_helper.buildPickList(OPTION_ALL_LABEL, OPTION_ALL));
        for(DmEventClass dm : classDms) {
            for(DmEventSession s : dm.sessions) {
                locations.put(s.region, m_helper.buildPickList(s.region, s.region));
            }
        }

        return locations.values();
    }
}