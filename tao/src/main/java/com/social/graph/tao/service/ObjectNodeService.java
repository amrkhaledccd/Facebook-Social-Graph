package com.social.graph.tao.service;

import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;

import java.util.List;
import java.util.Map;
import java.util.UUID;

public interface ObjectNodeService {
    ObjectNode createObject(ObjectType type, Map<String, String> data);
    ObjectNode findObjectById(UUID objectId);
    List<ObjectNode> findAdjacentObjects(UUID objectId, ObjectType type);
    void updateObject(UUID objectId);
    void deleteObject(UUID objectId);
}
