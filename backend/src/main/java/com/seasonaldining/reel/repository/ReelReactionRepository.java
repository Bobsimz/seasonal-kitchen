package com.seasonaldining.reel.repository;

import com.seasonaldining.reel.entity.ReelReaction;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface ReelReactionRepository extends JpaRepository<ReelReaction, Long> {
    long countByReelIdAndReactionType(Long reelId, String reactionType);
    boolean existsByReelIdAndUserIdAndReactionType(Long reelId, Long userId, String reactionType);
    Optional<ReelReaction> findByReelIdAndUserIdAndReactionType(Long reelId, Long userId, String reactionType);
}
