
Solution = (require './sol').Solution

class Genetic
  constructor: (@SolType, @totalPop = 100, @keepPop = 0) ->
    @keepPop = @totalPop / 2 if @keepPop == 0
    @pop = new Array
    return

  init: ->
    for i in [1..@totalPop]
      newSol = new @SolType
      newSol.random()
      newSol.gen = 0
      @pop.push newSol
    return

  sort: ->
    @pop.sort (a, b) ->
      b.fit - a.fit
    return
  
  bestfit: ->
    @sort()
    @pop[0]

  eval: ->
    sol.eval() for sol in @pop

  random: ->
    rand = Math.round((Math.random() * 100000) % (@pop.length - 1))
    @pop[rand]

  totalFit: ->
    ret = 0
    ret += sol.fit for sol in @pop
    ret

  rws: (f = null) ->
    f = Math.round(Math.random() * 1000000) % @totalFit() if f is null
    f = Math.random() if f == -1
    ptr = 0
    for sol in @pop
      if ptr < f and ptr + sol.fit > f
        return sol
      ptr += sol.fit
    @pop[0]

  selectRWS: (k = null) ->
    @sort()
    newPop = new Array
    newPop.push @rws(k) for i in [1..@totalPop]
    @pop = newPop
    return

  selectRWS2: ->
    @selectRWS -1
    return

  selectSUS: ->
    totalFit = @totalFit()
    start = (Math.random() * 1000) % (totalFit / @totalPop)
    ptrs = new Array
    (ptrs.push (start + i * (totalFit / @totalPop))) for i in [0..(@totalPop - 1)]
    newPop = new Array
    newPop.push @rws(f) for f in ptrs
    @pop = newPop
    return

  run: ->
    sol.eval() for sol in @pop
    @gen = 0
    while true
      if @end()
        @gen--
        return
      needed = @totalPop - @keepPop
      need1 = Math.round(needed / 2)
      need2 = needed - need1
      npop = new Array
      @sort()
      npop.push @pop[i] for i in [0..(@keepPop - 1)]
      @pop = npop
      newPop = new Array
      for i in [1..need1]
        newSol = new @SolType
        newSol.crossOver(@random(), @random())
        newSol.gen = @gen
        newPop.push newSol
      for i in [1..need2]
        newSol = @random().mutate()
        newSol.gen = @gen
        newPop.push newSol
      sol.eval() for sol in newPop
      @pop.push sol for sol in newPop
      if @select
        @select(@totalPop)
        if @pop.length != @totalPop
          throw "Select method failed"
      else
        @sort()
        oldPop = @pop
        @pop = new Array
        @pop.push oldPop[i] for i in [0..(@totalPop - 1)]
        oldPop = null
      @gen++

exports.Genetic = Genetic
exports.Solution = Solution

