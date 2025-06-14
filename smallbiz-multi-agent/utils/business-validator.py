#!/usr/bin/env python3
"""
Business Plan Validator
スモールビジネス計画の妥当性を検証するツール
"""

import json
import re
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from enum import Enum

class ValidationLevel(Enum):
    ERROR = "error"
    WARNING = "warning"
    INFO = "info"

@dataclass
class ValidationResult:
    level: ValidationLevel
    category: str
    message: str
    suggestion: Optional[str] = None

class BusinessValidator:
    def __init__(self):
        self.results: List[ValidationResult] = []
    
    def validate_business_plan(self, plan_data: Dict) -> List[ValidationResult]:
        """ビジネスプランの総合的な検証"""
        self.results = []
        
        # 各要素の検証
        self._validate_vision_mission(plan_data.get('vision_mission', {}))
        self._validate_market_analysis(plan_data.get('market_analysis', {}))
        self._validate_financial_plan(plan_data.get('financial_plan', {}))
        self._validate_marketing_strategy(plan_data.get('marketing_strategy', {}))
        self._validate_technical_plan(plan_data.get('technical_plan', {}))
        self._validate_team_structure(plan_data.get('team_structure', {}))
        
        return self.results
    
    def _validate_vision_mission(self, vision_mission: Dict):
        """ビジョン・ミッションの検証"""
        # ビジョンの存在チェック
        if not vision_mission.get('vision'):
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Vision/Mission",
                "ビジョンが定義されていません",
                "明確で具体的なビジョンを定義してください"
            ))
        
        # ミッションの存在チェック
        if not vision_mission.get('mission'):
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Vision/Mission",
                "ミッションが定義されていません",
                "事業の目的と価値を明確にしたミッションを定義してください"
            ))
        
        # ビジョンの長さチェック
        vision = vision_mission.get('vision', '')
        if len(vision) > 200:
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Vision/Mission",
                "ビジョンが長すぎます（200文字以下推奨）",
                "より簡潔で記憶に残るビジョンに短縮してください"
            ))
    
    def _validate_market_analysis(self, market_analysis: Dict):
        """市場分析の検証"""
        # 市場規模の妥当性チェック
        tam = market_analysis.get('tam', 0)
        sam = market_analysis.get('sam', 0)
        som = market_analysis.get('som', 0)
        
        if tam == 0:
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Market Analysis",
                "TAM（総獲得可能市場）が定義されていません"
            ))
        
        if sam > tam:
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Market Analysis",
                "SAMがTAMより大きくなっています",
                "SAM（具体的に取得可能な市場）はTAMより小さくする必要があります"
            ))
        
        if som > sam:
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Market Analysis",
                "SOMがSAMより大きくなっています",
                "SOM（現実的に獲得可能な市場）はSAMより小さくする必要があります"
            ))
        
        # 競合分析チェック
        competitors = market_analysis.get('competitors', [])
        if len(competitors) == 0:
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Market Analysis",
                "競合分析が不足しています",
                "少なくとも3-5社の競合を分析してください"
            ))
    
    def _validate_financial_plan(self, financial_plan: Dict):
        """財務計画の検証"""
        # 収益予測の妥当性チェック
        revenue_streams = financial_plan.get('revenue_streams', [])
        if not revenue_streams:
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Financial Plan",
                "収益源が定義されていません"
            ))
        
        # コスト構造チェック
        fixed_costs = financial_plan.get('fixed_costs', 0)
        variable_costs = financial_plan.get('variable_costs', 0)
        total_revenue = financial_plan.get('projected_revenue', 0)
        
        total_costs = fixed_costs + variable_costs
        
        if total_costs >= total_revenue:
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Financial Plan",
                "総コストが予想収益を上回っています",
                "コスト削減または収益向上の施策を検討してください"
            ))
        
        # 損益分岐点の計算
        if variable_costs > 0 and total_revenue > 0:
            break_even_ratio = fixed_costs / (total_revenue - variable_costs)
            if break_even_ratio > 0.8:
                self.results.append(ValidationResult(
                    ValidationLevel.WARNING,
                    "Financial Plan",
                    "損益分岐点が高すぎます",
                    "固定費の削減または粗利益率の改善を検討してください"
                ))
        
        # スモールビジネス規模チェック
        if total_revenue > 1000000000:  # 10億円
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Financial Plan",
                "収益規模がスモールビジネスの範囲を超えています",
                "数百万円〜数億円規模での現実的な計画を検討してください"
            ))
    
    def _validate_marketing_strategy(self, marketing_strategy: Dict):
        """マーケティング戦略の検証"""
        # ターゲット顧客の定義チェック
        target_customers = marketing_strategy.get('target_customers', [])
        if not target_customers:
            self.results.append(ValidationResult(
                ValidationLevel.ERROR,
                "Marketing Strategy",
                "ターゲット顧客が定義されていません"
            ))
        
        # SNS戦略チェック
        sns_strategy = marketing_strategy.get('sns_strategy', {})
        if not sns_strategy:
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Marketing Strategy",
                "SNS戦略が定義されていません",
                "スモールビジネスにはSNSマーケティングが重要です"
            ))
        
        # マーケティング予算の妥当性
        marketing_budget = marketing_strategy.get('budget', 0)
        total_revenue = marketing_strategy.get('projected_revenue', 0)
        
        if marketing_budget > 0 and total_revenue > 0:
            marketing_ratio = marketing_budget / total_revenue
            if marketing_ratio > 0.3:
                self.results.append(ValidationResult(
                    ValidationLevel.WARNING,
                    "Marketing Strategy",
                    "マーケティング予算が収益の30%を超えています",
                    "より効率的なマーケティング手法を検討してください"
                ))
    
    def _validate_technical_plan(self, technical_plan: Dict):
        """技術計画の検証"""
        # 技術スタックの定義チェック
        tech_stack = technical_plan.get('tech_stack', {})
        if not tech_stack:
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Technical Plan",
                "技術スタックが定義されていません"
            ))
        
        # 開発工数の妥当性チェック
        development_time = technical_plan.get('development_time_months', 0)
        if development_time > 12:
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Technical Plan",
                "開発期間が12ヶ月を超えています",
                "スモールビジネスでは迅速な市場投入が重要です"
            ))
        
        # セキュリティ要件チェック
        security_requirements = technical_plan.get('security_requirements', [])
        if not security_requirements:
            self.results.append(ValidationResult(
                ValidationLevel.INFO,
                "Technical Plan",
                "セキュリティ要件が明記されていません",
                "データ保護やプライバシー要件を検討してください"
            ))
    
    def _validate_team_structure(self, team_structure: Dict):
        """チーム構成の検証"""
        team_members = team_structure.get('members', [])
        
        # チームサイズチェック
        if len(team_members) > 10:
            self.results.append(ValidationResult(
                ValidationLevel.WARNING,
                "Team Structure",
                "チームサイズが大きすぎます",
                "スモールビジネスでは5-10名程度が適切です"
            ))
        
        # 必要な役割のチェック
        required_roles = ['engineer', 'marketer']
        existing_roles = [member.get('role', '').lower() for member in team_members]
        
        for role in required_roles:
            if role not in existing_roles:
                self.results.append(ValidationResult(
                    ValidationLevel.WARNING,
                    "Team Structure",
                    f"必要な役割（{role}）がチームに含まれていません"
                ))
    
    def generate_report(self) -> str:
        """検証結果のレポート生成"""
        if not self.results:
            return "検証が実行されていません。"
        
        report = "# ビジネスプラン検証レポート\n\n"
        
        # エラー、警告、情報の分類
        errors = [r for r in self.results if r.level == ValidationLevel.ERROR]
        warnings = [r for r in self.results if r.level == ValidationLevel.WARNING]
        infos = [r for r in self.results if r.level == ValidationLevel.INFO]
        
        # サマリー
        report += f"## 検証サマリー\n"
        report += f"- エラー: {len(errors)}件\n"
        report += f"- 警告: {len(warnings)}件\n"
        report += f"- 情報: {len(infos)}件\n\n"
        
        # 詳細結果
        for level_name, results in [("エラー", errors), ("警告", warnings), ("情報", infos)]:
            if results:
                report += f"## {level_name}\n\n"
                for result in results:
                    report += f"### {result.category}\n"
                    report += f"**問題**: {result.message}\n"
                    if result.suggestion:
                        report += f"**推奨**: {result.suggestion}\n"
                    report += "\n"
        
        return report

