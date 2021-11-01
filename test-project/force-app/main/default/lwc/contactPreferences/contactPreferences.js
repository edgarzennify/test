import { LightningElement, api } from 'lwc';

import DO_NOT_CALL_FIELD from '@salesforce/schema/Account.Do_Not_Call__c';
import DO_NOT_EMAIL_FIELD from '@salesforce/schema/Account.Do_Not_Email__c';
import DO_NOT_MAIL_FIELD from '@salesforce/schema/Account.Do_Not_Mail__c';
import DO_NOT_TEXT_FIELD from '@salesforce/schema/Account.Do_Not_Text__c';
import DO_NOT_SOLICIT_FIELD from '@salesforce/schema/Account.Do_Not_Solicit__c';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REASON_FIELD from '@salesforce/schema/Account.Reason_Do_Not_Solicit__c';
import MATERIAL_FIELD from '@salesforce/schema/Account.Material_Do_Not_Solicit__c';
import TCPA_CONSENT_FIELD from '@salesforce/schema/Account.TCPA_Consent_pick__c';
import TCPA_CONSENT_DATE_FIELD from '@salesforce/schema/Account.TCPA_Consent_Date__c';
import TCPA_REVOKE_FIELD from '@salesforce/schema/Account.TCPA_Revoke_pick__c';
import TCPA_REVOKE_DATE_FIELD from '@salesforce/schema/Account.TCPA_Revoke_Date__c';

export default class ContactPreferencesLayout extends LightningElement {
    @api recordId;
    @api objectApiName;

    fields = [
        DO_NOT_CALL_FIELD
        ,DO_NOT_EMAIL_FIELD
        ,DO_NOT_MAIL_FIELD
        ,DO_NOT_TEXT_FIELD
        ,DO_NOT_SOLICIT_FIELD
        ,NAME_FIELD
        ,REASON_FIELD
        ,MATERIAL_FIELD
        ,TCPA_CONSENT_FIELD
        ,TCPA_CONSENT_DATE_FIELD
        ,TCPA_REVOKE_FIELD
        ,TCPA_REVOKE_DATE_FIELD
    ];

}