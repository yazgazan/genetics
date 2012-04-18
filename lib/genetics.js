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
    rand = Math.round((Math.random() * 100000) % (this.pop.length - 1));
    return this.pop[rand];
  };

  Genetic.prototype.totalFit = function() {
    var ret, sol, _i, _len, _ref;
    ret = 0;
    _ref = this.pop;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sol = _ref[_i];
      ret += sol.fit;
    }
    return ret;
  };

  Genetic.prototype.rws = function(f) {
    var ptr, sol, _i, _len, _ref;
    if (f == null) f = null;
    if (f === null) f = Math.round(Math.random() * 1000000) % this.totalFit();
    if (f === -1) f = Math.random();
    ptr = 0;
    _ref = this.pop;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sol = _ref[_i];
      if (ptr < f && ptr + sol.fit > f) return sol;
      ptr += sol.fit;
    }
    return this.pop[0];
  };

  Genetic.prototype.selectRWS = function(k) {
    var i, newPop, _ref;
    if (k == null) k = null;
    this.sort();
    newPop = new Array;
    for (i = 1, _ref = this.totalPop; 1 <= _ref ? i <= _ref : i >= _ref; 1 <= _ref ? i++ : i--) {
      newPop.push(this.rws(k));
    }
    delete this.pop;
    this.pop = newPop;
  };

  Genetic.prototype.selectRWS2 = function() {
    this.selectRWS(null);
  };

  Genetic.prototype.selectSUS = function() {
    var f, i, newPop, ptrs, start, totalFit, _i, _len, _ref;
    totalFit = this.totalFit();
    start = (Math.random() * 1000) % (totalFit / this.totalPop);
    ptrs = new Array;
    for (i = 0, _ref = this.totalPop - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
      ptrs.push(start + i * (totalFit / this.totalPop));
    }
    newPop = new Array;
    for (_i = 0, _len = ptrs.length; _i < _len; _i++) {
      f = ptrs[_i];
      newPop.push(this.rws(f));
    }
    delete this.pop;
    this.pop = newPop;
  };

  Genetic.prototype.run = function() {
    var i, need1, need2, needed, newPop, newSol, npop, oldPop, sol, _i, _j, _k, _len, _len2, _len3, _ref, _ref2, _ref3;
    _ref = this.pop;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      sol = _ref[_i];
      sol.eval();
    }
    this.gen = 0;
    while (true) {
      if (this.end()) {
        this.gen--;
        return;
      }
      needed = this.totalPop - this.keepPop;
      need1 = Math.round(needed / 2);
      need2 = needed - need1;
      npop = new Array;
      this.sort();
      for (i = 0, _ref2 = this.keepPop - 1; 0 <= _ref2 ? i <= _ref2 : i >= _ref2; 0 <= _ref2 ? i++ : i--) {
        npop.push(this.pop[i]);
      }
      this.pop = npop;
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
        for (i = 0, _ref3 = this.totalPop - 1; 0 <= _ref3 ? i <= _ref3 : i >= _ref3; 0 <= _ref3 ? i++ : i--) {
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
