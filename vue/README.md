## vueファイル

scriptブロック、テンプレートブロック、スタイルブロックからなる

## テンプレート変数

ref()関数か、computed()関数で定義された変数。これらを使わないと変数展開されないのと、リアクティブデータにならない。

リアクティブデータとは、変数の変化を自動で検知し反映させる仕組みを持つ変数？のことを言う

### マスタッシュ構文

htmlの中身を書く際の変数展開の方法。変数は、テンプレート変数である必要がある

```
{{変数名}}
```

### ref()関数

テンプレート変数の宣言方法の一つ。値の書き換えは `変数名.value`に対して行う必要がある

### computed()関数

日本語で算出プロパティと呼ばれる。計算結果をリアクティブデータとしたい際に使われる

### reactive()関数

オブジェクトをまとめてリアクティブデータとする際に使われる。参照の際は、`変数名.プロパティ名`となる。値の書き換えは、ref()関数とは異なり、`.value`が必要なく、`変数名.プロパティ名 = xxx`で書き換えられる

## ディレクティブ

テンプレートタグでHTMLタグ内に記述する`v-`で始まる属性をディレクティブと呼ぶ

| ディレクティブ | 役割                                                                                                                   |
| -------------- | ---------------------------------------------------------------------------------------------------------------------- |
| v-bind         | データバインディング                                                                                                   |
| v-on           | イベント処理                                                                                                           |
| v-model        | 双方向データバインディング                                                                                             |
| v-html         | HTML文字列表示（dangerously html）                                                                                     |
| v-pre          | 静的コンテンツ表示 （変数展開させない）                                                                                |
| v-once         | データバインディングを初回のみに制限                                                                                   |
| v-cloak        | Vue instanceの初期化が終わるまで、マスタッシュ構文を非表示。おそらくApp.vueでしか使わない。App.vueでは使った方がよい。 |
| v-if           | 条件分岐                                                                                                               |
| v-show         | 表示/非表示の制御                                                                                                      |
| v-for          | ループ処理                                                                                                             |

### v-bind

htmlタグの任意の属性にテンプレート変数を適用する際に利用する。`v-bind:属性名="変数名"`の形。省略形は`:属性名="変数名"`

v-bindをつけた場合、""の中身がevalされるものと考えられる（つけないとただの文字列として評価される）。

```vue
<script setup lang="ts">
import { ref } from 'vue'

const url = ref('http://vuejs.org/')
const attr = ref('href')
const multipleAttr = ref({
  width: '100px',
  height: '100px',
  display: 'inline'
})
</script>

<template>
  <p><a v-bind:href="url">サイト</a></p>
  <p><a :href="url">v-bindの省略形はコロン</a></p>
  <p><a :[attr]="url">属性を変数にできる。指定には[]が必要</a></p>
  <p :="multipleAttr" height="10px">属性をまとめて指定もできる。属性の衝突はあと勝ち</p>
  <p :class="{ isRed: true, isBgWhite: false }">
    style属性やclass属性はカンマ区切りで複数の変数が渡せる
  </p>
</template>
```

### v-on

イベントハンドラの登録に使う。`v-on:イベント名=関数名`省略形は`@イベント名=関数名`。関数名はref()やcomputed()で囲う必要がない（リアクティブデータである必要がないため）

関数の呼び出し側（templateブロック側）では、関数名で呼び出すか、関数として呼び出す。

```vue
<script setup lang="ts">
const log = (type: string, event: MouseEvent): void => {
  console.log(e);
  console.log(type);
}
</script>

<template>
  <p @click="log">eventの中身が出る（MouseEventが一つ目の引数に入ってくる）/p>
  <p @click="log("1")">1が出る</p>
  <p @click="log("2", $event)">2が出て、eventの中身も取れる</p>
</template>
```

#### 主なイベント（composition系はIMEに関するイベント）

