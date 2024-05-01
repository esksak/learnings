import type { Animal } from "./basics/101.js"
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

// 関数の部分型
// 部分型のおさらい
// S型がT型として代用できる場合、SはTの部分型である、という。
type SubType = {
    name: string;
    age: number
}

type Type = {
    name: string
}

// SubTypeは、Typeの部分型である
const sub: SubType = {
    name: 'hoge',
    age: 25
}
const t: Type = sub;
// SubTypeは、Typeであるための条件（name propertyを持つ）を満たすので、部分型

// 返り値の方による関数の部分型関係
type SubFunc =  (arg: number) => SubType;
type Func = (arg: number) => Type;

const subf: SubFunc = (arg) => sub;
const f: Func = subf;
// SubFuncは、Funcであるための条件（argを受け取り、Typeを返す）を満たすので、部分型

// 引数の数による、関数の部分型関係
type Func2 = (arg1: number, arg2: number) => SubType;
const f2: Func2 = subf;
// SubFuncは、Func2であるための条件（arg1, arg2を受け取ることができ、SubTypeを返す関数）を満たすので、部分型
// SubFuncは、引数を１つしか持たないので、それ以上の引数を持つ関数として扱える（２つ目以降の引数は使わずに捨てればよい）

// 引数の部分型による、関数の部分型関係
type TypeArgFunc = (type: Type) => number;
type SubTypeArgFunc = (type: SubType) => number;

const taf: TypeArgFunc = (type) => parseInt(type.name);
const staf: SubTypeArgFunc = taf;
staf(sub)
// TypeArgFuncは、SubTypeArgFuncであるための条件（SubType型を受け取り、numberを返す関数）を満たす。
// Type型を引数として持つ関数が、SubType型を引数として持つ関数としてみなされ、SubType型の引数を渡されると、
// 実際には、Type型を引数として持つ関数に、Type型の部分型であるSubType型の引数が渡されるということになる
// わかったようなわからないような…

// 型宣言にメソッド記法が使えるが、使うな危険
// 部分型の条件が緩和されて、ややこしくなる
type HasName = { name: string };
type HasNameAndAge = { name: string; age: number };
type Obj = {
    func: (arg: HasName) => string;
    method(arg: HasName): string // メソッド記法
}

const something: Obj = {
    func: user => user.name,
    method: user => user.name
}

const getAge = (user: HasNameAndAge) => String(user.age)
//something.func = getAge; // =>エラーが出る（正しい）
// something.method = getAge;　// => エラーが出ない（間違い）

// objectのreadonly propertyの限界について
// objectのreadonly propertyと部分型を組み合わせると、予期しないことが起きることがある（というか、TSの型チェックが不完全）
// 配列の場合は問題ない

// readonlyの付いていないobject/arrayは、readonlyのついたobject/arrayの部分型である（readonlyのobject/arrayであるための条件を満たすため）
function sum(nums: readonly number[]) {
    let result = 0;
    for (const num of nums) {
        result += num;
    }
    return result;
}

const nums1: readonly number[] = [1, 10, 100];
const nums2: number[] = [1, 1, 2, 3, 5, 8];
sum(nums1);
sum(nums2); // number[]はreadonly number[]の部分型なので、渡せる

// エラーが出る例
function fillZero(nums: number[]): void {
    for (let i = 0; i < nums.length; i++) {
        nums[i] = 0;
    }
}
// fillZero(nums1); // => readonly arrayなので、エラーが出る
// fillZero(nums2); // => OK

// objectの場合
type User = { name: string };
type ReadOnlyUser = { readonly name: string };
const uhyoify = (user: User) => {
    user.name = "uhyo";
}

const jhon: ReadOnlyUser = {
    name: "jhon"
}

// jhon.name = "uhyo";  // => error
uhyoify(jhon); // errorが出ない。。。Read onlyなのに上書きできちゃう

// unknown型は、すべての型を部分型として持てるので、あらゆる値を代入できる。
const u1:unknown = 3;
const u2:unknown = "string";
const u3:unknown = false;

// voidも、unknownと似ており、すべての型を部分型として持てる。
// ただし、voideは、返り値のみで使える型。
type voidFunc = () => void;
const numFunc: voidFunc = () => 123; // エラーが起きない


export {};
