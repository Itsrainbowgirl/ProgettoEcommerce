package com.example.demo.controllers;

import com.example.demo.ResponseMessage;
import com.example.demo.entities.Product;
import com.example.demo.exceptions.BarCodeAlreadyExistException;
import com.example.demo.exceptions.BarCodeNotExistException;
import com.example.demo.services.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;

@CrossOrigin
@RestController
@RequestMapping("/products")
public class ProductsController {
    @Autowired
    private ProductService productService;


    @PostMapping
    public ResponseEntity create(@RequestBody Product product) {
        try {
            productService.addProduct(product);
        } catch (BarCodeAlreadyExistException e) {
            return new ResponseEntity<>(new ResponseMessage("Barcode already exist!"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(new ResponseMessage("Added successful!"), HttpStatus.OK);
    }

    @DeleteMapping
    public ResponseEntity destroy(@RequestBody Product product) {
        try {
            productService.removeProduct(product);
        } catch (BarCodeNotExistException e) {
            return new ResponseEntity<>(new ResponseMessage("Barcode not already exist!"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(new ResponseMessage("Removed successful!"), HttpStatus.OK);
    }

    @GetMapping
    public List<Product> getAll() {
        return productService.showAllProducts();
    }

    @GetMapping("/paged")
    public ResponseEntity getAll(@RequestParam(value = "pageNumber", defaultValue = "0") int pageNumber, @RequestParam(value = "pageSize", defaultValue = "10") int pageSize, @RequestParam(value = "sortBy", defaultValue = "id") String sortBy) {
        List<Product> result = productService.showAllProducts(pageNumber, pageSize, sortBy);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/by_name")
    public ResponseEntity getByName(@RequestParam(required = false) String name) {
        List<Product> result = productService.showProductsByName(name);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/by_genere")
    public ResponseEntity getByGenere(@RequestParam(required = false) String genere) {
        List<Product> result = productService.showProductsByGenere(genere);
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/prezzo50")
    public ResponseEntity getPrezzomin50() {
        List<Product> result = productService.showProductsByPrezzomin50();
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/prezzo50_100")
    public ResponseEntity getPrezzomin50_100() {
        List<Product> result = productService.showProductsByPrezzo50_100();
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @GetMapping("/search/prezzo100")
    public ResponseEntity getPrezzomax100() {
        List<Product> result = productService.showProductsByPrezzomax100();
        if ( result.size() <= 0 ) {
            return new ResponseEntity<>(new ResponseMessage("No results!"), HttpStatus.OK);
        }
        return new ResponseEntity<>(result, HttpStatus.OK);
    }


}
