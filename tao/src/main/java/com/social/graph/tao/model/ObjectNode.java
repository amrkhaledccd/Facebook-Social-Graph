package com.social.graph.tao.model;

import lombok.*;
import org.springframework.data.neo4j.core.schema.*;
import java.util.*;

@Node
@Data
@RequiredArgsConstructor
public class ObjectNode {
    @Id
    @GeneratedValue(generatorClass = GeneratedValue.UUIDGenerator.class)
    private UUID id;

    @NonNull
    private ObjectType type;

    @Relationship(type = "relate_to")
    private List<Association> edges = new ArrayList<>();

    @CompositeProperty
    private Map<String, String> data = new HashMap<>();
}

