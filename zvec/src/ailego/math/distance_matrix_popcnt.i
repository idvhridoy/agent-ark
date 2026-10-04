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

#include "distance_matrix_int32.i"
#include "distance_matrix_int64.i"
#include "matrix_utility.i"

//! Calculate population count (UINT32 Permute 1 SSE)
#define POPCNT_UINT32_PERMUTE1_SSE(v, ...) \
  _mm_add_epi16(_mm_srli_epi16(v, 8), _mm_and_si128(v, _mm_set1_epi16(0xff)))

//! Calculate population count (UINT32 Permute 2 SSE)
#define POPCNT_UINT32_PERMUTE2_SSE(v, ...) \
  _mm_add_epi32(_mm_srli_epi32(v, 16), _mm_and_si128(v, _mm_set1_epi32(0xffff)))

//! Calculate population count (UINT32 Permute 1 AVX)
#define POPCNT_UINT32_PERMUTE1_AVX(v, ...)  \
  _mm256_add_epi16(_mm256_srli_epi16(v, 8), \
                   _mm256_and_si256(v, _mm256_set1_epi16(0xff)))

//! Calculate population count (UINT32 Permute 2 AVX)
#define POPCNT_UINT32_PERMUTE2_AVX(v, ...)   \
  _mm256_add_epi32(_mm256_srli_epi32(v, 16), \
                   _mm256_and_si256(v, _mm256_set1_epi32(0xffff)))

//! Calculate population count (UINT64 Permute AVX)
#define POPCNT_UINT64_PERMUTE_AVX(v, ...) \
  _mm256_sad_epu8(v, _mm256_setzero_si256())

//! Compute the distance between matrix and query (UINT32, M=2, N=1)
#define POPCNT_UINT32_2X1_SSE(m, q, cnt, out, _NORM)                         \
  MATRIX_VAR_INIT(1, 2, __m128i, xmm_sum, _mm_setzero_si128())               \
  const uint32_t *qe_0 = q + ((cnt >> 2) << 2);                              \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 2) << 2) : qe_0);           \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 2) << 2) : qe_0);       \
  const uint32_t *qe_3 = q + cnt;                                            \
  if (((uintptr_t)m & 0xf) == 0 && ((uintptr_t)q & 0xf) == 0) {              \
    for (; q != qe_1; m += 8, q += 4) {                                      \
      MATRIX_INT32_ITER_2X1_SSE(m, q, xmm_sum, _mm_load_si128,               \
                                POPCNT_UINT32_STEP1_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE)            \
    for (; q != qe_2; m += 8, q += 4) {                                      \
      MATRIX_INT32_ITER_2X1_SSE(m, q, xmm_sum, _mm_load_si128,               \
                                POPCNT_UINT32_STEP2_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE)            \
    for (; q != qe_0; m += 8, q += 4) {                                      \
      MATRIX_INT32_ITER_2X1_SSE(m, q, xmm_sum, _mm_load_si128,               \
                                POPCNT_UINT32_STEP3_SSE)                     \
    }                                                                        \
    if (qe_3 >= qe_0 + 2) {                                                  \
      __m128i xmm_m = _mm_load_si128((const __m128i *)(m));                  \
      __m128i xmm_q = _mm_set_epi32(q[1], q[1], q[0], q[0]);                 \
      POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                     \
      m += 4;                                                                \
      q += 2;                                                                \
    }                                                                        \
  } else {                                                                   \
    for (; q != qe_1; m += 8, q += 4) {                                      \
      MATRIX_INT32_ITER_2X1_SSE(m, q, xmm_sum, _mm_loadu_si128,              \
                                POPCNT_UINT32_STEP1_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE)            \
    for (; q != qe_2; m += 8, q += 4) {                                      \
      MATRIX_INT32_ITER_2X1_SSE(m, q, xmm_sum, _mm_loadu_si128,              \
                                POPCNT_UINT32_STEP2_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE)            \
    for (; q != qe_0; m += 8, q += 4) {                                      \
      MATRIX_INT32_ITER_2X1_SSE(m, q, xmm_sum, _mm_loadu_si128,              \
                                POPCNT_UINT32_STEP3_SSE)                     \
    }                                                                        \
    if (qe_3 >= qe_0 + 2) {                                                  \
      __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));                 \
      __m128i xmm_q = _mm_set_epi32(q[1], q[1], q[0], q[0]);                 \
      POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                     \
      m += 4;                                                                \
      q += 2;                                                                \
    }                                                                        \
  }                                                                          \
  xmm_sum_0_0 = _mm_add_epi32(xmm_sum_0_0, xmm_sum_0_1);                     \
  xmm_sum_0_0 = _mm_add_epi32(                                               \
      xmm_sum_0_0, _mm_shuffle_epi32(xmm_sum_0_0, _MM_SHUFFLE(0, 0, 3, 2))); \
  if (q != qe_3) {                                                           \
    __m128i xmm_m = _mm_set_epi32(0, 0, m[1], m[0]);                         \
    __m128i xmm_q = _mm_broadcast_si32(q);                                   \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                       \
  }                                                                          \
  _mm_storel_pi((__m64 *)out, _NORM(xmm_sum_0_0));

//! Compute the distance between matrix and query (UINT32, M=2, N=2)
#define POPCNT_UINT32_2X2_SSE(m, q, cnt, out, _NORM)                         \
  MATRIX_VAR_INIT(1, 2, __m128i, xmm_sum, _mm_setzero_si128())               \
  const uint32_t *qe_0 = q + ((cnt >> 1) << 2);                              \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 2) : qe_0);           \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 1) << 2) : qe_0);       \
  const uint32_t *qe_3 = q + (cnt << 1);                                     \
  if (((uintptr_t)m & 0xf) == 0 && ((uintptr_t)q & 0xf) == 0) {              \
    for (; q != qe_1; m += 4, q += 4) {                                      \
      MATRIX_INT32_ITER_2X2_SSE(m, q, xmm_sum, _mm_load_si128,               \
                                POPCNT_UINT32_STEP1_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE)            \
    for (; q != qe_2; m += 4, q += 4) {                                      \
      MATRIX_INT32_ITER_2X2_SSE(m, q, xmm_sum, _mm_load_si128,               \
                                POPCNT_UINT32_STEP2_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE)            \
    for (; q != qe_0; m += 4, q += 4) {                                      \
      MATRIX_INT32_ITER_2X2_SSE(m, q, xmm_sum, _mm_load_si128,               \
                                POPCNT_UINT32_STEP3_SSE)                     \
    }                                                                        \
  } else {                                                                   \
    for (; q != qe_1; m += 4, q += 4) {                                      \
      MATRIX_INT32_ITER_2X2_SSE(m, q, xmm_sum, _mm_loadu_si128,              \
                                POPCNT_UINT32_STEP1_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE)            \
    for (; q != qe_2; m += 4, q += 4) {                                      \
      MATRIX_INT32_ITER_2X2_SSE(m, q, xmm_sum, _mm_loadu_si128,              \
                                POPCNT_UINT32_STEP2_SSE)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE)            \
    for (; q != qe_0; m += 4, q += 4) {                                      \
      MATRIX_INT32_ITER_2X2_SSE(m, q, xmm_sum, _mm_loadu_si128,              \
                                POPCNT_UINT32_STEP3_SSE)                     \
    }                                                                        \
  }                                                                          \
  xmm_sum_0_0 = _mm_add_epi32(_mm_unpacklo_epi64(xmm_sum_0_0, xmm_sum_0_1),  \
                              _mm_unpackhi_epi64(xmm_sum_0_0, xmm_sum_0_1)); \
  if (q != qe_3) {                                                           \
    __m128i xmm_m = _mm_set_epi32(m[1], m[0], m[1], m[0]);                   \
    __m128i xmm_q = _mm_set_epi32(q[1], q[1], q[0], q[0]);                   \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                       \
  }                                                                          \
  if (((uintptr_t)out & 0xf) == 0) {                                         \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)             \
  } else {                                                                   \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)            \
  }

//! Compute the distance between matrix and query (UINT32, M=4, N=1)
#define POPCNT_UINT32_4X1_SSE(m, q, cnt, out, _NORM)                   \
  MATRIX_VAR_INIT(2, 1, __m128i, xmm_sum, _mm_setzero_si128())         \
  const uint32_t *qe_0 = q + ((cnt >> 1) << 1);                        \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 1) : qe_0);     \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 1) << 1) : qe_0); \
  const uint32_t *qe_3 = q + cnt;                                      \
  if (((uintptr_t)m & 0xf) == 0) {                                     \
    for (; q != qe_1; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_SSE(m, q, xmm_sum, _mm_load_si128,         \
                                POPCNT_UINT32_STEP1_SSE)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE)      \
    for (; q != qe_2; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_SSE(m, q, xmm_sum, _mm_load_si128,         \
                                POPCNT_UINT32_STEP2_SSE)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE)      \
    for (; q != qe_0; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_SSE(m, q, xmm_sum, _mm_load_si128,         \
                                POPCNT_UINT32_STEP3_SSE)               \
    }                                                                  \
    if (q != qe_3) {                                                   \
      __m128i xmm_m = _mm_load_si128((const __m128i *)(m));            \
      __m128i xmm_q = _mm_broadcast_si32(q);                           \
      POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)               \
    }                                                                  \
  } else {                                                             \
    for (; q != qe_1; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_SSE(m, q, xmm_sum, _mm_loadu_si128,        \
                                POPCNT_UINT32_STEP1_SSE)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE)      \
    for (; q != qe_2; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_SSE(m, q, xmm_sum, _mm_loadu_si128,        \
                                POPCNT_UINT32_STEP2_SSE)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE)      \
    for (; q != qe_0; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_SSE(m, q, xmm_sum, _mm_loadu_si128,        \
                                POPCNT_UINT32_STEP3_SSE)               \
    }                                                                  \
    if (q != qe_3) {                                                   \
      __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));           \
      __m128i xmm_q = _mm_broadcast_si32(q);                           \
      POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)               \
    }                                                                  \
  }                                                                    \
  xmm_sum_0_0 = _mm_add_epi32(xmm_sum_0_0, xmm_sum_1_0);               \
  if (((uintptr_t)out & 0xf) == 0) {                                   \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)       \
  } else {                                                             \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)      \
  }

