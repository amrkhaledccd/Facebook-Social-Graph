package com.social.graph.authservice.service;

import com.google.gson.Gson;
import com.social.graph.authservice.exception.EmailAlreadyExistsException;
import com.social.graph.authservice.exception.UsernameAlreadyExistsException;
import com.social.graph.authservice.model.ObjectNode;
import com.social.graph.authservice.model.Role;
import com.social.graph.authservice.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@Slf4j
public class UserService {

    private PasswordEncoder passwordEncoder;
    private UserRepository userRepository;

    public UserService(UserRepository userRepository,
                       PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public Optional<ObjectNode> findByUsername(String username) {
        log.info("retrieving user {}", username);
        return userRepository.findByUsername(username);
    }

    public ObjectNode registerUser(Map<String, String> data) {
        var username = data.get("username");
        var email = data.get("email");

        if(userRepository.existsByUsername(username)) {
            log.warn("username {} already exists.", username);

            throw new UsernameAlreadyExistsException(
                    String.format("username %s already exists", username));
        }

        if(userRepository.existsByEmail(email)) {
            log.warn("email {} already exists.", email);

            throw new EmailAlreadyExistsException(
                    String.format("email %s already exists", email));
        }
        data.put("password", passwordEncoder.encode(data.get("password")));
        var roles = new HashSet<String>() {{ add(Role.USER.getName()); }};
        data.put("roles", new Gson().toJson(roles, HashSet.class));
        data.put("isActive", Boolean.TRUE.toString());

        var node = new ObjectNode("USER", data);
        return userRepository.save(node);
    }
}
