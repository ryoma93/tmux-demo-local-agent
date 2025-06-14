#!/usr/bin/env python3
"""
Data Processor Template
Template for cleaning, transforming, and validating data
"""

import pandas as pd
import numpy as np
import logging
from typing import Dict, List, Optional, Any, Callable
from dataclasses import dataclass
from datetime import datetime
import json
import re
from pathlib import Path

@dataclass
class ProcessingConfig:
    """Configuration for data processing"""
    input_format: str = 'json'  # json, csv, parquet
    output_format: str = 'json'
    remove_duplicates: bool = True
    handle_missing_values: str = 'drop'  # drop, fill, interpolate
    fill_value: Any = None
    date_columns: List[str] = None
    numeric_columns: List[str] = None
    categorical_columns: List[str] = None
    validation_rules: Dict[str, Any] = None

class DataProcessor:
    """Template class for data processing and cleaning"""
    
    def __init__(self, config: ProcessingConfig):
        self.config = config
        self._setup_logging()
        self.processing_stats = {
            'records_processed': 0,
            'records_removed': 0,
            'records_modified': 0,
            'validation_errors': 0
        }
    
    def _setup_logging(self):
        """Set up logging for the processor"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelevel)s - %(message)s'
        )
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def load_data(self, input_path: str) -> pd.DataFrame:
        """
        Load data from file based on format
        
        Args:
            input_path: Path to input data file
            
        Returns:
            DataFrame containing loaded data
        """
        path = Path(input_path)
        
        if not path.exists():
            raise FileNotFoundError(f"Input file not found: {input_path}")
        
        self.logger.info(f"Loading data from: {input_path}")
        
        if self.config.input_format.lower() == 'csv':
            df = pd.read_csv(input_path)
        elif self.config.input_format.lower() == 'json':
            df = pd.read_json(input_path)
        elif self.config.input_format.lower() == 'parquet':
            df = pd.read_parquet(input_path)
        else:
            raise ValueError(f"Unsupported input format: {self.config.input_format}")
        
        self.logger.info(f"Loaded {len(df)} records with {len(df.columns)} columns")
        return df
    
    def clean_data(self, df: pd.DataFrame) -> pd.DataFrame:
        """
        Clean and standardize the data
        
        Args:
            df: Input DataFrame
            
        Returns:
            Cleaned DataFrame
        """
        self.logger.info("Starting data cleaning process")
        original_count = len(df)
        
        # Remove duplicates
        if self.config.remove_duplicates:
            before_dedup = len(df)
            df = df.drop_duplicates()
            removed_duplicates = before_dedup - len(df)
            if removed_duplicates > 0:
                self.logger.info(f"Removed {removed_duplicates} duplicate records")
                self.processing_stats['records_removed'] += removed_duplicates
        
        # Handle missing values
        df = self._handle_missing_values(df)
        
        # Clean text columns
        df = self._clean_text_columns(df)
        
        # Standardize date columns
        if self.config.date_columns:
            df = self._standardize_dates(df)
        
        # Validate and convert numeric columns
        if self.config.numeric_columns:
            df = self._clean_numeric_columns(df)
        
        # Standardize categorical columns
        if self.config.categorical_columns:
            df = self._clean_categorical_columns(df)
        
        self.processing_stats['records_processed'] = original_count
        self.logger.info(f"Data cleaning complete. {len(df)} records remaining")
        
        return df
    
    def _handle_missing_values(self, df: pd.DataFrame) -> pd.DataFrame:
        """Handle missing values based on configuration"""
        missing_before = df.isnull().sum().sum()
        
        if missing_before == 0:
            return df
        
        self.logger.info(f"Handling {missing_before} missing values")
        
        if self.config.handle_missing_values == 'drop':
            df = df.dropna()
        elif self.config.handle_missing_values == 'fill':
            df = df.fillna(self.config.fill_value or 0)
        elif self.config.handle_missing_values == 'interpolate':
            # Interpolate numeric columns only
            numeric_cols = df.select_dtypes(include=[np.number]).columns
            df[numeric_cols] = df[numeric_cols].interpolate()
            # Fill remaining non-numeric missing values
            df = df.fillna('Unknown')
        
        missing_after = df.isnull().sum().sum()
        self.logger.info(f"Missing values reduced from {missing_before} to {missing_after}")
        
        return df
    
    def _clean_text_columns(self, df: pd.DataFrame) -> pd.DataFrame:
        """Clean text columns by removing extra whitespace and standardizing case"""
        text_columns = df.select_dtypes(include=['object']).columns
        
        for col in text_columns:
            if df[col].dtype == 'object':
                # Remove extra whitespace
                df[col] = df[col].astype(str).str.strip()
                # Remove multiple spaces
                df[col] = df[col].str.replace(r'\s+', ' ', regex=True)
                # Remove special characters if needed
                # df[col] = df[col].str.replace(r'[^\w\s]', '', regex=True)
        
        return df
    
    def _standardize_dates(self, df: pd.DataFrame) -> pd.DataFrame:
        """Convert and standardize date columns"""
        for col in self.config.date_columns:
            if col in df.columns:
                try:
                    df[col] = pd.to_datetime(df[col], errors='coerce')
                    invalid_dates = df[col].isnull().sum()
                    if invalid_dates > 0:
                        self.logger.warning(f"Found {invalid_dates} invalid dates in column {col}")
                        self.processing_stats['validation_errors'] += invalid_dates
                except Exception as e:
                    self.logger.error(f"Error converting column {col} to datetime: {e}")
        
        return df
    
    def _clean_numeric_columns(self, df: pd.DataFrame) -> pd.DataFrame:
        """Clean and validate numeric columns"""
        for col in self.config.numeric_columns:
            if col in df.columns:
                try:
                    # Convert to numeric, coercing errors to NaN
                    df[col] = pd.to_numeric(df[col], errors='coerce')
                    
                    # Remove outliers (optional - using IQR method)
                    Q1 = df[col].quantile(0.25)
                    Q3 = df[col].quantile(0.75)
                    IQR = Q3 - Q1
                    lower_bound = Q1 - 1.5 * IQR
                    upper_bound = Q3 + 1.5 * IQR
                    
                    outliers = ((df[col] < lower_bound) | (df[col] > upper_bound)).sum()
                    if outliers > 0:
                        self.logger.info(f"Found {outliers} outliers in column {col}")
                        # Optionally remove or cap outliers
                        # df = df[(df[col] >= lower_bound) & (df[col] <= upper_bound)]
                
                except Exception as e:
                    self.logger.error(f"Error processing numeric column {col}: {e}")
        
        return df
    
    def _clean_categorical_columns(self, df: pd.DataFrame) -> pd.DataFrame:
        """Standardize categorical columns"""
        for col in self.config.categorical_columns:
            if col in df.columns:
                # Convert to lowercase and strip whitespace
                df[col] = df[col].astype(str).str.lower().str.strip()
                
                # Log unique values for review
                unique_values = df[col].nunique()
                self.logger.info(f"Column {col} has {unique_values} unique values")
        
        return df
    
    def validate_data(self, df: pd.DataFrame) -> Dict[str, Any]:
        """
        Validate data against defined rules
        
        Args:
            df: DataFrame to validate
            
        Returns:
            Dictionary containing validation results
        """
        validation_results = {
            'is_valid': True,
            'errors': [],
            'warnings': [],
            'statistics': {}
        }
        
        if not self.config.validation_rules:
            return validation_results
        
        self.logger.info("Starting data validation")
        
        for rule_name, rule_config in self.config.validation_rules.items():
            try:
                if rule_name == 'required_columns':
                    missing_cols = set(rule_config) - set(df.columns)
                    if missing_cols:
                        validation_results['errors'].append(
                            f"Missing required columns: {missing_cols}"
                        )
                        validation_results['is_valid'] = False
                
                elif rule_name == 'min_records':
                    if len(df) < rule_config:
                        validation_results['errors'].append(
                            f"Insufficient records: {len(df)} < {rule_config}"
                        )
                        validation_results['is_valid'] = False
                
                elif rule_name == 'max_missing_percentage':
                    for col, max_missing in rule_config.items():
                        if col in df.columns:
                            missing_pct = (df[col].isnull().sum() / len(df)) * 100
                            if missing_pct > max_missing:
                                validation_results['errors'].append(
                                    f"Column {col} has {missing_pct:.1f}% missing values (> {max_missing}%)"
                                )
                                validation_results['is_valid'] = False
                
            except Exception as e:
                validation_results['errors'].append(f"Validation rule {rule_name} failed: {e}")
                validation_results['is_valid'] = False
        
        # Generate data statistics
        validation_results['statistics'] = {
            'total_records': len(df),
            'total_columns': len(df.columns),
            'missing_values': df.isnull().sum().sum(),
            'data_types': df.dtypes.to_dict()
        }
        
        self.logger.info(f"Validation complete. Valid: {validation_results['is_valid']}")
        return validation_results
    
    def save_data(self, df: pd.DataFrame, output_path: str):
        """
        Save processed data to file
        
        Args:
            df: DataFrame to save
            output_path: Path for output file
        """
        path = Path(output_path)
        path.parent.mkdir(parents=True, exist_ok=True)
        
        self.logger.info(f"Saving {len(df)} records to: {output_path}")
        
        if self.config.output_format.lower() == 'csv':
            df.to_csv(output_path, index=False)
        elif self.config.output_format.lower() == 'json':
            df.to_json(output_path, orient='records', indent=2)
        elif self.config.output_format.lower() == 'parquet':
            df.to_parquet(output_path, index=False)
        else:
            raise ValueError(f"Unsupported output format: {self.config.output_format}")
        
        self.logger.info("Data saved successfully")
    
    def get_processing_summary(self) -> Dict[str, Any]:
        """Get summary of processing operations"""
        return {
            'processing_stats': self.processing_stats,
            'processed_at': datetime.utcnow().isoformat(),
            'config': self.config.__dict__
        }

def main():
    """Example usage of DataProcessor"""
    # Example configuration
    config = ProcessingConfig(
        input_format='json',
        output_format='csv',
        remove_duplicates=True,
        handle_missing_values='fill',
        fill_value='Unknown',
        date_columns=['created_at', 'updated_at'],
        numeric_columns=['age', 'salary', 'score'],
        categorical_columns=['status', 'category'],
        validation_rules={
            'required_columns': ['id', 'name'],
            'min_records': 10,
            'max_missing_percentage': {'name': 5, 'email': 10}
        }
    )
    
    processor = DataProcessor(config)
    
    try:
        # Load data
        df = processor.load_data('input_data.json')
        
        # Clean data
        cleaned_df = processor.clean_data(df)
        
        # Validate data
        validation_result = processor.validate_data(cleaned_df)
        
        if validation_result['is_valid']:
            # Save processed data
            processor.save_data(cleaned_df, 'output_data.csv')
            
            # Print summary
            summary = processor.get_processing_summary()
            print(f"Processing complete: {summary}")
        else:
            print(f"Validation failed: {validation_result['errors']}")
            
    except Exception as e:
        print(f"Processing failed: {e}")

if __name__ == "__main__":
    main()