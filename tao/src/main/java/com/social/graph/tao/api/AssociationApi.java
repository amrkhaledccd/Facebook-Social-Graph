package com.social.graph.tao.api;

import com.social.graph.tao.payload.CreateAssociationRequest;
import com.social.graph.tao.service.AssociationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

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
}
