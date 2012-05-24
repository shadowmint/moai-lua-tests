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

#ifndef AUTO_IMPL
#define AUTO_IMPL

/** Print a log message */
void auto_trace(char *format, ...);

/** Change to a specific directory */
void auto_chdir(char *path);

/** Remove the file given by path */
void auto_remove(char *path);

/** Sleep for a specified number of microseconds */
void auto_sleep(int usec);

/** 
 * Execute a process and wait for it to finish.
 * <p>
 * Pass NULL to terminal the argument set.
 */
void auto_exec_wait(char *command, ... /*, NULL */);

/** 
 * Execute a process and return a process handle.
 * <p>
 * Pass NULL to terminal the argument set.
 */
void *auto_exec(char *command, ... /*, NULL */);

/** Terminate a process from a process handle */
void auto_kill(void *handle);

#endif
