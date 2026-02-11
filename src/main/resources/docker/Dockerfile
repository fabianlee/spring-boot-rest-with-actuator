#
# Used to build OCI-compatible image using either Docker or Buildah
#
FROM eclipse-temurin:25.0.1_8-jdk-alpine

# create non-root user and group
# -l and static IDs assigned to avoid delay in lookups and system logging
ARG THE_USER_ID=1001
ARG THE_GROUP_ID=1001
RUN DEBIAN_FRONTEND=noninteractive && \
  addgroup -g $THE_GROUP_ID spring && \
  adduser --disabled-password -u $THE_USER_ID -G spring -g $THE_GROUP_ID spring && \
  mkdir logs && chgrp spring logs && chmod ug+rwx logs

# run as non-root
USER spring:spring

# main service: /api/product, /swagger-ui/index.html, /metrics
EXPOSE 8080
# actuator metrics /actuator/prometheus, /actuator/prometheus-custom
EXPOSE 8081

COPY springBoot.jar app.jar
CMD ["java","-jar","app.jar"]