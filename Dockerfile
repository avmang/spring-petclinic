FROM eclipse-temurin:17-jdk AS build

WORKDIR /build

RUN apt-get update && apt-get install -y maven

COPY pom.xml .
COPY src ./src

RUN mvn clean install -DskipTests

FROM eclipse-temurin:17-jdk AS runtime

WORKDIR /build

COPY --from=build /build/target/spring-petclinic-*.jar app.jar

ENV VERSION 0.11.0
ENV JAR jmx_prometheus_javaagent-$VERSION.jar

RUN mkdir -p /opt/jmx_exporter
RUN curl -L https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/$VERSION/$JAR -o /opt/jmx_exporter/$JAR
RUN chmod +x /opt/jmx_exporter/$JAR
COPY config.yml /opt/jmx_exporter/config.yaml

EXPOSE 8080

EXPOSE 10254

CMD java -javaagent:/opt/jmx_exporter/$JAR=10254:/opt/jmx_exporter/config.yaml -jar app.jar app.log


