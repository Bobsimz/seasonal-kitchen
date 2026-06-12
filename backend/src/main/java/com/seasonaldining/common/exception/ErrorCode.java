package com.seasonaldining.common.exception;

import org.springframework.http.HttpStatus;

public enum ErrorCode {
    COMMON_INVALID_REQUEST(HttpStatus.BAD_REQUEST, "COMMON_INVALID_REQUEST", "잘못된 요청입니다."),
    COMMON_VALIDATION_FAILED(HttpStatus.BAD_REQUEST, "COMMON_VALIDATION_FAILED", "요청 값 검증에 실패했습니다."),
    COMMON_UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "COMMON_UNAUTHORIZED", "인증이 필요합니다."),
    COMMON_INTERNAL_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "COMMON_INTERNAL_ERROR", "서버 오류가 발생했습니다."),
    AUTH_INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH_INVALID_TOKEN", "유효하지 않은 토큰입니다."),
    AUTH_EMAIL_DUPLICATE(HttpStatus.CONFLICT, "AUTH_EMAIL_DUPLICATE", "이미 가입된 이메일입니다."),
    AUTH_NICKNAME_DUPLICATE(HttpStatus.CONFLICT, "AUTH_NICKNAME_DUPLICATE", "이미 사용 중인 닉네임입니다."),
    AUTH_INVALID_CREDENTIALS(HttpStatus.UNAUTHORIZED, "AUTH_INVALID_CREDENTIALS", "이메일 또는 비밀번호가 올바르지 않습니다."),
    INGREDIENT_NOT_FOUND(HttpStatus.NOT_FOUND, "INGREDIENT_NOT_FOUND", "식재료를 찾을 수 없습니다."),
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "USER_NOT_FOUND", "사용자를 찾을 수 없습니다."),
    FAVORITE_NOT_FOUND(HttpStatus.NOT_FOUND, "FAVORITE_NOT_FOUND", "찜 정보를 찾을 수 없습니다."),
    PRICE_ALERT_NOT_FOUND(HttpStatus.NOT_FOUND, "PRICE_ALERT_NOT_FOUND", "가격 알림을 찾을 수 없습니다."),
    NOTIFICATION_NOT_FOUND(HttpStatus.NOT_FOUND, "NOTIFICATION_NOT_FOUND", "알림을 찾을 수 없습니다."),
    REEL_NOT_FOUND(HttpStatus.NOT_FOUND, "REEL_NOT_FOUND", "릴스를 찾을 수 없습니다."),
    REEL_COMMENT_NOT_FOUND(HttpStatus.NOT_FOUND, "REEL_COMMENT_NOT_FOUND", "릴스 댓글을 찾을 수 없습니다."),
    RECIPE_NOT_FOUND(HttpStatus.NOT_FOUND, "RECIPE_NOT_FOUND", "레시피를 찾을 수 없습니다."),
    PRODUCER_NOT_FOUND(HttpStatus.NOT_FOUND, "PRODUCER_NOT_FOUND", "농가를 찾을 수 없습니다."),
    PRODUCER_ALREADY_REGISTERED(HttpStatus.CONFLICT, "PRODUCER_ALREADY_REGISTERED", "이미 농가로 등록되어 있습니다."),
    PRODUCER_OFFER_NOT_FOUND(HttpStatus.NOT_FOUND, "PRODUCER_OFFER_NOT_FOUND", "농가 판매 상품을 찾을 수 없습니다."),
    CART_ITEM_NOT_FOUND(HttpStatus.NOT_FOUND, "CART_ITEM_NOT_FOUND", "장바구니 항목을 찾을 수 없습니다."),
    ORDER_NOT_FOUND(HttpStatus.NOT_FOUND, "ORDER_NOT_FOUND", "주문을 찾을 수 없습니다."),
    GEMINI_API_NOT_CONFIGURED(HttpStatus.SERVICE_UNAVAILABLE, "GEMINI_API_NOT_CONFIGURED", "AI 분석 서비스가 설정되지 않았습니다."),
    GEMINI_API_ERROR(HttpStatus.BAD_GATEWAY, "GEMINI_API_ERROR", "AI 분석 중 오류가 발생했습니다."),
    GEMINI_PARSE_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "GEMINI_PARSE_ERROR", "AI 분석 결과를 처리할 수 없습니다.");

    private final HttpStatus status;
    private final String code;
    private final String message;

    ErrorCode(HttpStatus status, String code, String message) {
        this.status = status;
        this.code = code;
        this.message = message;
    }

    public HttpStatus status() {
        return status;
    }

    public String code() {
        return code;
    }

    public String message() {
        return message;
    }
}
