# README
react-i18nextを多言語対応の検証

- 使いやすい、分かりやすい、Docがちゃんと書いてある
- reactでもRailsのconfig/locales 配下のファイルを読み込むことができること

# 検証のバージョン

- Rails 6.0.0
- React 16.10.2
- react-i18next 10.13.1

# ロカール環境確認

## 起動
```sh
$ docker-compose build
# upすると、両方rails sとbin/webpack-dev-serverが実行される
$ docker-compose up
```
## 確認

http://0.0.0.0:3000/

de-enボタンをクリックして言語が切り替えることを確認してください。

[![Image from Gyazo](https://i.gyazo.com/d4af5ff6fa63d62fc9d611aaeb65311b.gif)](https://gyazo.com/d4af5ff6fa63d62fc9d611aaeb65311b)

# 設定内容

## react-i18nextのGithub 
https://github.com/i18next/react-i18next

## 必要なライブラリをインストール

i18nextとreact-i18nextだけのインストールは必要ですが、i18next-xhr-backendとi18next-browser-languagedetectorもおすすめです。
```sh
$ yarn add i18next i18next-xhr-backend i18next-browser-languagedetector react-i18next
```
- https://github.com/i18next/react-i18next
- https://github.com/i18next/i18next-xhr-backend
  -  xhrを使用してバックエンドサーバーからリソースをロードする用です。
- https://github.com/i18next/i18next-browser-languageDetector
  - ブラウザでユーザー言語を検出するために使用されるi18next言語検出プラグインです。

## i18n.jsファイル作成
https://github.com/Sparobo/rails-react-i18next/blob/master/app/javascript/packs/i18n.js

i18nextを設定する用です。どんなプラグインを使うか、サーバからリソースをロードパスもこちらを設定します。
デフォルトのロードパスは/locales/{{lng}}/translation.jsonです。{{lng}}はen, jpなどです。
今回/locales/{{lng}}.jsonを設定します。

```javascript
...
  .init({
    fallbackLng: 'en',
    debug: true,
    ...
    backend: {
      loadPath: '/locales/{{lng}}.json',
    }
  });
```
詳細の設定説明はこちらを参考してください。
- https://www.i18next.com/overview/configuration-options
- https://react.i18next.com/latest/i18next-instance

## バックエンドのlocalesロードパス準備

```yaml
# config/locales/en.yml
en:
  title: "Welcome to react using react-i18next"
  description:
    part1: "To get started, edit <1>App.js</1> and save to reload."
    part2: "Switch language between english and german using buttons above."
```

```yaml
# config/locales/de.yml
de:
  title: "Willkommen zu react und react-i18next"
  description:
    part1: "Um loszulegen, ändere <1>App(DE).js</1> speicheren und neuladen."
    part2: "Ändere die Sprachen zwischen deutsch und englisch mit Hilfe der beiden Schalter."
```

```ruby
# route.rb
Rails.application.routes.draw do
  root to: 'home#index'

  namespace :locales do
    get :en, format: 'json'
    get :de, format: 'json'
  end
end
```

```ruby
class LocalesController < ApplicationController
  before_action :render_locale
  
  def en; end
  def de; end

  private

  def render_locale
    lang = params[:action]
    render json: YAML.load_file(File.open("config/locales/#{lang}.yml"))[lang].to_json
  end
end
```

## テスト用App.js作成
https://github.com/Sparobo/rails-react-i18next/blob/master/app/javascript/packs/App.js

これはreact-i18nextからExampleをそのまま使います。三つの翻訳方法を紹介します。

```javascript
import { useTranslation, withTranslation, Trans } from 'react-i18next';
import './i18n';
```

### useTranslation (hook)
https://react.i18next.com/latest/usetranslation-hook

```javascript
const { t, i18n } = useTranslation();
```

### withTranslation (HOC)
https://react.i18next.com/latest/withtranslation-hoc

```javascript
// use hoc for class based components
class LegacyWelcomeClass extends Component {
  render() {
    const { t, i18n } = this.props;
    return <h2>{t('title')}</h2>;
  }
}
const Welcome = withTranslation()(LegacyWelcomeClass);
```

### Translation (render prop)
https://react.i18next.com/latest/translation-render-prop

```javascript
// Component using the Trans component
const MyComponent = () => {
  return (
    <Trans i18nKey="description.part1">
      To get started, edit <code>src/Home.js</code> and save to reload.
    </Trans>
  );
}
```

### コンテンツ翻訳
```
<div>{t('title')}</div>
<div>{t('description.part2')}</div>
```

### 言語を切り替える

```javascript
i18n.changeLanguage('en');
i18n.changeLanguage('de');
```

# DIFF確認用
https://github.com/Sparobo/rails-react-i18next/compare/f0bbc9048e0d7760300647b392636c65dbce3716...master

# Doc
https://react.i18next.com/

# 参照
https://shinshin86.hateblo.jp/entry/2019/09/28/084835
