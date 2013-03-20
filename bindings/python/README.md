Python bindings for libmdp
==========================

This contains basic cython bindings for client and worker funcionality of libmdp. It's build against
the 0.2 protocol spec and library. It has been tested on Linux with Python 2.7 and Cython 0.16.
The code will probably not work with Python 3.x due to the use of PyCObject. I've inclued a
test__client.py and test__worker.py which mimic the C programs of the same name.

The setup.py is not very fancy and does not attempt to locate libmdp, libzmq, or libczmq. If you have
them installed in a non-standard location, add the include and lib directories to the appropriate env
variables. For example:

CFLAGS="-I/usr/local/zmq3/include" LDFLAGS="-L/usr/local/zmq3/lib" python setup.py build
