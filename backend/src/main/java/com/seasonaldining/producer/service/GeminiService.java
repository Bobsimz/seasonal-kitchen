package com.seasonaldining.producer.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.seasonaldining.common.exception.BusinessException;
import com.seasonaldining.common.exception.ErrorCode;
import com.seasonaldining.producer.config.GeminiProperties;
import com.seasonaldining.producer.config.GeminiPromptsProperties;
import com.seasonaldining.producer.dto.request.GenerateDescriptionRequest;
import com.seasonaldining.producer.dto.request.OfferImageGenerationRequest;
import com.seasonaldining.producer.dto.response.GenerateDescriptionResponse;
import com.seasonaldining.producer.dto.response.OfferImageGenerationResponse;
import com.seasonaldining.producer.dto.response.OfferPhotoAnalysisResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.client.RestClient;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.IIOImage;
import javax.imageio.ImageIO;
import javax.imageio.ImageWriteParam;
import javax.imageio.ImageWriter;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import java.util.List;
import java.util.Map;

@Service
public class GeminiService {

    private static final Logger log = LoggerFactory.getLogger(GeminiService.class);

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
            byte[] imageBytes = compressImage(image);
            String base64 = Base64.getEncoder().encodeToString(imageBytes);
            log.info("[GeminiService] 이미지 압축 후 base64 길이: {} chars ({} KB)", base64.length(), base64.length() / 1024);
            String mimeType = "image/jpeg";
            String prompt = prompts.offerPhotoAnalysis().userTemplate();

