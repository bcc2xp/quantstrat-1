# Walk Forward demo for MACD
###############################################################################

require(foreach,quietly=TRUE)
require(iterators)
require(quantstrat)

demo('macd',ask=FALSE)

# example parallel initialization for doParallel. this or doMC, or doRedis are 
# most probably preferable to doSMP
#require(doParallel)
#registerDoParallel() # by default number of physical cores -1


#please run macd demo before all these...

#retrieve the strategy from the environment, since the 'macd' strategy uses store=TRUE
strategy.st <- 'macd'

### Set up Parameter Values
.FastMA = (1:10)
.SlowMA = (5:25)
.nsamples = 15 #for random parameter sampling, less important if you're using doParallel or doMC


### MA paramset

add.distribution(strategy.st,
                 paramset.label = 'MA',
                 component.type = 'indicator',
                 component.label = '_', #this is the label given to the indicator in the strat
                 variable = list(n = .FastMA),
                 label = 'nFAST'
)

add.distribution(strategy.st,
                 paramset.label = 'MA',
                 component.type = 'indicator',
                 component.label = '_', #this is the label given to the indicator in the strat
                 variable = list(n = .SlowMA),
                 label = 'nSLOW'
)

add.distribution.constraint(strategy.st,
                            paramset.label = 'MA',
                            distribution.label.1 = 'nFAST',
                            distribution.label.2 = 'nSLOW',
                            operator = '<',
                            label = 'MA'
)


###

results <- walk.forward(strategy.st, 
                        paramset.label='MA', 
                        portfolio.st=portfolio.st, 
                        account.st=account.st, 
                        nsamples=.nsamples,
                        period='months',
                        k.training = 12,
                        k.testing = 36,
                        verbose=TRUE)

wfa.stats <- results$tradeStats

print(wfa.stats)

