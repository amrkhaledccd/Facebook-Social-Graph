package com.social.graph.tao.model;


import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.neo4j.core.schema.*;

@RelationshipProperties
@NoArgsConstructor
@RequiredArgsConstructor
public class Association {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private AssociationType type;

    @TargetNode
    @NonNull
    private ObjectNode target;
}
