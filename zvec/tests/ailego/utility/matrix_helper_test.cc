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

#include <random>
#include <ailego/utility/matrix_helper.h>
#include <gtest/gtest.h>

using namespace zvec;

TEST(MatrixHelper, Transpose) {
  std::mt19937 gen((std::random_device())());

  std::vector<float> result1(31 * 7);
  std::vector<float> result2(31 * 7);
  std::vector<float> result3(31 * 7);

  std::uniform_real_distribution<float> dist(0.0, 1.0);
  for (size_t i = 0; i < 31 * 7; ++i) {
    result1[i] = dist(gen);
  }

  ailego::MatrixHelper::Transpose<float, 31>(result1.data(), 7, result2.data());
  ailego::MatrixHelper::ReverseTranspose<float, 31>(result2.data(), 7,
                                                    result3.data());
  EXPECT_EQ(0, memcmp(result1.data(), result3.data(),
                      result1.size() * sizeof(float)));

  ailego::MatrixHelper::Transpose<float, 7>(result1.data(), 31, result2.data());
  ailego::MatrixHelper::ReverseTranspose<float, 7>(result2.data(), 31,
                                                   result3.data());
  EXPECT_EQ(0, memcmp(result1.data(), result3.data(),
                      result1.size() * sizeof(float)));

  ailego::MatrixHelper::Transpose<float>(result1.data(), 31, 7, result2.data());
  ailego::MatrixHelper::ReverseTranspose<float>(result2.data(), 31, 7,
                                                result3.data());
  EXPECT_EQ(0, memcmp(result1.data(), result3.data(),
                      result1.size() * sizeof(float)));

  ailego::MatrixHelper::Transpose<float>(result1.data(), 7, 31, result2.data());
  ailego::MatrixHelper::ReverseTranspose<float>(result2.data(), 7, 31,
                                                result3.data());
  EXPECT_EQ(0, memcmp(result1.data(), result3.data(),
                      result1.size() * sizeof(float)));
}
