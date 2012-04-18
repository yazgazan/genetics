var Genetic, Solution;

Solution = (require('./sol')).Solution;

Genetic = (function() {

  function Genetic(SolType, totalPop, keepPop) {
    this.SolType = SolType;
    this.totalPop = totalPop != null ? totalPop : 100;
    this.keepPop = keepPop != null ? keepPop : 0;
    if (this.keepPop === 0) this.keepPop = this.totalPop / 2;
    this.pop = new Array;
    return;
  }

  Genetic.prototype.init = function() {
    var i, newSol, _ref;
    for (i = 1, _ref = this.totalPop; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
      newSol = new this.SolType;
      newSol.random();
      newSol.gen = 0;
      this.pop.push(newSol);
    }
  };

  Genetic.prototype.sort = function() {
    this.pop.sort(function(a, b) {
      return b.fit - a.fit;
    });
  };

  Genetic.prototype.bestfit = function() {
    this.sort();
    return this.pop[0];
  };

  Genetic.prototype.eval = function() {
    var sol, _i, _len, _ref, _results;
    _ref = this.pop;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sol = _ref[_i];
      _results.push(sol.eval());
    }
    return _results;
  };

  Genetic.prototype.random = function() {
    var rand;
    rand = Math.round((Math.random() * 100000) % (this.totalPop - 1));
    return this.pop[rand];
  };

  Genetic.prototype.run = function() {
    var i, need1, need2, needed, newPop, newSol, oldPop, sol, _i, _j, _k, _len, _len2, _len3, _ref, _ref2;
    _ref = this.pop;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sol = _ref[_i];
      sol.eval();
    }
    this.gen = 0;
    while (true) {
      if (this.end()) return;
      needed = this.totalPop - this.keepPop;
      need1 = Math.round(needed / 2);
      need2 = needed - need1;
      newPop = new Array;
      for (i = 1; 1 <= need1 ? i <= need1 : i >= need1; 1 <= need1 ? i++ : i--) {
        newSol = new this.SolType;
        newSol.crossOver(this.random(), this.random());
        newSol.gen = this.gen;
        newPop.push(newSol);
      }
      for (i = 1; 1 <= need2 ? i <= need2 : i >= need2; 1 <= need2 ? i++ : i--) {
        newSol = this.random().mutate();
        newSol.gen = this.gen;
        newPop.push(newSol);
      }
      for (_j = 0, _len2 = newPop.length; _j < _len2; _j++) {
        sol = newPop[_j];
        sol.eval();
      }
      for (_k = 0, _len3 = newPop.length; _k < _len3; _k++) {
        sol = newPop[_k];
        this.pop.push(sol);
      }
      if (this.select) {
        this.select(this.totalPop);
        if (this.pop.length !== this.totalPop) throw "Select method failed";
      } else {
        this.sort();
        oldPop = this.pop;
        this.pop = new Array;
        for (i = 0, _ref2 = this.totalPop - 1; 0 <= _ref2 ? i <= _ref2 : i >= _ref2; 0 <= _ref2 ? i++ : i--) {
          this.pop.push(oldPop[i]);
        }
        delete oldPop;
      }
      this.gen++;
    }
  };

  return Genetic;

})();

exports.Genetic = Genetic;

exports.Solution = Solution;
