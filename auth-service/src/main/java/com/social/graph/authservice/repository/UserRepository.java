package com.social.graph.authservice.repository;

import com.social.graph.authservice.model.ObjectNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends Neo4jRepository<ObjectNode, UUID> {

    @Query("MATCH (n:ObjectNode) where n.`data.username` = $username RETURN n")
    Optional<ObjectNode> findByUsername(String username);

    @Query("MATCH (n:ObjectNode) where n.`data.username` = $username RETURN COUNT(n) > 0")
    boolean existsByUsername(String username);

    @Query("MATCH (n:ObjectNode) where n.`data.email` = $email RETURN COUNT(n) > 0")
    boolean existsByEmail(String email);
}
