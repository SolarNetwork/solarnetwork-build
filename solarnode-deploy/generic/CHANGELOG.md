# SolarNode Application Changelog

The **ID** values listed here refer to plugin symbolic names, defined in the
`Bundle-SymbolicName` entry of each plugin's `META-INF/MANIFEST.MF` file. They
are abbreviated to make them shorter, using the following conventions:

| ID abbreviation | Full value                |
|:----------------|:--------------------------|
| `n.s.common`    | `net.solarnetwork.common` |
| `n.s.n`         | `net.solarnetwork.node`   |

## 1.13.1 - 2021-04-07

Includes the following plugins:

| Name                                 | ID                             | Vers   |
|:-------------------------------------|:-------------------------------|:-------|
| Auto Setup                           | `n.s.n.setup.auto`             | 1.3.1  |
| Bouncy Castle PKI                    | `n.s.common.pki.bc`            | 1.3.0  |
| Command Line System Service          | `n.s.n.system.cmdline`         | 1.2.0  |
| Common AWS S3 Support                | `n.s.common.s3`                | 1.1.1  |
| Core Database Storage Support        | `n.s.n.dao.jdbc`               | 1.28.2 |
| Core Reactor Service                 | `n.s.n.reactor.simple`         | 1.5.1  |
| Core Settings Support                | `n.s.n.settings.ca`            | 1.12.0 |
| Core Setup Support                   | `n.s.n.setup`                  | 1.22.0 |
| Core Setup Web App                   | `n.s.n.setup.web`              | 1.45.0 |
| Core SolarNetwork Support            | `n.s.common`                   | 1.68.0 |
| Core SolarNode Framework             | `n.s.node`                     | 1.80.0 |
| Debian Setup Support                 | `n.s.n.setup.deb`              | 1.0.0  |
| Derby Database Extensions            | `n.s.n.dao.jdbc.derby.ext`     | 1.1.1  |
| Derby Database Storage Support       | `n.s.n.dao.jdbc.derby`         | 1.8.1  |
| Eclipse Gemini Web Support           | `n.s.common.web.gemini`        | 2.1.0  |
| JSON Metadata Service                | `n.s.n.metadata.json`          | 1.4.0  |
| MQTT client - Netty                  | `n.s.common.mqtt.netty`        | 1.1.0  |
| Plugin Repository                    | `n.s.n.setup.obr`              | 1.5.2  |
| Reactor Database Storage             | `n.s.n.reactor.dao.jdbc`       | 1.4.0  |
| Reactor JSON Support                 | `n.s.n.reactor.io.json`        | 1.2.1  |
| S3 Backup                            | `n.s.n.backup.s3`              | 1.1.0  |
| S3 Setup                             | `n.s.n.setup.s3`               | 1.2.0  |
| SolarNet Bulk JSON Web Uploader      | `n.s.n.upload.bulkjsonwebpost` | 1.11.0 |
| SolarNet Location Service            | `n.s.n.location.ws`            | 2.4.0  |
| SolarNet MQTT integration            | `n.s.n.upload.mqtt`            | 1.6.1  |
| SolarNetwork Common MQTT Support     | `n.s.common.mqtt`              | 2.1.0  |
| SolarNetwork Common Web              | `n.s.common.web`               | 1.17.0 |
| SolarNode External Filesystem Backup | `n.s.n.backup.ext`             | 1.0.0  |
| SolarNode Security                   | `n.s.n.setup.security`         | 1.0.0  |
| Spring Expression Service            | `n.s.common.expr.spel`         | 1.0.1  |
| System SSH Support                   | `n.s.n.system.ssh`             | 1.1.1  |

## 1.13.0 - 2021-04-06

Includes the following plugins:

| Name                                 | ID                             | Vers   |
|:-------------------------------------|:-------------------------------|:-------|
| Auto Setup                           | `n.s.n.setup.auto`             | 1.3.1  |
| Bouncy Castle PKI                    | `n.s.common.pki.bc`            | 1.3.0  |
| Command Line System Service          | `n.s.n.system.cmdline`         | 1.2.0  |
| Common AWS S3 Support                | `n.s.common.s3`                | 1.1.1  |
| Core Database Storage Support        | `n.s.n.dao.jdbc`               | 1.28.2 |
| Core Reactor Service                 | `n.s.n.reactor.simple`         | 1.5.1  |
| Core Settings Support                | `n.s.n.settings.ca`            | 1.12.0 |
| Core Setup Support                   | `n.s.n.setup`                  | 1.22.0 |
| Core Setup Web App                   | `n.s.n.setup.web`              | 1.45.0 |
| Core SolarNetwork Support            | `n.s.common`                   | 1.68.0 |
| Core SolarNode Framework             | `n.s.node`                     | 1.80.0 |
| Debian Setup Support                 | `n.s.n.setup.deb`              | 1.0.0  |
| Derby Database Extensions            | `n.s.n.dao.jdbc.derby.ext`     | 1.1.1  |
| Derby Database Storage Support       | `n.s.n.dao.jdbc.derby`         | 1.8.1  |
| Eclipse Gemini Web Support           | `n.s.common.web.gemini`        | 2.1.0  |
| JSON Metadata Service                | `n.s.n.metadata.json`          | 1.4.0  |
| MQTT client - Netty                  | `n.s.common.mqtt.netty`        | 1.1.0  |
| Plugin Repository                    | `n.s.n.setup.obr`              | 1.5.2  |
| Reactor Database Storage             | `n.s.n.reactor.dao.jdbc`       | 1.4.0  |
| Reactor JSON Support                 | `n.s.n.reactor.io.json`        | 1.2.1  |
| S3 Backup                            | `n.s.n.backup.s3`              | 1.1.0  |
| S3 Setup                             | `n.s.n.setup.s3`               | 1.2.0  |
| SolarNet Bulk JSON Web Uploader      | `n.s.n.upload.bulkjsonwebpost` | 1.11.0 |
| SolarNet Location Service            | `n.s.n.location.ws`            | 2.4.0  |
| SolarNet MQTT integration            | `n.s.n.upload.mqtt`            | 1.6.1  |
| SolarNetwork Common MQTT Support     | `n.s.common.mqtt`              | 2.1.0  |
| SolarNetwork Common Web              | `n.s.common.web`               | 1.17.0 |
| SolarNode External Filesystem Backup | `n.s.n.backup.ext`             | 1.0.0  |
| SolarNode Security                   | `n.s.n.setup.security`         | 1.0.0  |
| Spring Expression Service            | `n.s.common.expr.spel`         | 1.0.1  |
| System SSH Support                   | `n.s.n.system.ssh`             | 1.1.1  |

## 1.12.0 - 2021-02-26

Includes the following plugins:

| Name                                 | ID                             | Vers   |
|:-------------------------------------|:-------------------------------|:-------|
| Auto Setup                           | `n.s.n.setup.auto`             | 1.3.1  |
| Bouncy Castle PKI                    | `n.s.common.pki.bc`            | 1.3.0  |
| Command Line System Service          | `n.s.n.system.cmdline`         | 1.2.0  |
| Common AWS S3 Support                | `n.s.common.s3`                | 1.0.1  |
| Core Database Storage Support        | `n.s.n.dao.jdbc`               | 1.28.1 |
| Core Reactor Service                 | `n.s.n.reactor.simple`         | 1.5.1  |
| Core Settings Support                | `n.s.n.settings.ca`            | 1.11.1 |
| Core Setup Support                   | `n.s.n.setup`                  | 1.22.0 |
| Core Setup Web App                   | `n.s.n.setup.web`              | 1.44.1 |
| Core SolarNetwork Support            | `n.s.common`                   | 1.68.0 |
| Core SolarNode Framework             | `n.s.node`                     | 1.79.0 |
| Debian Setup Support                 | `n.s.n.setup.deb`              | 1.0.0  |
| Derby Database Extensions            | `n.s.n.dao.jdbc.derby.ext`     | 1.1.1  |
| Derby Database Storage Support       | `n.s.n.dao.jdbc.derby`         | 1.8.1  |
| Eclipse Gemini Web Support           | `n.s.common.web.gemini`        | 2.1.0  |
| JSON Metadata Service                | `n.s.n.metadata.json`          | 1.4.0  |
| MQTT client - Netty                  | `n.s.common.mqtt.netty`        | 1.1.0  |
| Plugin Repository                    | `n.s.n.setup.obr`              | 1.5.2  |
| Reactor Database Storage             | `n.s.n.reactor.dao.jdbc`       | 1.4.0  |
| Reactor JSON Support                 | `n.s.n.reactor.io.json`        | 1.2.1  |
| S3 Backup                            | `n.s.n.backup.s3`              | 1.0.0  |
| S3 Setup                             | `n.s.n.setup.s3`               | 1.2.0  |
| SolarNet Bulk JSON Web Uploader      | `n.s.n.upload.bulkjsonwebpost` | 1.11.0 |
| SolarNet Location Service            | `n.s.n.location.ws`            | 2.4.0  |
| SolarNet MQTT integration            | `n.s.n.upload.mqtt`            | 1.6.1  |
| SolarNetwork Common MQTT Support     | `n.s.common.mqtt`              | 2.1.0  |
| SolarNetwork Common Web              | `n.s.common.web`               | 1.17.0 |
| SolarNode External Filesystem Backup | `n.s.n.backup.ext`             | 1.0.0  |
| SolarNode Security                   | `n.s.n.setup.security`         | 1.0.0  |
| Spring Expression Service            | `n.s.common.expr.spel`         | 1.0.1  |
| System SSH Support                   | `n.s.n.system.ssh`             | 1.1.0  |


