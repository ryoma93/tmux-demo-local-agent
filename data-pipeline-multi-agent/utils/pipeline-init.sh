#!/bin/bash

# Data Pipeline Project Initialization Script
# Creates a complete data pipeline project structure with templates and configurations

PROJECT_NAME="$1"
PIPELINE_TYPE="$2"  # batch, streaming, hybrid

# Default values
if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: $0 PROJECT_NAME [PIPELINE_TYPE]"
    echo "PIPELINE_TYPE options: batch, streaming, hybrid (default: batch)"
    exit 1
fi

if [ -z "$PIPELINE_TYPE" ]; then
    PIPELINE_TYPE="batch"
fi

echo "Initializing data pipeline project: $PROJECT_NAME"
echo "Pipeline type: $PIPELINE_TYPE"

# Create project directory structure
mkdir -p "$PROJECT_NAME"/{config,data/{raw,processed,clean,archive},logs,notebooks,scripts,src/{collectors,processors,analyzers,storage},tests,docs}

# Create configuration files
cat > "$PROJECT_NAME/config/pipeline.yaml" << 'EOF'
# Data Pipeline Configuration
pipeline:
  name: DATA_PIPELINE_PROJECT
  version: "1.0.0"
  type: batch  # batch, streaming, hybrid
  
# Data sources configuration
sources:
  api:
    base_url: "https://api.example.com"
    auth_type: "bearer"  # bearer, basic, api_key
    rate_limit: 100  # requests per minute
    timeout: 30
    
  database:
    type: "postgresql"  # postgresql, mysql, sqlite
    host: "localhost"
    port: 5432
    database: "data_pipeline"
    
  files:
    input_directory: "./data/raw"
    supported_formats: ["csv", "json", "parquet", "xlsx"]
    
# Processing configuration
processing:
  remove_duplicates: true
  handle_missing: "drop"  # drop, fill, interpolate
  validation_enabled: true
  quality_threshold: 0.95
  
# Storage configuration
storage:
  type: "postgresql"  # postgresql, s3, gcs, local
  connection_string: "postgresql://user:pass@localhost:5432/db"
  backup_enabled: true
  compression: true
  
# Monitoring configuration
monitoring:
  logging_level: "INFO"
  metrics_enabled: true
  alerting_enabled: true
  
# Scheduler configuration (for batch processing)
scheduler:
  enabled: true
  interval: "daily"  # hourly, daily, weekly
  start_time: "02:00"
EOF

# Create environment configuration
cat > "$PROJECT_NAME/.env.template" << 'EOF'
# Environment Variables Template
# Copy this file to .env and fill in your actual values

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=data_pipeline
DB_USER=your_username
DB_PASSWORD=your_password

# API Configuration
API_BASE_URL=https://api.example.com
API_KEY=your_api_key
API_SECRET=your_api_secret

# Cloud Storage (if using)
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_S3_BUCKET=your_bucket_name

# Monitoring and Alerting
SLACK_WEBHOOK_URL=your_slack_webhook
EMAIL_SMTP_SERVER=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_USERNAME=your_email
EMAIL_PASSWORD=your_email_password

# Redis (for caching and job queues)
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_DB=0
EOF

# Create requirements.txt
cat > "$PROJECT_NAME/requirements.txt" << 'EOF'
# Core data processing libraries
pandas>=1.3.0
numpy>=1.21.0
scipy>=1.7.0
scikit-learn>=1.0.0

# Database connectivity
psycopg2-binary>=2.9.0
sqlalchemy>=1.4.0
redis>=4.0.0

# API and web requests
requests>=2.26.0
aiohttp>=3.8.0

# Data validation and quality
great-expectations>=0.15.0
cerberus>=1.3.0

# File format support
openpyxl>=3.0.0
pyarrow>=5.0.0
fastparquet>=0.7.0

# Scheduling and workflow
schedule>=1.1.0
celery>=5.2.0

# Configuration management
pyyaml>=6.0
python-dotenv>=0.19.0

# Logging and monitoring
structlog>=21.0.0
prometheus-client>=0.12.0

# Testing
pytest>=6.2.0
pytest-cov>=3.0.0

# Development tools
black>=21.0.0
flake8>=4.0.0
isort>=5.10.0
EOF

# Create main pipeline script
cat > "$PROJECT_NAME/src/main.py" << 'EOF'
#!/usr/bin/env python3
"""
Main Data Pipeline Entry Point
"""

import os
import sys
import yaml
import logging
from pathlib import Path
from datetime import datetime

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.append(str(project_root))

from src.collectors.data_collector import DataCollector
from src.processors.data_processor import DataProcessor
from src.analyzers.data_analyzer import DataAnalyzer
from src.storage.data_storage import DataStorage

def load_config(config_path: str = "config/pipeline.yaml"):
    """Load pipeline configuration"""
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)

def setup_logging(config: dict):
    """Setup logging configuration"""
    log_level = config.get('monitoring', {}).get('logging_level', 'INFO')
    
    logging.basicConfig(
        level=getattr(logging, log_level),
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
        handlers=[
            logging.FileHandler('logs/pipeline.log'),
            logging.StreamHandler()
        ]
    )

