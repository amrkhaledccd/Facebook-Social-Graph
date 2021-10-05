package com.social.graph.authservice.model;

import lombok.Data;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.neo4j.core.schema.*;

import java.time.Instant;
import java.util.*;

@Node
@Data
@RequiredArgsConstructor
public class ObjectNode {

    @Id
    @GeneratedValue(generatorClass = GeneratedValue.UUIDGenerator.class)
    private UUID id;

    @NonNull
    private String type;

    @CreatedDate
    private Instant createdAt;

    @LastModifiedDate
    private Instant updatedAt;

    @NonNull
    @CompositeProperty
    private Map<String, String> data;
}

