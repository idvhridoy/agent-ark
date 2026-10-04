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

#include "db/index/common/meta.h"
#include <gtest/gtest.h>

using namespace zvec;

TEST(SegmentMetaTest, DefaultConstruction) {
  SegmentMeta segment_meta;
  EXPECT_EQ(segment_meta.id(), 0u);
  EXPECT_TRUE(segment_meta.persisted_blocks().empty());
  EXPECT_FALSE(segment_meta.has_writing_forward_block());
  EXPECT_EQ(segment_meta.min_doc_id(), 0u);
  EXPECT_EQ(segment_meta.max_doc_id(), 0u);
  EXPECT_EQ(segment_meta.doc_count(), 0u);
  EXPECT_TRUE(segment_meta.indexed_vector_fields().empty());
}

TEST(SegmentMetaTest, ConstructionWithID) {
  SegmentMeta segment_meta(42);
  EXPECT_EQ(segment_meta.id(), 42u);
  EXPECT_TRUE(segment_meta.persisted_blocks().empty());
  EXPECT_FALSE(segment_meta.has_writing_forward_block());
  EXPECT_EQ(segment_meta.min_doc_id(), 0u);
  EXPECT_EQ(segment_meta.max_doc_id(), 0u);
  EXPECT_EQ(segment_meta.doc_count(), 0u);
  EXPECT_TRUE(segment_meta.indexed_vector_fields().empty());
}

TEST(SegmentMetaTest, PersistedBlocksOperations) {
  SegmentMeta segment_meta(1);

  // Add persisted blocks
  BlockMeta block1(1, BlockType::SCALAR, 0, 100);
  block1.set_doc_count(50);
  block1.add_column("col1");
  block1.add_column("col2");

  BlockMeta block2(2, BlockType::VECTOR_INDEX, 101, 200);
  block2.set_doc_count(75);
  block2.add_column("vec_col");

  segment_meta.add_persisted_block(block1);
  segment_meta.add_persisted_block(block2);

  EXPECT_EQ(segment_meta.persisted_blocks().size(), 2u);

  const auto &blocks = segment_meta.persisted_blocks();
  EXPECT_EQ(blocks[0].id(), 1u);
  EXPECT_EQ(blocks[0].type(), BlockType::SCALAR);
  EXPECT_EQ(blocks[0].min_doc_id(), 0u);
  EXPECT_EQ(blocks[0].max_doc_id(), 100u);
  EXPECT_EQ(blocks[0].doc_count(), 50u);
  EXPECT_EQ(blocks[0].columns().size(), 2u);

  EXPECT_EQ(blocks[1].id(), 2u);
  EXPECT_EQ(blocks[1].type(), BlockType::VECTOR_INDEX);
  EXPECT_EQ(blocks[1].min_doc_id(), 101u);
  EXPECT_EQ(blocks[1].max_doc_id(), 200u);
  EXPECT_EQ(blocks[1].doc_count(), 75u);
  EXPECT_EQ(blocks[1].columns().size(), 1u);
}

TEST(SegmentMetaTest, WritingForwardBlockOperations) {
  SegmentMeta segment_meta(1);

  // Initially no writing forward block
  EXPECT_FALSE(segment_meta.has_writing_forward_block());

  // Set writing forward block
  BlockMeta writing_block(3, BlockType::SCALAR, 201, 300);
  writing_block.set_doc_count(25);
  writing_block.add_column("col3");

  segment_meta.set_writing_forward_block(writing_block);

  // Now should have writing forward block
  EXPECT_TRUE(segment_meta.has_writing_forward_block());

  const auto &wfb = segment_meta.writing_forward_block();
  EXPECT_EQ(wfb.value().id(), 3u);
  EXPECT_EQ(wfb.value().type(), BlockType::SCALAR);
  EXPECT_EQ(wfb.value().min_doc_id(), 201u);
  EXPECT_EQ(wfb.value().max_doc_id(), 300u);
  EXPECT_EQ(wfb.value().doc_count(), 25u);
  EXPECT_EQ(wfb.value().columns().size(), 1u);
  EXPECT_EQ(wfb.value().columns()[0], "col3");
}

TEST(SegmentMetaTest, MinDocIDCalculation) {
  SegmentMeta segment_meta(1);

  // Case 1: No persisted blocks, no writing forward block
  EXPECT_EQ(segment_meta.min_doc_id(), 0u);

  // Case 2: No persisted blocks, but has writing forward block
  BlockMeta writing_block(1, BlockType::SCALAR, 100, 200);
  segment_meta.set_writing_forward_block(writing_block);
  EXPECT_EQ(segment_meta.min_doc_id(), 100u);

  // Case 3: Has persisted blocks (should take precedence)
  BlockMeta persisted_block(1, BlockType::SCALAR, 50, 150);
  segment_meta.add_persisted_block(persisted_block);
  EXPECT_EQ(segment_meta.min_doc_id(), 50u);
}

