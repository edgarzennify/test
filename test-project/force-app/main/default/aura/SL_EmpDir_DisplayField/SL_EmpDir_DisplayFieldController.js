({
   	doInit : function(component) {
        var record = component.get("v.record");
        var fieldName = component.get("v.fieldApiName");

        /* Function that recompose the reference fields.
         * eg: Oppty.Account.Name recomposes to Record['Oppty']['Account']['Name']
         */
        function getRecordValue(value,fieldName) {
            var lstFields = fieldName.split('.');
            var recordValue = value[lstFields[0]];
            if(lstFields[1] && recordValue){
                lstFields.splice(0,1);
                var newFieldName = lstFields.join('.');
                return getRecordValue(recordValue,newFieldName);
            }
            return recordValue;
        }
        if(record !== undefined) {
        	component.set("v.fieldValue", getRecordValue(record, fieldName));
        }
    }
})