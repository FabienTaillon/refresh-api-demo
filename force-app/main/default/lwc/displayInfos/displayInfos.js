import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { registerRefreshHandler, unregisterRefreshHandler } from 'lightning/refresh';
import { refreshApex } from '@salesforce/apex';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import getRecordName from "@salesforce/apex/RecordService.getRecordName";

export default class DisplayInfos extends LightningElement {

    @api recordId;
    refreshHandlerID;
    
    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD] })
    account;

    @wire(getRecordName, { recordId: '$recordId' })
    recordName;

    get name() {
        return getFieldValue(this.account.data, NAME_FIELD);
    }

    connectedCallback() {
        //this.refreshHandlerID = registerRefreshHandler(this, this.refreshHandler);
     }

     disconnectedCallback() {
        unregisterRefreshHandler(this.refreshHandlerID);
     }

    refreshHandler() {
        return new Promise((resolve) => {
            refreshApex(this.recordName);
            resolve(true);
        });
    }
}

