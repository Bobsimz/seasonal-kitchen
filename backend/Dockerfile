# syntax=docker/dockerfile:1

# 1) 빌드 (Gradle + JDK 21)
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
# 의존성 캐싱: 빌드 스크립트 먼저 복사해 소스 변경과 레이어 분리
COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x gradlew && ./gradlew --no-daemon dependencies > /dev/null 2>&1 || true
COPY src ./src
# bootJar만 실행하면 실행 가능한 단일 jar 하나만 생성된다 (plain jar 미생성)
RUN ./gradlew --no-daemon -x test bootJar

# 2) 실행 (JRE 21 슬림)
FROM eclipse-temurin:21-jre
WORKDIR /app
RUN useradd -r -u 1001 spring
COPY --from=builder /app/build/libs/*.jar app.jar
USER spring
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
