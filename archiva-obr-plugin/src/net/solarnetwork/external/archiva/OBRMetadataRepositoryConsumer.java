/* ==================================================================
 * OBRMetadataRepositoryConsumer.java - May 7, 2014 7:08:37 PM
 * 
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 * 
 *   http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 * ==================================================================
 */

package net.solarnetwork.external.archiva;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.regex.Pattern;
import org.apache.archiva.admin.model.beans.ManagedRepository;
import org.apache.archiva.consumers.AbstractMonitoredConsumer;
import org.apache.archiva.consumers.ConsumerException;
import org.apache.archiva.consumers.KnownRepositoryContentConsumer;
import org.apache.felix.bundlerepository.DataModelHelper;
import org.apache.felix.bundlerepository.Repository;
import org.apache.felix.bundlerepository.Resource;
import org.apache.felix.bundlerepository.impl.DataModelHelperImpl;
import org.apache.felix.bundlerepository.impl.RepositoryImpl;
import org.apache.felix.bundlerepository.impl.ResourceImpl;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;

/**
 * Generate OSGi Bundle Repository XML metadata out of OSGi bundle resources.
 * This requires adding the Apache Felix BundleRepository and OSGi Core JARs to
 * Archiva's classpath. This can be accomplished by adding those JARs to the
 * {@code WEB-INF/lib} directory of the web application.
 * 
 * By default the OBR metadata will be created as a file named
 * {@code metadata.xml} at the root of the Archiva repository. The directory can
 * be changed by adding a {@code $appserver.base/conf/obr.properties} file with
 * a <b>obr.base</b> key with an associated absolute file path to the desired
 * directory. Note that {@code $appserver.base} represents the
 * {@code appserver.base} System property, which is normally set by the Archiva
 * start up script.
 * 
 * A bundle symbolic name exclusion regex can be configured in
 * {@code obr.properties} using a <b>obr.bundle.exclude</b> key.
 * 
 * @author matt
 * @version 1.0
 */
