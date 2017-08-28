/* ==================================================================
 * BundleHelper.java - Dec 16, 2009 9:44:33 AM
 * 
 * Copyright 2007 SolarNetwork.net Dev Team
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

package net.solarnetwork.bh.ant;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.jar.Attributes;
import java.util.jar.Manifest;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.PatternSet;

/**
 * Parse a manifest file and expose attributes as properties.
 * 
 * <p>
 * The exposed properties are created exactly from the manifest attribute keys
 * and values.
 * </p>
 * 
 * @author matt
 * @version 1.1
 */
public class ManifestReader extends Task {

	private static final String[] DEFAULT_KEYS = new String[] { "Bundle-Name", "Bundle-SymbolicName",
			"Bundle-Version", "Bundle-Vendor" };

	private static final String BUNDLE_CLASSPATH = "Bundle-ClassPath";

	private File manifest = null;

	public void execute() throws BuildException {
		Manifest mf;
		InputStream in = null;
		try {
			in = new BufferedInputStream(new FileInputStream(manifest));
			mf = new Manifest(in);
		} catch ( FileNotFoundException e ) {
			throw new BuildException(e);
		} catch ( IOException e ) {
			throw new BuildException(e);
		} finally {
			if ( in != null ) {
				try {
					in.close();
				} catch ( IOException e ) {
					// ignore this
				}
			}
		}
		Attributes main = mf.getMainAttributes();
		for ( int i = 0, len = DEFAULT_KEYS.length; i < len; i++ ) {
			String key = DEFAULT_KEYS[i];
			String value = main.getValue(key);
			if ( value != null ) {
				getProject().setNewProperty(key, value);
			}
		}

		// include ClassPath as a FileSet, if available
		String bcpHeader = main.getValue(BUNDLE_CLASSPATH);
		if ( bcpHeader != null ) {
			String[] bcp = bcpHeader.split(",");
			if ( bcp != null ) {
				PatternSet fs = null;
				for ( int i = 0, len = bcp.length; i < len; i++ ) {
					String oneEntry = bcp[i];
					if ( oneEntry.length() > 0 && !".".equals(oneEntry) ) {
						if ( fs == null ) {
							fs = new PatternSet();
							fs.setProject(getProject());
						}
						fs.createInclude().setName(oneEntry);
					}
				}

				if ( fs != null ) {
					getProject().addReference(BUNDLE_CLASSPATH, fs);
				}
			}
		}
	}

	/**
	 * Set the manifest file to read from.
	 * 
	 * @param manifest
	 *        the manifest to set
	 */
	public void setManifest(File manifest) {
		this.manifest = manifest;
	}

}
