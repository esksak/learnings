// optionalはプロパティ自体なくて良いが、mandatoryはundefinedを明示する必要がある
// exactOptionalPropertyTypeを有効にすると、optional propertyに明示的にundefinedを指定すると
// エラーにできるので、両者の区別を明確にできる
const oam = {
    mandatory: undefined
};
// as constの効果は４つ
// 1. 配列リテラルはreadonlyタプル型に
// 2. オブジェクトの各プロパティはreadonlyに
// 3. 文字列・数値・BigInt・真偽値リテラルは、自動でwideningされないリテラル型に
// 4. テンプレート文字列リテラルの型が、stringではなくテンプレート文字列リテラル型に
// 要するに、変更できないもの、とするということ。
// as constをつければ、要素数、要素の中身も変更できなくなる。
const names1 = ["Tom", "John", "George"]; //string型
const names2 = ["Tom", "John", "George"]; //readonly ["Tom", "John", "George"]型
// object型
// {}型は、オブジェクトだけではなく、プリミティブなものでも入れられてしまう。
// オブジェクトにだけ絞りたいときは、object型を使う。
const a = 0;
const b = {};
const num = 5; // これだとプリミティブもOKになってしまう
// これはエラー
// const num2:onlyObject = 5;
const toStrObj = {
    toString: () => "str"
};
// 型変数も使える(ただし、T extends readonly any[] = なんらかのArrayである必要がある)
function removeFirst(arr) {
    const [, ...rest] = arr;
    return rest;
}
export {};
