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

This COPIES the lua sources into the build directory. This is not 
ideal, as it means you have to run cmake every time you want to 
run your test suite.
