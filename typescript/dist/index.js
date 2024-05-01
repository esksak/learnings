"use strict";
const dog = {
    head: "かわいいお耳があるワン",
    body: "かわいいぶち模様があるワン",
    tail: "かわいいしっぽだワン",
    sex: "男の子"
};
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
const newCat = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
};
const clone = newCat; // Cat型はAnimal型の部分型なので、代入可能
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
};
const thisIsOKCat = noErrorCat; //これならOK
// 配列の場合も同様
const arr = [dog, cat];
// 複雑な型の場合、Array/ReadOnlyArrayを使って定義してもよい。
const complArray = [{ mother: newCat, father: newCat, children: [] }];
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
