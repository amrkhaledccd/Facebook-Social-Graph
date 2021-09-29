package com.social.graph.tao.model;


import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.RelationshipProperties;
import org.springframework.data.neo4j.core.schema.TargetNode;


@RelationshipProperties
@NoArgsConstructor
@RequiredArgsConstructor
public class Edge {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String type;

    @TargetNode
    @NonNull
    private ObjectNode target;
}
