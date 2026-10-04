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

#include "dl_helper.h"
#if !defined(_WIN64) && !defined(_WIN32)
#include <dlfcn.h>
#else
#include <Windows.h>
#endif

namespace zvec {
namespace ailego {

#if !defined(_WIN64) && !defined(_WIN32)
void *DLHelper::Load(const char *path, std::string *err) {
  void *handle = dlopen(path, RTLD_NOW);
  if (!handle && err) {
    *err = dlerror();
  }
  return handle;
}

void DLHelper::Unload(void *handle) {
  ailego_return_if_false(handle);
  dlclose(handle);
}

void *DLHelper::Symbol(void *handle, const char *symbol) {
  ailego_null_if_false(handle && symbol);
  return dlsym(handle, symbol);
}

#else
void *DLHelper::Load(const char *path, std::string *err) {
  HMODULE handle = LoadLibraryA(path);
  if (!handle && err) {
    DWORD error_code = GetLastError();
    LPSTR error_msg = nullptr;

    DWORD len = FormatMessageA(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM |
            FORMAT_MESSAGE_IGNORE_INSERTS,
        nullptr, error_code, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
        (LPSTR)&error_msg, 0, nullptr);
    err->assign(error_msg, len);
    LocalFree(error_msg);
  }
  return handle;
}

void DLHelper::Unload(void *handle) {
  ailego_return_if_false(handle);
  FreeLibrary((HMODULE)handle);
}

void *DLHelper::Symbol(void *handle, const char *symbol) {
  ailego_null_if_false(handle && symbol);
  return GetProcAddress((HMODULE)handle, symbol);
}
#endif  // !_WIN64 && !_WIN32

}  // namespace ailego
}  // namespace zvec