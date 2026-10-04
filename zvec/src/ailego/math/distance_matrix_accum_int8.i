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
#include "matrix_utility.i"

//! Compute the distance between matrix and query (INT8, M=2, N=1)
#define ACCUM_INT8_2X1_SSE(m, q, dim, out, _NORM)                            \
  MATRIX_VAR_INIT(1, 2, __m128i, xmm_sum, _mm_setzero_si128())               \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);                \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);                \
  const uint32_t *qe_aligned = qi + ((dim >> 4) << 2);                       \
  const uint32_t *qe = qi + (dim >> 2);                                      \
  if (((uintptr_t)mi & 0xf) == 0 && ((uintptr_t)qi & 0xf) == 0) {            \
    for (; qi != qe_aligned; mi += 8, qi += 4) {                             \
      MATRIX_INT32_ITER_2X1_SSE(mi, qi, xmm_sum, _mm_load_si128,             \
                                ACCUM_INT8_STEP_SSE)                         \
    }                                                                        \
    if (qe >= qe_aligned + 2) {                                              \
      __m128i xmm_mi = _mm_load_si128((const __m128i *)(mi));                \
      __m128i xmm_qi = _mm_set_epi32(qi[1], qi[1], qi[0], qi[0]);            \
      ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                       \
      mi += 4;                                                               \
      qi += 2;                                                               \
    }                                                                        \
  } else {                                                                   \
    for (; qi != qe_aligned; mi += 8, qi += 4) {                             \
      MATRIX_INT32_ITER_2X1_SSE(mi, qi, xmm_sum, _mm_loadu_si128,            \
                                ACCUM_INT8_STEP_SSE)                         \
    }                                                                        \
    if (qe >= qe_aligned + 2) {                                              \
      __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));               \
      __m128i xmm_qi = _mm_set_epi32(qi[1], qi[1], qi[0], qi[0]);            \
      ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                       \
      mi += 4;                                                               \
      qi += 2;                                                               \
    }                                                                        \
  }                                                                          \
  xmm_sum_0_0 = _mm_add_epi32(xmm_sum_0_0, xmm_sum_0_1);                     \
  xmm_sum_0_0 = _mm_add_epi32(                                               \
      xmm_sum_0_0, _mm_shuffle_epi32(xmm_sum_0_0, _MM_SHUFFLE(0, 0, 3, 2))); \
  if (qi != qe) {                                                            \
    __m128i xmm_mi = _mm_set_epi32(0, 0, mi[1], mi[0]);                      \
    __m128i xmm_qi = _mm_broadcast_si32(qi);                                 \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                         \
  }                                                                          \
  _mm_storel_pi((__m64 *)out, _NORM(xmm_sum_0_0));

//! Compute the distance between matrix and query (INT8, M=2, N=2)
#define ACCUM_INT8_2X2_SSE(m, q, dim, out, _NORM)                            \
  MATRIX_VAR_INIT(1, 2, __m128i, xmm_sum, _mm_setzero_si128())               \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);                \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);                \
  const uint32_t *qe = qi + ((dim >> 2) << 1);                               \
  if (((uintptr_t)mi & 0xf) == 0 && ((uintptr_t)qi & 0xf) == 0) {            \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 2);                \
         qi != qe_aligned; mi += 4, qi += 4) {                               \
      MATRIX_INT32_ITER_2X2_SSE(mi, qi, xmm_sum, _mm_load_si128,             \
                                ACCUM_INT8_STEP_SSE)                         \
    }                                                                        \
  } else {                                                                   \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 2);                \
         qi != qe_aligned; mi += 4, qi += 4) {                               \
      MATRIX_INT32_ITER_2X2_SSE(mi, qi, xmm_sum, _mm_loadu_si128,            \
                                ACCUM_INT8_STEP_SSE)                         \
    }                                                                        \
  }                                                                          \
  xmm_sum_0_0 = _mm_add_epi32(_mm_unpacklo_epi64(xmm_sum_0_0, xmm_sum_0_1),  \
                              _mm_unpackhi_epi64(xmm_sum_0_0, xmm_sum_0_1)); \
  if (qi != qe) {                                                            \
    __m128i xmm_mi = _mm_set_epi32(mi[1], mi[0], mi[1], mi[0]);              \
    __m128i xmm_qi = _mm_set_epi32(qi[1], qi[1], qi[0], qi[0]);              \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                         \
  }                                                                          \
  if (((uintptr_t)out & 0xf) == 0) {                                         \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)             \
  } else {                                                                   \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)            \
  }