//! Compute the distance between matrix and query (UINT32, M=4, N=2)
#define POPCNT_UINT32_4X2_SSE(m, q, cnt, out, _NORM)              \
  MATRIX_VAR_INIT(1, 2, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 1);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 4, q += 2) {                           \
      MATRIX_INT32_ITER_4X2_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 4, q += 2) {                           \
      MATRIX_INT32_ITER_4X2_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 4, q += 2) {                           \
      MATRIX_INT32_ITER_4X2_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 4, q += 2) {                           \
      MATRIX_INT32_ITER_4X2_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 4, q += 2) {                           \
      MATRIX_INT32_ITER_4X2_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 4, q += 2) {                           \
      MATRIX_INT32_ITER_4X2_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=4, N=4)
#define POPCNT_UINT32_4X4_SSE(m, q, cnt, out, _NORM)              \
  MATRIX_VAR_INIT(1, 4, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 2);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 4, q += 4) {                           \
      MATRIX_INT32_ITER_4X4_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 4, q += 4) {                           \
      MATRIX_INT32_ITER_4X4_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 4, q += 4) {                           \
      MATRIX_INT32_ITER_4X4_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 4, q += 4) {                           \
      MATRIX_INT32_ITER_4X4_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 4, q += 4) {                           \
      MATRIX_INT32_ITER_4X4_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(1, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 4, q += 4) {                           \
      MATRIX_INT32_ITER_4X4_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=1)
#define POPCNT_UINT32_8X1_SSE(m, q, cnt, out, _NORM)              \
  MATRIX_VAR_INIT(2, 1, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + cnt;                                 \
  const uint32_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);              \
  const uint32_t *qe_2 = (cnt > 4095 ? q + 4095 : qe_0);          \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 8, ++q) {                              \
      MATRIX_INT32_ITER_8X1_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, ++q) {                              \
      MATRIX_INT32_ITER_8X1_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, ++q) {                              \
      MATRIX_INT32_ITER_8X1_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 8, ++q) {                              \
      MATRIX_INT32_ITER_8X1_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, ++q) {                              \
      MATRIX_INT32_ITER_8X1_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, ++q) {                              \
      MATRIX_INT32_ITER_8X1_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=2)
#define POPCNT_UINT32_8X2_SSE(m, q, cnt, out, _NORM)              \
  MATRIX_VAR_INIT(2, 2, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 1);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 8, q += 2) {                           \
      MATRIX_INT32_ITER_8X2_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, q += 2) {                           \
      MATRIX_INT32_ITER_8X2_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, q += 2) {                           \
      MATRIX_INT32_ITER_8X2_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 8, q += 2) {                           \
      MATRIX_INT32_ITER_8X2_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, q += 2) {                           \
      MATRIX_INT32_ITER_8X2_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, q += 2) {                           \
      MATRIX_INT32_ITER_8X2_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=4)
#define POPCNT_UINT32_8X4_SSE(m, q, cnt, out, _NORM)              \
  MATRIX_VAR_INIT(2, 4, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 2);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 8, q += 4) {                           \
      MATRIX_INT32_ITER_8X4_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, q += 4) {                           \
      MATRIX_INT32_ITER_8X4_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, q += 4) {                           \
      MATRIX_INT32_ITER_8X4_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 8, q += 4) {                           \
      MATRIX_INT32_ITER_8X4_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, q += 4) {                           \
      MATRIX_INT32_ITER_8X4_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, q += 4) {                           \
      MATRIX_INT32_ITER_8X4_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=8)
#define POPCNT_UINT32_8X8_SSE(m, q, cnt, out, _NORM)              \
  MATRIX_VAR_INIT(2, 8, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 3);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 3) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 8, q += 8) {                           \
      MATRIX_INT32_ITER_8X8_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 8, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, q += 8) {                           \
      MATRIX_INT32_ITER_8X8_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 8, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, q += 8) {                           \
      MATRIX_INT32_ITER_8X8_SSE(m, q, xmm_sum, _mm_load_si128,    \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 8, q += 8) {                           \
      MATRIX_INT32_ITER_8X8_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP1_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 8, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 8, q += 8) {                           \
      MATRIX_INT32_ITER_8X8_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP2_SSE)          \
    }                                                             \
    MATRIX_VAR_PERMUTE(2, 8, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 8, q += 8) {                           \
      MATRIX_INT32_ITER_8X8_SSE(m, q, xmm_sum, _mm_loadu_si128,   \
                                POPCNT_UINT32_STEP3_SSE)          \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 8, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 8, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=1)
