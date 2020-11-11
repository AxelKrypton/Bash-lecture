# The source of all material

Around 10,000 lines of LaTeX code have been written to prepare the material of this lecture.
Files have been structured in a way that different days might be as consistent in notation as possible.

* The [`beamer`](https://www.ctan.org/pkg/beamer) class has been used for the slides.
* The [`tikz`](https://www.ctan.org/pkg/pgf) package has been used everywhere, who doesn't?! :smirk:
* The [`listings`](https://ctan.org/pkg/listings) package has been used to typeset Bash code.
* The [`lstautogobble`](https://www.ctan.org/pkg/lstaddons) addon of the `listing` package turned out to be very useful!
* The [`fontspec`](https://www.ctan.org/pkg/fontspec) package was used to set the main font to the [Yanone Kaffeesatz](https://www.yanone.de/fonts/kaffeesatz/).

If you would like to compile any of the main files, you should use `xelatex` as compiler and be sure the used font is available on your machine.
