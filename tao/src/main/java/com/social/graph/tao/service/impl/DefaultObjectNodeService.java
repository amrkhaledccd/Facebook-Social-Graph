package com.social.graph.tao.service.impl;

import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.repository.ObjectNodeRepository;
import com.social.graph.tao.service.ObjectNodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class DefaultObjectNodeService implements ObjectNodeService {

    @Autowired private ObjectNodeRepository repository;

    @Override
    public ObjectNode createObject(ObjectType type, List<String> label) {
        return repository.save(new ObjectNode(type, label));
    }

    @Override
    public ObjectNode findObjectById(UUID objectId) {
        return null;
    }

    @Override
    public void updateObject(UUID objectId) {

    }

    @Override
    public void deleteObject(UUID objectId) {

    }
}
