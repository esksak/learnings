// optional propertyは xxx | undefined型だが、そもそもこのプロパティが存在しないことも許されるので、少し違う
// そのプロパティが必須だが、中身が確定しない場合は、optional propertyは使わないようにする
type optionalAndMandatory = {
    optional?: string;
    mandatory: string | undefined;
}

// optionalはプロパティ自体なくて良いが、mandatoryはundefinedを明示する必要がある
// exactOptionalPropertyTypeを有効にすると、optional propertyに明示的にundefinedを指定すると
// エラーにできるので、両者の区別を明確にできる
const oam: optionalAndMandatory = {
    mandatory: undefined
}

// as constの効果は４つ
// 1. 配列リテラルはreadonlyタプル型に
// 2. オブジェクトの各プロパティはreadonlyに
// 3. 文字列・数値・BigInt・真偽値リテラルは、自動でwideningされないリテラル型に
// 4. テンプレート文字列リテラルの型が、stringではなくテンプレート文字列リテラル型に
// 要するに、変更できないもの、とするということ。

// as constをつければ、要素数、要素の中身も変更できなくなる。
const names1 = ["Tom", "John", "George"]; //string型
const names2 = ["Tom", "John", "George"] as const; //readonly ["Tom", "John", "George"]型

// as constは、値から型を作る手段として使われる。
// 普通は型を先に定義して、それに準拠するように値を用意するが、
// 値が先にあって、それを元に型を定義したいときにas constが頻出する。
// 下の例では、さきにtype Name = "Tom" | "John" | "George"と定義して
// そのあとnames2を書いてもいいが、その場合内容が重複することになる
type Name = (typeof names2)[number] // "Tom" | "John" | "George"

// object型
// {}型は、オブジェクトだけではなく、プリミティブなものでも入れられてしまう。
// オブジェクトにだけ絞りたいときは、object型を使う。
const a: {} = 0;
const b:object = {}

// ただ、object型単品だと、使い勝手が悪いので、実際にはインターセクション型で使う
type hasToString = {
    toString: () => string
};
const num:hasToString = 5; // これだとプリミティブもOKになってしまう
type onlyObject = hasToString & object;

// これはエラー
// const num2:onlyObject = 5;
const toStrObj: onlyObject = {
    toString: () => "str"
}

// 可変長タプル
// ...Tという形で、任意の個数の要素を持つタプル型を定義できる

// 最初にnumberを持ち、そのあとstring型の要素を可変個（0個以上）持つ型
type NumberAndStrings = [number, ...string[]];

// ...Tを途中に挟んでもOK.ただし挟めるのはひとつのみ
type NumberStringsNumber = [number, ...string[], number];

// 既存のタプルを用いて、拡張タプルも定義できる
type NNNS = [number, ...NumberAndStrings];

// 型変数も使える(ただし、T extends readonly any[] = なんらかのArrayである必要がある)
function removeFirst<T, Rest extends readonly unknown[]>(
    arr: [T, ...Rest]
) {
    const [, ...rest] = arr;
    return rest;
}

export {};
