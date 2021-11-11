package com.example.demo.repositories;



import com.example.demo.entities.Product;
import com.example.demo.entities.ProductInPurchase;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface ProductInPurchaseRepository extends JpaRepository<ProductInPurchase, Integer> {
    boolean existsById(int id);


}