//! Compute the distance between matrix and query (INT8, M=4, N=1)
#define ACCUM_INT8_4X1_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(2, 1, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);     \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);     \
  const uint32_t *qe = qi + (dim >> 2);                           \
  if (((uintptr_t)mi & 0xf) == 0) {                               \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 1);     \
         qi != qe_aligned; mi += 8, qi += 2) {                    \
      MATRIX_INT32_ITER_4X1_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
    if (qi != qe) {                                               \
      __m128i xmm_mi = _mm_load_si128((const __m128i *)(mi));     \
      __m128i xmm_qi = _mm_broadcast_si32(qi);                    \
      ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)            \
    }                                                             \
  } else {                                                        \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 1);     \
         qi != qe_aligned; mi += 8, qi += 2) {                    \
      MATRIX_INT32_ITER_4X1_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
    if (qi != qe) {                                               \
      __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));    \
      __m128i xmm_qi = _mm_broadcast_si32(qi);                    \
      ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)            \
    }                                                             \
  }                                                               \
  xmm_sum_0_0 = _mm_add_epi32(xmm_sum_0_0, xmm_sum_1_0);          \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=4, N=2)
#define ACCUM_INT8_4X2_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(1, 2, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);     \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);     \
  if (((uintptr_t)mi & 0xf) == 0) {                               \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;   \
         mi += 4, qi += 2) {                                      \
      MATRIX_INT32_ITER_4X2_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  } else {                                                        \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;   \
         mi += 4, qi += 2) {                                      \
      MATRIX_INT32_ITER_4X2_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=4, N=4)
#define ACCUM_INT8_4X4_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(1, 4, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);     \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);     \
  if (((uintptr_t)mi & 0xf) == 0) {                               \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;   \
         mi += 4, qi += 4) {                                      \
      MATRIX_INT32_ITER_4X4_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  } else {                                                        \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;   \
         mi += 4, qi += 4) {                                      \
      MATRIX_INT32_ITER_4X4_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=1)
#define ACCUM_INT8_8X1_SSE(m, q, dim, out, _NORM)                         \
  MATRIX_VAR_INIT(2, 1, __m128i, xmm_sum, _mm_setzero_si128())            \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);             \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);             \
  if (((uintptr_t)mi & 0xf) == 0) {                                       \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 8, ++qi) { \
      MATRIX_INT32_ITER_8X1_SSE(mi, qi, xmm_sum, _mm_load_si128,          \
                                ACCUM_INT8_STEP_SSE)                      \
    }                                                                     \
  } else {                                                                \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 8, ++qi) { \
      MATRIX_INT32_ITER_8X1_SSE(mi, qi, xmm_sum, _mm_loadu_si128,         \
                                ACCUM_INT8_STEP_SSE)                      \
    }                                                                     \
  }                                                                       \
  if (((uintptr_t)out & 0xf) == 0) {                                      \
    MATRIX_VAR_STORE(2, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)          \
  } else {                                                                \
    MATRIX_VAR_STORE(2, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)         \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=2)
#define ACCUM_INT8_8X2_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(2, 2, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);     \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);     \
  if (((uintptr_t)mi & 0xf) == 0) {                               \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;   \
         mi += 8, qi += 2) {                                      \
      MATRIX_INT32_ITER_8X2_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  } else {                                                        \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;   \
         mi += 8, qi += 2) {                                      \
      MATRIX_INT32_ITER_8X2_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=4)
#define ACCUM_INT8_8X4_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(2, 4, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);     \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);     \
  if (((uintptr_t)mi & 0xf) == 0) {                               \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;   \
         mi += 8, qi += 4) {                                      \
      MATRIX_INT32_ITER_8X4_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  } else {                                                        \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;   \
         mi += 8, qi += 4) {                                      \
      MATRIX_INT32_ITER_8X4_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=8)
#define ACCUM_INT8_8X8_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(2, 8, __m128i, xmm_sum, _mm_setzero_si128())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);     \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);     \
  if (((uintptr_t)mi & 0xf) == 0) {                               \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;   \
         mi += 8, qi += 8) {                                      \
      MATRIX_INT32_ITER_8X8_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  } else {                                                        \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;   \
         mi += 8, qi += 8) {                                      \
      MATRIX_INT32_ITER_8X8_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                ACCUM_INT8_STEP_SSE)              \
    }                                                             \
  }                                                               \
  if (((uintptr_t)out & 0xf) == 0) {                              \
    MATRIX_VAR_STORE(2, 8, 4, xmm_sum, out, _mm_store_ps, _NORM)  \
  } else {                                                        \
    MATRIX_VAR_STORE(2, 8, 4, xmm_sum, out, _mm_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=1)
#define ACCUM_INT8_16X1_SSE(m, q, dim, out, _NORM)                         \
  MATRIX_VAR_INIT(4, 1, __m128i, xmm_sum, _mm_setzero_si128())             \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);              \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);              \
  if (((uintptr_t)mi & 0xf) == 0) {                                        \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 16, ++qi) { \
      MATRIX_INT32_ITER_16X1_SSE(mi, qi, xmm_sum, _mm_load_si128,          \
                                 ACCUM_INT8_STEP_SSE)                      \
    }                                                                      \
  } else {                                                                 \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 16, ++qi) { \
      MATRIX_INT32_ITER_16X1_SSE(mi, qi, xmm_sum, _mm_loadu_si128,         \
                                 ACCUM_INT8_STEP_SSE)                      \
    }                                                                      \
  }                                                                        \
  if (((uintptr_t)out & 0xf) == 0) {                                       \
    MATRIX_VAR_STORE(4, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)           \
  } else {                                                                 \
    MATRIX_VAR_STORE(4, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)          \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=2)
