# SolarNode Platform (Equinox) Changelog

## v20190716

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
