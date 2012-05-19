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

# Unique name for this test
set(TEST_NAME "template")

# Load cmake definitions
file(GLOB_RECURSE PROJECT_INCLUDES "${PROJECT_SOURCE_DIR}/cmake/*.cmake")
foreach(PROJECT_INCLUDE ${PROJECT_INCLUDES})
  include(${PROJECT_INCLUDE})
endforeach(PROJECT_INCLUDE ${PROJECT_INCLUDES})

# Copy lua files into the build path
copy_source_files("${CMAKE_CURRENT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}/tests/${TEST_NAME}")

# Create application runner for this test application
set(TEST_PROJECT_TARGET "${PROJECT_BINARY_DIR}/tests/${TEST_NAME}/test.lua")
file(MAKE_DIRECTORY "${PROJECT_BINARY_DIR}/templates/${TEST_NAME}")
configure_file("${PROJECT_SOURCE_DIR}/cmake/test-runner.c.in" "${PROJECT_BINARY_DIR}/templates/${TEST_NAME}/runner.c")
add_executable("test-${TEST_NAME}" "${PROJECT_BINARY_DIR}/templates/${TEST_NAME}/runner.c")

# This is a test
add_test(${TEST_NAME} "${CMAKE_CURRENT_BINARY_DIR}/test-${TEST_NAME}")
