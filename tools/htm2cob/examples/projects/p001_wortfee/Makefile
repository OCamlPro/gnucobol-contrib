SUBDIRS_SAMPLES = css htm2cob html img img_wortfee js

.PHONY: all clean $(SUBDIRS_SAMPLES)

default: all

$(SUBDIRS_SAMPLES): 
	$(MAKE) -C $@ $(MAKECMDGOALS) $(SUBFLAGS)

all clean : $(SUBDIRS_SAMPLES)
