import { Human } from "./union_intersection.js"

// mapped types と conditional types
// 2大ややこしや機能

// mapped types
// { [P in K]: T }（K/Tは適当な型、Pは型変数）
// Kはstring | number | symbolの部分型であり、プロパティ名になれる型
// つまり、あるオブジェクトのそれぞれのプロパティの型を指定できる
type fruits = "apple" | "orange" | "grape";
// FruitsObjectはプロパティ名としてfruitsの要素を持ち、プロパティの型はnumberである
// [key: string]: numberみたいなもの。
type FruitsObject = {
    [P in fruits]: number
    // こんな複雑にしても良い
    // readonly [P in fruits]?: number
}

// { [P in number]: T}は、配列の要素へのアクセスという意味になるので、
// { [i: number]: T }と同じ意味になるっぽい

const fo:FruitsObject = {
    apple: 0,
    orange: 1,
    grape: 2
}

// こういう感じで、もとのobjectのプロパティにnullを許容するような型を定義できる
type PropNullable<T> = {[P in keyof T]: T[P] | null};

// もとのobjectのoptionalをrequiredにするようなものも定義できる。
// -をつけると、取り除くを意味する。readonlyと?に対して使える。
type Required<T> = {[P in keyof T]-?: T[P]}

// homomorphic mapped type
// { [P in keyof T]: U} という形の構文らしい

// conditional types
// X extends Y ? S : T
// 型レベルプログラミングという概念を開拓した立役者
type RestArgs<M> = M extends string ? [string, string] : [number, number];

function restFunc<M extends string | number>(
    mode: M,
    ...args: RestArgs<M>
) {
    console.log(mode, ...args);
}

restFunc("test", "1", "2");
restFunc(1, 2, 3)

// Tのプロパティやプリミティブ型を使って、extendsを ===みたいに使える
type First<T extends any[]> = T extends [] ? never : T[0]
type First2<T extends any[]> = T['length'] extends 0 ? never : T[0]

// 再帰の型を定義できる。
type DeepReadonly<T> =
    T extends any[] ? DeepReadonlyArray<T[number]> :
    T extends object ? DeepReadonlyObject<T> :
    T;

interface DeepReadonlyArray<T> extends ReadonlyArray<DeepReadonly<T>> {}

type DeepReadonlyObject<T> = {
    readonly [P in NonFunctionPropertyNames<T>]: DeepReadonly<T[P]>;
};

type NonFunctionPropertyNames<T> = { [K in keyof T]: T[K] extends Function ? never : K }[keyof T];

type List<T> = {
    value: T;
    next: List<T>;
  } | undefined; 

type Diff<T, U> = T extends U ? never : T;
type test = Diff<"hoge" | "foo" | "piyo", "foo">

// inferを使った型マッチング
// conditional typeの条件部分(extends内)で型変数を導入することができます。
// 導入された型変数は分岐のthen側で(?と:の間)で利用可能

// Tが関数型の場合、返り値の型を、それ以外の場合T自信を返す
// 変数Rは、<>の中にないことに留意
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : T;

type ReturnTypeNumber = ReturnType<number>; // number
type ReturnTypeFunctionNumber = ReturnType<() => number>; // number

declare let rtn:ReturnTypeNumber;
declare let rtfn:ReturnTypeFunctionNumber;

// 同じ名前の変数を複数の位置に導入できる。この場合、その変数は合成型になる。
type Foo<T> = 
    T extends { 
        foo: infer U;
        bar: infer U;
        hoge: (arg: infer V)=> void;
        piyo: (arg: infer V)=> void;
    } ? [U, V] : never;

interface Obj { 
    foo: string;
    bar: number;
    hoge: (arg: string)=> void;
    piyo: (arg: number)=> void;
}

// プロパティではユニオン型、関数の中はその反対のインターセクション型
declare let t: Foo<Obj>; // tの型は[string | number, string & number]

// conditional typeによる文字列操作
// conditional typeとinferとテンプレートリテラル型を組み合わせて、
// 型を動的に作成できる。
// 使い道がピンとこないので、後で調べる。
// 型を使った条件分岐ができなかったら、あんまり意味ないのでは？さらにconditional typesを使う？
type ExtractHelloedPart<S extends string> = S extends `Hello, ${infer P}!` ? P : unknown;

// type T1 = "world"
type T1 = ExtractHelloedPart<"Hello, world!">; 
// type T2 = unknown
type T2 = ExtractHelloedPart<"Hell, world!">;


// union distribution （分配法則）
// Xがユニオン型、かつ構成要素がすべて型変数だったとき、
// ユニオン型のconditional typeをconditional typeのユニオン型に変換できる
type None = { type: 'None' };
type Some<T> = { type: 'Some'; value: T };
type Option<T> = None | Some<T>;

/**
 * ValueOfOption<V>: Option<T>を受け取って、渡されたのがSome型なら中身の値の型を返す。
 * 渡されたのがNone型ならundefinedを返す。
 */
