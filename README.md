RaffleDraw
==========

HAML + SCSS + CoffeeScript 寫的 3D 抽獎程式

Demo: [https://neson.github.com/RaffleDraw/](https://neson.github.com/RaffleDraw/)

- - -

## 使用

[下載](https://github.com/Neson/RaffleDraw/archive/gh-pages.zip) 後用 Chrome 開 `index.html`。

### 抽獎操作

| 鍵盤按鍵 | 功能                 |
| -------- | -------------------- |
| `Space`  | 抽獎                 |
| `Enter`  | 抽獎                 |
| `S`      | 使用 Google 語音唱名 |
| `1~9`    | 調整速度 (×2 秒)     |

### 抽獎資料

需要放在與 `index.html` 同目錄下的 `data.js`。若 `data.js` 中沒資料會轉用 `data.demo.js`。  
格式如：

```js
var data = [
    {
        "name": "陳俞安",
        "id": "000-00-001",
        "avator": "http://placehold.it/150x150"
    },
    {
        "name": "陳凡睿",
        "id": "000-00-002",
        "avator": "http://placehold.it/150x150"
    }
]
```

屬性意義如下：

- `name`: 必須資料，名稱。方便從資料庫匯出的資料直接貼上使用，改成 `full_name` 或 `fullname` 也可以。
- `avator`: 頭像。改用 `img` 也行。
- `id`: 編號。若改用 `fbid` (Facebook ID)，會自動從 FB 抓取頭像，點頭像會連結到 FB 塗鴉牆。

## Build

使用 [Middleman](http://middlemanapp.com/)

```
bundle install
middleman build
```
