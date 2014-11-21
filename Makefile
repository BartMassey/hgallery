# Copyright © 2014 Bart Massey

# This work is made available under the "GNU AGPL v3", as
# specified the terms in the file COPYING in this
# distribution.

CORE = Dispatch.hs Foundation.hs HGallery.hs
HANDLERS = Handler/Home.hs Handler/Stats.hs Handler/Raw.hs
TEMPLATES = templates/default-layout-wrapper.hamlet \
            templates/default-layout.hamlet \
            templates/default-layout.cassius \
	    templates/stats.hamlet templates/home.hamlet
CONFIGS = config/routes

HGallery: $(CORE) $(HANDLERS) $(TEMPLATES) $(CONFIGS)
	$(MAKE) $(MFLAGS) clean
	ghc -Wall --make HGallery.hs

clean:
	sh ./hsclean.sh *.hs Handler/*.hs