def run_pipeline():
    """Run the complete data pipeline"""
    logger = logging.getLogger(__name__)
    logger.info("Starting data pipeline execution")
    
    try:
        # Load configuration
        config = load_config()
        setup_logging(config)
        
        # Initialize pipeline components
        collector = DataCollector(config['sources'])
        processor = DataProcessor(config['processing'])
        analyzer = DataAnalyzer(config.get('analysis', {}))
        storage = DataStorage(config['storage'])
        
        # Execute pipeline stages
        logger.info("Stage 1: Data Collection")
        raw_data = collector.collect_all_sources()
        
        logger.info("Stage 2: Data Processing")
        processed_data = processor.process(raw_data)
        
        logger.info("Stage 3: Data Analysis")
        analysis_results = analyzer.analyze(processed_data)
        
        logger.info("Stage 4: Data Storage")
        storage.store_data(processed_data)
        storage.store_analysis_results(analysis_results)
        
        logger.info("Pipeline execution completed successfully")
        return True
        
    except Exception as e:
        logger.error(f"Pipeline execution failed: {e}")
        return False

if __name__ == "__main__":
    success = run_pipeline()
    sys.exit(0 if success else 1)
EOF

# Create collector template
mkdir -p "$PROJECT_NAME/src/collectors"
cat > "$PROJECT_NAME/src/collectors/data_collector.py" << 'EOF'
#!/usr/bin/env python3
"""
Data Collector Module
"""

import logging
from typing import Dict, List, Any

class DataCollector:
    """Main data collection coordinator"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def collect_all_sources(self) -> Dict[str, Any]:
        """Collect data from all configured sources"""
        collected_data = {}
        
        if 'api' in self.config:
            collected_data['api'] = self.collect_api_data()
        
        if 'database' in self.config:
            collected_data['database'] = self.collect_database_data()
        
        if 'files' in self.config:
            collected_data['files'] = self.collect_file_data()
        
        return collected_data
    
    def collect_api_data(self) -> List[Dict]:
        """Collect data from API sources"""
        self.logger.info("Collecting API data...")
        # Implement API collection logic
        return []
    
    def collect_database_data(self) -> List[Dict]:
        """Collect data from database sources"""
        self.logger.info("Collecting database data...")
        # Implement database collection logic
        return []
    
    def collect_file_data(self) -> List[Dict]:
        """Collect data from file sources"""
        self.logger.info("Collecting file data...")
        # Implement file collection logic
        return []
EOF

# Create processor template
mkdir -p "$PROJECT_NAME/src/processors"
cat > "$PROJECT_NAME/src/processors/data_processor.py" << 'EOF'
#!/usr/bin/env python3
"""
Data Processor Module
"""

import logging
import pandas as pd
from typing import Dict, List, Any

class DataProcessor:
    """Main data processing coordinator"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def process(self, raw_data: Dict[str, Any]) -> pd.DataFrame:
        """Process raw data from all sources"""
        self.logger.info("Starting data processing...")
        
        # Combine data from all sources
        combined_data = self.combine_sources(raw_data)
        
        # Apply processing steps
        processed_data = self.clean_data(combined_data)
        processed_data = self.transform_data(processed_data)
        processed_data = self.validate_data(processed_data)
        
        return processed_data
    
    def combine_sources(self, raw_data: Dict[str, Any]) -> pd.DataFrame:
        """Combine data from multiple sources"""
        # Implement data combination logic
        return pd.DataFrame()
    
    def clean_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Clean and standardize data"""
        # Implement data cleaning logic
        return df
    
    def transform_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Transform data according to business rules"""
        # Implement data transformation logic
        return df
    
    def validate_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """Validate processed data"""
        # Implement data validation logic
        return df
EOF

# Create analyzer template
mkdir -p "$PROJECT_NAME/src/analyzers"
cat > "$PROJECT_NAME/src/analyzers/data_analyzer.py" << 'EOF'
#!/usr/bin/env python3
"""
Data Analyzer Module
"""

import logging
import pandas as pd
from typing import Dict, Any

