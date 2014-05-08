/* ==================================================================
 * OBRMetadataRepositoryConsumer.java - May 7, 2014 7:08:37 PM
 * 
 * Copyright 2007-2014 SolarNetwork.net Dev Team
 * 
 * This program is free software; you can redistribute it and/or 
 * modify it under the terms of the GNU General Public License as 
 * published by the Free Software Foundation; either version 2 of 
 * the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 
 * 02111-1307 USA
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
 * a {@bold obr.base} key with an associated absolute file path to the
 * desired directory. Note that {@code $appserver.base} represents the
 * {@code appserver.base} System property, which is normally set by the Archiva
 * start up script.
 * 
 * @author matt
 * @version 0.1
 */
@Service("knownRepositoryContentConsumer#create-obr-metadata")
@Scope("prototype")
public class OBRMetadataRepositoryConsumer extends AbstractMonitoredConsumer implements
		KnownRepositoryContentConsumer {

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

	@Override
	public String getId() {
		return id;
	}

	@Override
	public String getDescription() {
		return description;
	}

	@Override
	public boolean isPermanent() {
		return false;
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
		log.debug("Beginning scan on repository {} on {}", repoId, whenGathered);
		loadProperties();
		archivaRepositoryLocation = repository.getLocation();
		basePath = (props.containsKey("obr.base") ? props.getProperty("obr.base")
				: archivaRepositoryLocation);
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
				if ( existingRepo != null ) {
					obrRepositoryLastModifiedDate = existingRepo.getLastModified();
				}
				if ( executeOnEntireRepo == false ) {
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
				ResourceImpl obrResource = (ResourceImpl) dataModelHelper.createResource(file.toURI()
						.toURL());
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
		if ( !metadataFile.exists() || foundMostRecentModifiedDate <= obrRepositoryLastModifiedDate ) {
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
