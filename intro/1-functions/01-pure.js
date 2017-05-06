/**
 * From Andre Staltz' Pragmatic functional programming in JavaScript
 * https://github.com/staltz/fp-js-workshop/tree/master/1-pure-functions
 */

// função impura
function greetImpure(name) {
  console.log(`Welcome ${name}!`);
}

// função pura
function greetString(name) {
  return `Welcome ${name}!`;
}

// função pura
function greetEval(name) {
  return `console.log('Welcome ${name}!')`;
}

// função pura
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
