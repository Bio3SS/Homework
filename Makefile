## This is Homework, a screens project directory

current: target
-include target.mk

include makestuff/perl.def

######################################################################

## 2019 Mar 10 (Sun) DEPRECATE all working subdirectories; use source!
## If kids can do it, we can do it
## Also: working on stepR local pipelines

# Content

vim_session:
	bash -cl "vmt"

######################################################################

## Actively cribbing; delete when empty
Sources += content.mk

pardirs += evaluation
pushdir = ../web/materials

######################################################################

## Assignments

Ignore += *.asn.* *.key.* *.rub.*

## Intro (NFC)
intro.asn.pdf: evaluation/intro.ques
intro.key.pdf: evaluation/intro.ques

## Population growth
## For-credit 2018, 2019
pg.asn.pdf: evaluation/pg.ques
pg.key.pdf: evaluation/pg.ques
pg.rub.pdf: evaluation/pg.ques

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
%.qq: %.ques
	$(knit)

##################################################################

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

-include makestuff/git.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
-include makestuff/wrapR.mk
-include makestuff/texdeps.mk
-include makestuff/pandoc.mk
