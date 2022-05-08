//TODO: fill your information here

let yourName = "Hoàng Quốc Nam"
let yourID = "20127566"
let yourClass = "20CLC09"
// course dc tao trc const course = "xxxx"
const course = "XXXX"

let answers = document.getElementsByClassName("answer");

answers[0]
  .getElementsByClassName("question")[0]
  .getElementsByTagName("input")[0].value = yourID;
answers[1]
  .getElementsByClassName("question")[0]
  .getElementsByTagName("input")[0].value = yourName;
answers[2]
  .getElementsByTagName("ul")[0]
  .getElementsByTagName("li")[8]
  .getElementsByTagName("input")[1].checked = true;
answers[3]
  .getElementsByClassName("question")[0]
  .getElementsByTagName("input")[0].value = yourClass;
answers[4]
  .getElementsByTagName("ul")[0]
  .getElementsByTagName("li")
  [course].getElementsByTagName("input")[1].checked = true;

let answerB = document.getElementsByClassName("answer");
for (let i = 0; i < answerB.length; i++) {
  let ul = answerB[i].getElementsByTagName("ul")[0];
  console.log(ul);
  let li = ul.getElementsByTagName("li")[4];
  li.getElementsByTagName("input")[0].checked = true;
}
