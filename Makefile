TRANSPECT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

ifeq ($(shell uname -o),Cygwin)
win_path = $(shell cygpath -ma "$(1)")
uri = $(shell echo file:///$(call win_path,$(1))  | sed -r 's/ /%20/g')
else
ifeq ($(shell uname -o),Msys)
win_path = $(shell readlink -m "$(1)")
uri = file:///$(shell echo $(shell cd $(dir $(1)) && pwd -W)/$(notdir $(1)) | sed -r 's/ /%20/g')
else
win_path = $(shell readlink -m "$(1)")
uri = $(shell echo $(abspath $(1))  | sed -r 's/ /%20/g')
endif
endif

out_replace = $(shell echo $(1) | sed -r 's/\/(idml|xml)\/([^.]+)(\.indb)?\.[a-z]+$$/\/$(2)\/\2.$(3)/')

# Modified Cygwin/Windows-Java-compatible input file path:
out_path = $(call win_path,$(call out_replace,$(1),$(2),$(3)))

UMASK = umask 002
HEAP = 2048m
CODE := $(TRANSPECT_DIR)
CONF = $(CODE)/conf/transpect-conf.xml
CALABASH = $(CODE)/calabash/calabash.sh
MAKE_CALL = make -f $(CODE)/Makefile --no-print-directory
DEBUG = yes
DEBUG_DIR_URI  = $(call uri,$(call out_path,$(IN_FILE),debug,debug))
IDML = $(call uri,$(call out_path,$(IN_FILE),idml,idml))
IDML_TEMPLATE = $(call win_path,$(basename $(IN_FILE)).tmp)
HTML = $(call win_path,$(basename $(IN_FILE)).xhtml)

check_input:
ifeq ($(IN_FILE),)
	@echo Please specifiy IN_FILE
	@exit 1
endif

conversion: check_input
ifeq ($(suffix $(IN_FILE)),.xml)
	$(MAKE_CALL) omni2idml
endif

omni2idml:
	$(UMASK); $(CALABASH) -D \
		-i source=$(call win_path,$(IN_FILE)) \
		-i conf=$(call uri,$(CONF)) \
		-o html=$(HTML) \
		$(call uri,$(CODE)/a9s/common/xpl/omnibook2idml.xpl) \
		idml-target-uri=$(IDML) \
		idml-template-expanded-uri=$(IDML_TEMPLATE) \
		debug-dir-uri=$(DEBUG_DIR_URI) \
		debug=$(DEBUG) 
	rm -rf $(call win_path,template.idml.tmp)
