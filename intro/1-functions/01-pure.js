/**
 * From Andre Staltz' Pragmatic functional programming in JavaScript
 * https://github.com/staltz/fp-js-workshop/tree/master/1-pure-functions
 */

// impure function
function greetImpure(name) {
  console.log(`Welcome ${name}!`);
}

// pure function
function greetString(name) {
  return `Welcome ${name}!`;
}

// pure function
function greetEval(name) {
  return `console.log('Welcome ${name}!')`;
}

// pure function
function greetInstruction(name) {
  return {
    type: 'log',
    data: `Welcome ${name}!`,
  };
}

//
greetImpure('Michael');
greetString('Richard');
greetEval('Mariane');
greetInstruction('William');

//
console.log(greetString('Richard'));

//
eval(greetEval('William'));

//
let instruction = greetInstruction('Pauline');

switch (instruction.type) {
  case 'log':
    console.log(instruction.data);
    break;
}
