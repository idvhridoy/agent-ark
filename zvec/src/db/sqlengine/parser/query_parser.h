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

#include "sql_info.h"
#include "zvec_sql_parser.h"

namespace zvec::sqlengine {

class QueryParser {
 public:
  SQLInfo::Ptr parse(const std::string &query);

  const std::string &err_msg() {
    return err_msg_;
  }

 private:
  std::string err_msg_{""};
};

}  // namespace zvec::sqlengine
