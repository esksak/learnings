//関数宣言
function BMI1({ height, weight }) {
    return weight / height ** 2;
}
// ジェネリクス
function Gen1(element) {
    return [element];
}
// 関数式
const BMI2 = function ({ height, weight }) {
    return weight / height ** 2;
};
// ジェネリクス
const Gen2 = function (element) {
    return [element];
};
// アロー関数
const BMI3 = ({ height, weight }) => weight / height ** 2;
// ジェネリクス
const Gen3 = (element) => {
    return [element];
};
// メソッド記法
const obj = {
    method(double) {
        return double ** 2;
    },
    // アロー関数だとこう
    method2: (double) => double ** 2,
    // オプション引数
    method3: ({ height: h, weight: w }, o) => o ? h * w : 0,
    // ジェネリクス
    gen(element) {
        return [element];
    }
};
// 可変超引数
function method3(...rest) {
    console.log(rest);
}
// スプレッド演算子
const arr2 = [1, 2, 3];
method3(...arr2);
// 引数の数が固定の関数に、スプレッド演算子のものは渡せない。スプレッド演算子で渡されるarrayの要素数が不明なため。
function fixedArgs(a, b, c) {
    return a * b * c;
}
// ↓これはエラー（Error: A spread argument must either have a tuple type or be passed to a rest parameter.ts(2556)
// console.log(fixedArgs(...arr2))
// 同じ長さのarray(tuple)であることが明示されていれば、使用できる。 
// いちいちtupleの型注釈を書くのが面倒だが、これはas constを使えば楽に書けるようになる
const arr3 = [1, 2, 3];
console.log(fixedArgs(...arr3));
// 関数型もつけた場合の、関数のフル定義はこう。
const bmi = (w, h) => h / w ** 2;
// BMI型を展開して、もっとややこしくするとこう。
const bmi2 = (w, h) => h / w ** 2;
// 型推論によって実際は引数の型は省略できるところがある。
// 推論は、通常の型推論と逆方向の型推論（contextual typing）とがある
// 通常の型推論: 式から、その式自体の型が推論される
const arr4 = []; // []が代入されているので、arr4はArrayと推論される
const xRepeat = (arg) => "x".repeat(arg); // xRepeatは、代入されているものから(arg:number) => string型
const xRepeat2 = (num) => "x".repeat(num); //引数numは、F型から推論されているので注釈がいらない
// callback関数の引数は、この仕組みによって大抵の場合方注釈を省略できる。
const nums = [0, 1, 2];
nums.filter(x => x % 3 === 0); // 引数 x はnumber型であることは自明なので、わざわざ書かなくてよい
const obj2 = {
    greet: (str) => `Hello ${str}` // Greetableのgreet methodの方定義によって推論されるので、str引数の型引数は省略可能
};
// ジェネリクス関数の引数の型注釈も、原則不要。自動で推論してくれる。
function repeat(element, length) {
    const result = [];
    for (let i = 0; i < length; i++) {
        result.push(element);
    }
    return result;
}
repeat("a", 10); // elementの型から、Tを自動で推論するので、関数の利用側はジェネリクスを意識する必要がない
const double = (arg) => console.log(arg);
double.isUsed = true;
console.log(double.isUsed); // doubleはisUsedプロパティを持つ
console.log(double(1000)); // doubleは関数としてもcallできる
export {};
