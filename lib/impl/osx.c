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

#include <auto/tools.h>
#include <auto/impl.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <stdarg.h>
#include <signal.h>

/** Tracer */
void auto_trace(char *format, ...) {
  va_list args;
  va_start(args, format);
  vprintf(format, args);
  va_end(args);
}

/** Internal process struct */
struct auto_process {
  pid_t pid;
};

/** Change to a specific directory */
void auto_chdir(char *path) {
  chdir(path);
}

/** Remove the file given by path */
void auto_remove(char *path) {
  remove(path);
}

/** Sleep for a specified number of microseconds */
void auto_sleep(int usec) {
  usleep(usec * 1000);
}

/** Collect arguments */
char **auto_exec_args(char *command, va_list args) {

  char **argv;
  char *argn;
  int count; 

  count = 0;
  argv = (char **) malloc(sizeof (char *) * 2);
  while((argn = va_arg(args, char *)) != NULL) {
    ++count;
    argn = auto_strdup(argn);
    argv = realloc(argv, sizeof(char *) * (2 + count));
    argv[count] = argn;
  }

  argv[0] = auto_strdup(command);
  argv[count + 1] = NULL;

  return argv;
}

/** Execute a process and waits */
struct auto_process *auto_execv(char *command, char *argv[]) {

  struct auto_process *ph;
  pid_t pid; 

  pid = fork();
  if (pid == 0) {
    execv(command, argv); 
  }

  ph = (struct auto_process *) malloc(sizeof(struct auto_process));
  ph->pid = pid;

  return ph;
}

/** Execute a process and wait for a return code */
void auto_exec_wait(char *command, ... /*, NULL */) {

  char **argv;
  va_list args;
  struct auto_process *ph;
  int stat_loc;

  va_start(args, command);
  argv = auto_exec_args(command, args);
  va_end(args);

  ph = auto_execv(command, argv);
  waitpid(ph->pid, &stat_loc, 0);
}

/** Execute a process and return a process handle. */
void *auto_exec(char *command, ... /*, NULL */) {

  va_list args;
  struct auto_process *ph;
  char **argv;

  va_start(args, command);
  argv = auto_exec_args(command, args);
  va_end(args);

  ph = auto_execv(command, argv);
  return ph;
}

/** Terminate a process from a process handle */
void auto_kill(void *handle) {
  struct auto_process *ph = handle;
  kill(ph->pid, SIGKILL);
}
