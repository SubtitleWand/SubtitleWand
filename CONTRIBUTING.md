# Contributing to Subtitle Wand

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

The following is a set of guidelines for contributing to Subtitle Wand and its packages.
These are mostly guidelines, not rules. Use your best judgment,
and feel free to propose changes to this document in a pull request.

## Proposing a Change

If you intend to change the core painter/panel, or make any non-trivial changes
to the implementation, we recommend filing an issue.
This lets us reach an agreement on your proposal before you put significant
effort into it.

If you’re only fixing a bug, it’s fine to submit a pull request right away
but we still recommend to file an issue detailing what you’re fixing.
This is helpful in case we don’t accept that specific fix but want to keep
track of the issue.

## Creating a Pull Request

Before creating a pull request please:

1. Fork the repository and create your branch from `master`.
2. Install all dependencies (`flutter packages get` or `pub get`).
3. Squash your commits and ensure you have a meaningful commit message.
4. If you’ve fixed a bug or added code that should be tested, add tests!
Pull Requests without 100% test coverage will not be approved.
5. Ensure the test suite passes.
6. If you've changed the public API, make sure to update/add documentation.
7. Don't Format your code with (`dartfmt -w .`), If It make It indent the arguments 4 characters. See [Style Guild](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo#indent-multi-line-argument-and-parameter-lists-by-2-characters), [Issue](https://github.com/flutter/flutter/issues/53018), use [pedantic](https://github.com/dart-lang/pedantic) to check in vscode.
8. Analyze your code (`dartanalyzer --fatal-infos --fatal-warnings .`).
9. Create the Pull Request.
10. Verify that all status checks are passing.

While the prerequisites above must be satisfied prior to having your
pull request reviewed, the reviewer(s) may ask you to complete additional
design work, tests, or other changes before your pull request can be ultimately
accepted.

## License

By contributing to Bloc, you agree that your contributions will be licensed
under its [GNU license](LICENSE).

## Attribution
This Contributing is adapted from the [felangel's bloc](https://github.com/felangel/bloc/blob/master/CONTRIBUTING.md),