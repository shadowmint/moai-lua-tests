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

## Constants
set(PROJECT_NAME "LuaTest")

## Generated Constants
string(TOUPPER ${PROJECT_NAME} NS)
string(TOLOWER ${PROJECT_NAME} ns)

## Project definition
cmake_minimum_required(VERSION 2.8)
project(${NS})

## Load cmake definitions
file(GLOB_RECURSE PROJECT_INCLUDES "${PROJECT_SOURCE_DIR}/cmake/*.cmake")
foreach(PROJECT_INCLUDE ${PROJECT_INCLUDES})
  include(${PROJECT_INCLUDE})
endforeach(PROJECT_INCLUDE ${PROJECT_INCLUDES})

## Macros
function(add_source_path DIR) 
  file(GLOB_RECURSE FILES "${PROJECT_SOURCE_DIR}/${DIR}/*.lua")
  foreach(FILE ${FILES})
    string(REPLACE "${PROJECT_SOURCE_DIR}/${DIR}/" "" FILE_RELATIVE ${FILE})
    string(REGEX REPLACE "/[^/]+$" "" FILE_RELATIVE_PATH ${FILE_RELATIVE})
    set(FILE_ABSOLUTE "${PROJECT_BINARY_DIR}/${FILE_RELATIVE}")

    # If there was actually a directory for that, create it.
    if (NOT FILE_RELATIVE STREQUAL FILE_RELATIVE_PATH)
      set(FILE_ABSOLUTE_PATH "${PROJECT_BINARY_DIR}/${FILE_RELATIVE_PATH}")
      file(MAKE_DIRECTORY ${FILE_ABSOLUTE_PATH})
    endif()

    # Copy the file into the directory
    file(READ ${FILE} FP)
    file(WRITE ${FILE_ABSOLUTE} ${FP})
  endforeach()
endfunction()

add_source_path("src")
