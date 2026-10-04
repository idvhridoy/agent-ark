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
#pragma once

#include <memory>
#include <string>
#include <arrow/api.h>
#include "db/index/common/index_filter.h"

namespace zvec {

class ForwardWriter {
 public:
  virtual ~ForwardWriter() = default;

  // Factory methods
  static std::unique_ptr<ForwardWriter> CreateArrowIPCWriter(
      const std::string &filepath, int64_t max_rows_per_batch = 0);

  static std::unique_ptr<ForwardWriter> CreateParquetWriter(
      const std::string &filepath, int64_t max_rows_per_batch = 0);

  // Interface methods
  virtual arrow::Status insert(std::shared_ptr<arrow::RecordBatchReader> reader,
                               const IndexFilter::Ptr &filter = nullptr) = 0;

  virtual arrow::Status insert_batch(
      std::shared_ptr<arrow::RecordBatch> batch,
      const IndexFilter::Ptr &filter = nullptr) = 0;

  virtual arrow::Status finalize() = 0;
};

}  // namespace zvec