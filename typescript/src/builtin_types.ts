// 組み込みの型
// Readonly<T>: Tのreadonly型
// Partial<T>: Tの全てのプロパティをオプショナルに
// Required<T>: Tの全てのプロパティを必須に
// Pick<T, K>: Tのうち、K（string | number | symbolを要素としてもつユニオン型）で指定したプロパティのみをとってくる型
// Omit<T, K>: Pickの逆で、Kで指定したプロパティを捨てた型
// Extract<T, U>: T（普通はユニオン型）の構成要素のうちUの部分型となるものだけを抜き出した型
// Exclude<T, U>: Extractの逆で、Uの部分型となるものだけを捨てた型
// NonNullable<T>: Exclude<T, null | undefined>と同じ意味で、Tからnullとundefinedの可能性を取り除いた型

// chapter 6 力試し
/*
type Option<T> = {
    tag: "some",
    value: T
} | { tag: "none" }

function doubleOption(obj: Option<number>) {
    return mapOption(obj, x => x * 2);
}

const four: Option<number> = { tag: "some", value: 4 };
const nothing: Option<number> = { tag: "none" };

function mapOption<T, U>(
    obj: Option<T>,
    callback: (v: T) => U
): Option<U> {
    if (obj.tag === "none" ) {
        return obj;
    }
    return {
        ...obj,
        value: callback(obj.value)
    }
}
*/

export {};
