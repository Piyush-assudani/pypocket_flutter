class DailyChallenge {
  final String id;
  final String title;
  final String difficulty;
  final String description;
  final String examples;
  final String starterCode;
  final String testRunnerCode;
  final int xpReward;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.description,
    required this.examples,
    required this.starterCode,
    required this.testRunnerCode,
    this.xpReward = 75,
  });
}

class DailyChallengesData {
  static const List<DailyChallenge> challenges = [
    DailyChallenge(
      id: "challenge_two_sum",
      title: "Two Sum Target Indices",
      difficulty: "Easy",
      description: "Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`. Each input has exactly one solution, and you may not use the same element twice.",
      examples: '''Input: nums = [2, 7, 11, 15], target = 9
Output: [0, 1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].''',
      starterCode: '''def two_sum(nums, target):
    # Write your solution here
    # Hint: Use a hash table (dict) for O(N) lookup
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ([2, 7, 11, 15], 9, [0, 1]),
    ([3, 2, 4], 6, [1, 2]),
    ([3, 3], 6, [0, 1]),
    ([1, 5, 8, 12, 19], 20, [0, 4]),
]

passed = 0
for idx, (nums, target, expected) in enumerate(tests, 1):
    result = two_sum(nums, target)
    if result == expected:
        print(f"[PASS] Test {idx}: two_sum({nums}, {target}) == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, but got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 75,
    ),

    DailyChallenge(
      id: "challenge_valid_palindrome",
      title: "Valid Alphanumeric Palindrome",
      difficulty: "Easy",
      description: "A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward.",
      examples: '''Input: s = "A man, a plan, a canal: Panama"
Output: True
Explanation: "amanaplanacanalpanama" is a palindrome.''',
      starterCode: '''def is_palindrome(s: str) -> bool:
    # Filter lowercase alphanumeric characters and check reverse
    clean = "".join(c.lower() for c in s if c.isalnum())
    return clean == clean[::-1]
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ("A man, a plan, a canal: Panama", True),
    ("race a car", False),
    (" ", True),
    ("0P", False),
    ("Was it a car or a cat I saw?", True),
]

passed = 0
for idx, (string, expected) in enumerate(tests, 1):
    result = is_palindrome(string)
    if result == expected:
        print(f"[PASS] Test {idx}: is_palindrome('{string[:15]}...') == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, but got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 75,
    ),

    DailyChallenge(
      id: "challenge_reverse_words",
      title: "Reverse Words in a String",
      difficulty: "Medium",
      description: "Given an input string `s`, reverse the order of the words. A word is defined as a sequence of non-space characters. Return a string with a single space separating the reversed words.",
      examples: '''Input: s = "the sky is blue"
Output: "blue is sky the"

Input: s = "  hello world  "
Output: "world hello"''',
      starterCode: '''def reverse_words(s: str) -> str:
    # Split by whitespace, reverse sequence, and join with single space
    return " ".join(s.split()[::-1])
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ("the sky is blue", "blue is sky the"),
    ("  hello world  ", "world hello"),
    ("a good   example", "example good a"),
    ("Python", "Python"),
]

passed = 0
for idx, (string, expected) in enumerate(tests, 1):
    result = reverse_words(string)
    if result == expected:
        print(f"[PASS] Test {idx}: reverse_words('{string}') == '{result}'")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected '{expected}', got '{result}'")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 80,
    ),

    DailyChallenge(
      id: "challenge_single_number",
      title: "Single Non-Duplicate Number",
      difficulty: "Medium",
      description: "Given a non-empty array of integers `nums`, every element appears twice except for one. Find that single one in linear O(N) time using O(1) space (Bitwise XOR).",
      examples: '''Input: nums = [4, 1, 2, 1, 2]
Output: 4
Explanation: 1 and 2 appear twice. 4 appears once.''',
      starterCode: '''def single_number(nums):
    # Bitwise XOR trick: a ^ a = 0, a ^ 0 = a
    result = 0
    for n in nums:
        result ^= n
    return result
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ([2, 2, 1], 1),
    ([4, 1, 2, 1, 2], 4),
    ([1], 1),
    ([7, 3, 5, 3, 7], 5),
]

passed = 0
for idx, (nums, expected) in enumerate(tests, 1):
    result = single_number(nums)
    if result == expected:
        print(f"[PASS] Test {idx}: single_number({nums}) == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 85,
    ),

    DailyChallenge(
      id: "challenge_valid_parentheses",
      title: "Valid Bracket Sequences (Stack)",
      difficulty: "Easy",
      description: "Given a string `s` containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid. Open brackets must be closed by the same type of brackets in the correct order.",
      examples: '''Input: s = "()[]{}"
Output: True

Input: s = "(]"
Output: False''',
      starterCode: '''def is_valid_brackets(s: str) -> bool:
    stack = []
    mapping = {")": "(", "}": "{", "]": "["}
    for char in s:
        if char in mapping:
            top = stack.pop() if stack else '#'
            if mapping[char] != top:
                return False
        else:
            stack.append(char)
    return not stack
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ("()", True),
    ("()[]{}", True),
    ("(]", False),
    ("([)]", False),
    ("{[]}", True),
    ("(((", False),
]

passed = 0
for idx, (string, expected) in enumerate(tests, 1):
    result = is_valid_brackets(string)
    if result == expected:
        print(f"[PASS] Test {idx}: is_valid_brackets('{string}') == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 80,
    ),

    DailyChallenge(
      id: "challenge_max_subarray",
      title: "Maximum Subarray Sum (Kadane's)",
      difficulty: "Medium",
      description: "Given an integer array `nums`, find the subarray with the largest sum, and return its sum in linear O(N) time.",
      examples: '''Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: The subarray [4,-1,2,1] has the largest sum 6.''',
      starterCode: '''def max_sub_array(nums):
    # Kadane's algorithm
    max_so_far = nums[0]
    curr_max = nums[0]
    for x in nums[1:]:
        curr_max = max(x, curr_max + x)
        max_so_far = max(max_so_far, curr_max)
    return max_so_far
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ([-2, 1, -3, 4, -1, 2, 1, -5, 4], 6),
    ([1], 1),
    ([5, 4, -1, 7, 8], 23),
    ([-1, -2, -3], -1),
]

passed = 0
for idx, (nums, expected) in enumerate(tests, 1):
    result = max_sub_array(nums)
    if result == expected:
        print(f"[PASS] Test {idx}: max_sub_array({nums}) == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 90,
    ),

    DailyChallenge(
      id: "challenge_binary_search",
      title: "Binary Search Logarithmic Algorithm",
      difficulty: "Easy",
      description: "Given an array of integers `nums` which is sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If target exists, return its index. Otherwise, return -1 in O(log n) time.",
      examples: '''Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9 exists in nums and its index is 4.''',
      starterCode: '''def search(nums, target):
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = (left + right) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ([-1, 0, 3, 5, 9, 12], 9, 4),
    ([-1, 0, 3, 5, 9, 12], 2, -1),
    ([5], 5, 0),
    ([1, 3, 5, 7, 9], 1, 0),
    ([1, 3, 5, 7, 9], 9, 4),
]

passed = 0
for idx, (nums, target, expected) in enumerate(tests, 1):
    result = search(nums, target)
    if result == expected:
        print(f"[PASS] Test {idx}: search({nums}, {target}) == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 75,
    ),

    DailyChallenge(
      id: "challenge_climbing_stairs",
      title: "Climbing Stairs (Dynamic Programming)",
      difficulty: "Easy",
      description: "You are climbing a staircase. It takes `n` steps to reach the top. Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?",
      examples: '''Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top:
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step''',
      starterCode: '''def climb_stairs(n: int) -> int:
    if n <= 2:
        return n
    a, b = 1, 2
    for _ in range(3, n + 1):
        a, b = b, a + b
    return b
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 5),
    (5, 8),
    (6, 13),
]

passed = 0
for idx, (n, expected) in enumerate(tests, 1):
    result = climb_stairs(n)
    if result == expected:
        print(f"[PASS] Test {idx}: climb_stairs({n}) == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 80,
    ),

