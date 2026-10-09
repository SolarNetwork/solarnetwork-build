/* ==================================================================
 * MarkdownFormat.java - 10/10/2026 9:05:00 am
 *
 * Copyright 2026 SolarNetwork.net Dev Team
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

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension;
import com.vladsch.flexmark.ext.gfm.tasklist.TaskListExtension;
import com.vladsch.flexmark.ext.tables.TablesExtension;
import com.vladsch.flexmark.formatter.Formatter;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.parser.ParserEmulationProfile;
import com.vladsch.flexmark.util.ast.Node;
import com.vladsch.flexmark.util.data.MutableDataSet;

/**
 * Format GitHub flavored Markdown files into a consistent style.
 *
 * <p>
 * This program uses the flexmark-java formatter included in
 * {@code flexmark-all-lib.jar}, with the GFM table, strikethrough, and task
 * list extensions enabled. Tables are aligned, list markers and indentation
 * are normalized, and headings use the ATX ({@code #}) style. Line breaks in
 * paragraphs are preserved, and embedded HTML is left as-is. Run it as a
 * single-file source program:
 * </p>
 *
 * <pre>
 * java -cp flexmark-all-lib.jar MarkdownFormat.java [--recursive] [--verbose] README.md
 * </pre>
 *
 * <p>
 * Each target can be a Markdown file, or a directory to format all
 * {@code .md} files in (including those in sub-directories if
 * {@code --recursive} is given).
 * </p>
 *
 * @author matt
 * @version 1.0
 */
public class MarkdownFormat {

	private static final String USAGE = "Usage: MarkdownFormat [--recursive] [--verbose] <target>...";

	/**
	 * Format Markdown files.
	 *
	 * @param args
	 *        the arguments
	 * @throws Exception
	 *         if any error occurs
	 */
	public static void main(String[] args) throws Exception {
		boolean recursive = false;
		boolean verbose = false;
		final List<Path> targets = new java.util.ArrayList<>();
		for ( String arg : args ) {
			if ( arg.equals("-r") || arg.equals("--recursive") ) {
				recursive = true;
			} else if ( arg.equals("-v") || arg.equals("--verbose") ) {
				verbose = true;
			} else if ( !arg.startsWith("-") ) {
				targets.add(Path.of(arg));
			} else {
				System.err.println(USAGE);
				System.exit(1);
			}
		}
		if ( targets.isEmpty() ) {
			System.err.println(USAGE);
			System.exit(1);
		}

		final MutableDataSet options = new MutableDataSet();
		options.setFrom(ParserEmulationProfile.GITHUB);
		// keep the leading whitespace of code content exactly as written
		options.set(Formatter.FENCED_CODE_MINIMIZE_INDENT, false);
		options.set(Formatter.INDENTED_CODE_MINIMIZE_INDENT, false);
		options.set(Parser.EXTENSIONS, Arrays.asList(TablesExtension.create(),
				StrikethroughExtension.create(), TaskListExtension.create()));
		final Parser parser = Parser.builder(options).build();
		final Formatter formatter = Formatter.builder(options).build();

		for ( Path target : targets ) {
			final List<Path> files;
			try (Stream<Path> paths = Files.walk(target, recursive ? Integer.MAX_VALUE : 1)) {
				files = paths.filter(p -> p.toString().endsWith(".md") && Files.isRegularFile(p))
						.sorted().toList();
			}
			for ( Path file : files ) {
				if ( format(parser, formatter, file) && verbose ) {
					System.out.println("Formatted " + file);
				}
			}
		}
	}

	/**
	 * Format a Markdown file.
	 *
	 * @param parser
	 *        the parser to use
	 * @param formatter
	 *        the formatter to use
	 * @param file
	 *        the file to format
	 * @return {@literal true} if the file was changed
	 * @throws IOException
	 *         if the file cannot be read or written
	 */
	private static boolean format(Parser parser, Formatter formatter, Path file) throws IOException {
		final String source = Files.readString(file);
		final Node document = parser.parse(source);
		final String result = formatter.render(document);
		if ( result.equals(source) ) {
			return false;
		}
		Files.writeString(file, result);
		return true;
	}

}
