// js/esの一般的な書き方に関すること
// 巻き上げ(hoisting)
// 関数宣言が実行の後にあっても、使うことができる。（関数式だと巻き上げは起きない）
// class構文には、巻き上げはない
console.log(test());
function test() {
    return "test";
}
// 分割代入
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
};
// 基本
const { first } = complicatedObject;
// 名前の変更
const { first: newFirst } = complicatedObject;
// nestした値の取得
const { second: { secondFirst: secondSecond } } = complicatedObject;
// デフォルト値
const { second = "none" } = complicatedObject; // complicatedObject.secondがundefinedの場合"noneになる"（nullの場合はデフォルト値が代入されない）
// 組み合わせ
const { first: { firstFirst: { value: firstFirstValue }, firstSecond: { firstSecondFirst: { value: firstSecondFirstValue = 100 } } }, second: { secondFirst, secondSecond: { value } } } = complicatedObject;
console.log(firstFirstValue, // 0
firstSecondFirstValue, // 100
secondFirst.value, // 1
value // 2
);
// オプショナルチェイニング：nullやundefinedのプロパティを見に行ったときに、undefinedを返す
// objectのとき: obj?.a.b.c ?は一回だけでいいはず？
// functionのとき func?.()
// class式: クラスを動的に作成するときに使うが、普通は使わない
// ただし、private/protectedなプロパティが使用できない（？）という制約がある
// TSが型も自動で生成してくれないので、型としての参照もできない 
// (const u:UserClassExpression = ... みたいなのができない)
const UserClassExpression = class {
    constructor(name, age) {
        this.name = name;
        this.age = age;
    }
};
export {};
