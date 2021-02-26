ARCH = all
NAME = solarnode-base
VERSION = 1.8.0-2

deb : 
	fpm -s dir -t deb \
	-n $(NAME) \
	-v $(VERSION) \
	-a $(ARCH) \
	-m 'packaging@solarnetwork.org.nz' \
	--vendor 'SolarNetwork Foundation' \
	--description 'SolarNode application' \
	--license 'GPL 2.0' \
	-f \
	-d 'systemd (>= 215)' \
	-d 'sn-system (>= 1.2.0)' \
	-d 'java8-runtime-headless' \
	--provides 'solarnode-framework' \
	--after-install $(NAME).postinst \
	--before-remove $(NAME).prerm \
	--after-remove $(NAME).postrm \
	--deb-no-default-config-files \
	etc lib usr var

clean : 
	rm $(NAME)_$(VERSION)_$(ARCH).deb
