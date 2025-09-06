# Maven deployment scripts

The purpose of these scripts is to produce a set of PGP-signed jars and
POM files for deployment to Maven Central.

  http://search.maven.org

Because the jogamp projects do not use Maven to manage their own builds
(and it would be too much work for very little gain to convert the build
system over to Maven), these scripts take an archive of already-released
jar files and produce renamed jar files and POM files as output, ready
for deployment to the repository.

These instructions assume that you know how to set up a PGP agent [0].

In order to get packages onto Maven Central, it's necessary to have an
account on one of the large Java "forges". The most-used one seems to be
Sonatype. See the repository usage guide [1] for details on getting an
account.

## Prerequisites

Close `maven-wagon` branch [wagon-3.x](https://github.com/sgothel/maven-wagon/tree/wagon-3.x)
and install locally via

```
mvn install -Dmaven.test.skip
```

This satisfies out dependencies to `wagon-ssh-external` version `3.5.4-SNAPSHOT`,
as this version contains a required patch to allow processing relative file names.

- [patch](https://github.com/sgothel/maven-wagon/commit/e8ffd1535177b3aa00c4f726d92d957aa29cab31)
- [merge request](https://github.com/apache/maven-wagon/pull/817)

## Instructions (deploying a release to Central)

  1. Obtain the jogamp-all-platforms.7z release for the version
     of jogamp you wish to deploy to Central. As an example, we'll
     use 2.3.0. Unpack the 7z file to the 'input' subdirectory,
     creating it if it doesn't exist:

    $ mkdir input
    $ cd input
    $ wget http://jogamp.org/deployment/v2.3.0/archive/jogamp-all-platforms.7z
    $ 7z x jogamp-all-platforms.7z

  2. Switch back to the old directory:

    $ cd ..

  3. Maven [$HOME/.m2/settings.xml](settings.jogamp.xml) excerpt

```
     <?xml version="1.0" encoding="UTF-8"?>
     <settings
       xmlns="http://maven.apache.org/SETTINGS/1.0.0"
       ... >
       <profiles>
         <profile>
           <id>jogamp-sonatype</id>
           <activation>
             <activeByDefault>false</activeByDefault> <!-- change this to false, if you don't like to have it on per default -->
             <property>
               <name>repositoryId</name>
               <value>jogamp-sonatype</value>
             </property>
           </activation>
           <properties>
             <gpg.useagent>true</gpg.useagent>
             <gpg.keyname>JogAmp Maven Deployment</gpg.keyname>
             <gpg.bestPractices>true</gpg.bestPractices>
           </properties>
           <repositories>
             <repository>
               <id>jogamp-sonatype</id>
               <name>jogamp sonatype</name>
               <url>https://oss.sonatype.org/service/local/staging/deploy/maven2/</url>
               <layout>default</layout>
             </repository>
           </repositories>
         </profile>
       </profiles>
       <servers>
         <server>
           <id>jogamp-sonatype</id>
           <username>USERNAME</username>
           <password>PASSWORD</password>
         </server>
       </servers>

     </settings>
```


  4. The Central repository requires PGP signatures on all files
     deployed to the repository. Because we'll be signing a lot
     of files, we need this to occur in the most automated manner
     possible. Therefore, we need to tell Maven which PGP key to
     use and also to tell it to use any running PGP agent we have.
     To do this, we have to add a profile to [$HOME/.m2/settings.xml](settings.jogamp.xml)
     that sets various properties that tell the PGP plugin what
     to do.

    I've defined a new profile called `jogamp-sonatype`,
    which is enabled if the `repositoryId` equals `jogamp-sonatype`.

    This profile enables the use of a PGP agent, and uses the string
    `JogAmp Maven Deployment` to tell PGP which key to use.
    You can obviously use the fingerprint of the key here too
    (or anything else that uniquely identifies it).

    See: http://www.sonatype.com/books/mvnref-book/reference/profiles.html

  5. Now, run make.sh with the desired version number to generate POM
     files and copy jar files to the correct places:

      $ ./make.sh 2.3.0

  6. The scripts will have created an 'output' directory, containing
     all the prepared releases. It's now necessary to deploy the releases,
     one at a time [2]. Assuming that our Sonatype username is 'jogamp'
     and our password is `********`, we need to edit settings.xml
     to tell Maven to use them both, see `server` id `jogamp-sonatype` above.

  6. Now we can deploy an individual project to the staging repository:

      $ ./make-deploy-one.sh gluegen-rt-main 2.3.0

     Or deploy all of the projects defined in make-projects.txt:

      $ ./make-deploy.sh 2.3.0

     The scripts will upload all necessary jars, poms, signatures, etc.

  7. Now, we need to tell the Sonatype repository that we wish to actually
     promote the uploaded ("staged") files to a release. This step (unfortunately)
     doesn't seem to be possible from the command line.

     Log in to https://oss.sonatype.org using the 'jogamp:********' username
     and password.

     Click 'Staging repositories' in the left navigation bar.

     In the main pane, there should now be a table of repositories. Because
     we've just uploaded a set of files, there should be one entry (staging
     repositories are automatically created when files are uploaded).

     Click the checkbox to the left of the repository name. This will open
     a 'repository browser' below the main view, showing a tree of files.
     Inspect the tree of files to be sure that all of the necessary files are
     present.

     If all files are there, and assuming that the checkbox is still selected
     from the previous step, click the 'Close' button above the repository
     browser - this will 'close' the staging repository (meaning no new files
     can be added). Then click 'Release' when you absolutely positively want
     to commit. The release will be made official and the files synced to
     the Central repository within two hours.

     If there are still more projects to release, return to step 6.

## Projects

The way that Maven works demanded a certain structure to the projects
produced. The requirements were:

  1. The end-user of the jogamp projects released to the repository
     must not have to do anything beyond adding one or two dependencies
     to their own projects. Everything must work using only the basic
     dependency resolution mechanism that Maven supports and must not
     require anything complex in the way of build scripts.

  2. The way that jogamp projects locate their own jar files must
     work as it always had.

The first requirement was reasonably easy to satisfy (and the details
of which will be covered shortly). The second requirement was complicated
by the fact that Maven unconditionally appends version numbers to jar
files (and requires the numbers to be present in order for the dependency
resolution to work). After trying various approaches, a small change was
made to the jogamp code in order to allow it to cope with version numbers,
and the Maven projects were carefully structured to produce jar files
with usable names. In other words, we had to essentially write Maven
POM files that, when "deployed", produced jar files with the correct
names, using a variety of tricks. The other issue was that jogamp implicitly
assumed that all of the jar files would be in the same directory, whereas
Maven essentially assumes one directory per jar file.

We ended up with the following structure: For each part of jogamp that
had associated native binaries (contained within jar files), a project
was created. Then, using the "classifiers" [3], each of the native jar
files were deployed along with the main jar file for each project. Using
'gluegen-rt' as an example:

  The main jar file as part of jogamp is "gluegen-rt.jar". When
  "deployed" by Maven, this becomes "gluegen-rt-${VERSION}.jar".

  Each native jar file associated with gluegen-rt is named
  "gluegen-rt-natives-${OS}-${ARCH}.jar". We use "classifiers" to
  get Maven to "deploy" jar files with the correct names:

```
    PLATFORMS="linux-amd64 linux-i586 ..."
    for PLATFORM in ${PLATFORMS}
    do
      CLASS="natives-${PLATFORM}"
      mvn gpg:sign-and-deploy-file \
        -Dfile="gluegen-rt-${VERSION}-natives-${PLATFORM}.jar \
        -Dclassifier="natives-${PLATFORM}"
    done
```

  Assuming version 2.3.0, this results in:

  - gluegen-rt-2.3.0.jar
  - gluegen-rt-2.3.0-natives-linux-amd64.jar
  - gluegen-rt-2.3.0-natives-linux-i586.jar
  - ...

This results in a project with a main jar and a set of native jar
files, each with the correct name and version. As the native jar
files are implicitly part of the same "project", they're deployed
in the same directory as the main jar file, and the jogamp code can
locate them without issue.

The problem with this approach is that the end-user would have
to add an explicit dependency on "gluegen-rt" and each and every
one of the associated native jars in their project's POM file! The
simplest solution for this problem was to create a second project
that contained explicit dependencies on all of the classified jar
files of the first. The end-user then simply adds a dependency on
this second project instead of the first, and everything is resolved
automatically by Maven. This second project also contains an empty
"dummy" jar file in order to allow Maven to deploy it to repositories.

With that in mind, each part of Maven therefore has an associated
"-main" project, meant to be used by end-users. This "-main" project,
when added to the dependencies of any project, pulls in all of the
real jogamp jars, native or otherwise.

## Test suite

The scripts now include a basic test suite for checking that the
produced packages actually work in Maven.

Assuming that the packages have been created with the ./make.sh script
above:

  1. Generate project files for the tests:

    $ ./make-tests.sh 2.3.0

  2. Deploy packages to a local directory for the unit tests
     to use:

     $ ./make-tests-deploy.sh 2.3.0

  3. Run the tests.

    $ ./make-tests-run.sh

## Notes

We're currently uploading empty jar files for the "sources" and
"javadoc" jars required by Central. The rules state that these
files are required unconditionally, but may be empty in the case
that there aren't sources or javadoc. It'd be nice to provide real
sources and javadoc one day.

## Footnotes

[0] [Invoking GPG](http://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html)

[1] [Sonatype OSS Maven Repo Guide](https://docs.sonatype.org/display/Repository/Sonatype+OSS+Maven+Repository+Usage+Guide)

[2] Sonatype seems to have the restriction that it's only possible to
    deploy one 'artifactId' at a time - that translates to deploying one
    jogamp project at a time.

[3] [Maven Deploy Plugin](https://maven.apache.org/plugins/maven-deploy-plugin/examples/deploying-with-classifiers.html)

[4] `maven-wagon` branch [wagon-3.x](https://github.com/sgothel/maven-wagon/tree/wagon-3.x)

