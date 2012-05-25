/* 
 * Copyright 2011 Douglas Linder
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICEnsE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIOns OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <auto/tools.h>
#include <auto/impl.h>

#ifndef AUTO_
#define AUTO_

/** State variable for the absolute path to the moai binary */
#define AUTO_MOAI_BINARY 1

/** State variable for the project binary directory */
#define AUTO_PROJECT_BINARY_DIR 2

/** State variable for the project source directory */
#define AUTO_PROJECT_SOURCE_DIR 3

/** State variable for the absolute path to the cmake binary */
#define AUTO_CMAKE_BINARY 4

/** Initialize one of the global state variables */
void auto_init(int id, char *value);

/** 
 * Run a moai script
 * <p>
 * This just triggers the moai binary on the target and waits for it to exit.
 * This is run from inside the project binary directory.
 */
void auto_run_moai (char *path);

/** 
 * Update the binary directory from the source 
 * <p>
 * Calls cmake on the source dir to re-generate all the lua source files.
 * This is run from inside the project binary directory.
 */
void auto_rebuild(void);

/** 
 * Run a moai test script
 * <p>
 * Calls the moai binary on the test script and then polls periodically 
 * for the existence of the 'done_path' file. If the file is found,
 * the process is terminated and existence of the 'success_path' file
 * is checked to determine what return code to generate.
 * <p>
 * This is run from inside the project binary directory.
 * <p>
 * Before invoking moai, both the done and success path files are
 * deleted from the system.
 * <p>
 * This slightly obtuse way of dealing with moai is required to 
 * allow cross platform checking of test results; some hosts exit
 * on complete, some dont. The only general way of ensuring the
 * test is over is to kill the process.
 * <p>
 * The timeout value allows tests to be failed if they fail to
 * generate a "done_path" file within a valid time. To ignore this,
 * pass a -1 value in. The timeout is in microseconds.
 */
int auto_run_moai_test (char *path, char *done_path, char *success_path, int timeout);

#endif