| ディレクティブ | 役割                                                                                                           |
| -------------- | -------------------------------------------------------------------------------------------------------------- |
| フォーカス     | blur, focus, focusin, focusout                                                                                 |
| マウス         | click, contextmenu, dblclick, mousedown, mouseenter, mouseleave, mousemove, mouseout, mouseover, mousup, wheel |
| 入力           | change, compositionend, compositionstart, compositionupdate, input, keydown, keypress, keyup, select           |
| その他         | resize, scroll                                                                                                 |

#### 修飾子

`@イベント名.修飾子`で、stopPropagationやpreventDefaultなどができる

| 修飾子  | 内容                                                                                                                               |
| ------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| stop    | stopPropagation                                                                                                                    |
| capture | イベントリスナーをキャプチャモードにする                                                                                           |
| self    | イベント発生がこの要素のときのみに限定                                                                                             |
| prevent | preventDefault                                                                                                                     |
| passive | addEventListnerにおけるpassive: true。該当イベントのデフォルトの挙動が即時実行される（preventDefaultしないことを開発者が保証する） |
| once    | イベントの実行を１回のみとする                                                                                                     |

#### click/keyイベントのみの修飾子

keyイベントは、どのキーが押下されたのかを取れる。`@keydown.q="..."`や`@keydown.enter="..."`など

clickイベントは、左クリックなのか右クリックなのかやシステムキーと一緒に押下されたかなどを取れる。`@click.right="..."`やなど`@click.shift="..."`

シフトキーなどが押された場合を除外するために、exact修飾子で制御できる。`@keydown.enter.exact`のように。

### v-model

inputタグのように、ユーザー入力によりhtml側から状態の変更が可能なものに対して双方向データバインディングを行うことができることを示す。意外にも省略形がない。チェックボックスの場合、true-value/false-valueで、それぞれの値を指定できる。

```vue
<script>
const isAgreed = ref(false)
</script>

<template>
  <input type="checkbox" v-model="isAgreed" true-value="1" false-value="0" />
</template>
```

#### v-modelの修飾子

| 修飾子 | 内容                                                                    |
| ------ | ----------------------------------------------------------------------- |
| lazy   | inputイベントの代わりにchangeイベントで双方向データバインディングを行う |
| number | 入力値を数値として扱う                                                  |
| trim   | 入力値の前後の空白を取り除く                                            |

### v-if

条件に一致した場合のみ、このディレクティブがついているタグ（と、その子要素）がレンダリングされる。一致しない場合は<!--v-if-->という形でコメントアウトされてレンダリングされる。複数のタグを表示しないといけない場合、divで括らずにtemplateで括ればOK。余計なdivがつかなくてよい。

```vue
<script setup lang="ts">
const number = computed((): number => Math.round(Math.random() * 100))
</script>

<template>
  <p>
    評価は
    <span v-if="number >= 80">A</span>
    <span v-else-if="number >= 60">B</span>
    <span v-else-if="number >= 40">C</span>
    <span v-else>D</span>
    です。
  </p>
</template>
```

### v-show

v-ifに似ているが、v-ifと違い、falseの場合でも要素はレンダリングされる。表示の切り替えの場合はv-showを使い、そもそも表示させるかの分岐の際はv-ifを使う

### v-for

v-forタグがついた要素を、ループして繰り返し表示できる。複数のタグをiterationごとに表示したい場合は、templateタグを使えば余計なタグが必要ない。

key属性が必須で、v-bind:keyの形でiteratorを参照してループ内でuniqueとなるようにつける（loop内で、じゃないかも）

for文しかないので、iteratableな整形済みのものをscriptブロックで加工しておき、加工済みのものをtemplateブロックに渡すしかない（reactみたいに、map関数とかでダイレクトに書けない）

