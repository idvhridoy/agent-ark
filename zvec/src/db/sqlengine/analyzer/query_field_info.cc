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

#include "query_field_info.h"

namespace zvec::sqlengine {

std::string QueryFieldInfo::to_string() const {
  std::string str = "";
  if (is_func_call()) {
    if (is_func_param_asterisk()) {
      str += func_name_ + "(*)";
    } else {
      str += func_name_ + "(" + func_param_ + ")";
    }
  } else {
    str = field_name_;
    if (!alias_.empty()) {
      str += " as " + alias_;
    }
  }

  return str;
}

}  // namespace zvec::sqlengine
