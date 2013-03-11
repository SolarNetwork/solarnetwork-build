Virgo 3.6 Deployment
====================

This build script is designed for deploying into the Virgo 3.6 server.
Run the *archive* task to create an archive of bundles suitable for
expanding in the root Virgo directory. You must create a 
*build.properties* file and an *ivy.xml* file in this directory to
specify which bundles and dependencies you want to include in the
server runtime. Copy the *example/build.properties* and 
*example/ivy.xml* file to this directory and use as a starting 
point.

Virgo can easily run into class loading deadlocks if you're not
careful with how the bundles are deployed. I've had success by
adding

	,repository:plan/net.solarnetwork.central.env.plan
	
to the *initialArtifacts* property in Virgo's 
*configuration/org.eclipse.virgo.kernel.userregion.properties* file
and then deploying the remaining plans via Virgo's *pickup* directory.
