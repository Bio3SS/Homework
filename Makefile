## This is Homework, a screens project directory
## Rules and products here. evaluation/ is only for the secret files (current answers, I guess)

current: target
-include target.mk

-include makestuff/perl.def

######################################################################

# Content

vim_session:
	bash -cl "vmt"

######################################################################

pardirs += evaluation Life_tables
pushdir = ../web/materials

alldirs += $(pardirs)
hotdirs += $(pardirs)

Ignore += $(pardirs)

######################################################################

## Assignments

Ignore += *.asn.* *.key.* *.rub.*

## Intro (NFC)
intro.asn.pdf: evaluation/intro.ques
intro.key.pdf: evaluation/intro.ques

## Population growth
## For-credit 2018, 2019, 2020, 2021
pg.asn.pdf: evaluation/pg.ques
pg.key.pdf: evaluation/pg.ques
pg.rub.pdf: evaluation/pg.ques

## NFC 2020
## FC 2024
life_history.asn.pdf: evaluation/life_history.ques
life_history.key.pdf: evaluation/life_history.ques

## For-credit 2020; 2021
## Documentation stuff lives in the web directory
competition.asn.pdf: evaluation/competition.ques
competition.key.pdf: evaluation/competition.ques
competition.rub.pdf: evaluation/competition.ques

## For-credit 2022, may be a bit rough after its vacation
expl.asn.pdf: evaluation/expl.ques
expl.key.pdf: evaluation/expl.ques

expl_figures.Rout: evaluation/expl_figures.R
	$(pipeR)

######################################################################

evaluation/comp_figures.Rout.pdf:

evaluation/%.pdf: $(wildcard evaluation/*.R)
	$(justmakethere)

######################################################################

## Main lect.pl products
Sources += asn.tmp copy.tex

%.ques.fmt: lect/ques.format lect/fmt.pl
	$(PUSHSTAR)

%.asn.tex: %.qq asn.tmp asn.ques.fmt talk/lect.pl
	$(PUSH)

%.key.tex: %.qq asn.tmp key.ques.fmt talk/lect.pl
	$(PUSH)

%.rub.tex: %.qq asn.tmp rub.ques.fmt talk/lect.pl
	$(PUSH)

##################################################################

## qq pipeline
## Pre-knit markup
Ignore += *.ques
%.ques: evaluation/%.ques lect/knit.fmt talk/lect.pl
	$(PUSH)

## Knit
Ignore += *.qq
knit = echo 'knitr::knit("$<", "$@")' | R --vanilla
.PRECIOUS: %.qq
%.qq: %.ques
	$(knit)

##################################################################

## What if we make and export html?? Stand-alone?

## rmd pipelining (much to be done!)

# r.rmdout: r.rmd

rmd = $(wildcard *.rmd)
Ignore += *.yaml.md *.rmd.md *.export.md
Sources += $(rmd)
Ignore += *.export.* *_files/

## Direct translation
%.rmd.md: %.rmd
	Rscript -e 'library("rmarkdown"); render("$<", output_format="md_document", output_file="$@")'

## Add headers
%.yaml.md: %.rmd Makefile
	perl -nE "last if /^$$/; print; END{say}" $< > $@

%.export.md: %.yaml.md %.rmd.md
	$(cat)

%.rmdout: %.export.md
	- $(RMR) $(pushdir)/$*.rmd_files
	$(CP) -r $< $(pushdir)
	- $(CP) -r $< $*.rmd_files $(pushdir)

shiprmd = $(rmd:rmd=rmdout)
shiprmd: $(shiprmd)
## bd.rmdout: bd.rmd

######################################################################

### Some misunderstood messiness here 2020 Feb 14 (Fri)

### ADD point outline to future HWs!

######################################################################

## Regulation (uses some R, lives here, points to wiki)
## For-credit 2018, 2020 maybe other times, 2024
regulation.asn.pdf: evaluation/regulation.ques
regulation.key.pdf: evaluation/regulation.ques
regulation.rub.pdf: evaluation/regulation.ques

## Pipelining with .R files
## 2019 Mar 10 (Sun)
regulation.qq: evaluation/regulation.rda

Ignore += bd.R

## There is some weird spinny makiness going on here.
## regulation.key.pdf regulation.rub.pdf: regulation.Rout-0.pdf regulation.Rout-1.pdf regulation.Rout-2.pdf regulation.Rout-3.pdf regulation.Rout-4.pdf

######################################################################

## An allee question that has fallen between the cracks. Could be added to the previous or following assignment
## Previous assignment currently has a detailed Allee question, though.
allee.asn.pdf: evaluation/allee.ques

## Structure assignment
## For-credit 2018; this depends on the long version of the unit
## 2021; the Euler equation part is suppressed
structure.asn.pdf: evaluation/structure.ques
structure.key.pdf: evaluation/structure.ques
structure.rub.pdf: evaluation/structure.ques

## lect and talk resources

Ignore += lect
.PRECIOUS: lect/%
lect/%: 
	$(MAKE) lect

lect: dir=makestuff
lect:
	$(linkdir)

Ignore += talk
.PRECIOUS: talk/%
talk/%: 
	$(MAKE) talk

talk: dir=makestuff/newtalk
talk:
	$(linkdirname)

######################################################################

### Makestuff

Sources += Makefile README.md

## include content.mk

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk

## Seems ancient, do we use it?
## -include makestuff/projdir.mk
-include makestuff/pipeR.mk
-include makestuff/texi.mk
-include makestuff/pandoc.mk
-include makestuff/hotcold.mk
-include makestuff/pdfpages.mk

-include makestuff/git.mk
-include makestuff/visual.mk
