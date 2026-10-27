class BookletChapter {
  final String title;
  final String subtitle;
  final String content;
  final String codeExample;
  final List<String> keyTakeaways;

  const BookletChapter({
    required this.title,
    required this.subtitle,
    required this.content,
    required this.codeExample,
    required this.keyTakeaways,
  });
}

class PythonBooklet {
  final String id;
  final String title;
  final String subtitle;
  final String tag;
  final String readTime;
  final List<BookletChapter> chapters;

  const PythonBooklet({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.readTime,
    required this.chapters,
  });
}

class PythonBookletsData {
  static const List<PythonBooklet> booklets = [
    PythonBooklet(
      id: 'booklet_memory_core',
      title: 'Python Memory & Object Model',
      subtitle: 'Variables, References, Mutability & Garbage Collection',
      tag: 'CORE FOUNDATIONS',
      readTime: '8 min read',
      chapters: [
        BookletChapter(
          title: 'Names vs Values (Variables as Pointers)',
          subtitle: 'Understanding why Python variables are names, not boxes',
          content: '''In Python, variables do not store values directly. Instead, variables are symbolic names (pointers) bound to objects residing in heap memory.

When you write `x = [1, 2, 3]`, Python allocates a list object in memory, and binds the identifier `x` to its address. When you execute `y = x`, `y` points to the exact same object in memory, not a copy.

Checking object identity is done using the `id()` function or the `is` operator, whereas value equality is compared with `==`.''',
          codeExample: '''# Variable binding & identity
a = [10, 20, 30]
b = a          # Both reference same list
b.append(40)

print(a)       # Output: [10, 20, 30, 40]
print(a is b)  # True (Identical memory address)
print(id(a) == id(b)) # True''',
          keyTakeaways: [
            'Python variables are references (pointers) bound to heap objects.',
            'Assignment (`=`) binds a name to an object, never copies deep data.',
            '`is` checks memory address (`id`), while `==` checks value equality.',
          ],
        ),
        BookletChapter(
          title: 'Mutable vs Immutable Data Types',
          subtitle: 'Tuples, Integers, Strings vs Lists, Sets, Dictionaries',
          content: '''Python classifies all types into mutable (modifiable in-place) and immutable (cannot be modified after creation).

- Immutable: `int`, `float`, `str`, `tuple`, `frozenset`, `bytes`.
- Mutable: `list`, `dict`, `set`, `bytearray`.

When you modify an immutable object (e.g. `s = "py"; s += "thon"`), Python creates a brand-new string in memory and rebinds `s` to the new address.''',
          codeExample: '''# Immutability in practice
text = "hello"
original_id = id(text)

text += " world"
new_id = id(text)

print("ID Changed:", original_id != new_id) # True

# Safe immutable dictionary keys:
valid_dict = {(1, 2): "Coordinate Point"} # Tuples can be keys
# invalid = {[1, 2]: "Point"} # TypeError: unhashable type: 'list\'''',
          keyTakeaways: [
            'Modifying an immutable type creates a new object in memory.',
            'Only immutable types can be used as dictionary keys and set elements.',
            'Use tuples for fixed records and lists for dynamic collections.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_data_structures',
      title: 'Data Structures & Big-O Complexity',
      subtitle: 'Lists, HashMaps, Sets, Deques and Algorithmic Performance',
      tag: 'ALGORITHMIC MASTERY',
      readTime: '10 min read',
      chapters: [
        BookletChapter(
          title: 'Dictionary & Set Hash Tables',
          subtitle: 'O(1) average lookup via open addressing',
          content: '''Python dictionaries and sets are implemented as dynamic hash tables using open addressing with quadratic perturbation.

When inserting key-value pairs, Python computes `hash(key)` to determine the array bucket index. If multiple keys produce index collisions, Python probes subsequent indices using a perturbation formula until an empty slot is found.

Because dictionary lookups are O(1) average time complexity, searching a million elements in a set takes microseconds compared to O(n) linear scanning in lists.''',
          codeExample: '''# O(1) Lookup Performance
user_ids = {f"USR_{i}" for i in range(100000)}

# O(1) Instant Check:
print("USR_500" in user_ids) # Instantaneous

# Dictionary comprehension:
squared_map = {x: x**2 for x in range(10) if x % 2 == 0}
print(squared_map) # {0: 0, 2: 4, 4: 16, 6: 36, 8: 64}''',
          keyTakeaways: [
            'Dicts and Sets provide average O(1) search, insert, and delete.',
            'Dictionary keys must implement `__hash__` and `__eq__`.',
            'Since Python 3.7, standard dictionaries guarantee insertion order.',
          ],
        ),
        BookletChapter(
          title: 'Double-Ended Queues (`collections.deque`)',
          subtitle: 'Why appending to left of list is slow O(n) and deques are O(1)',
          content: '''In Python, `list.insert(0, val)` or `list.pop(0)` is an O(n) operation because every subsequent element must be shifted in contiguous memory.

`collections.deque` (Double-Ended Queue) is backed by a doubly linked list of fixed-size blocks. It guarantees O(1) fast appends and pops from both ends (`appendleft`, `popleft`), making it the premier choice for BFS graph traversals, sliding windows, and job queues.''',
          codeExample: '''from collections import deque

queue = deque(["task1", "task2", "task3"])
queue.append("task4")       # O(1) fast right append
first = queue.popleft()     # O(1) fast left pop (instant)

print("Processed:", first)
print("Remaining:", list(queue))''',
          keyTakeaways: [
            '`list.pop(0)` is O(n); `deque.popleft()` is O(1).',
            'Use `collections.deque` for all queue and sliding window algorithms.',
            'Deques can have a `maxlen` parameter to automatically discard old items.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_oop_dunders',
      title: 'OOP Architecture & Magic Dunders',
      subtitle: 'Classes, Inheritance, Protocols, Dataclasses & Metaprogramming',
      tag: 'OBJECT-ORIENTED SUITE',
      readTime: '12 min read',
      chapters: [
        BookletChapter(
          title: 'Essential Dunder Methods (Python Protocols)',
          subtitle: '__repr__, __str__, __eq__, __call__, __getitem__',
          content: '''Dunder (Double Underscore) methods allow custom classes to hook into Python syntax. By implementing standard dunders, your custom objects behave like built-in Python constructs.

- `__repr__`: Unambiguous developer string representation.
- `__str__`: Human-readable string representation.
- `__len__` & `__getitem__`: Allows indexing `obj[i]` and `len(obj)`.
- `__call__`: Allows instances to be invoked like functions `obj()`.
- `__enter__` & `__exit__`: Enables `with` context manager support.''',
          codeExample: '''class Vector:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __add__(self, other):
        return Vector(self.x + other.x, self.y + other.y)

    def __repr__(self):
        return f"Vector({self.x}, {self.y})"

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

v1 = Vector(2, 4)
v2 = Vector(3, 1)
v3 = v1 + v2
print(v3)        # Vector(5, 5)
print(v3 == Vector(5, 5)) # True''',
          keyTakeaways: [
            'Dunders implement Python operator overloading cleanly.',
            'Always define `__repr__` for effortless debugging and logging.',
            'Implementing `__getitem__` automatically gives slicing and iteration.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_asyncio',
      title: 'Asyncio & Concurrent Architecture',
      subtitle: 'Coroutines, Event Loops, Tasks & ThreadPool Concurrency',
      tag: 'CONCURRENCY & ASYNC',
      readTime: '9 min read',
      chapters: [
        BookletChapter(
          title: 'Cooperative Multitasking & Event Loops',
          subtitle: 'async def, await, asyncio.gather',
          content: '''Asyncio provides single-threaded cooperative multitasking. Unlike preemptive OS threads, async coroutines yield control voluntarily at `await` expression points.

When an I/O operation (HTTP request, database query, socket read) waits for data, the Python Event Loop pauses that coroutine and executes other runnable tasks on the same thread. This allows a single Python process to manage tens of thousands of concurrent connections.''',
          codeExample: '''import asyncio

async def fetch_api(service_name, delay):
    print(f"Fetching {service_name}...")
    await asyncio.sleep(delay) # Non-blocking I/O wait
    return f"{service_name}: 200 OK"

async def main():
    # Run 3 requests concurrently
    results = await asyncio.gather(
        fetch_api("AuthService", 1.0),
        fetch_api("BillingService", 0.5),
        fetch_api("MLModelService", 1.2),
    )
    print("All Finished:", results)

asyncio.run(main())''',
          keyTakeaways: [
            'Asyncio achieves high concurrency on a single CPU core for I/O bound tasks.',
            '`await` can only be called inside an `async def` coroutine.',
            'Never call blocking synchronous code (like `time.sleep`) inside async tasks.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_developer_playbook',
      title: 'Python Engineering Playbook',
      subtitle: 'Production Workflows, Tooling, Virtual Environments & FastAPI',
      tag: 'PRODUCTION PLAYBOOK',
      readTime: '15 min read',
      chapters: [
        BookletChapter(
          title: 'Modern Environment & Dependency Management',
          subtitle: 'Virtual Environments, uv, Poetry, and Lockfiles',
          content: '''Never install third-party packages into the global system Python. Isolated virtual environments guarantee deterministic deployments across development, staging, and production.

Modern high-speed package managers like `uv` (written in Rust) resolve and install dependencies 10-100x faster than traditional pip while guaranteeing strict reproducible lockfiles (`uv.lock` or `poetry.lock`).''',
          codeExample: '''# Terminal workflow for modern project setup:
# 1. Create high-speed isolated venv:
#    uv venv .venv
# 2. Activate virtual environment:
#    source .venv/bin/activate  # macOS / Linux
#    .venv\\Scripts\\activate     # Windows

# Modern dependency pinning:
dependencies = [
    "fastapi>=0.110.0",
    "pydantic>=2.6.0",
    "uvicorn[standard]>=0.28.0",
]''',
          keyTakeaways: [
            'Always isolate project dependencies in a dedicated virtual environment.',
            'Use lockfiles (`uv.lock`, `poetry.lock`) to guarantee reproducible production builds.',
            'Keep development dependencies (pytest, ruff, mypy) separate from runtime dependencies.',
          ],
        ),
        BookletChapter(
          title: 'Production REST APIs with FastAPI & Pydantic',
          subtitle: 'Type-safe request validation, Dependency Injection & OpenAPI schemas',
          content: '''FastAPI leverages Python type hints and Pydantic V2 to provide automatic request parsing, runtime JSON validation, and interactive OpenAPI documentation.

Using FastAPI's `Depends()` mechanism, you decouple database sessions, authentication guards, and business services, adhering strictly to clean inversion of control.''',
          codeExample: '''from pydantic import BaseModel, EmailStr
from typing import Annotated

# Schema definition with strict type validation
class UserCreate(BaseModel):
    username: str
    email: str
    experience_years: int

def validate_developer(user: UserCreate) -> dict:
    # Automatic validation occurs at boundary
    return {
        "status": "approved",
        "developer": user.username,
        "seniority": "Senior" if user.experience_years >= 5 else "Junior"
    }

demo_user = UserCreate(username="alex_dev", email="alex@pypocket.io", experience_years=6)
print(validate_developer(demo_user))''',
          keyTakeaways: [
            'Pydantic models validate and serialize input data at system boundaries.',
            'Type hints eliminate entire classes of runtime type errors.',
            'FastAPI Dependency Injection enables modular, testable service layers.',
          ],
        ),
        BookletChapter(
          title: 'Automated Testing Mastery with Pytest & Fixtures',
          subtitle: 'Unit tests, mock dependencies, parameterized test matrices',
          content: '''Automated testing is the backbone of production Python. `pytest` provides a clean, pythonic testing harness using standard `assert` statements rather than cumbersome OOP test classes.

Fixtures (`@pytest.fixture`) provide reusable, memoized test dependencies (test database connections, mock API clients, sample payload objects) with deterministic teardown phases.''',
          codeExample: '''# Example test suite pattern
def calculate_growth(xp: int, multiplier: float) -> int:
    if multiplier <= 0:
        raise ValueError("Multiplier must be positive")
    return int(xp * multiplier)

# Test cases
def test_growth_standard():
    assert calculate_growth(100, 1.5) == 150

def test_growth_invalid_multiplier():
    try:
        calculate_growth(100, -1.0)
        assert False, "Should raise ValueError"
    except ValueError as e:
        assert "Multiplier must be positive" in str(e)

test_growth_standard()
test_growth_invalid_multiplier()
print("All unit tests passed successfully!")''',
          keyTakeaways: [
            'Write independent, isolated unit tests for all core business logic.',
            'Use `@pytest.mark.parametrize` to run tests across multiple edge-case matrices.',
            'Mock external network and database calls to guarantee fast, deterministic test runs.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_modern_python',
      title: 'Modern Python 3.10 - 3.12 Deep Dive',
      subtitle: 'Pattern Matching, Type Parameter Syntax & Exception Groups',
      tag: 'MODERN PYTHON 3.12',
      readTime: '11 min read',
      chapters: [
        BookletChapter(
          title: 'Structural Pattern Matching (match / case)',
          subtitle: 'Deconstructing sequences, mappings, class instances & guard clauses',
          content: '''Python 3.10 introduced Structural Pattern Matching (`match / case`), which is far more powerful than a simple switch-case statement.

Pattern matching deconstructs complex nested data structures (tuples, dictionaries, custom objects), extracts inner variables, and executes conditional logic using `if` guard clauses in a single expressive syntax.''',
          codeExample: '''def handle_command(command):
    match command:
        case ["quit" | "exit"]:
            return "Session terminated"
        case ["load", filename]:
            return f"Loading script: {filename}"
        case ["run", filename, "--timeout", int(secs)] if secs > 0:
            return f"Executing {filename} with {secs}s timeout"
        case _:
            return "Unknown command pattern"

print(handle_command(["load", "app.py"]))
print(handle_command(["run", "main.py", "--timeout", 30]))
print(handle_command(["exit"]))''',
          keyTakeaways: [
            'Pattern matching matches structure, type, and values simultaneously.',
            'Use `_` as the wildcard fallback for unhandled patterns.',
            'Guard clauses (`case ... if condition`) enforce dynamic runtime validations.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_fastapi_production',
      title: 'Full-Stack FastAPI & Microservices Architecture',
      subtitle: 'Pydantic v2, Async SQLAlchemy, JWT Auth & Production Deployment',
      tag: 'SYSTEM ARCHITECTURE',
      readTime: '12 min read',
      chapters: [
        BookletChapter(
          title: 'Pydantic v2 Schemas & Dependency Injection',
          subtitle: 'Type-safe request validation and modular services with Depends()',
          content: '''FastAPI pairs ASGI asynchronous execution with Pydantic v2 core compiled in Rust. Request bodies are validated automatically against annotated classes, returning informative 422 JSON errors when types mismatch.

Dependency Injection (`Depends`) allows database sessions, authentication headers, and configuration objects to be injected cleanly into path operations without global state.''',
          codeExample: '''from pydantic import BaseModel, EmailStr, Field

class CreateTenantRequest(BaseModel):
    organization_name: str = Field(min_length=3, max_length=50)
    admin_email: EmailStr
    tier: str = "professional"

# Simulated request validation
payload = {
    "organization_name": "Antigravity Cloud",
    "admin_email": "ops@antigravity.internal",
    "tier": "enterprise",
}

tenant = CreateTenantRequest(**payload)
print(f"Validated Tenant: {tenant.organization_name} ({tenant.admin_email})")
print(f"Model Dump: {tenant.model_dump()}")''',
          keyTakeaways: [
            'Pydantic v2 validates requests 5-10x faster using the rust-pydantic-core engine.',
            'Use `Depends()` to inject reusable database sessions and authorization contexts.',
            'Never expose raw ORM database models directly to external HTTP consumers.',
          ],
        ),
        BookletChapter(
          title: 'Async Database Sessions & Connection Pooling',
          subtitle: 'Preventing connection starvation under high concurrency',
          content: '''In an async microservice, blocking I/O calls (like synchronous database drivers) will freeze the entire event loop for all concurrent users.

Always pair async web frameworks with async drivers (like `asyncpg` for PostgreSQL or `aiosqlite` for SQLite). Configure explicit connection pool limits (`pool_size=20`, `max_overflow=10`) to protect the database against connection spikes.''',
          codeExample: '''# Connection Pool Configuration Pattern
class DatabasePoolConfig:
    pool_size: int = 20
    max_overflow: int = 10
    pool_timeout: int = 30
    pool_recycle: int = 1800  # Recycle idle sockets after 30 mins

config = DatabasePoolConfig()
print(f"Pool Active Limit: {config.pool_size} + {config.max_overflow} overflow")
print(f"Socket Recycle:    {config.pool_recycle}s to prevent stale TCP connections")''',
          keyTakeaways: [
            'Always use async drivers (asyncpg) to keep the ASGI event loop unblocked.',
            'Tune pool size and max overflow based on database CPU core count and max_connections.',
            'Set connection recycle timeouts to prevent dropped connections across NAT gateways.',
          ],
        ),
      ],
    ),
    PythonBooklet(
      id: 'booklet_algorithms_interview_playbook',
      title: 'Python Algorithms & LeetCode Patterns',
      subtitle: 'Two Pointers, Sliding Window, Monotonic Stacks & Graph BFS/DFS',
      tag: 'INTERVIEW PLAYBOOK',
      readTime: '15 min read',
      chapters: [
        BookletChapter(
          title: 'Two Pointers & Sliding Window Mechanics',
          subtitle: 'Optimizing O(N^2) brute-force searches into linear O(N) scans',
          content: '''Array and string problems frequently require finding contiguous sequences meeting target constraints. Brute-force nested loops inspect every pair in O(N^2) time.

The Sliding Window technique expands a right pointer to include elements, and contracts a left pointer when constraints are violated, guaranteeing each element enters and leaves the window at most once for an optimal O(N) runtime.''',
          codeExample: '''def min_subarray_len(target: int, nums: list[int]) -> int:
    left = 0
    current_sum = 0
    min_len = float("inf")

    for right in range(len(nums)):
        current_sum += nums[right]
        while current_sum >= target:
            min_len = min(min_len, right - left + 1)
            current_sum -= nums[left]
            left += 1

    return min_len if min_len != float("inf") else 0

print("Min Subarray Length for sum >= 7 in [2,3,1,2,4,3]:")
print(min_subarray_len(7, [2, 3, 1, 2, 4, 3]))  # 2 ([4, 3])''',
          keyTakeaways: [
            'Sliding window guarantees each element is processed at most twice: O(N) time.',
            'Use two pointers converging from both ends for sorted pair sums.',
            'Track window state with hash maps or running aggregates for O(1) condition checks.',
          ],
        ),
        BookletChapter(
          title: 'Tree & Graph Traversals: BFS vs DFS',
          subtitle: 'Choosing between recursion stacks and FIFO queues',
          content: '''Graphs and trees model relational networks, dependency graphs, and search trees.

- **Depth-First Search (DFS)**: Uses the recursion call stack (or explicit LIFO stack) to explore as deep as possible along each branch before backtracking. Best for path finding and topological sorting.
- **Breadth-First Search (BFS)**: Uses a FIFO queue (`collections.deque`) to explore nodes layer-by-layer. Best for shortest path in unweighted graphs.''',
          codeExample: '''from collections import deque

graph = {
    "A": ["B", "C"],
    "B": ["D", "E"],
    "C": ["F"],
    "D": [], "E": ["F"], "F": []
}

def bfs_shortest_path(graph, start, target):
    queue = deque([[start]])
    visited = {start}

    while queue:
        path = queue.popleft()
        node = path[-1]
        if node == target:
            return path
        for neighbor in graph.get(node, []):
            if neighbor not in visited:
                visited.add(neighbor)
                queue.append(path + [neighbor])
    return None

print("BFS Shortest Path A -> F:", bfs_shortest_path(graph, "A", "F"))''',
          keyTakeaways: [
            'BFS guarantees shortest path in unweighted graphs because it explores by depth layers.',
            'Always use `collections.deque` for O(1) `popleft()`; lists take O(N) to pop index 0.',
            'Always track `visited` sets to prevent infinite loops in cyclic graphs.',
          ],
        ),
      ],
    ),
  ];
}
