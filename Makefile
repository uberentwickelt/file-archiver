SHELL := bash

reminder = printf "\nDon't forget to add the appropriate crontab entry(s). For more information look at crontab.*.txt\n\n"
VAR_ALL := 0

.PHONY: all
all: downloads screenshots

.PHONY: required_dirs
required_dirs: ## Sets up the required directory structure in home
	mkdir -p ${HOME}/.local/{bin,log};

.PHONY: downloads
downloads: required_dirs ## Installs the downloads archive script
	cp $(CURDIR)/.local/bin/archive_downloads.sh ${HOME}/.local/bin/;
	chmod 0700 ${HOME}/.local/bin/archive_downloads.sh
	@$(call reminder)

.PHONY: screenshots
screenshots: required_dirs ## Installs the screenshots archive script
	cp $(CURDIR)/.local/bin/archive_screenshots.sh ${HOME}/.local/bin/;
	chmod 0700 ${HOME}/.local/bin/archive_screenshots.sh
ifneq ($(VAR_ALL), 1)
	@$(call reminder)
endif
