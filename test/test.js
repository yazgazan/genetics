
genetics = require('../lib/genetics');
Genetic = genetics.Genetic
Solution = genetics.Solution

var mod = 1000;
var ratio = 1;

modb = Math.round(mod / ratio);
moda = modb - 1;
best = mod * mod;

var Sol = Solution;

Sol.prototype.random = function () {
  this.a = Math.round(Math.random() * 1000) % modb;
  this.b = Math.round(Math.random() * 1000) % modb;
  this.c = Math.round(Math.random() * 1000) % modb;
  return;
}

Sol.prototype.crossOver = function (sola, solb) {
  this.a = Math.round((sola.a + solb.a) / 2);
  this.b = Math.round((sola.b + solb.b) / 2);
  this.c = Math.round((sola.c + solb.c) / 2);
  return;
}

Sol.prototype.mutate = function () {
  newSol = new Sol();
  newSol.a = this.a;
  newSol.b = this.b;
  newSol.c = this.c;
  if (Math.random() < 0.3)
    newSol.a = Math.round(Math.random() * 1000) % (mod + 1);
  if (Math.random() < 0.3)
    newSol.b = Math.round(Math.random() * 1000) % (mod + 1);
  if (Math.random() < 0.3)
    newSol.c = Math.round(Math.random() * 1000) % (mod + 1);
  return (newSol);
}

Sol.prototype.eval = function () {
  this.fit = this.a * this.b - this.c;
  return;
}

var Gene = Genetic;

Gene.prototype.end = function () {
  return (this.bestfit().fit >= best);
}

gen = new Gene(Sol, 100);
gen.init();

gen.eval();
console.log(gen.bestfit());
gen.run();

console.log(gen.bestfit());
console.log('last gen :' + gen.gen);

