class CodeExecutionResult {
  final String stdout;
  final String? stderr;
  final String? compileOutput;
  final String? executionTime;
  final int? memory;
  final String status;
  final bool isSuccess;

  CodeExecutionResult({
    required this.stdout,
    this.stderr,
    this.compileOutput,
    this.executionTime,
    this.memory,
    required this.status,
    required this.isSuccess,
  });

  factory CodeExecutionResult.fromJson(Map<String, dynamic> json) {
    final statusObj = json['status'] as Map<String, dynamic>?;
    final statusId = statusObj?['id'] as int? ?? 0;
    final statusDesc = statusObj?['description'] as String? ?? 'Unknown';

    final stdout = json['stdout'] as String? ?? '';
    final stderr = json['stderr'] as String?;
    final compileOutput = json['compile_output'] as String?;
    final time = json['time'] as String?;
    final memory = json['memory'] as int?;

    // Status 3 in Judge0 means 'Accepted' (successful execution)
    final isSuccess = statusId == 3;

    return CodeExecutionResult(
      stdout: stdout,
      stderr: stderr,
      compileOutput: compileOutput,
      executionTime: time,
      memory: memory,
      status: statusDesc,
      isSuccess: isSuccess,
    );
  }

  factory CodeExecutionResult.error(String message) {
    return CodeExecutionResult(
      stdout: '',
      stderr: message,
      status: 'Execution Failed',
      isSuccess: false,
    );
  }
}