#define ACCUM_INT8_16X2_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(4, 2, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);      \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);      \
  if (((uintptr_t)mi & 0xf) == 0) {                                \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;    \
         mi += 16, qi += 2) {                                      \
      MATRIX_INT32_ITER_16X2_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  } else {                                                         \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;    \
         mi += 16, qi += 2) {                                      \
      MATRIX_INT32_ITER_16X2_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(4, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(4, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=4)
#define ACCUM_INT8_16X4_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(4, 4, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);      \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);      \
  if (((uintptr_t)mi & 0xf) == 0) {                                \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;    \
         mi += 16, qi += 4) {                                      \
      MATRIX_INT32_ITER_16X4_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  } else {                                                         \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;    \
         mi += 16, qi += 4) {                                      \
      MATRIX_INT32_ITER_16X4_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(4, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(4, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=8)
#define ACCUM_INT8_16X8_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(4, 8, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);      \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);      \
  if (((uintptr_t)mi & 0xf) == 0) {                                \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;    \
         mi += 16, qi += 8) {                                      \
      MATRIX_INT32_ITER_16X8_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  } else {                                                         \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;    \
         mi += 16, qi += 8) {                                      \
      MATRIX_INT32_ITER_16X8_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(4, 8, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(4, 8, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=16)
#define ACCUM_INT8_16X16_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(4, 16, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);       \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);       \
  if (((uintptr_t)mi & 0xf) == 0) {                                 \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;     \
         mi += 16, qi += 16) {                                      \
      MATRIX_INT32_ITER_16X16_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                  ACCUM_INT8_STEP_SSE)              \
    }                                                               \
  } else {                                                          \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;     \
         mi += 16, qi += 16) {                                      \
      MATRIX_INT32_ITER_16X16_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                  ACCUM_INT8_STEP_SSE)              \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(4, 16, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                          \
    MATRIX_VAR_STORE(4, 16, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=1)
#define ACCUM_INT8_32X1_SSE(m, q, dim, out, _NORM)                         \
  MATRIX_VAR_INIT(8, 1, __m128i, xmm_sum, _mm_setzero_si128())             \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);              \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);              \
  if (((uintptr_t)mi & 0xf) == 0) {                                        \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 32, ++qi) { \
      MATRIX_INT32_ITER_32X1_SSE(mi, qi, xmm_sum, _mm_load_si128,          \
                                 ACCUM_INT8_STEP_SSE)                      \
    }                                                                      \
  } else {                                                                 \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 32, ++qi) { \
      MATRIX_INT32_ITER_32X1_SSE(mi, qi, xmm_sum, _mm_loadu_si128,         \
                                 ACCUM_INT8_STEP_SSE)                      \
    }                                                                      \
  }                                                                        \
  if (((uintptr_t)out & 0xf) == 0) {                                       \
    MATRIX_VAR_STORE(8, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)           \
  } else {                                                                 \
    MATRIX_VAR_STORE(8, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)          \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=2)
#define ACCUM_INT8_32X2_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(8, 2, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);      \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);      \
  if (((uintptr_t)mi & 0xf) == 0) {                                \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;    \
         mi += 32, qi += 2) {                                      \
      MATRIX_INT32_ITER_32X2_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  } else {                                                         \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;    \
         mi += 32, qi += 2) {                                      \
      MATRIX_INT32_ITER_32X2_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(8, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(8, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=4)
#define ACCUM_INT8_32X4_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(8, 4, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);      \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);      \
  if (((uintptr_t)mi & 0xf) == 0) {                                \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;    \
         mi += 32, qi += 4) {                                      \
      MATRIX_INT32_ITER_32X4_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  } else {                                                         \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;    \
         mi += 32, qi += 4) {                                      \
      MATRIX_INT32_ITER_32X4_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(8, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(8, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=8)
#define ACCUM_INT8_32X8_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(8, 8, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);      \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);      \
  if (((uintptr_t)mi & 0xf) == 0) {                                \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;    \
         mi += 32, qi += 8) {                                      \
      MATRIX_INT32_ITER_32X8_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  } else {                                                         \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;    \
         mi += 32, qi += 8) {                                      \
      MATRIX_INT32_ITER_32X8_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                 ACCUM_INT8_STEP_SSE)              \
    }                                                              \
  }                                                                \
  if (((uintptr_t)out & 0xf) == 0) {                               \
    MATRIX_VAR_STORE(8, 8, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                         \
    MATRIX_VAR_STORE(8, 8, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=16)
#define ACCUM_INT8_32X16_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(8, 16, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);       \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);       \
  if (((uintptr_t)mi & 0xf) == 0) {                                 \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;     \
         mi += 32, qi += 16) {                                      \
      MATRIX_INT32_ITER_32X16_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                  ACCUM_INT8_STEP_SSE)              \
    }                                                               \
  } else {                                                          \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;     \
         mi += 32, qi += 16) {                                      \
      MATRIX_INT32_ITER_32X16_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                  ACCUM_INT8_STEP_SSE)              \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(8, 16, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                          \
    MATRIX_VAR_STORE(8, 16, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=32)
#define ACCUM_INT8_32X32_SSE(m, q, dim, out, _NORM)                 \
  MATRIX_VAR_INIT(8, 32, __m128i, xmm_sum, _mm_setzero_si128())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);       \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);       \
  if (((uintptr_t)mi & 0xf) == 0) {                                 \
    for (const uint32_t *qe = qi + ((dim >> 2) << 5); qi != qe;     \
         mi += 32, qi += 32) {                                      \
      MATRIX_INT32_ITER_32X32_SSE(mi, qi, xmm_sum, _mm_load_si128,  \
                                  ACCUM_INT8_STEP_SSE)              \
    }                                                               \
  } else {                                                          \
    for (const uint32_t *qe = qi + ((dim >> 2) << 5); qi != qe;     \
         mi += 32, qi += 32) {                                      \
      MATRIX_INT32_ITER_32X32_SSE(mi, qi, xmm_sum, _mm_loadu_si128, \
                                  ACCUM_INT8_STEP_SSE)              \
    }                                                               \
  }                                                                 \
  if (((uintptr_t)out & 0xf) == 0) {                                \
    MATRIX_VAR_STORE(8, 32, 4, xmm_sum, out, _mm_store_ps, _NORM)   \
  } else {                                                          \
    MATRIX_VAR_STORE(8, 32, 4, xmm_sum, out, _mm_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=2, N=1)
#define ACCUM_INT8_2X1_AVX(m, q, dim, out, _NORM)                              \
  MATRIX_VAR_INIT(1, 1, __m256i, ymm_sum, _mm256_setzero_si256())              \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);                  \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);                  \
  const uint32_t *qe_aligned = qi + ((dim >> 4) << 2);                         \
  const uint32_t *qe = qi + (dim >> 2);                                        \
  if (((uintptr_t)mi & 0x1f) == 0) {                                           \
    for (; qi != qe_aligned; mi += 8, qi += 4) {                               \
      MATRIX_INT32_ITER_2X1_AVX(mi, qi, ymm_sum, _mm256_load_si256,            \
                                ACCUM_INT8_STEP_AVX)                           \
    }                                                                          \
  } else {                                                                     \
    for (; qi != qe_aligned; mi += 8, qi += 4) {                               \
      MATRIX_INT32_ITER_2X1_AVX(mi, qi, ymm_sum, _mm256_loadu_si256,           \
                                ACCUM_INT8_STEP_AVX)                           \
    }                                                                          \
  }                                                                            \
  __m128i xmm_sum_0 = _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),       \
                                    _mm256_extracti128_si256(ymm_sum_0_0, 1)); \
  if (qe >= qe_aligned + 2) {                                                  \
    __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));                   \
    __m128i xmm_qi = _mm_set_epi32(qi[1], qi[1], qi[0], qi[0]);                \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0)                             \
    mi += 4;                                                                   \
    qi += 2;                                                                   \
  }                                                                            \
  xmm_sum_0 = _mm_add_epi32(                                                   \
      xmm_sum_0, _mm_shuffle_epi32(xmm_sum_0, _MM_SHUFFLE(0, 0, 3, 2)));       \
  if (qi != qe) {                                                              \
    __m128i xmm_mi = _mm_set_epi32(0, 0, mi[1], mi[0]);                        \
    __m128i xmm_qi = _mm_broadcast_si32(qi);                                   \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0)                             \
  }                                                                            \
  _mm_storel_pi((__m64 *)out, _NORM(xmm_sum_0));

