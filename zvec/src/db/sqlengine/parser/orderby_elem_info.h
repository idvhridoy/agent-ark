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
#include "node.h"

namespace zvec::sqlengine {

class OrderByElemInfo {
 public:
  using Ptr = std::shared_ptr<OrderByElemInfo>;

  OrderByElemInfo() = default;

  const std::string &field_name() {
    return field_name_;
  }

  void set_field_name(const std::string &value) {
    field_name_ = value;
  }

  void set_desc() {
    desc_ = true;
  }

  bool is_desc() {
    return desc_;
  }

  std::string to_string() {
    std::string str = field_name_ + " " + (desc_ ? "DESC" : "ASC");
    return str;
  }

 private:
  std::string field_name_{""};
  bool desc_{false};
};

}  // namespace zvec::sqlengine
