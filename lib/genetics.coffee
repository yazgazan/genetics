
Solution = (require './sol.coffee').Solution

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
      return b.fit - a.fit
    return
  
  bestfit: ->
    @sort()
    return @pop[0]

  eval: ->
    sol.eval() for sol in @pop

  random: ->
    rand = Math.round((Math.random() * 100000) % (@totalPop - 1))
    return @pop[rand]

  run: ->
    sol.eval() for sol in @pop
    @gen = 0
    while true
      if @end()
        return
      needed = @totalPop - @keepPop
      need1 = Math.round(needed / 2)
      need2 = needed - need1
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
        delete oldPop
      @gen++

exports.Genetic = Genetic
exports.Solution = Solution

