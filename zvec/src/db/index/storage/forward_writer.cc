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

// forward_writer.cc
#include "forward_writer.h"
#include "arrow_ipc_writer.h"
#include "parquet_writer.h"

namespace zvec {

std::unique_ptr<ForwardWriter> ForwardWriter::CreateArrowIPCWriter(
    const std::string &filepath, int64_t max_rows_per_batch) {
  return std::make_unique<ArrowIpcWriter>(filepath, max_rows_per_batch);
}

std::unique_ptr<ForwardWriter> ForwardWriter::CreateParquetWriter(
    const std::string &filepath, int64_t max_rows_per_batch) {
  return std::make_unique<ParquetWriter>(filepath, max_rows_per_batch);
}

}  // namespace zvec