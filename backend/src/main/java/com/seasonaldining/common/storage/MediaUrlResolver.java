package com.seasonaldining.common.storage;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

/**
 * DB에 저장된 미디어 경로를 공개 접근 URL로 변환한다.
 * <ul>
 *   <li>절대 URL({@code http://}/{@code https://})은 그대로 반환한다(외부/데모 URL 보존).</li>
 *   <li>상대 key({@code reels/abc.mp4})는 {@code app.uploads.public-base-url}(CloudFront 도메인)을 앞에 붙인다.</li>
 * </ul>
 * base-url이 비어 있으면(로컬 개발 등) 루트 상대 경로({@code /reels/abc.mp4})를 반환한다.
 */
@Component
public class MediaUrlResolver {

    private final String publicBaseUrl;

    public MediaUrlResolver(@Value("${app.uploads.public-base-url:}") String publicBaseUrl) {
        this.publicBaseUrl = publicBaseUrl == null ? "" : publicBaseUrl.replaceAll("/+$", "");
    }

    public String resolve(String value) {
        if (value == null || value.isBlank()) {
            return value;
        }
        if (value.startsWith("http://") || value.startsWith("https://")) {
            return value;
        }
        String key = value.replaceAll("^/+", "");
        return publicBaseUrl.isBlank() ? "/" + key : publicBaseUrl + "/" + key;
    }
}
