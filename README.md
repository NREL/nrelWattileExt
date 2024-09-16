nrelWattileExt: Interface extension for Wattile Python package
==============================================================

**nrelWattileExt** is a [SkySpark] extension for interfacing [Wattile], a
[Python] package for probabilistic prediction of building energy use developed
by NREL's Intelligent Campus team. This package is developed and maintained by
the [National Renewable Energy Laboratory].

[SkySpark]: http://skyfoundry.com/skyspark/ "SkySpark"
[Wattile]: https://github.com/NREL/wattile/ "Wattile"
[Python]: https://www.python.org/ "Python Programming Language"
[National Renewable Energy Laboratory]: https://www.nrel.gov "NREL Website"

Build
-----

Build instructions:

1. Create a local clone of this repository on a computer with a working copy of SkySpark.
2. From the command line, change directory to the SkySpark root directory.
3. Execute `bin/fan /path/to/nrelWattileExt/build.fan`.
   - On Linux, you may need to `chmod +x bin/fan` first.
   - Output pod will be `lib/fan/nrelWattileExt.pod` (relative to
     SkySpark root).
4. Execute `bin/fan docgen` to regenerate documentation.

Build instructions are the same for Windows except paths use backslashes `\`
and `fan` becomes `fan.bat`.

Note that all dependencies need to be in `lib/fan` (relative to SkySpark root);
the build script will not find pods located in `var/lib/fan`.

Installation
------------

Select a set of installation instructions below that corresponds to how you
obtained the **nrelWattileExt** extension. Following installation, you must
enable the *nrelWattile* extension in the *Exts* tab of the SkySpark *Settings*
app within each project that needs access to the functions.

### From Source ###

If you built from source, all that is needed to install the extension is to
start (or restart) SkySpark.

### From GitHub ###

1. Download a `nrelWattileExt.pod` release from GitHub.
2. Copy `nrelWattileExt.pod` into the `lib/fan/` directory of your SkySpark
   installation.
3. Set ownership permissions correctly on the pod to match the other pods in
   your SkySpark installation (Linux/Mac).
4. From the command line, change directory to the SkySpark root directory.
5. Execute `bin/fan docgen` to regenerate documentation.
   - Optional; the functions will work without this step but the *Doc* app won't
     show any function documentation.
   - On Linux, you may need to `chmod +x bin/fan` first.
6. Start (or restart) SkySpark.

### From StackHub ###

**TO DO** (Future)

Prerequisites
-------------

To use **nrelWattileExt**, you must have:

1. [Docker] installed and working with SkySpark
2. A local Docker image built from the [nrelWattileExt] repo registered with a
   tag you can access from SkySpark (e.g. `"wattile"`); see *Docker* below

[Docker]: https://www.docker.com/ "Docker"
[nrelWattileExt]: https://github.com/NREL/nrelWattileExt "nrelWattileExt"

For more information, see the **nrelWattileExt** documentation within SkySpark.

Docker
------

To build the required Docker image containing [Wattile]:

1. Install and launch [Docker]
2. Clone the [nrelWattileExt] repository branch or release corresponding to your
   current **nrelWattileExt** version
3. From the repository root directory, run:
     
   ```
   docker build --tag="wattile" .
   ```
   
   Optionally, to specify a Wattile release version or branch other than
   the default:
   
   ```
   docker build --build-arg="WATTILE_RELEASE=X.Y.Z" --tag="wattile" .
   ```
   
   or
   
   ```
   docker build --no-cache --build-arg="WATTILE_BRANCH=branch" --tag="wattile" .
   ```
   
   (The `--no-cache` option is used here to ensure that you do not accidentally
   build from an outdated, cached local copy of the repository.)

If you did not build the Docker image on the same system where SkySpark runs,
you will also need to copy and install the Docker image on your SkySpark system:

1. Run `docker save wattile | gzip > wattile.tar.gz` (this may take a while)
2. Copy `wattile.tar.gz` to the target system
3. Run `docker load --input /path/to/wattile.tar.gz`

The Docker image is now ready for use with SkySpark.

### Linux User Permissions ###

When running a Docker container based on [Hxpy], SkySpark mounts the project
`io/` directory within the Docker container at `/io/`. When SkySpark is running
on Linux, permissions conflicts arise if the user ID (UID) and group ID (GID) of
the user running SkySpark do not match the UID and GID of the user running
Wattile within the Docker container: files and folders owned by the SkySpark
user may not be readable and writable by the Wattile user and vice versa.

[Hxpy]: https://haxall.io/doc/lib-py/doc "Hxpy"

**Therefore, when SkySpark is running on Linux, you must use one of the
following options to ensure SkySpark and Wattile share file access:**

1. Build the Docker image such that the container user has the same UID and GID
   as the host system's SkySpark user. If building the image on the host system,
   use:
   
   ```
      docker build \
         --build-arg HOST_UID="$(id -u)" \
         --build-arg HOST_GID="$(id -g)" \
         ...
   ```
   
   Where `...` represents the remaining build options or arguments (see above).
   
   If building the image on a different system, first identify the UID and GID
   of the SkySpark user be executing the `id` command on the host system. Then,
   with the `uid` and `gid` numbers from the host system, run:
   
   ```
      docker build \
         --build-arg HOST_UID="uid" \
         --build-arg HOST_GID="gid" \
         ...
   ```
   
   This is the recommended option.

2. Run SkySpark as a user whose UID and GID match the defaults from Wattile
   Docker image:
   
   - UID = 1022
   - GID = 1022
   
   This option will work, but changing the SkySpark user may have unintended
   consequences (such as breaking access permissions for existing files).
   
3. Modify ownership for the `io/` directory to be readable and writable by
   others: `chmod o+wrx /path/to/io/`. This option will also work but is
   discouraged for security reasons.

Documentation
-------------

Function documentation is available in the SkySpark *Doc* app under
*nrelWattile* or within the *Docs* interface in the *Code* app.

Develop
-------

**nrelWattileExt** is a SkySpark resource extension, that is, it provides the
set of [Axon] functions as a resource for SkySpark users. The functions are
stored in the [Trio]-formatted files within `lib/`:

- `taskFuncs.trio`: Functions used to define Python interaction task(s)
- `pythonFuncs.trio`: Functions for interacting with Python (internal use)
- `supportFuncs.trio`: Support and convenience functions for interacting with
  Wattile models and their proxy records in SkySpark
- `utilityFuncs.trio`: Other utility functions (internal use)

The simplest development workflow is to import these functions into SkySpark,
make changes *Code* app (and test via *Tools*), export back to Trio format, and
update the corresponding file(s) in the repo. Workflows for importing functions
to SkySpark and exporting functions from SkySpark are described below. These
istructions assume you have the [nrelUtility] extension installed (contains
`importFunctions()` and `exportFunctions()`).

For more guidance on developing resource extensions, see the [SkyFoundry
Resource Extension App Note].

[Axon]: https://haxall.io/doc/appendix/axon "Axon documentation"
[Trio]: https://project-haystack.org/doc/docHaystack/Trio "Trio file format"
[nrelUtility]: https://github.com/NREL/nrelUtilityExt/ "nrelUtility Extension"
[SkyFoundry Resource Extension App Note]: https://skyfoundry.com/doc/docAppNotes/CreateResourceExtension

### Importing to SkySpark ###

*Note:* All paths below are relative to repository root directory.

1. Launch SkySpark and log in with an admin or superuser account.

2. Create a project to use for development and make it the active project.
   (These instructions assume your project is named `"wattile_test"`.)

3. Within the *Settings* app, *Exts* tab, enable:

  - docker
  - py
  - nrelUtility

4. Within the *Tools* app, *Files* tab, upload some or all of following files
   from `lib/` directory to `proj > wattile_test > io`, according to your
   development needs:

   - `taskFuncs.trio`
   - `pythonFuncs.trio`
   - `supportFuncs.trio`
   - `utilityFuncs.trio`

5. (Optional) Pick a marker (or "flag") tag to attach to each imported function
   to facilitate easy querying for later export.

   - These instructions assume your flag tag is `wattileDev`.
   - For organization, you may want to use a different flag tag for each file.

6. In the *Tools* app, *Shell* tab, execute the following for each file `x.trio`
   that contains functions you need to import:

   ```
   importFunctions(`io/x.trio`, {merge:{wattileDev}, commit})
   ```

   Alternatively, if you are not using a flag tag:

   ```
   importFunctions(`io/x.trio`, {commit})
   ```

7. To verify that the functions were successfully imported, ceck the *Code* app
   or query for them via the *Shell*:

   ```
   readAll(func) // All functions
   ```

   or

   ```
   readAll(func and wattileDev) // Flagged functions only
   ```

Note that if any of the imported functions has a name conflict with an existing
function, then both versions will now be present in your project database. You
will need to manually resolve any conflicts by removing or renaming the
duplicate function record(s). Hint: check the function record `mod` tags.

### Exporting from SkySpark ###

*Note:* All paths below are relative to repository root directory.

1. In SkySpark, construct a query that returns the function(s) you wish to
   export. If you used a flag tag during import (e.g. `wattileDev`), your
   query will probably look something like this:

   ```
   func and wattileDev
   ```

   (If you did not use a flag tag, you will need a different query, such as
   specifying the name or each function combined with the `or` keyword.)

   You can test your query from the *Tools* app, *Shell* tab, by executing it
   directly and inspecting the records that SkySpark returns.

2. In the *Tools* app, *Shell* tab, execute the following code to query your
   functions and export them to a Trio file.

  ```
  readAll(func and wattileDev).exportFunctions(`io/x.trio`, {merge:{-wattileDev}})
  ```

  - The query within `readAll()` should match what you developed in Step 1 above
  - Modify `x.trio` to the desired name of your output file
  - If you did not use a flag tag, you do not need to remove it with the `merge`
    option of `exportFunctions()`.

3. Download `x.trio` from SkySpark via the *Tools* app, *Files* tab (or copy it
   via your file system), then place it in the `lib/` directory.

4. Commit to Git.

Alternative Workflow:

1. Develop your query per Step 1 above

2. In the *Tools* app, *Shell* tab, execute the following code to query your
   functions and prepare them for export:

  ```
  readAll(func and wattileDev).exportFunctions(null, {preview, merge:{-wattileDev}})
  ```

  - The query within `readAll()` should match what you developed in Step 1 above
  - If you did not use a flag tag, you do not need to remove it with the `merge`
    option of `exportFunctions()`.

3. On the right-hand side of the *Shell*, find the view select button (it will
   likey say "Table") and change it to "Trio".

4. Manually copy the Trio-formatted function record(s) from the *Shell* to the
   relevant file(s) in the `lib/` directory, replacing the existing versions
   as applicable.

### Test Environment ###

The `test/` subdirectory contains resources and instructions for setting up a
minimal SkySpark test environment for developing and testing functions and workflows related to **nrelWattileExt**.

License
-------

This software is licensed for use under the terms of the Berkeley Software
Distribution 3-clause (BSD-3) license; see `LICENSE.md`. NREL software record
number: SWR-24-73.