type ValueOfOption<V extends Option<unknown>> = V extends Some<infer R> ? R : undefined;

const opt1: Some<number> = { type: 'Some', value: 123 };
const opt2: None = { type: 'None' };

// union ditributionではないパターン
// typeof opt1はSome<number>なので ValueOfOption<typeof opt1>はnumber
const val1: ValueOfOption<typeof opt1> = 12345;

// union ditributionではないパターン
// typeof opt2はNoneなのでValueOfOption<typeof opt2>はundefined
const val2: ValueOfOption<typeof opt2> = undefined;

// union ditributionのパターン
// V (extendsの前)に、ユニオン型を渡す
// V extends Some<infer R> ? R : undefined;
// => Option<number> extends Some<infer R>? R : undifined
// => Some<number> | None extends Some<infer R>? R : undifined
// => Some<number> extends Some<infer R>? R : undifined 
//    | None extends Some<infer R>? R : undifined
// => number | undefinedとなるので、T3は number | undefined となる
type T3 = ValueOfOption<Option<number>>;

// union distributionは、結果にも条件の型があった場合、同じ形で展開される
type NoneToNull<V extends Option<unknown>> = V extends Some<unknown> ? V : null;

// (Some<T> extends Some<unknown> ? Some<T> : null
// | (None extends Some<unknown> ? None : null)
// => Some<T> | null
type T4 = NoneToNull<Option<number>>;

// 注意事項として、条件部分の型が型変数でないと、union distributionは起きない。
// 変数が条件部分にないような形で書き下すと、結果が変わるということ
// T3と同じことを、書き下すと、結果が変わる 
// (Option<number>はSome<T>の部分型ではない（Noneがあるので）ため、
// 条件分岐はelse側になりundifinedになる)
type T3_2 = Option<number> extends Some<infer R>? R : undefined

// 条件部分に型変数がきたけど、union distributionさせたくないときは、適当な型で囲む（[]で囲むことが多い）
// type ValueOfOption<V extends Option<unknown>> = V extends Some<infer R> ? R : undefined;
type ValueOfOptionNonDist<V extends Option<unknown>> = V[] extends Some<infer R> []? R : undefined;

// T3と同じ形だが、結果はT3_2と同じくundefined
type T3_3 = ValueOfOptionNonDist<Option<number>>

// neverは、空のユニオン型と判定され、union distributionが適用されるも、
// lengthが0なので、実際には適用できずにnever型が返る
type IsNever<T> = T extends never ? true : false;

// T1はneverになる。T[] extends never[]にすれば、来た通りの動作になる
type TN = IsNever<never>;

// mapped typeのunion distribution
// 以下の形のmapped typeでTが型変数のときに、Tにunion型が入ると分配されます。
// {[P in keyof T]: X}
// {[P in keyof (A | B)]: (A | B)[P]}のとき、
// {[P in keyof A]: A[P]} | {[P in keyof B]: B[P]}になる。
type Arrayify<T> = {[P in keyof T]: Array<T[P]>};

type Fooo = { foo: string };
type Bar = { bar: number };
type FooBar = Fooo | Bar;

// FooBarArrはunion型が分配されてArrayify<Foo> | Arrayify<Bar>になる
type FooBarArr = Arrayify<FooBar>;

// 型変数を使わずに展開して入れると、{}になる。keyof (Fooo | Bar)がneverだから？
type CompareFooBarArr = {[P in keyof (Fooo | Bar)]: Array<(Fooo | Bar)[P]>};
type CompareFooBarArr2 = {[P in keyof Fooo]: Array<Fooo[P]>}
  | {[P in keyof Bar]: Array<Bar[P]>}
const fba1 = { foo: ["string"] };
const fba2 = { bar: [0]};
const fba3 = { foo: ["string"], bar: [0]}
let cfbar: CompareFooBarArr2 = fba1;
cfbar = fba2;
cfbar = fba3;
  
// mapped typeと配列型
// {[P in keyof T]: X}
// この形で、Tに配列の型（タプル型も含む）が入る場合も、やはり特別な挙動をします。
// keyof 配列は、全てのメソッドなどのプロパティを列挙してしまうので、
// 関数型とかもstring型だと思われてしまい、型が壊れる
type BrokenStringArray = {[P in keyof number[]]: string};

// error Type 'string[]' is not assignable to type 'BrokenStringArray'.
// Types of property 'length' are incompatible.
// const bsarr: BrokenStringArray = ["string"];

declare const bsarr:BrokenStringArray;
// error his expression is not callable.
// Type 'String' has no call signatures.
// bsarr.forEach((b) => console.log)

// これを回避するには、型変数を使う。
// これは、別に配列でなくても、オブジェクトに対しても使える
type Strify<T> = {[P in keyof T]: string};
const nbsarr: Strify<any[]> = ["string"];
