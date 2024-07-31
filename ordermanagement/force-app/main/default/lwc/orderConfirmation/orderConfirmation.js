import { LightningElement, api, track } from 'lwc';
import checkProductionCapacity from '@salesforce/apex/ProductionCapacityChecker.checkProductionCapacity';

export default class OrderConfirmation extends LightningElement {
    @api recordId; // The Id of the Order to be confirmed
    @track message; // To display messages to the user

    handleConfirmOrder() {
        // Call the Apex method to check production capacity
        checkProductionCapacity({ orderIds: [this.recordId] })
            .then(result => {
                // Display message based on the result
                if (result[this.recordId].includes('exceeds')) {
                    this.message = result[this.recordId];
                } else {
                    this.message = result[this.recordId];
                    // Additional logic to proceed with order confirmation can go here
                }
            })
            .catch(error => {
                this.message = 'An error occurred: ' + error.body.message;
            });
    }
}
