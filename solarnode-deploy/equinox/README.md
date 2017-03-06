# SolarNode Framework (Equinox)

This directory contains the build script for generating the base SolarNode
Framework using the Equinox OSGi runtime. The build requires [Apache Ant][ant]
with JavaScript language [script][ant-script] support.

## Configuration Setup

The build requires some configuration to run. Copy the `example/build.properties`
and `example/ivy.xml` files into this directory first. Then you can modify the new
copies (they will be ignored by version control).

## Ivy Configuration

The build script assembles all the various artifacts that make up the SolarNode
Framework using Apache Ivy. The **ivy.xml** file configures which artifacts to
include in the build. Typically you might customize this to add additional 
artifacts not already included in the framework.

## Building

To build the framework, run the **archive** task:

	ant archive
	
This will produce a framework tarball at `build/base-equinox-node.tgz`. To
rebuild always from scratch, add the **clean** task:

	ant clean archive

  [ant]: https://ant.apache.org/
  [ant-script]: https://ant.apache.org/manual/Tasks/script.html
 