//! Compute the distance between matrix and query (INT8, M=2, N=2)
#define ACCUM_INT8_2X2_AVX(m, q, dim, out, _NORM)                            \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())            \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);                \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);                \
  const uint32_t *qe_aligned = qi + ((dim >> 4) << 3);                       \
  const uint32_t *qe = qi + ((dim >> 2) << 1);                               \
  if (((uintptr_t)mi & 0x1f) == 0 && ((uintptr_t)qi & 0x1f) == 0) {          \
    for (; qi != qe_aligned; mi += 8, qi += 8) {                             \
      MATRIX_INT32_ITER_2X2_AVX(mi, qi, ymm_sum, _mm256_load_si256,          \
                                ACCUM_INT8_STEP_AVX)                         \
    }                                                                        \
  } else {                                                                   \
    for (; qi != qe_aligned; mi += 8, qi += 8) {                             \
      MATRIX_INT32_ITER_2X2_AVX(mi, qi, ymm_sum, _mm256_loadu_si256,         \
                                ACCUM_INT8_STEP_AVX)                         \
    }                                                                        \
  }                                                                          \
  __m128i xmm_sum_0_0 =                                                      \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),                     \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));               \
  __m128i xmm_sum_0_1 =                                                      \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_1),                     \
                    _mm256_extracti128_si256(ymm_sum_0_1, 1));               \
  if (qe >= qe_aligned + 4) {                                                \
    __m128i xmm_qi = _mm_loadu_si128((const __m128i *)(qi));                 \
    __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));                 \
    __m128i xmm_pi = _mm_shuffle_epi32(xmm_qi, _MM_SHUFFLE(2, 2, 0, 0));     \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_pi, xmm_sum_0_0)                         \
    xmm_pi = _mm_shuffle_epi32(xmm_qi, _MM_SHUFFLE(3, 3, 1, 1));             \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_pi, xmm_sum_0_1)                         \
    mi += 4;                                                                 \
    qi += 4;                                                                 \
  }                                                                          \
  xmm_sum_0_0 = _mm_add_epi32(_mm_unpacklo_epi64(xmm_sum_0_0, xmm_sum_0_1),  \
                              _mm_unpackhi_epi64(xmm_sum_0_0, xmm_sum_0_1)); \
  if (qi != qe) {                                                            \
    __m128i xmm_mi = _mm_set_epi32(mi[1], mi[0], mi[1], mi[0]);              \
    __m128i xmm_qi = _mm_set_epi32(qi[1], qi[1], qi[0], qi[0]);              \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                         \
  }                                                                          \
  if (((uintptr_t)out & 0xf) == 0) {                                         \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)             \
  } else {                                                                   \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)            \
  }

