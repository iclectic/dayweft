enum PlanningFailureCode {
  invalidInput,
  notFound,
  staleProposal,
  constraintViolation,
}

class PlanningFailure implements Exception {
  const PlanningFailure(this.code, this.message);
  final PlanningFailureCode code;
  final String message;
  @override
  String toString() => message;
}
