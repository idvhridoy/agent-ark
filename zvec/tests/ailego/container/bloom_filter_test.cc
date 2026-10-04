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
#include <ailego/container/bloom_filter.h>
#include <gtest/gtest.h>

using namespace zvec::ailego;

TEST(BloomFilterCalculator, General) {
  EXPECT_EQ(13487125u,
            BloomFilterCalculator::NumberOfItems(536454615, 5, 0.000023));
  EXPECT_EQ(295835133u,
            BloomFilterCalculator::NumberOfBytes(123456789, 0.0001));
  EXPECT_EQ(11924878998u,
            BloomFilterCalculator::NumberOfBits(536454615, 0.000023));
  EXPECT_FLOAT_EQ(0.00032803119f, (float)BloomFilterCalculator::Probability(
                                      400204, 7005007, 8));
  EXPECT_FLOAT_EQ(0.747645072f,
                  (float)BloomFilterCalculator::Probability(10000, 10000, 2));
  EXPECT_EQ(12u, BloomFilterCalculator::NumberOfHash(400204, 7005007));
  EXPECT_EQ(24120650u,
            BloomFilterCalculator::NumberOfBits(1000000, 5, 0.00023));

  double p = 0.000023;
  size_t n = 536454615;
  size_t m = BloomFilterCalculator::NumberOfBits(n, p);
  size_t k = BloomFilterCalculator::NumberOfHash(n, m);
  double p2 = BloomFilterCalculator::Probability(n, m, k);
  std::cout << "Probability: " << p << std::endl;
  std::cout << "Probability2: " << p2 << std::endl;
}

TEST(BloomFilter, General) {
  BloomFilter<5> filter(10000, 0.00023);
  EXPECT_TRUE(filter.insert(19009, 134, 1234, 54511, 43423));
  EXPECT_EQ(1u, filter.count());
  EXPECT_TRUE(filter.has(19009, 134, 1234, 54511, 43423));
  EXPECT_FALSE(filter.has(19009, 135, 1234, 54511, 43423));

  filter.force_insert(19009, 135, 1234, 54511, 43423);
  EXPECT_TRUE(filter.has(19009, 135, 1234, 54511, 43423));

  filter.clear();
  EXPECT_EQ(0u, filter.count());
  EXPECT_FALSE(filter.has(19009, 134, 1234, 54511, 43423));

  BloomFilter<0> filter0;
  (void)filter0;

  BloomFilter<6> filter6;
  EXPECT_FALSE(filter6.reset(0, 23.1));
  EXPECT_TRUE(filter6.reset(100000, 0.00023));
  std::cout << "bits_count: " << filter6.bits_count() << std::endl;
  std::cout << "capacity: " << filter6.capacity() << std::endl;
  std::cout << "count: " << filter6.count() << std::endl;
  std::cout << "probability: " << filter6.probability() << std::endl;
}
