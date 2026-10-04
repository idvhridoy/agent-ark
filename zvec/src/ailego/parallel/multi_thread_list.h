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

#include <atomic>
#include <condition_variable>
#include <deque>
#include <mutex>

namespace zvec {
namespace ailego {

/*! Multi-Thread list
 */
template <typename T>
class MultiThreadList {
 public:
  MultiThreadList(size_t size_limit = 1000) : size_limit_(size_limit) {}
  bool produce(const T &item) {
    std::unique_lock<std::mutex> lk(lock_);
    not_full_.wait(
        lk, [&]() { return (list_.size() < size_limit_) || done_.load(); });
    if (done_.load()) {
      return false;
    }
    list_.emplace_back(item);
    not_empty_.notify_one();
    return true;
  }

  bool produce(T &&item) {
    std::unique_lock<std::mutex> lk(lock_);
    not_full_.wait(
        lk, [&]() { return (list_.size() < size_limit_) || done_.load(); });
    if (done_.load()) {
      return false;
    }
    list_.emplace_back(std::move(item));
    not_empty_.notify_one();
    return true;
  }

  bool consume(T *item) {
    std::unique_lock<std::mutex> lk(lock_);
    not_empty_.wait(lk, [&]() {
      return !list_.empty() || done_.load() || consume_stopped_.load();
    });
    if ((list_.empty() && done_.load()) || consume_stopped_.load()) {
      return false;
    }
    *item = std::move(list_.front());
    list_.pop_front();
    not_full_.notify_one();
    return true;
  }

  void done() {
    std::unique_lock<std::mutex> lk(lock_);
    done_.store(true);
    not_empty_.notify_all();
    not_full_.notify_all();
  }

  void reset() {
    done_.store(false);
    list_.clear();
  }

  void stop_consume() {
    std::unique_lock<std::mutex> lk(lock_);
    consume_stopped_.store(true);
    not_empty_.notify_all();
  }

  void resume_consume() {
    consume_stopped_.store(false);
  }

 private:
  std::deque<T> list_;
  size_t size_limit_{0};
  std::mutex lock_;
  std::condition_variable not_empty_, not_full_;

  std::atomic<bool> done_{false};
  std::atomic<bool> consume_stopped_{false};
};

}  // namespace ailego
}  // namespace zvec