@Service("knownRepositoryContentConsumer#create-obr-metadata")
@Scope("prototype")
public class OBRMetadataRepositoryConsumer extends AbstractMonitoredConsumer
		implements KnownRepositoryContentConsumer {

	private static final Logger log = LoggerFactory.getLogger(OBRMetadataRepositoryConsumer.class);

	private final String id = "create-obr-metadata";
	private final String description = "Create OSGi Bundle Repository metadata from artifacts in the repository.";
	private String repoId;
	private Properties props;
	private String basePath;
	private String archivaRepositoryLocation;
	private File metadataFile;
	private RepositoryImpl obrRepository;
	private long obrRepositoryLastModifiedDate;
	private long foundMostRecentModifiedDate;
	private DataModelHelper dataModelHelper;
	private Pattern bundleIdExcludePattern;

	@Override
	public String getId() {
		return id;
	}

	@Override
	public String getDescription() {
		return description;
	}

	@Override
	public List<String> getIncludes() {
		// we only care about OSGi bundle artifacts
		return Collections.singletonList("**/*.jar");
	}

	@Override
	public List<String> getExcludes() {
		// we also want to exclude searching in the default locations, and exclude source JARs
		List<String> excludes = new ArrayList<String>(getDefaultArtifactExclusions());
		excludes.add("**/*-sources.jar");
		return excludes;
	}

	@Override
	public void beginScan(ManagedRepository repository, Date whenGathered) throws ConsumerException {
		beginScan(repository, whenGathered, true);
	}

	private void loadProperties() {
		File propFile = new File(System.getProperty("appserver.base", "."), "conf/obr.properties");
		props = new Properties();
		if ( propFile.canRead() ) {
			InputStream in = null;
			try {
				in = new BufferedInputStream(new FileInputStream(propFile));
				props.load(in);
			} catch ( IOException e ) {
				log.warn("Unable to load OBR properties from {}: {}", propFile, e.getMessage());
			} finally {
				if ( in != null ) {
					try {
						in.close();
					} catch ( IOException e ) {
						// ignore this
					}
				}
			}
		}
	}

	@Override
	public void beginScan(ManagedRepository repository, Date whenGathered, boolean executeOnEntireRepo)
			throws ConsumerException {
		repoId = repository.getId();
		log.info("Beginning scan on repository {} on {}; all = {}", repoId, whenGathered,
				executeOnEntireRepo);
		loadProperties();
		archivaRepositoryLocation = repository.getLocation();
		basePath = (props.containsKey("obr.base") ? props.getProperty("obr.base")
				: archivaRepositoryLocation);
		bundleIdExcludePattern = (props.containsKey("obr.bundle.exclude")
				? Pattern.compile(props.getProperty("obr.bundle.exclude"))
				: null);
		if ( bundleIdExcludePattern != null ) {
			log.info("Excluding bundles with symbolic IDs that match regex: {}",
					bundleIdExcludePattern.pattern());
		}
		obrRepositoryLastModifiedDate = 0;
		foundMostRecentModifiedDate = 0;
		metadataFile = new File(basePath, "metadata.xml");
		if ( !metadataFile.getParentFile().isDirectory() && !metadataFile.getParentFile().mkdirs() ) {
			log.error("OBR base path {} does not exist and can't be created.", basePath);
			throw new ConsumerException("OBR base path does not exist: " + basePath);
		}
		dataModelHelper = new DataModelHelperImpl();
		if ( metadataFile.canRead() ) {
			// load up existing repository
			Reader reader = null;
			try {
				reader = new FileReader(metadataFile);
				Repository existingRepo = dataModelHelper.readRepository(reader);
				if ( executeOnEntireRepo == false ) {
					if ( existingRepo != null ) {
						obrRepositoryLastModifiedDate = existingRepo.getLastModified();
						log.info("OBR metadata last generated at {}",
								new Date(obrRepositoryLastModifiedDate));
					}
					obrRepository = (RepositoryImpl) existingRepo;
				}
			} catch ( Exception e ) {
				log.warn("Exception reading existing OBR metadata; will recreate", e);
			} finally {
				if ( reader != null ) {
					try {
						reader.close();
					} catch ( IOException e ) {
						// ignore
					}
				}
			}
		}
		if ( obrRepository == null ) {
			obrRepository = new RepositoryImpl();
		}
	}

	@Override
	public void processFile(String path) throws ConsumerException {
		log.debug("Processing file {}", path);
		try {
			File file = new File(archivaRepositoryLocation, path);
			final long foundLastModified = file.lastModified();
			if ( foundLastModified > obrRepositoryLastModifiedDate ) {
				ResourceImpl obrResource = (ResourceImpl) dataModelHelper
						.createResource(file.toURI().toURL());
				if ( bundleIdExcludePattern != null && obrResource.getSymbolicName() != null
						&& bundleIdExcludePattern.matcher(obrResource.getSymbolicName()).find() ) {
					log.info("Excluding OBR resource {}", path);
					return;
				}
				// we want a relative URL, so override the absolute path ResourceImpl generated
				obrResource.put(Resource.URI, path);
				obrRepository.addResource(obrResource);
				if ( foundLastModified > foundMostRecentModifiedDate ) {
					foundMostRecentModifiedDate = foundLastModified;
				}
			} else if ( log.isTraceEnabled() ) {
				log.trace("Skipping unmodified OBR resource {}", path);
			}
		} catch ( IllegalArgumentException e ) {
			log.warn("Skipping OBR resource {}, does not appear to be a bundle", path);
		} catch ( IOException e ) {
			throw new ConsumerException("Error creating OBR resource", e);
		}
	}

	@Override
	public void processFile(String path, boolean executeOnEntireRepo) throws Exception {
		processFile(path);
	}

	@Override
	public void completeScan() {
		log.debug("Completed scan of repository {}", repoId);
		if ( metadataFile.exists() && foundMostRecentModifiedDate <= obrRepositoryLastModifiedDate ) {
			log.info("OBR metadata unchanged.");
			return;
		}
		// write the XML to a temporary file first, and if that succeeds then move the temporary
		// file to the final destination
		Writer writer = null;
		File tmpFile = new File(metadataFile.getAbsolutePath() + ".tmp");
		try {
			writer = new BufferedWriter(new FileWriter(tmpFile));
			dataModelHelper.writeRepository(obrRepository, writer);
			writer.flush();
			if ( metadataFile.exists() && !metadataFile.delete() ) {
				log.warn("Unable to delete old OBR metadata file {}", metadataFile);
			}
			if ( !tmpFile.renameTo(metadataFile) ) {
				log.warn("Unable to move temporary OBR metadata file to {}", metadataFile);
			} else if ( log.isInfoEnabled() ) {
				log.info("Created OBR metadata {}", metadataFile);
			}
		} catch ( IOException e ) {
			log.error("Error writing OBR metadata file {}", metadataFile, e);
		} finally {
			if ( writer != null ) {
				try {
					writer.close();
				} catch ( IOException e ) {
					// ignore this
				}
			}
		}
	}

	@Override
	public void completeScan(boolean executeOnEntireRepo) {
		completeScan();
	}

}
