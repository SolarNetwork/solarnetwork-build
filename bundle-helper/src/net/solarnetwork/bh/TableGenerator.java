/* ==================================================================
 * TableGenerator.java - 9/09/2020 7:22:49 AM
 * 
 * Copyright 2020 SolarNetwork.net Dev Team
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

package net.solarnetwork.bh;

import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.SortedMap;
import java.util.TreeMap;
import java.util.jar.Attributes;
import java.util.jar.JarInputStream;
import java.util.jar.Manifest;

/**
 * Generate a list of bundle names as a Markdown table.
 * 
 * <p>
 * This tool is designed to help generate a table of bundle information, for use
 * in README or CHANGELOG style documentation. Pass a list of directories and/or
 * JAR files on the command line and it will print out a table of all bundles,
 * sorted by name, like this:
 * </p>
 * 
 * <pre>
 * <code>
 * | Name                                                     | ID                            | Vers  |
 * |:---------------------------------------------------------|:------------------------------|:------|
 * | Advanced Energy 250TX Inverter Data Source               | n.s.n.datum.ae.ae250tx        | 3.1.0 |
 * | Advanced Energy 500NX Inverter Data Source               | n.s.n.datum.ae.ae500nx        | 1.1.0 |
 * | Advanced Energy Hardware Support                         | n.s.n.hw.ae                   | 3.0.0 |
 * </code>
 * </pre>
 * 
 * @author matt
 * @version 1.0
 */
public class TableGenerator {

	public static final String BUNDLE_NAME = "Bundle-Name";
	public static final String BUNDLE_ID = "Bundle-SymbolicName";
	public static final String BUNDLE_VERS = "Bundle-Version";

	private final SortedMap<String, BundleInfo> bundles = new TreeMap<>();
	private final int[] widths = new int[] { 0, 0, 0 };

	private static class BundleInfo {

		private String name;
		private String bundleId;
		private String version;

		private boolean isValid() {
			return (name != null && !name.isEmpty() && bundleId != null && !bundleId.isEmpty()
					&& version != null && !version.isEmpty());
		}
	}

	private void printTable(PrintStream out, String... resources) throws IOException {
		for ( String resource : resources ) {
			Path path = Paths.get(resource);
			if ( Files.isDirectory(path) ) {
				Files.walk(path).filter(p -> !Files.isDirectory(p)).forEach(p -> {
					if ( p.getFileName().toString().endsWith(".jar") ) {
						extractManifestInfo(p);
					}
				});
			} else if ( path.getFileName().toString().endsWith(".jar") ) {
				extractManifestInfo(path);
			}
		}
		String fmt = "| %-" + widths[0] + "s | %-" + widths[1] + "s | %-" + widths[2] + "s |";
		out.println(String.format(fmt, "Name", "ID", "Vers"));
		for ( int i = 0; i < widths.length; i++ ) {
			out.print("|:");
			for ( int j = 0, len = widths[i] + 1; j < len; j++ ) {
				out.print('-');
			}
		}
		out.println('|');
		for ( BundleInfo info : bundles.values() ) {
			out.println(String.format(fmt, info.name, info.bundleId, info.version));
		}
	}

	private static String NODE_PREFIX = "net.solarnetwork.node.";
	private static String SN_PREFIX = "net.solarnetwork.";

	private static String compressedBundleId(String id) {
		if ( id.startsWith(NODE_PREFIX) ) {
			return "n.s.n." + id.substring(NODE_PREFIX.length());
		} else if ( id.startsWith(SN_PREFIX) ) {
			return "n.s." + id.substring(SN_PREFIX.length());
		}
		return id;
	}

	private static String compressedBundleVersion(String vers) {
		int count = 0, idx = -1;
		while ( (idx = vers.indexOf('.', idx + 1)) >= 0 ) {
			count++;
			if ( count > 2 ) {
				return vers.substring(0, idx);
			}
		}
		return vers;
	}

	private void extractManifestInfo(Path resource) {
		try (JarInputStream in = new JarInputStream(Files.newInputStream(resource))) {
			Manifest mf = in.getManifest();
			Attributes main = mf.getMainAttributes();
			BundleInfo info = new BundleInfo();
			info.name = main.getValue(BUNDLE_NAME);
			info.bundleId = compressedBundleId(main.getValue(BUNDLE_ID));
			info.version = compressedBundleVersion(main.getValue(BUNDLE_VERS));
			if ( info.isValid() ) {
				bundles.put(info.name.toLowerCase(), info);
				if ( info.name.length() > widths[0] ) {
					widths[0] = info.name.length();
				}
				if ( info.bundleId.length() > widths[1] ) {
					widths[1] = info.bundleId.length();
				}
				if ( info.version.length() > widths[2] ) {
					widths[2] = info.version.length();
				}
			}
		} catch ( IOException e ) {
			throw new RuntimeException(e);
		}
	}

	/**
	 * Main entry point.
	 * 
	 * @param args
	 *        the resources to process
	 */
	public static void main(String[] args) {
		if ( args == null || args.length < 1 ) {
			System.err.println("Pass file or directory names of bundles to read.");
			System.exit(1);
		}
		try {
			new TableGenerator().printTable(System.out, args);
		} catch ( IOException e ) {
			System.err.println("Error printing table: " + e.toString());
			System.exit(1);
		}
	}

}
