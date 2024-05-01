const sh = {
    species: "super human",
    name: "kal el",
};
//  インターセクション型はユニオン型の部分型
const u = sh;
function getSpecies(anilmal) {
    return anilmal.species;
}
function getName(human) {
    return human.name;
}
const randFunc = Math.random() < 0.5 ? getSpecies : getName;
randFunc(sh); // Human & Animal型で呼び出せる
// ユニオン型を使う際は、型の絞り込みが必須
// 1. 等価演算子での絞り込み
// 2. typeof演算子での絞り込み（nullのみobjectなので注意）
// 文字列 => "string"
// 数値 => "number"
// 真偽値 => "boolean"
// BigInt => "bigint"
// シンボル => "symbol"
// undefined => "undefined"
// null => "object"
// オブジェクト（関数以外） => "object"
// 関数以外 => "function"
// 3. 代数的データ型（tag propertyなど、特定のプロパティを全ての型で持つことで、そのプロパティを用いて型を絞り込む）
// as
// TSの型推論は完璧ではない。
// たとえばeveryを使った場合の型の絞り込みができなかったりする
function getNamesIfAllHuman(users) {
    if (users.every(u => u.tag === "human")) {
        // この時点で、usersはHuman[]型だが、TSがわからないので、users.mapだと、コンパイルエラーが出る
        return users.map(u => u.name);
    }
}
// 似たものとして、nullとundefinedを型の可能性として無視する!記法がある
let str;
// 強制的にstring型とみなす。asでも書ける
str.substring(5);
// ユーザー定義型ガード
// boolean/voieを返す関数として定義して、結果によって型を絞り込める機能。
// 関数の中身が、本当に型の絞り込みに適しているかどうかはtypescriptは監視してくれないので、
// 開発者が注意しておく必要がある
// booleanを返す関数としての定義
// 返り値の型の位置に、引数 is 型と書くことで、関数の返り値が真のときにその型であるとみなす
function isHuman(value) {
    if (value == null) {
        return false;
    }
    return (value.tag === "human" &&
        value.name &&
        typeof value.name === "string");
}
// voidを返す関数として定義
// asserts 引数 is 型と書くことで、
// 例外を投げなければ、その型であるとみなす
function isHuman2(value) {
    if (value == null) {
        throw new Error('value is not a object');
    }
    if (value.tag === "human" &&
        value.name &&
        typeof value.name === "string") {
        return;
    }
    throw new Error('value is not Human');
}
const fakeHuman = {
    tag: "fake human"
};
// 実際の関数の中身までは見ていないので、関数が適当だと、型システムを壊す
if (isHuman(fakeHuman)) {
    // trueの場合、Human型であるとみなす
    console.log(fakeHuman.tag === "human");
}
else {
    isHuman2(fakeHuman);
    // 通過した場合、ここ以降はfakeHumanの型はHumanであるとみなす
    console.log(fakeHuman.tag === "human");
}
export {};
