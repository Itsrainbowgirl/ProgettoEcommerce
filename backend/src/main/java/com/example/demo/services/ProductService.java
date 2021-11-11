package com.example.demo.services;



import com.example.demo.entities.Product;
import com.example.demo.exceptions.BarCodeAlreadyExistException;
import com.example.demo.exceptions.BarCodeNotExistException;
import com.example.demo.repositories.ProductRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;


@Service
public class ProductService {
    @Autowired
    private ProductRepository productRepository;


    @Transactional(readOnly = false)
    public void addProduct(Product product) throws BarCodeAlreadyExistException {
        if ( product.getBarCode() != null && productRepository.existsByBarCode(product.getBarCode()) ) {
            throw new BarCodeAlreadyExistException();
        }
        productRepository.save(product);
    }

    @Transactional(readOnly = false)
    public void removeProduct(Product product) throws BarCodeNotExistException {
        if ( product.getBarCode() != null && !productRepository.existsByBarCode(product.getBarCode()) ) {
            throw new BarCodeNotExistException();
        }
        productRepository.delete(product);
    }



    @Transactional(readOnly = true)
    public List<Product> showAllProducts() {
        return productRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Product> showAllProducts(int pageNumber, int pageSize, String sortBy) {
        Pageable paging = PageRequest.of(pageNumber, pageSize, Sort.by(sortBy));
        Page<Product> pagedResult = productRepository.findAll(paging);
        if ( pagedResult.hasContent() ) {
            return pagedResult.getContent();
        }
        else {
            return new ArrayList<>();
        }
    }

    @Transactional(readOnly = true)
    public List<Product> showProductsByName(String name) {
        return productRepository.findByNameContaining(name);
    }

    @Transactional(readOnly = true)
    public List<Product> showProductsByBarCode(String barCode) {
        return productRepository.findByBarCode(barCode);
    }

    @Transactional(readOnly = true)
    public List<Product> showProductsByGenere(String genere) {
        return productRepository.findByGenere(genere);
    }

    @Transactional(readOnly = true)
    public List<Product> showProductsByPrezzomin50() {
        return productRepository.prezzoMinore50();
    }

    @Transactional(readOnly = true)
    public List<Product> showProductsByPrezzo50_100() {
        return productRepository.prezzoMinore50_100();
    }

    @Transactional(readOnly = true)
    public List<Product> showProductsByPrezzomax100() {
        return productRepository.prezzoMaggiore100();
    }


}
