# Kings Awards for Enterprise (KAE) System Overview

```mermaid
graph LR
    subgraph GOV_UK_PaaS["GOV.UK PaaS"]
        Poxa["Poxa Websocket server (Elixir)"]
        KAE["KAE Application (Ruby on Rails)"]
        Vigilion["Malware/AV Scanner (Ruby)"]
        S3["AWS S3 Bucket"]
        PostgreSQL["PostgreSQL Database"]
        Redis["Redis Cache"]

        KAE -->|stores files in| S3
        KAE -->|uses| PostgreSQL
        KAE -->|background jobs| Redis
        Vigilion -->|scans files in| S3
    end
    Users -->|connects via| CDN
    CDN[AWS CloudFront CDN]
    CDN -->|fronts| KAE
    CDN -->|fronts| Poxa
    KAE -->|sends emails via | Notify["GOV.UK Notify"]
    KAE -->|error reporting| Appsignal
    KAE -->|log archive| Appsignal
    KAE -->|performance monitoring| Appsignal
    

