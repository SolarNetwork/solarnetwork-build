# SolarNode Application

This directory contains the build script for generating the base SolarNode
Application. The build requires [Apache Ant][ant]. To build Debian packages
with the provided make files, `make` and [fpm][fpm] are required. To install 
`fpm` on a Debian based system:

```sh
apt-get install ruby ruby-dev build-essential
gem install --no-ri --no-rdoc fpm
```

You might need to be `root` to do this.

## Ivy Configuration

The build script assembles all the various artifacts that make up the SolarNode
Application using Apache Ivy. The build by default looks for a `ivy.xml` file to
configure which artifacts to include in the build. The standard configuration 
maintained currently is `example/ivy-deb.xml`. You can use that configuration in 
the build by passing a `-Divy.file=example/ivy-deb.xml` argument to the build.
If you need to customize the application in any way, just copy one of the example Ivy
files to `ivy.xml` in this directory, and the build will use that. 

## Building

To build the platform, run the **deb-package-assemble** task:

```sh
# prepare debian package
ant -Divy.file=example/ivy-deb.xml \
	clean deb-package-assemble

```

This will produce a package filesystem tree with a `Makefile` in `build/deb`.
To build the package, run `make`:

```sh
make -C build/deb
```

This will build the `build/deb/solarnode-app-core-X.deb` package.

### Building specialized platforms

Some other specialized configurations exist as well, in the `example` directory.
For example, to build a platform package with OCPP support, run:

```sh
# prepare debian package using ivy-ocpp-deb.xml
ant -Divy.file=example/ivy-ocpp-deb.xml \
	-Ddir.deb.base=deb/ocpp \
	clean deb-package-assemble

make -C build/deb
```

This will build the `build/deb/solarnode-ocpp-X.deb` package.

### Building legacy archive

To build the legacy style platform archive, use the **archive** task, with
the `example/ivy.xml` Ivy configuration:

```sh
# or, prepare legacy archive
ant -Divy.file=example/ivy.xml \
	clean archive
```
	
This will produce an application tarball at `build/node-bundles.tgz`.

You can maintain multiple packages by creating other Ivy XML files. For example
to maintain a package with all the bundles required you could create a 
**ivy-mycompany.xml** file and then run the build like this:

	ant -Divy.file=ivy-mycompany.xml clean archive

## Upgrading nodes

To upgrade an existing node with a new application version, [follow the process
outlined on the SolarNetwork wiki][upgrade].

 
[ant]: https://ant.apache.org/
[fpm]: https://github.com/jordansissel/fpm
[upgrade]: https://github.com/SolarNetwork/solarnetwork/wiki/SolarNode-Manual-Platform-Update
 
