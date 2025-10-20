package com.example.orderservice.config;

import com.example.orderservice.model.Order;
import com.example.orderservice.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.math.BigDecimal;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class DataSeeder {

    @Bean
    public CommandLineRunner seedData(OrderRepository orderRepository) {
        return args -> {
            if (orderRepository.count() == 0) {
                log.info("Seeding initial data...");

                Order order1 = new Order();
                order1.setCustomerName("Alice Johnson");
                order1.setCustomerEmail("alice@example.com");
                order1.setProductName("Laptop Pro 15");
                order1.setQuantity(1);
                order1.setPrice(new BigDecimal("1299.99"));
                order1.setTotalAmount(new BigDecimal("1299.99"));
                order1.setStatus(Order.OrderStatus.CONFIRMED);

                Order order2 = new Order();
                order2.setCustomerName("Bob Smith");
                order2.setCustomerEmail("bob@example.com");
                order2.setProductName("Wireless Mouse");
                order2.setQuantity(3);
                order2.setPrice(new BigDecimal("29.99"));
                order2.setTotalAmount(new BigDecimal("89.97"));
                order2.setStatus(Order.OrderStatus.SHIPPED);

                Order order3 = new Order();
                order3.setCustomerName("Carol White");
                order3.setCustomerEmail("carol@example.com");
                order3.setProductName("USB-C Hub");
                order3.setQuantity(2);
                order3.setPrice(new BigDecimal("45.50"));
                order3.setTotalAmount(new BigDecimal("91.00"));
                order3.setStatus(Order.OrderStatus.PENDING);

                orderRepository.save(order1);
                orderRepository.save(order2);
                orderRepository.save(order3);

                log.info("Successfully seeded {} orders", 3);
            } else {
                log.info("Database already contains data. Skipping seeding.");
            }
        };
    }
}
