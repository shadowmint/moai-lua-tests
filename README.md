## Moai lua unit test template example.

### To run tests on osx 

    mkdir build
    cd build
    cmake ..
    make 
    make test


### To run tests on windows using MSYS

    mkdir build
    cd build
    cmake .. -G "MSYS Makefiles"
    make
    make test

### To run tests on windows using visual studio

    create a sub directory called 'build'
    run the cmake-gui
    select source 'moai-lua-tests'
    select build 'moai-lua-tests/build'
    hit configure
    from the 'Build' section, untick 'BUILD_WARNINGS'
    hit generate
    open the solution file in VS
    view output
    build RUN_TESTS
    
This should also create a binary called "luatest.exe" in the build
directory. Invoking this will 1) regenerate the vs project and 2)
run the main.lua in src/

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
