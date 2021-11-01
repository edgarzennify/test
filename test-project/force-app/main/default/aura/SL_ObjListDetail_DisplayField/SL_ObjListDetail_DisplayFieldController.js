({
    doInit: function (component) {
        var record = component.get("v.record");
        var fieldApiName = component.get("v.fieldApiName");

        /* Function that recompose the reference fields.
         * eg: Oppty.Account.Name recomposes to Record['Oppty']['Account']['Name']
         */
        function getRecordValue(value, fieldName) {
            var lstFields = fieldName.split('.');
            var recordValue = value[lstFields[0]];
            if (lstFields[1] && recordValue) {
                lstFields.splice(0, 1);
                var newFieldName = lstFields.join('.');
                return getRecordValue(recordValue, newFieldName);
            }
            return recordValue;
        }

        if (record !== undefined) {
            component.set("v.fieldValue", getRecordValue(record, fieldApiName));
        }
        var fieldType = component.get('v.fieldType');
        var fieldValue = component.get('v.fieldValue');
        /*if (fieldType === 'TEXTAREA') {
            //component.set('v.fieldValue', fieldValue && fieldValue.replace(/(font-family:[\s|A-z0-9|,|-]+;)|(font-size:?\s[0-9\.]+px;)/gm,''));
            component.set('v.fieldValue', fieldValue && fieldValue.replace(/style="[a-zA-Z0-9:;\.\s\(\)\-\,]*"/gm,''));
        }*/
    }
})