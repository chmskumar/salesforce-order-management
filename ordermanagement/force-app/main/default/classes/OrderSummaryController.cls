public with sharing class OrderSummaryController {
    
    @AuraEnabled(cacheable=true)
    public static OrderSummaryWrapper getOrderSummary(Id orderId) {
        // Query the Order and its related OrderItems
        OrderSummaryWrapper result = new OrderSummaryWrapper();
        
        // Query for the Order details
        Order order = [
            SELECT Id, OrderNumber, Account.Name, Total_Quantity__c
            FROM Order
            WHERE Id = :orderId
            LIMIT 1
        ];
        
        // Query for the related OrderItems
        List<OrderItem> orderItems = [
            SELECT Product2.Name, Quantity
            FROM OrderItem
            WHERE OrderId = :orderId
        ];
        
        result.order = order;
        result.orderItems = orderItems;
        
        return result;
    }
    
    public class OrderSummaryWrapper {
        @AuraEnabled
        public Order order;
        
        @AuraEnabled
        public List<OrderItem> orderItems;
    }
}