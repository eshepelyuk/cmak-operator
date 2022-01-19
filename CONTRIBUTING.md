# Contributing guide

## Requirements

### Commit message format

This repository uses [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

Use only following _types_ to create valid commit messages:

* `feat`, for a new functionality.
* `fix`, for a bug fixes.
* `chore`, for everything else (CI/CD, docs, etc)

Also, we would like PRs to contain a single commit and be rebased onto project `master` branch before submitting.

### Test coverage

The project is covered by following types of tests

* linter tests - `test/linter`
* unit tests - `test/unit`
* e2e tests - `test/e2e`

Every PR should provide appropriate amount of testing, corresponding to its scope.

Use `GNU Make` to run test locally:

* `make test-lint` - execute linter tests
* `make test-unit` - execute unit tests

## Development flow.

Although, you could choose your own approach to create branches, develop code
and provide new PR, we recommend following.

1. Fork this project and clone it to local PC.

1. Add this project as a new remote named `upstream`.

    ```sh
    git remote add upstream https://github.com/eshepelyuk/cmak-operator.git
    git fetch upstream
    ```

1. Create a new branch, based on `upstream` master and push it to your repository.

    ```sh
    git checkout --no-track -b <BRANCH NAME> upstream/master
    git push -u origin <BRANCH NAME>
    ```

1. Develop your code locally, test and commit.

    ```sh
    git commit -am '<COMMIT MESSAGE>'
    ```

1. Before pushing code to `origin` ensure your working branch is rebased onto `upstream/master`.

    ```sh
    git fetch upstream
    git rebase -i upstream/master
    ```
    During rebase, make your PR to be comprised of a single commit,
    unless, you _really_ want to provide multiple commits via single PR.

1. Push your branch and create a PR via GitHub UI.

    ```sh
    git push -u -f origin <BRANCH NAME>
    ```

