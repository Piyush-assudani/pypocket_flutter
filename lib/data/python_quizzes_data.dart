import '../models/quiz_model.dart';

class PythonQuizzesData {
  static const List<QuizQuestion> certificationExamQuestions = [
    QuizQuestion(
      id: "cert_q1",
      category: "Certification Exam",
      question: "What will be the output of the following Python code snippet?",
      codeSnippet: '''x = [1, 2, 3]
y = x
y.append(4)
print(len(x))''',
      options: ["3", "4", "Error: Lists are immutable", "None"],
      correctIndex: 1,
      explanation: "Lists are mutable references in Python. Assigning `y = x` does not make a copy; both reference the same object in memory.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q2",
      category: "Certification Exam",
      question: "What is the result of evaluating this boolean and arithmetic expression?",
      codeSnippet: '''print(bool([]) == False and bool([0]) == True)''',
      options: ["False", "True", "TypeError", "ZeroDivisionError"],
      correctIndex: 1,
      explanation: "An empty list `[]` is falsy (`bool([]) == False`), while a non-empty list `[0]` is truthy (`bool([0]) == True`).",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q3",
      category: "Certification Exam",
      question: "What will be printed by this list comprehension?",
      codeSnippet: '''matrix = [[1, 2], [3, 4]]
flat = [num for row in matrix for num in row]
print(flat)''',
      options: [
        "[[1, 2], [3, 4]]",
        "[1, 2, 3, 4]",
        "[1, 3, 2, 4]",
        "SyntaxError",
      ],
      correctIndex: 1,
      explanation: "In nested list comprehensions, the `for row in matrix` runs first, followed by `for num in row`.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q4",
      category: "Certification Exam",
      question: "What does the `*args` and `**kwargs` syntax unpack in function definitions?",
      options: [
        "*args unpacks positional arguments into a tuple; **kwargs unpacks keyword arguments into a dictionary.",
        "*args unpacks into a list; **kwargs unpacks into a set.",
        "*args unpacks keyword arguments; **kwargs unpacks positional arguments.",
        "Both unpack into lists.",
      ],
      correctIndex: 0,
      explanation: "*args collects surplus positional parameters into a tuple, while **kwargs collects keyword arguments into a dict.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q5",
      category: "Certification Exam",
      question: "What will be the output of this dictionary operation?",
      codeSnippet: '''d = {"a": 1, "b": 2}
print(d.get("c", 100))''',
      options: ["KeyError", "None", "100", "0"],
      correctIndex: 2,
      explanation: "The `.get(key, default)` method returns the default value (100) instead of raising a KeyError when key is missing.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q6",
      category: "Certification Exam",
      question: "In Python OOP, what is the role of the `__init__` method?",
      options: [
        "It destroys the object when garbage collected.",
        "It initializes the object's instance attributes upon instantiation.",
        "It compiles the class into bytecode.",
        "It defines the string representation for print.",
      ],
      correctIndex: 1,
      explanation: "`__init__` is the constructor/initializer method called immediately after a new instance of a class is created.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q7",
      category: "Certification Exam",
      question: "What will this generator function output when iterated?",
      codeSnippet: '''def count_up():
    yield 1
    yield 2
    yield 3

gen = count_up()
print(next(gen) + next(gen))''',
      options: ["3", "6", "1", "TypeError"],
      correctIndex: 0,
      explanation: "The first `next(gen)` yields 1, and the second yields 2. 1 + 2 = 3.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q8",
      category: "Certification Exam",
      question: "What is the average time complexity for searching an element in a Python `set`?",
      options: ["O(N)", "O(log N)", "O(1)", "O(N^2)"],
      correctIndex: 2,
      explanation: "Python sets use hash tables internally, providing average O(1) constant time lookup and insertion.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q9",
      category: "Certification Exam",
      question: "What happens in Python when you divide by zero inside a `try-except` block?",
      codeSnippet: '''try:
    res = 10 / 0
except ZeroDivisionError:
    res = -1
finally:
    res = 99
print(res)''',
      options: ["-1", "99", "ZeroDivisionError", "None"],
      correctIndex: 1,
      explanation: "The `finally` block ALWAYS executes regardless of whether an exception occurred or was handled.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q10",
      category: "Certification Exam",
      question: "What does the `is` operator check compared to the `==` operator?",
      options: [
        "`==` checks memory identity; `is` checks value equality.",
        "`is` checks memory identity (object identity); `==` checks value equality.",
        "They are completely identical in every case.",
        "`is` is only valid for strings.",
      ],
      correctIndex: 1,
      explanation: "`is` verifies if both references point to the exact same object in memory (`id(a) == id(b)`), whereas `==` checks equality of values.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q11",
      category: "Certification Exam",
      question: "What error is raised when attempting to mutate an attribute of a `@dataclass(frozen=True)` instance?",
      options: ["AttributeError", "FrozenInstanceError", "TypeError", "ValueError"],
      correctIndex: 1,
      explanation: "Frozen dataclasses enforce immutability by intercepting `__setattr__` and raising `dataclasses.FrozenInstanceError`.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q12",
      category: "Certification Exam",
      question: "In `asyncio.gather(*tasks, return_exceptions=True)`, what happens if one task raises an exception?",
      options: [
        "The entire gather crashes immediately.",
        "The exception is returned as a list element and sibling tasks continue running.",
        "The exception is silently ignored and omitted from results.",
        "The event loop terminates.",
      ],
      correctIndex: 1,
      explanation: "Setting `return_exceptions=True` catches errors and treats exceptions as normal result items, preventing premature cancellation of siblings.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q13",
      category: "Certification Exam",
      question: "What architectural benefit does `typing.Protocol` provide over standard inheritance with `abc.ABC`?",
      options: [
        "It provides runtime compilation to C.",
        "It enables structural subtyping (duck typing) without requiring classes to explicitly inherit from the Protocol.",
        "It makes dictionaries immutable.",
        "It automatically optimizes database queries.",
      ],
      correctIndex: 1,
      explanation: "Protocols allow static and runtime duck typing without forced inheritance hierarchies.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q14",
      category: "Certification Exam",
      question: "Which function should be used to prevent timing side-channel attacks when comparing secret tokens?",
      options: [
        "secrets.compare_digest(a, b)",
        "hashlib.md5(a) == hashlib.md5(b)",
        "operator.eq(a, b)",
        "a.casefold() == b.casefold()",
      ],
      correctIndex: 0,
      explanation: "`secrets.compare_digest()` performs a constant-time comparison that does not leak timing information to attackers.",
      xp: 25,
    ),
    QuizQuestion(
      id: "cert_q15",
      category: "Certification Exam",
      question: "Why does declaring `__slots__` or `@dataclass(slots=True)` reduce memory usage in CPython?",
      options: [
        "It compresses string characters using gzip.",
        "It replaces the dynamic `__dict__` hash table with a fixed-size C array of pointers.",
        "It converts Python bytecode to Assembly.",
        "It disables the garbage collector completely.",
      ],
      correctIndex: 1,
      explanation: "Slots prevent the per-instance allocation of the heavy `__dict__` hash map, saving 40-60% memory per object.",
      xp: 25,
    ),
  ];

