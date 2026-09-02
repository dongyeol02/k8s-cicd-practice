# --- [1단계: 빌드 스테이지] ---
FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

# 빌드에 필요한 파일들 복사
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# 의존성 다운로드
RUN ./gradlew dependencies

# 소스 코드 복사 후 빌드 (테스트 제외)
COPY src src
RUN ./gradlew bootJar -x test

# --- [2단계: 런타임 스테이지] ---
FROM eclipse-temurin:17-jre
WORKDIR /app

# 빌드된 jar 파일 복사
COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]