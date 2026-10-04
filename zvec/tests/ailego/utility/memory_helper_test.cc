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

#include <iostream>
#include <ailego/utility/memory_helper.h>
#include <gtest/gtest.h>

using namespace zvec;

TEST(MemoryHelper, General) {
  size_t vsz, rss;
  EXPECT_TRUE(ailego::MemoryHelper::SelfUsage(&vsz, &rss));

  std::cout << "Page Size: " << ailego::MemoryHelper::PageSize() << std::endl;
  std::cout << "Usage: VSZ=" << vsz << ", RSS=" << rss << std::endl;
  std::cout << "RSS: " << ailego::MemoryHelper::SelfRSS() << std::endl;
  std::cout << "Peak RSS: " << ailego::MemoryHelper::SelfPeakRSS() << std::endl;
  std::cout << "Total RAM Size: " << ailego::MemoryHelper::TotalRamSize()
            << std::endl;
  std::cout << "Available RAM Size: "
            << ailego::MemoryHelper::AvailableRamSize() << std::endl;
  std::cout << "Used RAM Size: " << ailego::MemoryHelper::UsedRamSize()
            << std::endl;
  std::cout << "Total RAM Size in Container: "
            << ailego::MemoryHelper::ContainerAwareTotalRamSize() << std::endl;
}