class DataAnalyzer:
    """Main data analysis coordinator"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def analyze(self, data: pd.DataFrame) -> Dict[str, Any]:
        """Perform comprehensive data analysis"""
        self.logger.info("Starting data analysis...")
        
        results = {
            'summary_statistics': self.calculate_summary_stats(data),
            'quality_metrics': self.assess_data_quality(data),
            'anomalies': self.detect_anomalies(data),
            'insights': self.generate_insights(data)
        }
        
        return results
    
    def calculate_summary_stats(self, df: pd.DataFrame) -> Dict[str, Any]:
        """Calculate summary statistics"""
        # Implement statistical analysis
        return {}
    
    def assess_data_quality(self, df: pd.DataFrame) -> Dict[str, Any]:
        """Assess data quality metrics"""
        # Implement quality assessment
        return {}
    
    def detect_anomalies(self, df: pd.DataFrame) -> Dict[str, Any]:
        """Detect anomalies in data"""
        # Implement anomaly detection
        return {}
    
    def generate_insights(self, df: pd.DataFrame) -> Dict[str, Any]:
        """Generate business insights"""
        # Implement insight generation
        return {}
EOF

# Create storage template
mkdir -p "$PROJECT_NAME/src/storage"
cat > "$PROJECT_NAME/src/storage/data_storage.py" << 'EOF'
#!/usr/bin/env python3
"""
Data Storage Module
"""

import logging
import pandas as pd
from typing import Dict, Any

class DataStorage:
    """Main data storage coordinator"""
    
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def store_data(self, data: pd.DataFrame):
        """Store processed data"""
        self.logger.info("Storing processed data...")
        
        if self.config['type'] == 'postgresql':
            self.store_to_database(data)
        elif self.config['type'] in ['s3', 'gcs']:
            self.store_to_cloud(data)
        else:
            self.store_to_local(data)
    
    def store_analysis_results(self, results: Dict[str, Any]):
        """Store analysis results"""
        self.logger.info("Storing analysis results...")
        # Implement analysis results storage
        pass
    
    def store_to_database(self, data: pd.DataFrame):
        """Store data to database"""
        # Implement database storage
        pass
    
    def store_to_cloud(self, data: pd.DataFrame):
        """Store data to cloud storage"""
        # Implement cloud storage
        pass
    
    def store_to_local(self, data: pd.DataFrame):
        """Store data to local filesystem"""
        # Implement local storage
        pass
EOF

# Create test templates
mkdir -p "$PROJECT_NAME/tests"
cat > "$PROJECT_NAME/tests/test_pipeline.py" << 'EOF'
#!/usr/bin/env python3
"""
Pipeline Tests
"""

import pytest
import pandas as pd
from src.main import load_config

def test_config_loading():
    """Test configuration loading"""
    config = load_config()
    assert config is not None
    assert 'pipeline' in config

def test_data_collection():
    """Test data collection functionality"""
    # Implement collection tests
    pass

def test_data_processing():
    """Test data processing functionality"""
    # Implement processing tests
    pass

def test_data_analysis():
    """Test data analysis functionality"""
    # Implement analysis tests
    pass
EOF

# Create README
cat > "$PROJECT_NAME/README.md" << EOF
# $PROJECT_NAME

A comprehensive data pipeline for collecting, processing, analyzing, and storing data.

## Features

- **Data Collection**: Support for APIs, databases, and file sources
- **Data Processing**: Cleaning, transformation, and validation
- **Data Analysis**: Statistical analysis and anomaly detection
- **Data Storage**: Flexible storage options (database, cloud, local)
- **Monitoring**: Comprehensive logging and metrics
- **Scheduling**: Automated pipeline execution

## Quick Start

1. **Install Dependencies**
   \`\`\`bash
   pip install -r requirements.txt
   \`\`\`

2. **Configuration**
   \`\`\`bash
   cp .env.template .env
   # Edit .env with your configuration
   \`\`\`

3. **Run Pipeline**
   \`\`\`bash
   python src/main.py
   \`\`\`

## Project Structure

\`\`\`
$PROJECT_NAME/
├── config/           # Configuration files
├── data/            # Data storage directories
│   ├── raw/         # Raw collected data
│   ├── processed/   # Processed data
│   ├── clean/       # Clean, validated data
│   └── archive/     # Archived data
├── logs/            # Log files
├── notebooks/       # Jupyter notebooks for analysis
├── scripts/         # Utility scripts
├── src/             # Source code
│   ├── collectors/  # Data collection modules
│   ├── processors/  # Data processing modules
│   ├── analyzers/   # Data analysis modules
│   └── storage/     # Data storage modules
├── tests/           # Test files
└── docs/            # Documentation
\`\`\`

## Configuration

Edit \`config/pipeline.yaml\` to configure:

- Data sources (APIs, databases, files)
- Processing parameters
- Storage settings
- Monitoring options

## Testing

\`\`\`bash
pytest tests/
\`\`\`

## Development

- Use Black for code formatting: \`black .\`
- Use flake8 for linting: \`flake8 .\`
- Use isort for import sorting: \`isort .\`

## License

MIT License
EOF

# Create Makefile for common tasks
cat > "$PROJECT_NAME/Makefile" << 'EOF'
.PHONY: install test lint format clean run

install:
	pip install -r requirements.txt

test:
	pytest tests/ -v --cov=src

lint:
	flake8 src/ tests/
	black --check src/ tests/

format:
	black src/ tests/
	isort src/ tests/

clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf dist/
	rm -rf build/

run:
	python src/main.py

setup-dev: install
	pre-commit install

docker-build:
	docker build -t data-pipeline .

docker-run:
	docker run -d --name data-pipeline data-pipeline
EOF

# Make scripts executable
chmod +x "$PROJECT_NAME/src/main.py"

echo ""
echo "✅ Data pipeline project '$PROJECT_NAME' created successfully!"
echo ""
echo "Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. cp .env.template .env  # Configure environment variables"
echo "3. pip install -r requirements.txt"
echo "4. Edit config/pipeline.yaml to configure your data sources"
echo "5. python src/main.py  # Run the pipeline"
echo ""
echo "Project structure created with $PIPELINE_TYPE pipeline configuration."