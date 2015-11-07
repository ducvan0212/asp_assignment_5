#script (python)

import gringo
from gringo import Fun
from IPython import embed

class Solver:
    def __init__(self, fpath):
        self._prg = gringo.Control()
        self._prg.conf.solve.models = 0 
        self._prg.load(fpath)
        self._prg.ground([("base", [])])
        
def main():
    p = Solver("p.lp")
    q = Solver("q.lp")
    
    intermediate = p._prg.solve_iter()
    
    # with each model in intermediate results
    for i, model in enumerate(intermediate):
        # assign each atoms in p model to be true in q
        for k in model.atoms(gringo.Model.ATOMS):
            q._prg.assign_external(k, True)   
        # calculate final solutions, where wizard does his job.
        final = q._prg.solve_iter()
        for j, fiso in enumerate(final):
            print "Allakhazam: %s" % (fiso)
        # remove assignments.
        for k in model.atoms(gringo.Model.ATOMS):
            q._prg.release_external(k)
        
#end.

main()