#define POPCNT_UINT32_16X1_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(4, 1, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + cnt;                                 \
  const uint32_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);              \
  const uint32_t *qe_2 = (cnt > 4095 ? q + 4095 : qe_0);          \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 16, ++q) {                             \
      MATRIX_INT32_ITER_16X1_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, ++q) {                             \
      MATRIX_INT32_ITER_16X1_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, ++q) {                             \
      MATRIX_INT32_ITER_16X1_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 16, ++q) {                             \
      MATRIX_INT32_ITER_16X1_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, ++q) {                             \
      MATRIX_INT32_ITER_16X1_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, ++q) {                             \
      MATRIX_INT32_ITER_16X1_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(4, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(4, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=2)
#define POPCNT_UINT32_16X2_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(4, 2, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 1);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 16, q += 2) {                          \
      MATRIX_INT32_ITER_16X2_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 2) {                          \
      MATRIX_INT32_ITER_16X2_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 2) {                          \
      MATRIX_INT32_ITER_16X2_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 16, q += 2) {                          \
      MATRIX_INT32_ITER_16X2_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 2) {                          \
      MATRIX_INT32_ITER_16X2_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 2) {                          \
      MATRIX_INT32_ITER_16X2_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(4, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(4, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=4)
#define POPCNT_UINT32_16X4_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(4, 4, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 2);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 16, q += 4) {                          \
      MATRIX_INT32_ITER_16X4_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 4) {                          \
      MATRIX_INT32_ITER_16X4_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 4) {                          \
      MATRIX_INT32_ITER_16X4_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 16, q += 4) {                          \
      MATRIX_INT32_ITER_16X4_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 4) {                          \
      MATRIX_INT32_ITER_16X4_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 4) {                          \
      MATRIX_INT32_ITER_16X4_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(4, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(4, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=8)
#define POPCNT_UINT32_16X8_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(4, 8, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 3);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 3) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 16, q += 8) {                          \
      MATRIX_INT32_ITER_16X8_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 8, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 8) {                          \
      MATRIX_INT32_ITER_16X8_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 8, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 8) {                          \
      MATRIX_INT32_ITER_16X8_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 16, q += 8) {                          \
      MATRIX_INT32_ITER_16X8_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 8, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 8) {                          \
      MATRIX_INT32_ITER_16X8_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(4, 8, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 8) {                          \
      MATRIX_INT32_ITER_16X8_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(4, 8, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(4, 8, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=16)
#define POPCNT_UINT32_16X16_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(4, 16, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 4);                           \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 4) : qe_0);        \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 4) : qe_0);    \
  if (((uintptr_t)m & 0xf) == 0) {                                 \
    for (; q != qe_1; m += 16, q += 16) {                          \
      MATRIX_INT32_ITER_16X16_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP1_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(4, 16, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 16) {                          \
      MATRIX_INT32_ITER_16X16_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP2_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(4, 16, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 16) {                          \
      MATRIX_INT32_ITER_16X16_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP3_SSE)         \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 16, q += 16) {                          \
      MATRIX_INT32_ITER_16X16_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP1_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(4, 16, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 16, q += 16) {                          \
      MATRIX_INT32_ITER_16X16_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP2_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(4, 16, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 16, q += 16) {                          \
      MATRIX_INT32_ITER_16X16_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP3_SSE)         \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(4, 16, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                         \
    MATRIX_VAR_STORE(4, 16, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=1)
#define POPCNT_UINT32_32X1_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(8, 1, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + cnt;                                 \
  const uint32_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);              \
  const uint32_t *qe_2 = (cnt > 4095 ? q + 4095 : qe_0);          \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 32, ++q) {                             \
      MATRIX_INT32_ITER_32X1_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, ++q) {                             \
      MATRIX_INT32_ITER_32X1_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, ++q) {                             \
      MATRIX_INT32_ITER_32X1_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 32, ++q) {                             \
      MATRIX_INT32_ITER_32X1_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 1, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, ++q) {                             \
      MATRIX_INT32_ITER_32X1_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 1, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, ++q) {                             \
      MATRIX_INT32_ITER_32X1_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(8, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(8, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=2)
#define POPCNT_UINT32_32X2_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(8, 2, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 1);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 32, q += 2) {                          \
      MATRIX_INT32_ITER_32X2_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 2) {                          \
      MATRIX_INT32_ITER_32X2_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 2) {                          \
      MATRIX_INT32_ITER_32X2_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 32, q += 2) {                          \
      MATRIX_INT32_ITER_32X2_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 2, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 2) {                          \
      MATRIX_INT32_ITER_32X2_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 2, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 2) {                          \
      MATRIX_INT32_ITER_32X2_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(8, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(8, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=4)
#define POPCNT_UINT32_32X4_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(8, 4, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 2);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 32, q += 4) {                          \
      MATRIX_INT32_ITER_32X4_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 4) {                          \
      MATRIX_INT32_ITER_32X4_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 4) {                          \
      MATRIX_INT32_ITER_32X4_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 32, q += 4) {                          \
      MATRIX_INT32_ITER_32X4_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 4, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 4) {                          \
      MATRIX_INT32_ITER_32X4_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 4, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 4) {                          \
      MATRIX_INT32_ITER_32X4_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(8, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(8, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=8)
#define POPCNT_UINT32_32X8_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(8, 8, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 3);                          \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);       \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 3) : qe_0);   \
  if (((uintptr_t)m & 0xf) == 0) {                                \
    for (; q != qe_1; m += 32, q += 8) {                          \
      MATRIX_INT32_ITER_32X8_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 8, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 8) {                          \
      MATRIX_INT32_ITER_32X8_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 8, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 8) {                          \
      MATRIX_INT32_ITER_32X8_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  } else {                                                        \
    for (; q != qe_1; m += 32, q += 8) {                          \
      MATRIX_INT32_ITER_32X8_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP1_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 8, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 8) {                          \
      MATRIX_INT32_ITER_32X8_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP2_SSE)         \
    }                                                             \
    MATRIX_VAR_PERMUTE(8, 8, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 8) {                          \
      MATRIX_INT32_ITER_32X8_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                 POPCNT_UINT32_STEP3_SSE)         \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(8, 8, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(8, 8, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=16)
#define POPCNT_UINT32_32X16_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(8, 16, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 4);                           \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 4) : qe_0);        \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 4) : qe_0);    \
  if (((uintptr_t)m & 0xf) == 0) {                                 \
    for (; q != qe_1; m += 32, q += 16) {                          \
      MATRIX_INT32_ITER_32X16_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP1_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 16, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 16) {                          \
      MATRIX_INT32_ITER_32X16_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP2_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 16, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 16) {                          \
      MATRIX_INT32_ITER_32X16_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP3_SSE)         \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 32, q += 16) {                          \
      MATRIX_INT32_ITER_32X16_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP1_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 16, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 16) {                          \
      MATRIX_INT32_ITER_32X16_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP2_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 16, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 16) {                          \
      MATRIX_INT32_ITER_32X16_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP3_SSE)         \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(8, 16, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                         \
    MATRIX_VAR_STORE(8, 16, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=32)
#define POPCNT_UINT32_32X32_SSE(m, q, cnt, out, _NORM)             \
  MATRIX_VAR_INIT(8, 32, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qe_0 = q + (cnt << 5);                           \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 5) : qe_0);        \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 5) : qe_0);    \
  if (((uintptr_t)m & 0xf) == 0) {                                 \
    for (; q != qe_1; m += 32, q += 32) {                          \
      MATRIX_INT32_ITER_32X32_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP1_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 32, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 32) {                          \
      MATRIX_INT32_ITER_32X32_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP2_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 32, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 32) {                          \
      MATRIX_INT32_ITER_32X32_SSE(m, q, xmm_sum, _mm_load_si128,   \
                                  POPCNT_UINT32_STEP3_SSE)         \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 32, q += 32) {                          \
      MATRIX_INT32_ITER_32X32_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP1_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 32, xmm_sum, POPCNT_UINT32_PERMUTE1_SSE) \
    for (; q != qe_2; m += 32, q += 32) {                          \
      MATRIX_INT32_ITER_32X32_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP2_SSE)         \
    }                                                              \
    MATRIX_VAR_PERMUTE(8, 32, xmm_sum, POPCNT_UINT32_PERMUTE2_SSE) \
    for (; q != qe_0; m += 32, q += 32) {                          \
      MATRIX_INT32_ITER_32X32_SSE(m, q, xmm_sum, _mm_loadu_si128,  \
                                  POPCNT_UINT32_STEP3_SSE)         \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(8, 32, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                         \
    MATRIX_VAR_STORE(8, 32, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=2, N=1)
#define POPCNT_UINT32_2X1_AVX(m, q, cnt, out, _NORM)                           \
  MATRIX_VAR_INIT(1, 1, __m256i, ymm_sum, _mm256_setzero_si256())              \
  const uint32_t *qe_0 = q + ((cnt >> 2) << 2);                                \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 2) << 2) : qe_0);             \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 2) << 2) : qe_0);         \
  const uint32_t *qe_3 = q + cnt;                                              \
  if (((uintptr_t)m & 0x1f) == 0) {                                            \
    for (; q != qe_1; m += 8, q += 4) {                                        \
      MATRIX_INT32_ITER_2X1_AVX(m, q, ymm_sum, _mm256_load_si256,              \
                                POPCNT_UINT32_STEP1_AVX)                       \
    }                                                                          \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)              \
    for (; q != qe_2; m += 8, q += 4) {                                        \
      MATRIX_INT32_ITER_2X1_AVX(m, q, ymm_sum, _mm256_load_si256,              \
                                POPCNT_UINT32_STEP2_AVX)                       \
    }                                                                          \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)              \
    for (; q != qe_0; m += 8, q += 4) {                                        \
      MATRIX_INT32_ITER_2X1_AVX(m, q, ymm_sum, _mm256_load_si256,              \
                                POPCNT_UINT32_STEP3_AVX)                       \
    }                                                                          \
  } else {                                                                     \
    for (; q != qe_1; m += 8, q += 4) {                                        \
      MATRIX_INT32_ITER_2X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,             \
                                POPCNT_UINT32_STEP1_AVX)                       \
    }                                                                          \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)              \
    for (; q != qe_2; m += 8, q += 4) {                                        \
      MATRIX_INT32_ITER_2X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,             \
                                POPCNT_UINT32_STEP2_AVX)                       \
    }                                                                          \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)              \
    for (; q != qe_0; m += 8, q += 4) {                                        \
      MATRIX_INT32_ITER_2X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,             \
                                POPCNT_UINT32_STEP3_AVX)                       \
    }                                                                          \
  }                                                                            \
  __m128i xmm_sum_0 = _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),       \
                                    _mm256_extracti128_si256(ymm_sum_0_0, 1)); \
  if (qe_3 >= qe_0 + 2) {                                                      \
    __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));                     \
    __m128i xmm_q = _mm_set_epi32(q[1], q[1], q[0], q[0]);                     \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0)                           \
    m += 4;                                                                    \
    q += 2;                                                                    \
  }                                                                            \
  xmm_sum_0 = _mm_add_epi32(                                                   \
      xmm_sum_0, _mm_shuffle_epi32(xmm_sum_0, _MM_SHUFFLE(0, 0, 3, 2)));       \
  if (q != qe_3) {                                                             \
    __m128i xmm_m = _mm_set_epi32(0, 0, m[1], m[0]);                           \
    __m128i xmm_q = _mm_broadcast_si32(q);                                     \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0)                           \
  }                                                                            \
  _mm_storel_pi((__m64 *)out, _NORM(xmm_sum_0));

