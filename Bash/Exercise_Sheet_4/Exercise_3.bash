#!/usr/bin/env bash

# Use logger
source ../Exercise_Sheet_3/Exercise_4.bash || exit 2

echo
PrintInfo 'Which snippet would you like to run?'
select snippet in Snippet_{1..5}; do
    if [[ ${snippet#*_} =~ ^[1-5]$ ]]; then
        snippet=${snippet#*_}
        break
    fi
done

echo
case "${snippet}" in
    1)
        PrintInfo 'The difference between the two lines is that in the second we have a whole'\
                  'compound command and the && affects the behaviour in the first subshell!'\
                  'Hence the output is:'
        ( set -e; ( echo 11; false; echo 22 ); echo 33 ); echo 44
        ( set -e; ( echo 55; false; echo 66 ) ; echo 77 ) && echo 88
        ;;

    2)
        PrintInfo 'The function F1 runs in a subshell and enables errexit. Hence the call to'\
                  'F2 makes the subshell exit and F3 is not called. However, calling F1 as part'\
                  'of a || list makes the function F1 be executed in a context where errexit'\
                  'has to be ignored and hence F3 gets called. The output is then:'
        function F1 () ( set -e; F2; F3 ) # Subshell!
        function F2 () { echo 'In F2'; false; }
        function F3 () { echo 'In F3'; false; }
        echo 'Call: F1 '
        F1
        echo 'Call: F1 || false '
        F1 || false
        ;;

    3)
        PrintInfo 'The failing test (the directory does not exist) returns a non zero exit code,'\
                  'but is done as "part of any command executed in a && or || list except the'\
                  'command following the final && or ||" (Bash man page), so it does not cause'\
                  'the shell to exit. The output is then:'
        set -e
        [[ -d notExistingDir ]] && echo 'Dir found'
        echo 'Survived'
        ;;

    4)
        PrintInfo 'In this script, it is also true that the failing test is executed as part of'\
                  'a && list, so the shell does not exit immediately after the  [[ ... ]] && command.'\
                  'However, the function F1 returns 1 (failure) because that was the exit status of'\
                  'the last command executed in the function. The simple command F1 in the main body'\
                  'of the script therefore returns 1 (failure), which causes the shell to exit.'\
                  'Hence the "Survived" string does not get printed to the screen.'
        set -e
        function F1 () { [[ -d notExistingDir ]] && echo 'Dir found'; }
        F1
        echo 'Survived'
        ;;

    5)
        PrintInfo 'In this script, we observe one of the ways in which if and && are not the same.'\
                  'In the Bash manual, under Compound Commands, we find this sentence in the definition'\
                  'of if: "The exit status is the exit status of the last command executed, or zero'\
                  'if no condition tested true." Since the test is not true, and no commands are executed'\
                  'in the F1 function, if must return 0. This means that F1 returns 0 (as last executed'\
                  'command) and the shell does not exit. The output is then:'
        set -e
        function F1 () { if [[ -d notExistingDir ]]; then echo 'Dir found'; fi; }
        F1
        echo 'Survived'
        ;;
esac
