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
set(TEST_NAME "terminal")

# Config
set(TEST_TARGET "test.lua.in")
set(TEST_PROJECT_TARGET "test.lua")

# Load cmake definitions
file(GLOB_RECURSE PROJECT_INCLUDES "${PROJECT_SOURCE_DIR}/cmake/*.cmake")
foreach(PROJECT_INCLUDE ${PROJECT_INCLUDES})
  include(${PROJECT_INCLUDE})
endforeach(PROJECT_INCLUDE ${PROJECT_INCLUDES})

# Copy lua files into the build path
copy_source_files("${CMAKE_CURRENT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}/tests/${TEST_NAME}")

# Generate lua test file
set(TEST_PACKAGE_PATH "${PROJECT_BINARY_DIR}/tests/${TEST_NAME}")
set(TEST_PROJECT_TARGET "${TEST_PACKAGE_PATH}/${TEST_PROJECT_TARGET}")
set(TEST_SUCCESS_PATH "${TEST_PACKAGE_PATH}/${TEST_NAME}_success.txt")
set(TEST_DONE_PATH "${TEST_PACKAGE_PATH}/${TEST_NAME}_done.txt")
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/${TEST_TARGET}" "${TEST_PROJECT_TARGET}")

# Create application runner for this test application
set(TEST_SOURCE "${PROJECT_BINARY_DIR}/templates/${TEST_NAME}/runner.c")
file(MAKE_DIRECTORY "${PROJECT_BINARY_DIR}/templates/${TEST_NAME}")
configure_file("${PROJECT_TEST_TEMPLATE}" "${TEST_SOURCE}")
add_executable("test-${TEST_NAME}" "${TEST_SOURCE}")
target_link_libraries("test-${TEST_NAME}" ${AUTO_LIBRARIES})
include_directories(${AUTO_INCLUDE_DIR})

# This is a test
add_test(${TEST_NAME} "${CMAKE_CURRENT_BINARY_DIR}/test-${TEST_NAME}")
