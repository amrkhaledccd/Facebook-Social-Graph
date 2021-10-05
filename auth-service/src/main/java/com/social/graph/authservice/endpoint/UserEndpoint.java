package com.social.graph.authservice.endpoint;

import com.social.graph.authservice.exception.ResourceNotFoundException;
import com.social.graph.authservice.payload.ApiResponse;
import com.social.graph.authservice.payload.JwtAuthenticationResponse;
import com.social.graph.authservice.payload.LoginRequest;
import com.social.graph.authservice.payload.SignUpRequest;
import com.social.graph.authservice.service.JwtTokenProvider;
import com.social.graph.authservice.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import javax.validation.Valid;
import java.util.HashMap;

@RestController
@Slf4j
public class UserEndpoint {

    @Autowired
    private UserService userService;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtTokenProvider tokenProvider;


    @PostMapping("/signin")
    public ResponseEntity<?> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {

        var authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getUsername(),
                        loginRequest.getPassword()
                )
        );

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String jwt = tokenProvider.generateToken(authentication);
        return ResponseEntity.ok(new JwtAuthenticationResponse(jwt));
    }

    @PostMapping(value = "/users", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> createUser(@Valid @RequestBody SignUpRequest payload) {
        log.info("creating user {}", payload.getUsername());

        var data = new HashMap<String, String>();
        data.put("username", payload.getUsername());
        data.put("name", payload.getName());
        data.put("email", payload.getEmail());
        data.put("password", payload.getPassword());
        if(payload.getImageUrl() != null && !payload.getImageUrl().isEmpty()) {
            data.put("imageUrl", payload.getImageUrl());
        }

        userService.registerUser(data);
        var location = ServletUriComponentsBuilder
                .fromCurrentContextPath().path("/users/{username}")
                .buildAndExpand(payload.getUsername()).toUri();

        return ResponseEntity
                .created(location)
                .body(new ApiResponse(true,"User registered successfully"));
    }

    @GetMapping(value = "/users/{username}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<?> findUser(@PathVariable("username") String username) {
        log.info("retrieving user {}", username);

        return  userService
                .findByUsername(username)
                .map(ResponseEntity::ok)
                .orElseThrow(() -> new ResourceNotFoundException(username));
    }
}