package com.social.graph.tao.service.impl;

import com.social.graph.tao.exception.ObjectNotFoundException;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.repository.ObjectNodeRepository;
import com.social.graph.tao.service.ObjectNodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
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
    public List<ObjectNode> findAdjacentObjects(UUID objectId, ObjectType type) {
        findObjectById(objectId);
        return repository.findAdjacentObjects(objectId, type);
    }

    @Override
    public void updateObject(UUID objectId) {

    }

    @Override
    public void deleteObject(UUID objectId) {

    }
}
