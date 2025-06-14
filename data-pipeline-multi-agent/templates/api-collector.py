#!/usr/bin/env python3
"""
API Data Collector Template
Template for collecting data from REST APIs with error handling and rate limiting
"""

import requests
import time
import json
import logging
from typing import Dict, List, Optional, Any
from dataclasses import dataclass
from datetime import datetime
import os
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

@dataclass
class APIConfig:
    """Configuration for API data collection"""
    base_url: str
    api_key: Optional[str] = None
    rate_limit_per_second: float = 1.0
    timeout: int = 30
    retry_attempts: int = 3
    headers: Optional[Dict[str, str]] = None

class APICollector:
    """Template class for API data collection"""
    
    def __init__(self, config: APIConfig):
        self.config = config
        self.session = self._create_session()
        self.last_request_time = 0
        self._setup_logging()
    
    def _setup_logging(self):
        """Set up logging for the collector"""
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        self.logger = logging.getLogger(self.__class__.__name__)
    
    def _create_session(self) -> requests.Session:
        """Create a requests session with retry strategy"""
        session = requests.Session()
        
        # Configure retry strategy
        retry_strategy = Retry(
            total=self.config.retry_attempts,
            backoff_factor=1,
            status_forcelist=[429, 500, 502, 503, 504],
        )
        
        adapter = HTTPAdapter(max_retries=retry_strategy)
        session.mount("http://", adapter)
        session.mount("https://", adapter)
        
        # Set default headers
        headers = {
            'Content-Type': 'application/json',
            'User-Agent': 'DataPipeline-Collector/1.0'
        }
        
        if self.config.api_key:
            headers['Authorization'] = f'Bearer {self.config.api_key}'
        
        if self.config.headers:
            headers.update(self.config.headers)
        
        session.headers.update(headers)
        
        return session
    
    def _rate_limit(self):
        """Implement rate limiting"""
        if self.config.rate_limit_per_second > 0:
            time_since_last = time.time() - self.last_request_time
            min_interval = 1.0 / self.config.rate_limit_per_second
            
            if time_since_last < min_interval:
                sleep_time = min_interval - time_since_last
                time.sleep(sleep_time)
        
        self.last_request_time = time.time()
    
    def collect_data(self, endpoint: str, params: Optional[Dict] = None) -> Dict[str, Any]:
        """
        Collect data from API endpoint
        
        Args:
            endpoint: API endpoint path
            params: Query parameters
            
        Returns:
            Dictionary containing collected data and metadata
        """
        self._rate_limit()
        
        url = f"{self.config.base_url.rstrip('/')}/{endpoint.lstrip('/')}"
        
        try:
            self.logger.info(f"Collecting data from: {url}")
            
            response = self.session.get(
                url,
                params=params,
                timeout=self.config.timeout
            )
            
            response.raise_for_status()
            
            data = response.json()
            
            # Add collection metadata
            result = {
                'data': data,
                'metadata': {
                    'collected_at': datetime.utcnow().isoformat(),
                    'source_url': url,
                    'status_code': response.status_code,
                    'response_headers': dict(response.headers),
                    'record_count': len(data) if isinstance(data, list) else 1
                }
            }
            
            self.logger.info(f"Successfully collected {result['metadata']['record_count']} records")
            return result
            
        except requests.exceptions.RequestException as e:
            self.logger.error(f"Failed to collect data from {url}: {e}")
            raise
        except json.JSONDecodeError as e:
            self.logger.error(f"Failed to parse JSON response from {url}: {e}")
            raise
    
    def collect_paginated_data(self, 
                             endpoint: str, 
                             params: Optional[Dict] = None,
                             page_param: str = 'page',
                             per_page_param: str = 'per_page',
                             max_pages: Optional[int] = None) -> Dict[str, Any]:
        """
        Collect data from paginated API endpoint
        
        Args:
            endpoint: API endpoint path
            params: Base query parameters
            page_param: Parameter name for page number
            per_page_param: Parameter name for items per page
            max_pages: Maximum number of pages to collect
            
        Returns:
            Dictionary containing all collected data and metadata
        """
        if params is None:
            params = {}
        
        all_data = []
        page = 1
        total_records = 0
        
        while True:
            if max_pages and page > max_pages:
                break
            
            page_params = params.copy()
            page_params[page_param] = page
            
            try:
                result = self.collect_data(endpoint, page_params)
                page_data = result['data']
                
                if isinstance(page_data, list):
                    if not page_data:  # Empty page, stop pagination
                        break
                    all_data.extend(page_data)
                    total_records += len(page_data)
                else:
                    # Handle non-list responses (e.g., wrapped in 'items' key)
                    if 'items' in page_data:
                        items = page_data['items']
                        if not items:
                            break
                        all_data.extend(items)
                        total_records += len(items)
                    else:
                        all_data.append(page_data)
                        total_records += 1
                        break  # Single item response, no pagination
                
                page += 1
                
            except requests.exceptions.RequestException as e:
                self.logger.error(f"Error collecting page {page}: {e}")
                break
        
        return {
            'data': all_data,
            'metadata': {
                'collected_at': datetime.utcnow().isoformat(),
                'source_endpoint': endpoint,
                'total_pages': page - 1,
                'total_records': total_records,
                'collection_params': params
            }
        }

def main():
    """Example usage of APICollector"""
    # Example configuration
    config = APIConfig(
        base_url="https://api.example.com/v1",
        api_key=os.getenv("API_KEY"),
        rate_limit_per_second=2.0,
        timeout=30
    )
    
    collector = APICollector(config)
    
    try:
        # Collect single endpoint data
        result = collector.collect_data("users", {"status": "active"})
        print(f"Collected {result['metadata']['record_count']} records")
        
        # Collect paginated data
        paginated_result = collector.collect_paginated_data(
            "users",
            {"status": "active"},
            max_pages=5
        )
        print(f"Collected {paginated_result['metadata']['total_records']} total records from {paginated_result['metadata']['total_pages']} pages")
        
    except Exception as e:
        print(f"Collection failed: {e}")

if __name__ == "__main__":
    main()