//! Compute the distance between matrix and query (INT8, M=4, N=1)
#define ACCUM_INT8_4X1_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(1, 1, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);        \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);        \
  const uint32_t *qe = qi + (dim >> 2);                              \
  if (((uintptr_t)mi & 0x1f) == 0) {                                 \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 1);        \
         qi != qe_aligned; mi += 8, qi += 2) {                       \
      MATRIX_INT32_ITER_4X1_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  } else {                                                           \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 1);        \
         qi != qe_aligned; mi += 8, qi += 2) {                       \
      MATRIX_INT32_ITER_4X1_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  }                                                                  \
  __m128i xmm_sum_0_0 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),             \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));       \
  if (qi != qe) {                                                    \
    __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));         \
    __m128i xmm_qi = _mm_broadcast_si32(qi);                         \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                 \
  }                                                                  \
  if (((uintptr_t)out & 0xf) == 0) {                                 \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_store_ps, _NORM)     \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 1, 4, xmm_sum, out, _mm_storeu_ps, _NORM)    \
  }

//! Compute the distance between matrix and query (INT8, M=4, N=2)
#define ACCUM_INT8_4X2_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);        \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);        \
  const uint32_t *qe = qi + ((dim >> 2) << 1);                       \
  if (((uintptr_t)mi & 0x1f) == 0) {                                 \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 2);        \
         qi != qe_aligned; mi += 8, qi += 4) {                       \
      MATRIX_INT32_ITER_4X2_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  } else {                                                           \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 2);        \
         qi != qe_aligned; mi += 8, qi += 4) {                       \
      MATRIX_INT32_ITER_4X2_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  }                                                                  \
  __m128i xmm_sum_0_0 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),             \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));       \
  __m128i xmm_sum_0_1 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_1),             \
                    _mm256_extracti128_si256(ymm_sum_0_1, 1));       \
  if (qi != qe) {                                                    \
    __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));         \
    __m128i xmm_qi = _mm_broadcast_si32(qi);                         \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                 \
    xmm_qi = _mm_broadcast_si32(qi + 1);                             \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_1)                 \
  }                                                                  \
  if (((uintptr_t)out & 0xf) == 0) {                                 \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_store_ps, _NORM)     \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 2, 4, xmm_sum, out, _mm_storeu_ps, _NORM)    \
  }

