package com.example.demo.repositories;



import com.example.demo.entities.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface ProductRepository extends JpaRepository<Product, Integer> {

    List<Product> findByNameContaining(String name);
    List<Product> findByBarCode(String name);
    List<Product> findByGenere(String genere);
    boolean existsByBarCode(String barCode);

    @Query("SELECT c FROM Product c WHERE c.price<50" )
    List<Product> prezzoMinore50();

    @Query("SELECT c FROM Product c WHERE c.price<100 AND c.price>50" )
    List<Product> prezzoMinore50_100();

    @Query("SELECT c FROM Product c WHERE c.price>100" )
    List<Product> prezzoMaggiore100();



}
