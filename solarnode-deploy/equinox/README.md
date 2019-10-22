# SolarNode Platform (Equinox)

This directory contains the build script for generating the base SolarNode
Platform using the Equinox OSGi runtime. The build requires [Apache Ant][ant]
with JavaScript language [script][ant-script] support. To build Debian packages
with the provided make files, `make` and [fpm][fpm] are required. To install 
`fpm` on a Debian based system:

```sh
apt-get install ruby ruby-dev build-essential
gem install --no-ri --no-rdoc fpm
```

You might need to be `root` to do this.

## Configuration Setup

The build requires some configuration to run. Copy the `example/build.properties`
file into this directory first. Then you can modify the new copies (they will be
ignored by version control). You can also pass these settings via a `-D` argument
to the build.

## Ivy Configuration

The build script assembles all the various artifacts that make up the SolarNode
Platform using Apache Ivy. The build by default looks for a `ivy.xml` file to
configure which artifacts to include in the build. The standard configuration 
maintained currently is `example/ivy-aws.xml`. You can use that configuration in 
the build by passing a `-Divy.file=example/ivy-aws.xml` argument to the build.
If you need to customize the platform in any way, just copy one of the example Ivy
files to `ivy.xml` in this directory, and the build will use that. 

## Building

To build the platform, run the **deb-package-assemble** task:

```sh
# prepare debian package
ant -Divy.file=example/ivy-aws.xml \
	-Dlog.file=/run/solarnode/log/solarnode.log \
	clean deb-package-assemble

```

This will produce a package filesystem tree with a `Makefile` in `build/deb`.
To build the package, run `make`:

```sh
make -C build/deb
```

This will build the `build/deb/solarnode-base-X.deb` package.

### Building specialized platforms

Some other specialized configurations exist as well, in the `example` directory.
For example, to build a platform package with Apache CXF support, run:

```sh
# prepare debian package using ivy-cxf.xml
ant -Divy.file=example/ivy-cxf.xml \
	-Dlog.file=/run/solarnode/log/solarnode.log \
	clean deb-package-assemble

make -C build/deb -f Makefile-cxf
```

This will build the `build/deb/solarnode-cxf-X.deb` package.

### Building specialized platform apps

Use the `build-deb-app.xml` script to build specialized apps, for example:

```sh
ant -Divy.file=example/ivy-protobuf.xml \
	-Ddir.deb.base=deb-app/protobuf \
	-f build-deb-app.xml \
	clean deb-package-assemble

make -C build/deb
```

### Building legacy archive

To build the legacy style platform archive, use the **archive** task:

```sh
# or, prepare legacy archive
ant -Divy.file=example/ivy-aws.xml \
	-Dlog.file=/run/solarnode/log/solarnode.log \
	clean archive
```
	
This will produce a platform tarball at `build/base-equinox-node.tgz`.

## Upgrading nodes

To upgrade an existing node with a new platform version, follow the process
outlined [on the SolarNetwork wiki][upgrade].

 
[ant]: https://ant.apache.org/
[ant-script]: https://ant.apache.org/manual/Tasks/script.html
[fpm]: https://github.com/jordansissel/fpm
[upgrade]: https://github.com/SolarNetwork/solarnetwork/wiki/SolarNode-Manual-Platform-Update
 
