# Small Business Multi-Agent System

スモールビジネス（数百万円〜数億円規模）の立案・設計に特化したマルチエージェントシステムです。
ソフトウェアエンジニアとSNS広報担当を中心とした数名のチームで実現可能なビジネスモデルの設計をサポートします。

## 特徴

- **専門特化型エージェント**: 戦略、調査、マーケティング、技術、財務の5つの専門エージェント
- **SNS重視のマーケティング**: Twitter/X、Instagram、TikTok、LinkedInを活用した現代的なマーケティング戦略
- **技術実装重視**: Cloudflare Workersを前提とした現実的な技術アーキテクチャ
- **財務現実性**: スモールチーム・スモール予算での実現可能な事業計画

## エージェント構成

### STRATEGIST（戦略家）
- ビジョン・ミッションの言語化
- 事業戦略の立案と統合
- アクションプランの整理

### RESEARCHER（調査専門家）
- 市場調査と分析
- ユーザーニーズの深掘り
- 競合分析と仮説検証

### MARKETER（マーケター）
- ペルソナ設計
- SNS中心のマーケティング戦略
- ブランディングとコンテンツ戦略

### ENGINEER（エンジニア）
- 技術的実現可能性の評価
- システムアーキテクチャ設計
- 開発工数見積もり

### FINANCIER（財務戦略家）
- ビジネスモデル設計
- 財務計画と収益予測
- 投資・資金調達計画

## クイックスタート

### 1. マルチエージェントシステムの起動
```bash
cd smallbiz-multi-agent
./scripts/setup.sh
```

### 2. 新しいプロジェクトの初期化
```bash
./utils/project-init.sh
```

### 3. エージェント間のコミュニケーション
```bash
# 戦略家から調査専門家へメッセージ送信
./scripts/agent-send.sh -f STRATEGIST -t RESEARCHER -m "市場調査を開始してください"

# 全エージェントへの重要な通知
./scripts/agent-send.sh -f STRATEGIST -t ALL -m "プロジェクト目標を更新しました" -p HIGH
```

## プロジェクト開発フロー

### Phase 1: 調査・企画（2-4週間）
1. **RESEARCHER**: 市場調査、競合分析、ユーザーインタビュー
2. **STRATEGIST**: ビジョン・ミッション定義、戦略方向性決定
3. **MARKETER**: ペルソナ設計、初期マーケティング戦略
4. **FINANCIER**: 市場機会の定量化、初期収益モデル検討
5. **ENGINEER**: 技術的実現可能性の初期評価

### Phase 2: 設計・計画（2-3週間）
1. **STRATEGIST**: 統合事業計画の策定
2. **ENGINEER**: システムアーキテクチャ設計、技術スタック選定
3. **MARKETER**: 詳細マーケティング戦略、SNS戦略立案
4. **FINANCIER**: 詳細財務計画、収益予測、投資計画
5. **全エージェント**: 計画の統合と妥当性検証

### Phase 3: 実装準備（1-2週間）
1. **ENGINEER**: 開発環境セットアップ、Cloudflare Workers設定
2. **MARKETER**: マーケティング資料作成、SNSアカウント準備
3. **FINANCIER**: 予算管理システム、KPI設定
4. **STRATEGIST**: プロジェクト管理体制、チーム編成

## テンプレート・ツール

### ビジネス計画テンプレート
- `templates/business-model-canvas.md`: ビジネスモデルキャンバス
- `templates/persona-template.md`: 詳細ペルソナ設計
- `templates/market-research-template.md`: 市場調査フレームワーク

### 開発支援ツール
- `utils/business-validator.py`: ビジネスプラン妥当性検証
- `utils/project-init.sh`: 新規プロジェクト初期化スクリプト

## エージェント利用例

### 市場調査の開始
```bash
./scripts/agent-send.sh -f STRATEGIST -t RESEARCHER -m "AIを活用した中小企業向けSaaSの市場調査を実施してください。TAM/SAM/SOMの算出と主要競合5社の分析を含めてください。"
```

### ペルソナ設計の依頼
```bash
./scripts/agent-send.sh -f RESEARCHER -t MARKETER -m "中小企業の経営者（従業員10-50名）をターゲットとしたペルソナを3パターン作成してください。調査結果のインサイトを添付します。"
```

### 技術実装の相談
```bash
./scripts/agent-send.sh -f STRATEGIST -t ENGINEER -m "月間10万PVのSaaSサービスをCloudflare Workersで構築する場合の技術スタックと開発工数を見積もってください。"
```

### 収益モデルの検討
```bash
./scripts/agent-send.sh -f MARKETER -t FINANCIER -m "フリーミアムモデルでのSaaS事業において、月間ARR500万円を達成するためのプライシング戦略を検討してください。"
```

## 成功事例の規模感

このシステムは以下の規模感のビジネス立案に最適化されています：

### 事業規模
- **初期投資**: 100万円〜3,000万円
- **月間売上目標**: 50万円〜5,000万円
- **年間売上目標**: 1,000万円〜5億円

### チーム規模
- **創業メンバー**: 2-3名
- **初期チーム**: 3-8名
- **成長期チーム**: 5-15名

### 開発期間
- **MVP**: 3-8ヶ月
- **本格ローンチ**: 6-12ヶ月
- **スケールフェーズ**: 12-24ヶ月

## Cloudflare Workers対応

全ての技術設計はCloudflare Workersでの運用を前提としています：

- `wrangler.toml`の自動生成
- エッジコンピューティングを活かしたアーキテクチャ
- 低コスト・高パフォーマンスな運用設計
- TypeScript/JavaScriptでの実装推奨

## 開発者向け情報

### 必要な環境
- tmux
- Node.js (Wrangler CLI用)
- Python 3.8+ (ユーティリティ用)
- Git

### セッション管理
- セッション名: `smallbiz-dev`
- ウィンドウ数: 6（5エージェント + MONITOR）
- ログファイル: `logs/communication.log`

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。