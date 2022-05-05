nrelPredictiveAnalyticsExt: Interface extension for predictive analytics tools
==============================================================================

**nrelPredictiveAnalyticsExt** (name subject to change) is a [SkySpark]
extension for interfacing with the [Python]-based predictive analytics
algorithms developed by NREL's Intelligent Campus team. At this time, the
extension is for NREL internal use only. This package is developed and
maintained by the [National Renewable Energy Laboratory].

[SkySpark]: http://skyfoundry.com/skyspark/ "SkySpark"
[Python]: https://www.python.org/ "Python Programming Language"
[National Renewable Energy Laboratory]: https://www.nrel.gov "NREL Website"

Build
-----

Build instructions:

1. Create a local clone of this repository on a computer with a working copy of SkySpark.
2. From the command line, change directory to the SkySpark root directory.
3. Execute `bin/fan /path/to/nrelPredictiveAnalyticsExt/build.fan`.
   - On Linux, you may need to `chmod +x bin/fan` first.
   - Output pod will be `lib/fan/nrelPredictiveAnalyticsExt.pod` (relative to
     SkySpark root).
4. Execute `bin/fan docgen` to regenerate documentation.

Build instructions are the same for Windows except paths use backslashes `\`
and `fan` becomes `fan.bat`.

Note that all dependencies need to be in `lib/fan` (relative to SkySpark root);
the build script will not find pods located in `var/lib/fan`.
   
Installation
------------

Select a set of installation instructions below that corresponds to how you
obtained the **nrelPredictiveAnalyticsExt** extension. Following installation,
you must enable the *nrelPredictiveAnalytics* extension in the *Exts* tab of the
SkySpark *Settings* app within each project that needs access to the functions.

### From Source ###

If you built from source, all that is needed to install the extension is to
start (or restart) SkySpark.

### From GitHub ###

**TO DO** (Adapt text from [nrelUtilityExt])

[nrelUtilityExt]: https://github.com/NREL/nrelUtilityExt/

### From StackHub ###

**TO DO** (Future)

Prerequisites
-------------

To use **nrelPredictiveAnalyticsExt**, you must have:

1. Docker installed and working with SkySpark
2. A local Docker image built from the NREL [intelligentcampus-pred-analytics]
   repo registered with a tag you can access from SkySpark (e.g. "intelcamp")

**TO DO:** Put more instructions here.

[intelligentcampus-pred-analytics]: https://github.com/NREL/intelligentcampus-pred-analytics/

Documentation
-------------

Function documentation is available in the SkySpark *Doc* app under
*nrelPredictiveAnalytics* or within the *Docs* interface in the *Code* app.

Develop
-------

**nrelPredictiveAnalyticsExt** is a SkySpark resource extension, that is, it
provides the set of [Axon] functions as a resource for SkySpark users. The
functions are stored in the [Trio]-formatted files within `lib/`:

- `taskFuncs.trio`: Functions used to define Python interaction task(s)
- `pythonFuncs.trio`: Functions for interacting with Python (internal use)
- `supportFuncs.trio`: Other supporting functions (internal use)

The simplest development workflow is to import these functions into SkySpark,
make changes *Code* app (and test via *Tools*), export back to Trio format, and
update the corresponding file(s) in the repo. Workflows for importing functions
to SkySpark and exporting functions from SkySpark are described below. For more
guidance on developing resource extensions, see the [SkyFoundry Resource
Extension App Note].

[Axon]: https://haxall.io/doc/appendix/axon "Axon documentation"
[Trio]: https://project-haystack.org/doc/docHaystack/Trio "Trio file format"
[SkyFoundry Resource Extension App Note]: https://skyfoundry.com/doc/docAppNotes/CreateResourceExtension

### Importing to SkySpark ###

*Note:* All paths below are relative to repository root directory.

1. Launch SkySpark and log in with an admin or superuser account.

2. Create a project to use for development. (These instructions assume your
   project is named "pred_test".)

3. Within the *Tools* app, *Files* tab, upload some or all of following files
   from `lib/` directory to `proj > pred_test > io`, according to your
   development needs:
   
   - `taskFuncs.trio`
   - `pythonFuncs.trio`
   - `supportFuncs.trio`

4. (Optional) Pick a marker (or "flag") tag to attach to each imported function
   to facilitate easy querying for later export. 
   
   - These instructions assume your flag tag is `predAnalyticsDev`.
   - For organization, you may want to use a different flag tag for each file.

5. In the *Tools* app, *Shell* tab, execute the following for each file `x.trio`
   that contains functions you need to import:
   
   ```
   ioReadTrio(`io/x.trio`).map(rec => diff(null, rec.merge({predAnalyticsDev}), {add})).commit
   ```
   
   Alternatively, if you are not using a flag tag:
   
   ```
   ioReadTrio(`io/x.trio`).map(rec => diff(null, rec), {add})).commit
   ```

6. To verify that the functions were successfully imported, ceck the *Code* app
   or query for them via the *Shell*:
   
   ```
   readAll(func)
   ```
   
   or
   
   ```
   readAll(func and predAnalyticsDev)
   ```

Note that if any of the imported functions has a name conflict with an existing
function, then both versions will now be present in your project database. You
will need to manually resolve any conflicts by removing or renaming the
duplicate function record(s).
   
### Exporting from SkySpark ###

*Note:* All paths below are relative to repository root directory.

1. In SkySpark, construct a query that returns the function(s) you wish to
   export. If you used a flag tag during import (e.g. `predAnalyticsDev`), your
   query will probably look something like this:
   
   ```
   func and predAnalyticsDev
   ```
   
   (If you did not use a flag tag, you will need a different query, such as
   specifying the name or each function combined with the `or` keyword.)
   
   You can test your query from the *Tools* app, *Shell* tab, by executing it
   directly and inspecting the records that SkySpark returns.
   
2. In the *Tools* app, *Shell* tab, execute the following code to query your
   functions and export them to a Trio file.

  ```
  readAll(func and predAnalyticsDev).removeCols(["id","predAnalyticsDev","mod"]).ioWriteTrio(`io/x.trio`)
  ```

  - The query within `readAll()` should match what you developed in Step 1 above
  - Modify `x.trio` to the desired name of your output file
  - If you did not use a flag tag, modify the `removeCols()` part of the call
    to: `removeCols(["id","mod"])`
   
3. Download `x.trio` from SkySpark via the *Tools* app, *Files* tab (or copy it
   via your file system), then place it in the `lib/` directory.

4. Commit to Git.

Alternative Workflow:

1. Develop your query per Step 1 above

2. In the *Tools* app, *Shell* tab, execute the following code to query your
   functions and prepare them for export:
   
  ```
  readAll(func and predAnalyticsDev).removeCols(["id","predAnalyticsDev","mod"])
  ```

  - The query within `readAll()` should match what you developed in Step 1 above
  - If you did not use a flag tag, modify the `removeCols()` part of the call
    to: `removeCols(["id","mod"])`

3. On the right-hand side of the *Shell*, find the view select button (it will
   likey say "Table") and change it to "Trio".

4. Manually copy the Trio-formatted function record(s) from the *Shell* to the
   relevant file(s) in the `lib/` directory, replacing the existing versions
   as applicable.

License
-------

NREL internal use only

