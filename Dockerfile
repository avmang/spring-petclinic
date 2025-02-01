FROM eclipse-temurin:17-jdk AS build

WORKDIR /build

RUN apt-get update && apt-get install -y maven

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:17-jdk AS runtime

WORKDIR /build

COPY --from=build /target/spring-petclinic-*.jar app.jar

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]