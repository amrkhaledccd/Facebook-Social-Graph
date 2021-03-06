package com.social.graph.tao.api;

import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.payload.CreateAssociationRequest;
import com.social.graph.tao.service.AssociationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/associations")
public class AssociationApi {

    @Autowired
    private AssociationService associationService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public void createAssociation(@RequestBody CreateAssociationRequest request) {
        associationService.createAssociation(request.getStartObjectId(), request.getEndObjectId(), request.getType());
    }

    @GetMapping("/{id1}/{id2}")
    public void findAssociation(
            @PathVariable UUID id1, @PathVariable UUID id2, @RequestParam AssociationType type) {
        associationService.associationExists(id1, id2, type);
    }

    @GetMapping("/{objectId}/count")
    public long countAssociation(
            @PathVariable UUID objectId, @RequestParam AssociationType type, ObjectType objectType) {
        return associationService.countAssociation(objectId, type, objectType);
    }

    @DeleteMapping("/{id1}/{id2}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteAssociation(
            @PathVariable UUID id1, @PathVariable UUID id2, @RequestParam AssociationType type) {
        associationService.deleteAssociation(id1, id2, type);
    }
}
