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
@Table(name = "cliente", schema = "public")
@SecondaryTable(name="t_indirizzi", pkJoinColumns = {@PrimaryKeyJoinColumn(name = "id")})
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private int id;

    @Basic
    @Column(name = "nome", nullable = true, length = 50)
    private String nome;

    @Basic
    @Column(name = "cognome", nullable = true, length = 50)
    private String cognome;

    @Basic
    @Column(name = "telefono", nullable = false, length = 20)
    private String telefono;

    @Basic
    @Column(name = "email", nullable = false, length = 90)
    private String email;

    @Basic
    @Column(name = "cap",table = "t_indirizzi",length = 5)
    private String cap;

    @Basic
    @Column(name = "via",table = "t_indirizzi",length = 90)
    private String via;

    @Basic
    @Column(name = "numero_civico",table = "t_indirizzi")
    private int numCivico;

    @Basic
    @Column(name = "provincia",table = "t_indirizzi",length = 70)
    private String provincia;

    @OneToMany(mappedBy = "buyer", cascade = CascadeType.MERGE)
    @JsonIgnore
    private List<Purchase> purchases;


}
