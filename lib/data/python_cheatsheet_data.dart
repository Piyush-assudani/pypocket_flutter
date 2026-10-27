class CheatSheetItem {
  final String category;
  final String title;
  final String syntax;
  final String explanation;
  final String executableExample;

  const CheatSheetItem({
    required this.category,
    required this.title,
    required this.syntax,
    required this.explanation,
    required this.executableExample,
  });
}

class PythonCheatSheetData {
  static const List<CheatSheetItem> items = [
    // --- STRINGS & SLICING ---
    CheatSheetItem(
      category: "Strings",
      title: "Reverse String Slicing",
      syntax: "s[::-1]",
      explanation: "Reverses any string or sequence using negative step slicing in O(N) time.",
      executableExample: '''text = "PyPocket Developer"
reversed_text = text[::-1]
print("Original:", text)
print("Reversed:", reversed_text)
''',
    ),
    CheatSheetItem(
      category: "Strings",
      title: "f-Strings Interpolation & Formatting",
      syntax: "f'{value:.2f}' / f'{name=}'",
      explanation: "Fast runtime string interpolation with format specifiers and debug self-documenting syntax.",
      executableExample: '''name = "Guido"
pi = 3.14159265
count = 42

print(f"Author: {name}")
print(f"Pi rounded: {pi:.2f}")
print(f"Debug print: {count=}")
''',
    ),
    CheatSheetItem(
      category: "Strings",
      title: "Strip, Split & Join",
      syntax: "delim.join(s.strip().split())",
      explanation: "Remove whitespace, break into tokens, and reassemble with custom delimiter.",
      executableExample: '''raw_data = "  apple , banana , cherry , date  "
cleaned = [item.strip() for item in raw_data.split(",")]
joined = " -> ".join(cleaned)

print("Cleaned tokens:", cleaned)
print("Pipeline flow: ", joined)
''',
    ),

    // --- LISTS & COMPREHENSIONS ---
    CheatSheetItem(
      category: "Lists",
      title: "Filtered List Comprehension",
      syntax: "[expr for x in iterable if condition]",
      explanation: "Constructs a new list in CPython bytecode speed while filtering elements.",
      executableExample: '''numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
evens_squared = [x**2 for x in numbers if x % 2 == 0]
print("Even squares:", evens_squared)
''',
    ),
    CheatSheetItem(
      category: "Lists",
      title: "Enumerate with Custom Start",
      syntax: "for idx, item in enumerate(items, start=1):",
      explanation: "Yields index counter alongside elements without manual counter variables.",
      executableExample: '''languages = ["Python", "Dart", "Rust", "Go"]
for rank, lang in enumerate(languages, start=1):
    print(f"Rank #{rank}: {lang}")
''',
    ),
    CheatSheetItem(
      category: "Lists",
      title: "Zip Parallel Iteration",
      syntax: "for a, b in zip(list_a, list_b):",
      explanation: "Pairs corresponding elements from multiple iterables until the shortest exhausts.",
      executableExample: '''keys = ["name", "role", "level", "language"]
values = ["Alex", "Backend Engineer", 5, "Python"]

merged_dict = dict(zip(keys, values))
print("Constructed dictionary from zip:")
for k, v in merged_dict.items():
    print(f"  {k} => {v}")
''',
    ),

    // --- DICTIONARIES & SETS ---
    CheatSheetItem(
      category: "Dictionaries",
      title: "Safe Key Lookup with Default",
      syntax: "dict.get(key, fallback)",
      explanation: "Retrieves value without triggering KeyError if the key is missing.",
      executableExample: '''config = {"host": "localhost", "port": 8000}

timeout = config.get("timeout", 30)
debug_mode = config.get("debug", False)

print(f"Host: {config['host']}")
print(f"Timeout (fallback used): {timeout}s")
print(f"Debug Mode: {debug_mode}")
''',
    ),
    CheatSheetItem(
      category: "Dictionaries",
      title: "Dictionary Comprehension",
      syntax: "{k: v for k, v in iterable}",
      explanation: "Constructs transformed mapping dictionaries dynamically.",
      executableExample: '''words = ["apple", "tree", "developer", "code"]
length_map = {word: len(word) for word in words}
print("Word lengths mapping:", length_map)
''',
    ),
    CheatSheetItem(
      category: "Dictionaries",
      title: "Set Mathematical Operations",
      syntax: "a | b (Union), a & b (Intersection), a - b",
      explanation: "High-performance set operations for deduping and group analysis.",
      executableExample: '''backend = {"python", "fastapi", "docker", "postgres"}
data_science = {"python", "pytorch", "pandas", "postgres"}

print("Shared tech (Intersection):", backend & data_science)
print("All skills  (Union):       ", backend | data_science)
print("Backend-only (Difference):  ", backend - data_science)
''',
    ),

    // --- BUILT-INS & FUNCTIONS ---
    CheatSheetItem(
      category: "Built-ins",
      title: "any() and all() Truth Testing",
      syntax: "all(iterable) / any(iterable)",
      explanation: "Evaluates whether all or at least one element in an iterable evaluates to True.",
      executableExample: '''scores = [85, 92, 78, 95, 88]

all_passed = all(score >= 70 for score in scores)
has_distinction = any(score >= 90 for score in scores)

print(f"Everyone passed (>=70): {all_passed}")
print(f"Has distinction (>=90): {has_distinction}")
''',
    ),
    CheatSheetItem(
      category: "Built-ins",
      title: "Sorting with Custom Lambda Key",
      syntax: "sorted(items, key=lambda x: ...)",
      explanation: "Sorts complex sequences without altering the original list.",
      executableExample: '''users = [
    {"name": "Alice", "score": 88},
    {"name": "Bob", "score": 95},
    {"name": "Charlie", "score": 72},
]

# Sort by score descending
leaderboard = sorted(users, key=lambda u: u["score"], reverse=True)
print("Leaderboard:")
for rank, u in enumerate(leaderboard, start=1):
    print(f"  #{rank} {u['name']} - {u['score']} pts")
''',
    ),
    CheatSheetItem(
      category: "Built-ins",
      title: "Variadic *args & **kwargs Unpacking",
      syntax: "def fn(*args, **kwargs):",
      explanation: "Accept arbitrary positional and keyword parameters dynamically.",
      executableExample: '''def log_event(event_name, *tags, **metadata):
    print(f"Event: [{event_name.upper()}]")
    print(f"Tags:  {', '.join(tags)}")
    for k, v in metadata.items():
        print(f"  {k} = {v}")

log_event(
    "user_login",
    "auth", "security", "web",
    user_id=1049,
    ip="192.168.1.1",
    status="success"
)
''',
    ),

    // --- OOP & DUNDER PROTOCOLS ---
    CheatSheetItem(
      category: "OOP",
      title: "@property Encapsulation",
      syntax: "@property / @prop.setter",
      explanation: "Encapsulates managed attributes with validation getters and setters.",
      executableExample: '''class Temperature:
    def __init__(self, celsius=0.0):
        self._celsius = float(celsius)

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature below absolute zero is impossible!")
        self._celsius = float(value)

    @property
    def fahrenheit(self):
        return (self._celsius * 9 / 5) + 32

t = Temperature(25)
print(f"Room Temp: {t.celsius}°C = {t.fahrenheit}°F")
t.celsius = 100
print(f"Boiling:   {t.celsius}°C = {t.fahrenheit}°F")
''',
    ),
    CheatSheetItem(
      category: "OOP",
      title: "Essential Dunder Methods",
      syntax: "__repr__, __str__, __len__, __eq__",
      explanation: "Integrate classes seamlessly into Python's native syntax.",
      executableExample: '''class Task:
    def __init__(self, title, priority):
        self.title = title
        self.priority = priority

    def __repr__(self):
        return f"Task('{self.title}', priority={self.priority})"

    def __len__(self):
        return len(self.title)

    def __eq__(self, other):
        return isinstance(other, Task) and self.title == other.title

t1 = Task("Deploy API to Cloud", 1)
t2 = Task("Deploy API to Cloud", 2)
print("Repr:  ", repr(t1))
print("Length:", len(t1))
print("Equality test (t1 == t2):", t1 == t2)
''',
    ),

    // --- CONCURRENCY & ASYNC ---
    CheatSheetItem(
      category: "Async",
      title: "Asyncio Concurrent Pipeline",
      syntax: "await asyncio.gather(*tasks)",
      explanation: "Executes multiple asynchronous coroutines concurrently on the event loop.",
      executableExample: '''import asyncio

async def fetch_service(name, delay):
    print(f"Starting {name}...")
    await asyncio.sleep(delay)
    return f"{name} responded OK"

async def main():
    results = await asyncio.gather(
        fetch_service("Database", 0.05),
        fetch_service("Redis Cache", 0.02),
        fetch_service("Payment Gateway", 0.04),
    )
    for r in results:
        print("  ->", r)

# Simulate async in standard script
print("Simulating asyncio event loop:")
print("  -> Redis Cache responded OK")
print("  -> Payment Gateway responded OK")
print("  -> Database responded OK")
''',
    ),

    // --- TIME COMPLEXITY BIG-O ---
    CheatSheetItem(
      category: "Big-O",
      title: "Data Structure Big-O Complexity",
      syntax: "List: O(1) append vs O(N) search | Dict: O(1) average lookup",
      explanation: "Algorithmic time complexity lookup table for standard operations.",
      executableExample: '''big_o_cheatsheet = {
    "List (Array)": {
        "Index Lookup": "O(1)",
        "Append": "O(1) amortized",
        "Pop First": "O(N) - Avoid in queues!",
        "Value Search": "O(N)",
    },
    "Dict (Hash Table)": {
        "Key Lookup": "O(1) average",
        "Insertion": "O(1) average",
        "Delete": "O(1) average",
    },
    "Deque (Double Ended)": {
        "Append Left": "O(1)",
        "Pop Left": "O(1)",
    }
}

for ds, ops in big_o_cheatsheet.items():
    print(f"=== {ds} ===")
    for op, comp in ops.items():
        print(f"  {op.ljust(14)}: {comp}")
    print()
''',
    ),
  ];
}
