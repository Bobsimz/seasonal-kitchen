package com.seasonaldining.reel.service;

import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.common.storage.MediaUrlResolver;
import com.seasonaldining.ingredient.entity.Ingredient;
import com.seasonaldining.ingredient.repository.IngredientRepository;
import com.seasonaldining.reel.dto.response.*;
import com.seasonaldining.reel.entity.*;
import com.seasonaldining.reel.repository.*;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ReelService {
    private static final String PUBLISHED = "PUBLISHED";
    private static final String ACTIVE = "ACTIVE";
    private final ReelRepository reels;
    private final CreatorRepository creators;
    private final ReelReactionRepository reactions;
    private final ReelCommentRepository comments;
    private final UserRepository users;
    private final IngredientRepository ingredients;
    private final MediaUrlResolver mediaUrls;

    public ReelService(ReelRepository reels, CreatorRepository creators, ReelReactionRepository reactions, ReelCommentRepository comments, UserRepository users, IngredientRepository ingredients, MediaUrlResolver mediaUrls) {
        this.reels = reels;
        this.creators = creators;
        this.reactions = reactions;
        this.comments = comments;
        this.users = users;
        this.ingredients = ingredients;
        this.mediaUrls = mediaUrls;
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

    @Transactional
    public ReelSaveActionResponse save(Long reelId, Long userId) {
        findPublishedReel(reelId);
        if (!reactions.existsByReelIdAndUserIdAndReactionType(reelId, userId, ReelReaction.SAVE)) {
            reactions.save(new ReelReaction(reelId, userId, ReelReaction.SAVE));
        }
        return new ReelSaveActionResponse(reelId, true, reactions.countByReelIdAndReactionType(reelId, ReelReaction.SAVE));
    }

    @Transactional
    public ReelSaveActionResponse unsave(Long reelId, Long userId) {
        findPublishedReel(reelId);
        reactions.findByReelIdAndUserIdAndReactionType(reelId, userId, ReelReaction.SAVE).ifPresent(reactions::delete);
        return new ReelSaveActionResponse(reelId, false, reactions.countByReelIdAndReactionType(reelId, ReelReaction.SAVE));
    }

    @Transactional(readOnly = true)
    public List<ReelCommentResponse> getComments(Long reelId) {
        findPublishedReel(reelId);
        List<ReelComment> list = comments.findByReelIdAndStatusOrderByIdAsc(reelId, ACTIVE);
        Map<Long, User> authors = loadAuthors(list.stream().map(ReelComment::getUserId).toList());
        return list.stream().map(comment -> toCommentResponse(comment, authors.get(comment.getUserId()))).toList();
    }

    @Transactional
    public ReelCommentResponse addComment(Long reelId, Long userId, String content) {
        findPublishedReel(reelId);
        ReelComment comment = comments.save(new ReelComment(reelId, userId, content, ACTIVE));
        return toCommentResponse(comment, users.findById(userId).orElse(null));
    }

    // 댓글 작성자(닉네임/프로필)를 한 번에 로딩해 N+1 을 피한다.
    private Map<Long, User> loadAuthors(List<Long> userIds) {
        if (userIds.isEmpty()) return Map.of();
        return users.findAllById(new HashSet<>(userIds)).stream()
                .collect(Collectors.toMap(User::getId, user -> user));
    }

    private ReelCommentResponse toCommentResponse(ReelComment comment, User author) {
        return new ReelCommentResponse(
                comment.getId(),
                comment.getReelId(),
                comment.getUserId(),
                author == null ? null : author.getNickname(),
                author == null ? null : mediaUrls.resolve(author.getProfileImageUrl()),
                comment.getContent(),
                comment.getCreatedAt()
        );
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
        // 표시용 = 실제 사용자 액션(reactions/comments) 기준. V49 시드 baseline(reels.*_count)은
        // 보여주기용이라 합산하지 않는다 — DB 컬럼은 그대로 두고 코드에서만 무시한다.
        long likeCount = reactions.countByReelIdAndReactionType(reel.getId(), ReelReaction.LIKE);
        long saveCount = reactions.countByReelIdAndReactionType(reel.getId(), ReelReaction.SAVE);
        long commentCount = comments.countByReelIdAndStatus(reel.getId(), ACTIVE);
        boolean liked = userId != null && reactions.existsByReelIdAndUserIdAndReactionType(reel.getId(), userId, ReelReaction.LIKE);
        boolean saved = userId != null && reactions.existsByReelIdAndUserIdAndReactionType(reel.getId(), userId, ReelReaction.SAVE);
        List<String> tagNames = tags(reel.getIngredientTags());
        return new ReelResponse(
                reel.getId(),
                reel.getRecipeId(),
                reel.getCreatorId(),
                creator == null ? null : creator.getDisplayName(),
                creator == null ? null : mediaUrls.resolve(creator.getAvatarUrl()),
                mediaUrls.resolve(reel.getVideoUrl()),
                mediaUrls.resolve(reel.getThumbnailUrl()),
                reel.getTitle(),
                reel.getDescription(),
                tagNames,
                ingredientRefs(tagNames),
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

    /**
     * 재료 태그 이름을 카탈로그 식재료 id와 매칭해 바로가기 항목으로 만든다.
     * 매칭되는 활성 식재료가 있으면 id를 채우고(상세 링크 가능), 없으면 id=null(프론트는 검색 폴백).
     * 태그 이름 순서를 유지한다.
     */
    private List<ReelResponse.IngredientRef> ingredientRefs(List<String> tagNames) {
        if (tagNames.isEmpty()) return List.of();
        Map<String, Long> nameToId = ingredients.findByNameInAndActiveTrue(tagNames).stream()
                .collect(Collectors.toMap(Ingredient::getName, Ingredient::getId, (a, b) -> a));
        return tagNames.stream()
                .map(name -> new ReelResponse.IngredientRef(nameToId.get(name), name))
                .toList();
    }

    private List<String> tags(String raw) {
        if (raw == null || raw.isBlank()) return List.of();
        return Arrays.stream(raw.split(",")).map(String::trim).filter(s -> !s.isBlank()).toList();
    }
}
