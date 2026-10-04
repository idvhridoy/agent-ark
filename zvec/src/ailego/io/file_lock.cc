// Copyright 2025-present the zvec project
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "file_lock.h"

#if !defined(_WIN64) && !defined(_WIN32)
#include <sys/file.h>
#else
#include <Windows.h>
#endif

namespace zvec {
namespace ailego {

#if !defined(_WIN64) && !defined(_WIN32)
bool FileLock::Lock(int fd) {
  return (flock(fd, LOCK_EX) == 0);
}

bool FileLock::TryLock(int fd) {
  return (flock(fd, LOCK_EX | LOCK_NB) == 0);
}

bool FileLock::LockShared(int fd) {
  return (flock(fd, LOCK_SH) == 0);
}

bool FileLock::TryLockShared(int fd) {
  return (flock(fd, LOCK_SH | LOCK_NB) == 0);
}

bool FileLock::Unlock(int fd) {
  return (flock(fd, LOCK_UN) == 0);
}

#else
bool FileLock::Lock(HANDLE handle) {
  OVERLAPPED ol = {0};
  return (!!LockFileEx(handle, LOCKFILE_EXCLUSIVE_LOCK, 0, MAXDWORD, MAXDWORD,
                       &ol));
}

bool FileLock::TryLock(HANDLE handle) {
  OVERLAPPED ol = {0};
  return (!!LockFileEx(handle,
                       LOCKFILE_EXCLUSIVE_LOCK | LOCKFILE_FAIL_IMMEDIATELY, 0,
                       MAXDWORD, MAXDWORD, &ol));
}

bool FileLock::LockShared(HANDLE handle) {
  OVERLAPPED ol = {0};
  return (!!LockFileEx(handle, 0, 0, MAXDWORD, MAXDWORD, &ol));
}

bool FileLock::TryLockShared(HANDLE handle) {
  OVERLAPPED ol = {0};
  return (!!LockFileEx(handle, LOCKFILE_FAIL_IMMEDIATELY, 0, MAXDWORD, MAXDWORD,
                       &ol));
}

bool FileLock::Unlock(HANDLE handle) {
  OVERLAPPED ol = {0};
  return (!!UnlockFileEx(handle, 0, MAXDWORD, MAXDWORD, &ol));
}

#endif  // !_WIN64 && !_WIN32

}  // namespace ailego
}  // namespace zvec