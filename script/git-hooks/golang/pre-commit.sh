#!/bin/sh

has_errors=0

# 获取git暂存的所有go代码
allgofiles=$(git diff --cached --name-only --diff-filter=ACM | grep '.go$' | grep -v 'vendor*' | grep -v '*.pb.go')

# 高版本兼容
declare -a gofiles
declare -a godirs
for allfile in ${allgofiles[@]}; do
    gofiles+=("$allfile")
    dir=$(dirname "$allfile")
    godirs+=("$dir")
done

godirs=$(echo "${godirs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')

[ -z "$gofiles" ] && exit 0

check_gofmt() {
    unformatted=$(gofmt -l ${gofiles[@]})
    if [ -n "$unformatted" ]; then
        echo >&2 "gofmt Fail:\n Run following command:"
        for f in ${unformatted[@]}; do
            echo >&2 " gofmt -w $PWD/$f"
        done
        echo "\n"
        has_errors=1
    fi
}

check_goimports() {
    if goimports >/dev/null 2>&1; then
        unimports=$(goimports -l ${gofiles[@]})
        if [  -n "$unimports" ]; then
            echo >&2 "goimports Fail:\nRun following command:"
            for f in ${unimports[@]};do
                echo >&2 " goimports -w $PWD/$f"
            done
            echo "\n"
            has_errors=1
        fi
    else
        echo 'Error: goimports not install. Run: "go install golang.org/x/tools/cmd/goimports@latest"' >&2
        exit 1
    fi
}

check_govet() {
    show_vet_header=true
    for dir in ${godirs[@]}; do
        vet=$(go vet $PWD/$dir 2>&1)
        if [ -n "$vet" -a $show_vet_header = true ]; then
            echo "govet Fail:"
            show_vet_header=false
        fi
        if [ -n "$vet" ]; then
            echo "$vet\n"
            has_errors=1
        fi
    done
}

check_gofmt
check_goimports
check_govet

exit $has_errors