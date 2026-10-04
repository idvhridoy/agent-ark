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

#include "flat_sparse_context.h"

namespace zvec {
namespace core {

const FlatSparseEntity *FlatSparseContext::entity() const {
  if (context_type_ == kStreamerContext) {
    return &streamer_owner_->entity();
  } else if (context_type_ == kSearcherContext) {
    return &searcher_owner_->entity();
  }
  return nullptr;
}

}  // namespace core
}  // namespace zvec