    DailyChallenge(
      id: "challenge_longest_common_prefix",
      title: "Longest Common Prefix",
      difficulty: "Easy",
      description: "Write a function to find the longest common prefix string amongst an array of strings. If there is no common prefix, return an empty string.",
      examples: '''Input: strs = ["flower","flow","flight"]
Output: "fl"''',
      starterCode: '''def longest_common_prefix(strs):
    if not strs:
        return ""
    prefix = strs[0]
    for s in strs[1:]:
        while not s.startswith(prefix):
            prefix = prefix[:-1]
            if not prefix:
                return ""
    return prefix
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    (["flower", "flow", "flight"], "fl"),
    (["dog", "racecar", "car"], ""),
    (["interspecies", "interstellar", "interstate"], "inters"),
    (["throne", "throne"], "throne"),
]

passed = 0
for idx, (arr, expected) in enumerate(tests, 1):
    result = longest_common_prefix(arr)
    if result == expected:
        print(f"[PASS] Test {idx}: longest_common_prefix({arr}) == '{result}'")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected '{expected}', got '{result}'")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 75,
    ),

    DailyChallenge(
      id: "challenge_contains_duplicate",
      title: "Duplicate Element Detection (Hash Sets)",
      difficulty: "Easy",
      description: "Given an integer array `nums`, return true if any value appears at least twice in the array, and return false if every element is distinct in O(N) time.",
      examples: '''Input: nums = [1,2,3,1]
Output: True

Input: nums = [1,2,3,4]
Output: False''',
      starterCode: '''def contains_duplicate(nums):
    return len(nums) != len(set(nums))
''',
      testRunnerCode: '''# --- AUTOMATED TEST VERIFIER ---
tests = [
    ([1, 2, 3, 1], True),
    ([1, 2, 3, 4], False),
    ([1, 1, 1, 3, 3, 4, 3, 2, 4, 2], True),
    ([], False),
]

passed = 0
for idx, (nums, expected) in enumerate(tests, 1):
    result = contains_duplicate(nums)
    if result == expected:
        print(f"[PASS] Test {idx}: contains_duplicate({nums}) == {result}")
        passed += 1
    else:
        print(f"[FAIL] Test {idx}: Expected {expected}, got {result}")

print(f"\\nSUMMARY: {passed}/{len(tests)} tests passed.")
if passed == len(tests):
    print("SUCCESS: ALL_TESTS_PASSED")
''',
      xpReward: 70,
    ),
  ];

  static DailyChallenge getTodayChallenge() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    return challenges[dayOfYear % challenges.length];
  }
}
