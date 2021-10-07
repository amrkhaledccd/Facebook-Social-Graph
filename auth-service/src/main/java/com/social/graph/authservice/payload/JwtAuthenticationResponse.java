package com.social.graph.authservice.payload;


import com.social.graph.authservice.model.ObjectNode;
import lombok.Data;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class JwtAuthenticationResponse {

    @NonNull
    private String accessToken;

    @NonNull
    private ObjectNode user;

    private String tokenType = "Bearer";
}
