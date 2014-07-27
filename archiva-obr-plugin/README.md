# Apache Archiva OSGi Bundle Repository Plugin

This projects implements an [Apache Archiva][1] plugin that produces an [OSGi Bundle
Repository][2] metadata file based on the available OSGi bundles hosted in Archiva
repositories.

# Building

The build relies on Apache Ant and the Apache Ivy Ant plugin. If you clone this
entire repository the Ivy Ant plugin will be included. Then run

	ant jar
	
To build the OBR plugin, which will be created as `target/archiva-obr-plugin-X.jar`.

# Configuring

To enable support, you must first download and install the following dependencies
into Archiva's `WEB-INF/lib` directory:

 1. [Apache Felix Bundle Repository][3]
 2. [OSGi Core API][4]
 
Copy the **archiva-obr-plugin-X.jar** you downloaded or built to the `WEB-INF/lib`
directory as well.

Next, modify the `conf/archiva.xml` file and look for a section starting with
`<knownContentConsumers>`. There will be a list of `<knownContentConsumer>` elements
in that section. Add another line after the last one like this:

	<knownContentConsumer>create-obr-metadata</knownContentConsumer>
	
Now you should be able to (re)start Archiva, and kick off a directory scan on your
desired repository to generate the OBR metadata file.

  [1]: http://archiva.apache.org/
  [2]: http://felix.apache.org/site/apache-felix-osgi-bundle-repository.html
  [3]: http://search.maven.org/#artifactdetails|org.apache.felix|org.apache.felix.bundlerepository|1.6.6|bundle
  [4]: http://search.maven.org/#artifactdetails|org.osgi|org.osgi.core|4.1.0|jar
  
