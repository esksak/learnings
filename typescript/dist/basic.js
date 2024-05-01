const dog = {
    head: "かわいいお耳があるワン",
    body: "かわいいぶち模様があるワン",
    tail: "かわいいしっぽだワン",
    sex: "男の子"
};
// 配列の場合も同様
const arr = [dog, dog];
// 複雑な型の場合、Array/ReadOnlyArrayを使って定義してもよい。
const complArray = [dog];
const cat = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子"
};
console.log(typeof cat); // => object (typeof演算子)
// typeofキーワードを使うのは、型よりも値が上位に来る場合に使う。（値によって型が定義される場合） as constについては後述
const Commands = ["attack", "defend", "run"];
const number = Math.floor(3 * Math.random());
const tupleTest = ["id", 0];
export {};
