#Genetics

Genetics is a genetic algorithm implementation for [node](http://nodejs.org);  
Genetics is written in [CoffeeScript](http://coffeescript.org/) but can be used in JavaScript.

#Installation
    npm install Genetics

#Usage
See test/test.coffee for quick start.

##Class Genetic(solType, totalPop = 100, keepPop = 0)
solType must be an implementation of class Solution()
totalPop is the total number of solutions
keepPop is the number of solutions kept after selection (by default : totalPop / 2)
This class must implement the folowing method :
after implementation, Genetic.init() and Genetic.run() must be called

###Genetic.end()
return true if end Conditions is reached
else return false

###Genetic.select() (optional)
Select Solutions to be kept from @pop
After the Selection, @pop.length must equal @totalPop


##Class Solution()
This class must implement the following methods :

###Solution.random()
Generate a random solution.

###Solution.crossOver(sol1, sol2)
Generate a solution from sol1 and sol2

###Solution.mutate()
Return a mutated solution

###Solution.eval()
Set Solution.fit to a number representing the solution's fitness

#Documentation

##Genetics.pop\<Array>
contain all solutions

##Genetics.gen\<Number>
current generation

##Genetics.constructor(@solType, @totalPop = 100, @keepPop = 0)
 - set @solType, @totalPop and @keepPop
 - if @keepPop == 0, then @keepPop = @totalPop / 2
 - create an empty array @pop


##Genetics.init()
 - generate @totalPop solutions calling Solution.random()
 - solutions are pushed into @pop

 
##Genetics.sort()
 - sort @pop by fitness 
 - solutions must have been evaluated before calling @sort()

 
##Genetics.bestfit()
 - return bestfit after calling @sort()


##Genetics.eval()
 - call Solution.eval() for each solution in @pop


##Genetics.random()
 - return a randomly chose solution from @pop


##Genetics.run()
 - run genetic algorithm
 - initial pop is eval
 - initialize @gen to 0
  - @end() is checked
  - newPop is generated with Solution.crossOver() and Solution.mutate()
  - newPop is eval by calling Solution.eval() for each new solution
  - newPop is added to @pop
  - if @select() is not implemented, the @totalPop best Solution are selected
  - else @select() is called, an exception is threw if @pop.length != @totalPop
  - @gen is incremented

##Genetics.totalFit()
 - return total Fitness of @pop

##Genetics.rws(f = null)
 - return a random solution selected by roulette wheel
 - f is a random number, auto-generated if f == null

##Genetics.selectRWS()
 - select by roulette wheel sampling
 - using this selection method, Solution.eval must return a value in [0,1]
 - implementation may looks like :
    select: -> @selectRWS()

##Genetics.selectRWS2() (cheated :p)
 - select by roulette wheel sampling, with higher probability for bests fit
 - using this selection method, Solution.eval must return a value in [0,1]
 - implementation may looks like :
    select: -> @selectRWS2()

##Genetics.selectSUS()
 - select by Stochastic universal sampling
 - using this selection method, Solution.eval must return a value in [0,1]
 - implementation may looks like :
    select: -> @selectSUS()