  static const List<QuizQuestion> beginnerQuestions = [
    QuizQuestion(
      id: "beg_1",
      category: "Foundations",
      question: "Which of the following is an immutable data type in Python?",
      options: ["List", "Dictionary", "Tuple", "Set"],
      correctIndex: 2,
      explanation: "Tuples and strings are immutable in Python, meaning their elements cannot be changed in place.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_2",
      category: "Foundations",
      question: "What is the output of `print(2 ** 3)` in Python?",
      options: ["6", "8", "9", "5"],
      correctIndex: 1,
      explanation: "In Python, `**` is the exponentiation operator: 2 ** 3 = 2 * 2 * 2 = 8.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_3",
      category: "Foundations",
      question: "How do you reverse a string `s = 'Python'` using slicing?",
      options: ["s[::1]", "s[::-1]", "s.reverse()", "s[-1:0]"],
      correctIndex: 1,
      explanation: "The step `-1` in `s[::-1]` iterates backwards over the string.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_4",
      category: "Foundations",
      question: "What is the output of `type([])` in Python?",
      options: ["<class 'list'>", "<class 'array'>", "<class 'sequence'>", "<class 'dict'>"],
      correctIndex: 0,
      explanation: "Empty square brackets `[]` create a list instance.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_5",
      category: "Foundations",
      question: "Which keyword is used to declare a function in Python?",
      options: ["func", "function", "def", "lambda"],
      correctIndex: 2,
      explanation: "In Python, standard functions are defined using the `def` keyword.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_6",
      category: "Foundations",
      question: "What is the default return value of a Python function that does not contain a return statement?",
      options: ["0", "False", "None", "undefined"],
      correctIndex: 2,
      explanation: "Functions without an explicit return statement implicitly return `None` upon reaching completion.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_7",
      category: "Foundations",
      question: "Which data structure stores data as key-value pairs with O(1) average lookup time?",
      options: ["List", "Dictionary", "Tuple", "Linked List"],
      correctIndex: 1,
      explanation: "Python dictionaries (`dict`) use hash tables to provide O(1) average key-value lookups.",
      xp: 20,
    ),
    QuizQuestion(
      id: "beg_8",
      category: "Foundations",
      question: "Which pair of keywords is used for structured exception handling in Python?",
      options: ["try / except", "try / catch", "begin / rescue", "do / handle"],
      correctIndex: 0,
      explanation: "Python uses `try` blocks and `except` clauses to catch and handle exceptions.",
      xp: 20,
    ),
  ];
}
