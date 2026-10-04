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
// limitations under the License

#include "db/sqlengine/planner/ops/check_not_filtered_op.h"
#include <arrow/type_fwd.h>
#include "db/sqlengine/common/util.h"

namespace zvec::sqlengine {

arrow::Status CheckNotFilteredOp::CheckNotFilteredFunction(
    cp::KernelContext *ctx, const cp::ExecSpan &batch, cp::ExecResult *out) {
  CheckNotFilteredState *state =
      static_cast<CheckNotFilteredState *>(ctx->state());
  auto *filter = state->args.filter.get();
  if (filter == nullptr) {
    return arrow::Status::ExecutionError("filter is null");
  }

  auto row_span = batch[0].array.GetSpan<uint64_t>(1, batch.length);
  std::shared_ptr<arrow::BooleanBuilder> builder =
      std::make_shared<arrow::BooleanBuilder>(ctx->memory_pool());
  ARROW_RETURN_NOT_OK(builder->Reserve(batch.length));
  for (int i = 0; i < batch.length; i++) {
    builder->UnsafeAppend(!filter->is_filtered(row_span[i]));
  }
  std::shared_ptr<arrow::Array> result_array;
  ARROW_RETURN_NOT_OK(builder->Finish(&result_array));

  out->value = std::move(result_array->data());
  return arrow::Status::OK();
}

arrow::Result<std::unique_ptr<arrow::compute::KernelState>>
CheckNotFilteredOp::InitExprValue(arrow::compute::KernelContext *,
                                  const arrow::compute::KernelInitArgs &args) {
  auto func_options =
      static_cast<const CheckNotFilteredOp::Options *>(args.options);
  return std::make_unique<CheckNotFilteredOp::CheckNotFilteredState>(
      func_options ? func_options : nullptr);
}


arrow::Status CheckNotFilteredOp::register_op() {
  static Options options = Options::Defaults();
  auto func = std::make_shared<cp::ScalarFunction>(
      kCheckNotFiltered, cp::Arity::Unary(), func_doc, &options, false);
  cp::ScalarKernel kernel({arrow::uint64()}, arrow::boolean(),
                          CheckNotFilteredFunction, InitExprValue);

  kernel.mem_allocation = cp::MemAllocation::NO_PREALLOCATE;
  kernel.null_handling = cp::NullHandling::COMPUTED_NO_PREALLOCATE;

  ARROW_RETURN_NOT_OK(func->AddKernel(std::move(kernel)));

  auto registry = cp::GetFunctionRegistry();
  ARROW_RETURN_NOT_OK(registry->AddFunction(std::move(func)));

  return arrow::Status::OK();
}

}  // namespace zvec::sqlengine