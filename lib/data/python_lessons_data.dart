import '../models/lesson_model.dart';

class PythonLessonsData {
  static const List<Lesson> lessons = [
    // ================= TRACK 1: FOUNDATIONS =================
    Lesson(
      id: "intro_vars",
      track: "Foundations",
      title: "Variables & Dynamic Types",
      description: "Master variables, primitive memory allocation, dynamic typing, and runtime inspection.",
      content: '''Python is dynamically typed: variable names are references bound to objects in memory. You don't declare types ahead of time; the CPython runtime determines types dynamically.

### Key Concepts:
- **Reference Semantics**: `x = 10` creates an integer object `10` and binds the label `x` to it.
- **Dynamic Rebinding**: A variable can point to an integer and later be rebound to a string or dictionary.
- **Identity vs Equality**: `==` checks value equality, while `is` checks memory address identity via `id(x)`.
- **f-strings**: Modern Python 3.6+ string interpolation `f"Value: {val}"`.
''',
      codeExample: '''# Variables & Dynamic Typing Demo
language = "Python"
version = 3.12
is_compiled_to_bytecode = True

print(f"Language: {language} (Type: {type(language).__name__})")
print(f"Version:  {version} (Type: {type(version).__name__})")
print(f"Bytecode: {is_compiled_to_bytecode}")

# Dynamic Rebinding
counter = 42
print(f"Initial counter: {counter} ({type(counter).__name__})")
counter = "Forty Two"
print(f"Rebound counter: {counter} ({type(counter).__name__})")
''',
      expectedOutput: '''Language: Python (Type: str)
Version:  3.12 (Type: float)
Bytecode: True
Initial counter: 42 (Type: int)
Rebound counter: Forty Two (Type: str)''',
      exercisePrompt: "Create variables for `creator` ('Guido van Rossum') and `year` (1991), then print an f-string: '{creator} invented Python in {year}'.",
      starterCode: '''# Assign variables and print the exact sentence:
creator = "Guido van Rossum"
year = 1991

# Write print statement below:
''',
      solutionCode: '''creator = "Guido van Rossum"
year = 1991
print(f"{creator} invented Python in {year}")
''',
      xp: 40,
      difficulty: LessonDifficulty.easy,
      youtubeVideoId: "kqtD5dpn9C8",
      videoTitle: "Python Variables & Data Types Deep Dive",
      videoDurationMinutes: 12,
      keyConcepts: [
        "Dynamic rebinding and reference semantics",
        "Type inspection with type() and isinstance()",
        "f-strings expressions and format specifiers",
      ],
      commonMistakes: [
        "Confusing '==' (value equality) with 'is' (memory identity)",
        "Overwriting built-in names like 'list', 'str', 'id', 'input'",
      ],
    ),

    Lesson(
      id: "strings_slicing",
      track: "Foundations",
      title: "String Slicing & Immutability",
      description: "Master string indexing, reverse step slicing [::-1], immutability, and formatting.",
      content: '''In Python, strings are **immutable sequences** of Unicode characters. Once created, individual characters cannot be mutated in place (`s[0] = 'X'` raises a `TypeError`).

### Slicing Formula:
`sequence[start:stop:step]`
- `start`: inclusive starting index (default `0`)
- `stop`: exclusive ending index (default `len`)
- `step`: stride / step size (negative step reverses direction)
''',
      codeExample: '''phrase = "Python Developer"

print("First 6 chars:", phrase[:6])
print("Last word:     ", phrase[7:])
print("Every 2nd char:", phrase[::2])
print("Reversed:      ", phrase[::-1])

# String Methods
tokens = phrase.upper().split()
print("Tokens:        ", tokens)
print("Joined:        ", "-".join(tokens))
''',
      expectedOutput: '''First 6 chars: Python
Last word:      Developer
Every 2nd char: Pto eeoe
Reversed:       repoleveD nohtyP
Tokens:         ['PYTHON', 'DEVELOPER']
Joined:         PYTHON-DEVELOPER''',
      exercisePrompt: "Write a function `is_palindrome(text)` that returns True if the lowercase alphanumeric text reads the same forwards and backwards.",
      starterCode: '''def is_palindrome(text):
    clean = text.lower().replace(" ", "")
    pass

print(is_palindrome("racecar"))
print(is_palindrome("python"))
''',
      solutionCode: '''def is_palindrome(text):
    clean = text.lower().replace(" ", "")
    return clean == clean[::-1]

print(is_palindrome("racecar"))
print(is_palindrome("python"))
''',
      xp: 45,
      difficulty: LessonDifficulty.easy,
      youtubeVideoId: "k9TUPpGqYTo",
      videoTitle: "String Formatting & Advanced Slicing",
      videoDurationMinutes: 14,
      keyConcepts: [
        "String immutability and memory optimization",
        "Extended slice syntax [start:stop:step]",
        "Efficient string concatenation with str.join()",
      ],
      commonMistakes: [
        "Attempting in-place mutation (e.g. s[0] = 'a')",
        "Repeated '+=' string concatenation inside large loops instead of join()",
      ],
    ),

    Lesson(
      id: "numbers_math_precision",
      track: "Foundations",
      title: "Numerical Types & Math Operations",
      description: "Understand arbitrary-precision integers, IEEE floating point limits, and the math module.",
      content: '''Python seamlessly handles arbitrary-precision integers (`int` expands in memory to fit massive calculations). Floating point numbers (`float`) use 64-bit IEEE 754 standards.

### Operators:
- `//`: Floor division (truncates towards negative infinity).
- `%`: Modulo operator.
- `**`: Power exponentiation (`2 ** 10 = 1024`).
- `math.isclose()`: Recommended way to test floating-point equality.
''',
      codeExample: '''import math

# Arbitrary Precision Integer
huge_int = 2 ** 100
print("2^100 digits:", len(str(huge_int)))

# Float Precision Warning
a = 0.1 + 0.2
print("0.1 + 0.2 == 0.3?", a == 0.3)
print("Safe comparison:", math.isclose(a, 0.3))

# Math functions
print("Hypotenuse (3, 4):", math.hypot(3, 4))
print("Floor div 7 // 2:  ", 7 // 2)
''',
      expectedOutput: '''2^100 digits: 31
0.1 + 0.2 == 0.3? False
Safe comparison: True
Hypotenuse (3, 4): 5.0
Floor div 7 // 2:   3''',
      exercisePrompt: "Write a function `circle_area(radius)` that returns the area rounded to 2 decimal places using `math.pi`.",
      starterCode: '''import math

def circle_area(radius):
    # Compute pi * r^2 and round to 2 decimals
    pass

print(circle_area(5))
''',
      solutionCode: '''import math

def circle_area(radius):
    return round(math.pi * (radius ** 2), 2)

print(circle_area(5))
''',
      xp: 45,
      difficulty: LessonDifficulty.easy,
      youtubeVideoId: "D48iCW3WpBQ",
      videoTitle: "Numeric Types, Floats & Math in Python",
      videoDurationMinutes: 13,
      keyConcepts: [
        "Arbitrary-precision integers vs fixed IEEE-754 floats",
        "Using math.isclose() for floating-point comparisons",
        "Bitwise operations (&, |, ^, ~, <<, >>)",
      ],
      commonMistakes: [
        "Using `==` directly on float arithmetic calculations",
        "Dividing by zero without try-except handling",
      ],
    ),

    // ================= TRACK 2: CONTROL FLOW =================
    Lesson(
      id: "control_flow_match",
      track: "Control Flow",
      title: "Conditionals & Structural Pattern Matching",
      description: "Harness if/elif/else chains, boolean short-circuiting, and modern match/case statements.",
      content: '''Python 3.10 introduced **Structural Pattern Matching** (`match/case`), bringing modern algebraic pattern matching capabilities beyond traditional switch statements.

### Features:
- **Short-circuit Evaluation**: In `a and b`, if `a` is False, `b` is never evaluated.
- **Match-Case Patterns**: Matches shapes of data (sequences, mappings, class instances) with optional guards `if condition`.
''',
      codeExample: '''def handle_command(command):
    match command.split():
      case ["quit"]:
        return "Exiting session."
      case ["load", filename]:
        return f"Loading file: {filename}"
      case ["save", filename, ("--force" | "-f")]:
        return f"Force saving to {filename}!"
      case ["save", filename]:
        return f"Saving to {filename}."
      case _:
        return "Unknown command syntax."

print(handle_command("load script.py"))
print(handle_command("save model.pkl --force"))
print(handle_command("quit"))
''',
      expectedOutput: '''Loading file: script.py
Force saving to model.pkl!
Exiting session.''',
      exercisePrompt: "Implement `evaluate_http_status(code)` using `match case` to return 'OK' for 200, 'Not Found' for 404, 'Server Error' for 500, and 'Other' for anything else.",
      starterCode: '''def evaluate_http_status(code):
    pass

print(evaluate_http_status(200))
print(evaluate_http_status(404))
print(evaluate_http_status(500))
''',
      solutionCode: '''def evaluate_http_status(code):
    match code:
      case 200:
        return "OK"
      case 404:
        return "Not Found"
      case 500:
        return "Server Error"
      case _:
        return "Other"

print(evaluate_http_status(200))
print(evaluate_http_status(404))
print(evaluate_http_status(500))
''',
      xp: 50,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "DZwmZ8Usvnk",
      videoTitle: "Conditionals, Logic & Modern Match-Case",
      videoDurationMinutes: 16,
      keyConcepts: [
        "Short-circuit boolean logic (and/or)",
        "Structural pattern matching with wildcards and guards",
        "Truthy and Falsy evaluations in Python",
      ],
      commonMistakes: [
        "Using '==' with None instead of 'is None'",
        "Unintentional fallthrough assumptions from other C-style languages",
      ],
    ),

    Lesson(
      id: "loops_comprehensions",
      track: "Control Flow",
      title: "Comprehensions & Iterators",
      description: "Write idiomatic list, dictionary, and generator comprehensions for blazing performance.",
      content: '''Comprehensions provide a concise syntax for deriving new sequences from existing iterables. Under the hood, they execute in C speed within CPython's bytecode.

### Comprehension Flavors:
- **List**: `[x * 2 for x in items if x > 0]`
- **Dict**: `{k: v for k, v in pairs}`
- **Set**: `{x % 5 for x in items}`
- **Generator**: `(x ** 2 for x in stream)` (lazy evaluation)
''',
      codeExample: '''numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# List comprehension with filter
evens_squared = [x**2 for x in numbers if x % 2 == 0]
print("Evens squared:", evens_squared)

# Dict comprehension
square_map = {x: x**2 for x in range(1, 6)}
print("Square map:   ", square_map)

# Enumerate with start index
for rank, num in enumerate(evens_squared[:3], start=1):
  print(f"Top {rank}: {num}")
''',
      expectedOutput: '''Evens squared: [4, 16, 36, 64, 100]
Square map:    {1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
Top 1: 4
Top 2: 16
Top 3: 36''',
      exercisePrompt: "Filter words that start with uppercase letters and return their lengths in a dictionary `{word: len(word)}`.",
      starterCode: '''words = ["Python", "dart", "Rust", "javascript", "Go"]

def get_capitalized_lengths(word_list):
    pass

print(get_capitalized_lengths(words))
''',
      solutionCode: '''words = ["Python", "dart", "Rust", "javascript", "Go"]

def get_capitalized_lengths(word_list):
    return {w: len(w) for w in word_list if w[0].isupper()}

print(get_capitalized_lengths(words))
''',
      xp: 55,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "6iF8Xb7Z3wQ",
      videoTitle: "List Comprehensions & Generator Performance",
      videoDurationMinutes: 18,
      keyConcepts: [
        "Comprehensions vs map/filter vs standard for-loops",
        "Memory efficiency with Generator Expressions",
        "Using zip() and enumerate() idioms",
      ],
      commonMistakes: [
        "Writing nested comprehensions that sacrifice code readability",
        "Mutating a list while iterating over it",
      ],
    ),

    // ================= TRACK 3: DATA STRUCTURES =================
    Lesson(
      id: "data_structures_dicts",
      track: "Data Structures",
      title: "HashMaps, Dictionaries & Sets",
      description: "Deep dive into Python's hash tables, dictionary views, sets, and constant-time lookups.",
      content: '''Python's `dict` is an insertion-ordered hash table offering amortized **O(1)** time complexity for lookups, insertions, and deletions.

### Crucial Methods:
- `.get(key, default)`: Avoids `KeyError` when a key is absent.
- `.setdefault(key, default)`: Inserts key if not present and returns value.
- `.items()`, `.keys()`, `.values()`: Dynamic view objects.
- `set`: Unordered collection of unique hashable items, supporting union `|`, intersection `&`, and difference `-`.
''',
      codeExample: '''user_roles = {
    "alice": "admin",
    "bob": "developer",
    "charlie": "designer",
}

print("Alice role:  ", user_roles.get("alice"))
print("Dave role:   ", user_roles.get("dave", "guest"))

# Set operations
dev_skills = {"python", "sql", "docker", "git"}
ai_skills = {"python", "pytorch", "math", "git"}

shared = dev_skills & ai_skills
print("Shared skills:", sorted(shared))
print("All skills:   ", sorted(dev_skills | ai_skills))
''',
      expectedOutput: '''Alice role:   admin
Dave role:    guest
Shared skills: ['git', 'python']
All skills:    ['docker', 'git', 'math', 'python', 'pytorch', 'sql']''',
      exercisePrompt: "Write a function `count_frequencies(items)` that takes a list of strings and returns a frequency dictionary without using external libraries.",
      starterCode: '''def count_frequencies(items):
    counts = {}
    pass

print(count_frequencies(["apple", "banana", "apple", "orange", "banana", "apple"]))
''',
      solutionCode: '''def count_frequencies(items):
    counts = {}
    for item in items:
        counts[item] = counts.get(item, 0) + 1
    return counts

print(count_frequencies(["apple", "banana", "apple", "orange", "banana", "apple"]))
''',
      xp: 60,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "daefaLgNkw0",
      videoTitle: "Dictionaries & Sets: Hash Tables in CPython",
      videoDurationMinutes: 19,
      keyConcepts: [
        "Hashability requirement (__hash__ and __eq__)",
        "Amortized O(1) lookups vs O(N) list searches",
        "Set mathematical operations (union, intersection, symmetric difference)",
      ],
      commonMistakes: [
        "Using mutable types (like lists) as dictionary keys or set members",
        "Direct bracket indexing `d[key]` without checking or `.get()`",
      ],
    ),

    Lesson(
      id: "collections_module",
      track: "Data Structures",
      title: "The Collections Module",
      description: "Master specialized container datatypes: Counter, defaultdict, deque, and namedtuple.",
      content: '''The standard library `collections` module provides high-performance alternatives to Python's general-purpose built-in containers.

### Specialized Types:
- `Counter`: Dict subclass for counting hashable objects with `.most_common()`.
- `defaultdict`: Calls a factory function to supply missing values without raising KeyError.
- `deque`: Double-ended queue with **O(1)** appends and pops from both ends (unlike list O(N) pop(0)).
- `namedtuple`: Lightweight tuple with named fields for self-documenting data.
''',
      codeExample: '''from collections import Counter, defaultdict, deque, namedtuple

# 1. Counter
votes = ["py", "rs", "py", "go", "py", "rs"]
tally = Counter(votes)
print("Winner:      ", tally.most_common(1)[0])

# 2. Defaultdict
grouped = defaultdict(list)
pairs = [("backend", "FastAPI"), ("frontend", "Flutter"), ("backend", "Django")]
for category, tech in pairs:
    grouped[category].append(tech)
print("Backend stack:", grouped["backend"])

# 3. Deque
dq = deque([10, 20, 30])
dq.appendleft(5)
dq.append(40)
print("Deque elements:", list(dq))

# 4. Namedtuple
Point = namedtuple("Point", ["x", "y"])
pt = Point(12, 34)
print(f"Point: ({pt.x}, {pt.y})")
''',
      expectedOutput: '''Winner:       ('py', 3)
Backend stack: ['FastAPI', 'Django']
Deque elements: [5, 10, 20, 30, 40]
Point: (12, 34)''',
      exercisePrompt: "Write a function `top_words(text, n)` that returns a list of the n most frequent words in a text using `Counter`.",
      starterCode: '''from collections import Counter

def top_words(text, n):
    # Split text into lowercase words and return list of top n words
    pass

print(top_words("apple banana apple orange apple banana", 2))
''',
      solutionCode: '''from collections import Counter

def top_words(text, n):
    words = text.lower().split()
    return [word for word, count in Counter(words).most_common(n)]

print(top_words("apple banana apple orange apple banana", 2))
''',
      xp: 65,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "VGHPzXWqL9g",
      videoTitle: "Python Collections Module: Counter, Defaultdict & Deque",
      videoDurationMinutes: 16,
      keyConcepts: [
        "O(1) double-ended queue operations with deque",
        "Grouping and aggregation with defaultdict(list)",
        "Counter frequency analysis and arithmetic",
      ],
      commonMistakes: [
        "Using list.pop(0) in performance-critical queues instead of deque.popleft()",
        "Accidentally creating default values in defaultdict during key inspection",
      ],
    ),

    // ================= TRACK 4: FUNCTIONS =================
    Lesson(
      id: "functions_args_kwargs",
      track: "Functions",
      title: "First-Class Functions, *args & **kwargs",
      description: "Understand variadic arguments, keyword unpacking, lexical scoping, and closures.",
      content: '''In Python, functions are **first-class citizens**: they can be passed as arguments, assigned to variables, returned from other functions, and stored in data structures.

### Variadic Arguments:
- `*args`: Collects extra positional arguments into a `tuple`.
- `**kwargs`: Collects extra keyword arguments into a `dict`.
- Keyword-Only arguments: Arguments defined after a bare `*` must be passed by keyword.
''',
      codeExample: '''def create_profile(username, *tags, status="active", **metadata):
    print(f"User: {username} [{status}]")
    print(f"Tags: {tags}")
    for k, v in metadata.items():
        print(f"  {k}: {v}")

create_profile(
    "dev_user",
    "python", "fullstack", "ai",
    status="verified",
    location="Global",
    experience="Senior"
)
''',
      expectedOutput: '''User: dev_user [verified]
Tags: ('python', 'fullstack', 'ai')
  location: Global
  experience: Senior''',
      exercisePrompt: "Write a function `multiply_all(*numbers, factor=1)` that returns the product of all given numbers multiplied by the keyword factor.",
      starterCode: '''def multiply_all(*numbers, factor=1):
    pass

print(multiply_all(2, 3, 4, factor=2))
print(multiply_all(5, 5))
''',
      solutionCode: '''def multiply_all(*numbers, factor=1):
    product = 1
    for n in numbers:
        product *= n
    return product * factor

print(multiply_all(2, 3, 4, factor=2))
print(multiply_all(5, 5))
''',
      xp: 65,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "9Os0o3wzS_I",
      videoTitle: "Functions, Scope & Argument Unpacking",
      videoDurationMinutes: 17,
      keyConcepts: [
        "First-class function semantics & lambda expressions",
        "Positional-only and keyword-only parameters",
        "LEGB rule (Local, Enclosing, Global, Built-in)",
      ],
      commonMistakes: [
        "Mutable default arguments (`def fn(x=[])`) causing persistent state bugs",
        "Modifying global variables without `global` or `nonlocal` declarations",
      ],
    ),

    Lesson(
      id: "generators_yield",
      track: "Functions",
      title: "Generators, Yield & Lazy Evaluation",
      description: "Produce memory-efficient streaming pipelines using yield and generator state machines.",
      content: '''A **generator function** pauses execution upon encountering `yield`, preserving its entire local state frame. When requested via `next()` or a `for` loop, execution resumes right where it stopped.

### Why Generators?
- **Zero Memory Overhead**: Processing a 50GB log file line-by-line takes only kilobytes of RAM.
- **Infinite Streams**: Can model infinite series (e.g. Fibonacci, timestamps).
- `yield from`: Delegates sub-generator iteration smoothly.
''',
      codeExample: '''def countdown(n):
    print(f"[Starting countdown from {n}]")
    while n > 0:
        yield n
        n -= 1
    print("[Liftoff!]")

# Iterating lazily
for step in countdown(3):
    print("T-minus:", step)

# Infinite Generator Demo (first 5 even numbers)
def evens():
    i = 0
    while True:
        yield i
        i += 2

gen = evens()
sample = [next(gen) for _ in range(5)]
print("First 5 evens:", sample)
''',
      expectedOutput: '''[Starting countdown from 3]
T-minus: 3
T-minus: 2
T-minus: 1
[Liftoff!]
First 5 evens: [0, 2, 4, 6, 8]''',
      exercisePrompt: "Write a generator function `fibonacci_gen(limit)` that yields Fibonacci numbers up to `limit`.",
      starterCode: '''def fibonacci_gen(limit):
    a, b = 0, 1
    # Yield numbers while a <= limit
    pass

print(list(fibonacci_gen(20)))
''',
      solutionCode: '''def fibonacci_gen(limit):
    a, b = 0, 1
    while a <= limit:
        yield a
        a, b = b, a + b

print(list(fibonacci_gen(20)))
''',
      xp: 70,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "bD05uGo_sVI",
      videoTitle: "Generators & Yield in Python Explained",
      videoDurationMinutes: 15,
      keyConcepts: [
        "Lazy evaluation vs eager sequence evaluation",
        "Generator state preservation and the iterator protocol",
        "Generator delegation using `yield from`",
      ],
      commonMistakes: [
        "Trying to index a generator (`gen[0]`) instead of consuming with `next()`",
        "Attempting to re-iterate over an already exhausted generator",
      ],
    ),

    Lesson(
      id: "decorators_closures",
      track: "Functions",
      title: "Decorators & Metaprogramming",
      description: "Master closures, higher-order functions, and custom function decorators with @functools.wraps.",
      content: '''A **decorator** is a callable that takes a function as input and returns a replacement callable, allowing you to inject cross-cutting concerns (logging, timing, auth, caching) cleanly.

### Anatomy:
```python
def my_decorator(func):
  @functools.wraps(func)
  def wrapper(*args, **kwargs):
    # before
    result = func(*args, **kwargs)
    # after
    return result

  return wrapper
```
''',
      codeExample: '''import time
from functools import wraps

def timer_decorator(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        duration = time.perf_counter() - start
        print(f"[{func.__name__}] executed in {duration:.6f}s")
        return result
    return wrapper

@timer_decorator
def compute_sum(n):
    return sum(range(n))

val = compute_sum(100000)
print(f"Result: {val}")
''',
      expectedOutput: '''[compute_sum] executed in 0.001850s
Result: 4999950000''',
      exercisePrompt: "Create a decorator `repeat_twice(func)` that calls the decorated function twice whenever invoked and returns the last result.",
      starterCode: '''from functools import wraps

def repeat_twice(func):
    pass

@repeat_twice
def greet(name):
    print(f"Hello, {name}!")

greet("PyPocket")
''',
      solutionCode: '''from functools import wraps

def repeat_twice(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        func(*args, **kwargs)
        return func(*args, **kwargs)
    return wrapper

@repeat_twice
def greet(name):
    print(f"Hello, {name}!")

greet("PyPocket")
''',
      xp: 75,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "FsAPt_9Bf3U",
      videoTitle: "Python Decorators in Depth",
      videoDurationMinutes: 24,
      keyConcepts: [
        "Lexical closures retaining outer scope environment",
        "Preserving function metadata with @functools.wraps",
        "Decorators accepting custom arguments",
      ],
      commonMistakes: [
        "Forgetting to return the result of `func(*args, **kwargs)` from wrapper",
        "Losing docstrings and `__name__` by omitting `@wraps`",
      ],
    ),

    // ================= TRACK 5: OOP MASTERY =================
    Lesson(
      id: "oop_classes_dunders",
      track: "OOP Mastery",
      title: "Classes, Dunder Methods & Encapsulation",
      description: "Build robust object-oriented architectures with @property, __repr__, operator overloading, and inheritance.",
      content: '''Python's OOP system leverages **dunder (double underscore) methods** to integrate custom classes directly into Python's core language syntax (iteration, arithmetic, string formatting).

### Core Dunder Methods:
- `__init__(self, ...)`: Instance initializer.
- `__repr__(self)`: Unambiguous string representation for developers.
- `__str__(self)`: Human-friendly string representation.
- `__eq__(self, other)`: Implements `==` comparison.
- `__add__(self, other)`: Implements `+` operator overloading.
- `@property`: Managed attribute getter with optional `@prop.setter`.
''',
      codeExample: '''import math

class Vector2D:
    def __init__(self, x: float, y: float):
        self._x = float(x)
        self._y = float(y)

    @property
    def x(self) -> float:
        return self._x

    @property
    def y(self) -> float:
        return self._y

    def magnitude(self) -> float:
        return math.hypot(self._x, self._y)

    def __add__(self, other: 'Vector2D') -> 'Vector2D':
        return Vector2D(self._x + other._x, self._y + other._y)

    def __repr__(self) -> str:
        return f"Vector2D({self._x}, {self._y})"

v1 = Vector2D(3, 4)
v2 = Vector2D(1, 2)
v3 = v1 + v2

print("v1:", v1)
print("v2:", v2)
print("v1 + v2 =", v3)
print("v1 Magnitude:", v1.magnitude())
''',
      expectedOutput: '''v1: Vector2D(3.0, 4.0)
v2: Vector2D(1.0, 2.0)
v1 + v2 = Vector2D(4.0, 6.0)
v1 Magnitude: 5.0''',
      exercisePrompt: "Create a `BankAccount` class with `owner` and `balance`. Implement `deposit(amount)`, `withdraw(amount)` (preventing overdrafts), and `__repr__`.",
      starterCode: '''class BankAccount:
    def __init__(self, owner, balance=0.0):
        pass

    def deposit(self, amount):
        pass

    def withdraw(self, amount):
        pass

    def __repr__(self):
        pass

acct = BankAccount("Satoshi", 100.0)
acct.deposit(50.0)
acct.withdraw(30.0)
print(acct)
''',
      solutionCode: '''class BankAccount:
    def __init__(self, owner, balance=0.0):
        self.owner = owner
        self.balance = float(balance)

    def deposit(self, amount):
        self.balance += amount
        return self.balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError("Insufficient balance")
        self.balance -= amount
        return self.balance

    def __repr__(self):
        return f"BankAccount(owner='{self.owner}', balance={self.balance:.2f})"

acct = BankAccount("Satoshi", 100.0)
acct.deposit(50.0)
acct.withdraw(30.0)
print(acct)
''',
      xp: 80,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "ZDa-Z5JzLYM",
      videoTitle: "Object Oriented Programming (OOP) in Python",
      videoDurationMinutes: 32,
      keyConcepts: [
        "Encapsulation using private conventions `_var` and `@property`",
        "Operator overloading via dunder protocol",
        "Method Resolution Order (MRO) with super()",
      ],
      commonMistakes: [
        "Confusing class attributes (shared across all instances) with instance attributes",
        "Omitting `self` parameter in instance methods",
      ],
    ),

    Lesson(
      id: "oop_inheritance_abc",
      track: "OOP Mastery",
      title: "Inheritance, Polymorphism & Abstract Classes",
      description: "Implement interface contracts with abc.ABC, method resolution order (MRO), and super().",
      content: '''Abstract Base Classes (`abc.ABC`) enforce design contracts across subclasses by ensuring derived classes implement mandatory `@abstractmethod` signatures.

### Inheritance Architecture:
- `super().__init__(...)`: Invokes parent class constructors correctly according to C3 Linearization.
- `isinstance(obj, Cls)`: Polymorphic type checks.
- `Class.__mro__`: Displays method resolution order hierarchy.
''',
      codeExample: '''from abc import ABC, abstractmethod

class Shape(ABC):
    @abstractmethod
    def area(self) -> float:
        """Calculate shape area."""
        pass

class Circle(Shape):
    def __init__(self, radius: float):
        self.radius = radius

    def area(self) -> float:
        return 3.14159 * (self.radius ** 2)

class Rectangle(Shape):
    def __init__(self, w: float, h: float):
        self.w = w
        self.h = h

    def area(self) -> float:
        return self.w * self.h

shapes: list[Shape] = [Circle(3), Rectangle(4, 5)]
for s in shapes:
    print(f"{type(s).__name__} Area: {s.area():.2f}")
''',
      expectedOutput: '''Circle Area: 28.27
Rectangle Area: 20.00''',
      exercisePrompt: "Create an abstract class `Vehicle` with abstract method `drive()`. Subclass it as `ElectricCar` returning 'Driving silently with EV motor'.",
      starterCode: '''from abc import ABC, abstractmethod

class Vehicle(ABC):
    pass

class ElectricCar(Vehicle):
    pass

car = ElectricCar()
print(car.drive())
''',
      solutionCode: '''from abc import ABC, abstractmethod

class Vehicle(ABC):
    @abstractmethod
    def drive(self):
        pass

class ElectricCar(Vehicle):
    def drive(self):
        return "Driving silently with EV motor"

car = ElectricCar()
print(car.drive())
''',
      xp: 85,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "RSl87lqOXDE",
      videoTitle: "Inheritance & Abstract Base Classes (ABCs)",
      videoDurationMinutes: 20,
      keyConcepts: [
        "Enforcing subclass contracts with @abstractmethod",
        "Multiple inheritance and C3 Linearization MRO",
        "Composition over inheritance principles",
      ],
      commonMistakes: [
        "Instantiating an abstract class directly (raises TypeError)",
        "Forgetting to implement all abstract methods in concrete subclasses",
      ],
    ),

    // ================= TRACK 6: ERROR HANDLING =================
    Lesson(
      id: "error_handling_exceptions",
      track: "Error Handling",
      title: "Defensive Coding & Custom Exceptions",
      description: "Master EAFP idioms, try/except/else/finally blocks, and user-defined exception hierarchies.",
      content: '''Python follows the **EAFP philosophy**: *"Easier to Ask for Forgiveness than Permission"*. Instead of checking conditions defensively with multiple `if` statements, run the operation and handle potential exceptions gracefully.

### Structure:
```python
try:
  # risky operation
  pass
except SpecificError as e:
  # handle specific error
  pass
else:
  # executed ONLY if NO exception was raised
  pass
finally:
  # ALWAYS executed (e.g. cleanup, close sockets)
  pass
```
''',
      codeExample: '''class ValidationError(Exception):
    """Custom domain-specific exception."""
    pass

def register_user(username, age):
    try:
        if len(username) < 3:
            raise ValidationError("Username must have at least 3 characters.")
        if age < 18:
            raise ValidationError("User must be at least 18 years old.")
        return f"User '{username}' registered successfully."
    except ValidationError as err:
        return f"Registration Failed: {err}"
    finally:
        print("[Audit Log] Registration attempt completed.")

print(register_user("al", 22))
print(register_user("turing", 25))
''',
      expectedOutput: '''[Audit Log] Registration attempt completed.
Registration Failed: Username must have at least 3 characters.
[Audit Log] Registration attempt completed.
User 'turing' registered successfully.''',
      exercisePrompt: "Write a function `safe_divide(a, b)` that returns `a / b`, catches `ZeroDivisionError` and `TypeError`, and returns `None` on failure.",
      starterCode: '''def safe_divide(a, b):
    pass

print(safe_divide(10, 2))
print(safe_divide(10, 0))
print(safe_divide(10, "two"))
''',
      solutionCode: '''def safe_divide(a, b):
    try:
        return a / b
    except (ZeroDivisionError, TypeError):
        return None

print(safe_divide(10, 2))
print(safe_divide(10, 0))
print(safe_divide(10, "two"))
''',
      xp: 70,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "NIWwJbo-9_8",
      videoTitle: "Python Exception Handling & Debugging",
      videoDurationMinutes: 19,
      keyConcepts: [
        "EAFP vs LBYL programming paradigms",
        "Catching specific exceptions rather than bare `except:`",
        "Raising custom exceptions inheriting from Exception",
      ],
      commonMistakes: [
        "Using bare `except:` which catches KeyboardInterrupt and SystemExit",
        "Swallowing exceptions silently without logging or re-raising",
      ],
    ),

    Lesson(
      id: "context_managers_with",
      track: "Error Handling",
      title: "Context Managers & The 'with' Protocol",
      description: "Manage deterministic resource acquisition and cleanup via __enter__, __exit__, and contextlib.",
      content: '''Context managers guarantee that external resources (files, database sessions, mutex locks) are reliably released, even if unexpected exceptions occur during execution.

### Implementing Context Managers:
1. **Class-based**: Implement `__enter__(self)` and `__exit__(self, exc_type, exc_val, exc_tb)`.
2. **Generator-based**: Use the `@contextmanager` decorator from `contextlib` with a `try...finally` block.
''',
      codeExample: '''from contextlib import contextmanager
import time

@contextmanager
def benchmark_stage(stage_name):
    print(f"--> [ENTER] Stage: {stage_name}")
    start = time.perf_counter()
    try:
        yield
    finally:
        elapsed = time.perf_counter() - start
        print(f"<-- [EXIT]  Stage: {stage_name} (Duration: {elapsed:.4f}s)")

with benchmark_stage("Data Normalization"):
    total = sum(x**2 for x in range(50000))
    print("Computed total:", total)
''',
      expectedOutput: '''--> [ENTER] Stage: Data Normalization
Computed total: 41665416675000
<-- [EXIT]  Stage: Data Normalization (Duration: 0.0035s)''',
      exercisePrompt: "Create a class-based context manager `SuppressErrors(*exceptions)` that silences specified exception types inside the with block.",
      starterCode: '''class SuppressErrors:
    def __init__(self, *exceptions):
        self.exceptions = exceptions

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        # Return True if exc_type is in self.exceptions to suppress it
        pass

with SuppressErrors(ZeroDivisionError):
    x = 1 / 0
print("Continued without crashing!")
''',
      solutionCode: '''class SuppressErrors:
    def __init__(self, *exceptions):
        self.exceptions = exceptions

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        if exc_type is not None and issubclass(exc_type, self.exceptions):
            return True
        return False

with SuppressErrors(ZeroDivisionError):
    x = 1 / 0
print("Continued without crashing!")
''',
      xp: 75,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "-aKFBoZpiqA",
      videoTitle: "Context Managers and the with Statement",
      videoDurationMinutes: 18,
      keyConcepts: [
        "RAII resource management principles in Python",
        "Suppressing or propagating exceptions in __exit__",
        "Using contextlib.contextmanager generator patterns",
      ],
      commonMistakes: [
        "Forgetting to return True from __exit__ when intending to suppress an error",
        "Failing to close files or connections outside a with statement",
      ],
    ),

    // ================= TRACK 7: FILES & DATA =================
    Lesson(
      id: "files_json_serialization",
      track: "Files & Data",
      title: "File I/O, Pathlib & JSON Processing",
      description: "Master modern cross-platform filesystem path navigation and structured JSON serialization.",
      content: '''Python's `pathlib` module replaces legacy `os.path` operations with object-oriented paths. Combined with `json`, it provides clean pipelines for reading, transforming, and persisting configuration data.

### Highlights:
- `Path.cwd()`, `Path.home()`: Absolute anchor paths.
- `path / "subfolder" / "data.json"`: Path joining via operator overloading `/`.
- `json.dumps(obj, indent=2)`: Formats Python dictionaries to JSON strings.
- `json.loads(str)`: Deserializes JSON strings to Python dictionaries.
''',
      codeExample: '''import json
from pathlib import Path

# Create in-memory mock JSON payload
developer_data = {
    "project": "PyPocket",
    "version": "2.0.0",
    "features": ["3D UI", "CPython Engine", "Certificates"],
    "metrics": {"tests_passing": True, "coverage": 98.5}
}

# Serialize to formatted JSON string
json_str = json.dumps(developer_data, indent=2)
print("Serialized JSON:\\n" + json_str)

# Parse back
parsed = json.loads(json_str)
print("\\nParsed Project Name:", parsed["project"])
print("Feature Count:      ", len(parsed["features"]))
''',
      expectedOutput: '''Serialized JSON:
{
  "project": "PyPocket",
  "version": "2.0.0",
  "features": [
    "3D UI",
    "CPython Engine",
    "Certificates"
  ],
  "metrics": {
    "tests_passing": true,
    "coverage": 98.5
  }
}

Parsed Project Name: PyPocket
Feature Count:       3''',
      exercisePrompt: "Write a function `safe_json_parse(raw_str)` that safely parses a JSON string, returning an empty dict `{}` if `json.JSONDecodeError` occurs.",
      starterCode: '''import json

def safe_json_parse(raw_str):
    pass

print(safe_json_parse('{"id": 101, "valid": true}'))
print(safe_json_parse('invalid json format'))
''',
      solutionCode: '''import json

def safe_json_parse(raw_str):
    try:
        return json.loads(raw_str)
    except (json.JSONDecodeError, TypeError):
        return {}

print(safe_json_parse('{"id": 101, "valid": true}'))
print(safe_json_parse('invalid json format'))
''',
      xp: 70,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "9XJ3n2kK6rE",
      videoTitle: "File Objects, Pathlib & JSON in Python",
      videoDurationMinutes: 21,
      keyConcepts: [
        "Object-oriented path manipulation with pathlib.Path",
        "Difference between json.dump/load (files) vs json.dumps/loads (strings)",
        "Custom serialization encoders for complex types like datetime",
      ],
      commonMistakes: [
        "Opening files without specifying encoding='utf-8' leading to platform bugs",
        "Writing non-serializable objects (sets, custom classes) without custom serializer",
      ],
    ),

    Lesson(
      id: "regex_pattern_matching",
      track: "Files & Data",
      title: "Regular Expressions & Text Extraction",
      description: "Master pattern matching, capture groups, and regex lookaheads with the re module.",
      content: '''The `re` module allows you to locate substrings, validate input formats (emails, URLs, UUIDs), and perform structural pattern replacements using regular expressions.

### Crucial Functions:
- `re.search(pattern, text)`: Finds first match anywhere in string.
- `re.findall(pattern, text)`: Returns list of all matching string patterns.
- `re.sub(pattern, replacement, text)`: String substitution with regex patterns.
- Raw strings `r"pattern"`: Prevents Python escape character interference.
''',
      codeExample: '''import re

sample_text = "Contact devs at hello@pypocket.app or support@coders.io. Emergency: 1-800-555-0199."

# Email extraction
email_pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}'
emails = re.findall(email_pattern, sample_text)
print("Found Emails:", emails)

# Capture groups
phone_pattern = r'(\\d{1})-(\\d{3})-(\\d{3})-(\\d{4})'
match = re.search(phone_pattern, sample_text)
if match:
    country, area, prefix, line = match.groups()
    print(f"Phone Extracted: Area Code ({area}), Local: {prefix}-{line}")
''',
      expectedOutput: '''Found Emails: ['hello@pypocket.app', 'support@coders.io']
Phone Extracted: Area Code (800), Local: 555-0199''',
      exercisePrompt: "Write a function `extract_hashtags(post)` that returns a list of all words starting with '#' (excluding the '#' symbol).",
      starterCode: '''import re

def extract_hashtags(post):
    # Use re.findall with capture group r'#(\\w+)'
    pass

print(extract_hashtags("Loving #python and #flutter for mobile development #100DaysOfCode"))
''',
      solutionCode: '''import re

def extract_hashtags(post):
    return re.findall(r'#(\\w+)', post)

print(extract_hashtags("Loving #python and #flutter for mobile development #100DaysOfCode"))
''',
      xp: 75,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "K8L6KVGG-7o",
      videoTitle: "Regular Expressions (Regex) in Python",
      videoDurationMinutes: 25,
      keyConcepts: [
        "Pre-compiling patterns with re.compile() for high-volume loops",
        "Named capture groups `(?P<name>...)` for readable matches",
        "Greedy `.*` vs non-greedy `.*?` quantifiers",
      ],
      commonMistakes: [
        "Omitting raw string prefix `r'...'` leading to escaped backslash issues",
        "Catastrophic backtracking caused by nested unconstrained regex patterns",
      ],
    ),

    // ================= TRACK 8: CONCURRENCY =================
    Lesson(
      id: "async_concurrency",
      track: "Concurrency",
      title: "Async/Await & Event Loops",
      description: "Master modern asynchronous I/O, coroutines, tasks, and asyncio.gather for concurrent execution.",
      content: '''Python's `asyncio` library provides single-threaded cooperative multitasking using an **event loop**. It excels at I/O-bound operations (network requests, database calls, file streaming) by avoiding thread overhead.

### Keywords:
- `async def`: Declares a coroutine function.
- `await`: Suspends coroutine execution until the awaitable completes.
- `asyncio.gather(*tasks)`: Runs multiple coroutines concurrently.
''',
      codeExample: '''import asyncio

async def fetch_api(source: str, delay: float):
    print(f"Requesting {source}...")
    await asyncio.sleep(delay)
    print(f"Received {source} data.")
    return {source: "200 OK"}

async def main():
    print("Starting concurrent API pipeline:")
    results = await asyncio.gather(
        fetch_api("Weather Service", 0.1),
        fetch_api("Stock Exchange", 0.05),
        fetch_api("User Database", 0.08),
    )
    print("All responses gathered:")
    for res in results:
        print(" ", res)

# In standard Python: asyncio.run(main())
print("Async pipeline simulated:")
print("Weather Service: 200 OK")
print("Stock Exchange: 200 OK")
print("User Database: 200 OK")
''',
      expectedOutput: '''Async pipeline simulated:
Weather Service: 200 OK
Stock Exchange: 200 OK
User Database: 200 OK''',
      exercisePrompt: "Write an async function `download_chunk(chunk_id)` that awaits `asyncio.sleep(0.01)` and returns `f'Chunk {chunk_id} ready'`.",
      starterCode: '''import asyncio

async def download_chunk(chunk_id):
    pass
''',
      solutionCode: '''import asyncio

async def download_chunk(chunk_id):
    await asyncio.sleep(0.01)
    return f"Chunk {chunk_id} ready"
''',
      xp: 85,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "t5Bo1Je9EmE",
      videoTitle: "Async IO & Concurrency in Modern Python",
      videoDurationMinutes: 28,
      keyConcepts: [
        "Event loop cooperative scheduling vs OS threading",
        "When to use asyncio (I/O-bound) vs multiprocessing (CPU-bound)",
        "Handling timeouts with asyncio.wait_for()",
      ],
      commonMistakes: [
        "Calling blocking synchronous code (like time.sleep) inside async routines",
        "Creating a coroutine without awaiting it (raising RuntimeWarning)",
      ],
    ),

    Lesson(
      id: "threading_multiprocessing",
      track: "Concurrency",
      title: "Threading, Multiprocessing & The GIL",
      description: "Bypass CPython's Global Interpreter Lock (GIL) using ProcessPoolExecutor and ThreadPoolExecutor.",
      content: '''The **Global Interpreter Lock (GIL)** in CPython ensures only one native thread executes Python bytecode at a time. Therefore:
- **I/O-Bound**: Use `threading` or `asyncio` (GIL is released during socket/file waits).
- **CPU-Bound**: Use `multiprocessing` to spawn separate processes with independent memory spaces.
''',
      codeExample: '''from concurrent.futures import ThreadPoolExecutor

def process_item(item_id):
    return f"Processed item #{item_id} successfully"

# Concurrent execution using pool executor
items = [101, 102, 103, 104]
with ThreadPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(process_item, items))

for r in results:
    print(r)
''',
      expectedOutput: '''Processed item #101 successfully
Processed item #102 successfully
Processed item #103 successfully
Processed item #104 successfully''',
      exercisePrompt: "Write a function `parallel_squares(numbers)` that computes squares using `ThreadPoolExecutor` and returns the sorted list of results.",
      starterCode: '''from concurrent.futures import ThreadPoolExecutor

def parallel_squares(numbers):
    # Use ThreadPoolExecutor.map to square all numbers
    pass

print(parallel_squares([1, 2, 3, 4, 5]))
''',
      solutionCode: '''from concurrent.futures import ThreadPoolExecutor

def square(n):
    return n * n

def parallel_squares(numbers):
    with ThreadPoolExecutor() as executor:
        return list(executor.map(square, numbers))

print(parallel_squares([1, 2, 3, 4, 5]))
''',
      xp: 90,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "IEEhzQoKtQU",
      videoTitle: "Threading vs Multiprocessing in Python",
      videoDurationMinutes: 26,
      keyConcepts: [
        "The CPython Global Interpreter Lock (GIL) and its implications",
        "concurrent.futures high-level worker pool interfaces",
        "Inter-process communication (IPC) and serialization costs",
      ],
      commonMistakes: [
        "Using multi-threading for CPU-heavy tasks expecting a speedup (GIL prevents parallelism)",
        "Race conditions on shared mutable data without threading.Lock",
      ],
    ),

    // ================= TRACK 9: ALGORITHMS =================
    Lesson(
      id: "algorithms_binary_search",
      track: "Algorithms",
      title: "Binary Search & Two-Pointer Techniques",
      description: "Master logarithmic O(log N) searches and optimal two-pointer array partitions.",
      content: '''Binary Search divides sorted search intervals in half each step, achieving **O(log N)** time complexity (e.g. searching 1 billion sorted records in only ~30 comparisons).

### Two-Pointer Strategy:
Pointers start at opposite ends or at the same end moving at different speeds (Floyd's Tortoise & Hare) to solve array problems in **O(N)** time without auxiliary space.
''',
      codeExample: '''def binary_search(arr, target):
    left, right = 0, len(arr) - 1
    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# Two Sum with Two Pointers (Sorted Array)
def two_sum_sorted(arr, target):
    l, r = 0, len(arr) - 1
    while l < r:
        total = arr[l] + arr[r]
        if total == target:
            return (l, r)
        elif total < target:
            l += 1
        else:
            r -= 1
    return None

data = [2, 5, 8, 12, 16, 23, 38, 56, 72, 91]
print("Index of 23:    ", binary_search(data, 23))
print("Pairs summing to 28:", two_sum_sorted(data, 28))
''',
      expectedOutput: '''Index of 23:     5
Pairs summing to 28: (3, 4)''',
      exercisePrompt: "Write `search_insert_position(nums, target)` that returns index if target is found, or where it would be inserted in order.",
      starterCode: '''def search_insert_position(nums, target):
    pass

print(search_insert_position([1, 3, 5, 6], 5))
print(search_insert_position([1, 3, 5, 6], 2))
print(search_insert_position([1, 3, 5, 6], 7))
''',
      solutionCode: '''def search_insert_position(nums, target):
    l, r = 0, len(nums) - 1
    while l <= r:
        mid = (l + r) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            l = mid + 1
        else:
            r = mid - 1
    return l

print(search_insert_position([1, 3, 5, 6], 5))
print(search_insert_position([1, 3, 5, 6], 2))
print(search_insert_position([1, 3, 5, 6], 7))
''',
      xp: 90,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "MFhxShGxHWc",
      videoTitle: "Binary Search & Two Pointer Algorithms",
      videoDurationMinutes: 22,
      keyConcepts: [
        "O(log N) divide-and-conquer search guarantees",
        "Preventing integer overflow when calculating mid",
        "Two-pointer directional invariants",
      ],
      commonMistakes: [
        "Off-by-one errors with `while left < right` vs `while left <= right`",
        "Forgetting that Binary Search strictly requires sorted input data",
      ],
    ),

    Lesson(
      id: "algorithms_memoization_dp",
      track: "Algorithms",
      title: "Recursion, Memoization & Dynamic Programming",
      description: "Master recursive base cases, call stacks, memoization with lru_cache, and bottom-up DP.",
      content: '''Dynamic Programming (DP) solves complex problems by breaking them into overlapping subproblems and storing subproblem solutions to eliminate exponential recalculations.

### Approaches:
1. **Top-Down with Memoization**: Write natural recursive equations and cache intermediate outputs with `@functools.lru_cache`.
2. **Bottom-Up Tabulation**: Build up solutions iteratively in an array or table.
''',
      codeExample: '''from functools import lru_cache

# Top-Down with Built-in LRU Cache
@lru_cache(maxsize=None)
def fibonacci(n):
    if n <= 1:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)

print("Fibonacci(40):", fibonacci(40))

# Bottom-Up Dynamic Programming (Climbing Stairs)
def climb_stairs(n):
    if n <= 2:
        return n
    dp = [0] * (n + 1)
    dp[1], dp[2] = 1, 2
    for i in range(3, n + 1):
        dp[i] = dp[i-1] + dp[i-2]
    return dp[n]

print("Ways to climb 10 stairs:", climb_stairs(10))
''',
      expectedOutput: '''Fibonacci(40): 102334155
Ways to climb 10 stairs: 89''',
      exercisePrompt: "Write `coin_change(coins, amount)` using bottom-up DP to find the minimum number of coins needed to make up that amount (return -1 if impossible).",
      starterCode: '''def coin_change(coins, amount):
    pass

print(coin_change([1, 2, 5], 11))
print(coin_change([2], 3))
''',
      solutionCode: '''def coin_change(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    for coin in coins:
        for x in range(coin, amount + 1):
            dp[x] = min(dp[x], dp[x - coin] + 1)
    return dp[amount] if dp[amount] != float('inf') else -1

print(coin_change([1, 2, 5], 11))
print(coin_change([2], 3))
''',
      xp: 100,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "Qk0zUZW-U_M",
      videoTitle: "Dynamic Programming & Memoization Explained",
      videoDurationMinutes: 30,
      keyConcepts: [
        "Overlapping subproblems and optimal substructure",
        "Top-down memoization vs bottom-up tabulation tradeoffs",
        "Using @functools.lru_cache for automated memoization",
      ],
      commonMistakes: [
        "Omitting recursion base cases causing `RecursionError: maximum recursion depth exceeded`",
        "Creating massive state tables when only previous steps are needed (O(N) space vs O(1))",
      ],
    ),
    // ================= TRACK 7: WEB & APIS =================
    Lesson(
      id: "fastapi_microservices",
      track: "Web & APIs",
      title: "FastAPI & Microservices Architecture",
      description: "Build asynchronous, high-throughput REST APIs with automatic OpenAPI validation and dependency injection.",
      content: '''FastAPI is the modern gold standard for building Python microservices. It is built on Starlette and Pydantic, executing asynchronously on ASGI servers like Uvicorn.

### Key Concepts:
- **Automatic Validation**: Request bodies, query parameters, and headers are typed and validated using Pydantic.
- **Dependency Injection**: Reusable components (`Depends()`) handle database sessions, auth, and external clients.
- **Async Endpoints**: Native `async def` allows endpoints to handle thousands of concurrent requests non-blockingly.
''',
      codeExample: '''# FastAPI Minimal High-Performance Endpoint Simulation
class MockRequest:
    def __init__(self, token: str, payload: dict):
        self.token = token
        self.payload = payload

def auth_dependency(token: str) -> str:
    if token != "Bearer secret_dev_key":
        raise PermissionError("401 Unauthorized")
    return "authorized_user"

def create_order(req: MockRequest):
    user = auth_dependency(req.token)
    item = req.payload.get("item", "Python Masterclass")
    return {"status": 201, "user": user, "order": item}

req = MockRequest(token="Bearer secret_dev_key", payload={"item": "PyPocket Lifetime"})
print("API Response:", create_order(req))
''',
      expectedOutput: '''API Response: {'status': 201, 'user': 'authorized_user', 'order': 'PyPocket Lifetime'}''',
      exercisePrompt: "Write a function `validate_api_payload(payload)` that returns True if 'username' is non-empty and 'age' >= 18, otherwise False.",
      starterCode: '''def validate_api_payload(payload):
    pass

print(validate_api_payload({"username": "alex", "age": 22}))
print(validate_api_payload({"username": "", "age": 20}))
''',
      solutionCode: '''def validate_api_payload(payload):
    return bool(payload.get("username")) and payload.get("age", 0) >= 18

print(validate_api_payload({"username": "alex", "age": 22}))
print(validate_api_payload({"username": "", "age": 20}))
''',
      xp: 85,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "gQTRsZpqjAQ",
      videoTitle: "FastAPI Complete Microservices Guide",
      videoDurationMinutes: 24,
      keyConcepts: [
        "ASGI runtime and asynchronous request handling",
        "Pydantic V2 schema serialization",
        "Dependency injection patterns with Depends()",
      ],
      commonMistakes: [
        "Running synchronous blocking code inside async def endpoints",
        "Neglecting Pydantic validation for incoming query parameters",
      ],
    ),
    // ================= TRACK 8: MODERN PYTHON =================
    Lesson(
      id: "pattern_matching_312",
      track: "Modern Python",
      title: "Structural Pattern Matching (match / case)",
      description: "Harness Python 3.10+ pattern matching to cleanly decompose nested objects, sequences, and mappings.",
      content: '''Structural Pattern Matching (`match / case`) revolutionizes control flow in Python. Unlike basic switch statements, it performs structural destructuring and value binding.

### Key Concepts:
- **Sequence Patterns**: Match lists and tuples by shape: `case [x, y]`.
- **Mapping Patterns**: Extract dictionary keys: `case {"status": 200, "data": d}`.
- **Guard Clauses**: Dynamic conditional filters: `case [x, y] if x > y`.
- **Wildcard**: Default catch-all branch using `case _`.
''',
      codeExample: '''def process_packet(packet):
    match packet:
        case {"type": "ping"}:
            return "PONG"
        case {"type": "data", "payload": [x, y]}:
            return f"Processed coordinates: ({x}, {y})"
        case {"type": "error", "code": code} if code >= 500:
            return f"Critical Server Fault {code}"
        case _:
            return "Unrecognized Packet"

print(process_packet({"type": "ping"}))
print(process_packet({"type": "data", "payload": [10, 20]}))
print(process_packet({"type": "error", "code": 503}))
''',
      expectedOutput: '''PONG
Processed coordinates: (10, 20)
Critical Server Fault 503''',
      exercisePrompt: "Write `evaluate_action(action)` using `match/case` to return 'MOVE' for ['move', direction], 'ATTACK' for ['attack'], and 'IDLE' for anything else.",
      starterCode: '''def evaluate_action(action):
    pass

print(evaluate_action(["move", "north"]))
print(evaluate_action(["attack"]))
print(evaluate_action(["sleep"]))
''',
      solutionCode: '''def evaluate_action(action):
    match action:
        case ["move", _]:
            return "MOVE"
        case ["attack"]:
            return "ATTACK"
        case _:
            return "IDLE"

print(evaluate_action(["move", "north"]))
print(evaluate_action(["attack"]))
print(evaluate_action(["sleep"]))
''',
      xp: 75,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "ScNNfyq3d_w",
      videoTitle: "Modern Python 3.10-3.12 Pattern Matching",
      videoDurationMinutes: 18,
      keyConcepts: [
        "Destructuring sequences and nested mappings",
        "Using guard clauses for runtime assertion",
        "Wildcard patterns and exhaustion checking",
      ],
      commonMistakes: [
        "Confusing assignment with comparison inside case clauses",
        "Missing the fallback `case _` for unexpected inputs",
      ],
    ),
    // ================= TRACK 9: QUALITY & TESTING =================
    Lesson(
      id: "pytest_testing_suite",
      track: "Quality & Testing",
      title: "Automated Testing with PyTest & Fixtures",
      description: "Write clean, robust unit tests with assertions, fixtures, parametric testing, and mock isolation.",
      content: '''High-quality production software requires automated test verification. `pytest` makes writing tests effortless using native Python `assert` statements.

### Key Concepts:
- **Clean Assertions**: No need for `self.assertEqual`; standard `assert a == b` provides deep introspection.
- **Fixtures**: Reusable setup/teardown functions marked with `@pytest.fixture`.
- **Parametrization**: Run a single test logic across multiple input/output pairs.
''',
      codeExample: '''# PyTest Style Test Suite Simulation
def calculate_discount(price: float, is_vip: bool) -> float:
    if price < 0:
        raise ValueError("Price cannot be negative")
    return price * 0.8 if is_vip else price

# Test Runner Simulation
def run_tests():
    assert calculate_discount(100.0, True) == 80.0, "VIP discount failed"
    assert calculate_discount(100.0, False) == 100.0, "Standard price failed"
    try:
        calculate_discount(-10.0, False)
        assert False, "Should raise ValueError"
    except ValueError:
        pass
    print("Test Suite: 3 passed in 0.02s")

run_tests()
''',
      expectedOutput: '''Test Suite: 3 passed in 0.02s''',
      exercisePrompt: "Write a function `is_valid_email(email)` that returns True if '@' is in email and '.' is in email after the '@'.",
      starterCode: '''def is_valid_email(email):
    pass

print(is_valid_email("dev@pypocket.app"))
print(is_valid_email("invalid_email"))
''',
      solutionCode: '''def is_valid_email(email):
    if "@" not in email:
        return False
    parts = email.split("@")
    return len(parts) == 2 and "." in parts[1]

print(is_valid_email("dev@pypocket.app"))
print(is_valid_email("invalid_email"))
''',
      xp: 70,
      difficulty: LessonDifficulty.easy,
      youtubeVideoId: "byaxg00GMcU",
      videoTitle: "PyTest Complete Beginner to Pro",
      videoDurationMinutes: 20,
      keyConcepts: [
        "Unit testing patterns and assert introspection",
        "Fixtures and modular dependency setup",
        "Exception testing and edge cases",
      ],
      commonMistakes: [
        "Writing tests that depend on state mutated by previous tests",
        "Testing implementation details instead of observable behavior",
      ],
    ),
    // ================= TRACK 10: DATA SCIENCE =================
    Lesson(
      id: "numpy_data_foundations",
      track: "Data Science",
      title: "Data Processing & Vectorized Operations",
      description: "Understand vectorized operations, array broadcasting, and high-performance numerical computation in Python.",
      content: '''Pure Python loops are slow for numerical computations because of dynamic type checking per iteration. Vectorized operations run compiled C-speed loops over contiguous memory blocks.

### Key Concepts:
- **Vectorization**: Performing element-wise operations on arrays without explicit Python `for` loops.
- **Broadcasting**: Automatically expanding smaller arrays across compatible shapes.
- **Memory Contiguity**: C-contiguous memory layouts maximize CPU cache line efficiency.
''',
      codeExample: '''# Vectorized operations vs Python loops simulation
data = [10, 20, 30, 40, 50]

# Vectorized simulation: apply scale factor in one pass
def vectorize_scale(arr, factor):
    return [x * factor for x in arr]

scaled = vectorize_scale(data, 1.5)
print("Original:", data)
print("Scaled:  ", scaled)
print("Mean:    ", sum(scaled) / len(scaled))
''',
      expectedOutput: '''Original: [10, 20, 30, 40, 50]
Scaled:   [15.0, 30.0, 45.0, 60.0, 75.0]
Mean:     45.0''',
      exercisePrompt: "Write `normalize_scores(scores)` that takes a list of integers and returns each score divided by max(scores).",
      starterCode: '''def normalize_scores(scores):
    pass

print(normalize_scores([10, 20, 40, 50]))
''',
      solutionCode: '''def normalize_scores(scores):
    if not scores:
        return []
    max_val = max(scores)
    return [round(s / max_val, 2) for s in scores]

print(normalize_scores([10, 20, 40, 50]))
''',
      xp: 80,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "QUT1VHiLmmI",
      videoTitle: "NumPy & Data Foundations Crash Course",
      videoDurationMinutes: 25,
      keyConcepts: [
        "Vectorized execution vs interpreted Python loops",
        "Array memory layouts and broadcasting",
        "Statistical aggregations and data normalization",
      ],
      commonMistakes: [
        "Using manual nested for-loops instead of vectorized operations",
        "Ignoring zero-division when normalizing data arrays",
      ],
    ),
    // ================= TRACK 11: MODERN OOP & PROTOCOLS =================
    Lesson(
      id: "dataclasses_modern_oop",
      track: "Modern Python",
      title: "Dataclasses, Immutability & Slots",
      description: "Automate boilerplate dunder methods, optimize memory with slots, and create robust immutable data models.",
      content: '''Standard Python classes require verbose `__init__`, `__repr__`, and `__eq__` implementations. `@dataclass` generates these methods automatically via code generation during class definition.

### Key Concepts:
- **`@dataclass`**: Decorator inspecting type annotations to construct standard methods.
- **`frozen=True`**: Creates immutable value objects; mutating an attribute raises `FrozenInstanceError`.
- **`slots=True` (Python 3.10+)**: Replaces instance dynamic `__dict__` with a fixed memory array, saving 40-60% RAM per instance.
- **`field(default_factory=list)`**: Avoids mutable default parameter pitfalls.
''',
      codeExample: '''from dataclasses import dataclass, field

@dataclass(frozen=True, slots=True)
class DeploymentArtifact:
    service_name: str
    version: str
    tags: tuple = ("production", "stable")
    dependencies: list = field(default_factory=list)

artifact = DeploymentArtifact(
    service_name="payment_gateway",
    version="v2.14.0",
    dependencies=["redis", "postgresql"],
)

print(f"Artifact: {artifact}")
print(f"Service:  {artifact.service_name} ({artifact.version})")
print(f"Slots:    {artifact.__slots__}")
''',
      expectedOutput: '''Artifact: DeploymentArtifact(service_name='payment_gateway', version='v2.14.0', tags=('production', 'stable'), dependencies=['redis', 'postgresql'])
Service:  payment_gateway (v2.14.0)
Slots:    ('service_name', 'version', 'tags', 'dependencies')''',
      exercisePrompt: "Write an immutable dataclass `ServerConfig` with `host: str`, `port: int`, and `ssl: bool = True`.",
      starterCode: '''from dataclasses import dataclass

# Define ServerConfig here:
''',
      solutionCode: '''from dataclasses import dataclass

@dataclass(frozen=True)
class ServerConfig:
    host: str
    port: int
    ssl: bool = True

cfg = ServerConfig(host="api.domain.internal", port=8443)
print(cfg.host, cfg.port, cfg.ssl)
''',
      xp: 85,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "vBH6c8g_y3M",
      videoTitle: "Python Dataclasses in Depth",
      videoDurationMinutes: 18,
      keyConcepts: [
        "Automatic generation of __init__, __repr__, and __eq__",
        "Immutability enforcement with frozen=True",
        "Memory footprint reduction with slots=True",
      ],
      commonMistakes: [
        "Passing a mutable list [] as a default field without default_factory",
        "Attempting to mutate attributes on a frozen dataclass",
      ],
    ),
    Lesson(
      id: "protocols_structural_subtyping",
      track: "Object-Oriented Design",
      title: "Protocols & Structural Subtyping",
      description: "Implement Pythonic static duck typing with typing.Protocol and runtime type validation.",
      content: '''Traditional inheritance forces tight coupling between base classes and subclasses. `typing.Protocol` allows structural subtyping (duck typing verified statically by type checkers).

### Key Concepts:
- **Nominal vs Structural Subtyping**: Nominal requires explicit inheritance (`class Dog(Animal)`). Structural requires only that the target class implements the matching method signatures.
- **`@runtime_checkable`**: Enables `isinstance(obj, MyProtocol)` checks at runtime without requiring inheritance.
''',
      codeExample: '''from typing import Protocol, runtime_checkable

@runtime_checkable
class Notifier(Protocol):
    def send_alert(self, message: str) -> bool:
        ...

class EmailNotifier:
    def send_alert(self, message: str) -> bool:
        print(f"[EMAIL ALERT] {message}")
        return True

class SMSNotifier:
    def send_alert(self, message: str) -> bool:
        print(f"[SMS ALERT] {message}")
        return True

def dispatch(notifier: Notifier, msg: str):
    print(f"Valid notifier: {isinstance(notifier, Notifier)}")
    return notifier.send_alert(msg)

dispatch(EmailNotifier(), "Server load 94%")
dispatch(SMSNotifier(), "Disk space critical")
''',
      expectedOutput: '''Valid notifier: True
[EMAIL ALERT] Server load 94%
Valid notifier: True
[SMS ALERT] Disk space critical''',
      exercisePrompt: "Write a Protocol `Serializable` requiring a method `to_dict() -> dict` and test it with a sample class.",
      starterCode: '''from typing import Protocol

# Implement Protocol here:
''',
      solutionCode: '''from typing import Protocol, runtime_checkable

@runtime_checkable
class Serializable(Protocol):
    def to_dict(self) -> dict:
        ...

class UserRecord:
    def __init__(self, username: str):
        self.username = username
    def to_dict(self) -> dict:
        return {"username": self.username}

user = UserRecord("alex_dev")
print("Is Serializable:", isinstance(user, Serializable))
print("Payload:", user.to_dict())
''',
      xp: 85,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "xvb5hGLoK0A",
      videoTitle: "Python Protocols & Static Duck Typing",
      videoDurationMinutes: 19,
      keyConcepts: [
        "Structural subtyping without inheritance coupling",
        "Runtime inspection with @runtime_checkable",
        "Clean architectural boundaries in enterprise apps",
      ],
      commonMistakes: [
        "Forgetting ellipsis (...) in protocol method definitions",
        "Omitting @runtime_checkable when using isinstance()",
      ],
    ),
    // ================= TRACK 12: CONCURRENCY & ASYNC =================
    Lesson(
      id: "asyncio_concurrency_tasks",
      track: "Concurrency & Async",
      title: "AsyncIO Event Loops, Coroutines & Tasks",
      description: "Master cooperative single-threaded concurrency, async/await coroutines, and task gathering.",
      content: '''Python's `asyncio` runs cooperative concurrency on a single OS thread using an event loop. When a coroutine pauses for network or disk I/O, the loop switches execution to other waiting tasks.

### Key Concepts:
- **`async def` / `await`**: Defines a coroutine and suspends execution until the awaitable finishes.
- **`asyncio.gather(*tasks)`**: Concurrently executes multiple coroutines and aggregates results in order.
- **I/O Bound vs CPU Bound**: AsyncIO is ideal for high-concurrency network services, but not for heavy CPU calculations.
''',
      codeExample: '''import asyncio

async def fetch_telemetry(sensor_id: int):
    # Simulates non-blocking network wait
    await asyncio.sleep(0.01)
    return {"sensor": sensor_id, "reading": sensor_id * 14.5}

async def main():
    tasks = [fetch_telemetry(i) for i in range(1, 4)]
    results = await asyncio.gather(*tasks)
    for res in results:
        print(f"Telemetry: Sensor {res['sensor']} -> {res['reading']}C")

asyncio.run(main())
''',
      expectedOutput: '''Telemetry: Sensor 1 -> 14.5C
Telemetry: Sensor 2 -> 29.0C
Telemetry: Sensor 3 -> 43.5C''',
      exercisePrompt: "Write an async function `download_batch(ids)` that uses `asyncio.gather` to fetch all IDs.",
      starterCode: '''import asyncio

async def download_item(item_id):
    await asyncio.sleep(0.01)
    return f"item_{item_id}.bin"

async def download_batch(ids):
    pass

print(asyncio.run(download_batch([101, 102, 103])))
''',
      solutionCode: '''import asyncio

async def download_item(item_id):
    await asyncio.sleep(0.01)
    return f"item_{item_id}.bin"

async def download_batch(ids):
    tasks = [download_item(i) for i in ids]
    return await asyncio.gather(*tasks)

print(asyncio.run(download_batch([101, 102, 103])))
''',
      xp: 90,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "tSLvI_Xb31k",
      videoTitle: "AsyncIO in Python: Complete Tutorial",
      videoDurationMinutes: 28,
      keyConcepts: [
        "Event loop lifecycle and cooperative scheduling",
        "Gathering concurrent tasks with asyncio.gather",
        "Distinguishing blocking time.sleep() vs await asyncio.sleep()",
      ],
      commonMistakes: [
        "Calling blocking time.sleep() inside async coroutines",
        "Calling a coroutine without awaiting it (Coroutine was never awaited warning)",
      ],
    ),
    Lesson(
      id: "multiprocessing_parallelism",
      track: "Concurrency & Async",
      title: "Multiprocessing & Bypassing the GIL",
      description: "Harness multi-core CPU processors for computationally heavy Python workloads using ProcessPoolExecutor.",
      content: '''The Global Interpreter Lock (GIL) prevents pure Python bytecode from executing on multiple OS threads simultaneously. To achieve true parallel CPU execution, you spawn multiple OS processes, each with its own interpreter.

### Key Concepts:
- **`ProcessPoolExecutor`**: High-level pool managing worker processes and inter-process IPC.
- **Serialization (Pickling)**: Arguments and return values must be serializable across process boundaries.
- **CPU-Bound Threshold**: Process spawning incurs IPC overhead; use only for calculations exceeding a few milliseconds.
''',
      codeExample: '''from concurrent.futures import ProcessPoolExecutor
import math

def compute_heavy_factorial(n):
    # Pure CPU calculation
    return sum(int(digit) for digit in str(math.factorial(n)))

inputs = [500, 600, 700]

# Simulate parallel map execution
with ProcessPoolExecutor(max_workers=2) as executor:
    results = list(executor.map(compute_heavy_factorial, inputs))

for inp, res in zip(inputs, results):
    print(f"Digit sum of {inp}! is: {res}")
''',
      expectedOutput: '''Digit sum of 500! is: 4536
Digit sum of 600! is: 5643
Digit sum of 700! is: 6867''',
      exercisePrompt: "Write a function `parallel_square(numbers)` using `ProcessPoolExecutor` to compute squares in parallel.",
      starterCode: '''from concurrent.futures import ProcessPoolExecutor

def square(n):
    return n * n

def parallel_square(numbers):
    pass

print(parallel_square([2, 4, 6, 8]))
''',
      solutionCode: '''from concurrent.futures import ProcessPoolExecutor

def square(n):
    return n * n

def parallel_square(numbers):
    with ProcessPoolExecutor() as executor:
        return list(executor.map(square, numbers))

print(parallel_square([2, 4, 6, 8]))
''',
      xp: 90,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "fKl2JW_qrso",
      videoTitle: "Python Multiprocessing & GIL Bypass",
      videoDurationMinutes: 22,
      keyConcepts: [
        "Process vs Thread memory isolation",
        "ProcessPoolExecutor mapping interface",
        "Pickling overhead and IPC boundaries",
      ],
      commonMistakes: [
        "Using multiprocessing for network I/O instead of async/threading",
        "Passing non-picklable objects (like active file handles or lambdas) to workers",
      ],
    ),
    // ================= TRACK 13: DATA ENGINEERING & DATABASES =================
    Lesson(
      id: "pandas_data_wrangling",
      track: "Data Engineering",
      title: "Tabular Data & GroupBy Aggregations",
      description: "Clean, filter, transform, and aggregate structured datasets using columnar data manipulation techniques.",
      content: '''Data engineering pipelines transform raw records into actionable aggregates. GroupBy operations follow the Split-Apply-Combine paradigm.

### Key Concepts:
- **Split-Apply-Combine**: Segmenting records by categories, computing reduction metrics, and combining into a summary.
- **Columnar Filtering**: Applying logical conditions across record sets without explicit indexing loops.
- **Pivot Summaries**: Reshaping rows into matrix projections for statistical reporting.
''',
      codeExample: r'''# Pure Python Simulation of Pandas DataFrame GroupBy
records = [
    {"dept": "Engineering", "salary": 120000, "active": True},
    {"dept": "Engineering", "salary": 140000, "active": True},
    {"dept": "Product",     "salary": 110000, "active": True},
    {"dept": "Design",      "salary": 95000,  "active": False},
    {"dept": "Product",     "salary": 125000, "active": True},
]

# 1. Filter active employees
active = [r for r in records if r["active"]]

# 2. Group by department
groups = {}
for r in active:
    groups.setdefault(r["dept"], []).append(r["salary"])

# 3. Aggregate metrics
for dept, salaries in groups.items():
    avg = sum(salaries) / len(salaries)
    print(f"Dept: {dept:<12} Headcount: {len(salaries)} Avg Salary: ${avg:,.0f}")
''',
      expectedOutput: r'''Dept: Engineering  Headcount: 2 Avg Salary: $130,000
Dept: Product      Headcount: 2 Avg Salary: $117,500''',
      exercisePrompt: "Write `filter_and_average(records, min_score)` returning the average score of active students.",
      starterCode: '''def filter_and_average(records, min_score):
    pass

sample = [{"name": "A", "score": 90}, {"name": "B", "score": 60}, {"name": "C", "score": 85}]
print(filter_and_average(sample, 70))
''',
      solutionCode: '''def filter_and_average(records, min_score):
    filtered = [r["score"] for r in records if r["score"] >= min_score]
    if not filtered:
        return 0.0
    return round(sum(filtered) / len(filtered), 2)

sample = [{"name": "A", "score": 90}, {"name": "B", "score": 60}, {"name": "C", "score": 85}]
print(filter_and_average(sample, 70))
''',
      xp: 85,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "vmEHCJofslg",
      videoTitle: "Pandas Data Analysis Tutorial",
      videoDurationMinutes: 30,
      keyConcepts: [
        "Split-Apply-Combine aggregation workflow",
        "Record filtering and data normalization",
        "Computing statistical summary metrics",
      ],
      commonMistakes: [
        "Modifying source records directly while iterating",
        "Dividing by zero when filtering yields empty subsets",
      ],
    ),
    Lesson(
      id: "sqlite_database_persistence",
      track: "Databases & Storage",
      title: "Relational SQL & Context Managers",
      description: "Execute transactional database queries, schema migrations, and parameterized SQL safely in Python.",
      content: '''Python ships with a production-grade relational database engine in the standard library: `sqlite3`. Relational integrity guarantees ACID compliance.

### Key Concepts:
- **Parameterized Queries**: Always use `?` placeholders; never format strings directly into SQL (SQL injection vulnerability).
- **Transaction Rollback**: Using `with connection:` guarantees that failed operations automatically roll back without leaving partial state.
- **Row Factories**: Transform tuple rows into dictionary-accessible objects via `connection.row_factory = sqlite3.Row`.
''',
      codeExample: '''import sqlite3

# In-memory transient database for testing
with sqlite3.connect(":memory:") as conn:
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    
    # Schema creation
    cursor.execute("""
        CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            reputation INTEGER DEFAULT 100
        )
    """)
    
    # Parameterized safe insertion
    users = [("alex_staff", 250), ("maya_infra", 320)]
    cursor.executemany("INSERT INTO users (username, reputation) VALUES (?, ?)", users)
    
    # Query execution
    cursor.execute("SELECT username, reputation FROM users WHERE reputation > ?", (200,))
    for row in cursor.fetchall():
        print(f"User: {row['username']} (Reputation: {row['reputation']})")
''',
      expectedOutput: '''User: alex_staff (Reputation: 250)
User: maya_infra (Reputation: 320)''',
      exercisePrompt: "Write `fetch_user(conn, username)` that safely returns the user dictionary or None.",
      starterCode: '''import sqlite3

def fetch_user(conn, username):
    pass
''',
      solutionCode: '''import sqlite3

def fetch_user(conn, username):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username = ?", (username,))
    row = cursor.fetchone()
    return dict(row) if row else None

with sqlite3.connect(":memory:") as conn:
    conn.row_factory = sqlite3.Row
    conn.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, username TEXT)")
    conn.execute("INSERT INTO users (username) VALUES (?)", ("developer_one",))
    print(fetch_user(conn, "developer_one"))
    print(fetch_user(conn, "missing_user"))
''',
      xp: 85,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "byHcYRpMgI4",
      videoTitle: "Python SQLite3 Database Tutorial",
      videoDurationMinutes: 24,
      keyConcepts: [
        "Safe parameterized query execution against SQL injection",
        "Transaction management and context managers",
        "Row factory dictionary transformations",
      ],
      commonMistakes: [
        "Using f-strings to concatenate raw user inputs into SQL strings",
        "Forgetting to commit transactions when modifying on-disk databases",
      ],
    ),
    // ================= TRACK 14: AUTOMATION & SECURITY =================
    Lesson(
      id: "web_scraping_automation",
      track: "Automation & Web",
      title: "HTTP Requests, Sessions & HTML Parsing",
      description: "Build automated web scrapers, manage persistent cookie sessions, and parse structured HTML DOM trees.",
      content: '''Web scraping extracts unstructured HTML from target endpoints and parses it into clean domain objects. Respectful scraping follows robots.txt and includes sensible retry policies.

### Key Concepts:
- **HTTP Session Reuse**: Reusing TCP connections via connection pooling speeds up subsequent requests by 3-5x.
- **CSS Selectors**: Querying DOM tree nodes by tag, class (`.class`), ID (`#id`), and attribute filters.
- **Anti-Bot Etiquette**: Sending realistic `User-Agent` headers and introducing randomized backoff intervals.
''',
      codeExample: r'''import re

# HTML string simulation
html_document = """
<div class="product-catalog">
    <div class="card" data-sku="SKU-1001">
        <h3 class="title">Python Architecture Masterclass</h3>
        <span class="price">$149.00</span>
    </div>
    <div class="card" data-sku="SKU-1002">
        <h3 class="title">FastAPI Microservices Playbook</h3>
        <span class="price">$129.00</span>
    </div>
</div>
"""

# Extract structured cards with regex parsing
pattern = r'<h3 class="title">(.*?)</h3>\s*<span class="price">(.*?)</span>'
matches = re.findall(pattern, html_document)

for title, price in matches:
    print(f"Scraped Product: '{title}' priced at {price}")
''',
      expectedOutput: r'''Scraped Product: 'Python Architecture Masterclass' priced at $149.00
Scraped Product: 'FastAPI Microservices Playbook' priced at $129.00''',
      exercisePrompt: "Write a function `extract_links(html)` using regex to return all href attribute values.",
      starterCode: '''import re

def extract_links(html):
    pass

test_html = '<a href="https://python.org">Python</a> <a href="https://pypi.org">PyPI</a>'
print(extract_links(test_html))
''',
      solutionCode: '''import re

def extract_links(html):
    return re.findall(r'href="([^"]+)"', html)

test_html = '<a href="https://python.org">Python</a> <a href="https://pypi.org">PyPI</a>'
print(extract_links(test_html))
''',
      xp: 85,
      difficulty: LessonDifficulty.medium,
      youtubeVideoId: "XVv6mJpFOb0",
      videoTitle: "Web Scraping with Python",
      videoDurationMinutes: 26,
      keyConcepts: [
        "DOM pattern matching and node extraction",
        "HTTP header injection and user agent management",
        "Data hygiene and sanitizing scraped attributes",
      ],
      commonMistakes: [
        "Flooding endpoints with unthrottled requests causing IP rate limits",
        "Assuming DOM structure never changes across software releases",
      ],
    ),
    Lesson(
      id: "cryptography_hashing_security",
      track: "Security & DevOps",
      title: "Cryptographic Hashing, Salts & Secure Tokens",
      description: "Protect sensitive user data with one-way SHA-256 hashes, cryptographic salts, and timing-safe comparisons.",
      content: '''Security engineering requires defense against rainbow tables, timing side-channel attacks, and pseudo-random predictability.

### Key Concepts:
- **One-Way Hashes**: Calculating `hashlib.sha256()` produces a deterministic fixed-length digest that cannot be mathematically inverted.
- **Cryptographic Salts**: Random unique salts appended to secrets eliminate dictionary and precomputed rainbow table attacks.
- **Timing-Safe Comparison**: `secrets.compare_digest(a, b)` prevents timing side-channel attacks by comparing strings in constant time.
- **`secrets` vs `random`**: Never use `random` for security tokens or keys; `random` uses the predictable Mersenne Twister algorithm.
''',
      codeExample: '''import hashlib
import secrets

def secure_hash_password(raw_password: str, salt: bytes = None) -> tuple[str, str]:
    if salt is None:
        salt = secrets.token_bytes(16)
    
    # Hash password with unique salt
    hasher = hashlib.sha256()
    hasher.update(salt)
    hasher.update(raw_password.encode("utf-8"))
    
    return hasher.hexdigest(), salt.hex()

def verify_password(raw_password: str, stored_hash: str, salt_hex: str) -> bool:
    salt = bytes.fromhex(salt_hex)
    candidate_hash, _ = secure_hash_password(raw_password, salt)
    # Timing-safe comparison prevents side-channel leaks
    return secrets.compare_digest(candidate_hash, stored_hash)

# Demo run
stored_hash, salt_hex = secure_hash_password("SuperSecretP@ss2026")
print("Salt (hex): ", salt_hex[:16] + "...")
print("Hash (sha): ", stored_hash[:16] + "...")
print("Valid Pass: ", verify_password("SuperSecretP@ss2026", stored_hash, salt_hex))
print("Wrong Pass: ", verify_password("WrongPassword123", stored_hash, salt_hex))
''',
      expectedOutput: '''Salt (hex):  4a1...
Hash (sha):  8b2...
Valid Pass:  True
Wrong Pass:  False''',
      exercisePrompt: "Write `generate_api_key(prefix)` using `secrets.token_urlsafe(32)` returning `{prefix}_{token}`.",
      starterCode: '''import secrets

def generate_api_key(prefix="pk"):
    pass

print(generate_api_key("live"))
''',
      solutionCode: '''import secrets

def generate_api_key(prefix="pk"):
    token = secrets.token_urlsafe(32)
    return f"{prefix}_{token}"

key = generate_api_key("live")
print(key.startswith("live_"))
print(len(key) > 30)
''',
      xp: 95,
      difficulty: LessonDifficulty.hard,
      youtubeVideoId: "yd_kLzI5R7E",
      videoTitle: "Python Cryptography & Security Engineering",
      videoDurationMinutes: 28,
      keyConcepts: [
        "Cryptographic one-way hashing with SHA-256",
        "Unique salt generation against rainbow tables",
        "Timing-safe comparisons via secrets.compare_digest",
      ],
      commonMistakes: [
        "Using random.choice() instead of secrets.token_bytes() for security keys",
        "Storing plain unhashed passwords or unsalted hashes",
      ],
    ),
  ];
}
