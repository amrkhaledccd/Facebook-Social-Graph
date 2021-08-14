package com.social.graph.authservice.service;

import com.social.graph.authservice.exception.EmailAlreadyExistsException;
import com.social.graph.authservice.exception.UsernameAlreadyExistsException;
import com.social.graph.authservice.model.Role;
import com.social.graph.authservice.model.User;
import com.social.graph.authservice.payload.PagedResult;
import com.social.graph.authservice.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.HashSet;
import java.util.Optional;

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

    public PagedResult<User> findAll(int page, int size) {
        log.info("retrieving all users");
        var pageable = PageRequest.of(page, size);
        return buildPagedResult(userRepository.findAll(pageable));
    }

    public Optional<User> findByUsername(String username) {
        log.info("retrieving user {}", username);
        return userRepository.findByUsername(username);
    }

    public User registerUser(User user) {
        log.info("registering user {}", user.getUsername());

        if(userRepository.existsByUsername(user.getUsername())) {
            log.warn("username {} already exists.", user.getUsername());

            throw new UsernameAlreadyExistsException(
                    String.format("username %s already exists", user.getUsername()));
        }

        if(userRepository.existsByEmail(user.getEmail())) {
            log.warn("email {} already exists.", user.getEmail());

            throw new EmailAlreadyExistsException(
                    String.format("email %s already exists", user.getEmail()));
        }
        user.setActive(true);
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setRoles(new HashSet<>() {{
            add(Role.USER.getName());
        }});

        return userRepository.save(user);
    }

    private PagedResult<User> buildPagedResult(Page<User> page){
        return PagedResult
                .<User>builder()
                .content(page.getContent())
                .totalElements(page.getTotalElements())
                .totalPages(page.getTotalPages())
                .page(page.getPageable().getPageNumber())
                .size(page.getSize())
                .last(page.isLast())
                .build();
    }
}