```vue
<script>
const arr = ref([0, 1, 2, 3])
const obj = ref({ a: 'a', b: 'b', c: 'c' })
const map = ref(
  new Map() < number,
  string >
    [
      [0, '0'],
      [1, '1']
    ]
)
</script>

<template>
  <p>配列のループ</p>
  <ul>
    <li v-for="(v, idx) in arr" :key="v">arr[{{ idx }}] = {{ v }}</li>
  </ul>
  <p>オブジェクト（連想配列）のループ</p>
  <ul>
    <li v-for="(v, k, idx) in obj" :key="k">
      {{ idx + 1 }}番目のkeyの中身は、obj[{{ k }}] = {{ v }}
    </li>
  </ul>
  <p>Mapのループのときだけ、()ではなく[]を使う</p>
  <ul>
    <li v-for="[v, k] in map" :key="k">map[{{ k }}] = {{ v }}</li>
  </ul>
</template>
```

## ウォッチャー

算出プロパティは同期処理？のようで、非同期での値の変更は別の方法を使う必要がある。その方法がウォッチャーという仕組み。

### watchEffect()

```vue
watchEffect((): void => { // リアクティブ変数が更新されるたびに実行したい処理 })
```

引数として受け取ったcallbackに含まれるすべてのリアクティブ変数を監視し、それらのどれか１つでも更新されると、コールバック関数を実行する。

### watch()

```vue
watch( [監視したいリアクティブ変数], (newVal, oldVal): void => { //
リアクティブ変数が更新されるたびに実行したい処理 }, { immediate: true} )
```

#### watchEffect()と違う点

- 監視したい変数を限定できる
- 現在の値、更新後の値を取得できる
- { immediate: true }オプションをつけないと、初回起動時にcallbackが実行されない

## ライフサイクルフック

スクリプトブロックに`onライフサイクルイベント名`という関数を定義する。たとえば、beforeMountの場合、下記のように定義する。

```vue
<script>
onBeforeMount(():void => {
    // マウントの前に実行したい処理
})
</script>
```

### コンポーネントのライフサイクルの一般的なフック

| ライフサイクルフック名 | 呼び出しタイミング                                            |
| ---------------------- | ------------------------------------------------------------- |
| beforeMount            | コンポーネントの解析処理後、決定したDOMをレンダリングする直前 |
| mounted                | DOMのレンダリングが完了し、表示状態になった時点               |
| beforeUpdate           | リアクティブデータが変更され、DOMの再レンダリングを行う前     |
| updated                | DOMの再レンダリングが完了した時点                             |
| beforeUnmount          | コンポーネントのDOMno非表示処理を開始する直前                 |
| unmounted              | コンポーネントのDOMの非表示処理が完了した時点                 |

## デバッグ用

これらのイベントは、コールバックの引数にDebuggerEvent型を取る
|ライフサイクルフック名|呼び出しタイミング|
|-|-|
|renderTracked|リアクティブ変数に初めてアクセスが発生した時点|
|renderTriggered|リアクティブ変数が変更され、再レンダリングされる際に、その変数へのアクセスが発生した時点|

### その他

| ライフサイクルフック名 | 呼び出しタイミング                               |
| ---------------------- | ------------------------------------------------ |
| errorCaptured          | 配下のコンポーネントを含めてエラーを検知した時点 |
| activated              | コンポーネントが待機状態ではなくなった時点       |
| deactivated            | コンポーネントが待機状態になった時点             |

### Composition APIでは、まず使わない

beforeCreateとCreatedイベントは、Composition APIではスクリプトブロックのloadタイミングと一緒なので、scriptブロックに記載するだけで代替できる。
|ライフサイクルフック名|呼び出しタイミング|
|-|-|
|beforeCreate| 起動開始直後、Vueアプリケーションの初期化処理前|
|created||Vueアプリケーションの初期化処理後|

## コンポーネント間通信

### Props

利用側は、propsのそれぞれの名前を属性値として、値を入力すればよい。属性値が変数の場合は、v-bindをつける。

```vue
<template>
  <TestComponent v-bind:prop1="var1" />
</template>
```

スクリプトブロック内にinterfaceを記述し、defineProps()を呼び出すことで登録できる。

