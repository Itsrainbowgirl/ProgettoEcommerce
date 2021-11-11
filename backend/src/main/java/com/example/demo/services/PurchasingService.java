package com.example.demo.services;



import com.example.demo.entities.Product;
import com.example.demo.entities.ProductInPurchase;
import com.example.demo.entities.Purchase;
import com.example.demo.entities.User;
import com.example.demo.exceptions.*;
import com.example.demo.repositories.ProductInPurchaseRepository;
import com.example.demo.repositories.PurchaseRepository;
import com.example.demo.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;


@Service
public class PurchasingService {
    @Autowired
    private PurchaseRepository purchaseRepository;
    @Autowired
    private ProductInPurchaseRepository productInPurchaseRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private EntityManager entityManager;


    @Transactional(readOnly = false)
    public Purchase addPurchase(Purchase purchase) throws QuantityProductUnavailableException {
        Purchase result = purchaseRepository.save(purchase);
        for ( ProductInPurchase pip : result.getProductsInPurchase() ) {
            pip.setPurchase(result);
            ProductInPurchase justAdded = productInPurchaseRepository.save(pip);
            entityManager.refresh(justAdded);
            Product product = justAdded.getProduct();
            int newQuantity = product.getQuantity() - pip.getQuantity();
            if ( newQuantity < 0 ) {
                throw new QuantityProductUnavailableException();
            }
            product.setQuantity(newQuantity);
            entityManager.refresh(pip);
        }
        entityManager.refresh(result);
        return result;
    }

    @Transactional(readOnly = true)
    public List<Purchase> showAllPurchase() {
        return purchaseRepository.findAll();
    }


    @Transactional(readOnly = false)
    public void removePurchase(int id) throws PurchaseNotExistException {
        if ( !purchaseRepository.existsById(id)) {
            throw new PurchaseNotExistException();
        }
        else {
            Purchase purchase=purchaseRepository.getById(id);
            for(ProductInPurchase pip : purchase.getProductsInPurchase()) {
                Product p = pip.getProduct();
                int newQuantity = p.getQuantity() + pip.getQuantity();
                p.setQuantity(newQuantity);
                productInPurchaseRepository.delete(pip);
            }

            purchaseRepository.delete(purchase);
        }
    }


    @Transactional(readOnly = true)
    public List<Purchase> getPurchasesByUser(int id) throws UserNotFoundException {
        if ( !userRepository.existsById(id) ) {
            throw new UserNotFoundException();
        }
        return purchaseRepository.findByBuyer_Id(id);
    }

    @Transactional(readOnly = true)
    public List<Purchase> getPurchasesByUserInPeriod(User user, Date startDate, Date endDate) throws UserNotFoundException, DateWrongRangeException {
        if ( !userRepository.existsById(user.getId()) ) {
            throw new UserNotFoundException();
        }
        if ( startDate.compareTo(endDate) >= 0 ) {
            throw new DateWrongRangeException();
        }
        return purchaseRepository.findByBuyerInPeriod(startDate, endDate, user);
    }

    @Transactional(readOnly = true)
    public List<Purchase> getAllPurchases() {
        return purchaseRepository.findAll();
    }


}
