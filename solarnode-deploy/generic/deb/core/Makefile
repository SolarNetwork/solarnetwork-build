NAME = solarnode-app-core
VERSION = 1.12.0-1
PATHS = var

deb : prep
	fpm -s dir -t deb \
	-n $(NAME) \
	-v $(VERSION) \
	-a all \
	-m 'packaging@solarnetwork.org.nz' \
	--vendor 'SolarNetwork Foundation' \
	--description 'SolarNode application core' \
	--license 'GPL 2.0' \
	-f \
	-d 'solarnode-framework' \
	-d 'sn-solarssh (>= 1.0.0)' \
	--after-install $(NAME).postinst \
	$(PATHS)

prep : 
	find $(PATHS) -type f -name .DS_Store -delete

clean : 
	rm $(NAME)_$(VERSION)_all.deb
