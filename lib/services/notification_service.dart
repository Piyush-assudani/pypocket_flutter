import 'dart:math';
import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';
import 'system_notification_interface.dart';

class PythonNotificationItem {
  final int id;
  final String title;
  final String body;
  final String category;
  final IconData icon;

  const PythonNotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.icon,
  });
}

class PythonNotificationService {
  // Comprehensive Bank of 100 Real-Value, Witty, and Motivating Python Notifications
  static const List<PythonNotificationItem> notificationBank = [
    // --- 1. MORNING & HABIT STARTERS (1-15) ---
    PythonNotificationItem(
      id: 1,
      title: 'Morning Python Routine',
      body: 'No curly braces required before breakfast. Solve one 3-minute lesson to jumpstart your daily momentum.',
      category: 'Morning Habit',
      icon: Icons.wb_sunny_outlined,
    ),
    PythonNotificationItem(
      id: 2,
      title: 'The Zen of Python Rule #1',
      body: '"Beautiful is better than ugly." Spend 5 minutes refactoring one script today.',
      category: 'Zen of Python',
      icon: Icons.format_quote_rounded,
    ),
    PythonNotificationItem(
      id: 3,
      title: 'Coffee and CPython',
      body: 'Did you know CPython allocates small integers (-5 to 256) at startup? Your morning code is already pre-allocated.',
      category: 'Memory Internals',
      icon: Icons.coffee_outlined,
    ),
    PythonNotificationItem(
      id: 4,
      title: 'First Code of the Day',
      body: 'One line of code in the PyPocket sandbox is better than 10 hours of passive tutorial watching.',
      category: 'Action',
      icon: Icons.play_arrow_rounded,
    ),
    PythonNotificationItem(
      id: 5,
      title: 'Daily Streak Awaiting',
      body: 'Your consistency counter is active. Complete today\'s micro-exercise to lock in day progress.',
      category: 'Streak',
      icon: Icons.local_fire_department_outlined,
    ),
    PythonNotificationItem(
      id: 6,
      title: 'Explicit Is Better Than Implicit',
      body: 'Write clean variable names today. Future you reading your code at 2 AM will be deeply grateful.',
      category: 'Best Practices',
      icon: Icons.spellcheck_rounded,
    ),
    PythonNotificationItem(
      id: 7,
      title: 'Quick Spaced Repetition',
      body: 'Flip 3 flashcards during your commute. Repetition cements Python syntax into long-term memory.',
      category: 'Flashcards',
      icon: Icons.style_outlined,
    ),
    PythonNotificationItem(
      id: 8,
      title: 'Variable Naming Challenge',
      body: 'PEP 8 recommends snake_case for functions and PascalCase for classes. Check your habits today.',
      category: 'PEP 8 Standards',
      icon: Icons.rule_folder_outlined,
    ),
    PythonNotificationItem(
      id: 9,
      title: 'List vs Tuple Memory',
      body: 'Tuples have a smaller memory footprint because they are immutable. Save RAM on high-volume data.',
      category: 'Optimization',
      icon: Icons.data_array_rounded,
    ),
    PythonNotificationItem(
      id: 10,
      title: 'Start Small, Build Big',
      body: 'Even Guido van Rossum started Python as a holiday hobby project in 1989. Write your next block.',
      category: 'Inspiration',
      icon: Icons.lightbulb_outline,
    ),
    PythonNotificationItem(
      id: 11,
      title: 'Morning Focus Sprint',
      body: 'Open PyPocket IDE and type out one list comprehension. Feel the power of expressive syntax.',
      category: 'Sprint',
      icon: Icons.speed_rounded,
    ),
    PythonNotificationItem(
      id: 12,
      title: 'Mutable Default Arguments',
      body: 'Never use `def add(item, lst=[])`. The default list persists across function calls. Use `None` instead.',
      category: 'Pitfall Alert',
      icon: Icons.warning_amber_rounded,
    ),
    PythonNotificationItem(
      id: 13,
      title: 'Dictionary Lookup Speed',
      body: 'Python dict lookups are O(1) average time due to hash tables. Master them in Lesson 6.',
      category: 'Big-O Data',
      icon: Icons.bolt_outlined,
    ),
    PythonNotificationItem(
      id: 14,
      title: 'Daily 15-Minute Block',
      body: 'Consistency compounds. 15 minutes a day for a year equals over 90 hours of active programming.',
      category: 'Velocity',
      icon: Icons.trending_up_rounded,
    ),
    PythonNotificationItem(
      id: 15,
      title: 'Check Your Imports',
      body: 'Are you importing whole packages when you only need one class? Optimize your runtime footprint.',
      category: 'Architecture',
      icon: Icons.account_tree_outlined,
    ),

    // --- 2. SYNTAX, QUIRKS & HUMOR (16-35) ---
    PythonNotificationItem(
      id: 16,
      title: 'Colon Missing Detected',
      body: 'If you ever feel ignored, remember the colon at the end of an if statement. Don\'t leave it behind.',
      category: 'Syntax Humor',
      icon: Icons.code_rounded,
    ),
    PythonNotificationItem(
      id: 17,
      title: 'Indentation is Law',
      body: 'Tabs or 4 spaces? PEP 8 strictly decrees 4 spaces. Keep your indentation pristine.',
      category: 'PEP 8',
      icon: Icons.format_indent_increase_rounded,
    ),
    PythonNotificationItem(
      id: 18,
      title: 'The Walrus Operator',
      body: 'Assign and evaluate in one breath: `if (n := len(data)) > 10:`. Modern Python 3.8+ magic.',
      category: 'Modern Python',
      icon: Icons.auto_awesome_outlined,
    ),
    PythonNotificationItem(
      id: 19,
      title: 'Generator Memory Efficiency',
      body: 'Need to process 1,000,000 rows? Use a generator `(x for x in data)` to consume 0 buffer memory.',
      category: 'Performance',
      icon: Icons.memory_rounded,
    ),
    PythonNotificationItem(
      id: 20,
      title: 'Breakup vs SyntaxError',
      body: 'Breakups hurt, but running 200 lines of code only to get an IndentationError on line 199 hits different.',
      category: 'Developer Humor',
      icon: Icons.terminal_rounded,
    ),
    PythonNotificationItem(
      id: 21,
      title: 'Slicing Step Trick',
      body: 'Reverse any string or list in 5 characters: `s[::-1]`. Fast, expressive, and idiomatic.',
      category: 'Pro Tip',
      icon: Icons.swap_horiz_rounded,
    ),
    PythonNotificationItem(
      id: 22,
      title: 'F-Strings Debugger',
      body: 'Did you know `f"{x=}"` prints both the variable name and its value? Clean debugging without extra prints.',
      category: 'Python 3.8+',
      icon: Icons.bug_report_outlined,
    ),
    PythonNotificationItem(
      id: 23,
      title: 'The Truth About is vs ==',
      body: '`==` compares values, while `is` compares memory IDs (`id(a) == id(b)`). Master identity comparison.',
      category: 'Core Concepts',
      icon: Icons.compare_arrows_rounded,
    ),
    PythonNotificationItem(
      id: 24,
      title: 'Dunder Method Spotlight',
      body: 'Want your class to work with `len()`? Just implement `__len__(self)`. Python\'s data model is pure elegance.',
      category: 'OOP & Dunders',
      icon: Icons.functions_rounded,
    ),
    PythonNotificationItem(
      id: 25,
      title: 'Unpacking Power',
      body: 'Swap two variables with zero temporary space: `a, b = b, a`. Elegance at its finest.',
      category: 'Idiomatic Python',
      icon: Icons.transform_rounded,
    ),
    PythonNotificationItem(
      id: 26,
      title: 'Lambda Functions',
      body: 'Keep lambdas one line and simple. If it needs logic, write a proper `def` with docstrings.',
      category: 'Functional Python',
      icon: Icons.all_inclusive_rounded,
    ),
    PythonNotificationItem(
      id: 27,
      title: 'Context Managers with `with`',
      body: 'Always use `with open(...) as f:` to guarantee files close properly even if an exception strikes.',
      category: 'Resource Management',
      icon: Icons.lock_outline_rounded,
    ),
    PythonNotificationItem(
      id: 28,
      title: 'Any and All Functions',
      body: 'Replace nested loops with `any()` and `all()` on iterables for clean, readable condition checks.',
      category: 'Built-in Magic',
      icon: Icons.check_box_outlined,
    ),
    PythonNotificationItem(
      id: 29,
      title: 'Zip Function Synergy',
      body: 'Iterate over two parallel lists simultaneously using `for user, score in zip(users, scores):`.',
      category: 'Built-ins',
      icon: Icons.merge_type_rounded,
    ),
    PythonNotificationItem(
      id: 30,
      title: 'Enumerate Over Range(len)',
      body: 'Never write `for i in range(len(items)):`. Always prefer `for i, item in enumerate(items):`.',
      category: 'Clean Code',
      icon: Icons.list_alt_rounded,
    ),
    PythonNotificationItem(
      id: 31,
      title: 'The Mystery of None',
      body: '`None` in Python is a singleton of type `NoneType`. Always test it with `x is None`, never `x == None`.',
      category: 'Best Practices',
      icon: Icons.fingerprint_rounded,
    ),
    PythonNotificationItem(
      id: 32,
      title: 'List Comprehension Guard',
      body: '`[x for x in nums if x > 0]` is twice as fast as manual `for` loops in bytecode execution.',
      category: 'Bytecode Speed',
      icon: Icons.flash_on_outlined,
    ),
    PythonNotificationItem(
      id: 33,
      title: 'Set Intersection Power',
      body: 'Finding shared items between two massive lists? Convert to `set` and use `set_a & set_b` in O(min(len)).',
      category: 'Algorithms',
      icon: Icons.filter_alt_outlined,
    ),
    PythonNotificationItem(
      id: 34,
      title: 'Custom Exceptions',
      body: 'Inherit from `Exception`, not `BaseException`, when building your own custom domain error classes.',
      category: 'Error Handling',
      icon: Icons.error_outline_rounded,
    ),
    PythonNotificationItem(
      id: 35,
      title: 'Chained Comparisons',
      body: 'Python allows mathematical chaining: `if 0 < x < 100:`. Say goodbye to verbose `and` conditions.',
      category: 'Clean Syntax',
      icon: Icons.linear_scale_rounded,
    ),

    // --- 3. MIDDAY & ALGORITHMIC WORKOUTS (36-60) ---
    PythonNotificationItem(
      id: 36,
      title: 'Mid-Day Lunch Code Break',
      body: 'Feed your brain while you lunch. 5 minutes in PyPocket keeps cognitive coding muscles sharp.',
      category: 'Midday Sprint',
      icon: Icons.restaurant_outlined,
    ),
    PythonNotificationItem(
      id: 37,
      title: 'Binary Search Mastery',
      body: 'Searching a sorted million-item list takes only 20 comparisons with Binary Search (O(log n)).',
      category: 'Algorithms',
      icon: Icons.search_rounded,
    ),
    PythonNotificationItem(
      id: 38,
      title: 'Recursion Depth Limits',
      body: 'CPython defaults to a recursion limit of 1,000 to protect the C call stack. Check `sys.getrecursionlimit()`.',
      category: 'Internals',
      icon: Icons.layers_outlined,
    ),
    PythonNotificationItem(
      id: 39,
      title: 'Understanding GIL',
      body: 'The Global Interpreter Lock allows only one thread to execute Python bytecode at a time. Use multiprocessing for CPU bounds.',
      category: 'Concurrency',
      icon: Icons.lock_clock_outlined,
    ),
    PythonNotificationItem(
      id: 40,
      title: 'Asyncio Event Loops',
      body: 'Asyncio is single-threaded cooperative multitasking. Perfect for thousands of concurrent network sockets.',
      category: 'Asyncio',
      icon: Icons.sync_alt_rounded,
    ),
    PythonNotificationItem(
      id: 41,
      title: 'Decorator Magic',
      body: 'Decorators wrap functions without modifying their source code. Ideal for timing, logging, and auth checks.',
      category: 'Advanced OOP',
      icon: Icons.auto_awesome_mosaic_rounded,
    ),
    PythonNotificationItem(
      id: 42,
      title: '__slots__ for Massive Scale',
      body: 'Adding `__slots__ = ("x", "y")` to a class eliminates the dynamic `__dict__`, saving up to 50% memory per object.',
      category: 'Scale Architecture',
      icon: Icons.storage_rounded,
    ),
    PythonNotificationItem(
      id: 43,
      title: 'Type Hints in Python 3.12',
      body: 'Type hints don\'t slow runtime execution but catch 80% of edge case bugs before code hits production.',
      category: 'Type Safety',
      icon: Icons.verified_user_outlined,
    ),
    PythonNotificationItem(
      id: 44,
      title: 'Collections Counter',
      body: 'Need frequency counts of items? `from collections import Counter` counts any iterable in one single line.',
      category: 'Collections',
      icon: Icons.pie_chart_outline_rounded,
    ),
    PythonNotificationItem(
      id: 45,
      title: 'Defaultdict Simplicity',
      body: 'Eliminate `KeyError` forever: `defaultdict(list)` automatically creates empty buckets on first access.',
      category: 'Data Structures',
      icon: Icons.folder_special_outlined,
    ),
    PythonNotificationItem(
      id: 46,
      title: 'Bisect Module Efficiency',
      body: '`import bisect` maintains a sorted list without having to re-sort after every insertion.',
      category: 'Standard Library',
      icon: Icons.sort_rounded,
    ),
    PythonNotificationItem(
      id: 47,
      title: 'Heapq for Priority Queues',
      body: 'Min-heaps in Python are built-in with `heapq.heappush` and `heapq.heappop`. O(log n) priority access.',
      category: 'Algorithms',
      icon: Icons.bar_chart_rounded,
    ),
    PythonNotificationItem(
      id: 48,
      title: 'Pathlib over os.path',
      body: 'Modern Python uses `from pathlib import Path`. Object-oriented file system paths with `/` operator.',
      category: 'Modern Standard',
      icon: Icons.folder_open_rounded,
    ),
    PythonNotificationItem(
      id: 49,
      title: 'Memoization with lru_cache',
      body: 'Decorate any recursive function with `@functools.lru_cache(maxsize=128)` for instant dynamic programming speedups.',
      category: 'Optimization',
      icon: Icons.cached_rounded,
    ),
    PythonNotificationItem(
      id: 50,
      title: 'Dataclasses vs Pydantic',
      body: 'Dataclasses auto-generate `__init__`, `__repr__`, and `__eq__` without boilerplate. Try Lesson 15.',
      category: 'Data Modeling',
      icon: Icons.view_in_ar_rounded,
    ),
    PythonNotificationItem(
      id: 51,
      title: 'Interview Trivia: What is MRO?',
      body: 'Method Resolution Order determines inheritance hierarchy search using the C3 linearization algorithm.',
      category: 'Interview Prep',
      icon: Icons.account_tree_rounded,
    ),
    PythonNotificationItem(
      id: 52,
      title: 'Namedtuples for Readability',
      body: 'Access tuple fields by name instead of positional indices: `Point = namedtuple("Point", ["x", "y"])`.',
      category: 'Clean Data',
      icon: Icons.label_outline_rounded,
    ),
    PythonNotificationItem(
      id: 53,
      title: 'Shallow Copy vs Deep Copy',
      body: '`copy.copy()` duplicates the outer object, but nested objects remain referenced. Use `copy.deepcopy()` to clone all.',
      category: 'Memory Pitfall',
      icon: Icons.copy_rounded,
    ),
    PythonNotificationItem(
      id: 54,
      title: 'Avoid Global State',
      body: 'The `global` keyword makes testing difficult and causes race conditions. Pass variables explicitly.',
      category: 'Clean Architecture',
      icon: Icons.public_off_rounded,
    ),
    PythonNotificationItem(
      id: 55,
      title: 'Time Complexity of in Operator',
      body: '`x in my_list` takes O(n) time. `x in my_set` takes O(1) time. Choose the right data structure.',
      category: 'Big-O Analysis',
      icon: Icons.timelapse_rounded,
    ),
    PythonNotificationItem(
      id: 56,
      title: 'String Immutability',
      body: 'Strings cannot be modified in place. Repeated string concatenation in loops creates excessive objects; use `"".join()`.',
      category: 'String Performance',
      icon: Icons.text_fields_rounded,
    ),
    PythonNotificationItem(
      id: 57,
      title: 'Itertools Power Tools',
      body: '`itertools.product()`, `permutations()`, and `combinations()` eliminate complex nested combinatorial loops.',
      category: 'Itertools',
      icon: Icons.hub_outlined,
    ),
    PythonNotificationItem(
      id: 58,
      title: 'Regex Compilation',
      body: 'Always pre-compile regexes used inside loops: `pattern = re.compile(r"...")` to avoid redundant compilation.',
      category: 'Regex Optimization',
      icon: Icons.find_in_page_outlined,
    ),
    PythonNotificationItem(
      id: 59,
      title: 'The inspect Module',
      body: 'Want to inspect function arguments at runtime? `import inspect` reveals signature details for metaprogramming.',
      category: 'Reflection',
      icon: Icons.visibility_outlined,
    ),
    PythonNotificationItem(
      id: 60,
      title: 'Garbage Collection Cycles',
      body: 'Python uses reference counting for instant cleanup, plus a cyclic garbage collector for circular references.',
      category: 'Garbage Collector',
      icon: Icons.delete_sweep_outlined,
    ),

    // --- 4. EVENING STREAKS & HABIT REMINDERS (61-80) ---
    PythonNotificationItem(
      id: 61,
      title: 'Evening Streak Protector',
      body: 'Don\'t let today\'s streak slip away. Complete 1 flashcard or lesson quiz before dinner.',
      category: 'Streak Saver',
      icon: Icons.shield_outlined,
    ),
    PythonNotificationItem(
      id: 62,
      title: '5-Minute Code Review',
      body: 'Open PyPocket IDE and run a quick script. Muscle memory requires regular daily reinforcement.',
      category: 'Review',
      icon: Icons.rate_review_outlined,
    ),
    PythonNotificationItem(
      id: 63,
      title: '1 Quiz Away From +50 XP',
      body: 'Your level progress is climbing. Pass one algorithmic quiz to level up your developer rank.',
      category: 'XP Boost',
      icon: Icons.military_tech_outlined,
    ),
    PythonNotificationItem(
      id: 64,
      title: 'Certificate Progress Check',
      body: 'You are on track for verified certification. Complete remaining lesson modules to claim your diploma.',
      category: 'Certification',
      icon: Icons.workspace_premium_outlined,
    ),
    PythonNotificationItem(
      id: 65,
      title: 'Bug Hunting Hour',
      body: 'The best way to learn debugging is by breaking things intentionally. Experiment freely in PyPocket sandbox.',
      category: 'Sandbox Experiment',
      icon: Icons.construction_rounded,
    ),
    PythonNotificationItem(
      id: 66,
      title: 'Spaced Repetition Active',
      body: '3 flashcards are scheduled for review based on the Ebbinghaus forgetting curve. Keep them mastered.',
      category: 'Flashcards',
      icon: Icons.psychology_outlined,
    ),
    PythonNotificationItem(
      id: 67,
      title: 'Reading Digital Booklets',
      body: 'Check out the new Python Memory Model handbook in the Booklets section. Complete runnable notes.',
      category: 'Handbooks',
      icon: Icons.menu_book_rounded,
    ),
    PythonNotificationItem(
      id: 68,
      title: 'Consistency Beats Cramming',
      body: '15 minutes today beats 4 hours on Sunday. Lock in your session and relax guilt-free.',
      category: 'Philosophy',
      icon: Icons.done_all_rounded,
    ),
    PythonNotificationItem(
      id: 69,
      title: 'Python Career Milestone',
      body: 'Full-stack and AI engineers write Python daily. Every completed lesson moves you closer to job readiness.',
      category: 'Career Growth',
      icon: Icons.work_outline_rounded,
    ),
    PythonNotificationItem(
      id: 70,
      title: 'Daily Goal Progress',
      body: 'You set a daily commitment during onboarding. Open PyPocket to honor your personal pact.',
      category: 'Commitment',
      icon: Icons.flag_outlined,
    ),
    PythonNotificationItem(
      id: 71,
      title: 'Unwind with Python Logic',
      body: 'Coding is logic meditation. Solve one algorithmic challenge to decompress from your workday.',
      category: 'Focus',
      icon: Icons.self_improvement_rounded,
    ),
    PythonNotificationItem(
      id: 72,
      title: 'Did You Know: Python 3.12 Speed',
      body: 'Python 3.12 introduces specialized bytecode opcodes, boosting runtime performance up to 5% without code changes.',
      category: 'Python 3.12',
      icon: Icons.speed_outlined,
    ),
    PythonNotificationItem(
      id: 73,
      title: 'Mastering Try-Except-Else',
      body: 'Did you know `try-except` has an `else` block? Code in `else` runs only if no exception was raised.',
      category: 'Clean Code',
      icon: Icons.check_circle_outline,
    ),
    PythonNotificationItem(
      id: 74,
      title: 'The Finally Block Guarantee',
      body: 'Code in a `finally` block always executes, even if you return early inside the try block.',
      category: 'Error Handling',
      icon: Icons.lock_clock_rounded,
    ),
    PythonNotificationItem(
      id: 75,
      title: 'Bonus Quests Available',
      body: 'Check the Rewards Hub in your Profile. Over +820 XP in claimable bonus missions waiting for you.',
      category: 'Rewards Hub',
      icon: Icons.card_giftcard_rounded,
    ),
    PythonNotificationItem(
      id: 76,
      title: 'Understanding __repr__ vs __str__',
      body: '`__repr__` is for developers (unambiguous, code-like). `__str__` is for end users (readable). Master both.',
      category: 'OOP Principles',
      icon: Icons.text_snippet_outlined,
    ),
    PythonNotificationItem(
      id: 77,
      title: 'Avoid Wildcard Imports',
      body: '`from module import *` pollutes namespace and breaks IDE autocompletion. Import explicitly.',
      category: 'Architecture',
      icon: Icons.remove_circle_outline_rounded,
    ),
    PythonNotificationItem(
      id: 78,
      title: 'Evening Code Snippet',
      body: 'Have a cool algorithm idea? Save it to your Personal Snippets notebook inside PyPocket IDE.',
      category: 'Notebook',
      icon: Icons.bookmark_border_rounded,
    ),
    PythonNotificationItem(
      id: 79,
      title: 'Clean Code Principle: DRY',
      body: '"Don\'t Repeat Yourself." If you copy-paste code three times, it\'s time to abstract it into a function.',
      category: 'Clean Code',
      icon: Icons.replay_rounded,
    ),
    PythonNotificationItem(
      id: 80,
      title: 'Keep That Streak Glowing',
      body: 'One quick tap on PyPocket keeps your daily fire alive. Never break the chain.',
      category: 'Streak Protector',
      icon: Icons.whatshot_rounded,
    ),

    // --- 5. NIGHT CODERS, ADVANCED & DEEP DIVE (81-100) ---
    PythonNotificationItem(
      id: 81,
      title: 'Late Night Bytecode Session',
      body: 'While the world sleeps, the bytecode executes. Run `import dis; dis.dis(my_func)` to inspect raw assembly.',
      category: 'Bytecode',
      icon: Icons.nightlight_outlined,
    ),
    PythonNotificationItem(
      id: 82,
      title: 'The Infinite Loop Sentinel',
      body: 'Always verify loop termination invariants before running `while True:`. Your CPU fan thanks you.',
      category: 'Safety',
      icon: Icons.loop_rounded,
    ),
    PythonNotificationItem(
      id: 83,
      title: 'Metaclasses in Python',
      body: 'Metaclasses are classes that create classes. "If you wonder if you need them, you don\'t." - Tim Peters.',
      category: 'Deep Python',
      icon: Icons.hub_rounded,
    ),
    PythonNotificationItem(
      id: 84,
      title: 'Asyncio Await Discipline',
      body: 'Never run blocking I/O (like `time.sleep`) inside an async coroutine. Always use `await asyncio.sleep()`.',
      category: 'Asyncio',
      icon: Icons.timer_outlined,
    ),
    PythonNotificationItem(
      id: 85,
      title: 'Descriptors in Action',
      body: 'Properties, classmethods, and staticmethods are all built on Python\'s descriptor protocol (`__get__`, `__set__`).',
      category: 'Protocols',
      icon: Icons.tune_rounded,
    ),
    PythonNotificationItem(
      id: 86,
      title: 'Contextlib Utilities',
      body: '`from contextlib import contextmanager` turns any generator into a context manager with `@contextmanager`.',
      category: 'Standard Library',
      icon: Icons.extension_outlined,
    ),
    PythonNotificationItem(
      id: 87,
      title: 'FastAPI Dependency Injection',
      body: 'Building REST APIs? Modern Python uses FastAPI with typing for automatic schema generation and validation.',
      category: 'Web APIs',
      icon: Icons.api_rounded,
    ),
    PythonNotificationItem(
      id: 88,
      title: 'NumPy Vectorization',
      body: 'Looping through array math in pure Python is slow. NumPy vectorization executes in compiled C loops 50x faster.',
      category: 'Data Science',
      icon: Icons.calculate_outlined,
    ),
    PythonNotificationItem(
      id: 89,
      title: 'Pandas Vectorized Filtering',
      body: 'Filter DataFrames with boolean masks: `df[df["score"] > 90]` instead of iterrows for instant indexing.',
      category: 'Big Data',
      icon: Icons.table_chart_outlined,
    ),
    PythonNotificationItem(
      id: 90,
      title: 'PyTorch Tensor Device Placement',
      body: 'Remember to match tensor devices: `tensor.to(device)` before passing inputs to your neural network model.',
      category: 'AI & ML',
      icon: Icons.psychology_rounded,
    ),
    PythonNotificationItem(
      id: 91,
      title: 'Dockerizing Python Apps',
      body: 'Always use multi-stage Docker builds with a lightweight base like `python:3.12-slim` to shrink container image size.',
      category: 'DevOps',
      icon: Icons.cloud_outlined,
    ),
    PythonNotificationItem(
      id: 92,
      title: 'Virtual Environment Discipline',
      body: 'Never install project packages into global system Python. Always create a clean `venv` or `poetry` environment.',
      category: 'Environment',
      icon: Icons.folder_zip_outlined,
    ),
    PythonNotificationItem(
      id: 93,
      title: 'Security: SQL Injection Defense',
      body: 'Never format strings into SQL queries (`f"SELECT ... {id}"`). Always use parameterized query placeholders.',
      category: 'Security',
      icon: Icons.security_rounded,
    ),
    PythonNotificationItem(
      id: 94,
      title: 'Secrets Management',
      body: 'Never hardcode API keys or database passwords in source code. Use environment variables and `.env` files.',
      category: 'App Security',
      icon: Icons.vpn_key_outlined,
    ),
    PythonNotificationItem(
      id: 95,
      title: 'The Magic of functools.partial',
      body: 'Freeze some portions of a function\'s arguments to create a new callable with `functools.partial`.',
      category: 'Functional',
      icon: Icons.call_split_rounded,
    ),
    PythonNotificationItem(
      id: 96,
      title: 'Loggers over Print Statements',
      body: 'In production code, replace `print()` with Python\'s `logging` module to capture timestamps, severity, and traces.',
      category: 'Production',
      icon: Icons.subject_rounded,
    ),
    PythonNotificationItem(
      id: 97,
      title: 'Profiling with cProfile',
      body: 'Don\'t guess where bottlenecks are. Profile runtime performance scientifically with `python -m cProfile script.py`.',
      category: 'Profiling',
      icon: Icons.analytics_outlined,
    ),
    PythonNotificationItem(
      id: 98,
      title: 'Unit Testing with Pytest',
      body: 'Tests are living documentation. Writing simple asserts with `pytest` gives you the confidence to refactor boldly.',
      category: 'Testing',
      icon: Icons.fact_check_outlined,
    ),
    PythonNotificationItem(
      id: 99,
      title: 'Late Night Streak Victory',
      body: 'You showed up, coded, and made progress today. Rest well; tomorrow\'s algorithms await your commands.',
      category: 'Completion',
      icon: Icons.night_shelter_outlined,
    ),
    PythonNotificationItem(
      id: 100,
      title: 'PyPocket Master Certificate',
      body: 'Mastery is not an accident—it is the accumulation of daily commits. Keep building your legacy.',
      category: 'Mastery',
      icon: Icons.workspace_premium_rounded,
    ),
  ];

