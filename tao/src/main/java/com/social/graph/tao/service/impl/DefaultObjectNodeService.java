package com.social.graph.tao.service.impl;

import com.social.graph.tao.exception.ObjectNotFoundException;
import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.repository.ObjectNodeRepository;
import com.social.graph.tao.service.ObjectNodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

@Service
public class DefaultObjectNodeService implements ObjectNodeService {

    @Autowired private ObjectNodeRepository repository;

    @Override
    public ObjectNode createObject(ObjectType type, Map<String, String> data) {
        var objectNode = new ObjectNode(type);
        if(data != null) objectNode.setData(data);
        return repository.save(objectNode);
    }

    @Override
    public ObjectNode findObjectById(UUID objectId) {
        return repository
                .findById(objectId)
                .orElseThrow(() -> new ObjectNotFoundException(String.format("Object [%s] not found", objectId)));
    }

    @Override
    public List<ObjectNode> findObjectsByType(ObjectType type) {
        return repository.findByType(type);
    }

    @Override
    public List<ObjectNode> findAdjacentObjects(
            UUID objectId, Optional<Integer> limit, ObjectType type, AssociationType associationType) {
        findObjectById(objectId);
        return limit
                .map(value -> repository.findAdjacentObjectsWithLimit(objectId, value, type))
                .orElse(repository.findAdjacentObjects(objectId, type, associationType));
    }

    @Override
    public long countAdjacentObjects(UUID objectId, ObjectType type) {
        return repository.countAdjacentObjects(objectId, type);
    }

    @Override
    public List<ObjectNode> findMutualObjects(UUID objId1, UUID objId2, int limit, ObjectType type) {
        return repository.findMutualObjectsWithLimit(objId1, objId2, limit, type);
    }

    @Override
    public long countMutualObjects(UUID objId1, UUID objId2, ObjectType type) {
        return repository.countMutualObjectsWith(objId1, objId2, type);
    }

    @Override
    public List<ObjectNode> findObjectsWhereRelationNotExists(UUID objectId, ObjectType objectType, AssociationType associationType) {
        return repository.findObjectsWhereRelationNotExists(objectId, objectType, associationType);
    }

    @Override
    public void updateObject(UUID objectId) {

    }

    @Override
    public void deleteObject(UUID objectId) {

    }

    // This is a dummy function to generate user feed just for the sake of demo.
    @Override
    public List<ObjectNode> findUserFeed(UUID userId) {
        return repository.findUserFeed(userId);
    }
}
