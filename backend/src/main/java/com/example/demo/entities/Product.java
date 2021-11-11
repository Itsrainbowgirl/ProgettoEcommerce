package com.example.demo.entities;



import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;


import javax.persistence.*;
import java.util.List;


@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "prodotto", schema = "public")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Version
    @Column(name = "version", nullable = true, length = 50)
    private int version;

    @Basic
    @Column(name = "nome", nullable = true, length = 50)
    private String name;

    @Basic
    @Column(name = "bar_code", nullable = false,unique = true, length = 70)
    private String barCode;

    @Basic
    @Column(name = "descrizione", nullable = true, length = 500)
    private String description;

    @Basic
    @Column(name = "prezzo",nullable=false)
    private float price;

    @Basic
    @Column(name = "quantita", nullable = false)
    private int quantity;

    @Basic
    @Column(name = "immagine", nullable = true)
    private String immagine;

    @Basic
    @Column(name = "genere", nullable = true)
    private String genere;


    @OneToMany(targetEntity = ProductInPurchase.class, mappedBy = "product", cascade = CascadeType.MERGE)
    @JsonIgnore
    @ToString.Exclude
    private List<ProductInPurchase> productsInPurchase;


}
