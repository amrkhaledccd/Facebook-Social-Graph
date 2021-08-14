package com.social.graph.authservice.repository;

import com.social.graph.authservice.model.User;
import org.springframework.data.neo4j.repository.Neo4jRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends Neo4jRepository<User, UUID> {

    Optional<User> findByUsername(String username);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);
}