```vue
<script setup lang="ts">
interface newProps {
  prop1: string
}
// propsをスクリプトブロック内で利用しない場合は等式左側は不要
const props = defineProps<newProps>()
</script>
```

デフォルト値が必要な場合、defineProps()を、withDefaults()という関数で括り、それぞれのpropsのデフォルト値を規定する。ただし、式が複雑な場合は算出プロパティにする必要がある

```vue
<script setup lang="ts">
interface newProps {
  prop1: string
}
// propsをスクリプトブロック内で利用しない場合は等式左側は不要
// withDefaults()は、デフォルト値の設定が入らない場合は不要
const props = withDefaults(defineProps<newProps>(), {
  props1: 'unavailable'
})
</script>
```

## 動的コンポーネント

コンポーネントを動的に指定するには、`component`タグを使い、`v-bind:is`ディレクティブを指定する。

```vue
<script setup lang="ts">
import { ref } from 'vue'
import Input from './components/Input.vue'
import Ratio from './components/Radio.vue'

const currentComp = ref(Input)
const onClick = (): void => {
  if (currentComp.value === Input) {
    currentComp.value = Ratio
  } else {
    currentComp.value = Input
  }
}
</script>

<template>
  <KeepAlive>
    <component v-bind:is="currentComp" />
  </KeepAlive>
</template>
```

`<KeepAlive>`タグは、動的にレンダリングされたコンポーネントの状態を保持でき、コンポーネントが切り替わったあとも状態を保持しておける

## slot

コンポーネントに`<slot>`タグを定義しておくと、そのコンポーネントの子コンポーネントとして指定することで、コンポーネントで定義された`<slot>`タグの位置に、任意の要素を渡すことができる。

```vue
<template>
  <p>slot test</p>
  <slot>
    <p>slotタグ内に要素を記述することで、デフォルトコンポーネントを用意することができる</p>
  </slot>
  <slot name="second" />
  <template></template>
</template>
```

```vue
<SlotComponent>
  <p v-slot:default>this is passed from the parent component</p>
  <template #second>
    <span>Hello</span>
    <span>World</span>
  </template>
</SlotComponent>
```

複数slotを用意する場合はname属性を指定しておく。呼び出す側では、`v-slot`をつかって指定する。v-slotの省略形は"#"で表せる

v-slotの属性を変数にしたい場合は、`[変数名]`を使って指定する。

```vue
<script setup lang="ts">
const name = 'default'
</script>
<template>
  <SlotComponent>
    <template v-slot:[name]>
      <span>Hello</span>
    </template>
  </SlotComponent>
</template>
```

### スコープ付きslot

親コンポーネントから、子コンポーネントの変数を利用するための仕組み。
`<slot>`タグ内で、公開するprops名をv-bindで渡しておく。

```vue
<script setup lang="ts">
  const props = ref(0);
</script>

<template>
  <p>test</p>
  <slot v-bind:publishedProps="props">
</template>

```

受け手側では、`<template>`タグで`v-slot`の右辺に任意の変数を指定することで、受け取れる。

```vue
<TestComponent>
  <template v-slot="p">
    {{p.publishedProps}}
  </template>
</TestComponent>
```

わざわざ任意の変数をしていするのは煩雑なので、分割代入する方がよい。

```vue
<TestComponent>
  <template v-slot="{publishedProps}">
    {{publishedProps}}
  </template>
</TestComponent>
```

## Emit

コンポーネント通信を行う仕組み

```vue
interface Emits { (event: "eventName", argument: unknown): void } const emit = defineEmits
<Emits></Emits>
```

親コンポーネントで、`v-on:eventName`を購読することで、親コンポーネントで子コンポーネントのイベントを補足できる。

propsの値を更新したい場合、親コンポーネント側でイベント名を購読する代わりに、v-modelで渡し、子コンポーネント側ではupdate:Prop名とすることで、親側が管理しているpropsを子コンポーネントが直接書き換えることができる

```vue
<script setup lang="ts">
const point = ref(10)
</script>

<template>
  <ChildComponent v-model:point="point" />
</template>
```

