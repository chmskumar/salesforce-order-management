trigger UpdateOrderQuantity on OrderItem (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        OrderItemHandler.updateOrderTotalQuantities(Trigger.new);
    }
}