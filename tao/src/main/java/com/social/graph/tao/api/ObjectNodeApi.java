package com.social.graph.tao.api;

import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.model.ObjectType;
import com.social.graph.tao.payload.CreateObjectRequest;
import com.social.graph.tao.service.ObjectNodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/objects")
@CrossOrigin(value = "*")
public class ObjectNodeApi {

    @Autowired
    private ObjectNodeService objectNodeService;

    @GetMapping("/{objectId}/adjacents")
    public List<ObjectNode> findAdjacentObjects(@PathVariable UUID objectId, @RequestParam ObjectType type) {
        return objectNodeService.findAdjacentObjects(objectId, type);
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ObjectNode createObject(@RequestBody CreateObjectRequest request) {
        return objectNodeService.createObject(request.getType(), request.getData());
    }

}
