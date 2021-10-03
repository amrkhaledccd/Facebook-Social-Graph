package com.social.graph.tao.model;

public enum AssociationType {
    FRIEND, CREATED, CREATED_BY, LIKED, LIKED_BY, JOINED, MEMBER_OF;

    public AssociationType reverseAssociation() {
        return switch (this) {
            case CREATED -> CREATED_BY;
            case CREATED_BY -> CREATED;
            case LIKED -> LIKED_BY;
            case LIKED_BY -> LIKED;
            case JOINED -> MEMBER_OF;
            case MEMBER_OF -> JOINED;
            default -> FRIEND;
        };
    }
}
