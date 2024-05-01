// 関数の作り方４つ
// どの書き方でも、関数名のあとには:がつかず（変数の場合、これは関数型の変数宣言。後述。）、引数の後に:がつく。引数の後の:の方は、返り値の型
type Human = {
    height: number;
    weight: number;
}

//関数宣言
function BMI1({height, weight}: Human): number { // 分割代入で型をつけられる
    return weight / height ** 2;
}
// ジェネリクス
function Gen1<T>(element: T):T[] {
    return [element];
}
 
// 関数式
const BMI2 = function({height, weight}: Human): number {
    return weight / height ** 2;
}
// ジェネリクス
const Gen2 = function<T>(element: T):T[] {
    return [element];
}

// アロー関数
const BMI3 = ({height, weight}: Human): number => weight / height ** 2
// ジェネリクス
const Gen3 = <T>(element: T): T[] => {
    return [element];
}

// メソッド記法
const obj = {
    method(double: number): number {
        return double ** 2;
    },
    // アロー関数だとこう
    method2: (double: number): number => double ** 2,
    // オプション引数
    method3: ({height: h, weight: w}: Human, o?: string) => o ? h * w : 0,
    // ジェネリクス
    gen<T>(element: T): T[] {
        return [element]
    }
}

// 可変超引数
function method3(...rest: number[]) {
    console.log(rest)
}

// スプレッド演算子
const arr2 = [1, 2, 3];
method3(...arr2);

// 引数の数が固定の関数に、スプレッド演算子のものは渡せない。スプレッド演算子で渡されるarrayの要素数が不明なため。
function fixedArgs(a: number, b: number, c: number) {
    return a * b * c;
}
// ↓これはエラー（Error: A spread argument must either have a tuple type or be passed to a rest parameter.ts(2556)
// console.log(fixedArgs(...arr2))

// 同じ長さのarray(tuple)であることが明示されていれば、使用できる。 
// いちいちtupleの型注釈を書くのが面倒だが、これはas constを使えば楽に書けるようになる
const arr3: [number, number, number] = [1, 2, 3]
console.log(fixedArgs(...arr3))

// 関数型(callbackを受け取る関数を書くときとかに頻出)
type BMI = (weight: number, height: number) => number;
// ジェネリクスの場合
type GEN = <T>(element: T) => T[];

// 関数型もつけた場合の、関数のフル定義はこう。
const bmi: BMI = (w: number, h: number): number => h / w ** 2;
// BMI型を展開して、もっとややこしくするとこう。
const bmi2: (weight: number, height: number) => number = (w: number, h: number): number => h / w ** 2;

// 型推論によって実際は引数の型は省略できるところがある。
// 推論は、通常の型推論と逆方向の型推論（contextual typing）とがある
// 通常の型推論: 式から、その式自体の型が推論される
const arr4 = []; // []が代入されているので、arr4はArrayと推論される
const xRepeat = (arg: number): string => "x".repeat(arg) // xRepeatは、代入されているものから(arg:number) => string型

// 逆方向（contextual typing = 文脈からの型）
// 式の型が先にわかっている場合に、それを元に式の内部の方を推論する
// すでに定義済みだったら、わざわざもう一回書かなくても良いよね、というだけの話
type F = (arg: number) => string
const xRepeat2: F = (num) => "x".repeat(num) //引数numは、F型から推論されているので注釈がいらない

// callback関数の引数は、この仕組みによって大抵の場合方注釈を省略できる。
const nums = [0, 1, 2]
nums.filter(x => x % 3 === 0) // 引数 x はnumber型であることは自明なので、わざわざ書かなくてよい

// object型でも同様のことが可能
type Greetable = {
    greet: (str: string) => string;
}

const obj2: Greetable = {
    greet: (str) => `Hello ${str}` // Greetableのgreet methodの方定義によって推論されるので、str引数の型引数は省略可能
}

// ジェネリクス関数の引数の型注釈も、原則不要。自動で推論してくれる。
function repeat<T>(element: T, length: number): T[] {
    const result: T[] = [];
    for (let i = 0; i < length; i++) {
        result.push(element);
    }
    return result;
}
repeat("a", 10); // elementの型から、Tを自動で推論するので、関数の利用側はジェネリクスを意識する必要がない

// コールシグネチャ
// ほとんど使わなそう。jQueryの$のように、関数とプロパティをどちらも持つような変数に対応するためなどに使う
// あるオブジェクトが、プロパティをもち、かつ、関数としてもcallできることを表す。
type MyFunc = {
    isUsed?: boolean;
    (arg: number): void
}
const double: MyFunc = (arg) => console.log(arg);
double.isUsed = true;
console.log(double.isUsed); // doubleはisUsedプロパティを持つ
console.log(double(1000)) // doubleは関数としてもcallできる

// コールシグネチャを使えば、オーバーロード関数の型定義も可能っちゃ可能
// 引数がnumberの時はnumberを、stringのときはstringを返すオーバーロード関数
type OverLoad = {
    (arg: number): number;
    (arg: string): string;
}

export {};