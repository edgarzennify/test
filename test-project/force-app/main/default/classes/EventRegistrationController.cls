global class EventRegistrationController {
	private  final IStandardController m_controller;
    private final IJson m_json;

    @RemoteAction //Return string is the attendeeId
    global static String login(string recordJson) {
        try{
            IJson j = new JsonWrapper();
            EventRegistrationRequest req = (EventRegistrationRequest)j.deserialize(recordJson, EventRegistrationRequest.class);       
            EventRegistration.IPresenter presenter = EventRegistrationBootstrapper.getInstanceOfIPresenter();            
            return presenter.getValidLogin(req.lastName, req.email);

        }catch(exception ex){
            throw new EventRegistration.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static EventRegistration.FormVm bootstrap(string attendeeId, string recordJson ) {
        try{
            IJson j = new JsonWrapper();
            EventRegistrationRequest req = (EventRegistrationRequest)j.deserialize(recordJson, EventRegistrationRequest.class);       
            if(req == null || String.isBlank(req.lastName) || String.isBlank(req.Email)) {
                throw new EventRegistration.BootstrapException('Error in request');
            }
            EventRegistration.IPresenter presenter = EventRegistrationBootstrapper.getInstanceOfIPresenter();            
            
            return presenter.getFormVm(attendeeId, req.location);

        }catch(exception ex){
            throw new EventRegistration.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    //@RemoteAction
    //global static EventRegistration.FormVm bootstrap(string recordJson) {
    //    try{
    //        IJson j = new JsonWrapper();
    //        EventRegistrationRequest req = (EventRegistrationRequest)j.deserialize(recordJson, EventRegistrationRequest.class);       
    //        EventRegistration.IPresenter presenter = EventRegistrationBootstrapper.getInstanceOfIPresenter();            
            
    //        return presenter.getFormVm(req.lastName, req.email, req.location);

    //    }catch(exception ex){
    //        throw new EventRegistration.BootstrapException(ex.getMessage());
    //    }  
    //    return null;
    //}

    @RemoteAction
    global static EventRegistration.EventInstructor getInstructor(string recordJson) {
        try{
            IJson j = new JsonWrapper();
            InstructorRequest req = (InstructorRequest)j.deserialize(recordJson, InstructorRequest.class);       
            if(req.RequestType == 'getInstructor'){
     
                EventRegistration.IPresenter presenter = EventRegistrationBootstrapper.getInstanceOfIPresenter();
                EventRegistration.EventInstructor ins = presenter.getInstructor(req.Instructor.Id);
                return ins;
            }
        }catch(exception ex){
            throw new EventRegistration.InstructorException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static EventRegistration.FormVm save(SaveData sd) {
    	if(sd.RequestType == 'save') {
    		EventRegistration.FormVm vm = sd.RequestData;
            EventRegistration.IPresenter presenter = EventRegistrationBootstrapper.getInstanceOfIPresenter();
            presenter.save(sd.RequestData, sd.AttendeeSm); 

            return presenter.getFormVm(vm.attendee.id, sd.Location);
    	}
    	return null;
    }

    global class EventRegistrationRequest {
    	public String LastName {get;set;}
    	public String Email {get;set;}
        public String Location {get;set;}
    }

    global class InstructorRequest {
        public String RequestType {get;set;}
        public InstructorData Instructor{get;set;}
    }

    global class InstructorData {
        public String Id {get;set;}
        public String Name {get;set;}
    }

    global class SaveData {
        public String RequestType {get;set;}
        public String Location {get;set;}
        public EventRegistration.EventAttendeeSm AttendeeSm{get;set;}
        public EventRegistration.FormVm RequestData {get;set;}
    }
}