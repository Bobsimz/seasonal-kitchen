package com.seasonaldining.common.storage;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class MediaUrlResolverTest {

    @Test
    void resolvesRelativeKeyAgainstPublicBaseUrl() {
        MediaUrlResolver resolver = new MediaUrlResolver("https://cdn.example.com");
        assertThat(resolver.resolve("reels/abc.mp4")).isEqualTo("https://cdn.example.com/reels/abc.mp4");
    }

    @Test
    void keepsAbsoluteUrlUnchanged() {
        MediaUrlResolver resolver = new MediaUrlResolver("https://cdn.example.com");
        assertThat(resolver.resolve("https://example.com/video.mp4")).isEqualTo("https://example.com/video.mp4");
        assertThat(resolver.resolve("http://example.com/thumb.png")).isEqualTo("http://example.com/thumb.png");
    }

    @Test
    void normalizesTrailingAndLeadingSlashes() {
        MediaUrlResolver resolver = new MediaUrlResolver("https://cdn.example.com/");
        assertThat(resolver.resolve("/reels/abc.mp4")).isEqualTo("https://cdn.example.com/reels/abc.mp4");
    }

    @Test
    void returnsNullAndBlankUnchanged() {
        MediaUrlResolver resolver = new MediaUrlResolver("https://cdn.example.com");
        assertThat(resolver.resolve(null)).isNull();
        assertThat(resolver.resolve("")).isEqualTo("");
    }

    @Test
    void withoutBaseUrlReturnsRootRelativeKey() {
        MediaUrlResolver resolver = new MediaUrlResolver("");
        assertThat(resolver.resolve("reels/abc.mp4")).isEqualTo("/reels/abc.mp4");
        assertThat(resolver.resolve("https://example.com/video.mp4")).isEqualTo("https://example.com/video.mp4");
    }
}
