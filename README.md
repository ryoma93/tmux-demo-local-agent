# Tmux Demo Local Agent

tmuxベースのマルチエージェント開発システムのコレクション。専門的なエージェントが協力して、LINE Botやデータパイプラインなどの複雑なシステムを効率的に開発できる環境を提供します。

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
└── data-pipeline-multi-agent/   # データパイプラインシステム
    ├── scripts/                 # 自動化スクリプト
    ├── instructions/            # エージェント役割定義
    ├── templates/               # パイプラインテンプレート
    ├── utils/                   # データ処理ユーティリティ
    └── logs/                    # 通信ログ
```

## 🎮 Tmuxナビゲーション

- **エージェント間の切り替え**: `Ctrl-b + [0-4]`
- **ウィンドウ一覧表示**: `Ctrl-b + w`
- **セッションからデタッチ**: `Ctrl-b + d`
- **セッションへ再アタッチ**: `tmux attach -t [session-name]`

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

## 📄 ライセンス

MIT License - 自由に使用、変更、配布できます。

---

**注意**: このプロジェクトは継続的に進化しています。最新の情報は、各サブシステムのREADMEファイルを参照してください。 