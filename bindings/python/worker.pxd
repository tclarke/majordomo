include "zmsg.pxd"
cdef extern from "mdp_worker.h":
    ctypedef struct mdp_worker_t:
        pass

    mdp_worker_t *mdp_worker_new (char *broker,char *service, int verbose)
    void mdp_worker_destroy (mdp_worker_t **self_p)
    void mdp_worker_set_heartbeat (mdp_worker_t *self, int heartbeat)
    void mdp_worker_set_reconnect (mdp_worker_t *self, int reconnect)
    zmsg_t *mdp_worker_recv (mdp_worker_t *self, zmsg_t **reply_p)
