package com.social.graph.tao.api;

import com.social.graph.tao.model.AssociationType;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.payload.CreateObjectRequest;
import com.social.graph.tao.service.ObjectNodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/objects")
@CrossOrigin(value = "*")
public class ObjectNodeApi {

    @Autowired
    private ObjectNodeService objectNodeService;

    @GetMapping("/{objectId}/adjacents")
    public List<ObjectNode> findAdjacentObjects(
            @PathVariable UUID objectId,
            @RequestParam ObjectType type,
            @RequestParam AssociationType associationType,
            @RequestParam(required = false) Optional<Integer> limit) {
        return objectNodeService.findAdjacentObjects(objectId, limit, type, associationType);
    }

    @GetMapping("/{objectId}/adjacents/count")
    public long countAdjacentObjects(
            @PathVariable UUID objectId,
            @RequestParam ObjectType type) {
        return objectNodeService.countAdjacentObjects(objectId, type);
    }

    @GetMapping("/{objectId1}/mutual/{objectId2}")
    public List<ObjectNode> findMutualObjects(
            @PathVariable UUID objectId1,
            @PathVariable UUID objectId2,
            @RequestParam int limit,
            @RequestParam ObjectType type) {
        return objectNodeService.findMutualObjects(objectId1, objectId2, limit, type);
    }

    @GetMapping("/{objectId1}/mutual/{objectId2}/count")
    public long countMutualObjects(
            @PathVariable UUID objectId1,
            @PathVariable UUID objectId2,
            @RequestParam ObjectType type) {
        return objectNodeService.countMutualObjects(objectId1, objectId2, type);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ObjectNode createObject(@RequestBody CreateObjectRequest request) {
        return objectNodeService.createObject(request.getType(), request.getData());
    }

}
