package com.social.graph.tao.payload;

import com.social.graph.tao.model.ObjectType;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Map;

@Data
@AllArgsConstructor
public class CreateObjectRequest {
    private ObjectType type;
    private Map<String, String> data;
}
