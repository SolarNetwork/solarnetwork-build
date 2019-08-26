NAME = solarnode-app-protobuf
VERSION = 1.0.0-1

deb :
	fpm -s dir -t deb \
	-n $(NAME) \
	-v $(VERSION) \
	-a all \
	-m 'packaging@solarnetwork.org.nz' \
	--vendor 'SolarNetwork Foundation' \
	--description 'SolarNode application Protobuf support' \
	--license 'GPL 2.0' \
	-f \
	-d 'solarnode-base (>= 1.2.0)' \
	-d 'solarnode-app-core (>= 1.0.0)' \
	--after-install $(NAME).postinst \
	--after-remove $(NAME).postrm \
	usr var
	
clean : 
	rm $(NAME)_$(VERSION)_all.deb
