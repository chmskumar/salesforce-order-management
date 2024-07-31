public class OrderTriggerHandler {
    
    public static void handleOrderCapacityCheck(List<Id> orderIds, Map<Id, Order> newOrdersMap) {
        // Check production capacity for the given Order IDs
        Map<Id, String> results = ProductionCapacityChecker.checkProductionCapacity(orderIds);
        
        // Apply errors if capacity is exceeded
        applyErrorsToOrders(newOrdersMap, results);
    }
    
    private static void applyErrorsToOrders(Map<Id, Order> newOrdersMap, Map<Id, String> results) {
        for (Order order : newOrdersMap.values()) {
            if (results.containsKey(order.Id) && results.get(order.Id).contains('exceeds')) {
                // If the capacity is exceeded, prevent the update and display a message
                order.addError(results.get(order.Id));
            }
        }
    }
}