## 1.11.0 - 2021-02-26

Includes the following plugins:

| Name                                 | ID                             | Vers   |
|:-------------------------------------|:-------------------------------|:-------|
| Auto Setup                           | `n.s.n.setup.auto`             | 1.3.1  |
| Bouncy Castle PKI                    | `n.s.common.pki.bc`            | 1.3.0  |
| Command Line System Service          | `n.s.n.system.cmdline`         | 1.2.0  |
| Common AWS S3 Support                | `n.s.common.s3`                | 1.0.1  |
| Core Database Storage Support        | `n.s.n.dao.jdbc`               | 1.28.0 |
| Core Reactor Service                 | `n.s.n.reactor.simple`         | 1.5.1  |
| Core Settings Support                | `n.s.n.settings.ca`            | 1.11.1 |
| Core Setup Support                   | `n.s.n.setup`                  | 1.22.0 |
| Core Setup Web App                   | `n.s.n.setup.web`              | 1.44.1 |
| Core SolarNetwork Support            | `n.s.common`                   | 1.68.0 |
| Core SolarNode Framework             | `n.s.node`                     | 1.79.0 |
| Debian Setup Support                 | `n.s.n.setup.deb`              | 1.0.0  |
| Derby Database Extensions            | `n.s.n.dao.jdbc.derby.ext`     | 1.1.1  |
| Derby Database Storage Support       | `n.s.n.dao.jdbc.derby`         | 1.8.1  |
| Eclipse Gemini Web Support           | `n.s.common.web.gemini`        | 2.1.0  |
| JSON Metadata Service                | `n.s.n.metadata.json`          | 1.3.0  |
| MQTT client - Netty                  | `n.s.common.mqtt.netty`        | 1.1.0  |
| Plugin Repository                    | `n.s.n.setup.obr`              | 1.5.2  |
| Reactor Database Storage             | `n.s.n.reactor.dao.jdbc`       | 1.4.0  |
| Reactor JSON Support                 | `n.s.n.reactor.io.json`        | 1.2.1  |
| S3 Backup                            | `n.s.n.backup.s3`              | 1.0.0  |
| S3 Setup                             | `n.s.n.setup.s3`               | 1.2.0  |
| SolarNet Bulk JSON Web Uploader      | `n.s.n.upload.bulkjsonwebpost` | 1.11.0 |
| SolarNet Location Service            | `n.s.n.location.ws`            | 2.4.0  |
| SolarNet MQTT integration            | `n.s.n.upload.mqtt`            | 1.6.0  |
| SolarNetwork Common MQTT Support     | `n.s.common.mqtt`              | 2.1.0  |
| SolarNetwork Common Web              | `n.s.common.web`               | 1.17.0 |
| SolarNode External Filesystem Backup | `n.s.n.backup.ext`             | 1.0.0  |
| SolarNode Security                   | `n.s.n.setup.security`         | 1.0.0  |
| Spring Expression Service            | `n.s.common.expr.spel`         | 1.0.1  |
| System SSH Support                   | `n.s.n.system.ssh`             | 1.1.0  |


## 1.10.0 - 2020-08-26

Includes the following plugins:

