package com.social.graph.tao.service;

import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;

import java.util.List;
import java.util.UUID;

public interface ObjectNodeService {
    ObjectNode createObject(ObjectType type, List<String> labels);
    ObjectNode findObjectById(UUID objectId);
    void updateObject(UUID objectId);
    void deleteObject(UUID objectId);
}
