# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Metadata as described in best practices
LABEL maintainer="szmyty@gmail.com" \
    version="1.0" \
    description="Java service running JMusicBot"

# Create a non-root user and group
RUN groupadd -r jmusicbot && useradd -r -g jmusicbot jmusicbot

# Set environment variables to non-root user and group
ENV USER=jmusicbot \
    GROUP=jmusicbot

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file and config file into the container
COPY JMusicBot.jar /app/
COPY config /app/config

# Change ownership and permissions for better security
RUN chown -R $USER:$GROUP /app && \
    chmod 755 /app

# Switch to non-root user
USER $USER

# Run the Java service when the container launches
CMD ["java", "-Dconfig=config", "-jar", "JMusicBot.jar"]
