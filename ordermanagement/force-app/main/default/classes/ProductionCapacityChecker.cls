public class ProductionCapacityChecker {

    @AuraEnabled
    public static Map<Id, String> checkProductionCapacity(List<Id> orderIds) {
        Map<Id, String> results = new Map<Id, String>();
        
        // Query Orders and their quantities
        List<Order> orders = [SELECT Id, Total_Quantity__c FROM Order WHERE Id IN :orderIds];
        
        // Get production capacity
        Decimal productionCapacity = getProductionCapacity();
        
        for (Order order : orders) {
            Decimal orderQuantity = order.Total_Quantity__c;
            
            if (orderQuantity > productionCapacity) {
                // Capacity exceeded
                results.put(order.Id, 'The order quantity exceeds the available production capacity.');
            } else {
                // Capacity is sufficient
                results.put(order.Id, 'Order can be confirmed. Production capacity is sufficient.');
            }
        }
        
        return results;
    }
    
    private static Decimal getProductionCapacity() {
        // Replace this with actual logic to query production capacity from Manufacturing Cloud
        Decimal placeholderCapacity = 1000; // Example capacity
        return placeholderCapacity;
    }
}