cdef extern from "czmq.h":
    pass

cdef extern from "zmsg.h":
    ctypedef struct zmsg_t:
        pass

    zmsg_t *zmsg_new ()
    void zmsg_destroy (zmsg_t **self_p)
    size_t zmsg_size (zmsg_t *self)
    size_t zmsg_content_size (zmsg_t *self)
    int zmsg_pushstr (zmsg_t *self, char *format, ...)
    int zmsg_addstr (zmsg_t *self, char *format, ...)
    char *zmsg_popstr (zmsg_t *self)
    zmsg_t *zmsg_dup (zmsg_t *self)
    void zmsg_dump (zmsg_t *self)
