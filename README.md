## Moai lua unit test template example.

### To run tests on osx 

    mkdir build
    cd build
    cmake ..
    make 
    make test


### To run tests on windows 

    mkdir build
    cd build
    cmake .. -G "MSYS Makefiles"
    make
    make test

...or if you have a copy of visual studio, just use the cmake-gui 
and then choose 'build' on the ALL_TESTS project.

### Notes

Running a cmake configuration copies all the lua source from the
source dir to the build directory; this is so that we can later appply
preprocessing directives to combine files, etc. 

Notice that the 'luatest' binary actually invokes cmake; there's no 
need to run cmake every time; just work on the code in the source dir
and run luatest to run it.

Running the tests, however, requires a proper compile run: make; make test.

This approach is suitable for CI integration and should run on both win
and osx build agents.
