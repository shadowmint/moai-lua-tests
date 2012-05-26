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

## Copy a single source file to a single target file. 
function(copy_file DIR DEST TARGET COPY) 
  string(REPLACE "${DIR}/" "" FILE_RELATIVE ${TARGET})
  string(REGEX REPLACE ".in$" "" FILE_RELATIVE ${FILE_RELATIVE})
  string(REGEX REPLACE "/[^/]+$" "" FILE_RELATIVE_PATH ${FILE_RELATIVE})
  set(FILE_ABSOLUTE "${DEST}/${FILE_RELATIVE}")

  # If there was actually a directory for that, create it.
  if (NOT FILE_RELATIVE STREQUAL FILE_RELATIVE_PATH)
    set(FILE_ABSOLUTE_PATH "${DEST}/${FILE_RELATIVE_PATH}")
    file(MAKE_DIRECTORY ${FILE_ABSOLUTE_PATH})
  endif()

  # Copy the file into the directory
  if (${COPY}) 
    configure_file(${TARGET} ${FILE_ABSOLUTE} COPYONLY)
  else()
    configure_file(${TARGET} ${FILE_ABSOLUTE})
  endif()
endfunction()

## Copy all source files into the build directory
# @param DIR The directory to search for source files in.
# @param DEST The base directory to copy files to.
function(copy_source_files DIR DEST) 
  file(GLOB_RECURSE FILES "${DIR}/*.lua")
  foreach(FILE ${FILES})
    copy_file(${DIR} ${DEST} ${FILE} 1)
  endforeach()
  file(GLOB_RECURSE FILES "${DIR}/*.lua.in")
  foreach(FILE ${FILES})
    copy_file(${DIR} ${DEST} ${FILE} 0)
  endforeach()
endfunction()
