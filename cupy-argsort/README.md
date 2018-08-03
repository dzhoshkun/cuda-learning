## Running

`python do-cupy-argsort.py`

## Results

Using version `da8a8e43b91ffcc98e3747922446554e4e70ca36` we get:

```
[0] % python do-cupy-argsort.py
         228 function calls in 0.183 seconds

   Ordered by: internal time

   ncalls  tottime  percall  cumtime  percall filename:lineno(function)
        1    0.095    0.095    0.095    0.095 {cupy.cuda.nvrtc.compileProgram}
        1    0.078    0.078    0.078    0.078 {method 'argsort' of 'numpy.ndarray' objects}
        1    0.009    0.009    0.105    0.105 {method 'argsort' of 'cupy.core.core.ndarray' objects}
        1    0.000    0.000    0.096    0.096 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:120(compile_with_cache)
        1    0.000    0.000    0.000    0.000 {method 'load' of 'cupy.cuda.function.Module' objects}
        2    0.000    0.000    0.000    0.000 {_hashlib.openssl_md5}
        1    0.000    0.000    0.000    0.000 {method 'encode' of 'unicode' objects}
        5    0.000    0.000    0.000    0.000 {posix.stat}
       30    0.000    0.000    0.000    0.000 /usr/lib/python2.7/posixpath.py:61(join)
        1    0.000    0.000    0.000    0.000 {method 'sub' of '_sre.SRE_Pattern' objects}
        3    0.000    0.000    0.000    0.000 /usr/lib/python2.7/posixpath.py:329(normpath)
        1    0.000    0.000    0.000    0.000 {cupy.cuda.nvrtc.createProgram}
        1    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/cupy/cuda/__init__.py:53(get_cuda_path)
        1    0.000    0.000    0.078    0.078 /usr/local/lib/python2.7/dist-packages/numpy/core/fromnumeric.py:55(_wrapfunc)
        1    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:27(_get_arch)
        1    0.000    0.000    0.095    0.095 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:239(compile)
        1    0.000    0.000    0.000    0.000 {open}
        1    0.000    0.000    0.095    0.095 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:93(_preprocess)
        1    0.000    0.000    0.000    0.000 {method 'read' of 'file' objects}
        4    0.000    0.000    0.000    0.000 /usr/lib/python2.7/genericpath.py:23(exists)
        1    0.000    0.000    0.105    0.105 /usr/local/lib/python2.7/dist-packages/cupy/sorting/sort.py:84(argsort)
       38    0.000    0.000    0.000    0.000 {method 'startswith' of 'str' objects}
        1    0.000    0.000    0.000    0.000 /usr/lib/python2.7/string.py:148(substitute)
        2    0.000    0.000    0.000    0.000 /usr/lib/python2.7/posixpath.py:120(dirname)
        2    0.000    0.000    0.000    0.000 {method 'decode' of 'str' objects}
        1    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:222(__init__)
        1    0.000    0.000    0.000    0.000 {cupy.cuda.nvrtc.getPTX}
        3    0.000    0.000    0.000    0.000 /usr/lib/python2.7/UserDict.py:91(get)
        6    0.000    0.000    0.000    0.000 /usr/lib/python2.7/string.py:162(convert)
        4    0.000    0.000    0.000    0.000 {method 'split' of 'str' objects}
        1    0.000    0.000    0.078    0.078 /usr/local/lib/python2.7/dist-packages/numpy/core/fromnumeric.py:826(argsort)
        6    0.000    0.000    0.000    0.000 {isinstance}
        1    0.000    0.000    0.000    0.000 /usr/lib/python2.7/genericpath.py:46(isdir)
       12    0.000    0.000    0.000    0.000 {method 'group' of '_sre.SRE_Match' objects}
        2    0.000    0.000    0.000    0.000 {method 'rfind' of 'str' objects}
       30    0.000    0.000    0.000    0.000 {method 'endswith' of 'str' objects}
        1    0.000    0.000    0.000    0.000 {getattr}
        2    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:19(_get_nvrtc_version)
        2    0.000    0.000    0.000    0.000 {_codecs.utf_8_decode}
        2    0.000    0.000    0.000    0.000 /usr/lib/python2.7/posixpath.py:358(abspath)
        1    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:235(__del__)
        3    0.000    0.000    0.000    0.000 /usr/lib/python2.7/UserDict.py:103(__contains__)
        2    0.000    0.000    0.000    0.000 {method 'hexdigest' of '_hashlib.HASH' objects}
        1    0.000    0.000    0.000    0.000 /usr/lib/python2.7/stat.py:40(S_ISDIR)
        2    0.000    0.000    0.000    0.000 /usr/lib/python2.7/os.py:512(getenv)
        1    0.000    0.000    0.000    0.000 {method 'get' of 'dict' objects}
        1    0.000    0.000    0.000    0.000 /usr/lib/python2.7/stat.py:24(S_IFMT)
        1    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/six.py:648(b)
        1    0.000    0.000    0.000    0.000 {min}
        2    0.000    0.000    0.000    0.000 /usr/lib/python2.7/encodings/utf_8.py:15(decode)
        2    0.000    0.000    0.000    0.000 {method 'rstrip' of 'str' objects}
        4    0.000    0.000    0.000    0.000 {len}
        1    0.000    0.000    0.000    0.000 /usr/local/lib/python2.7/dist-packages/cupy/cuda/compiler.py:113(get_cache_dir)
        1    0.000    0.000    0.000    0.000 {cupy.cuda.nvrtc.destroyProgram}
        1    0.000    0.000    0.000    0.000 /usr/lib/python2.7/UserDict.py:35(__getitem__)
        1    0.000    0.000    0.000    0.000 /usr/lib/python2.7/string.py:131(__init__)
       17    0.000    0.000    0.000    0.000 {method 'append' of 'list' objects}
        1    0.000    0.000    0.000    0.000 {method 'pop' of 'list' objects}
        1    0.000    0.000    0.000    0.000 {cupy.cuda.nvrtc.getVersion}
        3    0.000    0.000    0.000    0.000 {method 'join' of 'str' objects}
        1    0.000    0.000    0.000    0.000 {method 'format' of 'str' objects}
        2    0.000    0.000    0.000    0.000 /usr/lib/python2.7/posixpath.py:52(isabs)
        1    0.000    0.000    0.000    0.000 {method 'disable' of '_lsprof.Profiler' objects}
```

