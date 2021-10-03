package com.social.graph.tao.service.impl;

import com.social.graph.tao.exception.ObjectNotFoundException;
import com.social.graph.tao.model.Association;
import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.repository.ObjectNodeRepository;
import com.social.graph.tao.service.AssociationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;
import static java.lang.String.format;

@Service
public class DefaultAssociationService implements AssociationService {
    @Autowired ObjectNodeRepository repository;

    @Override
    public void createAssociation(UUID startObjId, UUID endObjId, AssociationType associationType) {
        var startObj = findObjectById(startObjId);
        var endObj = findObjectById(endObjId);

        var exists = repository.associationExists(startObjId, endObjId, associationType);
        if(!exists) {
            startObj.getEdges().add(new Association(associationType, endObj));
            endObj.getEdges().add(new Association(associationType.reverseAssociation(), startObj));
            repository.save(startObj);
        }
    }

    private ObjectNode findObjectById(UUID id) {
        return repository
                .findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(format("Object [%s] not found", id)));
    }
}