TEST(SegmentMetaTest, MaxDocIDCalculation) {
  SegmentMeta segment_meta(1);

  // Case 1: No blocks at all
  EXPECT_EQ(segment_meta.max_doc_id(), 0u);

  // Case 2: Only persisted blocks
  BlockMeta persisted_block(1, BlockType::SCALAR, 0, 100);
  segment_meta.add_persisted_block(persisted_block);
  EXPECT_EQ(segment_meta.max_doc_id(), 100u);

  // Case 3: Both persisted and writing forward blocks (writing forward takes
  // precedence)
  BlockMeta writing_block(2, BlockType::SCALAR, 101, 200);
  segment_meta.set_writing_forward_block(writing_block);
  EXPECT_EQ(segment_meta.max_doc_id(), 100u);

  // Case 4: Only writing forward block
  SegmentMeta segment_meta2(2);
  segment_meta2.set_writing_forward_block(writing_block);
  EXPECT_EQ(segment_meta2.max_doc_id(), 0u);
}

TEST(SegmentMetaTest, DocCountCalculation) {
  SegmentMeta segment_meta(1);

  // Initially 0
  EXPECT_EQ(segment_meta.doc_count(), 0u);

  // Add persisted blocks
  BlockMeta block1(1, BlockType::SCALAR, 0, 100);
  block1.set_doc_count(50);
  segment_meta.add_persisted_block(block1);

  EXPECT_EQ(segment_meta.doc_count(), 50u);

  // Add another persisted block
  BlockMeta block2(2, BlockType::VECTOR_INDEX, 101, 200);
  block2.set_doc_count(75);
  segment_meta.add_persisted_block(block2);

  EXPECT_EQ(segment_meta.doc_count(), 50u);

  // Add writing forward block
  BlockMeta writing_block(3, BlockType::SCALAR, 201, 300);
  writing_block.set_doc_count(25);
  segment_meta.set_writing_forward_block(writing_block);

  EXPECT_EQ(segment_meta.doc_count(), 75);
}

TEST(SegmentMetaTest, IndexedVectorFieldsOperations) {
  SegmentMeta segment_meta(1);

  // Initially empty
  EXPECT_FALSE(segment_meta.vector_indexed("field1"));
  EXPECT_TRUE(segment_meta.indexed_vector_fields().empty());

  // Add indexed fields
  segment_meta.add_indexed_vector_field("field1");
  segment_meta.add_indexed_vector_field("field2");

  EXPECT_TRUE(segment_meta.vector_indexed("field1"));
  EXPECT_TRUE(segment_meta.vector_indexed("field2"));
  EXPECT_FALSE(segment_meta.vector_indexed("field3"));

  EXPECT_EQ(segment_meta.indexed_vector_fields().size(), 2u);

  // Check set operation
  std::set<std::string> fields = {"field3", "field4"};
  segment_meta.set_indexed_vector_fields(fields);

  EXPECT_FALSE(segment_meta.vector_indexed("field1"));
  EXPECT_FALSE(segment_meta.vector_indexed("field2"));
  EXPECT_TRUE(segment_meta.vector_indexed("field3"));
  EXPECT_TRUE(segment_meta.vector_indexed("field4"));
  EXPECT_EQ(segment_meta.indexed_vector_fields().size(), 2u);
}

TEST(SegmentMetaTest, UpdateMaxDocId) {
  SegmentMeta segment_meta(1);

  // Try to update when no writing forward block - should not crash
  segment_meta.update_max_doc_id(100);

  // Set writing forward block and update
  BlockMeta writing_block(1, BlockType::SCALAR, 0, 50);
  segment_meta.set_writing_forward_block(writing_block);
  EXPECT_EQ(segment_meta.writing_forward_block().value().max_doc_id(), 50u);

  segment_meta.update_max_doc_id(100);
  EXPECT_EQ(segment_meta.writing_forward_block().value().max_doc_id(), 100u);
}

TEST(SegmentMetaTest, EqualityOperators) {
  SegmentMeta segment1(1);
  SegmentMeta segment2(1);
  SegmentMeta segment3(2);

  // Same empty segments
  EXPECT_TRUE(segment1 == segment2);
  EXPECT_FALSE(segment1 != segment2);

  // Different IDs
  EXPECT_FALSE(segment1 == segment3);
  EXPECT_TRUE(segment1 != segment3);

  // Add same persisted block to both
  BlockMeta block(1, BlockType::SCALAR, 0, 100);
  block.set_doc_count(50);
  segment1.add_persisted_block(block);
  segment2.add_persisted_block(block);

  EXPECT_TRUE(segment1 == segment2);

  // Add writing forward block
  BlockMeta wfb(2, BlockType::VECTOR_INDEX, 101, 200);
  segment1.set_writing_forward_block(wfb);
  segment2.set_writing_forward_block(wfb);

  EXPECT_TRUE(segment1 == segment2);

  // Add indexed fields
  segment1.add_indexed_vector_field("vec_field");
  segment2.add_indexed_vector_field("vec_field");

  EXPECT_TRUE(segment1 == segment2);

  // Make them different again
  segment1.add_indexed_vector_field("vec_field2");

  EXPECT_FALSE(segment1 == segment2);
  EXPECT_TRUE(segment1 != segment2);
}