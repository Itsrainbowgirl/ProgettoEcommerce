package com.example.demo.repositories;


import com.example.demo.entities.Purchase;
import com.example.demo.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;


@Repository
public interface PurchaseRepository extends JpaRepository<Purchase, Integer> {
    boolean existsById(int id);
    List<Purchase> findByBuyer(User user);
    List<Purchase> findByPurchaseTime(Date date);
    List<Purchase> findByBuyer_Id(int id);

    @Query("select p from Purchase p where p.purchaseTime > ?1 and p.purchaseTime < ?2 and p.buyer = ?3")
    List<Purchase> findByBuyerInPeriod(Date startDate, Date endDate, User user);

}
