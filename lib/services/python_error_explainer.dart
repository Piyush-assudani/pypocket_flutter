class PythonExplainedError {
  final String errorType;
  final int? lineNumber;
  final String summary;
  final String beginnerExplanation;
  final String suggestedFix;
  final String codeExample;

  const PythonExplainedError({
    required this.errorType,
    this.lineNumber,
    required this.summary,
    required this.beginnerExplanation,
    required this.suggestedFix,
    required this.codeExample,
  });
}

class PythonErrorExplainer {
  static PythonExplainedError? explain(String rawStderr) {
    if (rawStderr.trim().isEmpty) return null;

    final text = rawStderr;
    final int? detectedLine = _extractLineNumber(text);

    if (text.contains('IndentationError')) {
      return PythonExplainedError(
        errorType: 'IndentationError',
        lineNumber: detectedLine,
        summary: 'Incorrect code indentation or mixed spaces/tabs.',
        beginnerExplanation:
            'Python does not use curly brackets {} to group code blocks. Instead, it relies strictly on consistent indentation (standard 4 spaces).',
        suggestedFix:
            'Ensure all code lines inside if-statements, loops, or functions are indented by exactly 4 spaces.',
        codeExample: '''# [INCORRECT]:
def greet():
print("Hello") # Missing indent!

# [CORRECT]:
def greet():
    print("Hello") # 4 spaces indent''',
      );
    }

    if (text.contains('SyntaxError')) {
      return PythonExplainedError(
        errorType: 'SyntaxError',
        lineNumber: detectedLine,
        summary: 'Python parser encountered invalid grammar.',
        beginnerExplanation:
            'Usually caused by a missing colon (:), an unclosed quotation mark (\' or "), or unmatched brackets () or [].',
        suggestedFix:
            'Check line ${detectedLine ?? 'around the error'} and the line immediately above it for missing colons or quotes.',
        codeExample: '''# [INCORRECT]:
if score >= 50
    print("Pass")

# [CORRECT]:
if score >= 50: # Added colon :
    print("Pass")''',
      );
    }

    if (text.contains('IndexError')) {
      return PythonExplainedError(
        errorType: 'IndexError: list index out of range',
        lineNumber: detectedLine,
        summary: 'Attempted to access an element past the list boundaries.',
        beginnerExplanation:
            'Python lists are 0-indexed. If a list has 3 elements, valid indices are 0, 1, and 2. Index 3 is out of range.',
        suggestedFix:
            'Verify list length with len(my_list) or use `if index < len(my_list):` before indexing.',
        codeExample: '''# [INCORRECT]:
nums = [10, 20, 30] # len is 3
print(nums[3]) # Crash!

# [CORRECT]:
print(nums[2]) # 30
print(nums[-1]) # Last element safely''',
      );
    }

    if (text.contains('KeyError')) {
      return PythonExplainedError(
        errorType: 'KeyError',
        lineNumber: detectedLine,
        summary: 'Dictionary key lookup failed.',
        beginnerExplanation:
            'The key you tried to access in the dictionary does not exist.',
        suggestedFix:
            'Use the safe `dict.get(key, default)` method to avoid crashing when a key might be absent.',
        codeExample: '''# [INCORRECT]:
user = {"name": "Alex"}
age = user["age"] # KeyError!

# [CORRECT]:
age = user.get("age", 0) # Returns 0 if missing''',
      );
    }

    if (text.contains('TypeError')) {
      return PythonExplainedError(
        errorType: 'TypeError',
        lineNumber: detectedLine,
        summary: 'Operation applied to an inappropriate or incompatible data type.',
        beginnerExplanation:
            'Python is strongly typed. You cannot directly combine or concatenate strings and numbers without explicit conversion.',
        suggestedFix:
            'Convert variables using `str()`, `int()`, or format with an f-string: `f"Result: {val}"`.',
        codeExample: '''# [INCORRECT]:
age = 25
print("Age: " + age) # TypeError!

# [CORRECT]:
print(f"Age: {age}")
print("Age: " + str(age))''',
      );
    }

    if (text.contains('NameError')) {
      return PythonExplainedError(
        errorType: 'NameError',
        lineNumber: detectedLine,
        summary: 'Identifier used before assignment or typo in variable name.',
        beginnerExplanation:
            'Python encountered a name that was never assigned in current or global scope, or there is a spelling mistake.',
        suggestedFix:
            'Check variable spelling and make sure variables are assigned before being read.',
        codeExample: '''# [INCORRECT]:
print(total) # total is not defined yet!
total = 100

# [CORRECT]:
total = 100
print(total)''',
      );
    }

    if (text.contains('ZeroDivisionError')) {
      return PythonExplainedError(
        errorType: 'ZeroDivisionError',
        lineNumber: detectedLine,
        summary: 'Division or modulo operation by 0.',
        beginnerExplanation:
            'Division by zero is mathematically undefined. Python stops execution to prevent corrupted calculations.',
        suggestedFix:
            'Check that divisor != 0 before performing division or modulo.',
        codeExample: '''# [INCORRECT]:
res = 10 / 0 # Crash!

# [CORRECT]:
divisor = 0
res = 10 / divisor if divisor != 0 else 0''',
      );
    }

    if (text.contains('AttributeError')) {
      return PythonExplainedError(
        errorType: 'AttributeError',
        lineNumber: detectedLine,
        summary: 'Method or property does not exist on this object type.',
        beginnerExplanation:
            'You tried to call a method that is not supported by this data type (e.g., calling .append() on a tuple or string).',
        suggestedFix:
            'Verify the object\'s actual type with `print(type(variable))` to ensure it supports this method.',
        codeExample: '''# [INCORRECT]:
my_tuple = (1, 2, 3)
my_tuple.append(4) # Tuples are immutable!

# [CORRECT]:
my_list = [1, 2, 3]
my_list.append(4)''',
      );
    }

    if (text.contains('ValueError')) {
      return PythonExplainedError(
        errorType: 'ValueError',
        lineNumber: detectedLine,
        summary: 'Received argument of correct type but inappropriate value.',
        beginnerExplanation:
            'Typically occurs when converting a non-numeric string to an integer, or unpacking mismatched tuple sizes.',
        suggestedFix:
            'Validate input format or wrap conversion in a try/except ValueError block.',
        codeExample: '''# [INCORRECT]:
num = int("abc") # ValueError!

# [CORRECT]:
text = "abc"
if text.isdigit():
    num = int(text)
else:
    num = 0''',
      );
    }

    if (text.contains('RecursionError')) {
      return PythonExplainedError(
        errorType: 'RecursionError: maximum recursion depth exceeded',
        lineNumber: detectedLine,
        summary: 'Infinite recursive function call stack.',
        beginnerExplanation:
            'Your function kept calling itself without reaching a stopping condition (base case).',
        suggestedFix:
            'Add a base condition: `if n <= 1: return 1` to terminate recursion.',
        codeExample: '''# [INCORRECT]:
def count(n):
    return count(n - 1) # Never stops!

# [CORRECT]:
def count(n):
    if n <= 0: return # Base condition
    count(n - 1)''',
      );
    }

    // Generic fallback for any runtime exception
    return PythonExplainedError(
      errorType: 'Python Runtime Exception',
      lineNumber: detectedLine,
      summary: 'Script execution encountered an unhandled exception.',
      beginnerExplanation:
          'A runtime error halted the script. Read the traceback below to pinpoint the offending line and variable states.',
      suggestedFix:
          'Wrap suspect statements in a `try: ... except Exception as e:` block to inspect and handle error safely.',
      codeExample: '''try:
    # Your code here
    pass
except Exception as e:
    print(f"Caught error: {e}")''',
    );
  }

  static int? _extractLineNumber(String text) {
    // Matches "line 4" or "line 12,"
    final regex = RegExp(r'line\s+(\d+)', caseSensitive: false);
    final match = regex.firstMatch(text);
    if (match != null && match.groupCount >= 1) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }
}