| Name                                 | ID                             | Vers   |
|:-------------------------------------|:-------------------------------|:-------|
| Auto Setup                           | `n.s.n.setup.auto`             | 1.3.1  |
| Bouncy Castle PKI                    | `n.s.common.pki.bc`            | 1.3.0  |
| Command Line System Service          | `n.s.n.system.cmdline`         | 1.2.0  |
| Common AWS S3 Support                | `n.s.common.s3`                | 1.0.1  |
| Core Database Storage Support        | `n.s.n.dao.jdbc`               | 1.28.0 |
| Core Reactor Service                 | `n.s.n.reactor.simple`         | 1.5.1  |
| Core Settings Support                | `n.s.n.settings.ca`            | 1.11.1 |
| Core Setup Support                   | `n.s.n.setup`                  | 1.22.0 |
| Core Setup Web App                   | `n.s.n.setup.web`              | 1.44.0 |
| Core SolarNetwork Support            | `n.s.common`                   | 1.65.0 |
| Core SolarNode Framework             | `n.s.node`                     | 1.76.0 |
| Debian Setup Support                 | `n.s.n.setup.deb`              | 1.0.0  |
| Derby Database Extensions            | `n.s.n.dao.jdbc.derby.ext`     | 1.1.1  |
| Derby Database Storage Support       | `n.s.n.dao.jdbc.derby`         | 1.8.1  |
| Eclipse Gemini Web Support           | `n.s.common.web.gemini`        | 2.1.0  |
| JSON Metadata Service                | `n.s.n.metadata.json`          | 1.3.0  |
| MQTT client - Netty                  | `n.s.common.mqtt.netty`        | 1.1.0  |
| Plugin Repository                    | `n.s.n.setup.obr`              | 1.5.2  |
| Reactor Database Storage             | `n.s.n.reactor.dao.jdbc`       | 1.4.0  |
| Reactor JSON Support                 | `n.s.n.reactor.io.json`        | 1.2.1  |
| S3 Backup                            | `n.s.n.backup.s3`              | 1.0.0  |
| S3 Setup                             | `n.s.n.setup.s3`               | 1.2.0  |
| SolarNet Bulk JSON Web Uploader      | `n.s.n.upload.bulkjsonwebpost` | 1.11.0 |
| SolarNet Location Service            | `n.s.n.location.ws`            | 2.4.0  |
| SolarNet MQTT integration            | `n.s.n.upload.mqtt`            | 1.6.0  |
| SolarNetwork Common MQTT Support     | `n.s.common.mqtt`              | 2.1.0  |
| SolarNetwork Common Web              | `n.s.common.web`               | 1.17.0 |
| SolarNode External Filesystem Backup | `n.s.n.backup.ext`             | 1.0.0  |
| SolarNode Security                   | `n.s.n.setup.security`         | 1.0.0  |
| Spring Expression Service            | `n.s.common.expr.spel`         | 1.0.1  |
| System SSH Support                   | `n.s.n.system.ssh`             | 1.1.0  |


## 1.9.0 - 2020-06-26

Updates to the following plugins:

| Name | ID | Version |
|:-----|:---|:--------|
| Command Line System Service | `n.s.n.system.cmdline` | 1.2.0 |
| Core Setup Web App | `n.s.n.setup.web` | 1.44.0 |
| Core SolarNetwork Support | `n.s.common` | 1.63.0 |
| Core SolarNode Framework | `n.s.n` | 1.75.0 |
| SolarNode External Filesystem Backup | `n.s.n.backup.ext` | 1.0.0 |


## 1.8.0 - 2020-04-23

Updates to the following plugins:

| Name | ID | Version |
|:-----|:---|:--------|
| Core SolarNetwork Support | `n.s.common` | 1.61.0 |
| Core SolarNode Framework | `n.s.n` | 1.74.1 |


## 1.7.0 - 2020-04-14

Updates to the following plugins:

| Name | ID | Version |
|:-----|:---|:--------|
| SolarNetwork Common MQTT Support | `n.s.common.mqtt` | 2.1.0 |
| MQTT client - Netty | `n.s.common.mqtt.netty` | 1.1.0 |
| Core SolarNetwork Support | `n.s.common` | 1.60.0 |
| Common AWS S3 Support | `n.s.common.s3` | 1.0.1 |
| Plugin Repository | `n.s.n.setup.obr` | 1.5.2 |
| SolarNet MQTT integration | `n.s.n.upload.mqtt` | 1.6.0 |


## 1.6.0 - 2020-03-15

Updates to the following plugins:

