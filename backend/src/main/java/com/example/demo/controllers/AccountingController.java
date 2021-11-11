package com.example.demo.controllers;



import com.example.demo.ResponseMessage;
import com.example.demo.entities.Product;
import com.example.demo.entities.User;
import com.example.demo.exceptions.BarCodeNotExistException;
import com.example.demo.exceptions.MailUserAlreadyExistsException;
import com.example.demo.exceptions.UserNotExist;
import com.example.demo.services.AccountingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;


@RestController
@RequestMapping("/users")
public class AccountingController {
    @Autowired
    private AccountingService accountingService;


    @PostMapping
    public ResponseEntity create(@RequestBody @Valid User user) {
        try {
            User added = accountingService.registerUser(user);
            return new ResponseEntity(added, HttpStatus.OK);
        } catch (MailUserAlreadyExistsException e) {
            return new ResponseEntity<>(new ResponseMessage("ERROR_MAIL_USER_ALREADY_EXISTS"), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/utente")
    public User getUser(@RequestParam String email){return accountingService.getUser(email);}

    @PutMapping
    public void modify(@RequestBody User user ){
        accountingService.modifyUser(user);
    }

    @GetMapping
    public List<User> getAll() {
        return accountingService.getAllUsers();
    }

    @DeleteMapping
    public ResponseEntity destroy(@RequestParam String email) {
        try {
            accountingService.deleteUser(email);
        } catch (UserNotExist e) {
            return new ResponseEntity<>(new ResponseMessage("Email not already exist!"), HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(new ResponseMessage("Removed successful!"), HttpStatus.OK);
    }


}
