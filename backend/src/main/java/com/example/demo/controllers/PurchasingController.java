package com.example.demo.controllers;



import com.example.demo.ResponseMessage;
import com.example.demo.entities.Product;
import com.example.demo.entities.Purchase;
import com.example.demo.entities.User;
import com.example.demo.exceptions.*;
import com.example.demo.services.PurchasingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;


import java.util.Date;
import java.util.List;


@RestController
@RequestMapping("/purchases")
public class PurchasingController {
    @Autowired
    private PurchasingService purchasingService;


    @PostMapping
    @ResponseStatus(code = HttpStatus.OK)
    public ResponseEntity create(@RequestBody Purchase purchase) { // è buona prassi ritornare l'oggetto inserito
        try {
            return new ResponseEntity<>(purchasingService.addPurchase(purchase), HttpStatus.OK);
        } catch (QuantityProductUnavailableException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Product quantity unavailable!", e); // realmente il messaggio dovrebbe essrere più esplicativo (es. specificare il prodotto di cui non vi è disponibilità)
        }
    }

    @GetMapping
    public List<Purchase> getAll() {
        return purchasingService.showAllPurchase();
    }

    @CrossOrigin
    @DeleteMapping
    public ResponseEntity destroy(@RequestParam int id) {
        try {
            purchasingService.removePurchase(id);
        } catch (PurchaseNotExistException e) {
            return new ResponseEntity<>(new ResponseMessage("Id Purchase not already exist!"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(new ResponseMessage("Removed successful!"), HttpStatus.OK);
    }


    @GetMapping("/byUser")
    public ResponseEntity getPurchases(@RequestParam int user) {
        try {
            List<Purchase> result = purchasingService.getPurchasesByUser(user);
            if ( result.size() <= 0 ) {
                return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
            }
            return new ResponseEntity<>(result, HttpStatus.OK);
        } catch (UserNotFoundException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User not found!", e);
        }

    }


}
