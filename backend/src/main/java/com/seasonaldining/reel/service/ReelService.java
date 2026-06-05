package com.seasonaldining.reel.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.reel.dto.response.*;
import com.seasonaldining.reel.entity.*;
import com.seasonaldining.reel.repository.*;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class ReelService {
    private static final String PUBLISHED = "PUBLISHED";
    private static final String ACTIVE = "ACTIVE";
    private final ReelRepository reels;
    private final CreatorRepository creators;
    private final ReelReactionRepository reactions;
    private final ReelCommentRepository comments;

    public ReelService(ReelRepository reels, CreatorRepository creators, ReelReactionRepository reactions, ReelCommentRepository comments) {
        this.reels = reels;
        this.creators = creators;
        this.reactions = reactions;
        this.comments = comments;
    }

    @Transactional(readOnly = true)
    public List<ReelResponse> getReels(Long userId) {
        return reels.findByStatusOrderByPublishedAtDesc(PUBLISHED, PageRequest.of(0, 20)).stream()
                .map(reel -> toResponse(reel, userId))
                .toList();
    }

    @Transactional(readOnly = true)
    public ReelResponse getReel(Long reelId, Long userId) {
        return toResponse(findPublishedReel(reelId), userId);
    }

    @Transactional
    public ReelActionResponse like(Long reelId, Long userId) {
        findPublishedReel(reelId);
        if (!reactions.existsByReelIdAndUserIdAndReactionType(reelId, userId, ReelReaction.LIKE)) {
            reactions.save(new ReelReaction(reelId, userId, ReelReaction.LIKE));
        }
        return new ReelActionResponse(reelId, true, reactions.countByReelIdAndReactionType(reelId, ReelReaction.LIKE));
    }

    @Transactional
    public ReelActionResponse unlike(Long reelId, Long userId) {
        findPublishedReel(reelId);
        reactions.findByReelIdAndUserIdAndReactionType(reelId, userId, ReelReaction.LIKE).ifPresent(reactions::delete);
        return new ReelActionResponse(reelId, false, reactions.countByReelIdAndReactionType(reelId, ReelReaction.LIKE));
    }

    @Transactional(readOnly = true)
    public List<ReelCommentResponse> getComments(Long reelId) {
        findPublishedReel(reelId);
        return comments.findByReelIdAndStatusOrderByIdAsc(reelId, ACTIVE).stream()
                .map(comment -> new ReelCommentResponse(comment.getId(), comment.getReelId(), comment.getUserId(), comment.getContent(), comment.getCreatedAt()))
                .toList();
    }

    @Transactional
    public ReelCommentResponse addComment(Long reelId, Long userId, String content) {
        findPublishedReel(reelId);
        ReelComment comment = comments.save(new ReelComment(reelId, userId, content, ACTIVE));
        return new ReelCommentResponse(comment.getId(), comment.getReelId(), comment.getUserId(), comment.getContent(), comment.getCreatedAt());
    }

    @Transactional
    public ReelResponse recordView(Long reelId, Long userId) {
        Reel reel = findPublishedReel(reelId);
        reel.incrementViewCount();
        return toResponse(reel, userId);
    }

    private Reel findPublishedReel(Long reelId) {
        return reels.findByIdAndStatus(reelId, PUBLISHED).orElseThrow(() -> new BusinessException(ErrorCode.REEL_NOT_FOUND));
    }

    private ReelResponse toResponse(Reel reel, Long userId) {
        Creator creator = creators.findById(reel.getCreatorId()).orElse(null);
        long likeCount = reactions.countByReelIdAndReactionType(reel.getId(), ReelReaction.LIKE);
        long saveCount = reactions.countByReelIdAndReactionType(reel.getId(), ReelReaction.SAVE);
        long commentCount = comments.countByReelIdAndStatus(reel.getId(), ACTIVE);
        boolean liked = userId != null && reactions.existsByReelIdAndUserIdAndReactionType(reel.getId(), userId, ReelReaction.LIKE);
        boolean saved = userId != null && reactions.existsByReelIdAndUserIdAndReactionType(reel.getId(), userId, ReelReaction.SAVE);
        return new ReelResponse(
                reel.getId(),
                reel.getRecipeId(),
                reel.getCreatorId(),
                creator == null ? null : creator.getDisplayName(),
                creator == null ? null : creator.getAvatarUrl(),
                reel.getVideoUrl(),
                reel.getThumbnailUrl(),
                reel.getTitle(),
                reel.getDescription(),
                tags(reel.getIngredientTags()),
                likeCount,
                commentCount,
                saveCount,
                reel.getViewCount(),
                reel.getDurationSeconds(),
                liked,
                saved,
                reel.getPublishedAt()
        );
    }

    private List<String> tags(String raw) {
        if (raw == null || raw.isBlank()) return List.of();
        return Arrays.stream(raw.split(",")).map(String::trim).filter(s -> !s.isBlank()).toList();
    }
}
