## A collection of links from the slides

This list is not meant to be complete.
Links have been extracted from the lecture and reorganized trying to follow the lecture order of topics.
Links to the Bash manual have been adjusted to point to the HTML version and, hence, to the correct section.
This might break in the future, though.
Links meant for future reference to go beyond the slides content.

### Table of content
  - [Overview](#overview)
  - [Quoting special characters](#quoting-special-characters)
  - [Variables](#variables)
  - [Special parameters](#special-parameters)
  - [Shell expansion](#shell-expansion)
  - [Globs](#globs)
  - [Conditionals](#conditionals)
  - [Colors cursor movements](#colors-cursor-movements)
  - [Input/Output](#inputoutput)
  - [Shell options](#shell-options)
  - [GNU\_Coreutils](#gnu_coreutils)
  - [File descriptors](#file-descriptors)
  - [Compound commands](#compound-commands)
  - [Functions](#functions)
  - [Autocompletion](#autocompletion)
  - [GNU Readline](#gnu-readline)
  - [Asynchronous commands](#asynchronous-commands)
  - [Error handling](#error-handling)
  - [Sed](#sed)
  - [Awk](#awk)
  - [Good practices](#good-practices)
  - [Useful tools](#useful-tools)
  - [Bash in real life](#bash-in-real-life)
  - [Disclaimer](#disclaimer)

---

#### Overview

  - [Bash](https://www.gnu.org/software/bash/)
  - [Bash logo](https://commons.wikimedia.org/w/index.php?curid=53428398)
  - [Download Bash](http://ftp.gnu.org/gnu/bash/)
  - [Bash weaknesses](http://mywiki.wooledge.org/BashWeaknesses)
  - [Change default shell on macOS](https://www.cyberciti.biz/faq/change-default-shell-to-bash-on-macos-catalina/)
  - [Bash official manual](https://www.gnu.org/software/bash/manual/)
  - [List of Bash builtins with descriptions](http://manpages.ubuntu.com/manpages/bionic/man7/bash-builtins.7.html)
  - [Notable changes in released Bash versions](http://mywiki.wooledge.org/BashFAQ/061)
  - [More detailed list of changes in Bash versions](https://bash-hackers.gabe565.com/scripting/bashchanges/)
  - [A nice Bash cheat-sheet](https://devhints.io/bash)
  - [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
  - [A (sadly not maintained) Bash library](https://github.com/mietek/bashmenot)
  - [An online help to get relevant manual pages of a given command](https://explainshell.com/)
  - [Bash Beginners Guide](http://tldp.org/LDP/Bash-Beginners-Guide/html/)
  - [Shell scripting tutorial](https://www.shellscript.sh/)
  - [Bash Guide a.k.a. Greg's Wiki](http://mywiki.wooledge.org/BashGuide)
  - [«Clean code» and «Clean testing»](https://github.com/AxelKrypton/Clean-code-good-practices)

#### Quoting special characters

  - [Localization support](http://mywiki.wooledge.org/BashFAQ/098)
  - [Quotes](http://mywiki.wooledge.org/Quotes)
  - [History expansion](https://www.gnu.org/software/bash/manual/html_node/History-Interaction.html\#History-Interaction)
  - [Advanced reading: `$(...)` versus <code>\`...\`</code>](http://mywiki.wooledge.org/BashFAQ/082)
  - [Advanced reading: difference between `test`, `[` and `[[`](http://mywiki.wooledge.org/BashFAQ/031)
  - [Obsolete and deprecated syntax](https://bash-hackers.gabe565.com/scripting/obsolete/)

#### Variables

  - [Shell variables](https://www.gnu.org/software/bash/manual/html_node/Shell-Variables.html)
  - [`set -u`](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
  - [When and why not to use a custom IFS](http://mywiki.wooledge.org/Arguments)

#### Special parameters

  - [Bash manual](https://www.gnu.org/software/bash/manual/bash.html#Special-Parameters)

#### Shell expansion

  - [Shell expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html)
  - [Parameter expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
  - [Command substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html)
  - [Process substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html)
  - [Shell arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html)
  - [The directory stack](https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html)
  - [Bash in POSIX Mode (item 30)](https://www.gnu.org/software/bash/manual/html_node/Bash-POSIX-Mode.html)

#### Globs

  - [`set -f`](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
  - [Character classes](http://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm)

#### Conditionals

  - [Bash reference](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)
  - [POSIX standard](http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap09.html)
  - [The Premier website about Regular Expressions](https://www.regular-expressions.info/posix.html)

#### Colors cursor movements

  - [A good reference](https://misc.flogisoft.com/bash/tip_colors_and_formatting)
  - [Compatibility list](https://misc.flogisoft.com/bash/tip_colors_and_formatting\#terminals_compatibility)
  - [few more styles](https://askubuntu.com/a/985386)
  - [Starting point](https://stackoverflow.com/a/20983251)

#### Input/Output

  - [Read more about `LANGUAGE`](https://askubuntu.com/a/544728)

#### Shell options

  - [`set`](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
  - [`shopt`](hhttps://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html)
  - [Which bash shell options are used by the parser?](https://unix.stackexchange.com/q/573589/370049)

#### GNU_Coreutils

  - [GNU coreutils manual](https://www.gnu.org/software/coreutils/manual/coreutils.pdf)
  - [Decoded: GNU coreutils](http://www.maizure.org/projects/decoded-gnu-coreutils/)
  - [Cheat-sheet](https://catonmat.net/ftp/gnu-coreutils-cheat-sheet.pdf)
  - [util-linux on GitHub](https://github.com/karelzak/util-linux)
  - [util-linux on Wikipedia](https://en.wikipedia.org/wiki/Util-linux)
  - [An issue about `column`](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=961301)

#### File descriptors

  - [Close FD open for read/write](https://unix.stackexchange.com/questions/131801/closing-a-file-descriptor-vs\#comment615492_131833)
  - [Pipes must have a reader and a writer](https://stackoverflow.com/a/19120674)
  - [The full story about process substitution not being waited for](https://unix.stackexchange.com/questions/403783/the-process-substitution-output-is-out-of-the-order)

#### Compound commands

  - [Advanced reading](http://mywiki.wooledge.org/BashFAQ/024)

#### Functions

  - [Exploring allowed names](https://stackoverflow.com/a/44041384)
  - [Solid way to create temporary files](http://mywiki.wooledge.org/BashFAQ/062)
  - [Very informative article](http://mywiki.wooledge.org/BashFAQ/048)

#### Autocompletion

  - [Programmable completion](https://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion-Builtins)
  - [Bash variables](https://www.gnu.org/software/bash/manual/bash.html#Bash-Variables)

#### GNU Readline

  - [Official website](https://tiswww.case.edu/php/chet/readline/rltop.html)
  - [Bash reference](https://www.gnu.org/software/bash/manual/bash.html#Command-Line-Editing)

#### Asynchronous commands

  - [Job control](https://www.gnu.org/software/bash/manual/bash.html#Job-Control)
  - [Process management](http://mywiki.wooledge.org/ProcessManagement)

#### Error handling

  - [Greg's Wiki about `set -e`](http://mywiki.wooledge.org/BashFAQ/105)
  - [David Pashley about `set -e`](https://www.davidpashley.com/articles/writing-robust-shell-scripts/)
  - [Simple Command Expansion](https://www.gnu.org/software/bash/manual/bash.html#Simple-Command-Expansion)
  - [About `set -u` in older Bash versions](https://gist.github.com/dimo414/2fb052d230654cc0c25e9e41a9651ebe)
  - [Read more about `set -u`](http://mywiki.wooledge.org/BashFAQ/112)
  - [Minor drawbacks of `set -o pipefail`](http://mywiki.wooledge.org/BashPitfalls\#pipefail)

#### Sed

  - [Tetris](https://github.com/uuner/sedtris)
  - [The official GNU manual](https://www.gnu.org/software/sed/manual)
  - [A very nice tutorial](http://www.grymoire.com/Unix/Sed.html)
  - [One-liners, with some comments](http://sed.sourceforge.net/sed1line.txt)
  - [More one-liners, explained but advanced!](https://catonmat.net/sed-one-liners-explained-part-one)
  - [Basic Regular Expression (BRE)](https://www.gnu.org/software/sed/manual/sed.html\#BRE-syntax)
  - [Extended Regular Expression (ERE)](https://www.gnu.org/software/sed/manual/sed.html\#ERE-syntax)

#### Awk

  - [The official GNU manual](https://www.gnu.org/software/gawk/manual/)
  - [A base tutorial](http://www.grymoire.com/Unix/Awk.html)
  - [String and numbers as variables](https://www.gnu.org/software/gawk/manual/gawk.html\#Strings-And-Numbers)

#### Good practices

  - [Bash manual section 3.5.4](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html)
  - [Bash Pitfalls](http://mywiki.wooledge.org/BashPitfalls)
  - [Clean code good practices](https://github.com/AxelKrypton/Clean-code-good-practices)
  - [Download Bash](https://ftp.gnu.org/gnu/bash/)
  - [Instructive and very encouraged reading](http://mywiki.wooledge.org/ParsingLs)
  - [Obsolete and deprecated syntax](https://bash-hackers.gabe565.com/scripting/obsolete/)
  - [Shell Hall of Shame](http://mywiki.wooledge.org/ShellHallOfShame)

#### Useful tools

  - [Shell unit test framework](https://github.com/kward/shunit2)
  - [Clean testing](https://github.com/AxelKrypton/Clean-code-good-practices)
  - [ShellCheck](https://github.com/koalaman/shellcheck)
  - [Use ShellCheck it online](https://www.shellcheck.net)
  - [ShellCheck Wiki example](https://github.com/koalaman/shellcheck/wiki/SC1000)
  - [`yq`](https://mikefarah.gitbook.io/yq)
  - [`jq`](https://jqlang.org)

#### Bash in real life

  - [`BaHaMAS`](https://github.com/AG-Philipsen/BaHaMAS)
  - [GitHooks](https://github.com/AxelKrypton/GitHooks)
  - [A Bash Logger](https://github.com/AxelKrypton/BashLogger)
  - [`SMASH-vHLLE-Hybrid`](https://smash-transport.github.io/smash-vhlle-hybrid/develop/)


---

#### Disclaimer

This collection was extracted from the ***TeX/Slides*** folder using a admittedly horrendous pipeline, which is reported here below.
The output was then edited by hand.

```bash
grep -rno '\\URL[^{]*{[^}]*}{[^}]*}' . |\
awk '
  BEGIN{FS=":"; OFS=":"}
  {
    texfile=$1;
    texfile=gensub(/^[.]\/(.*)[.]tex$/, "\\1", "g", texfile);
    printf "%40s   %s\n", texfile, substr($0, index($0,$3))
  }' |\
awk '
  {
    if($1 != section)
    {
      printf "#### %s\n", $1
    };
    section=$1
  }
  {
    $1="";
    printf "  - %s\n", $0
  }' |\
awk '
  BEGIN{FS="[{}]"}
  $1 ~ /^1/ {print "\n"$0"\n"; next}
  $1 ~ /URL/ {url=$2; printf "  - [%s](%s)\n", substr($0,index($0,$4)), url}' |\
sed 's/}]/]/' | less -r
```