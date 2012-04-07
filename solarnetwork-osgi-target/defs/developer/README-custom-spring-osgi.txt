We're using a modified version of Spring DM, to add functionality to the 
org.springframework.osgi.compendium.internal.cm.ManagedServiceFactoryFactoryBean
by adding service properties to the registered services.

To build the custom Spring DM core bundle, execute something like:

mvn -Denv.buildPlan=MSM -Denv.svnRevision=MSM -Denv.buildNumber=20120322A -P equinox install
