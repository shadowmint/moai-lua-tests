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
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

/** Duplicate a string */
char *auto_strdup(char *input) {
  char *rtn = (char *) malloc(sizeof(char) * (strlen(input) + 1));
  memmove(rtn, input, strlen(input));
  rtn[strlen(input)] = '\0';
  return rtn;
}
