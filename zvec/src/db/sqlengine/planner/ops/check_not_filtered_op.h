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

#pragma once

#include <arrow/api.h>
#include <arrow/compute/api.h>
#include "db/index/common/index_filter.h"


namespace zvec::sqlengine {

namespace cp = arrow::compute;

class CheckNotFilteredOp {
 public:
  class CheckNotFilteredOptionsType
      : public arrow::compute::FunctionOptionsType {
   public:
    static const arrow::compute::FunctionOptionsType *GetInstance() {
      static std::unique_ptr<arrow::compute::FunctionOptionsType> instance(
          new CheckNotFilteredOptionsType());
      return instance.get();
    }

    const char *type_name() const override {
      return "CheckNotFiltered";
    }

    std::string Stringify(
        const arrow::compute::FunctionOptions & /*options*/) const override {
      return type_name();
    }

    bool Compare(const arrow::compute::FunctionOptions &options,
                 const arrow::compute::FunctionOptions &other) const override {
      const auto &lop = static_cast<const Options &>(options);
      const auto &rop = static_cast<const Options &>(other);
      return lop.args.filter == rop.args.filter;
    }

    std::unique_ptr<arrow::compute::FunctionOptions> Copy(
        const arrow::compute::FunctionOptions &options) const override {
      const auto &opts = static_cast<const Options &>(options);
      return std::make_unique<Options>(opts.args.filter);
    }
  };

  struct Args {
    IndexFilter::Ptr filter;
  };

  class Options : public cp::FunctionOptions {
   public:
    Options() : Options(nullptr) {}

    Options(IndexFilter::Ptr filter)
        : cp::FunctionOptions(CheckNotFilteredOptionsType::GetInstance()),
          args{std::move(filter)} {}

    static inline constexpr char const kTypeName[] =
        "CheckNotFilteredFunctionOptions";

    static Options Defaults() {
      return Options();
    }

    Args get_args() const {
      return args;
    }

    Args args;
  };

  struct CheckNotFilteredState : public arrow::compute::KernelState {
    Args args;

    explicit CheckNotFilteredState(const Options *o) {
      if (o) {
        args = o->get_args();
      }
    }
  };


  static arrow::Status CheckNotFilteredFunction(cp::KernelContext *ctx,
                                                const cp::ExecSpan &batch,
                                                cp::ExecResult *out);

  static inline const cp::FunctionDoc func_doc{
      "check if the segment row id is not filtered",
      "returns not_filtered(x)",
      {"segment_row_id"},
      "Options"};

  static arrow::Status register_op();

  static arrow::Result<std::unique_ptr<arrow::compute::KernelState>>
  InitExprValue(arrow::compute::KernelContext *,
                const arrow::compute::KernelInitArgs &args);
};

}  // namespace zvec::sqlengine