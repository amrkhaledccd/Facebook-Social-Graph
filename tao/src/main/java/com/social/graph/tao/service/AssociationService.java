package com.social.graph.tao.service;

import com.social.graph.tao.model.AssociationType;

import java.util.UUID;

public interface AssociationService {
    void createAssociation(UUID startObjId, UUID endObjId, AssociationType associationType);
}
