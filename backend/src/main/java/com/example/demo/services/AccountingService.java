package com.example.demo.services;


import com.example.demo.entities.User;
import com.example.demo.exceptions.MailUserAlreadyExistsException;
import com.example.demo.exceptions.UserNotExist;
import com.example.demo.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


@Service
public class AccountingService {
    @Autowired
    private UserRepository userRepository;


    @Transactional(readOnly = false, propagation = Propagation.REQUIRED)
    public User registerUser(User user) throws MailUserAlreadyExistsException {
        if ( userRepository.existsByEmail(user.getEmail()) ) {
            throw new MailUserAlreadyExistsException();
        }
        return userRepository.save(user);
    }

    @Transactional(readOnly = false)
    public void modifyUser(User user){
        User usertemp=userRepository.findByEmail(user.getEmail()).get(0);
        usertemp.setProvincia(user.getProvincia());
        usertemp.setNumCivico(user.getNumCivico());
        usertemp.setVia(user.getVia());
        usertemp.setCap(user.getCap());
    }

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Transactional(readOnly = true)
    public User getUser(String email) {
        return userRepository.findByEmail(email).get(0);
    }

    @Transactional(readOnly = false)
    public void deleteUser (String email) throws UserNotExist {
        if ( !userRepository.existsByEmail(email) ) {
            throw new UserNotExist();
        }
        List<User> utente= userRepository.findByEmail(email);

        userRepository.delete(utente.get(0));
    }


}
