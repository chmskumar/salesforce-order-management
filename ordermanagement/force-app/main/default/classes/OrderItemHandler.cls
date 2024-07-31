public class OrderItemHandler {
    public static void updateOrderTotalQuantities(List<OrderItem> newOrderItems) {
        // Set to collect Order IDs from the inserted OrderItems
        Set<Id> orderIds = new Set<Id>();
        
        // Loop through the new OrderItems to gather Order IDs
        for (OrderItem oi : newOrderItems) {
            orderIds.add(oi.OrderId);
        }

        // Create a map to hold Order ID and its total quantity
        Map<Id, Decimal> orderQuantityMap = new Map<Id, Decimal>();

        // Query all OrderItems related to the gathered Order IDs to calculate total quantities
        List<OrderItem> orderItems = [
            SELECT OrderId, Quantity 
            FROM OrderItem 
            WHERE OrderId IN :orderIds
        ];
        
        // Calculate total quantity for each Order
        for (OrderItem oi : orderItems) {
            if (orderQuantityMap.containsKey(oi.OrderId)) {
                orderQuantityMap.put(oi.OrderId, orderQuantityMap.get(oi.OrderId) + oi.Quantity);
            } else {
                orderQuantityMap.put(oi.OrderId, oi.Quantity);
            }
        }

        // Prepare list of Orders to update
        List<Order> ordersToUpdate = new List<Order>();

        // Update the Total_Quantity__c field on each Order
        for (Id orderId : orderQuantityMap.keySet()) {
            ordersToUpdate.add(new Order(
                Id = orderId,
                Total_Quantity__c = orderQuantityMap.get(orderId)
            ));
        }

        // Perform the update operation
        if (!ordersToUpdate.isEmpty()) {
            update ordersToUpdate;
        }
    }
}