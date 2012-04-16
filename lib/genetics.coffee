
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

gn_run = ->
  throw "Can't run" if this.end is null or this.endFun is null
  throw "Can't run" if this.crossOverFun is null
  throw "Can't run" if this.mutationFun is null
  throw "Can't run" if this.select is null
  return

Genetic = ->
  this.end              = null
  this.endFun           = null
  this.gen              = 0
  this.crossOverFun     = null
  this.mutationFun      = null
  this.select           = null

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

  # run()
  #   run genetic algorithm
  this.run              = gn_run

  return this

exports.Genetic = Genetic

