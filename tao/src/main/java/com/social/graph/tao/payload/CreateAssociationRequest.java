package com.social.graph.tao.payload;

import com.social.graph.tao.model.AssociationType;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.UUID;

@Data
@AllArgsConstructor
public class CreateAssociationRequest {
    private UUID startObjectId;
    private UUID endObjectId;
    private AssociationType type;
}
