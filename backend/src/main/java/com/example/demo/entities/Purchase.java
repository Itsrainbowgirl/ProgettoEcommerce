package com.example.demo.entities;


import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import javax.persistence.*;
import java.util.Date;
import java.util.List;


@Getter
@Setter
@EqualsAndHashCode
@ToString
@Entity
@Table(name = "ordine",schema = "public")
@SecondaryTable(name = "pagamento", pkJoinColumns = {@PrimaryKeyJoinColumn(name = "id")})
public class Purchase {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Basic
    @CreationTimestamp
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "purchase_time")
    private Date purchaseTime;

    @ManyToOne
    @JoinColumn(name = "cliente")
    private User buyer;

    @OneToMany(mappedBy = "purchase", cascade = CascadeType.MERGE)
    private List<ProductInPurchase> productsInPurchase;

    @Basic
    @Column(name = "numero_carta",table = "pagamento",length = 16,nullable = false)
    private String numero_carta;

    @Basic
    @Column(name = "tipo",table = "pagamento",length = 50,nullable = false)
    private String tipo;

    @Basic
    @Column(name = "scadenza",table = "pagamento",nullable = false)
    private String scadenza;


}