//! Compute the distance between matrix and query (INT8, M=4, N=4)
#define ACCUM_INT8_4X4_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(1, 4, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);        \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);        \
  const uint32_t *qe = qi + ((dim >> 2) << 2);                       \
  if (((uintptr_t)mi & 0x1f) == 0 && ((uintptr_t)qi & 0x1f) == 0) {  \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 3);        \
         qi != qe_aligned; mi += 8, qi += 8) {                       \
      MATRIX_INT32_ITER_4X4_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  } else {                                                           \
    for (const uint32_t *qe_aligned = qi + ((dim >> 3) << 3);        \
         qi != qe_aligned; mi += 8, qi += 8) {                       \
      MATRIX_INT32_ITER_4X4_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  }                                                                  \
  __m128i xmm_sum_0_0 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_0),             \
                    _mm256_extracti128_si256(ymm_sum_0_0, 1));       \
  __m128i xmm_sum_0_1 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_1),             \
                    _mm256_extracti128_si256(ymm_sum_0_1, 1));       \
  __m128i xmm_sum_0_2 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_2),             \
                    _mm256_extracti128_si256(ymm_sum_0_2, 1));       \
  __m128i xmm_sum_0_3 =                                              \
      _mm_add_epi32(_mm256_castsi256_si128(ymm_sum_0_3),             \
                    _mm256_extracti128_si256(ymm_sum_0_3, 1));       \
  if (qi != qe) {                                                    \
    __m128i xmm_mi = _mm_loadu_si128((const __m128i *)(mi));         \
    __m128i xmm_qi = _mm_broadcast_si32(qi);                         \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_0)                 \
    xmm_qi = _mm_broadcast_si32(qi + 1);                             \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_1)                 \
    xmm_qi = _mm_broadcast_si32(qi + 2);                             \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_2)                 \
    xmm_qi = _mm_broadcast_si32(qi + 3);                             \
    ACCUM_INT8_STEP_SSE(xmm_mi, xmm_qi, xmm_sum_0_3)                 \
  }                                                                  \
  if (((uintptr_t)out & 0xf) == 0) {                                 \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_store_ps, _NORM)     \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 4, 4, xmm_sum, out, _mm_storeu_ps, _NORM)    \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=1)
#define ACCUM_INT8_8X1_AVX(m, q, dim, out, _NORM)                         \
  MATRIX_VAR_INIT(1, 1, __m256i, ymm_sum, _mm256_setzero_si256())         \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);             \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);             \
  if (((uintptr_t)mi & 0x1f) == 0) {                                      \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 8, ++qi) { \
      MATRIX_INT32_ITER_8X1_AVX(mi, qi, ymm_sum, _mm256_load_si256,       \
                                ACCUM_INT8_STEP_AVX)                      \
    }                                                                     \
  } else {                                                                \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 8, ++qi) { \
      MATRIX_INT32_ITER_8X1_AVX(mi, qi, ymm_sum, _mm256_loadu_si256,      \
                                ACCUM_INT8_STEP_AVX)                      \
    }                                                                     \
  }                                                                       \
  if (((uintptr_t)out & 0x1f) == 0) {                                     \
    MATRIX_VAR_STORE(1, 1, 8, ymm_sum, out, _mm256_store_ps, _NORM)       \
  } else {                                                                \
    MATRIX_VAR_STORE(1, 1, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)      \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=2)
#define ACCUM_INT8_8X2_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(1, 2, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);        \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);        \
  if (((uintptr_t)mi & 0x1f) == 0) {                                 \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;      \
         mi += 8, qi += 2) {                                         \
      MATRIX_INT32_ITER_8X2_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  } else {                                                           \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;      \
         mi += 8, qi += 2) {                                         \
      MATRIX_INT32_ITER_8X2_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 2, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 2, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=4)
#define ACCUM_INT8_8X4_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(1, 4, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);        \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);        \
  if (((uintptr_t)mi & 0x1f) == 0) {                                 \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;      \
         mi += 8, qi += 4) {                                         \
      MATRIX_INT32_ITER_8X4_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  } else {                                                           \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;      \
         mi += 8, qi += 4) {                                         \
      MATRIX_INT32_ITER_8X4_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 4, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 4, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=8, N=8)
#define ACCUM_INT8_8X8_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(1, 8, __m256i, ymm_sum, _mm256_setzero_si256())    \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);        \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);        \
  if (((uintptr_t)mi & 0x1f) == 0) {                                 \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;      \
         mi += 8, qi += 8) {                                         \
      MATRIX_INT32_ITER_8X8_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  } else {                                                           \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;      \
         mi += 8, qi += 8) {                                         \
      MATRIX_INT32_ITER_8X8_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                ACCUM_INT8_STEP_AVX)                 \
    }                                                                \
  }                                                                  \
  if (((uintptr_t)out & 0x1f) == 0) {                                \
    MATRIX_VAR_STORE(1, 8, 8, ymm_sum, out, _mm256_store_ps, _NORM)  \
  } else {                                                           \
    MATRIX_VAR_STORE(1, 8, 8, ymm_sum, out, _mm256_storeu_ps, _NORM) \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=1)
