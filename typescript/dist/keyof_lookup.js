// keyof型とlookup型
// lookup型: T[K]という書き方で、オブジェクト型のvalueの型情報を抜き出す
// keyof型：オブジェクト型のkeyの情報（通常文字列リテラルのユニオン型）を抜き出す
// keyofの返り値は通常stringだが、number/symbolもありうるので、string | number | symbolと解釈される
// lookup型
function setAge(human, age) {
    human.age = age;
}
// keyof型 keyof Objectという書き方で、その型のプロパティのユニオン型を作る。
// typeofと組み合わせて、任意のオブジェクトの型情報を抽出して、型にできる
const mmConversionTable = {
    mm: 1,
    m: 1e3,
    km: 1e6
};
// "mm" | "m" | "km"型を作るために、mmConversionTableの型を抽出して、そこからproperty名を抽出している
function convertUnits(value, unit) {
    const mmValue = value * mmConversionTable[unit];
    return {
        mm: mmValue,
        m: mmValue / 1e3,
        km: mmValue / 1e6
    };
}
let koa = 1; //数値は全部OK
koa = "length"; // length propertyを持つのでOK
koa = "slice"; // slice methodを持つのでOK
let kos = 1;
kos = "length"; // length propertyを持つのでOK
kos = "slice"; // slice methodを持つのでOK
// ジェネリクスと組み合わせるとこういう感じ
// TとKはいいとして、T[K]という書き方ができることに注意。
// KはTのkeyを表すユニオン型なので、lookup型は、ユニオン型を取れるということ。
function get(obj, key) {
    return obj[key];
}
export {};
