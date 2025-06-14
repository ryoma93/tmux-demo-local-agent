#!/usr/bin/env python3
"""
Data Validation Utilities
Comprehensive data validation functions for data pipeline
"""

import pandas as pd
import numpy as np
from typing import Dict, List, Any, Tuple, Optional
import re
import logging
from datetime import datetime
from dataclasses import dataclass

@dataclass
class ValidationRule:
    """Represents a single validation rule"""
    name: str
    description: str
    severity: str  # 'error', 'warning', 'info'
    rule_type: str  # 'column', 'row', 'table'
    parameters: Dict[str, Any]

class DataValidator:
    """Comprehensive data validation utility"""
    
    def __init__(self):
        self.logger = logging.getLogger(self.__class__.__name__)
        self.validation_results = []
    
    def validate_schema(self, df: pd.DataFrame, expected_schema: Dict[str, str]) -> Dict[str, Any]:
        """
        Validate DataFrame schema against expected schema
        
        Args:
            df: DataFrame to validate
            expected_schema: Dictionary of column_name: expected_type
            
        Returns:
            Validation result dictionary
        """
        result = {
            'is_valid': True,
            'errors': [],
            'warnings': [],
            'info': []
        }
        
        # Check for missing columns
        missing_columns = set(expected_schema.keys()) - set(df.columns)
        if missing_columns:
            result['errors'].append(f"Missing required columns: {missing_columns}")
            result['is_valid'] = False
        
        # Check for extra columns
        extra_columns = set(df.columns) - set(expected_schema.keys())
        if extra_columns:
            result['warnings'].append(f"Unexpected columns found: {extra_columns}")
        
        # Check data types
        for column, expected_type in expected_schema.items():
            if column in df.columns:
                actual_type = str(df[column].dtype)
                if not self._is_compatible_type(actual_type, expected_type):
                    result['errors'].append(
                        f"Column {column}: expected {expected_type}, got {actual_type}"
                    )
                    result['is_valid'] = False
        
        return result
    
    def validate_data_quality(self, df: pd.DataFrame, rules: List[ValidationRule]) -> Dict[str, Any]:
        """
        Validate data quality based on provided rules
        
        Args:
            df: DataFrame to validate
            rules: List of validation rules
            
        Returns:
            Comprehensive validation results
        """
        results = {
            'overall_score': 0.0,
            'rule_results': [],
            'summary': {
                'total_rules': len(rules),
                'passed': 0,
                'failed': 0,
                'warnings': 0
            }
        }
        
        for rule in rules:
            rule_result = self._apply_validation_rule(df, rule)
            results['rule_results'].append(rule_result)
            
            if rule_result['status'] == 'passed':
                results['summary']['passed'] += 1
            elif rule_result['status'] == 'failed':
                results['summary']['failed'] += 1
            elif rule_result['status'] == 'warning':
                results['summary']['warnings'] += 1
        
        # Calculate overall quality score
        if results['summary']['total_rules'] > 0:
            results['overall_score'] = (
                results['summary']['passed'] / results['summary']['total_rules']
            ) * 100
        
        return results
    
    def check_completeness(self, df: pd.DataFrame, 
                          required_columns: List[str] = None,
                          completeness_threshold: float = 0.95) -> Dict[str, Any]:
        """
        Check data completeness
        
        Args:
            df: DataFrame to check
            required_columns: List of columns that must be complete
            completeness_threshold: Minimum required completeness ratio
            
        Returns:
            Completeness analysis results
        """
        total_cells = df.size
        missing_cells = df.isnull().sum().sum()
        completeness_ratio = (total_cells - missing_cells) / total_cells
        
        results = {
            'overall_completeness': completeness_ratio,
            'meets_threshold': completeness_ratio >= completeness_threshold,
            'column_completeness': {},
            'completely_empty_columns': [],
            'critical_columns_status': {}
        }
        
        # Check each column
        for column in df.columns:
            column_missing = df[column].isnull().sum()
            column_total = len(df)
            column_completeness = (column_total - column_missing) / column_total
            
            results['column_completeness'][column] = {
                'completeness_ratio': column_completeness,
                'missing_count': int(column_missing),
                'total_count': column_total
            }
            
            if column_completeness == 0:
                results['completely_empty_columns'].append(column)
        
        # Check required columns
        if required_columns:
            for column in required_columns:
                if column in df.columns:
                    column_completeness = results['column_completeness'][column]['completeness_ratio']
                    results['critical_columns_status'][column] = {
                        'is_complete_enough': column_completeness >= completeness_threshold,
                        'completeness_ratio': column_completeness
                    }
        
        return results
    
    def check_consistency(self, df: pd.DataFrame) -> Dict[str, Any]:
        """
        Check data consistency across various dimensions
        
        Args:
            df: DataFrame to check
            
        Returns:
            Consistency analysis results
        """
        results = {
            'format_consistency': {},
            'value_consistency': {},
            'pattern_consistency': {}
        }
        
        for column in df.columns:
            col_data = df[column].dropna()
            
            if col_data.dtype == 'object':
                # Check format consistency for text columns
                results['format_consistency'][column] = self._check_format_consistency(col_data)
                
                # Check for common inconsistencies
                results['value_consistency'][column] = self._check_value_consistency(col_data)
        
        return results
    
    def check_validity(self, df: pd.DataFrame, validation_rules: Dict[str, Any]) -> Dict[str, Any]:
        """
        Check data validity against business rules
        
        Args:
            df: DataFrame to validate
            validation_rules: Dictionary of column-specific validation rules
            
        Returns:
            Validity check results
        """
        results = {
            'valid_records': 0,
            'invalid_records': 0,
            'column_validity': {},
            'validation_errors': []
        }
        
        valid_mask = pd.Series([True] * len(df))
        
        for column, rules in validation_rules.items():
            if column not in df.columns:
                continue
            
            column_valid = pd.Series([True] * len(df))
            column_errors = []
            
            for rule_name, rule_config in rules.items():
                if rule_name == 'range':
                    min_val, max_val = rule_config
                    invalid_mask = (df[column] < min_val) | (df[column] > max_val)
                    column_valid &= ~invalid_mask
                    if invalid_mask.any():
                        column_errors.append(f"Values outside range [{min_val}, {max_val}]")
                
                elif rule_name == 'regex':
                    pattern = rule_config
                    invalid_mask = ~df[column].astype(str).str.match(pattern, na=False)
                    column_valid &= ~invalid_mask
                    if invalid_mask.any():
                        column_errors.append(f"Values not matching pattern: {pattern}")
                
                elif rule_name == 'allowed_values':
                    allowed = set(rule_config)
                    invalid_mask = ~df[column].isin(allowed)
                    column_valid &= ~invalid_mask
                    if invalid_mask.any():
                        column_errors.append(f"Values not in allowed set: {allowed}")
            
            results['column_validity'][column] = {
                'valid_count': int(column_valid.sum()),
                'invalid_count': int((~column_valid).sum()),
                'validity_ratio': column_valid.mean(),
                'errors': column_errors
            }
            
            valid_mask &= column_valid
        
        results['valid_records'] = int(valid_mask.sum())
        results['invalid_records'] = int((~valid_mask).sum())
        
        return results
    
    def generate_data_profile(self, df: pd.DataFrame) -> Dict[str, Any]:
        """
        Generate comprehensive data profile
        
        Args:
            df: DataFrame to profile
            
        Returns:
            Complete data profile
        """
        profile = {
            'basic_info': {
                'shape': df.shape,
                'memory_usage': df.memory_usage(deep=True).sum(),
                'dtypes': df.dtypes.to_dict()
            },
            'missing_data': {
                'total_missing': int(df.isnull().sum().sum()),
                'missing_percentage': (df.isnull().sum().sum() / df.size) * 100,
                'columns_with_missing': df.isnull().sum()[df.isnull().sum() > 0].to_dict()
            },
            'duplicate_data': {
                'duplicate_rows': int(df.duplicated().sum()),
                'duplicate_percentage': (df.duplicated().sum() / len(df)) * 100
            },
            'column_profiles': {}
        }
        
        for column in df.columns:
            col_profile = self._profile_column(df[column])
            profile['column_profiles'][column] = col_profile
        
        return profile
    
    def _apply_validation_rule(self, df: pd.DataFrame, rule: ValidationRule) -> Dict[str, Any]:
        """Apply a single validation rule"""
        try:
            if rule.rule_type == 'column':
                return self._validate_column_rule(df, rule)
            elif rule.rule_type == 'row':
                return self._validate_row_rule(df, rule)
            elif rule.rule_type == 'table':
                return self._validate_table_rule(df, rule)
            else:
                return {
                    'rule_name': rule.name,
                    'status': 'error',
                    'message': f"Unknown rule type: {rule.rule_type}"
                }
        except Exception as e:
            return {
                'rule_name': rule.name,
                'status': 'error',
                'message': f"Rule execution failed: {str(e)}"
            }
    
    def _validate_column_rule(self, df: pd.DataFrame, rule: ValidationRule) -> Dict[str, Any]:
        """Validate column-level rules"""
        column = rule.parameters.get('column')
        
        if column not in df.columns:
            return {
                'rule_name': rule.name,
                'status': 'failed',
                'message': f"Column {column} not found"
            }
        
        # Implement specific column validation logic here
        # This is a template - add specific validations as needed
        
        return {
            'rule_name': rule.name,
            'status': 'passed',
            'message': 'Column validation passed'
        }
    
    def _validate_row_rule(self, df: pd.DataFrame, rule: ValidationRule) -> Dict[str, Any]:
        """Validate row-level rules"""
        # Implement row-level validation logic
        return {
            'rule_name': rule.name,
            'status': 'passed',
            'message': 'Row validation passed'
        }
    
    def _validate_table_rule(self, df: pd.DataFrame, rule: ValidationRule) -> Dict[str, Any]:
        """Validate table-level rules"""
        # Implement table-level validation logic
        return {
            'rule_name': rule.name,
            'status': 'passed',
            'message': 'Table validation passed'
        }
    
    def _is_compatible_type(self, actual_type: str, expected_type: str) -> bool:
        """Check if actual data type is compatible with expected type"""
        type_mapping = {
            'int': ['int64', 'int32', 'int16', 'int8'],
            'float': ['float64', 'float32', 'int64', 'int32'],
            'string': ['object', 'string'],
            'datetime': ['datetime64[ns]', 'object'],
            'bool': ['bool']
        }
        
        compatible_types = type_mapping.get(expected_type, [expected_type])
        return actual_type in compatible_types
    
    def _check_format_consistency(self, series: pd.Series) -> Dict[str, Any]:
        """Check format consistency within a series"""
        # Example: email format, phone format, etc.
        formats = {}
        sample_values = series.head(100).tolist()
        
        # Basic format detection
        if series.name and 'email' in series.name.lower():
            email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
            formats['email_format'] = series.str.match(email_pattern, na=False).mean()
        
        return formats
    
    def _check_value_consistency(self, series: pd.Series) -> Dict[str, Any]:
        """Check value consistency within a series"""
        return {
            'unique_values': int(series.nunique()),
            'most_common': series.value_counts().head(5).to_dict(),
            'case_consistency': self._check_case_consistency(series)
        }
    
    def _check_case_consistency(self, series: pd.Series) -> Dict[str, Any]:
        """Check case consistency in text data"""
        if series.dtype != 'object':
            return {}
        
        text_series = series.astype(str)
        return {
            'lowercase_count': int(text_series.str.islower().sum()),
            'uppercase_count': int(text_series.str.isupper().sum()),
            'mixed_case_count': int((~text_series.str.islower() & ~text_series.str.isupper()).sum())
        }
    
    def _profile_column(self, series: pd.Series) -> Dict[str, Any]:
        """Generate profile for a single column"""
        profile = {
            'dtype': str(series.dtype),
            'non_null_count': int(series.count()),
            'null_count': int(series.isnull().sum()),
            'unique_count': int(series.nunique())
        }
        
        if series.dtype in ['int64', 'float64']:
            profile.update({
                'mean': float(series.mean()) if not series.empty else None,
                'std': float(series.std()) if not series.empty else None,
                'min': float(series.min()) if not series.empty else None,
                'max': float(series.max()) if not series.empty else None,
                'quartiles': series.quantile([0.25, 0.5, 0.75]).to_dict()
            })
        
        elif series.dtype == 'object':
            profile.update({
                'avg_length': float(series.astype(str).str.len().mean()) if not series.empty else None,
                'max_length': int(series.astype(str).str.len().max()) if not series.empty else None,
                'min_length': int(series.astype(str).str.len().min()) if not series.empty else None
            })
        
        return profile

