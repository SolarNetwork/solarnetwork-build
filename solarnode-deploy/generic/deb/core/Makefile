NAME = solarnode-app-core
VERSION = 1.0.0-2

deb : 
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
	var

clean : 
	rm $(NAME)_$(VERSION)_all.deb