//! Compute the distance between matrix and query (UINT32, M=2, N=2)
#define POPCNT_UINT32_2X2_AVX(m, q, cnt, out, _NORM)                         \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())            \
  const uint32_t *qe_0 = q + ((cnt >> 2) << 3);                              \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 2) << 3) : qe_0);           \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 2) << 3) : qe_0);       \
  const uint32_t *qe_3 = q + (cnt << 1);                                     \
  if (((uintptr_t)m & 0x1f) == 0 && ((uintptr_t)q & 0x1f) == 0) {            \
    for (; q != qe_1; m += 8, q += 8) {                                      \
      MATRIX_INT32_ITER_2X2_AVX(m, q, ymm_sum, _mm256_load_si256,            \
                                POPCNT_UINT32_STEP1_AVX)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)            \
    for (; q != qe_2; m += 8, q += 8) {                                      \
      MATRIX_INT32_ITER_2X2_AVX(m, q, ymm_sum, _mm256_load_si256,            \
                                POPCNT_UINT32_STEP2_AVX)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)            \
    for (; q != qe_0; m += 8, q += 8) {                                      \
      MATRIX_INT32_ITER_2X2_AVX(m, q, ymm_sum, _mm256_load_si256,            \
                                POPCNT_UINT32_STEP3_AVX)                     \
    }                                                                        \
  } else {                                                                   \
    for (; q != qe_1; m += 8, q += 8) {                                      \
      MATRIX_INT32_ITER_2X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,           \
                                POPCNT_UINT32_STEP1_AVX)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)            \
    for (; q != qe_2; m += 8, q += 8) {                                      \
      MATRIX_INT32_ITER_2X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,           \
                                POPCNT_UINT32_STEP2_AVX)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)            \
    for (; q != qe_0; m += 8, q += 8) {                                      \
      MATRIX_INT32_ITER_2X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,           \
                                POPCNT_UINT32_STEP3_AVX)                     \
    }                                                                        \
  }                                                                          \
  __m128i xmm_sum_0_0 =                                                      \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),                     \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));               \
  __m128i xmm_sum_0_1 =                                                      \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_1),                     \
                    _mm256_extracti128_si256(ymm_sum_0_1, 1));               \
  if (qe_3 >= qe_0 + 4) {                                                    \
    __m128i xmm_q = _mm_loadu_si128((const __m128i *)(q));                   \
    __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));                   \
    __m128i xmm_p = _mm_shuffle_epi32(xmm_q, _MM_SHUFFLE(2, 2, 0, 0));       \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_p, xmm_sum_0_0)                       \
    xmm_p = _mm_shuffle_epi32(xmm_q, _MM_SHUFFLE(3, 3, 1, 1));               \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_p, xmm_sum_0_1)                       \
    m += 4;                                                                  \
    q += 4;                                                                  \
  }                                                                          \
  xmm_sum_0_0 = _mm_add_epi32(_mm_unpacklo_epi64(xmm_sum_0_0, xmm_sum_0_1),  \
                              _mm_unpackhi_epi64(xmm_sum_0_0, xmm_sum_0_1)); \
  if (q != qe_3) {                                                           \
    __m128i xmm_m = _mm_set_epi32(m[1], m[0], m[1], m[0]);                   \
    __m128i xmm_q = _mm_set_epi32(q[1], q[1], q[0], q[0]);                   \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                       \
  }                                                                          \
  if (((uintptr_t)out & 0xf) == 0) {                                         \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)             \
  } else {                                                                   \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)            \
  }

//! Compute the distance between matrix and query (UINT32, M=4, N=1)
#define POPCNT_UINT32_4X1_AVX(m, q, cnt, out, _NORM)                   \
  MATRIX_VAR_INIT(1, 1, __m256i, ymm_sum, _mm256_setzero_si256())      \
  const uint32_t *qe_0 = q + ((cnt >> 1) << 1);                        \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 1) : qe_0);     \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 1) << 1) : qe_0); \
  const uint32_t *qe_3 = q + cnt;                                      \
  if (((uintptr_t)m & 0x1f) == 0) {                                    \
    for (; q != qe_1; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)      \
    for (; q != qe_2; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP2_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)      \
    for (; q != qe_0; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP3_AVX)               \
    }                                                                  \
  } else {                                                             \
    for (; q != qe_1; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)      \
    for (; q != qe_2; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP2_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)      \
    for (; q != qe_0; m += 8, q += 2) {                                \
      MATRIX_INT32_ITER_4X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP3_AVX)               \
    }                                                                  \
  }                                                                    \
  __m128i xmm_sum_0_0 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),               \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));         \
  if (q != qe_3) {                                                     \
    __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));             \
    __m128i xmm_q = _mm_broadcast_si32(q);                             \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                 \
  }                                                                    \
  if (((uintptr_t)out & 0xf) == 0) {                                   \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)       \
  } else {                                                             \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)      \
  }

//! Compute the distance between matrix and query (UINT32, M=4, N=2)
#define POPCNT_UINT32_4X2_AVX(m, q, cnt, out, _NORM)                   \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())      \
  const uint32_t *qe_0 = q + ((cnt >> 1) << 2);                        \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 2) : qe_0);     \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 1) << 2) : qe_0); \
  const uint32_t *qe_3 = q + (cnt << 1);                               \
  if (((uintptr_t)m & 0x1f) == 0) {                                    \
    for (; q != qe_1; m += 8, q += 4) {                                \
      MATRIX_INT32_ITER_4X2_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)      \
    for (; q != qe_2; m += 8, q += 4) {                                \
      MATRIX_INT32_ITER_4X2_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP2_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)      \
    for (; q != qe_0; m += 8, q += 4) {                                \
      MATRIX_INT32_ITER_4X2_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP3_AVX)               \
    }                                                                  \
  } else {                                                             \
    for (; q != qe_1; m += 8, q += 4) {                                \
      MATRIX_INT32_ITER_4X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)      \
    for (; q != qe_2; m += 8, q += 4) {                                \
      MATRIX_INT32_ITER_4X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP2_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)      \
    for (; q != qe_0; m += 8, q += 4) {                                \
      MATRIX_INT32_ITER_4X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP3_AVX)               \
    }                                                                  \
  }                                                                    \
  __m128i xmm_sum_0_0 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),               \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));         \
  __m128i xmm_sum_0_1 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_1),               \
                    _mm256_extracti128_si256(ymm_sum_0_1, 1));         \
  if (q != qe_3) {                                                     \
    __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));             \
    __m128i xmm_q = _mm_broadcast_si32(q);                             \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                 \
    xmm_q = _mm_broadcast_si32(q + 1);                                 \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_1)                 \
  }                                                                    \
  if (((uintptr_t)out & 0xf) == 0) {                                   \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)       \
  } else {                                                             \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM)      \
  }

