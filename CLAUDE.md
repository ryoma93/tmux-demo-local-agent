# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## **最重要ルール・・・新しいルールの追加プロセス**
ユーザーから今回限りではなく常に対応が必要だと思われる指示を受けた場合： 

1. 「これを標準のルールにしますか？」と質問する 
2. YESの回答を得た場合、CLAUDE.mdに追加ルールとして記載する 
3. 以降は標準ルールとして常に適用する 

このプロセスにより、プロジェクトのルールを継続的に改善していきます。

## Commands

### LINE Bot Multi-Agent System Management
```bash
# Start the LINE Bot multi-agent tmux session
cd linebot-multi-agent && ./scripts/setup.sh

# Send messages between agents
./scripts/agent-send.sh -f FROM_AGENT -t TO_AGENT -m "message" [-p PRIORITY]

# Examples:
./scripts/agent-send.sh -f ARCHITECT -t BACKEND -m "Please implement webhook endpoint"
./scripts/agent-send.sh -f BACKEND -t ALL -m "Webhook implementation complete" -p HIGH

# Initialize a new LINE Bot project
./utils/project-init.sh
```

### Data Pipeline Multi-Agent System Management
```bash
# Start the data pipeline multi-agent tmux session
cd data-pipeline-multi-agent && ./scripts/setup.sh

# Send messages between data pipeline agents
./scripts/agent-send.sh -f FROM_AGENT -t TO_AGENT -m "message" [-p PRIORITY]

# Examples:
./scripts/agent-send.sh -f COLLECTOR -t PROCESSOR -m "Raw data collection complete, ready for processing"
./scripts/agent-send.sh -f PROCESSOR -t ALL -m "Data cleaning pipeline updated" -p HIGH
./scripts/agent-send.sh -f ANALYZER -t STORAGE -m "Analysis complete, recommend index optimization"

# Initialize a new data pipeline project
./utils/pipeline-init.sh PROJECT_NAME [PIPELINE_TYPE]
# PIPELINE_TYPE options: batch, streaming, hybrid (default: batch)
```

### Small Business Multi-Agent System Management
```bash
# Start the small business planning multi-agent tmux session
cd smallbiz-multi-agent && ./scripts/setup.sh

# Send messages between business planning agents
./scripts/agent-send.sh -f FROM_AGENT -t TO_AGENT -m "message" [-p PRIORITY]

# Examples:
./scripts/agent-send.sh -f STRATEGIST -t RESEARCHER -m "市場調査を開始してください"
./scripts/agent-send.sh -f RESEARCHER -t MARKETER -m "ペルソナ設計用のインサイトを共有します" -p HIGH
./scripts/agent-send.sh -f FINANCIER -t ALL -m "収益モデルの検証が完了しました" -p HIGH

# Initialize a new small business project
./utils/project-init.sh
```

### Cloudflare Deployment with Wrangler
```bash
# Install Wrangler CLI globally
npm install -g wrangler

# Login to Cloudflare
wrangler login

# Initialize Cloudflare Worker project
wrangler init my-linebot-worker

# Deploy to Cloudflare
wrangler deploy

# View deployment logs
wrangler tail

# Manage secrets
wrangler secret put SECRET_NAME
wrangler secret list
```

### Tmux Session Control
```bash
# LINE Bot system
tmux attach -t linebot-dev
tmux kill-session -t linebot-dev

# Data Pipeline system
tmux attach -t data-pipeline-dev
tmux kill-session -t data-pipeline-dev

# Small Business system
tmux attach -t smallbiz-dev
tmux kill-session -t smallbiz-dev

# Navigation within tmux
# Ctrl-b + [0-5] - Switch between agent windows
# Ctrl-b + d     - Detach from session
# Ctrl-b + w     - List all windows
```

## Architecture

This repository contains three specialized tmux-based multi-agent systems:

### 1. LINE Bot Multi-Agent System (`linebot-multi-agent/`)

Specialized for LINE Bot development with the following agent hierarchy:

#### Agent Hierarchy
- **ARCHITECT** (Window 0): System design, API specifications, database schemas
- **BACKEND** (Window 1): Webhook implementation, business logic, server-side code
- **FRONTEND** (Window 2): LINE messaging UI (Rich Menus, Flex Messages, Quick Replies)
- **TESTER** (Window 3): Testing strategies, quality assurance
- **MONITOR** (Window 4): Communication logger (watches logs/communication.log)

