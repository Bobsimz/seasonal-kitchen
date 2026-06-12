package com.seasonaldining.producer.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.producer.config.GeminiProperties;
import com.seasonaldining.producer.config.GeminiPromptsProperties;
import com.seasonaldining.producer.dto.request.OfferImageGenerationRequest;
import com.seasonaldining.producer.dto.response.OfferImageGenerationResponse;
import com.seasonaldining.producer.dto.response.OfferPhotoAnalysisResponse;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import java.util.Base64;
import java.util.List;
import java.util.Map;

@Service
public class GeminiService {

    private final GeminiProperties properties;
    private final GeminiPromptsProperties prompts;
    private final RestClient restClient;
    private final ObjectMapper objectMapper;

    public GeminiService(GeminiProperties properties,
                         GeminiPromptsProperties prompts,
                         RestClient geminiRestClient,
                         ObjectMapper objectMapper) {
        this.properties = properties;
        this.prompts = prompts;
        this.restClient = geminiRestClient;
        this.objectMapper = objectMapper;
    }

    public OfferPhotoAnalysisResponse analyzeOfferPhoto(MultipartFile image) {
        if (!StringUtils.hasText(properties.key())) {
            throw new BusinessException(ErrorCode.GEMINI_API_NOT_CONFIGURED);
        }
        try {
            String base64 = Base64.getEncoder().encodeToString(image.getBytes());
            String mimeType = image.getContentType() != null ? image.getContentType() : "image/jpeg";
            String prompt = prompts.offerPhotoAnalysis().userTemplate();

            Map<String, Object> request = buildRequest(prompt, mimeType, base64);
            String url = "/v1beta/models/" + properties.model() + ":generateContent?key=" + properties.key();

            String responseBody = restClient.post()
                    .uri(url)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(request)
                    .retrieve()
                    .body(String.class);

            return parseResponse(responseBody);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.GEMINI_API_ERROR);
        }
    }

    public OfferImageGenerationResponse generateOfferImage(OfferImageGenerationRequest request) {
        if (!StringUtils.hasText(properties.key())) {
            throw new BusinessException(ErrorCode.GEMINI_API_NOT_CONFIGURED);
        }
        try {
            String prompt = buildImagePrompt(request);
            Map<String, Object> requestBody = buildImageGenerationRequest(prompt);
            String url = "/v1beta/models/" + properties.imageModel() + ":generateContent?key=" + properties.key();

            String responseBody = restClient.post()
                    .uri(url)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(requestBody)
                    .retrieve()
                    .body(String.class);

            return parseImageResponse(responseBody);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.GEMINI_API_ERROR);
        }
    }

    private String buildImagePrompt(OfferImageGenerationRequest request) {
        StringBuilder sb = new StringBuilder(prompts.offerImageGeneration().userTemplate());
        String name = StringUtils.hasText(request.productName()) ? request.productName() : request.ingredientName();
        sb.append("\n상품명: ").append(name);
        if (StringUtils.hasText(request.category())) {
            sb.append("\n카테고리: ").append(request.category());
        }
        if (request.keywords() != null && !request.keywords().isEmpty()) {
            sb.append("\n핵심 키워드: ").append(String.join(", ", request.keywords()));
        }
        return sb.toString();
    }

    private Map<String, Object> buildImageGenerationRequest(String prompt) {
        Map<String, Object> textPart = Map.of("text", prompt);
        Map<String, Object> content = Map.of("parts", List.of(textPart));
        Map<String, Object> generationConfig = Map.of("responseModalities", List.of("IMAGE"));
        return Map.of("contents", List.of(content), "generationConfig", generationConfig);
    }

    private OfferImageGenerationResponse parseImageResponse(String responseBody) {
        try {
            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode parts = root.path("candidates").get(0).path("content").path("parts");
            for (JsonNode part : parts) {
                if (part.has("inlineData")) {
                    String mimeType = part.path("inlineData").path("mimeType").asText("image/png");
                    String data = part.path("inlineData").path("data").asText();
                    return new OfferImageGenerationResponse(mimeType, data);
                }
            }
            throw new BusinessException(ErrorCode.GEMINI_PARSE_ERROR);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.GEMINI_PARSE_ERROR);
        }
    }

    private Map<String, Object> buildRequest(String prompt, String mimeType, String base64) {
        Map<String, Object> textPart = Map.of("text", prompt);
        Map<String, Object> imageData = Map.of("mimeType", mimeType, "data", base64);
        Map<String, Object> imagePart = Map.of("inlineData", imageData);
        Map<String, Object> content = Map.of("parts", List.of(textPart, imagePart));
        return Map.of("contents", List.of(content));
    }

    private OfferPhotoAnalysisResponse parseResponse(String responseBody) {
        try {
            JsonNode root = objectMapper.readTree(responseBody);
            String text = root.path("candidates").get(0)
                    .path("content").path("parts").get(0)
                    .path("text").asText();
            // Gemini 가 ```json ... ``` 코드 블록으로 감싸서 반환하는 경우 제거
            text = text.replaceAll("(?s)```json\\s*", "").replaceAll("(?s)```\\s*", "").trim();
            return objectMapper.readValue(text, OfferPhotoAnalysisResponse.class);
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.GEMINI_PARSE_ERROR);
        }
    }
}
