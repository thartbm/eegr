# library(gWidgets2)
options(guiToolkit='tcltk') # comes with base R, so should always work?
eegrWindow <- gwindow(title = "eegr")

# there need to be:

# 1) A menu bar on top
# 2) A GUI area in the middle
# 3) A status bar on the bottom

# Can't be rescaled by the user: menu + status bar leave most room for the GUI area

mainvbox <- ggroup(horizontal=FALSE, container = eegrWindow)

menulist <- list()
menulist[['Project']] <- list('New Project...', 'Open Project...')
menulist[['Dataset']] <- list('Import...', 'Merge...')

menubar <- gmenu(menu.list=menulist, container=eegrWindow)
GUIarea <- ggroup(horizontal=TRUE, container=mainvbox)
statusbar <- gstatusbar(text='eegr', container=eegrWindow)

# The GUI area consists of 3 parts:

# 1) a tree area on the left that displays the data structure of the current project
# 2) an info / action area, dynamically filled and related to the selected node in the data tree
# 3) A ggraphicsnotebook with plots (and some way to store them as PDF / SVG / PNG / ...)

# perhaps these should be two gpanedgroup s, as those seem to be the only ones allowing handles/sashes for resizing

GUItreeDivider <- gpanedgroup(container=mainvbox)

offspring <- function(path=character(0), lst, ...) {
  if(length(path))
    obj <- lst[[path]]
  else
    obj <- lst
  nms <- names(obj)
  hasOffspring <- sapply(nms, function(i) {
    newobj <- obj[[i]]
    is.recursive(newobj) && !is.null(names(newobj))
  })
  data.frame(comps=nms, hasOffspring=hasOffspring, ## fred=nms,
             stringsAsFactors=FALSE)
}
l <- list('[empty]'='0') # this list will have to be generated dynamically when loading / editing a project

ProjectTree <- gtree(container=GUItreeDivider, offspring=offspring, offspring.data=l)

GUIviewDivider <- gpanedgroup(container=GUItreeDivider)

actionView <- ggroup(container = GUIviewDivider)

dataView <- ggraphicsnotebook(container = GUIviewDivider)



# now we show it:

visible(eegrWindow) <- TRUE
