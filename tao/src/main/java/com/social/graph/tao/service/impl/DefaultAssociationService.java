package com.social.graph.tao.service.impl;

import com.social.graph.tao.exception.AssociationNotFoundException;
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

    @Override
    public void associationExists(UUID id1, UUID id2, AssociationType type) {
        if(!repository.associationExists(id1, id2, type)) {
            throw new AssociationNotFoundException(String.format("No association found of %s", type));
        }
    }

    @Override
    public void deleteAssociation(UUID objId1, UUID objId2, AssociationType type) {
        repository.deleteAssociation(objId1, objId2, type);
        repository.deleteAssociation(objId2, objId1, type.reverseAssociation());
    }

    private ObjectNode findObjectById(UUID id) {
        return repository
                .findById(id)
                .orElseThrow(() -> new ObjectNotFoundException(format("Object [%s] not found", id)));
    }
}
