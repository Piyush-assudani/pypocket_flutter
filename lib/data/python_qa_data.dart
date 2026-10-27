class PythonQAItem {
  final String id;
  final String category;
  final String question;
  final String answer;
  final String codeExample;
  final String keyInsight;
  final String difficulty; // 'Junior', 'Mid-Level', 'Senior Architect'

  const PythonQAItem({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.codeExample,
    required this.keyInsight,
    required this.difficulty,
  });
}

class PythonQAData {
  static const List<PythonQAItem> items = [
    // -------------------------------------------------------------
    // CATEGORY: MEMORY & OBJECT MODEL
    // -------------------------------------------------------------
    PythonQAItem(
      id: 'qa_mem_1',
      category: 'Memory & Architecture',
      difficulty: 'Junior',
      question: 'Why are Python variables referred to as names/pointers rather than memory boxes?',
      answer: '''In languages like C or C++, a variable is a named memory location that directly stores a primitive binary value. In Python, every entity is a first-class heap object.

A variable identifier in Python is merely a symbolic string key inside a namespace dictionary (like locals() or globals()) that points to a PyObject header in heap memory. When you execute x = y, Python does not duplicate the object; it simply increments the reference count of the existing object and binds x to the same address.''',
      codeExample: '''# Demonstrating variable reference binding
a = [1, 2, 3]
b = a          # Both point to the same PyObject
b.append(4)
print(a)       # [1, 2, 3, 4]
print(a is b)  # True (Identical memory address)''',
      keyInsight: 'Variables are pointers in a namespace hash table, not storage containers.',
    ),
    PythonQAItem(
      id: 'qa_mem_2',
      category: 'Memory & Architecture',
      difficulty: 'Senior Architect',
      question: 'What is __slots__ in Python, and how does it optimize memory by up to 60%?',
      answer: '''By default, Python class instances store dynamic attributes in an internal dictionary called __dict__. A Python dict has considerable memory overhead due to hash table open-addressing and sparsity.

When you declare __slots__ = ('x', 'y') on a class, Python bypasses the creation of __dict__ and allocates a fixed-size array of C pointers directly on the PyObject struct. This eliminates dictionary overhead, preventing arbitrary attribute assignment and dramatically speeding up attribute access in millions of instances.''',
      codeExample: '''class MemoryOptimizedNode:
    __slots__ = ('val', 'next')
    def __init__(self, val):
        self.val = val
        self.next = None

# Millions of instances consume ~60% less RAM than default __dict__ classes''',
      keyInsight: '__slots__ prevents __dict__ allocation, storing attributes in fixed C struct offsets.',
    ),
    PythonQAItem(
      id: 'qa_mem_3',
      category: 'Memory & Architecture',
      difficulty: 'Mid-Level',
      question: 'What is the critical difference between the "is" keyword and the "==" operator?',
      answer: '''The "is" keyword checks for identity: it verifies whether two pointers point to the exact same physical memory address (i.e. id(a) == id(b)).

The "==" operator checks for equality: it delegates to the object's __eq__() dunder method to compare logical values. Two distinct objects in memory can evaluate to True with "==", but False with "is".''',
      codeExample: '''list1 = [1, 2, 3]
list2 = [1, 2, 3]

print(list1 == list2)  # True (values match)
print(list1 is list2)  # False (distinct heap allocations)''',
      keyInsight: '"is" checks pointer addresses; "==" invokes __eq__() for value equivalence.',
    ),

    // -------------------------------------------------------------
    // CATEGORY: GENERATORS & ITERATORS
    // -------------------------------------------------------------
    PythonQAItem(
      id: 'qa_gen_1',
      category: 'Generators & Streams',
      difficulty: 'Mid-Level',
      question: 'How do Python generators preserve state, and why are they superior for large datasets?',
      answer: '''A generator is a function containing one or more "yield" expressions. When called, it does not execute the function body; instead, it returns a generator iterator object.

When next() is invoked on the generator, Python executes the frame until it encounters yield. It saves the entire execution frame (local variables, program counter, instruction stack) on the heap and suspends execution. This enables streaming processing with O(1) auxiliary memory regardless of dataset size.''',
      codeExample: '''# Streaming 10 million records with O(1) memory
def stream_large_file(file_path):
    with open(file_path, 'r') as f:
        for line in f:
            if line.strip():
                yield line.strip()

# Memory consumption remains constant across arbitrarily large files''',
      keyInsight: 'Generators suspend frame state on the heap, allowing lazy streaming evaluation.',
    ),

    // -------------------------------------------------------------
    // CATEGORY: CONCURRENCY & GIL
    // -------------------------------------------------------------
    PythonQAItem(
      id: 'qa_conc_1',
      category: 'Concurrency & GIL',
      difficulty: 'Senior Architect',
      question: 'Why does Python threading not accelerate CPU-bound computations, and how do you resolve it?',
      answer: '''In CPython, the Global Interpreter Lock (GIL) is a mutual exclusion lock that prevents multiple native OS threads from executing Python bytecode simultaneously. This lock is necessary because CPython memory management (reference counting) is not thread-safe.

For CPU-bound tasks (e.g. data crunching, cryptography, neural nets), multiple threads serialize behind the GIL and suffer context-switch overhead, running slower than single-threaded code. To achieve true parallel execution across multiple CPU cores, use multiprocessing (which spawns independent processes with separate GILs) or external C extensions (NumPy, Cython) that release the GIL during computation.''',
      codeExample: '''from multiprocessing import Pool

def cpu_heavy_task(n):
    return sum(i * i for i in range(n))

if __name__ == '__main__':
    with Pool() as pool:
        # Executes in true parallel across all CPU cores
        results = pool.map(cpu_heavy_task, [10**7, 10**7, 10**7, 10**7])
        print("Parallel calculations complete!")''',
      keyInsight: 'The GIL prevents parallel bytecode execution; use multiprocessing for CPU parallelism.',
    ),
    PythonQAItem(
      id: 'qa_conc_2',
      category: 'Concurrency & GIL',
      difficulty: 'Mid-Level',
      question: 'When should you use Asyncio (async/await) over Multithreading?',
      answer: '''Asyncio uses cooperative single-threaded concurrency governed by an event loop. Coroutines yield control cooperatively at "await" points when waiting on I/O operations (network requests, database queries, file reads).

Unlike threads, coroutines have near-zero overhead (lightweight Python generator-like frames), allowing a single Python process to manage 50,000+ concurrent network connections without context-switch latency or OS thread stack overhead.''',
      codeExample: '''import asyncio

async def fetch_api(endpoint):
    await asyncio.sleep(0.5)  # Non-blocking I/O simulation
    return f"Data from {endpoint}"

async def main():
    endpoints = ["/users", "/orders", "/analytics", "/billing"]
    tasks = [fetch_api(ep) for ep in endpoints]
    results = await asyncio.gather(*tasks)
    print(results)

asyncio.run(main())''',
      keyInsight: 'Asyncio is optimal for massive I/O concurrency without thread overhead.',
    ),

    // -------------------------------------------------------------
    // CATEGORY: OOP & METACLASSES
    // -------------------------------------------------------------
    PythonQAItem(
      id: 'qa_oop_1',
      category: 'OOP & Architecture',
      difficulty: 'Senior Architect',
      question: 'What is the C3 Linearization (Method Resolution Order / MRO) algorithm in multiple inheritance?',
      answer: '''When a class inherits from multiple parents in Python, the C3 Linearization algorithm computes a deterministic, monotonic order for resolving attributes and super() calls.

C3 guarantees three invariants:
1. Subclasses appear before parent classes.
2. The order of parent classes in the class declaration list is preserved.
3. Monotonicity: If class A appears before class B in one MRO, it will never appear after class B in any descendant MRO. You can inspect any class's linearization using ClassName.__mro__.''',
      codeExample: '''class A: pass
class B(A): pass
class C(A): pass
class D(B, C): pass

print([cls.__name__ for cls in D.__mro__])
# Output: ['D', 'B', 'C', 'A', 'object']''',
      keyInsight: 'C3 Linearization guarantees monotonic order in diamond and multiple inheritance.',
    ),
    PythonQAItem(
      id: 'qa_oop_2',
      category: 'OOP & Architecture',
      difficulty: 'Mid-Level',
      question: 'Why should you always use @functools.wraps when building Python decorators?',
      answer: '''When you wrap a function with a decorator, the decorated function identifier is replaced by the inner closure function. Without @wraps, the original function loses its metadata (__name__, __doc__, __annotations__, __module__).

This breaks debugging tools, auto-documentation generators (Sphinx, FastAPI OpenAPI schemas), and reflection. @functools.wraps copies all metadata and dunder attributes from the wrapped function to the closure.''',
      codeExample: '''import functools

def audit_logger(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Executing: {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@audit_logger
def calculate_tax(amount):
    """Calculates VAT rate."""
    return amount * 0.18

print(calculate_tax.__name__)  # 'calculate_tax' (preserved!)
print(calculate_tax.__doc__)   # 'Calculates VAT rate.' (preserved!)''',
      keyInsight: '@functools.wraps preserves function docstrings, names, and type annotations.',
    ),

    // -------------------------------------------------------------
    // CATEGORY: DATA STRUCTURES & ALGORITHMS
    // -------------------------------------------------------------
    PythonQAItem(
      id: 'qa_dsa_1',
      category: 'Data Structures & Big-O',
      difficulty: 'Mid-Level',
      question: 'How do Python dictionaries achieve O(1) average lookup time, and what changed in Python 3.7+?',
      answer: '''Python dictionaries are implemented as hash tables. When you access dict[key], Python hashes the key using hash(), bounds it to the table index, and probes the bucket.

Prior to Python 3.6, dictionaries had high memory overhead because each hash entry contained the hash, key pointer, and value pointer directly in a sparse table. Since Python 3.7+, CPython uses a compact hash table: a sparse index table pointing to a dense insertion-ordered array. This preserves insertion order deterministically while reducing memory consumption by 25-30%.''',
      codeExample: '''d = {"alpha": 1, "beta": 2, "gamma": 3}
# Python 3.7+ guarantees keys are iterated in exact insertion order:
for key in d:
    print(key)  # alpha, beta, gamma deterministically''',
      keyInsight: 'Dictionaries use compact sparse index tables that preserve insertion order.',
    ),
    PythonQAItem(
      id: 'qa_dsa_2',
      category: 'Data Structures & Big-O',
      difficulty: 'Senior Architect',
      question: 'What is the amortized time complexity of list.append() versus list.insert(0, val)?',
      answer: '''In CPython, a list is an array of object pointers. When a list runs out of allocated space, CPython over-allocates extra memory using a growth factor: ~1.125x + 3.

Because reallocations happen exponentially less frequently as the list grows, list.append() has O(1) amortized time complexity. In contrast, list.insert(0, val) forces CPython to shift every existing pointer in memory right by one position using memmove(), yielding O(N) linear time complexity. For double-ended queues with O(1) left insertions, use collections.deque.''',
      codeExample: '''from collections import deque

# Inefficient O(N) insertions
slow_list = []
slow_list.insert(0, "item")  # Shifts all elements in memory

# Highly efficient O(1) double-ended queue
fast_deque = deque()
fast_deque.appendleft("item")  # Instant O(1) pointer adjustment''',
      keyInsight: 'list.append() is O(1) amortized; list.insert(0) is O(N); use deque for O(1) shifts.',
    ),
    PythonQAItem(
      id: 'qa_async_gather_exception_handling',
      category: 'Concurrency & Async',
      difficulty: 'Staff Engineer',
      question: 'How do you handle exceptions in asyncio.gather() without crashing all concurrent tasks?',
      answer: '''By default, if any coroutine inside asyncio.gather() raises an exception, the entire gather operation terminates immediately and propagates that exception, potentially leaving sibling tasks dangling.

Setting `return_exceptions=True` tells asyncio to catch any task exceptions and return them as elements in the resulting list alongside normal return values. You can then iterate through the results and inspect `isinstance(result, Exception)` to log failures or retry safely.''',
      codeExample: '''import asyncio

async def fetch_success():
    return {"status": 200, "data": "OK"}

async def fetch_failing():
    raise ConnectionResetError("Remote server disconnected")

async def main():
    results = await asyncio.gather(
        fetch_success(),
        fetch_failing(),
        return_exceptions=True,
    )
    for res in results:
        if isinstance(res, Exception):
            print(f"[RECOVERED] Task error: {type(res).__name__} -> {res}")
        else:
            print(f"[SUCCESS] Got payload: {res}")

asyncio.run(main())''',
      keyInsight: 'Use asyncio.gather(..., return_exceptions=True) to isolate failures from crashing sibling tasks.',
    ),
    PythonQAItem(
      id: 'qa_gil_free_threading_python_313',
      category: 'CPython Internals',
      difficulty: 'Staff Engineer',
      question: 'What is PEP 703 (Free-threaded Python 3.13) and how does it remove the GIL?',
      answer: '''PEP 703 introduces an experimental build option in Python 3.13 (`--disable-gil`) that removes the Global Interpreter Lock completely.

To maintain thread safety without a single global lock, CPython replaces the GIL with:
1. Mimalloc biased reference counting: Threads modify thread-local reference counts without atomic CPU bus locks.
2. Immortal objects: Core singletons (None, True, False, small integers) never modify reference counts.
3. Fine-grained mutexes per collection: Modifying dictionaries or lists locks only that individual object rather than the entire interpreter.''',
      codeExample: '''import sys

# Checking if GIL is enabled in running interpreter
has_gil = getattr(sys, "_is_gil_enabled", lambda: True)()
print(f"Is CPython GIL active? {has_gil}")
print(f"Python Implementation: {sys.implementation.name} {sys.version.split()[0]}")''',
      keyInsight: 'PEP 703 replaces the GIL with biased reference counting and object-level fine-grained locks.',
    ),
    PythonQAItem(
      id: 'qa_generators_vs_lists_memory_benchmark',
      category: 'Performance & Optimization',
      difficulty: 'Mid-Level',
      question: 'Why do generators consume virtually zero memory compared to list comprehensions?',
      answer: '''A list comprehension `[x for x in range(1_000_000)]` allocates a contiguous memory array on the heap and creates all 1,000,000 integer pointers immediately, consuming ~8MB of RAM.

In contrast, a generator expression `(x for x in range(1_000_000))` allocates only a lightweight generator object (~112 bytes) holding a reference to the code object and current execution frame. Values are computed on-demand one by one during iteration via the iterator protocol (`__next__`), allowing you to process terabyte-scale logs or infinite streams with fixed O(1) memory.''',
      codeExample: '''import sys

# List allocates all elements immediately
list_mem = sys.getsizeof([x for x in range(100_000)])

# Generator stores only current iteration state
gen_mem = sys.getsizeof((x for x in range(100_000)))

print(f"List Memory:      {list_mem:,} bytes")
print(f"Generator Memory: {gen_mem:,} bytes (~{list_mem // gen_mem}x smaller!)")''',
      keyInsight: 'Generators evaluate lazily on-demand with O(1) memory; lists allocate all items upfront.',
    ),
    PythonQAItem(
      id: 'qa_context_managers_generator_decorator',
      category: 'Design Patterns',
      difficulty: 'Senior Architect',
      question: 'How does contextlib.contextmanager turn a simple generator into a context manager?',
      answer: '''Writing a class with `__enter__` and `__exit__` dunder methods can be verbose. The `@contextmanager` decorator wraps a generator yielding once into an automatic context manager.

Code before the `yield` statement executes upon entering the `with` block (`__enter__`). The yielded value is bound to the `as` variable. Code after `yield` executes upon exiting (`__exit__`). By placing the cleanup code inside a `finally` block, you guarantee resources (like database locks or file descriptors) are released even if an exception occurs.''',
      codeExample: '''from contextlib import contextmanager

@contextmanager
def temporary_database_transaction():
    print("[TX START] BEGIN TRANSACTION")
    try:
        yield {"tx_id": "0x9F4A", "status": "ACTIVE"}
        print("[TX COMMIT] COMMIT TRANSACTION")
    except Exception as exc:
        print(f"[TX ROLLBACK] Aborting due to: {exc}")
        raise
    finally:
        print("[TX CLEANUP] Connection released back to pool")

with temporary_database_transaction() as tx:
    print(f"Executing query within {tx['tx_id']}...")''',
      keyInsight: 'Always wrap generator yields in try...finally when using @contextmanager to ensure resource release.',
    ),
    PythonQAItem(
      id: 'qa_pydantic_v2_core_rust_validation',
      category: 'System Architecture',
      difficulty: 'Senior Architect',
      question: 'Why is Pydantic v2 dramatically faster than Pydantic v1, and how does validation work?',
      answer: '''Pydantic v1 was written in pure Python, meaning every field validation traversed Python function call overhead and dynamic type checking.

Pydantic v2 moved the entire validation engine into `pydantic-core`, written in Rust. When a BaseModel is defined, Python builds a schema JSON tree and hands it to Rust. Rust traverses raw dictionaries, casts types, and validates regexes directly in compiled native machine code, achieving 5x to 17x faster throughput without triggering Python interpreter overhead.''',
      codeExample: '''# Pydantic v2 pattern simulation
from dataclasses import dataclass

@dataclass
class StrictSchema:
    endpoint: str
    port: int

def validate_payload(raw_dict):
    # Rust core performs schema checks directly
    return StrictSchema(
        endpoint=str(raw_dict["endpoint"]),
        port=int(raw_dict["port"])
    )

data = validate_payload({"endpoint": "api.production.internal", "port": "443"})
print(f"Validated: {data.endpoint}:{data.port} (Port is int: {isinstance(data.port, int)})")''',
      keyInsight: 'Pydantic v2 compiles schema validation trees into native Rust code, bypassing Python bytecode overhead.',
    ),
    PythonQAItem(
      id: 'qa_weakref_cyclic_garbage_collection',
      category: 'CPython Internals',
      difficulty: 'Staff Engineer',
      question: 'How do circular references defeat reference counting and how does weakref solve it?',
      answer: '''CPython primarily frees objects when their reference count drops to 0. If Object A references Object B and Object B references Object A, both reference counts remain at least 1 even after all external references are deleted.

These circular references can only be detected and reclaimed by CPython's cyclic generational garbage collector (`gc` module), which runs periodically and causes CPU latency spikes. Using `import weakref` allows an object to reference another without incrementing its reference count, preventing cycle formation and enabling immediate deterministic cleanup.''',
      codeExample: '''import weakref

class Node:
    def __init__(self, name):
        self.name = name
        self.parent = None

child = Node("ChildNode")
parent = Node("ParentNode")

# Using weak reference for backward pointer
child.parent = weakref.ref(parent)

print("Child parent name:", child.parent().name)
del parent
print("Child parent after deletion:", child.parent())  # None automatically!''',
      keyInsight: 'Use weakref for backward or cache references to avoid circular references and allow instant deallocation.',
    ),
  ];

  static List<String> get categories {
    final set = <String>{};
    for (final item in items) {
      set.add(item.category);
    }
    return ['All Categories', ...set];
  }
}
