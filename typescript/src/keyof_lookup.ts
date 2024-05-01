import { Human } from "./union_intersection.js"

// keyof型とlookup型
// lookup型: T[K]という書き方で、オブジェクト型のvalueの型情報を抜き出す
// keyof型：オブジェクト型のkeyの情報（通常文字列リテラルのユニオン型）を抜き出す
// keyofの返り値は通常stringだが、number/symbolもありうるので、string | number | symbolと解釈される

// lookup型
function setAge(human: Human, age: Human["age"]) {
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
function convertUnits(value: number, unit: keyof typeof mmConversionTable) {
    const mmValue = value * mmConversionTable[unit];
    return {
        mm: mmValue,
        m: mmValue / 1e3,
        km: mmValue / 1e6
    }
}

// keyof Array<T>は、Arrayから呼び出せる全てのメソッドやプロパティ
type keyofArray = keyof Array<any>;
let koa: keyofArray = 1; //数値は全部OK
koa = "length" // length propertyを持つのでOK
koa = "slice" // slice methodを持つのでOK

// keyof Stringも同様
type keyofString = keyof string;
let kos: keyofString = 1;
kos = "length" // length propertyを持つのでOK
kos = "slice" // slice methodを持つのでOK

// union型/intersection型のkeyofは、なぜか反転するらしい
type a = { a: string };
type b = { b: number };

// "a" & "b" => never
type keyAndB = keyof(a | b)

// "a" | "b"
type keyAorB = keyof(a & b)

// ジェネリクスと組み合わせるとこういう感じ
// TとKはいいとして、T[K]という書き方ができることに注意。
// KはTのkeyを表すユニオン型なので、lookup型は、ユニオン型を取れるということ。
function get<T, K extends keyof T>(obj: T, key: K): T[K] {
    return obj[key];
}

