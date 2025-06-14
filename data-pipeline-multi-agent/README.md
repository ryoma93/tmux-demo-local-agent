# Data Pipeline Multi-Agent System

A tmux-based multi-agent system for data collection, processing, and analysis. This system provides a collaborative environment where specialized agents work together to build robust data pipelines.

## Architecture

The system consists of 5 specialized agents:

### Agent Hierarchy
- **COLLECTOR** (Window 0): Data collection from APIs, files, databases, and streaming sources
- **PROCESSOR** (Window 1): Data cleaning, transformation, and standardization
- **ANALYZER** (Window 2): Statistical analysis, quality assessment, and anomaly detection
- **STORAGE** (Window 3): Data storage design, optimization, and management
- **MONITOR** (Window 4): Communication logger and system monitoring

### Inter-Agent Communication Protocol
- Messages are sent via `agent-send.sh` with priority levels (HIGH, MEDIUM, LOW)
- All communications are logged to `logs/communication.log`
- Agents can broadcast to ALL or send targeted messages
- Messages appear in tmux windows with timestamps and formatting

## Quick Start

### 1. Start the Multi-Agent System
```bash
cd data-pipeline-multi-agent
./scripts/setup.sh
```

### 2. Send Messages Between Agents
```bash
# Send specific message
./scripts/agent-send.sh -f COLLECTOR -t PROCESSOR -m "Raw data collection complete, ready for processing"

# Broadcast to all agents
./scripts/agent-send.sh -f PROCESSOR -t ALL -m "Data cleaning pipeline updated" -p HIGH

# More examples
./scripts/agent-send.sh -f ANALYZER -t STORAGE -m "Analysis complete, recommend index optimization"
./scripts/agent-send.sh -f STORAGE -t COLLECTOR -m "Storage capacity at 80%, consider data archival"
```

### 3. Initialize a New Data Pipeline Project
```bash
./utils/pipeline-init.sh my-pipeline-project batch
```

### 4. Tmux Session Control
```bash
# Attach to existing session
tmux attach -t data-pipeline-dev

# Kill session
tmux kill-session -t data-pipeline-dev

# Navigation within tmux
# Ctrl-b + [0-4] - Switch between agent windows
# Ctrl-b + d     - Detach from session
# Ctrl-b + w     - List all windows
```

## Agent Roles and Responsibilities

### COLLECTOR Agent
- **Primary Focus**: Data ingestion from various sources
- **Responsibilities**:
  - API integration with rate limiting and error handling
  - File processing (CSV, JSON, Parquet, XML)
  - Database connectivity and query optimization
  - Streaming data collection (Kafka, WebSocket)
  - Source data validation and quality checks

### PROCESSOR Agent
- **Primary Focus**: Data cleaning and transformation
- **Responsibilities**:
  - Data cleaning and standardization
  - Missing value handling and deduplication
  - Data type conversion and validation
  - Business rule application and enrichment
  - Schema management and evolution

### ANALYZER Agent
- **Primary Focus**: Data analysis and insights
- **Responsibilities**:
  - Statistical analysis and profiling
  - Data quality assessment and scoring
  - Anomaly detection and pattern recognition
  - Trend analysis and forecasting
  - Automated insight generation

### STORAGE Agent
- **Primary Focus**: Data persistence and optimization
- **Responsibilities**:
  - Storage architecture design
  - Database optimization and indexing
  - Backup and recovery planning
  - Data lifecycle management
  - Performance monitoring and tuning

### MONITOR Agent
- **Primary Focus**: System observability
- **Responsibilities**:
  - Inter-agent communication logging
  - Performance metrics tracking
  - Alert management and notification
  - Resource usage monitoring
  - System health checks

## Key Components

### Scripts
- **`scripts/setup.sh`**: Creates tmux session with 5 agent windows
- **`scripts/agent-send.sh`**: Handles message routing between agents

### Instructions
- **`instructions/[agent]/`**: Detailed role definitions for each agent
- Contains responsibilities, tools, best practices, and communication protocols

