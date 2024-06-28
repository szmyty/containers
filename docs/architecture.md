# Architecture Summary

## Overview
This document provides a summary of the architecture for a containerized application setup using Docker Swarm, Caddy server, custom-built Docker images, and TLS/SSL for secure communication.

## Components

### 1. **Caddy Server**
- Acts as the main entry point for the web application.
- Handles HTTPS traffic and reverse proxies requests to backend services.
- Manages SSL/TLS certificates.

### 2. **Docker Swarm**
- Orchestrates and manages the deployment and scaling of containers across multiple nodes.
- Uses Docker Stack files for service deployment.

### 3. **Earthly**
- Ensures consistent and reproducible builds of Docker images.
- Automates the build process for each service.

### 4. **Backend Services**
- API Service: Communicates with various backend services.
- AI Model: Provides AI-related functionalities.
- Redis Service: Offers in-memory data storage.
- Redis Insight: GUI tool for managing Redis.
- Elasticsearch Cluster: Includes Elasticsearch nodes, Kibana, and Logstash.
- Postgres Database: Provides persistent data storage.
- Other Services: Any additional services required.

### 5. **TLS/SSL**
- Ensures secure communication between services using SSL/TLS.
- Managed by Caddy and additional reverse proxies if needed.

### 6. **Bash Script Entry Point**
- A custom command-line tool to manage configurations, build processes, and deployment of containers.
- Provides commands to build, deploy, start, and stop services.

## Architectural Diagram
The following PlantUML code provides a visual representation of the architecture:

```plantuml
@startuml
!define RECTANGLE(rect) rect << (R,#FF7700) >> rect

RECTANGLE(Bash_Script) {
    start_services -down-> build_services
    start_services -down-> deploy_services
    deploy_services -down-> manage_certificates
    deploy_services -down-> set_configurations
}

RECTANGLE(Docker_Swarm_Manager) {
    RECTANGLE(Caddy_Server) {
        Caddy -[hidden]-> WebApp
    }
    RECTANGLE("Backend_Services") {
        API_Service -[hidden]-> AI_Model
        API_Service -[hidden]-> Postgres_DB
    }
}

RECTANGLE("Docker_Swarm_Worker_1") {
    RECTANGLE(Redis_Service) {
        Redis -[hidden]-> Redis_Insight
    }
    RECTANGLE("Elasticsearch_Cluster") {
        Elasticsearch -[hidden]-> Kibana
        Elasticsearch -[hidden]-> Logstash
    }
}

RECTANGLE("Docker_Swarm_Worker_2") {
    RECTANGLE("Other_Services") {
        Other_Service_1 -[hidden]-> Other_Service_2
    }
}

Caddy --> WebApp : HTTPS
WebApp --> API_Service : HTTPS
API_Service --> Redis : HTTPS
Redis_Insight --> Redis : HTTPS
WebApp --> AI_Model : HTTPS
API_Service --> Postgres_DB : HTTPS
Elasticsearch --> Kibana : HTTPS
Elasticsearch --> Logstash : HTTPS

@enduml