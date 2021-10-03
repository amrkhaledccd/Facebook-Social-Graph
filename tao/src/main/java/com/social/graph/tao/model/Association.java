package com.social.graph.tao.model;


import lombok.Getter;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.data.neo4j.core.schema.*;

import java.util.ArrayList;
import java.util.List;


@RelationshipProperties
@RequiredArgsConstructor
@Getter
public class Association {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private AssociationType type;

    @DynamicLabels
    private List<String> labels = new ArrayList<>();

    @TargetNode
    @NonNull
    private ObjectNode target;
}
