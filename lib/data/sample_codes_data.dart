class CodeSample {
  final String title;
  final String category;
  final String description;
  final String code;

  const CodeSample({
    required this.title,
    required this.category,
    required this.description,
    required this.code,
  });
}

class SampleCodesData {
  static const List<CodeSample> samples = [
    CodeSample(
      title: "Interactive Greeting & Math",
      category: "Beginner",
      description: "Demonstrates standard I/O, formatted strings, and arithmetic operations.",
      code: '''# Simple PyPocket Python Starter
name = "PyPocket User"
skills = ["Variables", "Loops", "Classes", "Algorithms"]

print(f"Welcome to PyPocket, {name}!")
print("Master Python right from your device.\\n")

for i, skill in enumerate(skills, start=1):
    print(f"  {i}. {skill} Mastery")

print("\\nHappy coding!")
''',
    ),
    CodeSample(
      title: "QuickSort & Binary Search",
      category: "Algorithms",
      description: "Divide and conquer sorting algorithm and logarithmic time search.",
      code: '''# Complex Algorithm: QuickSort & Binary Search
import random

def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)

def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    steps = 0
    while low <= high:
        steps += 1
        mid = (low + high) // 2
        if arr[mid] == target:
            return mid, steps
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1, steps

# Execution
numbers = [64, 34, 25, 12, 22, 11, 90, 42, 88, 15]
print("Original Array:", numbers)

sorted_arr = quick_sort(numbers)
print("Sorted Array:  ", sorted_arr)

target = 42
idx, steps = binary_search(sorted_arr, target)
print(f"Target {target} found at index {idx} in {steps} steps!")
''',
    ),
    CodeSample(
      title: "OOP Banking System",
      category: "OOP",
      description: "Encapsulation, inheritance, custom exceptions, and transaction history.",
      code: '''# Object Oriented Programming: Banking System
class InsufficientFundsError(Exception):
    pass

class BankAccount:
    def __init__(self, account_holder, initial_balance=0.0):
        self.holder = account_holder
        self.__balance = initial_balance
        self._transactions = []

    def deposit(self, amount):
        if amount <= 0:
            raise ValueError("Deposit must be positive")
        self.__balance += amount
        self._transactions.append(f"Deposited: +\${amount:.2f}")
        return self.__balance

    def withdraw(self, amount):
        if amount > self.__balance:
            raise InsufficientFundsError(f"Cannot withdraw \${amount}. Balance is \${self.__balance}")
        self.__balance -= amount
        self._transactions.append(f"Withdrawn: -\${amount:.2f}")
        return self.__balance

    def get_statement(self):
        print(f"\\n--- Statement for {self.holder} ---")
        for t in self._transactions:
            print(f"  {t}")
        print(f"Current Balance: \${self.__balance:.2f}")

# Subclass with interest
class SavingsAccount(BankAccount):
    def apply_interest(self, rate_percent=5.0):
        interest = (self.withdraw(0) if False else self._BankAccount__balance) * (rate_percent / 100)
        self.deposit(interest)
        print(f"Applied {rate_percent}% interest: +\${interest:.2f}")

# Run demo
acc = SavingsAccount("Alex", 1000.0)
acc.deposit(500.0)
acc.withdraw(200.0)
acc.apply_interest(4.5)
acc.get_statement()
''',
    ),
    CodeSample(
      title: "Matrix Multiplication & Transpose",
      category: "Data Science",
      description: "Pure Python nested matrix transformation and dot product operations.",
      code: '''# 2D Matrix Multiplication from Scratch
def multiply_matrices(A, B):
    rows_A = len(A)
    cols_A = len(A[0])
    rows_B = len(B)
    cols_B = len(B[0])

    if cols_A != rows_B:
        raise ValueError("Cannot multiply: Incompatible dimensions")

    # Output matrix initialized with zeros
    result = [[0 for _ in range(cols_B)] for _ in range(rows_A)]

    for i in range(rows_A):
        for j in range(cols_B):
            for k in range(cols_A):
                result[i][j] += A[i][k] * B[k][j]

    return result

def print_matrix(name, M):
    print(f"{name}:")
    for row in M:
        print("  ", row)

# Define 2x3 and 3x2 matrices
A = [
    [1, 2, 3],
    [4, 5, 6]
]

B = [
    [7, 8],
    [9, 1],
    [2, 3]
]

print_matrix("Matrix A (2x3)", A)
print_matrix("Matrix B (3x2)", B)

C = multiply_matrices(A, B)
print_matrix("Product C = A x B (2x2)", C)
''',
    ),
    CodeSample(
      title: "Decorators & Generators",
      category: "Advanced",
      description: "Higher-order timing decorators, Fibonacci stream generators, and closures.",
      code: '''# Advanced Python: Generators & Decorators
import time

def timing_decorator(func):
    def wrapper(*args, **kwargs):
        start = time.perf_counter()
        result = func(*args, **kwargs)
        duration = time.perf_counter() - start
        print(f"[TIMING] '{func.__name__}' executed in {duration:.6f}s")
        return result
    return wrapper

def fibonacci_stream():
    """Infinite generator for Fibonacci numbers"""
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

@timing_decorator
def calculate_heavy_primes(limit):
    sieve = [True] * limit
    sieve[0] = sieve[1] = False
    for i in range(2, int(limit**0.5) + 1):
        if sieve[i]:
            for j in range(i*i, limit, i):
                sieve[j] = False
    return [i for i, is_p in enumerate(sieve) if is_p]

# Generate first 12 Fibonacci numbers using generator
fib = fibonacci_stream()
first_12_fib = [next(fib) for _ in range(12)]
print("First 12 Fibonacci values:", first_12_fib)

# Calculate primes up to 1,000
primes = calculate_heavy_primes(1000)
print(f"Total primes found below 1000: {len(primes)}")
print("First 10 primes:", primes[:10])
''',
    ),
    CodeSample(
      title: "FastAPI REST Controller Simulation",
      category: "Web & Microservices",
      description: "In-memory REST API controller with route dispatching, query params, and JSON serialization.",
      code: '''import json

class MiniFastAPI:
    def __init__(self):
        self.routes = {}

    def get(self, path):
        def decorator(handler):
            self.routes[("GET", path)] = handler
            return handler
        return decorator

    def post(self, path):
        def decorator(handler):
            self.routes[("POST", path)] = handler
            return handler
        return decorator

    def dispatch(self, method, path, **kwargs):
        handler = self.routes.get((method.upper(), path))
        if not handler:
            return {"status": 404, "error": "Endpoint Not Found"}
        return {"status": 200, "data": handler(**kwargs)}

app = MiniFastAPI()

# In-memory database
database = [
    {"id": 1, "name": "Python 3.12 Architecture", "active": True},
    {"id": 2, "name": "AsyncIO High-Speed Gateway", "active": True},
]

@app.get("/items")
def get_items(active_only=True):
    if active_only:
        return [i for i in database if i["active"]]
    return database

@app.post("/items")
def create_item(name="New Service"):
    item = {"id": len(database) + 1, "name": name, "active": True}
    database.append(item)
    return item

print("[DISPATCH GET /items]:")
print(json.dumps(app.dispatch("GET", "/items", active_only=True), indent=2))

print("\\n[DISPATCH POST /items]:")
print(json.dumps(app.dispatch("POST", "/items", name="Real-Time Telemetry"), indent=2))
''',
    ),
    CodeSample(
      title: "Cryptographic Blockchain & Proof-of-Work",
      category: "Security & Cryptography",
      description: "Mini decentralized blockchain ledger with SHA-256 block hashing and mining difficulty.",
      code: '''import hashlib
import time

class Block:
    def __init__(self, index, timestamp, data, previous_hash=""):
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.nonce = 0
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        payload = f"{self.index}{self.timestamp}{self.data}{self.previous_hash}{self.nonce}"
        return hashlib.sha256(payload.encode("utf-8")).hexdigest()

    def mine_block(self, difficulty):
        target = "0" * difficulty
        while not self.hash.startswith(target):
            self.nonce += 1
            self.hash = self.calculate_hash()
        print(f"[MINED] Block #{self.index} mined with Nonce: {self.nonce} -> {self.hash[:20]}...")

# Initialize chain
genesis = Block(0, time.time(), "Genesis Block", "0" * 64)
chain = [genesis]

def add_block(data, difficulty=3):
    prev = chain[-1]
    new_b = Block(len(chain), time.time(), data, prev.hash)
    new_b.mine_block(difficulty)
    chain.append(new_b)

print("Mining blocks with SHA-256 (Difficulty = 3 leading zeros):")
add_block("Transfer 50 PYP -> Alice")
add_block("Deploy Smart Contract: TokenVault")

print(f"\\nChain Length: {len(chain)} blocks verified!")
''',
    ),
    CodeSample(
      title: "Binary Search Tree (BST) & Traversal",
      category: "Data Structures & Algorithms",
      description: "Binary search tree node insertion, search, and in-order sorted traversal.",
      code: '''class TreeNode:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None

class BinarySearchTree:
    def __init__(self):
        self.root = None

    def insert(self, val):
        if not self.root:
            self.root = TreeNode(val)
        else:
            self._insert_recursive(self.root, val)

    def _insert_recursive(self, node, val):
        if val < node.val:
            if node.left is None:
                node.left = TreeNode(val)
            else:
                self._insert_recursive(node.left, val)
        elif val > node.val:
            if node.right is None:
                node.right = TreeNode(val)
            else:
                self._insert_recursive(node.right, val)

    def in_order_traversal(self):
        res = []
        def dfs(node):
            if not node:
                return
            dfs(node.left)
            res.append(node.val)
            dfs(node.right)
        dfs(self.root)
        return res

bst = BinarySearchTree()
for num in [50, 30, 70, 20, 40, 60, 80]:
    bst.insert(num)

sorted_elements = bst.in_order_traversal()
print("BST In-Order Traversal (Always Sorted):", sorted_elements)
''',
    ),
  ];
}
