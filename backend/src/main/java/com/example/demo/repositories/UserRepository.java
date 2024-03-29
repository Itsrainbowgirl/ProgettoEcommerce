package com.example.demo.repositories;


import com.example.demo.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    List<User> findByNome(String firstName);
    List<User> findByCognome(String lastName);
    List<User> findByEmail(String email);
    boolean existsByEmail(String email);
    boolean existsById(int id);
}
