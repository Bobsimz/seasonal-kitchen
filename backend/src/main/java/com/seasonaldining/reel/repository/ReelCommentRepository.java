package com.seasonaldining.reel.repository;

import com.seasonaldining.reel.entity.ReelComment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ReelCommentRepository extends JpaRepository<ReelComment, Long> {
    List<ReelComment> findByReelIdAndStatusOrderByIdAsc(Long reelId, String status);
    long countByReelIdAndStatus(Long reelId, String status);
}