### Templates
- **`templates/api-collector.py`**: Template for API data collection
- **`templates/data-processor.py`**: Template for data processing pipelines

### Utils
- **`utils/data-validator.py`**: Comprehensive data validation utilities
- **`utils/pipeline-init.sh`**: Project initialization script

## Communication Examples

### Typical Workflow Messages

1. **Data Collection Phase**:
   ```bash
   ./scripts/agent-send.sh -f COLLECTOR -t PROCESSOR -m "Collected 10,000 records from customer API, ready for processing"
   ./scripts/agent-send.sh -f COLLECTOR -t STORAGE -m "Raw data stored in staging area, requires 2GB storage"
   ```

2. **Data Processing Phase**:
   ```bash
   ./scripts/agent-send.sh -f PROCESSOR -t ANALYZER -m "Data cleaning complete, 95% quality score achieved"
   ./scripts/agent-send.sh -f PROCESSOR -t STORAGE -m "Processed data ready for warehouse loading"
   ```

3. **Analysis Phase**:
   ```bash
   ./scripts/agent-send.sh -f ANALYZER -t ALL -m "Anomaly detected in recent data batch, investigating root cause" -p HIGH
   ./scripts/agent-send.sh -f ANALYZER -t STORAGE -m "Analysis suggests adding index on timestamp column"
   ```

4. **Storage Optimization**:
   ```bash
   ./scripts/agent-send.sh -f STORAGE -t COLLECTOR -m "Storage at 85% capacity, recommend implementing data archival"
   ./scripts/agent-send.sh -f STORAGE -t PROCESSOR -m "New partitioning strategy implemented, adjust batch sizes"
   ```

### Priority Levels
- **HIGH**: Critical issues, system failures, urgent notifications
- **MEDIUM**: Regular workflow updates, status reports
- **LOW**: Informational messages, suggestions, documentation updates

## Project Initialization

Use the pipeline initialization script to create new data pipeline projects:

```bash
# Create a batch processing pipeline
./utils/pipeline-init.sh my-batch-pipeline batch

# Create a streaming pipeline
./utils/pipeline-init.sh my-stream-pipeline streaming

# Create a hybrid pipeline
./utils/pipeline-init.sh my-hybrid-pipeline hybrid
```

This creates a complete project structure with:
- Configuration templates
- Source code scaffolding
- Testing framework
- Documentation
- Docker support
- Development tools

## Best Practices

### Agent Communication
- Use descriptive messages that provide context
- Include relevant metrics and status information
- Set appropriate priority levels
- Follow up on critical issues
- Document decisions and recommendations

### Data Pipeline Development
- Start with the COLLECTOR agent to understand data sources
- Collaborate with PROCESSOR for data quality requirements
- Engage ANALYZER for statistical validation
- Consult STORAGE for optimization strategies
- Monitor system performance continuously

### Quality Assurance
- Implement comprehensive data validation
- Monitor data quality metrics
- Set up automated alerting
- Document data lineage and transformations
- Regular performance reviews and optimization

## Advanced Features

### Custom Agent Instructions
Each agent has detailed instructions in `instructions/[agent]/AGENT.md` covering:
- Role definition and responsibilities
- Communication protocols
- Expected deliverables
- Tools and technologies
- Best practices and patterns

### Template System
Pre-built templates for common data pipeline components:
- API collectors with rate limiting
- Data processors with validation
- Quality assessment tools
- Storage optimization utilities

### Integration Support
The system supports integration with:
- Apache Spark and Hadoop ecosystem
- Cloud platforms (AWS, GCP, Azure)
- Modern data stack tools (dbt, Airflow, Kafka)
- Monitoring and observability platforms

## Contributing

To extend the system:

1. Add new agent types by creating instruction files
2. Develop new templates for common patterns
3. Enhance communication protocols
4. Add monitoring and alerting capabilities
5. Create integration modules for new technologies

## License

MIT License - feel free to adapt for your data pipeline needs.