def create_sample_validation_rules() -> List[ValidationRule]:
    """Create sample validation rules for demonstration"""
    return [
        ValidationRule(
            name="required_columns",
            description="Check if all required columns are present",
            severity="error",
            rule_type="table",
            parameters={"required_columns": ["id", "name", "email"]}
        ),
        ValidationRule(
            name="email_format",
            description="Validate email format",
            severity="error",
            rule_type="column",
            parameters={"column": "email", "pattern": r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'}
        ),
        ValidationRule(
            name="age_range",
            description="Check if age is within reasonable range",
            severity="warning",
            rule_type="column",
            parameters={"column": "age", "min_value": 0, "max_value": 150}
        )
    ]

if __name__ == "__main__":
    # Example usage
    validator = DataValidator()
    
    # Create sample data
    sample_data = pd.DataFrame({
        'id': [1, 2, 3, 4, 5],
        'name': ['John', 'Jane', 'Bob', None, 'Alice'],
        'email': ['john@email.com', 'invalid-email', 'bob@test.com', 'test@domain.co', 'alice@company.org'],
        'age': [25, 30, -5, 200, 28]
    })
    
    # Generate data profile
    profile = validator.generate_data_profile(sample_data)
    print("Data Profile:", profile)
    
    # Validate data quality
    rules = create_sample_validation_rules()
    quality_results = validator.validate_data_quality(sample_data, rules)
    print("Quality Results:", quality_results)