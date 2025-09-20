# Étape 1 : Build
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN ./mvnw -B dependency:go-offline
COPY . .
RUN ./mvnw -B -DskipTests package

# Étape 2 : Runtime
FROM eclipse-temurin:21-jre
WORKDIR /app
ARG JAR=target/*.jar
COPY --from=builder /app/${JAR} app.jar
EXPOSE 8080
ENTRYPOINT ["sh","-c","exec java -jar /app/app.jar"]
