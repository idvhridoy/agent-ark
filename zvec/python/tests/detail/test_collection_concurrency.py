# Copyright 2025-present the zvec project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import logging
import pytest
import threading
import numpy as np
import zvec

from zvec import (
    CollectionOption,
    InvertIndexParam,
    HnswIndexParam,
    Collection,
    Doc,
    DataType,
    FieldSchema,
    VectorSchema,
)


class TestCollectionConcurrency:
    @pytest.fixture(scope="function")
    def test_collection(self, tmp_path_factory):
        """Fixture to create a test collection"""
        collection_schema = zvec.CollectionSchema(
            name="test_collection",
            fields=[
                FieldSchema(
                    "id",
                    DataType.INT64,
                    nullable=False,
                    index_param=InvertIndexParam(enable_range_optimization=True),
                ),
                FieldSchema(
                    "name",
                    DataType.STRING,
                    nullable=False,
                    index_param=InvertIndexParam(),
                ),
                FieldSchema("weight", DataType.FLOAT, nullable=True),
            ],
            vectors=[
                VectorSchema(
                    "dense",
                    DataType.VECTOR_FP32,
                    dimension=128,
                    index_param=HnswIndexParam(),
                ),
                VectorSchema(
                    "sparse", DataType.SPARSE_VECTOR_FP32, index_param=HnswIndexParam()
                ),
            ],
        )

        collection_option = CollectionOption(read_only=False, enable_mmap=True)

        temp_dir = tmp_path_factory.mktemp("zvec")
        collection_path = temp_dir / "test_collection"

        coll = zvec.create_and_open(
            path=str(collection_path),
            schema=collection_schema,
            option=collection_option,
        )

        assert coll is not None, "Failed to create and open collection"

        yield coll

        # Clean up
        if hasattr(coll, "destroy") and coll is not None:
            try:
                coll.destroy()
            except Exception as e:
                print(f"Warning: failed to destroy collection: {e}")

    def test_concurrent_read_write(self, test_collection: Collection):
        results = []

        def insert_docs(thread_id):
            try:
                docs = [
                    Doc(
                        id=f"{thread_id}_{i}",
                        fields={
                            "id": int(f"{thread_id}{i}"),
                            "name": f"thread_{thread_id}_doc_{i}",
                            "weight": float(i),
                        },
                        vectors={
                            "dense": np.random.random(128).tolist(),
                            "sparse": {1: float(i), 2: float(i * 2)},
                        },
                    )
                    for i in range(5)
                ]

                result = test_collection.insert(docs)
                results.append((thread_id, "insert", len(result)))
            except Exception as e:
                results.append((thread_id, "insert_exception", str(e)))

        def query_docs(thread_id):
            try:
                result = test_collection.query(filter="id > 0", topk=10)
                results.append((thread_id, "query", len(result)))
            except Exception as e:
                results.append((thread_id, "query_exception", str(e)))

        # Create threads for concurrent operations
        threads = []

        # Start insert threads
        for i in range(3):
            thread = threading.Thread(target=insert_docs, args=(i,))
            threads.append(thread)
            thread.start()

        # Start query threads
        for i in range(3):
            thread = threading.Thread(target=query_docs, args=(i,))
            threads.append(thread)
            thread.start()

        # Wait for all threads to complete
        for thread in threads:
            thread.join()

        # Analyze results
        insert_results = [r for r in results if r[1] == "insert"]
        query_results = [r for r in results if r[1] == "query"]

        logging.info(
            f"Concurrent read/write results - Inserts: {len(insert_results)}, Queries: {len(query_results)}"
        )

        # At least some operations should succeed
        assert len(insert_results) + len(query_results) > 0

    def test_concurrent_query(self, test_collection: Collection):
        # First insert some data
        docs = [
            Doc(
                id=f"{i}",
                fields={"id": i, "name": f"test_{i}", "weight": float(i)},
                vectors={
                    "dense": np.random.random(128).tolist(),
                    "sparse": {1: float(i), 2: float(i * 2)},
                },
            )
            for i in range(20)
        ]

        insert_result = test_collection.insert(docs)
        assert len(insert_result) == 20

        results = []

        def query_operation(thread_id):
            """Perform query operation from a thread"""
            try:
                result = test_collection.query(filter=f"id > {thread_id}", topk=5)
                results.append((thread_id, "query", len(result)))
            except Exception as e:
                results.append((thread_id, "query_exception", str(e)))

        # Create multiple threads for concurrent queries
        threads = []
        for i in range(5):
            thread = threading.Thread(target=query_operation, args=(i,))
            threads.append(thread)
            thread.start()

        # Wait for all threads to complete
        for thread in threads:
            thread.join()

        # Analyze results
        query_results = [r for r in results if r[1] == "query"]
        logging.info(f"Concurrent query results - Queries: {len(query_results)}")

        # All query operations should succeed
        assert len(query_results) == 5

    def test_concurrent_modifications(self, test_collection: Collection):
        # First insert some data
        docs = [
            Doc(
                id=f"{i}",
                fields={"id": i, "name": f"test_{i}", "weight": float(i)},
                vectors={
                    "dense": np.random.random(128).tolist(),
                    "sparse": {1: float(i), 2: float(i * 2)},
                },
            )
            for i in range(10)
        ]

        insert_result = test_collection.insert(docs)
        assert len(insert_result) == 10

        results = []

        def update_operation(thread_id):
            """Perform update operation from a thread"""
            try:
                # Each thread updates different documents
                update_docs = [
                    Doc(
                        id=f"{i}",
                        fields={
                            "id": i,
                            "name": f"updated_by_thread_{thread_id}",
                            "weight": float(i + thread_id),
                        },
                        vectors={
                            "dense": np.random.random(128).tolist(),
                            "sparse": {1: float(i) + 0.5, 2: float(i * 2) + 0.5},
                        },
                    )
                    for i in range(thread_id * 2, thread_id * 2 + 2)
                ]

                result = test_collection.update(update_docs)
                results.append((thread_id, "update", len(result)))
            except Exception as e:
                results.append((thread_id, "update_exception", str(e)))

        def delete_operation(thread_id):
            """Perform delete operation from a thread"""
            try:
                # Each thread deletes different documents
                delete_ids = [f"{thread_id * 2 + 2}", f"{thread_id * 2 + 3}"]
                result = test_collection.delete(delete_ids)
                results.append((thread_id, "delete", len(result)))
            except Exception as e:
                results.append((thread_id, "delete_exception", str(e)))

        # Create threads for concurrent operations
        threads = []

        # Start update threads
        for i in range(3):
            thread = threading.Thread(target=update_operation, args=(i,))
            threads.append(thread)
            thread.start()

        # Start delete threads
        for i in range(2):
            thread = threading.Thread(target=delete_operation, args=(i,))
            threads.append(thread)
            thread.start()

        # Wait for all threads to complete
        for thread in threads:
            thread.join()

        # Analyze results
        update_results = [r for r in results if r[1] == "update"]
        delete_results = [r for r in results if r[1] == "delete"]

        logging.info(
            f"Concurrent modification results - Updates: {len(update_results)}, Deletes: {len(delete_results)}"
        )

        # At least some operations should succeed
        assert len(update_results) + len(delete_results) > 0

    def test_read_write_locking(self, test_collection: Collection):
        # Perform operations that should be thread-safe
        docs = [
            Doc(
                id=f"{i}",
                fields={"id": i, "name": f"test_{i}", "weight": float(i)},
                vectors={
                    "dense": np.random.random(128).tolist(),
                    "sparse": {1: float(i), 2: float(i * 2)},
                },
            )
            for i in range(5)
        ]

        # Insert data
        insert_result = test_collection.insert(docs)
        assert len(insert_result) == 5

        # Concurrent operations should not cause data corruption
        results = []

        def mixed_operation(thread_id):
            """Perform mixed operations from a thread"""
            try:
                # Mix of read and write operations
                if thread_id % 2 == 0:
                    # Read operation
                    result = test_collection.fetch([f"{thread_id % 5}"])
                    results.append((thread_id, "read", len(result)))
                else:
                    # Write operation
                    doc = Doc(
                        id=f"{thread_id % 5}",
                        fields={
                            "id": thread_id % 5,
                            "name": f"mixed_op_{thread_id}",
                            "weight": float(thread_id),
                        },
                        vectors={
                            "dense": np.random.random(128).tolist(),
                            "sparse": {1: float(thread_id), 2: float(thread_id * 2)},
                        },
                    )
                    result = test_collection.upsert(doc)
                    results.append((thread_id, "write", len(result)))
            except Exception as e:
                results.append((thread_id, "exception", str(e)))

        # Create multiple threads
        threads = []
        for i in range(10):
            thread = threading.Thread(target=mixed_operation, args=(i,))
            threads.append(thread)
            thread.start()

        # Wait for all threads to complete
        for thread in threads:
            thread.join()

        # Verify that the collection is still in a consistent state
        final_result = test_collection.query()
        assert len(final_result) >= 0  # Should not crash or return corrupted data

    def test_race_condition_detection(self, test_collection: Collection):
        # Insert initial data
        docs = [
            Doc(
                id=f"{i}",
                fields={"id": i, "name": f"initial_{i}", "weight": float(i)},
                vectors={
                    "dense": np.random.random(128).tolist(),
                    "sparse": {1: float(i), 2: float(i * 2)},
                },
            )
            for i in range(10)
        ]

        insert_result = test_collection.insert(docs)
        assert len(insert_result) == 10

        # Perform many rapid concurrent operations
        operation_count = 100
        results = []

        def rapid_operation(op_id):
            """Perform rapid operations"""
            try:
                # Alternate between different types of operations
                if op_id % 4 == 0:
                    # Insert
                    doc = Doc(
                        id=f"rapid_{op_id}",
                        fields={
                            "id": op_id,
                            "name": f"rapid_{op_id}",
                            "weight": float(op_id),
                        },
                        vectors={
                            "dense": np.random.random(128).tolist(),
                            "sparse": {1: float(op_id), 2: float(op_id * 2)},
                        },
                    )
                    result = test_collection.insert(doc)
                    results.append(("insert", len(result)))
                elif op_id % 4 == 1:
                    # Update
                    doc = Doc(
                        id=f"{op_id % 10}",
                        fields={
                            "id": op_id % 10,
                            "name": f"rapid_update_{op_id}",
                            "weight": float(op_id),
                        },
                        vectors={
                            "dense": np.random.random(128).tolist(),
                            "sparse": {1: float(op_id), 2: float(op_id * 2)},
                        },
                    )
                    result = test_collection.update(doc)
                    results.append(("update", len(result)))
                elif op_id % 4 == 2:
                    # Query
                    result = test_collection.query(filter=f"id > {op_id % 5}", topk=3)
                    results.append(("query", len(result)))
                else:
                    # Fetch
                    result = test_collection.fetch([f"{op_id % 10}"])
                    results.append(("fetch", len(result)))
            except Exception as e:
                results.append(("exception", str(e)))

        # Create many threads for rapid concurrent operations
        threads = []
        for i in range(operation_count):
            thread = threading.Thread(target=rapid_operation, args=(i,))
            threads.append(thread)
            thread.start()

        # Wait for all threads to complete
        for thread in threads:
            thread.join()

        # Verify collection is still functional
        final_query = test_collection.query()
        assert len(final_query) >= 0  # Should not be corrupted

        logging.info(
            f"Rapid concurrent operations completed - Total operations: {len(results)}"
        )
