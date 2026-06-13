package com.seasonaldining.upload.controller;

import com.seasonaldining.common.security.JwtTokenProvider;
import com.seasonaldining.support.UserDataCleaner;
import com.seasonaldining.user.entity.User;
import com.seasonaldining.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@TestPropertySource(properties = "app.uploads.max-bytes=1024")  // 1KB로 낮춰 크기 초과를 작은 파일로 테스트
class UploadControllerTest {

    @Autowired MockMvc mvc;
    @Autowired JwtTokenProvider jwt;
    @Autowired UserRepository userRepository;
    @Autowired JdbcTemplate jdbc;

    private String token;

    @BeforeEach
    void setUp() {
        UserDataCleaner.clean(jdbc);
        User user = userRepository.save(new User("uploader@example.com", "업로더", null, "ACTIVE"));
        token = "Bearer " + jwt.createAccessToken(user.getId());
    }

    @Test
    void uploadImage_succeeds_returnsUrl() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "photo.png", "image/png", new byte[]{1, 2, 3, 4, 5});
        mvc.perform(multipart("/api/v1/uploads").file(file).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.url").value(org.hamcrest.Matchers.startsWith("/uploads/images/")))
                .andExpect(jsonPath("$.data.url").value(org.hamcrest.Matchers.endsWith(".png")));
    }

    @Test
    void nonImageFile_isRejected() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "note.txt", "text/plain", "hello".getBytes());
        mvc.perform(multipart("/api/v1/uploads").file(file).header("Authorization", token))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error.code").value("INVALID_FILE_TYPE"));
    }

    @Test
    void oversizeFile_isRejected() throws Exception {
        byte[] big = new byte[2048]; // 2KB > 1KB 한도
        MockMultipartFile file = new MockMultipartFile("file", "big.png", "image/png", big);
        mvc.perform(multipart("/api/v1/uploads").file(file).header("Authorization", token))
                .andExpect(status().isPayloadTooLarge())
                .andExpect(jsonPath("$.error.code").value("FILE_TOO_LARGE"));
    }

    @Test
    void emptyFile_isRejected() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "empty.png", "image/png", new byte[0]);
        mvc.perform(multipart("/api/v1/uploads").file(file).header("Authorization", token))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error.code").value("EMPTY_FILE"));
    }

    @Test
    void unauthenticated_isRejected() throws Exception {
        MockMultipartFile file = new MockMultipartFile("file", "photo.png", "image/png", new byte[]{1, 2, 3});
        mvc.perform(multipart("/api/v1/uploads").file(file))
                .andExpect(status().isUnauthorized());
    }

    // ── /batch ──────────────────────────────────────────────────

    @Test
    void uploadBatch_multipleImages_returnsUrlList() throws Exception {
        MockMultipartFile f1 = new MockMultipartFile("files", "a.png", "image/png", new byte[]{1, 2, 3});
        MockMultipartFile f2 = new MockMultipartFile("files", "b.jpg", "image/jpeg", new byte[]{4, 5, 6});
        mvc.perform(multipart("/api/v1/uploads/batch").file(f1).file(f2).header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data.length()").value(2))
                .andExpect(jsonPath("$.data[0].url").exists())
                .andExpect(jsonPath("$.data[1].url").exists());
    }

    @Test
    void uploadBatch_tooManyFiles_isRejected() throws Exception {
        MockMultipartFile[] files = new MockMultipartFile[11];
        for (int i = 0; i < 11; i++) {
            files[i] = new MockMultipartFile("files", "img" + i + ".png", "image/png", new byte[]{1, 2});
        }
        var req = multipart("/api/v1/uploads/batch")
                .file(files[0]).file(files[1]).file(files[2]).file(files[3]).file(files[4])
                .file(files[5]).file(files[6]).file(files[7]).file(files[8]).file(files[9])
                .file(files[10])
                .header("Authorization", token);
        mvc.perform(req)
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error.code").value("TOO_MANY_FILES"));
    }

    @Test
    void uploadBatch_containsInvalidType_isRejected() throws Exception {
        MockMultipartFile valid = new MockMultipartFile("files", "ok.png", "image/png", new byte[]{1, 2, 3});
        MockMultipartFile invalid = new MockMultipartFile("files", "bad.txt", "text/plain", "hi".getBytes());
        mvc.perform(multipart("/api/v1/uploads/batch").file(valid).file(invalid).header("Authorization", token))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.error.code").value("INVALID_FILE_TYPE"));
    }
}
