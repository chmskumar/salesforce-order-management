public class InventoryManagement {

    // Method to reduce inventory when an Order is placed
    public static void reduceInventory(List<OrderItem> orderItems) {
        // Map to collect Product IDs and quantities to reduce
        Map<Id, Decimal> productQuantities = new Map<Id, Decimal>();

        // Aggregate quantities per product
        for (OrderItem oi : orderItems) {
            if (productQuantities.containsKey(oi.Product2Id)) {
                productQuantities.put(oi.Product2Id, productQuantities.get(oi.Product2Id) + oi.Quantity);
            } else {
                productQuantities.put(oi.Product2Id, oi.Quantity);
            }
        }

        // Query the Product2 objects to check current inventory levels
        List<Product2> products = [
            SELECT Id, Inventory__c 
            FROM Product2 
            WHERE Id IN :productQuantities.keySet()
        ];

        // Map to store Product2 records with updated inventory
        Map<Id, Product2> productsToUpdate = new Map<Id, Product2>();

        for (Product2 product : products) {
            Decimal quantityToReduce = productQuantities.get(product.Id);
            if (product.Inventory__c >= quantityToReduce) {
                product.Inventory__c -= quantityToReduce;
                productsToUpdate.put(product.Id, product);
            } else {
                // Log error for insufficient inventory
                System.debug('Insufficient inventory for product: ' + product.Id);
            }
        }

        // Perform the update operation
        if (!productsToUpdate.isEmpty()) {
            try {
                update productsToUpdate.values();
            } catch (DmlException e) {
                // Handle the exception (e.g., log the error or notify an admin)
                System.debug('Error updating inventory: ' + e.getMessage());
            }
        }
    }

    // Method to replenish inventory when an Order is canceled
    public static void replenishInventory(List<OrderItem> orderItems) {
        // Map to collect Product IDs and quantities to replenish
        Map<Id, Decimal> productQuantities = new Map<Id, Decimal>();

        // Aggregate quantities per product
        for (OrderItem oi : orderItems) {
            if (productQuantities.containsKey(oi.Product2Id)) {
                productQuantities.put(oi.Product2Id, productQuantities.get(oi.Product2Id) + oi.Quantity);
            } else {
                productQuantities.put(oi.Product2Id, oi.Quantity);
            }
        }

        // Query the Product2 objects to check current inventory levels
        List<Product2> products = [
            SELECT Id, Inventory__c 
            FROM Product2 
            WHERE Id IN :productQuantities.keySet()
        ];

        // Map to store Product2 records with updated inventory
        Map<Id, Product2> productsToUpdate = new Map<Id, Product2>();

        for (Product2 product : products) {
            if (!productsToUpdate.containsKey(product.Id)) {
                productsToUpdate.put(product.Id, product);
            }
            product.Inventory__c += productQuantities.get(product.Id);
        }

        // Perform the update operation
        if (!productsToUpdate.isEmpty()) {
            try {
                update productsToUpdate.values();
            } catch (DmlException e) {
                // Handle the exception (e.g., log the error or notify an admin)
                System.debug('Error replenishing inventory: ' + e.getMessage());
            }
        }
    }

    // Custom exception for handling inventory issues
    public class InventoryException extends Exception {}
}