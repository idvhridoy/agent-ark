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

#include <ailego/io/file_lock.h>
#include <gtest/gtest.h>

using namespace zvec::ailego;

TEST(FileLock, General) {
  File file;
  const char *path = "file_lock_test.dat";

  if (!File::IsExist(path)) {
    ASSERT_TRUE(file.create(path, 128));
  } else {
    ASSERT_TRUE(file.open(path, false));
  }

  FileLock file_lock(file);
  ASSERT_TRUE(file_lock.lock());
  ASSERT_TRUE(file_lock.unlock());

  ASSERT_TRUE(file_lock.try_lock_shared());
  ASSERT_TRUE(file_lock.unlock());

  ASSERT_TRUE(file_lock.lock_shared());
  ASSERT_TRUE(file_lock.unlock());

  ASSERT_TRUE(file_lock.try_lock());
  ASSERT_TRUE(file_lock.unlock());
  file.close();
}