| Name | ID | Version |
|:-----|:---|:--------|
| Core Database Storage Support | `n.s.n.dao.jdbc` | 1.27.0 |
| Core Setup Web App | `n.s.n.setup.web` | 1.43.1 |
| Core SolarNetwork Support | `n.s.common` | 1.59.0 |
| Core SolarNode Framework | `n.s.node` | 1.74.0 |
| SolarNetwork Common Web | `n.s.common.web` | 1.17.0 |


## 1.5.1 - 2020-01-30

Updates the following plugins:

| Name | ID | Version |
|:-----|:---|:--------|
| SolarNetwork Common MQTT Support | `n.s.common.mqtt` | 2.0.1 |
| SolarNet Location Service | `n.s.n.location.ws` | 2.3.0 |
| JSON Metadata Service | `n.s.n.metadata.json` | 1.2.0 |
| Core Setup Support | `n.s.n.setup` | 1.22.0 |
| Core Setup Web App | `n.s.n.setup.web` | 1.43.0 |
| SolarNet Bulk JSON Web Uploader | `n.s.n.upload.bulkjsonwebpost` | 1.11.0 |
| SolarNet MQTT integration | `n.s.n.upload.mqtt` | 1.5.1 |


## 1.5.0 - 2020-01-27

 * Update Core SolarNetwork Support to **1.58.0**

## 1.4.2 - 2020-01-24

 * Update Core SolarNode Framework to **1.73.1**

## 1.4.1 - 2020-01-14

 * Add MQTT client - Netty **1.0.2**
 * Update MQTT integration to **1.5.0**

## 1.4.0 - 2019-12-05

 * Update Core SolarNetwork Support to **1.57.0**
 * Update SolarNetwork Common MQTT Support to **2.0.0**
 * Add MQTT client - Netty **1.0.0**
 * Update SolarNetwork Common Web to **1.16.3**
 * Update Core SolarNode Framework to **1.73.0**
 * Remove obsolete plugin MQTT Communication Support
 * Update Auto Setup to **1.3.1**
 * Update Core Setup Web App to **1.42.2**
 * Update MQTT integration to **1.4.0**

## 1.3.0 - 2019-11-07

 * Update Core SolarNetwork Support to **1.55.0**
 * Update SolarNetwork Common MQTT Support to **1.1.0**
 * Update Core SolarNode Framework to **1.71.0**
 * Update MQTT Communication Support to **1.1.0**
 * Update Core Setup Web App to **1.42.0**
 * Update MQTT integration to **1.3.0**

## 1.2.0 - 2019-10-21

 * Update Core SolarNetwork Support to **1.54.0**
 * Add Common AWS S3 Support **1.0.0**
 * Update SolarNetwork Common Web to **1.16.2**
 * Update Core SolarNode Framework to **1.70.0**
 * Update S3 Backup to **1.0.0**
 * Update Core Database Storage Support to **1.26.0**
 * Update JSON Metadata Service to **1.1.0**
 * Update Core Settings Support to **1.11.0**
 * Update S3 Setup to **1.2.0**
 * Update Core Setup Web App to **1.40.0**

## V20180613

**Note** This release requires a minimum of the **20180613** SolarNode
Platform.

 * Add MQTT SolarIn support
 * Update to latest core plugins.

## V20180409

**Note** This release requires a minimum of the **20180409** SolarNode
Platform.

 * Bug fixes, enhancements to core plugins.

## V20170928

**Note** This release requires a minimum of the **20170628** SolarNode
Platform.

 * View captured datum values directly on the node web GUI, in real time.
 * New "Upgrade All" feature on web GUI Plugin screen.
 * Better handling of plugin updates by automatically restarting after
   upgrade.

## V20170801

**Note** This release requires a minimum of the **20170628** SolarNode
Platform.

 * Update to prevent database size from growing uncontrollably over
   time.
 * Fix bug in setup rendered "Trying URL /csrf" many times while
   waiting for service to restart.

## V20170725

**Note** This release requires a minimum of the **20170628** SolarNode
Platform.

 * Update to reduce memory use from database driver.
 * Fix bug in setup that prevented the initial random login password
   from displaying.

## V20170628

**Note** This release requires a minimum of the **20170628** SolarNode
Platform.

 * Support for platform version 20170628.
 * Add system SSH plugin to support SolarSSH.


## v20170306

**Note** This release requires a minimum of the **20170306** SolarNode
Platform.

 * Support for platform version 20170306.
