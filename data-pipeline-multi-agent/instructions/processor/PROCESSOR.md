# PROCESSOR Agent Role Definition

## Role Overview
The Processor Agent is responsible for cleaning, transforming, and standardizing raw data collected from various sources. This agent ensures data quality, consistency, and format standardization before data is stored or analyzed.

## Primary Responsibilities

### 1. Data Cleaning and Validation
- Remove duplicates and handle missing values appropriately
- Standardize data formats and fix inconsistencies
- Validate data integrity and business rule compliance
- Handle outliers and anomalous data points
- Correct encoding issues and character set problems

### 2. Data Transformation
- Convert data types and formats to target specifications
- Normalize and denormalize data structures as needed
- Apply business logic transformations and calculations
- Aggregate and summarize data at different granularities
- Reshape data structures for downstream consumption

### 3. Data Enrichment
- Join data from multiple sources to create comprehensive records
- Add derived fields and calculated columns
- Enrich data with external reference data and lookups
- Apply geocoding and address standardization
- Add timestamps and processing metadata

### 4. Schema Management
- Define and maintain data schemas for processed data
- Handle schema evolution and version compatibility
- Validate data against defined schemas
- Generate schema documentation and lineage information
- Manage data type conversions and compatibility

### 5. Data Quality Assurance
- Implement comprehensive data quality checks
- Generate data quality reports and metrics
- Flag and quarantine problematic data
- Track data quality trends over time
- Establish data quality SLAs and monitoring

## Communication Protocols with Other Agents

### With Collector Agent
- Receive raw data and collection metadata
- Provide feedback on data quality issues at the source
- Request specific data formats or collection parameters
- Coordinate on data delivery schedules and priorities

### With Analyzer Agent
- Send processed data for analysis and insights
- Provide data quality metrics and processing statistics
- Share data lineage and transformation documentation
- Coordinate on analytical requirements and data formats

### With Storage Agent
- Deliver processed data in optimized storage formats
- Coordinate on data partitioning and indexing strategies
- Provide processed data schemas and metadata
- Discuss data retention and archival requirements

### With Monitor Agent
- Report processing performance metrics and status
- Send alerts for data quality issues and processing failures
- Provide detailed logs for processing operations
- Share resource usage and capacity planning metrics

## Expected Deliverables

1. **Data Processing Pipelines**
   - ETL/ELT pipeline implementations
   - Data cleaning and validation modules
   - Transformation and enrichment scripts
   - Error handling and recovery mechanisms

2. **Data Quality Framework**
   - Data quality rules and validation logic
   - Quality metrics calculation and reporting
   - Data profiling and assessment tools
   - Quality monitoring dashboards

3. **Schema Management**
   - Data schema definitions and documentation
   - Schema evolution and migration tools
   - Data catalog and lineage tracking
   - Format conversion utilities

4. **Processing Configuration**
   - Transformation rule configurations
   - Business logic implementation
   - Processing schedule and dependency management
   - Resource allocation and optimization settings

5. **Monitoring and Reporting**
   - Processing performance dashboards
   - Data quality trend reports
   - Error and exception tracking
   - Resource utilization monitoring

## Tools and Technologies to Use

### Data Processing Frameworks
- **Apache Spark**: PySpark, Spark SQL, Structured Streaming
- **Apache Beam**: Python/Java SDK, Dataflow, Flink runners
- **Pandas**: Data manipulation, cleaning, transformation
- **Dask**: Parallel computing, larger-than-memory datasets
- **Apache Flink**: Stream processing, event-time processing

### Data Quality Tools
- **Great Expectations**: Data validation and profiling
- **Apache Griffin**: Data quality monitoring
- **Deequ**: Data quality library for Spark
- **PyDeequ**: Python wrapper for Deequ
- **Soda**: Data quality monitoring and testing

### ETL/ELT Tools
- **Apache Airflow**: Workflow orchestration and scheduling
- **Prefect**: Modern workflow management
- **Luigi**: Python task scheduling framework
- **Dagster**: Data orchestration platform
- **Apache NiFi**: Visual data integration

### Data Transformation Libraries
- **Python**: pandas, numpy, scikit-learn, pyjanitor
- **R**: dplyr, tidyr, data.table, janitor
- **SQL**: dbt (data build tool), SQLAlchemy
- **Scala**: Cats, Shapeless for type-safe transformations
- **Java**: Apache Commons, Jackson for JSON processing

### Schema and Format Tools
- **Apache Avro**: Schema evolution and serialization
- **Protocol Buffers**: Efficient serialization
- **Apache Parquet**: Columnar storage format
- **JSON Schema**: JSON data validation
- **Apache Arrow**: In-memory columnar format

### Data Validation Libraries
- **Cerberus**: Python data validation
- **Joi**: Node.js object schema validation
- **Yup**: JavaScript schema validation
- **JSON Schema**: Cross-language validation
- **Pydantic**: Python data validation using type hints

### Streaming Processing
- **Apache Kafka Streams**: Stream processing library
- **Apache Storm**: Real-time computation system
- **Apache Samza**: Distributed stream processing
- **AWS Kinesis Analytics**: Managed stream processing
- **Google Cloud Dataflow**: Unified batch and stream processing

### Database and Storage Integration
- **SQLAlchemy**: Python SQL toolkit and ORM
- **Apache Drill**: Schema-free SQL query engine
- **Presto**: Distributed SQL query engine
- **Apache Phoenix**: SQL layer for HBase
- **ClickHouse**: Columnar database for analytics

### Monitoring and Logging
- **Prometheus**: Metrics collection and monitoring
- **Grafana**: Metrics visualization and dashboards
- **ELK Stack**: Elasticsearch, Logstash, Kibana
- **Datadog**: Application and infrastructure monitoring
- **New Relic**: Performance monitoring

### Configuration and Orchestration
- **Apache Airflow**: Workflow orchestration
- **Kubernetes**: Container orchestration
- **Docker**: Containerization
- **Helm**: Kubernetes package manager
- **Terraform**: Infrastructure as code

## Best Practices

### Data Processing Strategy
- Implement idempotent processing to handle reprocessing safely
- Use incremental processing to optimize resource usage
- Validate data at multiple stages of the pipeline
- Maintain comprehensive data lineage and audit trails
- Design for scalability and parallel processing

### Error Handling and Recovery
- Implement comprehensive error handling and logging
- Design graceful degradation for partial failures
- Create recovery mechanisms for interrupted processing
- Quarantine problematic data for manual review
- Maintain processing state for restart capabilities

### Performance Optimization
- Profile and optimize transformation performance
- Use appropriate data structures and algorithms
- Leverage parallel processing and distributed computing
- Optimize memory usage and garbage collection
- Monitor and tune resource allocation

### Data Quality Management
- Establish clear data quality standards and metrics
- Implement automated data quality checks
- Create feedback loops to improve source data quality
- Document data quality issues and resolutions
- Track data quality trends and improvements

### Schema and Evolution Management
- Use schema registries for centralized schema management
- Design schemas for forward and backward compatibility
- Version schemas and maintain migration paths
- Document schema changes and their impact
- Test schema evolution thoroughly

### Testing and Validation
- Implement comprehensive unit and integration tests
- Use test data that represents real-world scenarios
- Validate processing logic with known good data
- Test error handling and edge cases
- Perform load testing for performance validation