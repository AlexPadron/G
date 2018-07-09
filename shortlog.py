import os
import sys

if __name__ == '__main__':
    from_commit = sys.argv[1]
    rel_path = sys.argv[2] if len(sys.argv) > 2 else '.'
    to_commit = sys.argv[3] if len(sys.argv) > 3 else 'origin/master'
    os.system('git shortlog {}..{} {}'.format(from_commit, to_commit, rel_path))
