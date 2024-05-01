var __classPrivateFieldGet = (this && this.__classPrivateFieldGet) || function (receiver, state, kind, f) {
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a getter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot read private member from an object whose class did not declare it");
    return kind === "m" ? f : kind === "a" ? f.call(receiver) : f ? f.value : state.get(receiver);
};
var __classPrivateFieldSet = (this && this.__classPrivateFieldSet) || function (receiver, state, value, kind, f) {
    if (kind === "m") throw new TypeError("Private method is not writable");
    if (kind === "a" && !f) throw new TypeError("Private accessor was defined without a setter");
    if (typeof state === "function" ? receiver !== state || !f : !state.has(receiver)) throw new TypeError("Cannot write private member to an object whose class did not declare it");
    return (kind === "a" ? f.call(receiver, value) : f ? f.value = value : state.set(receiver, value)), value;
};
var _a, _UserClass_pri;
class UserClass {
    // ctorで定義するか、構文内で定義するかのどちらか
    // name: string;
    // private age: number;
    // readonly sex: boolean;
    // protected data: T
    constructor(name, age, sex, data) {
        this.name = name;
        this.age = age;
        this.sex = sex;
        this.data = data;
        // class文の中に書いてもいいが、ctorで初期化されるものに関してはこう書く方が楽
        // propの型・アクセス修飾子定義と、初期値の代入が一気にできる(publicも必ず書かないといけない)
        // 関数の実体が空なのは、初期値の代入をTSが自動で行ってくれるから
        // ただし、ctorで初期値を設定しないプロパティの定義は、class構文中に書かないといけないため、
        // プロパティ定義の場所が別れて可読性が下がるデメリットがあるので、複雑なclassには不向き
        // private変数は、#を使って表せる。これはESの表記なので、runtimeでも効果が持続する。
        // ただし、継承のときにoverrideできてしまう（継承先で#priを全く違うものとして定義できてしまう）
        _UserClass_pri.set(this, "private");
    }
    getPri() {
        // #へのアクセスは、obj.#xxでする必要がある。obj["#xx"]ではアクセス不可
        return __classPrivateFieldGet(this, _UserClass_pri, "f");
    }
    isAdult() {
        return this.age >= 20;
    }
    getAge() {
        return this.age;
    }
    static getAdminUser() {
        return _a.adminUser;
    }
}
_a = UserClass, _UserClass_pri = new WeakMap();
// static 変数/関数
UserClass.adminName = "admin";
// staticブロック: class宣言評価時に実行されるブロック
// クラス内のprivate propertyにもアクセスできるので、クラス内で定義されている本来の挙動を
// 無視した設定ができる
// おそらくこれもESのよう。TSのreadonlyとかは突破できなかった。
(() => {
    // staticな変数をthisで参照可能
    _a.adminUser = new _a(_a.adminName, 99, true, "super admin");
    __classPrivateFieldSet(_a.adminUser, _UserClass_pri, "super private", "f");
})();
// extends で継承
// implementsでinterface定義（その型の部分型であることを強制する）
class PremiumUser extends UserClass {
    constructor(name, age, sex, data) {
        super(name, age, sex, data);
    }
    // override修飾子: tsconfigでnoImplicitOverrideを指定すると、
    // 同名関数にはかならずoverride修飾子を強制できる
    isAdult() {
        return true;
    }
}
function getPrice(customer) {
    // 型の絞り込みが可能だが、アンチパターン
    if (customer instanceof UserClass) {
        if (customer.isAdult()) {
            return 2000;
        }
    }
    return customer.getAge();
}
export {};
