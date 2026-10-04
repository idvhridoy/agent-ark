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

class SelectedElemInfo {
 public:
  using Ptr = std::shared_ptr<SelectedElemInfo>;

  void set_asterisk(const bool value) {
    asterisk_ = value;
  }

  bool is_asterisk() const {
    return asterisk_;
  }

  void set_empty(const bool value) {
    empty_ = value;
  }

  bool is_empty() const {
    return empty_;
  }

  void set_field_name(const std::string &value) {
    field_name_ = value;
  }

  const std::string &field_name() const {
    return field_name_;
  }

  void set_alias(const std::string &value) {
    alias_ = value;
  }

  const std::string &alias() const {
    return alias_;
  }

  const std::string &func_name() const {
    return func_name_;
  }

  void set_func_name(const std::string &value) {
    func_name_ = value;
    if (!value.empty()) {
      func_call_ = true;
    }
  }

  const std::string &func_param() const {
    return func_param_;
  }

  void set_func_param(const std::string &value) {
    func_param_ = value;
  }

  bool is_func_call() const {
    return func_call_;
  }

  void set_func_param_asterisk(bool value) {
    func_param_asterisk_ = value;
  }
  bool is_func_param_asterisk() const {
    return func_param_asterisk_;
  }

  std::string to_string() const;

 private:
  bool asterisk_{false};
  bool empty_{false};

  std::string field_name_{""};
  std::string alias_{""};

  std::string func_name_{""};
  bool func_call_{false};
  std::string func_param_{""};
  bool func_param_asterisk_{false};
};

}  // namespace zvec::sqlengine
