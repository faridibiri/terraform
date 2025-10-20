package com.example.orderservice.service;

import com.example.orderservice.dto.OrderRequest;
import com.example.orderservice.dto.OrderResponse;
import com.example.orderservice.exception.OrderNotFoundException;
import com.example.orderservice.model.Order;
import com.example.orderservice.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderService {

    private final OrderRepository orderRepository;

    @Transactional
    public OrderResponse createOrder(OrderRequest request) {
        log.info("Creating new order for customer: {}", request.getCustomerName());

        Order order = new Order();
        order.setCustomerName(request.getCustomerName());
        order.setCustomerEmail(request.getCustomerEmail());
        order.setProductName(request.getProductName());
        order.setQuantity(request.getQuantity());
        order.setPrice(request.getPrice());
        order.setTotalAmount(request.getPrice().multiply(BigDecimal.valueOf(request.getQuantity())));
        order.setStatus(Order.OrderStatus.PENDING);

        Order savedOrder = orderRepository.save(order);
        log.info("Order created successfully with ID: {}", savedOrder.getId());

        return OrderResponse.fromOrder(savedOrder);
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> getAllOrders() {
        log.info("Fetching all orders");
        return orderRepository.findAll().stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public OrderResponse getOrderById(Long id) {
        log.info("Fetching order with ID: {}", id);
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new OrderNotFoundException(id));
        return OrderResponse.fromOrder(order);
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> getOrdersByCustomerEmail(String email) {
        log.info("Fetching orders for customer email: {}", email);
        return orderRepository.findByCustomerEmail(email).stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<OrderResponse> getOrdersByStatus(Order.OrderStatus status) {
        log.info("Fetching orders with status: {}", status);
        return orderRepository.findByStatus(status).stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    @Transactional
    public OrderResponse updateOrderStatus(Long id, Order.OrderStatus status) {
        log.info("Updating order {} status to {}", id, status);
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new OrderNotFoundException(id));

        order.setStatus(status);
        Order updatedOrder = orderRepository.save(order);
        log.info("Order status updated successfully");

        return OrderResponse.fromOrder(updatedOrder);
    }

    @Transactional
    public void deleteOrder(Long id) {
        log.info("Deleting order with ID: {}", id);
        if (!orderRepository.existsById(id)) {
            throw new OrderNotFoundException(id);
        }
        orderRepository.deleteById(id);
        log.info("Order deleted successfully");
    }
}
