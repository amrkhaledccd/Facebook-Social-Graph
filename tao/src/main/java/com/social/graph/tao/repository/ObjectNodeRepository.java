package com.social.graph.tao.repository;

import com.social.graph.tao.model.ObjectNode;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import java.util.UUID;

public interface ObjectNodeRepository extends Neo4jRepository<ObjectNode, UUID> {
}
