

######################################################################

### ADD point outline to future HWs!

## For-credit 2018
## Regulation (uses some R, lives here, points to wiki)
regulation.asn.pdf: evaluation/regulation.ques
regulation.key.pdf: evaluation/regulation.ques
regulation.rub.pdf: evaluation/regulation.ques

## Pipelining with .R files
## 2019 Mar 10 (Sun)
regulation.qq: evaluation/regulation.RData
regulation.Rout: evaluation/regulation.R
	$(run-R)

Ignore += bd.R
evaluation/regulation.R: bd.R ;
bd.R:
	wget -O $@ "https://raw.githubusercontent.com/Bio3SS/Exponential_figures/master/bd.R" 

## Definitely want to be working on stepR pipelining!
regulation.key.pdf regulation.rub.pdf: regulation.Rout-0.pdf regulation.Rout-1.pdf regulation.Rout-2.pdf regulation.Rout-3.pdf regulation.Rout-4.pdf

## An allee question that has fallen between the cracks. Could be added to the previous or following assignment
## Previous assignment currently has a detailed Allee question, though.
allee.asn.pdf: evaluation/allee.ques

## Structure assignment
## For-credit 2018
structure.asn.pdf: evaluation/structure.ques
structure.key.pdf: evaluation/structure.ques
structure.rub.pdf: evaluation/structure.ques

######################################################################

## Interaction is an old assignment, now broken up into a very short (life history) assignment and a slightly longer (competition) assignment
## Now just misnamed life history (NFC 2018)
interaction.asn.pdf: evaluation/interaction.ques
interaction.key.pdf: evaluation/interaction.ques

## For-credit 2018
competition.asn.pdf: evaluation/competition.ques
competition.key.pdf: evaluation/competition.ques
competition.rub.pdf: evaluation/competition.ques

expl.asn.pdf: evaluation/expl.ques

######################################################################

## rmd pipelining (much to be done!)

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
## knitr 

## Pre-knit markup
Ignore += *.ques
%.ques: evaluation/%.ques lect/knit.fmt talk/lect.pl
	$(PUSH)

## Knit
Ignore += *.qq
knit = echo 'knitr::knit("$<", "$@")' | R --vanilla
%.qq: %.ques
	$(knit)

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

# -include $(ms)/newtalk.mk

-include $(ms)/hotcold.mk

# -include $(ms)/webpix.mk

## Using wrap because step doesn't (yet) understanding hiding ☹
