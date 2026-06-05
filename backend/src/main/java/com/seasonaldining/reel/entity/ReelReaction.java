package com.seasonaldining.reel.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "reel_reactions")
public class ReelReaction {
    public static final String LIKE = "LIKE";
    public static final String SAVE = "SAVE";
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY) private Long id;
    @Column(name = "reel_id", nullable = false) private Long reelId;
    @Column(name = "user_id", nullable = false) private Long userId;
    @Column(name = "reaction_type", nullable = false, length = 50) private String reactionType;
    protected ReelReaction() {}
    public ReelReaction(Long reelId, Long userId, String reactionType) {
        this.reelId = reelId; this.userId = userId; this.reactionType = reactionType;
    }
    public Long getId() { return id; }
    public Long getReelId() { return reelId; }
    public Long getUserId() { return userId; }
    public String getReactionType() { return reactionType; }
}
