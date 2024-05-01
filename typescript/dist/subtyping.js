const newCat = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
};
const clone = newCat; // Cat型はAnimal型の部分型なので、代入可能
// ただし、下記はエラー。部分型なので一見良さそうだが、こういう書き方をするのは、何か間違いをしている可能性があり、その防止のため。
/*
const errorCat: Animal = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
}
*/
// => Object literal may only specify known properties, and 'nikukyu' does not exist in type 'Animal'.
const noErrorCat = {
    head: "小さいお耳があるにゃん",
    body: "しましまもようだにゃん",
    tail: "ながいしっぽがあるにゃん",
    sex: "女の子",
    nikukyu: "ぷにぷに"
};
const thisIsOKCat = noErrorCat; //これならOK
// SubTypeは、Typeの部分型である
const sub = {
    name: 'hoge',
    age: 25
};
const t = sub;
const subf = (arg) => sub;
const f = subf;
const f2 = subf;
const taf = (type) => parseInt(type.name);
const staf = taf;
staf(sub);
const something = {
    func: user => user.name,
    method: user => user.name
};
const getAge = (user) => String(user.age);
//something.func = getAge; // =>エラーが出る（正しい）
// something.method = getAge;　// => エラーが出ない（間違い）
// objectのreadonly propertyの限界について
// objectのreadonly propertyと部分型を組み合わせると、予期しないことが起きることがある（というか、TSの型チェックが不完全）
// 配列の場合は問題ない
// readonlyの付いていないobject/arrayは、readonlyのついたobject/arrayの部分型である（readonlyのobject/arrayであるための条件を満たすため）
function sum(nums) {
    let result = 0;
    for (const num of nums) {
        result += num;
    }
    return result;
}
const nums1 = [1, 10, 100];
const nums2 = [1, 1, 2, 3, 5, 8];
sum(nums1);
sum(nums2); // number[]はreadonly number[]の部分型なので、渡せる
// エラーが出る例
function fillZero(nums) {
    for (let i = 0; i < nums.length; i++) {
        nums[i] = 0;
    }
}
const uhyoify = (user) => {
    user.name = "uhyo";
};
const jhon = {
    name: "jhon"
};
// jhon.name = "uhyo";  // => error
uhyoify(jhon); // errorが出ない。。。Read onlyなのに上書きできちゃう
// unknown型は、すべての型を部分型として持てるので、あらゆる値を代入できる。
const u1 = 3;
const u2 = "string";
const u3 = false;
const numFunc = () => 123; // エラーが起きない
export {};
