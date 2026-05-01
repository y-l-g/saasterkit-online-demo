git remote add upstream https://github.com/y-l-g/saasterkit


git fetch origin
git fetch upstream

git branch backup/pre-upstream-rebase-2026-05-01 origin/main

git rebase upstream/main

git push --force-with-lease origin main

git rev-list --left-right --count upstream/main...main

git remote -v

composer test
npm run build