            Map<String, Object> request = buildRequest(prompt, mimeType, base64);
            String url = "/gmsapi/generativelanguage.googleapis.com/v1beta/models/" + properties.visionModel() + ":generateContent";

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
            log.error("[GeminiService] analyzeOfferPhoto 오류: {}", e.getMessage(), e);
            throw new BusinessException(ErrorCode.GEMINI_API_ERROR);
        }
    }

    public OfferImageGenerationResponse generateOfferImageFromPhoto(MultipartFile image, String farmPhotoUrl) {
        if (!StringUtils.hasText(properties.key())) {
            throw new BusinessException(ErrorCode.GEMINI_API_NOT_CONFIGURED);
        }
        try {
            byte[] originalBytes = image.getBytes();
            BufferedImage originalBuf = ImageIO.read(new java.io.ByteArrayInputStream(originalBytes));
            int origW = originalBuf != null ? originalBuf.getWidth() : 0;
            int origH = originalBuf != null ? originalBuf.getHeight() : 0;

            byte[] compressed = compressForGeneration(originalBytes, originalBuf);
            String base64 = Base64.getEncoder().encodeToString(compressed);
            String aspectDesc = (origW > 0 && origH > 0) ? describeAspectRatio(origW, origH) : "1:1";

            byte[] farmImageBytes = loadFarmImage(farmPhotoUrl);
            boolean hasFarmImage = farmImageBytes != null;

            String prompt = buildImagePrompt(aspectDesc, hasFarmImage);

            Map<String, Object> textPart = Map.of("text", prompt);
            Map<String, Object> productImageData = Map.of("mimeType", "image/jpeg", "data", base64);
            Map<String, Object> productImagePart = Map.of("inlineData", productImageData);

            java.util.List<Map<String, Object>> parts = new java.util.ArrayList<>();
            parts.add(textPart);
            parts.add(productImagePart);
            if (hasFarmImage) {
                String farmBase64 = Base64.getEncoder().encodeToString(farmImageBytes);
                Map<String, Object> farmImageData = Map.of("mimeType", "image/jpeg", "data", farmBase64);
                parts.add(Map.of("inlineData", farmImageData));
            }

            Map<String, Object> content = Map.of("parts", parts);
            Map<String, Object> generationConfig = Map.of("responseModalities", List.of("IMAGE"));
            Map<String, Object> requestBody = Map.of(
                    "contents", List.of(content),
                    "generationConfig", generationConfig
            );

            String url = "/gmsapi/generativelanguage.googleapis.com/v1beta/models/" + properties.imageModel() + ":generateContent";

            String responseBody = restClient.post()
                    .uri(url)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(requestBody)
                    .retrieve()
                    .body(String.class);

            OfferImageGenerationResponse response = parseImageResponse(responseBody);
            if (origW > 0 && origH > 0) {
                response = cropToAspectRatio(response, origW, origH);
            }
            return response;
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("[GeminiService] generateOfferImageFromPhoto 오류: {}", e.getMessage(), e);
            throw new BusinessException(ErrorCode.GEMINI_API_ERROR);
        }
    }

    private String buildImagePrompt(String aspectDesc, boolean hasFarmImage) {
        StringBuilder sb = new StringBuilder();
        if (hasFarmImage) {
            sb.append("첫 번째 사진은 상품 사진이고, 두 번째 사진은 농가(배경) 사진입니다.\n");
            sb.append("두 사진을 참고하여 상품과 농가의 자연스러운 분위기가 어우러진 홍보 사진을 생성해주세요.\n");
            sb.append("농가의 환경과 배경을 살리면서 상품이 화면의 주인공이 되어야 합니다.\n");
        } else {
            sb.append("이 상품 사진을 참고하여 새로운 상품 홍보 사진을 생성해주세요.\n");
            sb.append("참고 사진과 유사한 구도와 스타일로 생성해주세요.\n");
        }
        sb.append("규칙:\n");
        sb.append("- 글씨, 텍스트, 라벨, 워터마크, 숫자가 절대 포함되면 안 됩니다\n");
        sb.append("- 신선하고 자연스러운 식재료 사진이어야 합니다\n");
        sb.append("- 배경은 깔끔하게 유지해주세요\n");
        sb.append("- 이미지 비율은 ").append(aspectDesc).append(" 이어야 합니다");
        return sb.toString();
    }

    private byte[] loadFarmImage(String farmPhotoUrl) {
        if (!StringUtils.hasText(farmPhotoUrl)) return null;
        try {
            java.net.URL url = new java.net.URL(farmPhotoUrl);
            byte[] rawBytes;
            try (java.io.InputStream is = url.openStream()) {
                rawBytes = is.readAllBytes();
            }
            BufferedImage buf = ImageIO.read(new java.io.ByteArrayInputStream(rawBytes));
            if (buf == null) return null;
            return compressForGeneration(rawBytes, buf);
        } catch (Exception e) {
            log.warn("[GeminiService] 농가 이미지 로드 실패, 농가 이미지 없이 생성: {}", e.getMessage());
            return null;
        }
    }

    private OfferImageGenerationResponse cropToAspectRatio(OfferImageGenerationResponse response, int origW, int origH) {
        try {
            byte[] imageBytes = Base64.getDecoder().decode(response.imageData());
            BufferedImage generated = ImageIO.read(new java.io.ByteArrayInputStream(imageBytes));
            if (generated == null) return response;

            int gw = generated.getWidth();
            int gh = generated.getHeight();
            double targetRatio = (double) origW / origH;
            double currentRatio = (double) gw / gh;
            if (Math.abs(targetRatio - currentRatio) < 0.02) return response;

            int cropW, cropH, cropX = 0, cropY = 0;
            if (targetRatio > currentRatio) {
                cropW = gw;
                cropH = Math.max(1, (int) (gw / targetRatio));
                cropY = (gh - cropH) / 2;
            } else {
                cropH = gh;
                cropW = Math.max(1, (int) (gh * targetRatio));
                cropX = (gw - cropW) / 2;
            }
            cropW = Math.min(cropW, gw - cropX);
            cropH = Math.min(cropH, gh - cropY);

            BufferedImage cropped = generated.getSubimage(cropX, cropY, cropW, cropH);
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(cropped, "jpeg", baos);
            return new OfferImageGenerationResponse("image/jpeg", Base64.getEncoder().encodeToString(baos.toByteArray()));
        } catch (Exception e) {
            log.warn("[GeminiService] cropToAspectRatio 실패, 원본 반환: {}", e.getMessage());
            return response;
        }
    }

    private String describeAspectRatio(int w, int h) {
        int g = gcd(w, h);
        return (w / g) + ":" + (h / g);
    }

    private int gcd(int a, int b) {
        return b == 0 ? a : gcd(b, a % b);
    }

    private byte[] compressForGeneration(byte[] originalBytes, BufferedImage original) throws Exception {
        if (original == null) return originalBytes;
        int maxDim = 512;
        int w = original.getWidth();
        int h = original.getHeight();
        BufferedImage target = original;
        if (w > maxDim || h > maxDim) {
            double scale = Math.min((double) maxDim / w, (double) maxDim / h);
            int nw = (int) (w * scale);
            int nh = (int) (h * scale);
            BufferedImage resized = new BufferedImage(nw, nh, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = resized.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g.drawImage(original, 0, 0, nw, nh, null);
            g.dispose();
            target = resized;
        } else if (original.getType() != BufferedImage.TYPE_INT_RGB) {
            BufferedImage rgb = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = rgb.createGraphics();
            g.drawImage(original, 0, 0, null);
            g.dispose();
            target = rgb;
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageWriter writer = ImageIO.getImageWritersByFormatName("jpeg").next();
        ImageWriteParam params = writer.getDefaultWriteParam();
        params.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
        params.setCompressionQuality(0.7f);
        writer.setOutput(ImageIO.createImageOutputStream(baos));
        writer.write(null, new IIOImage(target, null, null), params);
        writer.dispose();
        return baos.toByteArray();
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

    public GenerateDescriptionResponse generateDescription(GenerateDescriptionRequest request) {
        if (!StringUtils.hasText(properties.key())) {
            throw new BusinessException(ErrorCode.GEMINI_API_NOT_CONFIGURED);
        }
        try {
            String userContent = prompts.generateDescription().userTemplate()
                    + "\n농가명: " + request.producerName()
                    + "\n식재료명: " + request.ingredientName()
                    + "\n선택된 키워드: " + String.join(", ", request.keywords());

            Map<String, Object> textPart = Map.of("text", userContent);
            Map<String, Object> content = Map.of("parts", List.of(textPart));
            Map<String, Object> requestBody = Map.of("contents", List.of(content));
            String url = "/gmsapi/generativelanguage.googleapis.com/v1beta/models/" + properties.model() + ":generateContent";

            String responseBody = restClient.post()
                    .uri(url)
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(requestBody)
                    .retrieve()
                    .body(String.class);

            JsonNode root = objectMapper.readTree(responseBody);
            String text = root.path("candidates").get(0)
                    .path("content").path("parts").get(0)
                    .path("text").asText();
            text = text.replaceAll("(?s)```json\\s*", "").replaceAll("(?s)```\\s*", "").trim();
            JsonNode result = objectMapper.readTree(text);
            String description = result.path("description").asText();
            if (!StringUtils.hasText(description)) {
                // 필드명이 다를 경우 첫 번째 문자열 값 사용
                java.util.Iterator<JsonNode> values = result.elements();
                while (values.hasNext()) {
                    JsonNode val = values.next();
                    if (val.isTextual() && StringUtils.hasText(val.asText())) {
                        description = val.asText();
                        break;
                    }
                    if (val.isArray() && val.size() > 0) {
                        JsonNode first = val.get(0);
                        java.util.Iterator<JsonNode> fields = first.elements();
                        while (fields.hasNext()) {
                            JsonNode fv = fields.next();
                            if (fv.isTextual() && StringUtils.hasText(fv.asText())) {
                                description = fv.asText();
                                break;
                            }
                        }
                        if (StringUtils.hasText(description)) break;
                    }
                }
            }
            return new GenerateDescriptionResponse(description);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.GEMINI_API_ERROR);
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
            log.info("[GeminiService] analyzeOfferPhoto 응답 앞 300자: {}", responseBody.length() > 300 ? responseBody.substring(0, 300) + "..." : responseBody);
            JsonNode root = objectMapper.readTree(responseBody);
            String text = root.path("candidates").get(0)
                    .path("content").path("parts").get(0)
                    .path("text").asText();
            text = text.replaceAll("(?s)```json\\s*", "").replaceAll("(?s)```\\s*", "").trim();
            return objectMapper.readValue(text, OfferPhotoAnalysisResponse.class);
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.GEMINI_PARSE_ERROR);
        }
    }

    private byte[] compressImage(MultipartFile image) throws Exception {
        BufferedImage original = ImageIO.read(image.getInputStream());
        if (original == null) {
            return image.getBytes();
        }
        int maxDim = 200;
        int w = original.getWidth();
        int h = original.getHeight();
        BufferedImage target = original;
        if (w > maxDim || h > maxDim) {
            double scale = Math.min((double) maxDim / w, (double) maxDim / h);
            int nw = (int) (w * scale);
            int nh = (int) (h * scale);
            BufferedImage resized = new BufferedImage(nw, nh, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = resized.createGraphics();
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g.drawImage(original, 0, 0, nw, nh, null);
            g.dispose();
            target = resized;
        } else if (original.getType() != BufferedImage.TYPE_INT_RGB) {
            BufferedImage rgb = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
            Graphics2D g = rgb.createGraphics();
            g.drawImage(original, 0, 0, null);
            g.dispose();
            target = rgb;
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageWriter writer = ImageIO.getImageWritersByFormatName("jpeg").next();
        ImageWriteParam params = writer.getDefaultWriteParam();
        params.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);
        params.setCompressionQuality(0.3f);
        writer.setOutput(ImageIO.createImageOutputStream(baos));
        writer.write(null, new IIOImage(target, null, null), params);
        writer.dispose();
        return baos.toByteArray();
    }
}
