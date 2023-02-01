import { LightningElement, api } from "lwc";
import {
  getRecordNotifyChange,
  notifyRecordUpdateAvailable
} from "lightning/uiRecordApi";
import { RefreshEvent } from "lightning/refresh";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createRecords from "@salesforce/apex/RecordService.createRecords";

export default class MyComponent extends LightningElement {
  @api recordId;
  recordsToRefresh;

  handleCreate() {
    createRecords({ recordId: this.recordId })
      .then((result) => {
        console.log(result);

        this.recordsToRefresh = result.map((rec) => {
          return { 'recordId': rec };
        });
        console.log(this.recordsToRefresh);

        const event = new ShowToastEvent({
          title: "Records created",
          variant: "success"
        });
        this.dispatchEvent(event);
      })
      .catch((error) => {
        console.log(error);
      });
  }

  handeForceRefreshView() {
    eval("$A.get('e.force:refreshView').fire();");
  }

  handleGetRecordNotifyChange() {
    console.log(this.recordsToRefresh);
    if (this.recordsToRefresh) {
      getRecordNotifyChange(this.recordsToRefresh);
    }
  }

  handleNotifyRecordUpdateAvailable() {
    if (this.recordsToRefresh) {
      notifyRecordUpdateAvailable(this.recordsToRefresh);
    }
  }

  handleRefreshViewAPI() {
    console.log("refresh");
    this.dispatchEvent(new RefreshEvent());
  }
}