```vue
<script setup lang="ts">
interface Props {
  point: number
}

defineProps<Props>()

const onUpdate = (e: Event): void => {
  const newPoint = Number(e.target.value)
  emit('update: point', newPoint)
}
</script>

<template>
  <input type="number" v-on:input="onUpdate" v-bind:value="point" />
</template>
```

## ProvideとInject

propsのバケツリレーを解決するしくみ。Globalなストアオブジェクトを持つ。
App.vueからデータを提供（Provide）し、各コンポーネントでデータを注入（Inject）する。

```App.vue
<script setup lang="ts">
import { ref, provide } from "vue";
const data = {
    a: 0,
    b: 1,
    c: 2
}
// reactive変数でdataをprovide
provide("data", reactive(data));
</script>
```

ref関数の場合、`.value`でないとデータにアクセスできずややこしいので、reactive変数を使う方が間違いが起きにくい。
コンポーネント側では、inject()を使うことでデータへアクセスできる

```vue
<script setup lang="ts">
import { inject } from 'vue'

const data = inject('data') as [key: number]
</script>
```

## Vue Router

### ルーティング設定

`route`フォルダのindex.tsファイルへroutingを記述する。
historyには、`createWebHistory()`か、`createWebHashHistory()`のどちらかを指定できる。通常は前者。
後者はhistory APIが使えない古いブラウザまでサポートしたい場合に使う。

`createWebHistory()`の引数には、すべてのURLに付加するベースパス(e.g. /app/)を指定できる。指定しない場合は、`/`が与えられる。

下記の`import.meta`はES2020で導入された仕組みで、モジュールのメタ情報を取得できる。`import.meta.env`はViteが作成する環境変数で、プロジェクト直下の`vite.config.ts`が元になる。

```vue
import { createRouter, createWebHistory } from 'vue-router' import AppTop from "@views/AppTop.vue"
const routeSettings = [ { path: "/", name: "AppTop", component: AppTop } ] const router =
createRouter({ history: createWebHistory(import.meta.env.BASE_URL), routes: routeSettings }) export
default router;
```

Routerを効かせたいコンポーネント内で、RuoterViewコンポーネントを呼び出す

```vue
<template>
  <main>
    <RouterView />
  </main>
</template>
```

### Paramsを渡す

Paramsを渡すには、route settingsで、`:id`などparamsを`path`に指定する。

受け取るコンポーネントがparamsをprops経由で取得することを許可するため、 `props: true`を指定する。こうすると、paramsが文字列で取得できる。

paramsを成形しておきたい場合は、`prop`プロパティに関数を渡し、成形済みのparamsを返すように記述する。

```vue
const routeSettings = [ { path: "/members/:id", name: "MemberShow", component: MemberShow, props:
(routes) => { const idNum = Number(routes.params.id); return { id: idNum } } } ]
```

Router内でのリンクはRouterLinkを使う

```vue
<script setup lang="ts">
  import {RouterLink} from "vue-router"
  const id = ref("id")
</script>

<template>
 <RouterLink v-bind:to="{name: 'nameOfTheRouting', params: {id: id}}">
   こちら
 </RoterLink>
</template>
```

指定には`name`が推奨される。パス名は、変更されがちのため。

paramsの受け取り自体は、definePropsで可能。`id`は、`props.id`で取得できる。

### リダイレクト

リダイレクトは、redirectプロパティを使う。

```vue
{ path: "member/old", name: "old", redirect: { name: "MemberNew" } }
```

### ルートパラメーターの記法

`/members/:id`というように書くのが基本だが、他にもいくつかルールが存在する。

#### 複数パラメーター

複数のパラメーターを指定できる。パラメーターへのアクセスは、`route.params.name`, `route.params.points`で可能

```vue
/members/search/:name/:points
```

#### 省略可能パラメーター

`?`をつけたパラメーターは省略できる。

```vue
/members/search/:name/:points?
```

