#script (python)
import gringo
from gringo import Fun
from IPython import embed

def main():
    prg = gringo.Control()
    prg.conf.solve.models = 0
    prg.load("p.lp")
    prg.load("q.lp")
    prg.ground([("base", [])])
    solutions = prg.solve_iter()
    
    for i, sol in enumerate(solutions): 
        print "Allakhazam #%d: %s" % (i, sol)
    
#end.

main()
