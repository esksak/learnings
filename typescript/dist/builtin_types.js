// 組み込みの型
// Readonly<T>: Tのreadonly型
// Partial<T>: Tの全てのプロパティをオプショナルに
// Required<T>: Tの全てのプロパティを必須に
// Pick<T, K>: Tのうち、K（string | number | symbolを要素としてもつユニオン型）で指定したプロパティのみをとってくる型
// Omit<T, K>: Pickの逆で、Kで指定したプロパティを捨てた型
// Extract<T, U>: T（普通はユニオン型）の構成要素のうちUの部分型となるものだけを抜き出した型
// Exclude<T, U>: Extractの逆で、Uの部分型となるものだけを捨てた型
// NonNullable<T>: Exclude<T, null | undefined>と同じ意味で、Tからnullとundefinedの可能性を取り除いた型
export {};
