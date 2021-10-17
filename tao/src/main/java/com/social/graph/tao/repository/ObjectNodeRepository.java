package com.social.graph.tao.repository;

import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.data.neo4j.repository.query.Query;
import java.util.List;
import java.util.UUID;

public interface ObjectNodeRepository extends Neo4jRepository<ObjectNode, UUID> {

    @Query("MATCH (n:ObjectNode{id:$objectId}) -[r:relate_to{type: $associationType}]-> (p:ObjectNode{type:$type}) return p")
    List<ObjectNode> findAdjacentObjects(UUID objectId, ObjectType type, AssociationType associationType);

    @Query("MATCH (n:ObjectNode{id:$objectId}) -[r]-> (p:ObjectNode{type:$type}) return count(p)")
    long countAdjacentObjects(UUID objectId, ObjectType type);

    @Query("MATCH (n:ObjectNode{id:$objectId}) -[r]-> (p:ObjectNode{type:$type}) return p limit $limit")
    List<ObjectNode> findAdjacentObjectsWithLimit(UUID objectId, int limit, ObjectType type);

    @Query("MATCH (:ObjectNode{id: $objId1}) -[:relate_to]->(m:ObjectNode{type: $type})<-[:relate_to]- " +
            "(:ObjectNode{id: $objId2}) return m limit $limit")
    List<ObjectNode> findMutualObjectsWithLimit(UUID objId1, UUID objId2, int limit, ObjectType type);

    @Query("MATCH (:ObjectNode{id: $objId1}) -[:relate_to]->(m:ObjectNode{type: $type})<-[:relate_to]- " +
            "(:ObjectNode{id: $objId2}) return count(m)")
    long countMutualObjectsWith(UUID objId1, UUID objId2, ObjectType type);

    @Query("MATCH (n:ObjectNode{id:$startObjId}) -[r:relate_to{type:$type}]- (m:ObjectNode{id:$endObjId}) RETURN COUNT(r) > 0")
    boolean associationExists(UUID startObjId, UUID endObjId, AssociationType type);

    @Query("MATCH (:ObjectNode{id:$startObjId}) -[r:relate_to{type:$type}]- (:ObjectNode) RETURN COUNT(r)")
    long countAssociation(UUID startObjId, AssociationType type);

    @Query("MATCH (:ObjectNode{id: $objId1}) -[r:relate_to{type: $type}]- (:ObjectNode{id: $objId2}) delete r")
    void deleteAssociation(UUID objId1, UUID objId2, AssociationType type);
}
