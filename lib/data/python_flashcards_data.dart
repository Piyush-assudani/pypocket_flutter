class PythonFlashcard {
  final String id;
  final String category;
  final String question;
  final String answer;
  final String? codeExample;
  final String keyInsight;

  const PythonFlashcard({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    this.codeExample,
    required this.keyInsight,
  });
}

class PythonFlashcardsData {
  static const List<PythonFlashcard> cards = [
    // --- FOUNDATIONS & DATA STRUCTURES ---
    PythonFlashcard(
      id: "fc_1",
      category: "Foundations",
      question: "What is the key difference between a List and a Tuple?",
      answer: "Lists are MUTABLE (elements can be added, removed, or changed in place) and denoted with []. Tuples are IMMUTABLE (cannot be modified after creation), faster, memory-efficient, hashable (can be dict keys), and denoted with ().",
      codeExample: '''# List (Mutable)
nums = [1, 2]
nums.append(3) # OK

# Tuple (Immutable)
coords = (10, 20)
# coords[0] = 5 -> TypeError!''',
      keyInsight: "Use tuples for fixed collections of heterogeneous data and dictionary keys; use lists for dynamic sequences.",
    ),
    PythonFlashcard(
      id: "fc_2",
      category: "Foundations",
      question: "How does Python's `is` operator differ from `==`?",
      answer: "`==` tests for VALUE EQUALITY (do the two objects represent equal data?). `is` tests for IDENTITY (do both variables reference the exact same object in memory, i.e. id(a) == id(b)?).",
      codeExample: '''a = [1, 2, 3]
b = [1, 2, 3]
print(a == b)  # True (equal values)
print(a is b)  # False (distinct memory objects)

c = a
print(c is a)  # True (same reference)''',
      keyInsight: "Always use `is` when comparing against singleton values like `x is None`.",
    ),
    PythonFlashcard(
      id: "fc_3",
      category: "Foundations",
      question: "What is the difference between Shallow Copy and Deep Copy?",
      answer: "A shallow copy (`copy.copy()`) creates a new container object, but populates it with references to the original nested child objects. A deep copy (`copy.deepcopy()`) recursively clones the container AND all nested child objects.",
      codeExample: '''import copy
orig = [[1, 2], [3, 4]]
shallow = copy.copy(orig)
deep = copy.deepcopy(orig)

shallow[0][0] = 99
print(orig[0][0])  # 99! (shared nested reference)
print(deep[0][0])  # 1 (completely independent)''',
      keyInsight: "Mutating nested items in a shallow copy will mutate the original structure.",
    ),
    PythonFlashcard(
      id: "fc_4",
      category: "Foundations",
      question: "What are F-Strings and why are they preferred over `%` or `.format()`?",
      answer: "Formatted string literals (F-strings, introduced in Python 3.6) allow inline expression evaluation inside `{}`. They are evaluated at runtime directly in bytecode, making them substantially faster and far more readable than `%` formatting or `str.format()`.",
      codeExample: '''name = "PyPocket"
version = 3.12
# Fast, clear, supports inline expressions
print(f"Running {name.upper()} on Python {version:.1f}")''',
      keyInsight: "F-strings support full Python expressions inside braces, e.g. `{x * 2}` or `{datetime.now():%Y-%m-%d}`.",
    ),
    PythonFlashcard(
      id: "fc_5",
      category: "Foundations",
      question: "What does the Walrus Operator `:=` do?",
      answer: "The walrus operator `:=` (assignment expression) assigns a value to a variable while simultaneously returning that value inside an expression. This avoids redundant function evaluations in loops and conditionals.",
      codeExample: '''# Without walrus:
val = compute_score()
if val > 80:
    print(val)

# With walrus :=
if (val := compute_score()) > 80:
    print(val)''',
      keyInsight: "Saves lines and CPU cycles when reading streams, regex matches, or filtering list comprehensions.",
    ),

    // --- OOP & DUNDER METHODS ---
    PythonFlashcard(
      id: "fc_6",
      category: "OOP & Dunders",
      question: "What is the difference between `__str__` and `__repr__`?",
      answer: "`__repr__` is intended for developers/debugging: it should be unambiguous and ideally valid Python code to recreate the object. `__str__` is intended for end-users: a clean, readable representation. If `__str__` is omitted, Python falls back to `__repr__`.",
      codeExample: '''class Point:
    def __init__(self, x, y):
        self.x, self.y = x, y
    def __repr__(self):
        return f"Point({self.x}, {self.y})"
    def __str__(self):
        return f"({self.x}, {self.y})"''',
      keyInsight: "Always implement at least `__repr__` for any custom class.",
    ),
    PythonFlashcard(
      id: "fc_7",
      category: "OOP & Dunders",
      question: "What does `__getitem__` and `__setitem__` enable on custom classes?",
      answer: "They implement square bracket subscript indexing `obj[key]` and item assignment `obj[key] = val`, turning your custom object into a subscriptable container like a list or dictionary.",
      codeExample: '''class Cache:
    def __init__(self):
        self._data = {}
    def __getitem__(self, key):
        return self._data[key]
    def __setitem__(self, key, value):
        self._data[key] = value

c = Cache()
c["token"] = "xyz"  # calls __setitem__
print(c["token"])    # calls __getitem__''',
      keyInsight: "Enables Pythonic duck-typing without needing to subclass built-in dict or list.",
    ),
    PythonFlashcard(
      id: "fc_8",
      category: "OOP & Dunders",
      question: "What is the purpose of `@property` and `@setter`?",
      answer: "The `@property` decorator allows a method to be accessed like an attribute (without parentheses `()`). This provides clean encapsulation and getter/setter validation without breaking existing public API access.",
      codeExample: '''class Account:
    def __init__(self, balance):
        self._balance = balance

    @property
    def balance(self):
        return self._balance

    @balance.setter
    def balance(self, value):
        if value < 0:
            raise ValueError("Balance cannot be negative")
        self._balance = value''',
      keyInsight: "Never write `get_balance()` in Python; use `@property` instead.",
    ),
    PythonFlashcard(
      id: "fc_9",
      category: "OOP & Dunders",
      question: "What does `@classmethod` vs `@staticmethod` mean?",
      answer: "`@classmethod` takes `cls` (the class object) as its first argument and can access/modify class state or serve as alternative constructors. `@staticmethod` takes neither `self` nor `cls`; it acts as an ordinary utility function namespaced inside the class.",
      codeExample: '''class Date:
    def __init__(self, day, month, year):
        self.day, self.month, self.year = day, month, year

    @classmethod
    def from_string(cls, date_str): # Alt constructor
        d, m, y = map(int, date_str.split('-'))
        return cls(d, m, y)

    @staticmethod
    def is_valid_year(year):
        return year > 1900''',
      keyInsight: "Use class methods for factory patterns like `from_json()` or `from_dict()`.",
    ),

    // --- MEMORY & INTERNALS ---
    PythonFlashcard(
      id: "fc_10",
      category: "Memory & Internals",
      question: "What is the Python Global Interpreter Lock (GIL)?",
      answer: "The GIL is a mutex in CPython that ensures only one native OS thread executes Python bytecode at any given time. Because of this, CPU-bound tasks do not achieve multi-core parallelism using `threading`; you must use `multiprocessing` or native C extensions instead. I/O-bound tasks still benefit from threads.",
      codeExample: '''# CPU Bound -> Use multiprocessing:
from multiprocessing import Process

# I/O Bound (Network, Disk) -> Use threading or asyncio:
import asyncio''',
      keyInsight: "GIL protects CPython memory management and reference counting from race conditions.",
    ),
    PythonFlashcard(
      id: "fc_11",
      category: "Memory & Internals",
      question: "How does Python's Garbage Collection work?",
      answer: "Python primarily uses REFERENCE COUNTING: every object tracks how many references point to it. When the count drops to 0, memory is immediately reclaimed. To handle CYCLIC REFERENCES (e.g. A references B and B references A), Python has a cyclical generational garbage collector (Generations 0, 1, 2) that periodically runs.",
      codeExample: '''import sys
x = [1, 2, 3]
print(sys.getrefcount(x)) # Count of references''',
      keyInsight: "Use weak references (`import weakref`) when caching to prevent cyclic memory leaks.",
    ),
    PythonFlashcard(
      id: "fc_12",
      category: "Memory & Internals",
      question: "Why should you NEVER use a mutable default argument like `def func(lst=[])`?",
      answer: "Default arguments in Python are evaluated once when the function definition is executed, NOT each time the function is called. If you mutate the default argument, that same mutated list persists across subsequent function calls!",
      codeExample: '''# [BUGGY]:
def append_to(item, target=[]):
    target.append(item)
    return target

print(append_to(1)) # [1]
print(append_to(2)) # [1, 2] -- UNEXPECTED!

# [CORRECT]:
def append_to(item, target=None):
    if target is None:
        target = []
    target.append(item)
    return target''',
      keyInsight: "Always use `None` as the default value for mutable parameter arguments.",
    ),

    // --- TIME COMPLEXITIES & BIG-O ---
    PythonFlashcard(
      id: "fc_13",
      category: "Big-O Complexities",
      question: "What is the average time complexity of Dictionary and Set lookups in Python?",
      answer: "Average time complexity is O(1) CONSTANT TIME for key lookup, insertion, and deletion. This is because dicts and sets are implemented using optimized hash tables with open addressing. In the worst case (excessive hash collisions), complexity degrades to O(N).",
      codeExample: '''# O(1) lookup
if "target" in my_dict: ...
if 42 in my_set: ...

# O(N) lookup (linear search)
if 42 in my_list: ...''',
      keyInsight: "Checking membership `x in collection` is vastly faster on sets than lists.",
    ),
    PythonFlashcard(
      id: "fc_14",
      category: "Big-O Complexities",
      question: "What is the time complexity of `list.insert(0, val)` vs `list.append(val)`?",
      answer: "`list.append(val)` is amortized O(1) constant time because elements are added to the end. `list.insert(0, val)` or `list.pop(0)` is O(N) LINEAR TIME because all remaining N elements must be shifted in memory. Use `collections.deque` for O(1) left inserts/pops.",
      codeExample: '''from collections import deque
# O(1) both ends!
queue = deque([1, 2, 3])
queue.appendleft(0)  # O(1)
queue.popleft()      # O(1)''',
      keyInsight: "For FIFO queue operations, never use standard Python lists; use `deque`.",
    ),
    PythonFlashcard(
      id: "fc_15",
      category: "Big-O Complexities",
      question: "What sorting algorithm does Python's `list.sort()` and `sorted()` use?",
      answer: "Python uses TIMSORT, an adaptive hybrid of Merge Sort and Insertion Sort designed by Tim Peters. Its worst-case and average time complexity is O(N log N), and best-case (on already-sorted data) is O(N) with O(N) auxiliary space. It is a STABLE sort.",
      codeExample: '''# Timsort in action:
data = [(1, 'B'), (1, 'A'), (2, 'C')]
data.sort(key=lambda x: x[0])
# Guaranteed stable relative ordering preserved''',
      keyInsight: "Timsort is optimized to exploit pre-existing natural ordering patterns in real-world data.",
    ),

    // --- CONCURRENCY & ASYNCIO ---
    PythonFlashcard(
      id: "fc_16",
      category: "Concurrency",
      question: "What is the difference between `yield` and `return`?",
      answer: "`return` terminates a function and sends back a value, destroying its local execution stack. `yield` pauses the function, emits an intermediate value to the consumer, and remembers its entire state, resuming from that exact spot on the next `next()` call.",
      codeExample: '''def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

gen = fibonacci()
print([next(gen) for _ in range(5)]) # [0, 1, 1, 2, 3]''',
      keyInsight: "Generators use O(1) memory regardless of how many billions of items they produce.",
    ),
    PythonFlashcard(
      id: "fc_17",
      category: "Concurrency",
      question: "What is the purpose of Python's `async` and `await` syntax?",
      answer: "`async def` declares a coroutine. `await` yields execution back to the event loop while waiting for an asynchronous I/O operation (e.g. database query, network HTTP request) to complete, allowing single-threaded concurrency without blocking.",
      codeExample: '''import asyncio

async def fetch_data():
    await asyncio.sleep(1) # Simulates network I/O
    return {"status": "ok"}

async def main():
    result = await fetch_data()
    print(result)

# Run with: asyncio.run(main())''',
      keyInsight: "Asynchronous programming shines in high-concurrency I/O applications.",
    ),
    PythonFlashcard(
      id: "fc_18",
      category: "Modern Python",
      question: "How does structural pattern matching (`match/case`) differ from traditional `if/elif` chains?",
      answer: "`match/case` (introduced in Python 3.10 via PEP 634) deconstructs complex object structures, unpacks nested sequences or dictionaries, validates types, and matches literals in a single expressive syntax with optional guard clauses.",
      codeExample: '''command = ["deploy", "v2.0", "--canary"]
match command:
    case ["deploy", version, *flags]:
        print(f"Deploying {version} with flags: {flags}")
    case _:
        print("Unknown command pattern")''',
      keyInsight: "Pattern matching evaluates structural shape, sub-types, and values simultaneously.",
    ),
    PythonFlashcard(
      id: "fc_19",
      category: "Memory & Internals",
      question: "Why does `@dataclass(slots=True)` reduce memory consumption by up to 60%?",
      answer: "Standard Python classes store instance attributes in a dynamic dictionary (`__dict__`), which carries high hash table memory overhead. `slots=True` replaces `__dict__` with a fixed-size C array of pointers matching declared fields.",
      codeExample: '''from dataclasses import dataclass

@dataclass(slots=True)
class FastCoordinate:
    x: float
    y: float

pt = FastCoordinate(10.5, 20.8)
# pt.__dict__ does not exist; pt.__slots__ stores ('x', 'y')''',
      keyInsight: "Use slots=True for classes instantiated millions of times to drastically slash RAM usage.",
    ),
    PythonFlashcard(
      id: "fc_20",
      category: "Security",
      question: "Why should you use `secrets.compare_digest()` instead of `==` for authentication tokens?",
      answer: "The `==` operator performs early termination: it returns `False` immediately upon the first mismatched character. An attacker measuring request response latency in nanoseconds can deduce character by character (a timing side-channel attack). `secrets.compare_digest()` compares in constant time regardless of where mismatches occur.",
      codeExample: '''import secrets

expected_token = "secure_secret_token_abc"
user_token = "secure_secret_token_xyz"

# Timing-safe constant-time evaluation
is_valid = secrets.compare_digest(expected_token, user_token)''',
      keyInsight: "Always use constant-time comparisons for HMACs, passwords, and API secret tokens.",
    ),
    PythonFlashcard(
      id: "fc_21",
      category: "Architecture",
      question: "What is the difference between `abc.ABC` and `typing.Protocol`?",
      answer: "`abc.ABC` enforces nominal subtyping: a class must explicitly inherit `class Service(BaseService)` to satisfy the interface. `typing.Protocol` enforces structural subtyping (duck typing): any class implementing matching methods and signatures satisfies the Protocol without explicit inheritance.",
      codeExample: '''from typing import Protocol, runtime_checkable

@runtime_checkable
class Renderable(Protocol):
    def render(self) -> str: ...

class TerminalCard:
    def render(self) -> str:
        return "[CARD]"

# True without inheriting Renderable!
print(isinstance(TerminalCard(), Renderable))''',
      keyInsight: "Protocols enable static duck typing without forcing inheritance coupling across modules.",
    ),
    PythonFlashcard(
      id: "fc_22",
      category: "Concurrency",
      question: "When should you use `ProcessPoolExecutor` instead of `ThreadPoolExecutor`?",
      answer: "Use `ThreadPoolExecutor` for I/O-bound tasks (file reading, HTTP calls) where threads yield CPU during I/O wait. Use `ProcessPoolExecutor` for CPU-bound tasks (cryptography, image processing, numerical math) to bypass the GIL and utilize multiple CPU cores in parallel.",
      codeExample: '''from concurrent.futures import ProcessPoolExecutor

def heavy_computation(x):
    return sum(i * i for i in range(x))

with ProcessPoolExecutor() as pool:
    results = list(pool.map(heavy_computation, [1000000, 2000000]))''',
      keyInsight: "Threads for I/O-bound concurrency; processes for multi-core CPU-bound parallelism.",
    ),
  ];
}
