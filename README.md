## 設計
### 睡眠ログ
記録するもの: 日付2000-01-01(text) 起床時刻23:59(text)、4段階評価1-4(数字型)、タグ(json型)


## 構成
### frontend
src/utils
- UIに関係しない汎用ロジック、 自分で書いた小さなヘルパー関数の置き場。可能であれば、同じ入力には必ず同じ出力を返し副作用のない関数（＝純粋関数）をおくことが好ましい。
- SvelteKitではlibが使われるがreactではutilsが使われる。
- JSXをおかず拡張子は、JSまたはTSになるはず。

src/components/
- 再利用可能なUIパーツ。特定のページに依存しないもの：Button.jsx, Modal.jsx, Avatar.jsx

src/pages/（または views/）
- ルートに対応する画面単位のコンポーネント。
- Next.js/SvelteKitなどファイルベースルーティングのフレームワークではフレームワーク側が管理するので自分で作らないことも多い

src/auth
- 認証関連のコンポーネント、関数置き場。LoginForm.jsx、useAuth.js、authApi.js

src/data
- 静的データ置き場



---
参考：
- https://github.com/TomaszSkrzyp/good-game
- https://github.com/swerve731/go-solid-todo-app/tree/main/frontend
- https://github.com/OpenListTeam/OpenList-Frontend/tree/main/src
- https://github.com/H3rmt/FileSharing
- https://github.com/PeterHagane/solid-pocketbase-boilerplate
- https://github.com/kevinganthy/poc-pocketbase-solidjs/tree/main/front




