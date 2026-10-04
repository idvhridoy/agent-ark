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

#include "db/index/segment/segment.h"
#include "db/sqlengine/analyzer/query_info.h"

namespace zvec::sqlengine {

class Optimizer {
 public:
  using Ptr = std::shared_ptr<Optimizer>;

  virtual bool optimize(Segment *segment, QueryInfo *query_info) = 0;
};

class InvertCondOptimizer : public Optimizer {
 public:
  explicit InvertCondOptimizer(CollectionSchema *collection_schema)
      : collection_schema_(collection_schema) {}

  virtual ~InvertCondOptimizer() = default;

 public:
  static Optimizer::Ptr CreateInvertCondOptimizer(
      CollectionSchema *collection_schema);

 public:
  bool optimize(Segment *segment, QueryInfo *query_info) override;

 protected:
  virtual bool invert_rule(Segment *segment, QueryRelNode *invert_cond);

 private:
  bool ratio_rule(Segment *segment, QueryRelNode *invert_cond);

  bool apply_optimize_result(QueryInfo *query_info, QueryNode *invert_subroot);

  void convert_invert_cond_to_forward(QueryInfo *query_info,
                                      QueryNode *invert_cond);

  void check_node_except_subroot(QueryNode *invert_cond,
                                 QueryNode *invert_subroot,
                                 bool *rest_has_invert);

 private:
  CollectionSchema *collection_schema_{nullptr};
};

}  // namespace zvec::sqlengine
