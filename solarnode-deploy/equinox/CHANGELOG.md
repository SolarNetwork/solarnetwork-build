# SolarNode Platform (Equinox) Changelog

## 1.8.0 - 2020-09-08

 * Update to Gemini Web 3.0.6 (Apache Tomcat 8.5.56)

## 1.7.0 - 2020-08-31

 * Add JNA support to support easier direct hardware access.

## 1.6.0 - 2020-06-24

 * Add support for factory reset to remove SolarNode configuration and data.

## 1.5.2 - 2020-01-24

 * Remove net.solarnetwork.node.core.cfg from base package, so that 
   customer-specific packages can provide instead.

## 1.5.1 - 2019-12-19

 * Add /usr/lib to SolarNode lib path, to be able to pick up libraries
   like yasdi via yasdi4j.

## 1.5.0 - 2019-12-17

 * Update Jackson JSON to 2.10.1 to pick up CBOR bug fix.

## 1.4.0 - 2019-12-06

 * Replace Eclipse Paho with Netty MQTT for better connection resiliency.
 * Update to Netty v4.1.43.
 * Add javax.inject v1.3.
 * Add JAXB 2.3.2 runtime to work with Java 11.
 * Add javax.activation 1.2.1 to work with Java 11.
 * Replace AWS SDK JAR with custom "slim" version to reduce size of package.

## 1.3.1 - 2019-10-21

 * Add support for /usr/share/solarnode/app/ext directory to replace the
   jre/lib/ext directory removed in Java 11. This fixes a problem with
   loading the RXTX libary in Java 11.

## 1.3.0 - 2019-10-21

 * Update Apache HTTP client to v4.5.10.
 * Update AWS SDK to v1.11.651 for Java 11 fixes.
 * Update Eclipse Paho to v1.2.2.

## 1.2.2 - 2019-09-18

 * Make link from ~solar/bin to /var/lib/solarnode/bin.
 * Update to Spring 4.3.25 for bug fixes in working with Java 11.

## 1.2.1 - 2019-09-06

 * Fix SolarNode startup script to look for bundle hooks in proper directory.

## 1.2.0 - 2019-08-26

 * Add utility functions to add/remove bundles from Equinox's config.init
   osgi.bundles property, to allow other packages to easily maintain custom
   additions to startup. 

## 1.1.1 - 2019-07-23

 * Allow bash shell hooks via /usr/share/solarnode/bash-utils.d directory.

## 1.1.0 - 2019-07-16

 * Update Equinox to v3.14 for Java 11 support
 * Update Equinox CM to v1.4
 * Update Equinox Console to v1.3
 * Update Felix Event Admin to v1.5
 * Update Felix Gogo Shell to v1.1
 
## v20190325

 * Update Gemini Blueprint to v2.1.0
 * Update Gemini Web to v3.0.4 (Tomcat 8.5.35)
 * Update Spring Framework to v4.3.23
 * Update Spring Security to v4.2.4
 * Update Jackson JSON to v2.9.9

## v20180613

 * Add Eclipse Paho v1.2 for MQTT support

## v20180517

 * Remove duplicate Commons Codec JAR (v1.9)
 * Update SuperCSV to 2.4

## v20180409

 * Update Jackson JSON
 * Add JCache (javax.cache) support via Ehcache
 * Update slf4j
 * Update Apache Commons BeanUtils, Codec, Collections, and IO

## v20170628

 * Update Tomcat JDBC
 * Configure SolarSSH OS support
 * Update pack:tag to support SolarSSH

## v20170306

**Note** if the Tyrus websocket server added in this release was deployed as
a normal application artifact (e.g. in `app/main`), that copy should be removed
after upgrading to this version so there aren't two copies loaded.

 * Update to Gemini Web 3.0 (Servlet 3.1)
 * Update to Spring 4.2.9
 * Add Tyrus websocket server