def main():
    """サンプル実行"""
    # サンプルデータ
    sample_plan = {
        "vision_mission": {
            "vision": "すべての人が効率的に働ける世界を実現する",
            "mission": "中小企業の生産性向上をサポートするSaaSプラットフォームを提供"
        },
        "market_analysis": {
            "tam": 1000000000,  # 10億円
            "sam": 100000000,   # 1億円
            "som": 10000000,    # 1000万円
            "competitors": ["競合A", "競合B", "競合C"]
        },
        "financial_plan": {
            "revenue_streams": ["SaaS subscription", "Professional services"],
            "fixed_costs": 2000000,      # 200万円/月
            "variable_costs": 500000,    # 50万円/月
            "projected_revenue": 5000000  # 500万円/月
        },
        "marketing_strategy": {
            "target_customers": ["中小企業", "スタートアップ"],
            "sns_strategy": {"twitter": True, "linkedin": True},
            "budget": 1000000,           # 100万円/月
            "projected_revenue": 5000000
        },
        "technical_plan": {
            "tech_stack": {"backend": "Python", "frontend": "React"},
            "development_time_months": 8,
            "security_requirements": ["SSL", "データ暗号化"]
        },
        "team_structure": {
            "members": [
                {"name": "田中", "role": "engineer"},
                {"name": "佐藤", "role": "marketer"},
                {"name": "山田", "role": "manager"}
            ]
        }
    }
    
    validator = BusinessValidator()
    results = validator.validate_business_plan(sample_plan)
    print(validator.generate_report())

if __name__ == "__main__":
    main()