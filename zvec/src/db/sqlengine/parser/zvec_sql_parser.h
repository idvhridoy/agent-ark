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

#include "db/sqlengine/antlr/gen/SQLParser.h"
#include "select_info.h"
#include "zvec_parser.h"

namespace zvec::sqlengine {

class ZVecSQLParser : public ZVecParser {
 public:
  ZVecSQLParser() = default;

  SQLInfo::Ptr parse(const std::string &query,
                     bool need_formatted_tree = false) override;

  Node::Ptr parse_filter(const std::string &filter,
                         bool need_formatted_tree = false) override;

 private:
  SQLInfo::Ptr sql_info(VoidPtr tree);

  SQLInfo::SQLType sql_type(VoidPtr node);
  SelectInfo::Ptr select_info(VoidPtr node);

  Node::Ptr handle_logic_expr_node(VoidPtr node);
  Node::Ptr handle_rel_expr_node(VoidPtr node);
  Node::Ptr handle_rel_expr_left_node(VoidPtr node);
  Node::Ptr handle_value_expr_node(VoidPtr node);
  Node::Ptr handle_function_value_expr_node(VoidPtr node);
  Node::Ptr handle_in_value_expr_node(VoidPtr node);
  Node::Ptr handle_in_value_expr_list_node(VoidPtr node, bool exclude);
  Node::Ptr handle_id_node(VoidPtr node);
  Node::Ptr handle_const_node(VoidPtr node);
  Node::Ptr handle_const_num_and_str_node(VoidPtr node);
  Node::Ptr handle_bool_value_node(antlr4::SQLParser::Bool_valueContext *node);
  Node::Ptr handle_vector_expr_node(VoidPtr node);
  Node::Ptr handle_function_call_node(VoidPtr node);
};

}  // namespace zvec::sqlengine
