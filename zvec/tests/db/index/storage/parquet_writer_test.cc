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

#include "db/index/storage/parquet_writer.h"
#include <iostream>
#include <arrow/array/builder_primitive.h>
#include <arrow/record_batch.h>
#include <arrow/status.h>
#include <gtest/gtest.h>

using namespace zvec;

std::shared_ptr<arrow::RecordBatchReader> CreateTestReader(int start_id,
                                                           int count) {
  auto schema = arrow::schema({arrow::field("id", arrow::int32()),
                               arrow::field("name", arrow::utf8())});

  arrow::Int32Builder id_builder;
  arrow::StringBuilder name_builder;

  arrow::Status s;

  for (int i = 0; i < count; ++i) {
    s = id_builder.Append(start_id + i);
    if (!s.ok()) {
      return nullptr;
    }
    s = name_builder.Append("User" + std::to_string(start_id + i));
    if (!s.ok()) {
      return nullptr;
    }
  }

  std::shared_ptr<arrow::Array> id_array, name_array;
  s = id_builder.Finish(&id_array);
  if (!s.ok()) {
    return nullptr;
  }
  s = name_builder.Finish(&name_array);
  if (!s.ok()) {
    return nullptr;
  }

  auto batch = arrow::RecordBatch::Make(schema, count, {id_array, name_array});
  auto maybe_reader = arrow::RecordBatchReader::Make({batch}, schema);
  if (!maybe_reader.ok()) {
    return nullptr;
  }
  return *maybe_reader;
}

TEST(ParquetWriter, General) {
  ParquetWriter writer("output.parquet");
  // writer.SetMaxRowsPerGroup(1000); // 可选：控制每组行数

  // 第一次插入
  {
    auto reader1 = CreateTestReader(1, 3);
    ASSERT_NE(reader1, nullptr);
    auto status = writer.insert(reader1);
    ASSERT_TRUE(status.ok());
    std::cout << "Inserted batch 1" << std::endl;
  }

  // 第二次插入
  {
    auto reader2 = CreateTestReader(4, 2);
    ASSERT_NE(reader2, nullptr);
    auto status = writer.insert(reader2);
    ASSERT_TRUE(status.ok());
    std::cout << "Inserted batch 2" << std::endl;
  }

  // 第三次插入
  {
    auto reader3 = CreateTestReader(6, 4);
    ASSERT_NE(reader3, nullptr);
    auto status = writer.insert(reader3);
    ASSERT_TRUE(status.ok());
    std::cout << "Inserted batch 3" << std::endl;
  }

  // 最后关闭文件
  auto status = writer.finalize();
  if (!status.ok()) {
    std::cerr << "Finalize failed: " << status.ToString() << std::endl;
  }

  std::cout << "Parquet file written successfully to output.parquet"
            << std::endl;
}
