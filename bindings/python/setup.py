from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [
    Extension("mdp",
            ["mdp.pyx"],
            libraries=["mdp","czmq","zmq"]
    )]

setup(
    name="mdp",
    cmdclass = {"build_ext":build_ext},
    ext_modules = ext_modules
)
