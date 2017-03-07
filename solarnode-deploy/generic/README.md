# SolarNode Application

This directory contains the build script for generating the base SolarNode
Application. The build requires [Apache Ant][ant].

## Configuration Setup

The build requires some configuration to run. Copy the `example/ivy.xml` file
into this directory first. Then you can modify the new copy (it will be
ignored by version control).

## Ivy Configuration

The build script assembles all the various artifacts that make up the SolarNode
Application using Apache Ivy. The **ivy.xml** file configures which artifacts to
include in the build. Typically you might customize this to add additional 
artifacts not already included in the application.

## Building

To build the application, run the **archive** task:

	ant archive
	
This will produce a platform tarball at `build/node-bundles.tgz`. To
rebuild always from scratch, add the **clean** task:

	ant clean archive

## Upgrading nodes

To upgrade an existing node with a new application version, [follow the process
outlined on the SolarNetwork wiki][upgrade].

 
  [ant]: https://ant.apache.org/
  [upgrade]: https://github.com/SolarNetwork/solarnetwork/wiki/SolarNode-Manual-Platform-Update
 