NAME = solarnode-base
VERSION = 1.0.0-1

deb : 
	fpm -s dir -t deb \
	-n $(NAME) \
	-v $(VERSION) \
	-a all \
	-m 'packaging@solarnetwork.org.nz' \
	--vendor 'SolarNetwork Foundation' \
	--description 'SolarNode application' \
	--license 'GPL 2.0' \
	-f \
	-d 'systemd (>= 232)' \
	-d 'sn-system (>= 1.0.0)' \
	-d 'java8-runtime-headless' \
	--after-install $(NAME).postinst \
	etc lib usr var

clean : 
	rm $(NAME)_$(VERSION)_all.deb
