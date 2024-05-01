const fo = {
    apple: 0,
    orange: 1,
    grape: 2
};
function restFunc(mode, ...args) {
    console.log(mode, ...args);
}
restFunc("test", "1", "2");
restFunc(1, 2, 3);
const opt1 = { type: 'Some', value: 123 };
const opt2 = { type: 'None' };
// union ditributionではないパターン
// typeof opt1はSome<number>なので ValueOfOption<typeof opt1>はnumber
const val1 = 12345;
// union ditributionではないパターン
// typeof opt2はNoneなのでValueOfOption<typeof opt2>はundefined
const val2 = undefined;
const fba1 = { foo: ["string"] };
const fba2 = { bar: [0] };
const fba3 = { foo: ["string"], bar: [0] };
let cfbar = fba1;
cfbar = fba2;
cfbar = fba3;
const nbsarr = ["string"];
export {};