//! Compute the distance between matrix and query (UINT32, M=4, N=4)
#define POPCNT_UINT32_4X4_AVX(m, q, cnt, out, _NORM)                   \
  MATRIX_VAR_INIT(1, 4, __m256i, ymm_sum, _mm256_setzero_si256())      \
  const uint32_t *qe_0 = q + ((cnt >> 1) << 3);                        \
  const uint32_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 3) : qe_0);     \
  const uint32_t *qe_2 = (cnt > 4095 ? q + ((4095 >> 1) << 3) : qe_0); \
  const uint32_t *qe_3 = q + (cnt << 2);                               \
  if (((uintptr_t)m & 0x1f) == 0 && ((uintptr_t)q & 0x1f) == 0) {      \
    for (; q != qe_1; m += 8, q += 8) {                                \
      MATRIX_INT32_ITER_4X4_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)      \
    for (; q != qe_2; m += 8, q += 8) {                                \
      MATRIX_INT32_ITER_4X4_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP2_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)      \
    for (; q != qe_0; m += 8, q += 8) {                                \
      MATRIX_INT32_ITER_4X4_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT32_STEP3_AVX)               \
    }                                                                  \
  } else {                                                             \
    for (; q != qe_1; m += 8, q += 8) {                                \
      MATRIX_INT32_ITER_4X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)      \
    for (; q != qe_2; m += 8, q += 8) {                                \
      MATRIX_INT32_ITER_4X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP2_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)      \
    for (; q != qe_0; m += 8, q += 8) {                                \
      MATRIX_INT32_ITER_4X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT32_STEP3_AVX)               \
    }                                                                  \
  }                                                                    \
  __m128i xmm_sum_0_0 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),               \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));         \
  __m128i xmm_sum_0_1 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_1),               \
                    _mm256_extracti128_si256(ymm_sum_0_1, 1));         \
  __m128i xmm_sum_0_2 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_2),               \
                    _mm256_extracti128_si256(ymm_sum_0_2, 1));         \
  __m128i xmm_sum_0_3 =                                                \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_3),               \
                    _mm256_extracti128_si256(ymm_sum_0_3, 1));         \
  if (q != qe_3) {                                                     \
    __m128i xmm_m = _mm_loadu_si128((const __m128i *)(m));             \
    __m128i xmm_q = _mm_broadcast_si32(q);                             \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_0)                 \
    xmm_q = _mm_broadcast_si32(q + 1);                                 \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_1)                 \
    xmm_q = _mm_broadcast_si32(q + 2);                                 \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_2)                 \
    xmm_q = _mm_broadcast_si32(q + 3);                                 \
    POPCNT_UINT32_STEP3_SSE(xmm_m, xmm_q, xmm_sum_0_3)                 \
  }                                                                    \
  if (((uintptr_t)out & 0xf) == 0) {                                   \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)       \
  } else {                                                             \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM)      \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=1)
#define POPCNT_UINT32_8X1_AVX(m, q, cnt, out, _NORM)                 \
  MATRIX_VAR_INIT(1, 1, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + cnt;                                    \
  const uint32_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);                 \
  const uint32_t *qe_2 = (cnt > 4095 ? q + 4095 : qe_0);             \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 8, ++q) {                                 \
      MATRIX_INT32_ITER_8X1_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, ++q) {                                 \
      MATRIX_INT32_ITER_8X1_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, ++q) {                                 \
      MATRIX_INT32_ITER_8X1_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 8, ++q) {                                 \
      MATRIX_INT32_ITER_8X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, ++q) {                                 \
      MATRIX_INT32_ITER_8X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, ++q) {                                 \
      MATRIX_INT32_ITER_8X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 1, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 1, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=2)
#define POPCNT_UINT32_8X2_AVX(m, q, cnt, out, _NORM)                 \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 1);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 8, q += 2) {                              \
      MATRIX_INT32_ITER_8X2_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, q += 2) {                              \
      MATRIX_INT32_ITER_8X2_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, q += 2) {                              \
      MATRIX_INT32_ITER_8X2_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 8, q += 2) {                              \
      MATRIX_INT32_ITER_8X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, q += 2) {                              \
      MATRIX_INT32_ITER_8X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, q += 2) {                              \
      MATRIX_INT32_ITER_8X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 2, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 2, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=4)
#define POPCNT_UINT32_8X4_AVX(m, q, cnt, out, _NORM)                 \
  MATRIX_VAR_INIT(1, 4, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 2);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 8, q += 4) {                              \
      MATRIX_INT32_ITER_8X4_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, q += 4) {                              \
      MATRIX_INT32_ITER_8X4_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, q += 4) {                              \
      MATRIX_INT32_ITER_8X4_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 8, q += 4) {                              \
      MATRIX_INT32_ITER_8X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, q += 4) {                              \
      MATRIX_INT32_ITER_8X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, q += 4) {                              \
      MATRIX_INT32_ITER_8X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 4, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 4, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=8, N=8)
#define POPCNT_UINT32_8X8_AVX(m, q, cnt, out, _NORM)                 \
  MATRIX_VAR_INIT(1, 8, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 3);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 3) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 8, q += 8) {                              \
      MATRIX_INT32_ITER_8X8_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 8, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, q += 8) {                              \
      MATRIX_INT32_ITER_8X8_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 8, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, q += 8) {                              \
      MATRIX_INT32_ITER_8X8_AVX(m, q, ymm_sum, _mm256_load_si256,    \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 8, q += 8) {                              \
      MATRIX_INT32_ITER_8X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP1_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 8, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 8, q += 8) {                              \
      MATRIX_INT32_ITER_8X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP2_AVX)             \
    }                                                                \
    MATRIX_VAR_PERMUTE(1, 8, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 8, q += 8) {                              \
      MATRIX_INT32_ITER_8X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,   \
                                POPCNT_UINT32_STEP3_AVX)             \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 8, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 8, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=1)
