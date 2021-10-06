package com.social.graph.authservice.service;

import com.google.gson.Gson;
import com.social.graph.authservice.model.AuthUserDetails;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
public class AuthUserDetailsService implements UserDetailsService {

    private UserService userService;

    public AuthUserDetailsService(UserService userService) {
        this.userService = userService;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        return userService
                .findByUsername(username)
                .map(objectNode -> {
                    var password = objectNode.getData().get("password");
                    var roles =
                            new Gson().<Set<String>>fromJson(objectNode.getData().get("roles"), Set.class);
                    var isActive = Boolean.parseBoolean(objectNode.getData().get("isActive"));

                    return new AuthUserDetails(username, password, roles , isActive);
                })
                .orElseThrow(() -> new UsernameNotFoundException("Username not found"));
    }
}
