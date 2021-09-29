package com.social.graph.tao.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

@Node
@Data
@NoArgsConstructor
@RequiredArgsConstructor
public class ObjectNode {
    @Id
    @GeneratedValue(generatorClass = GeneratedValue.UUIDGenerator.class)
    private UUID id;

    @NonNull
    private String type;

    private String data;

    @Relationship(type = "relate_to")
    List<Edge> edges = new ArrayList<>();
}
