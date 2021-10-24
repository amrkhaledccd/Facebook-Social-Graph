package com.social.graph.tao.service;

import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectType;

import java.util.UUID;

public interface AssociationService {
    void createAssociation(UUID startObjId, UUID endObjId, AssociationType associationType);
    void associationExists(UUID id1, UUID id2, AssociationType type);
    long countAssociation(UUID startObjId, AssociationType type, ObjectType objectTypeobjectType);
    void deleteAssociation(UUID objId1, UUID objId2, AssociationType type);
}
