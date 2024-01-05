FROM openjdk:21-jdk-slim AS build

RUN apt-get update && apt-get install -y maven \
    && rm -rf /var/lib/apt/lists/*
ENV PATH="/usr/local/bin:$PATH"

WORKDIR /app

COPY pom.xml /app

COPY src /app/src

RUN mvn clean package -DskipTests

FROM openjdk:21-jdk-slim
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]