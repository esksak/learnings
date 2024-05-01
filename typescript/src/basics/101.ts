// type文: 型を宣言する構文。
// 似たものにinterface宣言があるが、type文ですべて代用できるため、interface宣言は使わなくてよい
export type Animal = {
    head: string;
    body: string;
    tail?: string; // オプショナルプロパティ
    readonly sex: string // readonly 初期化以外での上書きを禁止（object/arrayはconstつけてもプロパティは上書きできてしまうがこれをつければエラーにできる）
}

const dog: Animal = {
    head: "かわいいお耳があるワン",
    body: "かわいいぶち模様があるワン",
    tail: "かわいいしっぽだワン",
    sex: "男の子"
}

// 配列の場合も同様
const arr: readonly Animal[] = [dog, dog];
// 複雑な型の場合、Array/ReadOnlyArrayを使って定義してもよい。
const complArray: ReadonlyArray<Animal> = [dog]

// 配列の要素の型
type elements = Animal[][number]

// 配列の特定要素の型
type FirstElement = Animal[][0]

// インデックスシグネチャ: 任意のkeyを持つ型を定義できる
// ただし、これを使う場合、tsconfigにnoUnCheckedIndexedAccessをつけておかないと、
// 任意のプロパティを持つオブジェクトであることを想定されてしまうため、型システムが有効に効かなくなる
type Prices = {
    [key: string]: number;
}

// typeof キーワード: その変数の型を使えるもの。typeof演算子と混同しないようにする。
type T = typeof dog // typeof キーワード
const cat: T = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子"
}
console.log(typeof cat); // => object (typeof演算子)

// typeofキーワードを使うのは、型よりも値が上位に来る場合に使う。（値によって型が定義される場合） as constについては後述
const Commands = ["attack", "defend", "run"] as const;
const number = Math.floor(3 * Math.random())
type Command = typeof Commands[number] // Command型を定義するには、Commandsの型から推論させた方が書きやすい

// tuple型
type tuple =  [string, number];
const tupleTest: tuple = ["id", 0]

export {};