#define ACCUM_INT8_16X1_AVX(m, q, dim, out, _NORM)                         \
  MATRIX_VAR_INIT(2, 1, __m256i, ymm_sum, _mm256_setzero_si256())          \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);              \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);              \
  if (((uintptr_t)mi & 0x1f) == 0) {                                       \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 16, ++qi) { \
      MATRIX_INT32_ITER_16X1_AVX(mi, qi, ymm_sum, _mm256_load_si256,       \
                                 ACCUM_INT8_STEP_AVX)                      \
    }                                                                      \
  } else {                                                                 \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 16, ++qi) { \
      MATRIX_INT32_ITER_16X1_AVX(mi, qi, ymm_sum, _mm256_loadu_si256,      \
                                 ACCUM_INT8_STEP_AVX)                      \
    }                                                                      \
  }                                                                        \
  if (((uintptr_t)out & 0x1f) == 0) {                                      \
    MATRIX_VAR_STORE(2, 1, 8, ymm_sum, out, _mm256_store_ps, _NORM)        \
  } else {                                                                 \
    MATRIX_VAR_STORE(2, 1, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)       \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=2)
#define ACCUM_INT8_16X2_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(2, 2, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);         \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);         \
  if (((uintptr_t)mi & 0x1f) == 0) {                                  \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;       \
         mi += 16, qi += 2) {                                         \
      MATRIX_INT32_ITER_16X2_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  } else {                                                            \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;       \
         mi += 16, qi += 2) {                                         \
      MATRIX_INT32_ITER_16X2_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(2, 2, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                            \
    MATRIX_VAR_STORE(2, 2, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=4)
#define ACCUM_INT8_16X4_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(2, 4, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);         \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);         \
  if (((uintptr_t)mi & 0x1f) == 0) {                                  \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;       \
         mi += 16, qi += 4) {                                         \
      MATRIX_INT32_ITER_16X4_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  } else {                                                            \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;       \
         mi += 16, qi += 4) {                                         \
      MATRIX_INT32_ITER_16X4_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(2, 4, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                            \
    MATRIX_VAR_STORE(2, 4, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=8)
#define ACCUM_INT8_16X8_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(2, 8, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);         \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);         \
  if (((uintptr_t)mi & 0x1f) == 0) {                                  \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;       \
         mi += 16, qi += 8) {                                         \
      MATRIX_INT32_ITER_16X8_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  } else {                                                            \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;       \
         mi += 16, qi += 8) {                                         \
      MATRIX_INT32_ITER_16X8_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(2, 8, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                            \
    MATRIX_VAR_STORE(2, 8, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=16, N=16)
#define ACCUM_INT8_16X16_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(2, 16, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);          \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);          \
  if (((uintptr_t)mi & 0x1f) == 0) {                                   \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;        \
         mi += 16, qi += 16) {                                         \
      MATRIX_INT32_ITER_16X16_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                  ACCUM_INT8_STEP_AVX)                 \
    }                                                                  \
  } else {                                                             \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;        \
         mi += 16, qi += 16) {                                         \
      MATRIX_INT32_ITER_16X16_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                  ACCUM_INT8_STEP_AVX)                 \
    }                                                                  \
  }                                                                    \
  if (((uintptr_t)out & 0x1f) == 0) {                                  \
    MATRIX_VAR_STORE(2, 16, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                             \
    MATRIX_VAR_STORE(2, 16, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=1)
#define ACCUM_INT8_32X1_AVX(m, q, dim, out, _NORM)                         \
  MATRIX_VAR_INIT(4, 1, __m256i, ymm_sum, _mm256_setzero_si256())          \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);              \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);              \
  if (((uintptr_t)mi & 0x1f) == 0) {                                       \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 32, ++qi) { \
      MATRIX_INT32_ITER_32X1_AVX(mi, qi, ymm_sum, _mm256_load_si256,       \
                                 ACCUM_INT8_STEP_AVX)                      \
    }                                                                      \
  } else {                                                                 \
    for (const uint32_t *qe = qi + (dim >> 2); qi != qe; mi += 32, ++qi) { \
      MATRIX_INT32_ITER_32X1_AVX(mi, qi, ymm_sum, _mm256_loadu_si256,      \
                                 ACCUM_INT8_STEP_AVX)                      \
    }                                                                      \
  }                                                                        \
  if (((uintptr_t)out & 0x1f) == 0) {                                      \
    MATRIX_VAR_STORE(4, 1, 8, ymm_sum, out, _mm256_store_ps, _NORM)        \
  } else {                                                                 \
    MATRIX_VAR_STORE(4, 1, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)       \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=2)
#define ACCUM_INT8_32X2_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(4, 2, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);         \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);         \
  if (((uintptr_t)mi & 0x1f) == 0) {                                  \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;       \
         mi += 32, qi += 2) {                                         \
      MATRIX_INT32_ITER_32X2_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  } else {                                                            \
    for (const uint32_t *qe = qi + ((dim >> 2) << 1); qi != qe;       \
         mi += 32, qi += 2) {                                         \
      MATRIX_INT32_ITER_32X2_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(4, 2, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                            \
    MATRIX_VAR_STORE(4, 2, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=4)
#define ACCUM_INT8_32X4_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(4, 4, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);         \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);         \
  if (((uintptr_t)mi & 0x1f) == 0) {                                  \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;       \
         mi += 32, qi += 4) {                                         \
      MATRIX_INT32_ITER_32X4_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  } else {                                                            \
    for (const uint32_t *qe = qi + ((dim >> 2) << 2); qi != qe;       \
         mi += 32, qi += 4) {                                         \
      MATRIX_INT32_ITER_32X4_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(4, 4, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                            \
    MATRIX_VAR_STORE(4, 4, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=8)
#define ACCUM_INT8_32X8_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(4, 8, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);         \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);         \
  if (((uintptr_t)mi & 0x1f) == 0) {                                  \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;       \
         mi += 32, qi += 8) {                                         \
      MATRIX_INT32_ITER_32X8_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  } else {                                                            \
    for (const uint32_t *qe = qi + ((dim >> 2) << 3); qi != qe;       \
         mi += 32, qi += 8) {                                         \
      MATRIX_INT32_ITER_32X8_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                 ACCUM_INT8_STEP_AVX)                 \
    }                                                                 \
  }                                                                   \
  if (((uintptr_t)out & 0x1f) == 0) {                                 \
    MATRIX_VAR_STORE(4, 8, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                            \
    MATRIX_VAR_STORE(4, 8, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=16)
#define ACCUM_INT8_32X16_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(4, 16, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);          \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);          \
  if (((uintptr_t)mi & 0x1f) == 0) {                                   \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;        \
         mi += 32, qi += 16) {                                         \
      MATRIX_INT32_ITER_32X16_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                  ACCUM_INT8_STEP_AVX)                 \
    }                                                                  \
  } else {                                                             \
    for (const uint32_t *qe = qi + ((dim >> 2) << 4); qi != qe;        \
         mi += 32, qi += 16) {                                         \
      MATRIX_INT32_ITER_32X16_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                  ACCUM_INT8_STEP_AVX)                 \
    }                                                                  \
  }                                                                    \
  if (((uintptr_t)out & 0x1f) == 0) {                                  \
    MATRIX_VAR_STORE(4, 16, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                             \
    MATRIX_VAR_STORE(4, 16, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }

//! Compute the distance between matrix and query (INT8, M=32, N=32)
#define ACCUM_INT8_32X32_AVX(m, q, dim, out, _NORM)                    \
  MATRIX_VAR_INIT(4, 32, __m256i, ymm_sum, _mm256_setzero_si256())     \
  const uint32_t *qi = reinterpret_cast<const uint32_t *>(q);          \
  const uint32_t *mi = reinterpret_cast<const uint32_t *>(m);          \
  if (((uintptr_t)mi & 0x1f) == 0) {                                   \
    for (const uint32_t *qe = qi + ((dim >> 2) << 5); qi != qe;        \
         mi += 32, qi += 32) {                                         \
      MATRIX_INT32_ITER_32X32_AVX(mi, qi, ymm_sum, _mm256_load_si256,  \
                                  ACCUM_INT8_STEP_AVX)                 \
    }                                                                  \
  } else {                                                             \
    for (const uint32_t *qe = qi + ((dim >> 2) << 5); qi != qe;        \
         mi += 32, qi += 32) {                                         \
      MATRIX_INT32_ITER_32X32_AVX(mi, qi, ymm_sum, _mm256_loadu_si256, \
                                  ACCUM_INT8_STEP_AVX)                 \
    }                                                                  \
  }                                                                    \
  if (((uintptr_t)out & 0x1f) == 0) {                                  \
    MATRIX_VAR_STORE(4, 32, 8, ymm_sum, out, _mm256_store_ps, _NORM)   \
  } else {                                                             \
    MATRIX_VAR_STORE(4, 32, 8, ymm_sum, out, _mm256_storeu_ps, _NORM)  \
  }
