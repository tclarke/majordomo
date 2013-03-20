#!/usr/bin/env python

import sys
import mdp

verbose = len(sys.argv) > 1 and sys.argv[1] == "-v"
w = mdp.Worker('tcp://localhost:5555', 'echo', verbose)

try:
    reply = None
    while 1:
        rqst = w.recv(reply)
        if rqst is None:
            break
        reply = rqst
except KeyboardInterrupt: pass # CTRL-C to break
