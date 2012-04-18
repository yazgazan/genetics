
genetics = require '../lib/genetics'
Genetic = genetics.Genetic
Solution = genetics.Solution

mod = 1000
ratio = 100

modb = Math.round(mod / ratio)
moda = mod - 1
best = mod * mod

class Sol extends Solution
  random: ->
    @a = Math.round(Math.random() * 1000) % mod
    @b = Math.round(Math.random() * 1000) % mod
    @c = Math.round(Math.random() * 1000) % mod
    return

  crossOver: (sola, solb) ->
    @a = Math.round((sola.a + solb.a) / 2)
    @b = Math.round((sola.b + solb.b) / 2)
    @c = Math.round((sola.c + solb.c) / 2)
    return

  mutate: ->
    newSol = new Sol
    newSol.a = @a
    newSol.b = @b
    newSol.c = @c
    if Math.random() < 0.3
      newSol.a = Math.round(Math.random() * 1000) % (mod + 1)
    if Math.random() < 0.3
      newSol.b = Math.round(Math.random() * 1000) % (mod + 1)
    if Math.random() < 0.3
      newSol.c = Math.round(Math.random() * 1000) % (mod + 1)
    return newSol
  
  eval: ->
    @fit = (@a * @b - @c) / best
    return

class Gene extends Genetic
  end: ->
    console.log @gen + ', ' + @bestfit().fit
    return @gen == 100 or @bestfit().fit >= 1

  select: ->
    @selectSUS()

gen = new Gene Sol, 10000
gen.init()

gen.eval()
console.log gen.bestfit()
gen.run()

console.log gen.bestfit()
console.log 'last gen : ' + gen.gen

