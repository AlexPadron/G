import subprocess
from typing import List

import click


class DiffInfo:
    def __init__(self, commit: str) -> None:
        self.lines_added: List[str] = []
        self.commit = commit

    def __str__(self) -> str:
        return "commit: {}, \n lines added: \n {} \n".format(
            self.commit, "\n".join(self.lines_added)
        )

    def __repr__(self) -> str:
        return self.__str__()


@click.command()
@click.argument("version_file", type=str)
@click.argument("version_number", type=str)
def checkout_version(version_file: str, version_number: str) -> None:
    """Checkout a git revision based on the version of a package/project"""
    raw_file_history = subprocess.check_output(["git", "log", "-p", "--", version_file]).decode(
        "utf-8"
    )
    file_history_lines = raw_file_history.strip().split("\n")
    all_diffs = []
    # First, group the lines of output into DiffInfo objects

    for line in file_history_lines:
        # Indicates we are starting to work with a new diff
        if line.startswith("commit "):
            commit = line.strip().split(" ")[1]
            current_diff = DiffInfo(commit)
            all_diffs.append(current_diff)

        # Other than 'commit xxxxx' lines, we only care about added lines
        # start by filtering out file modifications
        if line.startswith("+++") or line.startswith("---"):
            continue

        # the only remaining lines with plus marks at the start are additions to the file
        if line.startswith("+"):
            current_diff.lines_added.append(line[1:])

    # Now, iterate over all the diffs and figure out the one that added the version
    # we are looking for. If multiple diffs have the same version, take the most recent
    target_diff = None

    for diff in reversed(all_diffs):
        if any(version_number in line for line in diff.lines_added):
            target_diff = diff
            break

    if target_diff is None:
        raise RuntimeError(
            "Version string {} not found in history of file {}".format(version_number, version_file)
        )
    else:
        print(
            "Found commit {} matching version {}, checking out".format(
                target_diff.commit, version_number
            )
        )
        subprocess.check_output(["git", "checkout", target_diff.commit])


if __name__ == "__main__":
    checkout_version()
