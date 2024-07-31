trigger OrderTrigger on Order (before update) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        // Collect Order IDs that are being confirmed
        List<Id> orderIds = new List<Id>();
        
        for (Order order : Trigger.new) {
            if (order.Status == 'Confirmed' && Trigger.oldMap.get(order.Id).Status != 'Confirmed') {
                orderIds.add(order.Id);
            }
        }
        
        if (!orderIds.isEmpty()) {
            // Call the handler class to process the orders and check production capacity
            OrderTriggerHandler.handleOrderCapacityCheck(orderIds, Trigger.newMap);
        }
    }
}