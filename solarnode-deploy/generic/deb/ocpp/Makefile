NAME = solarnode-app-ocpp
VERSION = 1.0.0-1

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
	-d 'solarnode-app-core (>= 1.0.0)' \
	var

clean : 
	rm $(NAME)_$(VERSION)_all.deb
