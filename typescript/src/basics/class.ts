class UserClass<T> {
    // ctorで定義するか、構文内で定義するかのどちらか
    // name: string;
    // private age: number;
    // readonly sex: boolean;
    // protected data: T

    constructor(
        public name: string,
        private age: number, 
        public readonly sex: boolean,
        protected data: T
    ) {} 
    // class文の中に書いてもいいが、ctorで初期化されるものに関してはこう書く方が楽
    // propの型・アクセス修飾子定義と、初期値の代入が一気にできる(publicも必ず書かないといけない)
    // 関数の実体が空なのは、初期値の代入をTSが自動で行ってくれるから
    // ただし、ctorで初期値を設定しないプロパティの定義は、class構文中に書かないといけないため、
    // プロパティ定義の場所が別れて可読性が下がるデメリットがあるので、複雑なclassには不向き

    // private変数は、#を使って表せる。これはESの表記なので、runtimeでも効果が持続する。
    // ただし、継承のときにoverrideできてしまう（継承先で#priを全く違うものとして定義できてしまう）
    #pri: string = "private";
    private getPri() {
        // #へのアクセスは、obj.#xxでする必要がある。obj["#xx"]ではアクセス不可
        return this.#pri;
    }
    
    public isAdult() { //publicはつけてもつけなくても同じ意味
        return this.age >= 20;
    }
    
    getAge() {
        return this.age;
    }

    // static 変数/関数
    static adminName = "admin";
    static adminUser: UserClass<string>;
    static getAdminUser() {
        return UserClass.adminUser;
    }
    
    // staticブロック: class宣言評価時に実行されるブロック
    // クラス内のprivate propertyにもアクセスできるので、クラス内で定義されている本来の挙動を
    // 無視した設定ができる
    // おそらくこれもESのよう。TSのreadonlyとかは突破できなかった。
    static {
        // staticな変数をthisで参照可能
        this.adminUser = new UserClass(
            this.adminName,
            99,
            true,
            "super admin"
        );
        this.adminUser.#pri = "super private";
    }
}

// extends で継承
// implementsでinterface定義（その型の部分型であることを強制する）
class PremiumUser<T> extends UserClass<T> implements HasAge {
    constructor(
        name: string,
        age: number, 
        sex: boolean,
        data: T
    ) {
        super(name, age, sex, data)
    }
    
    // override修飾子: tsconfigでnoImplicitOverrideを指定すると、
    // 同名関数にはかならずoverride修飾子を強制できる
    public override isAdult(): boolean {
        return true
    }
}

// めったに使わないが、クラス自体の型はnew ctor（引数付き） => クラス名として、こう書ける
type UserClassType<T> = new (
        name: string,
        age: number, 
        sex: boolean,
        data: T
    ) => UserClass<T>

// new シグネチャをつかって、こうもかける
type UserClassType2<T> = {
    new (
        name: string,
        age: number, 
        sex: boolean,
        data: T
    ) : UserClass<T>
}

// instanceof を利用して、型の絞り込みが可能だが、一般的にはアンチパターン
// instanceofはJSの機能であり、TSの機能ではないため、流儀が微妙に異なる。
// instanceofはランタイムでそのオブジェクトがnew演算子によってインスタンス化されたかどうかを判定するもの
// TSは、new演算子でインスタンス化していなくても、
// そのオブジェクトがあるクラスの部分型になっていればOKなので、ニュアンスが異なる
type HasAge = {
    getAge: () => number;
}
function getPrice(customer: HasAge) {
    // 型の絞り込みが可能だが、アンチパターン
    if (customer instanceof UserClass) {
        if (customer.isAdult()) {
            return 2000;
        }
    }
    return customer.getAge();
}

export {};
    