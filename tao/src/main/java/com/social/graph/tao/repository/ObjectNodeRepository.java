package com.social.graph.tao.repository;

import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;

import java.util.List;
import java.util.UUID;

public interface ObjectNodeRepository extends Neo4jRepository<ObjectNode, UUID> {

    @Query("MATCH (n:ObjectNode{id:$objectId}) -[r]-> (p:ObjectNode{type:$type}) return p")
    List<ObjectNode> findAdjacentObjects(UUID objectId, ObjectType type);

    @Query("MATCH (n:ObjectNode{id:$startObjId}) -[r:relate_to{type:$type}]-> (m:ObjectNode{id:$endObjId}) RETURN COUNT(r) > 0")
    boolean associationExists(UUID startObjId, UUID endObjId, AssociationType type);
}
