# Copyright 2012 Douglas Linder
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 2.8)

# Project definition
set(PROJECT_NAME "LuaTest")
string(TOUPPER ${PROJECT_NAME} NS)
string(TOLOWER ${PROJECT_NAME} ns)
project(${NS})

set(CMAKE_BUILD_TYPE Debug)
option(BUILD_WARNINGS "Build warnings" ON)
if(BUILD_WARNINGS)
  set(CMAKE_C_FLAGS "-ansi -Wall -pedantic -Wimplicit-function-declaration -Wreturn-type -Wstrict-prototypes -Wextra")
endif(BUILD_WARNINGS)

# Constants
if(APPLE)
  set(MOAI_BINARY_PATH "${PROJECT_SOURCE_DIR}/bin/moai")
  set(AUTO_IMPL "${PROJECT_SOURCE_DIR}/lib/impl/osx.c")
else()
  set(MOAI_BINARY_PATH "${PROJECT_SOURCE_DIR}/bin/moai.exe")
  set(AUTO_IMPL "${PROJECT_SOURCE_DIR}/lib/impl/win.c")
endif()
set(PROJECT_TEST_TEMPLATE "${PROJECT_SOURCE_DIR}/cmake/test-runner.c.in")
set(PROJECT_RUNNER_TEMPLATE "${PROJECT_SOURCE_DIR}/cmake/runner.c.in")
set(PROJECT_CONFIG_PATH "${PROJECT_SOURCE_DIR}/data/config.json")

# Load cmake definitions
file(GLOB_RECURSE PROJECT_INCLUDES "${PROJECT_SOURCE_DIR}/cmake/*.cmake")
foreach(PROJECT_INCLUDE ${PROJECT_INCLUDES})
  include(${PROJECT_INCLUDE})
endforeach(PROJECT_INCLUDE ${PROJECT_INCLUDES})

# Copy lua files into the build path
copy_source_files("${PROJECT_SOURCE_DIR}/src" "${PROJECT_BINARY_DIR}")

# Copy assets into the build path
file(COPY "assets" DESTINATION "${PROJECT_BINARY_DIR}")

# Setup auto lib
file(GLOB AUTO_SOURCES "${PROJECT_SOURCE_DIR}/lib/*.c")
set(AUTO_SOURCES ${AUTO_SOURCES} ${AUTO_IMPL})
add_library(auto ${AUTO_SOURCES})
set(AUTO_LIBRARIES "auto")
set(AUTO_INCLUDE_DIR "${PROJECT_SOURCE_DIR}/lib")

# Create application runner for the 'main' application
set(PROJECT_TARGET "main.lua")
file(MAKE_DIRECTORY "${PROJECT_BINARY_DIR}/templates")
configure_file("${PROJECT_RUNNER_TEMPLATE}" "${PROJECT_BINARY_DIR}/templates/runner.c")
add_executable(${ns} "${PROJECT_BINARY_DIR}/templates/runner.c")
target_link_libraries(${ns} ${AUTO_LIBRARIES})
include_directories(${AUTO_INCLUDE_DIR})

# Find tests
file(GLOB_RECURSE TESTS tests/CMakeLists*)

# Optional: build tests
option(BUILD_TESTS "Build tests" ON)
if(BUILD_TESTS)
  if(TESTS)
    enable_testing()
    foreach(TEST ${TESTS})
      string(REGEX REPLACE "CMakeLists.txt" "" TEST_DIR ${TEST})
      add_subdirectory(${TEST_DIR})
    endforeach(TEST)
  endif(TESTS)
endif(BUILD_TESTS)
