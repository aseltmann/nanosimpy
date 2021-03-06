#!/bin/bash
set -e -x

# Install a system package required by our library

for PYBIN in /opt/python/cp26-cp26mu/bin; do
    "${PYBIN}/pip" install numpy==1.10
    
done


# Compile wheels
for PYBIN in /opt/python/cp27-cp27mu/bin; do
    "${PYBIN}/pip" install -r /io/dev-requirements.txt
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/*.whl; do
    auditwheel repair "$whl" -w /io/wheelhouse/
done

# Install packages and test
for PYBIN in /opt/python/cp27-cp27mu/bin/; do
    "${PYBIN}/pip" install nanosimpy --no-index -f /io/wheelhouse
    #(cd "$HOME"; "${PYBIN}/nosetests" pymanylinuxdemo)
done