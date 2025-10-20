package com.example.orderservice.dto;

import com.example.orderservice.model.Order;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderResponse {

    private Long id;
    private String customerName;
    private String customerEmail;
    private String productName;
    private Integer quantity;
    private BigDecimal price;
    private BigDecimal totalAmount;
    private Order.OrderStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static OrderResponse fromOrder(Order order) {
        return new OrderResponse(
            order.getId(),
            order.getCustomerName(),
            order.getCustomerEmail(),
            order.getProductName(),
            order.getQuantity(),
            order.getPrice(),
            order.getTotalAmount(),
            order.getStatus(),
            order.getCreatedAt(),
            order.getUpdatedAt()
        );
    }
}