  // Request system OS notification permission
  static Future<bool> requestNotificationPermission() async {
    return SystemNotificationBridge.requestPermission();
  }

  // Trigger a random system notification from the 100 bank
  static Future<PythonNotificationItem> triggerRandomSystemNotification() async {
    final random = Random();
    final item = notificationBank[random.nextInt(notificationBank.length)];

    await SystemNotificationBridge.showSystemNotification(
      title: item.title,
      body: item.body,
      iconPath: 'icons/Icon-192.png',
    );

    return item;
  }

  // Get daily notification suggestions based on user commitment
  static List<PythonNotificationItem> getDailyScheduledNotifications(UserProfile profile) {
    final seed = DateTime.now().day;
    final random = Random(seed);
    final selected = <PythonNotificationItem>[];

    // Pick 4 diverse notifications from different quarters of the 100 bank
    selected.add(notificationBank[random.nextInt(20)]); // Morning
    selected.add(notificationBank[20 + random.nextInt(20)]); // Midday
    selected.add(notificationBank[50 + random.nextInt(25)]); // Evening
    selected.add(notificationBank[75 + random.nextInt(25)]); // Night

    return selected;
  }

  // Interactive Notification Center Modal Sheet
  static void showNotificationCenterSheet(BuildContext context, UserProfile profile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheduled = getDailyScheduledNotifications(profile);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.82,
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141822) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: isDark ? const Color(0xFF232A3B) : const Color(0xFFEAE3D6),
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle pill
                  Center(
                    child: Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC89B58).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_active_rounded,
                              color: Color(0xFFC89B58),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notification Hub',
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF17191C),
                                ),
                              ),
                              Text(
                                '100 Curated Python Learning Prompts',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Real OS System Notification Test Trigger Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final triggered = await triggerRandomSystemNotification();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Triggered: "${triggered.title}" via System Push',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              duration: const Duration(seconds: 2),
                              backgroundColor: const Color(0xFF17191C),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC89B58),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text(
                        'Send Test System Notification Now',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    "TODAY'S SCHEDULED NOTIFICATIONS",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: const Color(0xFFC89B58),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: scheduled.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = scheduled[index];
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1C2230) : const Color(0xFFFAF7F2),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? const Color(0xFF2A3448) : const Color(0xFFEAE3D6),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC89B58).withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item.icon, size: 18, color: const Color(0xFFC89B58)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item.title,
                                            style: TextStyle(
                                              fontFamily: 'Outfit',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : const Color(0xFF17191C),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          item.category,
                                          style: TextStyle(
                                            fontFamily: 'JetBrains Mono',
                                            fontSize: 10,
                                            color: const Color(0xFFC89B58),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.body,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        height: 1.4,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF5A6372),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
