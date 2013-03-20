#!/usr/bin/env python

import sys
import mdp

verbose = len(sys.argv) > 1 and sys.argv[1] == "-v"
c = mdp.Client('tcp://localhost:5555', verbose)

cnt = 0
try:
    for i in xrange(100000):
        r = c.send('echo', 'Hello world')
        if r is None or len(r) != 1:
            break
        cnt += 1
except KeyboardInterrupt: pass # CTRL-C to break
print("%i requests/replies processed" % cnt)
