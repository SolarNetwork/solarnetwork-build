# SolarNode Platform (Equinox)

This directory contains the build script for generating the base SolarNode
Platform using the Equinox OSGi runtime. The build requires [Apache Ant][ant]
with JavaScript language [script][ant-script] support.

## Configuration Setup

The build requires some configuration to run. Copy the `example/build.properties`
and `example/ivy.xml` files into this directory first. Then you can modify the new
copies (they will be ignored by version control).

If one of the example configurations is all you need, you can use that in the build
by passing a `-Divy.file` argument to the build, for example 
`-Divy.file=example/ivy.xml`.

## Ivy Configuration

The build script assembles all the various artifacts that make up the SolarNode
Platform using Apache Ivy. The **ivy.xml** file configures which artifacts to
include in the build. Typically you might customize this to add additional 
artifacts not already included in the platform.

## Building

To build the platform, run the **archive** task:

	ant archive
	
This will produce a platform tarball at `build/base-equinox-node.tgz`. To
rebuild always from scratch, add the **clean** task:

	ant clean archive

## Upgrading nodes

To upgrade an existing node with a new platform version, follow the process
outlined [on the SolarNetwork wiki][upgrade].

 
  [ant]: https://ant.apache.org/
  [ant-script]: https://ant.apache.org/manual/Tasks/script.html
  [upgrade]: https://github.com/SolarNetwork/solarnetwork/wiki/SolarNode-Manual-Platform-Update
 