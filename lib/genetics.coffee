
pop = require './pop'
Pop = pop.Pop

gn_set_end = (end) ->
  this.end = end
  return

gn_set_end_fun = (fun) ->
  this.endFun = fun
  return

gn_set_cross_over_fun = (fun) ->
  this.crossOverFun = fun
  return

gn_set_mutation_fun = (fun) ->
  this.mutationFun = fun
  return

gn_set_select_fun = (fun) ->
  this.select = fun
  this.pop.setSelect fun
  return

gn_is_end = ->
  if this.end != null
    if this.end.generation != null
      if this.gen >= this.end.generation
        return true
    if this.end.fit != null
      if this.pop.best() >= this.end.fit
        return true
  if this.endFun != null
    if this.endFun()
      return true
  return false

gn_do_crossOver = ->
  sol1 = this.pop.getRandomSol()
  sol2 = this.pop.getRandomSol()
  ret = this.crossOverFun sol1.datas, sol2.datas
  return ret

gn_do_mutate = ->
  sol = this.pop.getRandomSol()
  ret = this.mutationFun sol
  return ret

gn_run = ->
  throw "Can't run" if this.end is null and this.endFun is null
  throw "Can't run" if this.crossOverFun is null
  throw "Can't run" if this.mutationFun is null
  throw "Can't run" if this.select is null
  while 1
    if this.isEnd()
      return
    this.pop.eval()
    this.pop.sort()
    this.pop.select(this.keepPop)
    needed = this.totalPop - this.keepPop
    throw "select failed" if this.pop.pop.length != this.keepPop
    throw "select failed" if needed == 0
    need1 = Math.round(needed / 2)
    need2 = needed - need1
    (this.pop.add this.doCrossOver(), this.gen) for i in [1..need1]
    (this.pop.add this.doMutate(), this.gen) for i in [1..need2]
    this.gen++
  return

Genetic = ->
  this.end              = null
  this.endFun           = null
  this.gen              = 0
  this.crossOverFun     = null
  this.mutationFun      = null
  this.select           = null
  this.totalPop         = 100
  this.keepPop          = 50
  this.isEnd            = gn_is_end
  this.doCrossOver      = gn_do_crossOver
  this.doMutate         = gn_do_mutate

  # Population
  this.pop = new Pop

  # setEnd(end)
  #   set end condition.
  #   end must be an object containing one of these conditions (or both) :
  #   generation : end when this generation is reached
  #   fit : end when a fitness is reached
  this.setEnd           = gn_set_end

  # setEndFun(fun)
  #   set end function
  #   fun must return a boolean
  this.setEndFun        = gn_set_end_fun

  # setCrossOverFun(fun)
  #   set crossOver function.
  #   this function take two solution
  #   this function must return a new solution
  this.setCrossOverFun  = gn_set_cross_over_fun

  # setMutationFun(fun)
  #   set mutation function.
  #   this function take a solution
  #   this function must return a new solution
  this.setMutationFun   = gn_set_mutation_fun

  # setSelect(fun)
  #   set select function.
  #   this function is used to select people for mutations and crossover
  #   this function will be part of Pop object
  this.setSelect        = gn_set_select_fun

  # run()
  #   run genetic algorithm
  this.run              = gn_run

  return this

exports.Genetic = Genetic

