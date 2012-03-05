#! /usr/bin/make --no-print-directory -f

RUBYINC ?= $(LIBDIR)/ruby/$(RUBYLIBVER)/$(RUBYPLATFORM)
RUBYINSTALL ?= $(LIBDIR)/ruby/site_ruby/$(RUBYLIBVER)/$(RUBYPLATFORM)

## Default target
RUBY_VERSIONS := ruby1.8
all: $(RUBY_VERSIONS)

## Targets share the same output files, so must be run serially
.NOTPARALLEL:
.PHONY: all $(RUBY_VERSIONS)

## Helper variables
RUBY_PLATFORM = $(shell $@ -e 'print RUBY_PLATFORM')
RUBY_ARCHLIB        = /usr/lib/ruby/$*/$(RUBY_PLATFORM)
RUBY_VENDOR_ARCHLIB = /usr/lib/ruby/vendor_ruby/$*/$(RUBY_PLATFORM)

## SELinux does not have a very nice build process
extra_ruby_args  = RUBYLIBVER=$*
extra_ruby_args += RUBYPLATFORM=$(RUBY_PLATFORM)
extra_ruby_args += RUBYINC=$(RUBY_ARCHLIB)
extra_ruby_args += RUBYINSTALL=$(DESTDIR)$(RUBY_VENDOR_ARCHLIB)

## How to build and install each individually-versioned copy
$(RUBY_VERSIONS): ruby%:
	+$(MAKE) $(extra_ruby_args) clean-rubywrap
	+$(MAKE) $(extra_ruby_args) install-rubywrap
