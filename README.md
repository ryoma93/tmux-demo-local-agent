# Tmux Demo Local Agent

tmuxベースのマルチエージェント開発システムのコレクション。専門的なエージェントが協力して、LINE Bot、データパイプライン、スモールビジネス立案などの複雑なシステムを効率的に開発できる環境を提供します。

## 🚀 概要

このプロジェクトは、tmuxを活用した革新的な開発アプローチを提供します。複数の専門エージェントが同時に作業し、リアルタイムでコミュニケーションを取りながら、高品質なソフトウェアを迅速に開発できます。

### 主な特徴

- **マルチエージェント協調開発**: 各エージェントが専門分野に特化
- **リアルタイム通信**: 優先度付きメッセージングシステム
- **Cloudflare Workers対応**: Wranglerを使用した簡単なデプロイメント
- **包括的なテンプレート**: すぐに使える実装パターン
- **自動プロジェクト初期化**: ボイラープレートコードの自動生成

## 📦 含まれるシステム

### 1. LINE Bot Multi-Agent System

LINE Bot開発に特化したマルチエージェントシステム。

**エージェント構成:**
- **ARCHITECT**: システム設計、API仕様、データベーススキーマ
- **BACKEND**: Webhook実装、ビジネスロジック、サーバーサイド開発
- **FRONTEND**: LINE UI設計（Rich Menu、Flex Message、Quick Reply）
- **TESTER**: テスト戦略、品質保証

**主な機能:**
- LINE Webhook署名検証
- Flex Messageテンプレート
- Rich Menu設定ツール
- メッセージビルダーユーティリティ

### 2. Data Pipeline Multi-Agent System

データ収集、処理、分析のためのマルチエージェントシステム。

**エージェント構成:**
- **COLLECTOR**: API、ファイル、DB、ストリーミングデータの収集
- **PROCESSOR**: データクレンジング、変換、標準化
- **ANALYZER**: 統計分析、品質評価、異常検知
- **STORAGE**: データ保存設計、最適化、管理
- **MONITOR**: システム監視、ログ管理

**主な機能:**
- APIコレクターテンプレート（レート制限対応）
- データ処理パイプライン
- 包括的なデータ検証ツール
- ストレージ最適化ユーティリティ

### 3. Small Business Multi-Agent System

スモールビジネス（数百万円〜数億円規模）の立案・設計に特化したマルチエージェントシステム。

**エージェント構成:**
- **STRATEGIST**: ビジョン・ミッション設計、事業戦略立案
- **RESEARCHER**: 市場調査、ユーザーニーズ分析、競合分析
- **MARKETER**: ペルソナ設計、SNSマーケティング戦略
- **ENGINEER**: 技術実現可能性、システムアーキテクチャ設計
- **FINANCIER**: ビジネスモデル設計、財務計画、収益予測

**主な機能:**
- ビジネスモデルキャンバステンプレート
- 詳細ペルソナ設計フレームワーク
- 市場調査・競合分析テンプレート
- ビジネスプラン妥当性検証ツール
- 小規模チーム向け技術スタック評価

## 🛠️ セットアップ

### 前提条件

- tmux（バージョン2.0以上）
- Node.js（v14以上）
- Python 3.8以上（データパイプライン用）
- Wrangler CLI（Cloudflareデプロイ用）

### インストール

1. **リポジトリのクローン:**
   ```bash
   git clone https://github.com/yourusername/tmux-demo-local-agent.git
   cd tmux-demo-local-agent
   ```

2. **Wrangler CLIのインストール（Cloudflareデプロイ用）:**
   ```bash
   npm install -g wrangler
   ```

## 🚀 使用方法

### LINE Bot開発

1. **マルチエージェントシステムの起動:**
   ```bash
   cd linebot-multi-agent && ./scripts/setup.sh
   ```

2. **新しいLINE Botプロジェクトの初期化:**
   ```bash
   ./utils/project-init.sh
   ```

3. **エージェント間通信:**
   ```bash
   # 特定のエージェントへメッセージ送信
   ./scripts/agent-send.sh -f ARCHITECT -t BACKEND -m "Webhookエンドポイントを実装してください"
   
   # 全エージェントへブロードキャスト
   ./scripts/agent-send.sh -f BACKEND -t ALL -m "Webhook実装完了" -p HIGH
   ```

### データパイプライン開発

1. **マルチエージェントシステムの起動:**
   ```bash
   cd data-pipeline-multi-agent && ./scripts/setup.sh
   ```

2. **新しいデータパイプラインプロジェクトの初期化:**
   ```bash
   ./utils/pipeline-init.sh my-pipeline batch
   ```

3. **エージェント間通信:**
   ```bash
   # データ収集完了の通知
   ./scripts/agent-send.sh -f COLLECTOR -t PROCESSOR -m "データ収集完了、処理開始可能"
   
   # 品質レポート
   ./scripts/agent-send.sh -f ANALYZER -t ALL -m "データ品質95%、異常なし" -p HIGH
   ```

### スモールビジネス立案

1. **マルチエージェントシステムの起動:**
   ```bash
   cd smallbiz-multi-agent && ./scripts/setup.sh
   ```

