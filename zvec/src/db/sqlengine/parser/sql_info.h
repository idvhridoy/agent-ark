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
#include "base_info.h"

namespace zvec::sqlengine {

class SQLInfo {
 public:
  using Ptr = std::shared_ptr<SQLInfo>;

  enum class SQLType {
    NONE,
    INSERT,
    UPSERT,
    UPDATE,
    DELETE,
    CREATE,
    DROP,
    SELECT,
    SHOW_TABLES
  };
  static inline std::string type_to_str(SQLType c) {
    static std::string names[] = {"NONE",   "INSERT", "UPSERT",
                                  "UPDATE", "DELETE", "CREATE",
                                  "DROP",   "SELECT", "SHOW_TABLES"};
    return names[static_cast<int>(c)];
  }

 public:
  SQLInfo(SQLType type, BaseInfo::Ptr m_base_info);
  ~SQLInfo();

  SQLInfo(const SQLInfo &info);
  SQLInfo &operator=(const SQLInfo &info);

  void set_base_info(BaseInfo::Ptr value);
  void set_type(SQLType value);

  SQLType type() const;
  std::string type_name() const;
  const BaseInfo::Ptr &base_info() const;

  std::string to_string();

 private:
  SQLType type_{SQLType::NONE};
  BaseInfo::Ptr base_info_;
};

}  // namespace zvec::sqlengine
