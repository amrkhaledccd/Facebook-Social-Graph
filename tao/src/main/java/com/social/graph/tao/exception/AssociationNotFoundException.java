package com.social.graph.tao.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
public class AssociationNotFoundException extends RuntimeException{
    public AssociationNotFoundException(String message) {
        super(message);
    }
}
