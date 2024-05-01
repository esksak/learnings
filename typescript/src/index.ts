// type文: 型を宣言する構文。
// 似たものにinterface宣言があるが、type文ですべて代用できるため、interface宣言は使わなくてよい
type Animal = {
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

// 部分型関係
// ある型が他方の型のサブクラスになっていること。Cat型があったとき、Cat型はAnimal型の部分型である、みたいな感じ。
type Cat = {
    head: string;
    body: string;
    tail: string;
    sex: string;
    nikukyu: string;
}
const newCat: Cat = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
}
const clone: Animal = newCat; // Cat型はAnimal型の部分型なので、代入可能

// ただし、下記はエラー。部分型なので一見良さそうだが、こういう書き方をするのは、何か間違いをしている可能性があり、その防止のため。
/*
const errorCat: Animal = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
}
*/
// => Object literal may only specify known properties, and 'nikukyu' does not exist in type 'Animal'.

const noErrorCat = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
}
const thisIsOKCat: Animal = noErrorCat; //これならOK

// 型引数
// extendsは、その型の部分型である必要がある、という制約、 =　で繋げば、デフォルト引数として適用される
type Family<Parent extends Animal, Child extends Animal = Animal> = {
    mother: Parent;
    father: Parent;
    children: Child[]    
}

// 配列の場合も同様
const arr: readonly Animal[] = [dog, cat];
// 複雑な型の場合、Array/ReadOnlyArrayを使って定義してもよい。
const complArray: ReadonlyArray<Family<Cat>> = [{mother: newCat, father: newCat, children: []}]

// オブジェクトの分割代入
const complicatedObject = {
    first: {
        firstFirst: {
            value: 0
        },
        firstSecond: {
            firstSecondFirst: {
                value: undefined
            }
        }
    },
    second: {
        secondFirst: {
            value: 1
        },
        secondSecond: {
            value: 2
        }
    }
}

// 基本
const { first } = complicatedObject;

// 名前の変更
const {first: newFirst} = complicatedObject;

// nestした値の取得
const { second: { secondFirst: secondSecond }} = complicatedObject;

// デフォルト値
const { second = "none"} = complicatedObject; // complicatedObject.secondがundefinedの場合"noneになる"（nullの場合はデフォルト値が代入されない）

// 組み合わせ
const {
    first: {
        firstFirst: {
            value: firstFirstValue
        },
        firstSecond: {
            firstSecondFirst: {
                value: firstSecondFirstValue = 100
            }
        }
    },
    second: {
        secondFirst,
        secondSecond: {
            value
        }   
    }
} = complicatedObject;
console.log(
    firstFirstValue, // 0
    firstSecondFirstValue, // 100
    secondFirst.value, // 1
    value // 2
)

// 配列の場合、,で飛ばせることを覚えておく。
const longArr = [0, 1, 2, 3, 4, 5];
const [zero, , , , , five] = longArr;

