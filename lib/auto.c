/* 
 * Copyright 2012 Douglas Linder
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

#include <stdio.h>
#include <auto/auto.h>
#include <auto/impl.h>
#include <auto/tools.h>

/** Global consts */
char *_AUTO_MOAI_BINARY = NULL;
char *_AUTO_CMAKE_BINARY = NULL;
char *_AUTO_PROJECT_BINARY_DIR = NULL;
char *_AUTO_PROJECT_SOURCE_DIR = NULL;
int _AUTO_POLL_PERIOD = 100; 

/** Initialize one of the global state variables */
void auto_init(int id, char *value) {
  switch(id) {
    case AUTO_CMAKE_BINARY:
      _AUTO_CMAKE_BINARY = auto_strdup(value);
      break;

    case AUTO_MOAI_BINARY:
      _AUTO_MOAI_BINARY = auto_strdup(value);
      break;

    case AUTO_PROJECT_BINARY_DIR:
      _AUTO_PROJECT_BINARY_DIR = auto_strdup(value);
      break;

    case AUTO_PROJECT_SOURCE_DIR:
      _AUTO_PROJECT_SOURCE_DIR = auto_strdup(value);
      break;

    default:
      auto_trace("Invalid init id: %d -> %s", id, value);
  }
}

/** Run a moai script */
void auto_run_moai (char *path) {
  auto_trace("\nExecuting moai binary...\n");

  auto_trace("chdir %s\n", _AUTO_PROJECT_BINARY_DIR);
  auto_chdir(_AUTO_PROJECT_BINARY_DIR);

  auto_trace("%s %s\n", _AUTO_MOAI_BINARY, path);
  auto_exec_wait(_AUTO_MOAI_BINARY, path, NULL);
}

/** Update the binary directory from the source */
void auto_rebuild(void) {
  auto_trace("\nRebuilding configuration...\n");
  
  auto_trace("chdir %s\n", _AUTO_PROJECT_BINARY_DIR);
  auto_chdir(_AUTO_PROJECT_BINARY_DIR);

  auto_trace("%s %s\n", _AUTO_CMAKE_BINARY, _AUTO_PROJECT_SOURCE_DIR);
  auto_exec(_AUTO_CMAKE_BINARY, _AUTO_PROJECT_SOURCE_DIR, NULL);
}

/** Run a moai test script */
int auto_run_moai_test (char *path, char *done_path, char *success_path, int timeout) {

  FILE *fp;
  void *handle;
  int elapsed = 0;
  int success = 0;

  auto_trace("\nRunning test...\n");

  auto_trace("chdir %s\n", _AUTO_PROJECT_BINARY_DIR);
  auto_chdir(_AUTO_PROJECT_BINARY_DIR);

  auto_trace("remove %s\n", done_path);
  auto_remove(done_path);

  auto_trace("remove %s\n", success_path);
  auto_remove(success_path);

  auto_trace("%s %s\n", _AUTO_MOAI_BINARY, path);
  handle = auto_exec(_AUTO_MOAI_BINARY, path, NULL);

  while((elapsed < timeout) || (timeout == -1)) {
    auto_sleep(_AUTO_POLL_PERIOD);
    elapsed += _AUTO_POLL_PERIOD;
    fp = fopen(done_path, "r");
    if (fp != NULL) {
      fclose(fp);
      break;
    }
  }

  fp = fopen(success_path, "r");
  if (fp != NULL) {
    success = 1;
    fclose(fp);
  }

  auto_trace("\nKilling moai to complete test run.\n");
  auto_kill(handle);

  return success;
}