#define POPCNT_UINT32_16X1_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(2, 1, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + cnt;                                    \
  const uint32_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);                 \
  const uint32_t *qe_2 = (cnt > 4095 ? q + 4095 : qe_0);             \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 16, ++q) {                                \
      MATRIX_INT32_ITER_16X1_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, ++q) {                                \
      MATRIX_INT32_ITER_16X1_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, ++q) {                                \
      MATRIX_INT32_ITER_16X1_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 16, ++q) {                                \
      MATRIX_INT32_ITER_16X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, ++q) {                                \
      MATRIX_INT32_ITER_16X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, ++q) {                                \
      MATRIX_INT32_ITER_16X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(2, 1, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(2, 1, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=2)
#define POPCNT_UINT32_16X2_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(2, 2, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 1);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 16, q += 2) {                             \
      MATRIX_INT32_ITER_16X2_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 2) {                             \
      MATRIX_INT32_ITER_16X2_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 2) {                             \
      MATRIX_INT32_ITER_16X2_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 16, q += 2) {                             \
      MATRIX_INT32_ITER_16X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 2) {                             \
      MATRIX_INT32_ITER_16X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 2) {                             \
      MATRIX_INT32_ITER_16X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(2, 2, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(2, 2, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=4)
#define POPCNT_UINT32_16X4_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(2, 4, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 2);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 16, q += 4) {                             \
      MATRIX_INT32_ITER_16X4_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 4) {                             \
      MATRIX_INT32_ITER_16X4_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 4) {                             \
      MATRIX_INT32_ITER_16X4_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 16, q += 4) {                             \
      MATRIX_INT32_ITER_16X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 4) {                             \
      MATRIX_INT32_ITER_16X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 4) {                             \
      MATRIX_INT32_ITER_16X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(2, 4, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(2, 4, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=8)
#define POPCNT_UINT32_16X8_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(2, 8, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 3);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 3) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 16, q += 8) {                             \
      MATRIX_INT32_ITER_16X8_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 8, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 8) {                             \
      MATRIX_INT32_ITER_16X8_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 8, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 8) {                             \
      MATRIX_INT32_ITER_16X8_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 16, q += 8) {                             \
      MATRIX_INT32_ITER_16X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 8, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 8) {                             \
      MATRIX_INT32_ITER_16X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(2, 8, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 8) {                             \
      MATRIX_INT32_ITER_16X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(2, 8, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(2, 8, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=16, N=16)
#define POPCNT_UINT32_16X16_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(2, 16, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 4);                              \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 4) : qe_0);           \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 4) : qe_0);       \
  if (((uintptr_t)m & 0x1f) == 0) {                                   \
    for (; q != qe_1; m += 16, q += 16) {                             \
      MATRIX_INT32_ITER_16X16_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP1_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(2, 16, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 16) {                             \
      MATRIX_INT32_ITER_16X16_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP2_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(2, 16, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 16) {                             \
      MATRIX_INT32_ITER_16X16_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP3_AVX)            \
    }                                                                 \
  } else {                                                            \
    for (; q != qe_1; m += 16, q += 16) {                             \
      MATRIX_INT32_ITER_16X16_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP1_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(2, 16, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 16, q += 16) {                             \
      MATRIX_INT32_ITER_16X16_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP2_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(2, 16, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 16, q += 16) {                             \
      MATRIX_INT32_ITER_16X16_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP3_AVX)            \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(2, 16, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                            \
    MATRIX_VAR_STORE(2, 16, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=1)
#define POPCNT_UINT32_32X1_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(4, 1, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + cnt;                                    \
  const uint32_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);                 \
  const uint32_t *qe_2 = (cnt > 4095 ? q + 4095 : qe_0);             \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 32, ++q) {                                \
      MATRIX_INT32_ITER_32X1_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, ++q) {                                \
      MATRIX_INT32_ITER_32X1_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, ++q) {                                \
      MATRIX_INT32_ITER_32X1_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 32, ++q) {                                \
      MATRIX_INT32_ITER_32X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 1, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, ++q) {                                \
      MATRIX_INT32_ITER_32X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 1, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, ++q) {                                \
      MATRIX_INT32_ITER_32X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(4, 1, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(4, 1, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=2)
#define POPCNT_UINT32_32X2_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(4, 2, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 1);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 1) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 32, q += 2) {                             \
      MATRIX_INT32_ITER_32X2_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 2) {                             \
      MATRIX_INT32_ITER_32X2_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 2) {                             \
      MATRIX_INT32_ITER_32X2_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 32, q += 2) {                             \
      MATRIX_INT32_ITER_32X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 2, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 2) {                             \
      MATRIX_INT32_ITER_32X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 2, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 2) {                             \
      MATRIX_INT32_ITER_32X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(4, 2, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(4, 2, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=4)
#define POPCNT_UINT32_32X4_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(4, 4, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 2);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 2) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 32, q += 4) {                             \
      MATRIX_INT32_ITER_32X4_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 4) {                             \
      MATRIX_INT32_ITER_32X4_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 4) {                             \
      MATRIX_INT32_ITER_32X4_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 32, q += 4) {                             \
      MATRIX_INT32_ITER_32X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 4, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 4) {                             \
      MATRIX_INT32_ITER_32X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 4, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 4) {                             \
      MATRIX_INT32_ITER_32X4_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(4, 4, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(4, 4, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=8)
#define POPCNT_UINT32_32X8_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(4, 8, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 3);                             \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);          \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 3) : qe_0);      \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 32, q += 8) {                             \
      MATRIX_INT32_ITER_32X8_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 8, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 8) {                             \
      MATRIX_INT32_ITER_32X8_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 8, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 8) {                             \
      MATRIX_INT32_ITER_32X8_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 32, q += 8) {                             \
      MATRIX_INT32_ITER_32X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP1_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 8, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 8) {                             \
      MATRIX_INT32_ITER_32X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP2_AVX)            \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 8, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 8) {                             \
      MATRIX_INT32_ITER_32X8_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                 POPCNT_UINT32_STEP3_AVX)            \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(4, 8, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(4, 8, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=16)
#define POPCNT_UINT32_32X16_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(4, 16, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 4);                              \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 4) : qe_0);           \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 4) : qe_0);       \
  if (((uintptr_t)m & 0x1f) == 0) {                                   \
    for (; q != qe_1; m += 32, q += 16) {                             \
      MATRIX_INT32_ITER_32X16_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP1_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 16, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 16) {                             \
      MATRIX_INT32_ITER_32X16_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP2_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 16, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 16) {                             \
      MATRIX_INT32_ITER_32X16_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP3_AVX)            \
    }                                                                 \
  } else {                                                            \
    for (; q != qe_1; m += 32, q += 16) {                             \
      MATRIX_INT32_ITER_32X16_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP1_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 16, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 16) {                             \
      MATRIX_INT32_ITER_32X16_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP2_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 16, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 16) {                             \
      MATRIX_INT32_ITER_32X16_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP3_AVX)            \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(4, 16, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                            \
    MATRIX_VAR_STORE(4, 16, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT32, M=32, N=32)
#define POPCNT_UINT32_32X32_AVX(m, q, cnt, out, _NORM)                \
  MATRIX_VAR_INIT(4, 32, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qe_0 = q + (cnt << 5);                              \
  const uint32_t *qe_1 = (cnt > 31 ? q + (31 << 5) : qe_0);           \
  const uint32_t *qe_2 = (cnt > 4095 ? q + (4095 << 5) : qe_0);       \
  if (((uintptr_t)m & 0x1f) == 0) {                                   \
    for (; q != qe_1; m += 32, q += 32) {                             \
      MATRIX_INT32_ITER_32X32_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP1_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 32, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 32) {                             \
      MATRIX_INT32_ITER_32X32_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP2_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 32, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 32) {                             \
      MATRIX_INT32_ITER_32X32_AVX(m, q, ymm_sum, _mm256_load_si256,   \
                                  POPCNT_UINT32_STEP3_AVX)            \
    }                                                                 \
  } else {                                                            \
    for (; q != qe_1; m += 32, q += 32) {                             \
      MATRIX_INT32_ITER_32X32_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP1_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 32, ymm_sum, POPCNT_UINT32_PERMUTE1_AVX)    \
    for (; q != qe_2; m += 32, q += 32) {                             \
      MATRIX_INT32_ITER_32X32_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP2_AVX)            \
    }                                                                 \
    MATRIX_VAR_PERMUTE(4, 32, ymm_sum, POPCNT_UINT32_PERMUTE2_AVX)    \
    for (; q != qe_0; m += 32, q += 32) {                             \
      MATRIX_INT32_ITER_32X32_AVX(m, q, ymm_sum, _mm256_loadu_si256,  \
                                  POPCNT_UINT32_STEP3_AVX)            \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(4, 32, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                            \
    MATRIX_VAR_STORE(4, 32, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (UINT64, M=2, N=1)
#define POPCNT_UINT64_2X1_AVX(m, q, cnt, out, _NORM)                   \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())      \
  const uint64_t *qe_0 = q + ((cnt >> 2) << 2);                        \
  const uint64_t *qe_1 = (cnt > 31 ? q + ((31 >> 2) << 2) : qe_0);     \
  const uint64_t *qe_2 = q + cnt;                                      \
  if (((uintptr_t)m & 0x1f) == 0 && ((uintptr_t)q & 0x1f) == 0) {      \
    for (; q != qe_1; m += 8, q += 4) {                                \
      MATRIX_INT64_ITER_2X1_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT64_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)       \
    for (; q != qe_0; m += 8, q += 4) {                                \
      MATRIX_INT64_ITER_2X1_AVX(m, q, ymm_sum, _mm256_load_si256,      \
                                POPCNT_UINT64_STEP2_AVX)               \
    }                                                                  \
    if (qe_2 >= qe_0 + 2) {                                            \
      __m256i ymm_m = _mm256_load_si256((const __m256i *)(m));         \
      __m256i ymm_q = _mm256_set_epi64x(q[1], q[1], q[0], q[0]);       \
      POPCNT_UINT64_STEP2_AVX(ymm_m, ymm_q, ymm_sum_0_0)               \
      m += 4;                                                          \
      q += 2;                                                          \
    }                                                                  \
  } else {                                                             \
    for (; q != qe_1; m += 8, q += 4) {                                \
      MATRIX_INT64_ITER_2X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT64_STEP1_AVX)               \
    }                                                                  \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)       \
    for (; q != qe_0; m += 8, q += 4) {                                \
      MATRIX_INT64_ITER_2X1_AVX(m, q, ymm_sum, _mm256_loadu_si256,     \
                                POPCNT_UINT64_STEP2_AVX)               \
    }                                                                  \
    if (qe_2 >= qe_0 + 2) {                                            \
      __m256i ymm_m = _mm256_loadu_si256((const __m256i *)(m));        \
      __m256i ymm_q = _mm256_set_epi64x(q[1], q[1], q[0], q[0]);       \
      POPCNT_UINT64_STEP2_AVX(ymm_m, ymm_q, ymm_sum_0_0)               \
      m += 4;                                                          \
      q += 2;                                                          \
    }                                                                  \
  }                                                                    \
  ymm_sum_0_0 = _mm256_add_epi64(ymm_sum_0_0, ymm_sum_0_1);            \
  ymm_sum_0_0 = _mm256_add_epi64(                                      \
      ymm_sum_0_0,                                                     \
      _mm256_permute4x64_epi64(ymm_sum_0_0, _MM_SHUFFLE(0, 0, 3, 2))); \
  if (q != qe_2) {                                                     \
    __m256i ymm_m = _mm256_set_epi64x(0, 0, m[1], m[0]);               \
    __m256i ymm_q = _mm256_broadcast_si64(q);                          \
    POPCNT_UINT64_STEP2_AVX(ymm_m, ymm_q, ymm_sum_0_0)                 \
  }                                                                    \
  _mm_storel_pi((__m64 *)out, _NORM(ymm_sum_0_0));

//! Compute the distance between matrix and query (UINT64, M=2, N=2)
#define POPCNT_UINT64_2X2_AVX(m, q, cnt, out, _NORM)                         \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())            \
  const uint64_t *qe_0 = q + ((cnt >> 1) << 2);                              \
  const uint64_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 2) : qe_0);           \
  const uint64_t *qe_2 = q + (cnt << 1);                                     \
  if (((uintptr_t)m & 0x1f) == 0 && ((uintptr_t)q & 0x1f) == 0) {            \
    for (; q != qe_1; m += 4, q += 4) {                                      \
      MATRIX_INT64_ITER_2X2_AVX(m, q, ymm_sum, _mm256_load_si256,            \
                                POPCNT_UINT64_STEP1_AVX)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)             \
    for (; q != qe_0; m += 4, q += 4) {                                      \
      MATRIX_INT64_ITER_2X2_AVX(m, q, ymm_sum, _mm256_load_si256,            \
                                POPCNT_UINT64_STEP2_AVX)                     \
    }                                                                        \
  } else {                                                                   \
    for (; q != qe_1; m += 4, q += 4) {                                      \
      MATRIX_INT64_ITER_2X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,           \
                                POPCNT_UINT64_STEP1_AVX)                     \
    }                                                                        \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)             \
    for (; q != qe_0; m += 4, q += 4) {                                      \
      MATRIX_INT64_ITER_2X2_AVX(m, q, ymm_sum, _mm256_loadu_si256,           \
                                POPCNT_UINT64_STEP2_AVX)                     \
    }                                                                        \
  }                                                                          \
  ymm_sum_0_0 = _mm256_add_epi64(                                            \
      _mm256_inserti128_si256(ymm_sum_0_0,                                   \
                              _mm256_castsi256_si128(ymm_sum_0_1), 1),       \
      _mm256_inserti128_si256(ymm_sum_0_1,                                   \
                              _mm256_extractf128_si256(ymm_sum_0_0, 1), 0)); \
  if (q != qe_2) {                                                           \
    __m256i ymm_m = _mm256_set_epi64x(m[1], m[0], m[1], m[0]);               \
    __m256i ymm_q = _mm256_set_epi64x(q[1], q[1], q[0], q[0]);               \
    POPCNT_UINT64_STEP2_AVX(ymm_m, ymm_q, ymm_sum_0_0)                       \
  }                                                                          \
  if (((uintptr_t)out & 0xf) == 0) {                                         \
    MATRIX_VAR_STORE(1, 1, 4, ymm_sum, out, _mm_store_ps, _NORM)             \
  } else {                                                                   \
    MATRIX_VAR_STORE(1, 1, 4, ymm_sum, out, _mm_storeu_ps, _NORM)            \
  }

//! Compute the distance between matrix and query (UINT64, M=4, N=1)
#define POPCNT_UINT64_4X1_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(2, 1, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + ((cnt >> 1) << 1);                    \
  const uint64_t *qe_1 = (cnt > 31 ? q + ((31 >> 1) << 1) : qe_0); \
  const uint64_t *qe_2 = q + cnt;                                  \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_4X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_4X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
    if (q != qe_2) {                                               \
      __m256i ymm_m = _mm256_load_si256((const __m256i *)(m));     \
      __m256i ymm_q = _mm256_broadcast_si64(q);                    \
      POPCNT_UINT64_STEP2_AVX(ymm_m, ymm_q, ymm_sum_0_0)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_4X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_4X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
    if (q != qe_2) {                                               \
      __m256i ymm_m = _mm256_loadu_si256((const __m256i *)(m));    \
      __m256i ymm_q = _mm256_broadcast_si64(q);                    \
      POPCNT_UINT64_STEP2_AVX(ymm_m, ymm_q, ymm_sum_0_0)           \
    }                                                              \
  }                                                                \
  ymm_sum_0_0 = _mm256_add_epi64(ymm_sum_0_0, ymm_sum_1_0);        \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(1, 1, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(1, 1, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=4, N=2)
#define POPCNT_UINT64_4X2_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + (cnt << 1);                           \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);        \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 4, q += 2) {                            \
      MATRIX_INT64_ITER_4X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 4, q += 2) {                            \
      MATRIX_INT64_ITER_4X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 4, q += 2) {                            \
      MATRIX_INT64_ITER_4X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(1, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 4, q += 2) {                            \
      MATRIX_INT64_ITER_4X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(1, 2, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(1, 2, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=4, N=4)
#define POPCNT_UINT64_4X4_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(1, 4, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + (cnt << 2);                           \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);        \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 4, q += 4) {                            \
      MATRIX_INT64_ITER_4X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 4, q += 4) {                            \
      MATRIX_INT64_ITER_4X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 4, q += 4) {                            \
      MATRIX_INT64_ITER_4X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(1, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 4, q += 4) {                            \
      MATRIX_INT64_ITER_4X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(1, 4, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(1, 4, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=8, N=1)
#define POPCNT_UINT64_8X1_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(2, 1, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + cnt;                                  \
  const uint64_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);               \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 8, ++q) {                               \
      MATRIX_INT64_ITER_8X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, ++q) {                               \
      MATRIX_INT64_ITER_8X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 8, ++q) {                               \
      MATRIX_INT64_ITER_8X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, ++q) {                               \
      MATRIX_INT64_ITER_8X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(2, 1, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(2, 1, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=8, N=2)
#define POPCNT_UINT64_8X2_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(2, 2, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + (cnt << 1);                           \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);        \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_8X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_8X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_8X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 2) {                            \
      MATRIX_INT64_ITER_8X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(2, 2, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(2, 2, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=8, N=4)
#define POPCNT_UINT64_8X4_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(2, 4, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + (cnt << 2);                           \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);        \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 8, q += 4) {                            \
      MATRIX_INT64_ITER_8X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 4) {                            \
      MATRIX_INT64_ITER_8X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 8, q += 4) {                            \
      MATRIX_INT64_ITER_8X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 4) {                            \
      MATRIX_INT64_ITER_8X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(2, 4, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(2, 4, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=8, N=8)
#define POPCNT_UINT64_8X8_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(2, 8, __m256i, ymm_sum, _mm256_setzero_si256())  \
  const uint64_t *qe_0 = q + (cnt << 3);                           \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);        \
  if (((uintptr_t)m & 0x1f) == 0) {                                \
    for (; q != qe_1; m += 8, q += 8) {                            \
      MATRIX_INT64_ITER_8X8_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 8, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 8) {                            \
      MATRIX_INT64_ITER_8X8_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  } else {                                                         \
    for (; q != qe_1; m += 8, q += 8) {                            \
      MATRIX_INT64_ITER_8X8_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP1_AVX)           \
    }                                                              \
    MATRIX_VAR_PERMUTE(2, 8, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)   \
    for (; q != qe_0; m += 8, q += 8) {                            \
      MATRIX_INT64_ITER_8X8_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                POPCNT_UINT64_STEP2_AVX)           \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(2, 8, 4, ymm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(2, 8, 4, ymm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (UINT64, M=16, N=1)
#define POPCNT_UINT64_16X1_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(4, 1, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + cnt;                                   \
  const uint64_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);                \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 16, ++q) {                               \
      MATRIX_INT64_ITER_16X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, ++q) {                               \
      MATRIX_INT64_ITER_16X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 16, ++q) {                               \
      MATRIX_INT64_ITER_16X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, ++q) {                               \
      MATRIX_INT64_ITER_16X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(4, 1, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(4, 1, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=16, N=2)
#define POPCNT_UINT64_16X2_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(4, 2, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 1);                            \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);         \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 16, q += 2) {                            \
      MATRIX_INT64_ITER_16X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 2) {                            \
      MATRIX_INT64_ITER_16X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 16, q += 2) {                            \
      MATRIX_INT64_ITER_16X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 2) {                            \
      MATRIX_INT64_ITER_16X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(4, 2, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(4, 2, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=16, N=4)
#define POPCNT_UINT64_16X4_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(4, 4, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 2);                            \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);         \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 16, q += 4) {                            \
      MATRIX_INT64_ITER_16X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 4) {                            \
      MATRIX_INT64_ITER_16X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 16, q += 4) {                            \
      MATRIX_INT64_ITER_16X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 4) {                            \
      MATRIX_INT64_ITER_16X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(4, 4, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(4, 4, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=16, N=8)
#define POPCNT_UINT64_16X8_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(4, 8, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 3);                            \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);         \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 16, q += 8) {                            \
      MATRIX_INT64_ITER_16X8_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 8, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 8) {                            \
      MATRIX_INT64_ITER_16X8_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 16, q += 8) {                            \
      MATRIX_INT64_ITER_16X8_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(4, 8, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 8) {                            \
      MATRIX_INT64_ITER_16X8_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(4, 8, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(4, 8, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=16, N=16)
#define POPCNT_UINT64_16X16_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(4, 16, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 4);                             \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 4) : qe_0);          \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 16, q += 16) {                            \
      MATRIX_INT64_ITER_16X16_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                  POPCNT_UINT64_STEP1_AVX)           \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 16, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 16) {                            \
      MATRIX_INT64_ITER_16X16_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                  POPCNT_UINT64_STEP2_AVX)           \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 16, q += 16) {                            \
      MATRIX_INT64_ITER_16X16_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                  POPCNT_UINT64_STEP1_AVX)           \
    }                                                                \
    MATRIX_VAR_PERMUTE(4, 16, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 16, q += 16) {                            \
      MATRIX_INT64_ITER_16X16_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                  POPCNT_UINT64_STEP2_AVX)           \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0xf) == 0) {                                 \
    MATRIX_VAR_STORE(4, 16, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                           \
    MATRIX_VAR_STORE(4, 16, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=32, N=1)
#define POPCNT_UINT64_32X1_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(8, 1, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + cnt;                                   \
  const uint64_t *qe_1 = (cnt > 31 ? q + 31 : qe_0);                \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 32, ++q) {                               \
      MATRIX_INT64_ITER_32X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, ++q) {                               \
      MATRIX_INT64_ITER_32X1_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 32, ++q) {                               \
      MATRIX_INT64_ITER_32X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 1, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, ++q) {                               \
      MATRIX_INT64_ITER_32X1_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(8, 1, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(8, 1, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=32, N=2)
#define POPCNT_UINT64_32X2_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(8, 2, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 1);                            \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 1) : qe_0);         \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 32, q += 2) {                            \
      MATRIX_INT64_ITER_32X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 2) {                            \
      MATRIX_INT64_ITER_32X2_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 32, q += 2) {                            \
      MATRIX_INT64_ITER_32X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 2, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 2) {                            \
      MATRIX_INT64_ITER_32X2_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(8, 2, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(8, 2, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=32, N=4)
#define POPCNT_UINT64_32X4_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(8, 4, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 2);                            \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 2) : qe_0);         \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 32, q += 4) {                            \
      MATRIX_INT64_ITER_32X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 4) {                            \
      MATRIX_INT64_ITER_32X4_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 32, q += 4) {                            \
      MATRIX_INT64_ITER_32X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 4, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 4) {                            \
      MATRIX_INT64_ITER_32X4_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(8, 4, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(8, 4, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=32, N=8)
#define POPCNT_UINT64_32X8_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(8, 8, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 3);                            \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 3) : qe_0);         \
  if (((uintptr_t)m & 0x1f) == 0) {                                 \
    for (; q != qe_1; m += 32, q += 8) {                            \
      MATRIX_INT64_ITER_32X8_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 8, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 8) {                            \
      MATRIX_INT64_ITER_32X8_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  } else {                                                          \
    for (; q != qe_1; m += 32, q += 8) {                            \
      MATRIX_INT64_ITER_32X8_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP1_AVX)           \
    }                                                               \
    MATRIX_VAR_PERMUTE(8, 8, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 8) {                            \
      MATRIX_INT64_ITER_32X8_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                 POPCNT_UINT64_STEP2_AVX)           \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(8, 8, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                          \
    MATRIX_VAR_STORE(8, 8, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=32, N=16)
#define POPCNT_UINT64_32X16_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(8, 16, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 4);                             \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 4) : qe_0);          \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 32, q += 16) {                            \
      MATRIX_INT64_ITER_32X16_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                  POPCNT_UINT64_STEP1_AVX)           \
    }                                                                \
    MATRIX_VAR_PERMUTE(8, 16, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 16) {                            \
      MATRIX_INT64_ITER_32X16_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                  POPCNT_UINT64_STEP2_AVX)           \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 32, q += 16) {                            \
      MATRIX_INT64_ITER_32X16_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                  POPCNT_UINT64_STEP1_AVX)           \
    }                                                                \
    MATRIX_VAR_PERMUTE(8, 16, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 16) {                            \
      MATRIX_INT64_ITER_32X16_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                  POPCNT_UINT64_STEP2_AVX)           \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0xf) == 0) {                                 \
    MATRIX_VAR_STORE(8, 16, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                           \
    MATRIX_VAR_STORE(8, 16, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }

//! Compute the distance between matrix and query (UINT64, M=32, N=32)
#define POPCNT_UINT64_32X32_AVX(m, q, cnt, out, _NORM)               \
  MATRIX_VAR_INIT(8, 32, __m256i, ymm_sum, _mm256_setzero_si256())   \
  const uint64_t *qe_0 = q + (cnt << 5);                             \
  const uint64_t *qe_1 = (cnt > 31 ? q + (31 << 5) : qe_0);          \
  if (((uintptr_t)m & 0x1f) == 0) {                                  \
    for (; q != qe_1; m += 32, q += 32) {                            \
      MATRIX_INT64_ITER_32X32_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                  POPCNT_UINT64_STEP1_AVX)           \
    }                                                                \
    MATRIX_VAR_PERMUTE(8, 32, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 32) {                            \
      MATRIX_INT64_ITER_32X32_AVX(m, q, ymm_sum, _mm256_load_si256,  \
                                  POPCNT_UINT64_STEP2_AVX)           \
    }                                                                \
  } else {                                                           \
    for (; q != qe_1; m += 32, q += 32) {                            \
      MATRIX_INT64_ITER_32X32_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                  POPCNT_UINT64_STEP1_AVX)           \
    }                                                                \
    MATRIX_VAR_PERMUTE(8, 32, ymm_sum, POPCNT_UINT64_PERMUTE_AVX)    \
    for (; q != qe_0; m += 32, q += 32) {                            \
      MATRIX_INT64_ITER_32X32_AVX(m, q, ymm_sum, _mm256_loadu_si256, \
                                  POPCNT_UINT64_STEP2_AVX)           \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0xf) == 0) {                                 \
    MATRIX_VAR_STORE(8, 32, 4, ymm_sum, out, _mm_store_ps, _NORM)    \
  } else {                                                           \
    MATRIX_VAR_STORE(8, 32, 4, ymm_sum, out, _mm_storeu_ps, _NORM)   \
  }
