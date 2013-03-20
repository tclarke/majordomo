include "zmsg.pxd"
include "client.pxd"
include "worker.pxd"

from cpython.cobject cimport PyCObject_FromVoidPtr,PyCObject_AsVoidPtr

def ZMsgError(BaseException):
    pass

cdef class ZMsg:
    cdef zmsg_t *_c_hndl

    def __cinit__(self, initialize=True):
        if initialize:
            self._c_hndl = zmsg_new()
        else:
            self._c_hndl = NULL

    def __dealloc__(self):
        pass
        if self._c_hndl is not NULL:
            zmsg_destroy(&self._c_hndl)

    def copy(self):
        tmp = ZMsg(False)
        cdef zmsg_t *newp = zmsg_dup(self._c_hndl)
        tmp.set_zmsg_t(PyCObject_FromVoidPtr(<void*>newp, NULL))
        return tmp

    def set_zmsg_t(self, hndl):
        if self._c_hndl is not NULL:
            zmsg_destroy(&self._c_hndl)
        self._c_hndl = <zmsg_t*>PyCObject_AsVoidPtr(hndl)

    def get_zmsg_t(self):
        return PyCObject_FromVoidPtr(<void*>self._c_hndl, NULL)

    def release(self):
        rval = PyCObject_FromVoidPtr(<void*>self._c_hndl, NULL)
        self._c_hndl = NULL
        return rval

    def __len__(self):
        return zmsg_size(self._c_hndl)

    def push(self, str):
        if zmsg_pushstr(self._c_hndl, <char*>(str)) < 0:
            raise ZMsgError("Unable to push to zmsg")

    def append(self, str):
        if zmsg_addstr(self._c_hndl, <char*>(str)) < 0:
            raise ZMsgError("Unable to append to zmsg")

    def pop(self):
        if zmsg_size(self._c_hndl) <= 0:
            raise ZMsgError("zmsg is empty")
        return zmsg_popstr(self._c_hndl)

cdef class Client:
    cdef mdp_client_t *_c_hndl

    def __cinit__(self, broker, verbose=False):
        self._c_hndl = mdp_client_new(broker, int(verbose))

    def __dealloc__(self):
        if self._c_hndl is not NULL:
            mdp_client_destroy(&self._c_hndl)

    def set_timeout(self, timeout):
        mdp_client_set_timeout(self._c_hndl, timeout)

    def set_retries(self, retries):
        mdp_client_set_retries(self._c_hndl, retries)

    def send(self, char *service, request):
        if not isinstance(request, ZMsg):
            zm = ZMsg()
            tmps = str(request)
            zm.push(tmps)
            request = zm
        preq_po = request.release()
        cdef zmsg_t *preq = <zmsg_t*>PyCObject_AsVoidPtr(preq_po)
        cdef zmsg_t *tmp = mdp_client_send(self._c_hndl, service, &preq)
        if tmp is NULL:
            return None
        rval = ZMsg(False)
        rval.set_zmsg_t(PyCObject_FromVoidPtr(<void*>tmp, NULL))
        return rval

cdef class Worker:
    cdef mdp_worker_t *_c_hndl

    def __cinit__(self, broker, service, verbose=False):
        self._c_hndl = mdp_worker_new(broker, service, int(verbose))

    def __dealloc__(self):
        if self._c_hndl is not NULL:
            mdp_worker_destroy(&self._c_hndl)

    def set_heartbeat(self, heartbeat):
        mdp_worker_set_heartbeat(self._c_hndl, heartbeat)

    def set_reconnect(self, reconnect):
        mdp_worker_set_reconnect(self._c_hndl, reconnect)

    def recv(self, reply=None):
        "reply is the previous reply or None to skip the reply stage"
        if reply is not None and not isinstance(reply, ZMsg):
            tmpm = ZMsg()
            tmpm.push(str(reply))
            reply = tmpm
        cdef zmsg_t *prep = NULL
        if reply is not None:
            prep_po = reply.release()
            prep = <zmsg_t*>PyCObject_AsVoidPtr(prep_po)
        cdef zmsg_t *tmp = mdp_worker_recv(self._c_hndl, &prep)
        if tmp is NULL:
            return None
        rval = ZMsg(False)
        rval.set_zmsg_t(PyCObject_FromVoidPtr(<void*>tmp, NULL))
        return rval
