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
#include "db/common/typedef.h"
#include "db/index/column/vector_column/vector_column_params.h"

namespace zvec {

class IndexResults {
 public:
  using Ptr = std::shared_ptr<IndexResults>;
  class Iterator {
   public:
    virtual ~Iterator() = default;

    virtual idx_t doc_id() const = 0;

    virtual float score() const = 0;

    virtual void next() = 0;

    virtual bool valid() const = 0;

    virtual const std::string &group_id() const {
      return kEmpty;
    }

    virtual const vector_column_params::VectorData vector() const {
      return vector_column_params::VectorData{};
    }

    bool is_sparse() const {
      return is_sparse_;
    }
    bool set_is_sparse(bool is_sparse) {
      is_sparse_ = is_sparse;
      return true;
    }

   private:
    bool is_sparse_{false};
    inline static const std::string kEmpty{""};
  };
  using IteratorUPtr = std::unique_ptr<IndexResults::Iterator>;

 public:
  virtual ~IndexResults() = default;

  virtual size_t count() const = 0;

  virtual IteratorUPtr create_iterator() = 0;
};


}  // namespace zvec
