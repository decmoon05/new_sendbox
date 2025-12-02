#!/bin/bash
# 첫 번째 커밋 메시지를 영어로 변경하는 스크립트

# 첫 번째 커밋으로 이동하여 메시지 변경
git filter-branch -f --msg-filter '
if [ "$GIT_COMMIT" = "43885c0ce254f634447e9f5b0beaa43ed1de4aa4" ]; then
    echo "Initial commit: SendBox project redesign planning and architecture documentation"
else
    cat
fi' HEAD~1..HEAD