2. **新しいビジネスプロジェクトの初期化:**
   ```bash
   ./utils/project-init.sh
   ```

3. **エージェント間通信:**
   ```bash
   # 市場調査の依頼
   ./scripts/agent-send.sh -f STRATEGIST -t RESEARCHER -m "AIを活用したSaaSの市場調査を実施してください"
   
   # 収益モデルの検討
   ./scripts/agent-send.sh -f MARKETER -t FINANCIER -m "フリーミアムモデルでのプライシング戦略を検討してください"
   ```

## ☁️ Cloudflareデプロイメント

すべてのマルチエージェント開発アプリケーションは、Cloudflare Workersへのデプロイを前提としています。

### デプロイ手順

1. **Cloudflareへのログイン:**
   ```bash
   wrangler login
   ```

2. **プロジェクトの初期化:**
   ```bash
   wrangler init my-app
   ```

3. **設定ファイルの編集:**
   `wrangler.toml`を編集して、必要な環境変数やルーティングを設定

4. **デプロイ:**
   ```bash
   wrangler deploy
   ```

5. **ログの確認:**
   ```bash
   wrangler tail
   ```

### 環境変数の管理

```bash
# シークレットの設定
wrangler secret put LINE_CHANNEL_SECRET
wrangler secret put LINE_CHANNEL_ACCESS_TOKEN

# シークレットの一覧表示
wrangler secret list
```

## 📁 プロジェクト構造

```
tmux-demo-local-agent/
├── CLAUDE.md                    # Claude AI用の開発ガイドライン
├── README.md                    # このファイル
├── .gitignore                   # Git除外設定
├── linebot-multi-agent/         # LINE Bot開発システム
│   ├── scripts/                 # 自動化スクリプト
│   ├── instructions/            # エージェント役割定義
│   ├── templates/               # LINE Botテンプレート
│   ├── utils/                   # 開発ユーティリティ
│   └── logs/                    # 通信ログ
├── data-pipeline-multi-agent/   # データパイプラインシステム
│   ├── scripts/                 # 自動化スクリプト
│   ├── instructions/            # エージェント役割定義
│   ├── templates/               # パイプラインテンプレート
│   ├── utils/                   # データ処理ユーティリティ
│   └── logs/                    # 通信ログ
└── smallbiz-multi-agent/        # スモールビジネス立案システム
    ├── scripts/                 # 自動化スクリプト
    ├── instructions/            # エージェント役割定義
    ├── templates/               # ビジネス計画テンプレート
    ├── utils/                   # ビジネス分析ユーティリティ
    └── logs/                    # 通信ログ
```

## 🎮 Tmuxナビゲーション

- **エージェント間の切り替え**: `Ctrl-b + [0-5]` (スモールビジネスシステムは6ウィンドウ)
- **ウィンドウ一覧表示**: `Ctrl-b + w`
- **セッションからデタッチ**: `Ctrl-b + d`
- **セッションへ再アタッチ**: 
  - LINE Bot: `tmux attach -t linebot-dev`
  - データパイプライン: `tmux attach -t data-pipeline-dev`
  - スモールビジネス: `tmux attach -t smallbiz-dev`

## 📝 開発ガイドライン

### CLAUDE.md

このプロジェクトには、Claude AIと協力して開発する際のガイドラインを記載した`CLAUDE.md`ファイルが含まれています。新しいルールや標準的な手順は、このファイルに追加されます。

### ベストプラクティス

1. **エージェント間通信**: 明確で文脈のあるメッセージを使用
2. **優先度の設定**: 緊急度に応じて適切な優先度を設定
3. **ログの活用**: `logs/communication.log`で通信履歴を確認
4. **テンプレートの利用**: 提供されているテンプレートから開始
5. **環境変数**: 機密情報は必ず環境変数で管理

## 🤝 コントリビューション

プロジェクトへの貢献を歓迎します！

1. 新しいエージェントタイプの追加
2. テンプレートの拡充
3. ユーティリティ関数の改善
4. ドキュメントの更新
5. バグ修正とパフォーマンス改善

## 📚 リソース

### LINE Bot開発
- [LINE Developers Documentation](https://developers.line.biz/ja/docs/)
- [Messaging API リファレンス](https://developers.line.biz/ja/reference/messaging-api/)
- [LINE Bot Designer](https://developers.line.biz/ja/services/bot-designer/)

### Cloudflare Workers
- [Workers ドキュメント](https://developers.cloudflare.com/workers/)
- [Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/)
- [Workers Examples](https://developers.cloudflare.com/workers/examples/)

### データパイプライン
- [Apache Spark](https://spark.apache.org/)
- [Apache Kafka](https://kafka.apache.org/)
- [dbt (data build tool)](https://www.getdbt.com/)

### スモールビジネス開発
- [Business Model Canvas](https://www.strategyzer.com/business-model-canvas)
- [Lean Startup](http://theleanstartup.com/)
- [Market Research Best Practices](https://blog.hubspot.com/marketing/market-research-buyers-guide-ht)

## 📄 ライセンス

MIT License - 自由に使用、変更、配布できます。

---

**注意**: このプロジェクトは継続的に進化しています。最新の情報は、各サブシステムのREADMEファイルを参照してください。 