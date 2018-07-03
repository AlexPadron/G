import os
import subprocess
import sys

output = subprocess.check_output(['arc', 'which']).decode('utf-8')

found_included_commits = False
all_commit_hashes = []

for line in output.split('\n'):
    # [arc which] prints a lot of blank lines
    if len(line) == 0:
        continue

    # This line prefixes a set of nicely ordered lines such as
    #
    # 0dfe4ff5910d3570  z
    # dae0c360c9cdb46b  Docstore: Fix version checking in docstore interface commit
    # c03aff22f2568757  z
    # cb95aa1620b6dd48  z
    #
    # Once we have found a line of this form we can read in all the git diffs
    # associated with this arc diff
    if 'These commits will be included in the diff:' in line:
        found_included_commits = True
        continue

    if not found_included_commits:
        continue

    # This line comes immediately after the list of diffs, so if we see it we
    # know we have read every diff
    if 'MATCHING REVISIONS' in line:
        break

    if 'No commits' in line:
        print('No commits for current diff')
        exit(0)

    # Using this assumption that only diffs that get pushed with [arc diff]
    # have a commit message that is not [z]
    if line.endswith('  z'):
        continue

    # Hash is the first element of the line
    commit_hash = list(filter(lambda x: len(x) > 0, line.split(' ')))[0]
    all_commit_hashes.append(commit_hash)

if len(all_commit_hashes) == 0:
    print('Oh no! unable to locate previous hash!')
    exit(1)
else:
    # Check cli for status command
    status = len(sys.argv) > 1 and sys.argv[1] == 'status'

    if status:
        diff_command = 'git diff --stat {}'
    else:
        diff_command = 'git diff {}'

    # Commit hashes are ordered so the first is the most recent
    os.system(diff_command.format(all_commit_hashes[0]))
    exit(0)