#### Key Components
- **scripts/setup.sh**: Creates tmux session with 5 windows, initializes each agent
- **scripts/agent-send.sh**: Handles message routing and logging between agents
- **instructions/[agent]/*.md**: Role definitions for each agent type
- **templates/**: LINE Bot code templates (webhook handlers, message formats)
- **utils/**: Development utilities (validators, message builders, project init)

#### LINE Bot Development Focus
- Pre-built templates for Flex Messages, Rich Menus, Quick Replies
- Webhook signature validation utilities
- Message builder helper functions
- Project initialization script that creates a complete LINE Bot structure

### 2. Data Pipeline Multi-Agent System (`data-pipeline-multi-agent/`)

Specialized for data collection, processing, and analysis with the following agent hierarchy:

#### Agent Hierarchy
- **COLLECTOR** (Window 0): Data collection from APIs, files, databases, streaming sources
- **PROCESSOR** (Window 1): Data cleaning, transformation, standardization
- **ANALYZER** (Window 2): Statistical analysis, quality assessment, anomaly detection
- **STORAGE** (Window 3): Data storage design, optimization, management
- **MONITOR** (Window 4): Communication logger and system monitoring

#### Key Components
- **scripts/setup.sh**: Creates tmux session with 5 data pipeline agent windows
- **scripts/agent-send.sh**: Handles message routing between data pipeline agents
- **instructions/[agent]/*.md**: Detailed role definitions for each data agent
- **templates/**: Data pipeline templates (API collectors, data processors)
- **utils/**: Data validation utilities, pipeline initialization tools

#### Data Pipeline Focus
- Comprehensive data collection from multiple source types
- Advanced data cleaning and transformation capabilities
- Statistical analysis and data quality assessment
- Flexible storage solutions and optimization strategies
- Complete project scaffolding for data pipeline projects

### 3. Small Business Multi-Agent System (`smallbiz-multi-agent/`)

Specialized for small business planning and strategy development with the following agent hierarchy:

#### Agent Hierarchy
- **STRATEGIST** (Window 0): Business vision, strategy planning, action plan integration
- **RESEARCHER** (Window 1): Market research, user needs analysis, competitor analysis
- **MARKETER** (Window 2): Persona design, SNS marketing strategy, brand positioning
- **ENGINEER** (Window 3): Technical feasibility, architecture design, development estimation
- **FINANCIER** (Window 4): Business model design, financial planning, revenue projections
- **MONITOR** (Window 5): Communication logger and system monitoring

#### Key Components
- **scripts/setup.sh**: Creates tmux session with 6 business planning agent windows
- **scripts/agent-send.sh**: Handles message routing between business planning agents
- **instructions/[agent]/*.md**: Detailed role definitions for each business agent
- **templates/**: Business planning templates (business model canvas, persona design, market research)
- **utils/**: Business validation utilities, project initialization tools

#### Small Business Development Focus
- Comprehensive business model canvas creation
- Detailed persona design and validation
- Market research and competitive analysis frameworks
- Technical feasibility assessment for small teams
- Financial planning for 100万円-5億円 scale businesses
- SNS-focused marketing strategies for modern businesses
- Cloudflare Workers deployment optimization
- Complete project scaffolding for small business ventures

### Inter-Agent Communication Protocol (All Systems)
- Messages are sent via `agent-send.sh` with priority levels (HIGH, MEDIUM, LOW)
- All communications are logged to `logs/communication.log`
- Agents can broadcast to ALL or send targeted messages
- Messages appear in tmux windows with timestamps and formatting

## Deployment Standards

### LINE Bot System Deployment (Cloudflare Workers)
LINE Bot multi-agent developed applications must be designed for Cloudflare Workers deployment:

#### Agent Responsibilities for Cloudflare Deployment
- **ARCHITECT**: Design APIs compatible with Cloudflare Workers runtime, plan edge computing architecture
- **BACKEND**: Implement webhook handlers using Cloudflare Workers patterns, optimize for serverless execution
- **FRONTEND**: Ensure LINE messaging components work with Workers environment, optimize response times
- **TESTER**: Include Cloudflare Workers-specific testing strategies, edge case testing
- **MONITOR**: Set up Cloudflare analytics and monitoring, track Workers performance

#### Required Configuration for LINE Bot Projects
- `wrangler.toml` configuration file with LINE Bot-specific settings
- Environment variables setup for LINE Bot credentials (Channel Access Token, Channel Secret)
- Proper routing configuration for webhook endpoints (`/webhook`)
- TypeScript support for Workers runtime APIs
- LINE Bot SDK compatibility with Workers environment

#### LINE Bot Development Workflow
1. Initialize projects with `wrangler init linebot-project`
2. Configure `wrangler.toml` for LINE Bot webhook requirements
3. Set up LINE Bot credentials via `wrangler secret put`
4. Use `wrangler dev` for local webhook testing with ngrok
5. Deploy with `wrangler deploy`
6. Monitor with `wrangler tail` and LINE Developers Console

### Data Pipeline System Deployment (Cloud/On-Premise)
Data pipeline multi-agent developed systems support flexible deployment options:

#### Agent Responsibilities for Data Pipeline Deployment
- **COLLECTOR**: Design data ingestion compatible with target infrastructure, plan for scalability
- **PROCESSOR**: Implement processing pipelines optimized for deployment environment (batch/streaming)
- **ANALYZER**: Create analysis modules that work in distributed environments, optimize for compute resources
- **STORAGE**: Design storage architecture for target platform (cloud/on-premise), plan backup strategies
- **MONITOR**: Set up comprehensive monitoring for data pipeline health, performance metrics, and alerts

#### Deployment Options for Data Pipeline Projects
1. **Cloud Deployment** (AWS/GCP/Azure):
   - Containerized deployment with Docker/Kubernetes
   - Managed services integration (S3, BigQuery, etc.)
   - Auto-scaling configuration
   - Cloud-native monitoring and logging

2. **On-Premise Deployment**:
   - Local infrastructure optimization
   - Network security configuration
   - Resource allocation planning
   - Custom monitoring solutions

3. **Hybrid Deployment**:
   - Multi-cloud data synchronization
   - Edge computing integration
   - Disaster recovery planning
   - Cross-platform monitoring

#### Data Pipeline Development Workflow
1. Initialize projects with `./utils/pipeline-init.sh PROJECT_NAME [batch|streaming|hybrid]`
2. Configure deployment environment in `config/pipeline.yaml`
3. Set up environment variables in `.env` file
4. Use Docker for containerized development and testing
5. Deploy using platform-specific tools (kubectl, terraform, etc.)
6. Monitor using configured monitoring stack (Prometheus, Grafana, etc.)

### Small Business System Deployment (Cloudflare Workers Focus)
Small business multi-agent developed applications are optimized for Cloudflare Workers deployment:

#### Agent Responsibilities for Small Business Deployment
- **STRATEGIST**: Define deployment strategy aligned with business goals, plan scalability milestones
- **RESEARCHER**: Validate technical assumptions about target infrastructure, assess user technical constraints
- **MARKETER**: Ensure marketing tools and analytics work with chosen deployment platform
- **ENGINEER**: Design architecture specifically for Cloudflare Workers, optimize for edge computing
- **FINANCIER**: Calculate deployment costs and ROI for chosen infrastructure strategy

#### Small Business Deployment Strategy
All small business projects must include:
- **Cloudflare Workers** as primary deployment platform for cost efficiency and global reach
- **TypeScript/JavaScript** implementation for Workers compatibility
- **Edge-first architecture** to minimize latency and infrastructure costs
- **Serverless design patterns** to reduce operational overhead for small teams

#### Small Business Development Workflow
1. Initialize projects with `./utils/project-init.sh` (includes wrangler.toml setup)
2. Configure business requirements and technical constraints
3. Design MVP with Cloudflare Workers limitations in mind
4. Develop using `wrangler dev` for local testing
5. Deploy with `wrangler deploy` for staging and production
6. Monitor using Cloudflare Analytics and custom business metrics

### Reference Links
- Cloudflare Workers: https://developers.cloudflare.com/workers/get-started/guide/
- LINE Bot SDK: https://developers.line.biz/en/docs/messaging-api/overview/
- Data Pipeline Best Practices: https://cloud.google.com/architecture/data-preprocessing-for-ml-with-tf-transform-pt1