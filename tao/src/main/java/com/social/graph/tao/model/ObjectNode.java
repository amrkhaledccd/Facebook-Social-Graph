package com.social.graph.tao.model;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.neo4j.core.schema.*;

import java.util.ArrayList;
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
    private ObjectType type;

    @DynamicLabels
    private List<String> labels = new ArrayList<>();

    @Relationship(type = "relate_to")
    List<Association> edges = new ArrayList<>();

    public ObjectNode(ObjectType type, List<String> labels) {
        this.type = type;
        this.labels = labels;
    }
}
