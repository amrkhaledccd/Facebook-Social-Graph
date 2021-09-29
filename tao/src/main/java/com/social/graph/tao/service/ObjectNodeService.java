package com.social.graph.tao.service;

import com.social.graph.tao.model.Edge;
import com.social.graph.tao.model.ObjectNode;
import com.social.graph.tao.repository.ObjectNodeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class ObjectNodeService {

    @Autowired private ObjectNodeRepository repository;

    public void save(String userId1, String userId2) {
       var node1 = repository.save(new ObjectNode("user"));
        var node2 = repository.save(new ObjectNode("group"));

        node1.getEdges().add(new Edge("joined", node2));
        node2.getEdges().add(new Edge("member", node1));

        repository.save(node1);
    }
}
