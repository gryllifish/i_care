import 'package:i_care/core/error/failure.dart';
import 'package:i_care/core/l10n/l10n.dart';

extension FailureMessage on Failure {
  /// User-friendly, localized description of this failure.
  String message(AppLocalizations l10n) => switch (this) {
    StorageFailure() || ParsingFailure() => l10n.errorLoadData,
    NotFoundFailure() => l10n.errorNotFound,
    NoConnectionFailure() => l10n.errorOffline,
    TimeoutFailure() => l10n.errorTimeout,
    ServerFailure() => l10n.errorServer,
    UnexpectedFailure() => l10n.errorUnexpected,
    NotMemberFailure() => l10n.errorNotMember,
    ForbiddenFailure() => l10n.errorForbidden,
    InvalidCodeFailure(problem: CodeProblem.unknown) => l10n.errorCodeUnknown,
    InvalidCodeFailure(problem: CodeProblem.used) => l10n.errorCodeUsed,
    InvalidCodeFailure(problem: CodeProblem.expired) => l10n.errorCodeExpired,
    InvalidCodeFailure(problem: CodeProblem.locked) => l10n.errorCodeLocked,
  };
}

extension ErrorMessage on AppLocalizations {
  /// Message for an error surfaced by a provider: the [Failure]'s own
  /// message, or a generic one for anything unexpected.
  String errorMessage(Object error) => switch (error) {
    final Failure failure => failure.message(this),
    _ => errorUnexpected,
  };
}
