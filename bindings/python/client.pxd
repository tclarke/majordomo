include "zmsg.pxd"
cdef extern from "mdp_client.h":
    ctypedef struct mdp_client_t:
        pass

    mdp_client_t *mdp_client_new (char *broker, int verbose)
    void mdp_client_destroy (mdp_client_t **self_p)
    void mdp_client_set_timeout (mdp_client_t *self, int timeout)
    void mdp_client_set_retries (mdp_client_t *self, int retries)
    void mdp_client_send (mdp_client_t *self, char *service, zmsg_t **request_p)
    zmsg_t *mdp_client_send (mdp_client_t *self, char *service, zmsg_t **request_p)