とした場合、`/members/search/tanaka/45`も、`/members/search/tanaka`も、ヒットする。

#### 可変長パラメーター

ルートパラメーターの個数を限定しない書き方もできる。 `*`の場合、ルートパラメーターが0個以上、`+`の場合１個以上でヒットする。

```vue
/members/call/:id* localhost:3000/members/call // => OK localhost:3000/members/call/12/34/56 // =>
OK
```

```vue
/members/call/:id+ localhost:3000/members/call // => NG localhost:3000/members/call/12/34/56 // =>
OK
```

どちらの場合も、route.params.idには、配列が格納される

#### 正規表現

idが5桁であることを保証するには、下記のようにする

```vue
/memnbers/pull/:id(\\d{5})
```

### useRouter

スクリプトブロックでルーティングを制御するためのオブジェクトを取得するには、useRouterを使う

```
impoprt { useRouter } from 'vue-router'
const router = useRouter()
```

routerオブジェクト（RouteLocationNormalized型）には、下記のようなメソッドがある。
|メソッド|内容|
|-|-|
|push()|指定パスに遷移する|
|replace()|現在のパスを置き換える|
|back()|一つ前の履歴に戻る|
|forward()|一つ後ろの履歴に進む|
|go|履歴上の指定の画面に進む|

プロパティは下記のようなものがある
|プロパティ|内容|例|
|-|-|-|
|name|ルーティング名|`MemberDetail`|
|fullpath|path, hash, queryの全てが含まれた文字列|`/member/detail/1#section?name=tanaka`
|path|ルーティングパス文字列|`/member/detail/1`|
|hash|ハッシュ（`#`含む）|`#section`|
|query|クエリパラメーターのオブジェクト（`?`含まず）|`{name: tanaka}`|
|params|ルートパラメーターのオブジェクト|`{id: 1}`|

### ルーティングのネスト

`children`プロパティに、pathの配列をつけることによって実現できる。`children`プロパティ内のpathは、`/`をつけると正しく機能しない。

```vue
{ path: "/parent", name: "Parent", component: Parent, children: [ { path: "information", name:
"ParentInfo", component: ParentInfo } ] }
```

対象となる親コンポーネントには、`<RouterView/>`タグを入れる必要がある。上記の例の場合、Parentコンポーネントに`<RouterView/>`コンポーネントを描画させる必要がある。

### マルチビュー

複数のエリアの表示を、別々のルーターで管理できる。使い道がわからない。

### ナビゲーションガード

画面遷移が発生する前後に処理を挟むことができる。
ガードメソッドやその記述内は、下記の通り

| カテゴリ           | ガードメソッド    | 記述先             |
| ------------------ | ----------------- | ------------------ |
| グローバル         | beforeEach        | router/index.ts    |
|                    | beforeResolve     |                    |
|                    | afterEach         |                    |
| ルーティングごと   | beforeEnter       |                    |
| コンポーネントごと | beforeRouteEnter  | 各コンポーネント内 |
|                    | beforeRouteUpdate |                    |
|                    | beforeRouteLeave  |                    |

## Pinia

Vueのストアライブラリ。データへの変更処理や、読み出しの際の成形を担う。
Vue 2系ではVuexだったが、今はメンテされておらず代わりのライブラリがPinia。

`npm init vue@latest`時にpiniaをプロジェクトに追加するようにすると、`src`直下に`stores`フォルダが生成され、main.tsに下記のコードが追加されている。

```vue
import { createPinia } from 'pibia' app.use(createPinia())
```

### ストアファイル

`stores/`ディレクトリに配置するファイル。ストアのファイル名と、defineStore()で定義するidの文字列は一致させることが推奨される。たとえば、ファイル名が`counter.ts`だったとき、下記のようにStoreを定義する。

