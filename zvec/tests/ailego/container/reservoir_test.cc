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
#include <ailego/container/reservoir.h>
#include <gtest/gtest.h>

using namespace zvec;

TEST(Reservoir, General) {
  ailego::Reservoir<size_t> sampler(20);
  EXPECT_EQ(0u, sampler.pool().size());
  EXPECT_EQ(0u, sampler.total());
  EXPECT_EQ(20u, sampler.samples());

  for (size_t i = 0; i < sampler.samples(); ++i) {
    sampler.fill(i);
  }
  EXPECT_EQ(sampler.samples(), sampler.pool().size());
  EXPECT_EQ(sampler.samples(), sampler.total());

  for (size_t i = 0; i < sampler.pool().size(); ++i) {
    EXPECT_EQ(i, (sampler.pool())[i]);
  }

  for (size_t i = 0; i < 10000; ++i) {
    sampler.fill(i);
  }
  EXPECT_EQ(sampler.samples(), sampler.pool().size());
  EXPECT_EQ(10020u, sampler.total());

  for (auto it : sampler.pool()) {
    std::cout << it << ' ';
  }
  std::cout << std::endl;

  sampler.reset();
  EXPECT_EQ(0u, sampler.pool().size());
  EXPECT_EQ(0u, sampler.total());
  EXPECT_EQ(20u, sampler.samples());
}
