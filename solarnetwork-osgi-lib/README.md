# SolarNetwork Build Support

## Unit tests

The `test.xml` Ant build script can be used to run unit tests for all the SolarNetwork
bundles. The **test-all-clean** target will run the tests. It helps to give Ant a good
amount of memory to run the tests. Here's an example of running the tests:

	ANT_OPTS=-Xmx2g ant -f test.xml test-all-clean
	
Once the tests have run, you can generate a report via the **test-report** target:

	ANT_OPTS=-Xmx2g ant -f test.xml test-report

You can include test coverage statistics when running the tests by including a
`-Dwith-coverage=yes` option when running the tests:

	ANT_OPTS=-Xmx2g ant -Dwith-coverage=yes -f test.xml test-all-clean

A coverage report can then be generated via the **coverage-report-all** target:

	ANT_OPTS=-Xmx2g ant -Dwith-coverage=yes -f test.xml coverage-report-all