```ts
import { defineStore } from 'pinia'

interface State {
  counter: number
}
// use`Store名`Storeという名前にする
export const useCounterStore = defineStore({
  // ファイル名と一致させる
  id: 'counter',
  state: (): State => ({
    counter: 0
  }),
  getters: {
    doubleCount: (state) => state.counter * 2,
    getCounterMultiple: (state) => {
      return (mul: number) => {
        return state.counter * mul
      }
    }
  },
  actions: {
    // this を使うので、アロー関数はNG（？）
    increment() {
      this.counter++
    }
  }
})
```

ストアを利用する側は、下記のようにする。

```vue
<script setup>
import { computed } from 'vue'
import { useCounterStore } from "@/stores/counter"

const counterStore = useCounterStore();
const count computed(() => counteStore.counter)
const doubleCount = computed(() => counterStore.doubleCount)
const counterMultiple = counterStore.getCounterMultiple(3)
const onIncrementClick = () => {
  counterStore.incrementCount();
}
</script>
```

ここで、getterに注目すると、getterのアロー関数の返り値は２種類定義できる。１つが値、もう一つが関数。
値を返すgetterの場合は、プロパティのようにアクセスできる。関数を返すgetterの場合は、このプロパティ名を関数としてcallする。
getterの`doubleCount`は、値を返すgetterなので、プロパティのようにアクセスすることができる。
`getCounterMultiple()`の方は、引数`mul`を取る関数としてcallできる。

## その他tips

### インボート文中の`@`

srcフォルダを示す表記方法であり、src配下から記述できるので便利

```
import Component from "@/components/Component.vue"
```

### routingコンポーネントの遅延評価

component内で動的インポートを使えば、遅延評価できる

```
[
  {
    path: "/members",
    name: "Members",
    component: () => {
        return import("/path/to/the/component.vue")
    }
  }
]
```

### CSSの設計とscoped属性

スタイルブロックに`scoped`属性を付与すると、他のコンポーネントのスタイルの影響を受けない。下記のような取り決めをしておくとよい。

- グローバルに適用したいCSS記述は、App.vueのスタイルブロックに記述する
- App.vue以外のコンポーネントのスタイルブロックには原則`scoped`属性を記述してscoped SCCとする

### 画像ファイルの指定

スクリプトブロックで画像ファイルを指定したい際はちょっとコツがいる（p. 57）

### Vue Devtools

Chrome webstoreからインストール可能。beta版やlegacy版があるが、通常版をインストールする

Vue routerを使っている場合、ルーティングタブが現れており、現在のroute情報が見られる

Piniaを使っている場合、Piniaタブが出てくるので、内部状態を確認できる

### vueスタイルガイド

Aルール（必須）からDルール（注意していれば守らなくてもよい）まである
https://vuejs.org/stule-guide/

### vite

ヴィートと読む。webpackみたいなもの。開発用サーバーの立ち上げや、デプロイファイルの作成などをしてくれる

### scriptタグのsetup属性について

setup属性は、Composition APIの書き方で、コードをかなりスッキリ書ける。これがない場合、下記のように、定型構文を毎回書かないといけない

```vue
<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'App',
  setup() {
    // setup属性がある場合の、スクリプトタグの中身
    // ただし、関数の戻り値として、テンプレート変数をすべてリターンする必要がある
  }
})
</script>
```

### 404 Not Found

vue-routerで404のパスを表現するには、下記のようにする。

```vue
{ path: "/:path(.*)*", name: "NotFound", component: NotFound }
```

ルート（`/`）以降が全てパラメーターとなるように書かれているので、存在しないルーティングはすべてこちらでレンダリングされる。
なお、パラメーター名（上記は`path`）は任意の文字列で問題ない。

### ルートパラメーターが変わったのに、コンポーネントが再描画されない

たとえば`/members/1234`から、`/members/5678`に遷移するような場合を考える。この場合、再描画にはルートパラメーターが変わったことをコンポーネントに通知する必要があるので、ウォッチャーを用いてルートパラメーターの変更を監視しておく必要がある

### Piniaのステートリセット

`$reset()`という特別な関数が用意されているので、それをコールする
