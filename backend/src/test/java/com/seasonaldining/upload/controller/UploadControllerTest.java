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
}
