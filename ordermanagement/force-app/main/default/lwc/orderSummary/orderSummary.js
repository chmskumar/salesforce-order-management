import { LightningElement, api, wire } from 'lwc';
import getOrderSummary from '@salesforce/apex/OrderSummaryController.getOrderSummary';

export default class OrderSummary extends LightningElement {
    @api recordId; // This will be provided when the component is used in a record page
    
    order;
    orderItems;
    error;

    columns = [
        { label: 'Product Name', fieldName: 'Name', type: 'text' },
        { label: 'Quantity', fieldName: 'Quantity', type: 'number' }
    ];

    @wire(getOrderSummary, { orderId: '$recordId' })
    wiredOrderSummary({ error, data }) {
        if (data) {
            this.order = data.order;
            this.orderItems = data.orderItems;
            this.error = undefined;
        } else if (error) {
            this.error = 'Error fetching order details';
            this.order = undefined;
            this.orderItems = undefined;
        }
    }
}