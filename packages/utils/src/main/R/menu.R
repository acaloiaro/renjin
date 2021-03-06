#  File src/library/utils/R/menu.R
#  Part of the R package, http://www.R-project.org
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  A copy of the GNU General Public License is available at
#  http://www.r-project.org/Licenses/

menu <- function(choices, graphics = FALSE, title = NULL)
{
    if(!interactive()) stop("menu() cannot be used non-interactively")
    if(isTRUE(graphics)) {
        if(.Platform$OS.type == "windows" || .Platform$GUI == "AQUA"
           ## Tk might not require X11 on Mac OS X, but if DISPLAY is set
           ## this will work for Aqua Tcl/Tk.
           ## OTOH, we do want to check Tk works!
           || (capabilities("tcltk") && capabilities("X11") &&
               suppressWarnings(tcltk:::.TkUp))) {
            res <- select.list(choices, multiple = FALSE, title = title,
                               graphics = TRUE)
            return(match(res, choices, nomatch = 0L))
        }
    }
    nc <- length(choices)
    if(length(title) && nzchar(title[1L])) cat(title[1L], "\n")
    op <- paste(format(seq_len(nc)), ": ", choices, sep="")
    if(nc > 10L) {
        fop <- format(op)
        nw <- nchar(fop[1L], "w") + 2
        ncol <- getOption("width") %/% nw  # might be 0
        if(ncol > 1L)
            op <- paste(fop, c(rep("  ", ncol - 1), "\n"), sep="", collapse="")
        cat("", op, "", sep="\n")
    } else cat("", op, "", sep="\n")
    repeat {
	ind <- .Internal(menu(as.character(choices)))
	if(ind <= nc) return(ind)
	cat(gettext("Enter an item from the menu, or 0 to exit\n"))
    }
}
