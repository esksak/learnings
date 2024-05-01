// 型引数にreadonlyをつけること
// 型プログラミングで使えるもの
// ...T
// 配列の要素はinferで取り出せる
// extendsは、primitiveと合わせると ===的な使い方ができる
// conditional types
// mapped types

// wrong answer questions
//   14 - First of Array 

//   13 - Hello World
type HelloWorld = string // expected to be a string

// 4- pick
type MyPick<T, K extends keyof T> = {
    [P in K]: T[P];
}

// 7 - readonly
type MyReadOnly<T> = {
    readonly [P in keyof T]: T[P]
}

//   11 - Tuple to Object
//   wrong
type TupleToObject<T extends readonly any[]> = {
   [P in T[number]]: P 
}

// 14 - first of Array
// wrong
type First<T extends readonly any[]> = T extends [] ? never: T[0] 

// 18- length of tupple
type Length<T extends readonly any[]> = T['length']

// 43 - exclude
// [P in R]: T[P]はpickであってexcludeではない
// 引数T/Rにextendsはつけられない。なぜ？
type MyExclude<T, R> = T extends R ? never: T;

// 189- Awaited
// PromiseLike is more sophisticated than this one
// 再帰を忘れずに
type MyPromiseLike<T> = Promise<T> | { then: (onfulfilled: (arg: T) => any) => any}
type MyAwaited<T> = T extends MyPromiseLike<infer R> 
    ? R extends MyPromiseLike<any> 
        ? MyAwaited<R>
        : R    
    : never;

// 268 - if
type If<C extends boolean, A, B> = C extends true ? A : B

// 533 - Concat
type Concat<T extends readonly any[], U extends readonly any[]> = [...T, ...U]

// 898 - Includes
// wrong
type Includes<T extends readonly any[], U> = T extends [infer First, ...infer Rest] ? 
    Equal<U, First> extends true ? 
        true : 
        Includes<Rest, U> : 
    false;

// 3057 - push
type Push<T extends any[], U> = [...T, U]

// 3060 - unshift
type Unshift<T extends any[], U> = [U, ...T]

// 3312 - parameters
type MyParameters<T> = T extends (...arg: infer R) => any ? R : never;

// Equal<X, Y>は何をやっているのか？
// 1. まず、<T>() => (T extends X ? 1 : 2) が簡約できるかを判定する
// 2. () => (T extends X ? 1 : 2) の返り値を見ると型パラメータであるから、
// Distributive Conditional Types の定義に則り遅延評価される
// 3. <U>() => (U extends Y ? 1 : 2) も同様に遅延評価される
// 4. 遅延評価の結果、
// (<T>() => (T extends X ? 1 : 2)) extends 
// (<U>() => (U extends Y ? 1 : 2)) ? true : false の判定に移る
// 5. () => (T extends X ? 1 : 2) が () => (U extends Y ? 1 : 2) の
// subtype であるかを判定したい。
// 引数は0個で一致してるため、返り値同士が subtype であるかの判定となる
// これは Conditional Types 同士の比較であるため、定義をもとに判定する
// Two conditional types の定義：
// 'T1 extends U1 ? X1 : Y1' and 
// 'T2 extends U2 ? X2 : Y2' are related if one of 
// T1 and T2 is related to the other, 
// U1 and U2 are identical types, 
// X1 is related to X2, and
// Y1 is related to Y2.
// 6. T1 = T2のとき、一方がもう一方の subtype となるのは自明
// X と Y は型が一致すればOK（Equal<X,Y>の本質）
// X1/Y1, X2/Y2も同じ型にすればOK
// したがって、下記の式は、「X と Y の型が一致」すれば、trueが返る
type Equal<X, Y> = 
    (<T>() => (T extends X ? 1 : 2)) extends
    (<T>() => (T extends Y ? 1 : 2))
    ? true : false

export {};
