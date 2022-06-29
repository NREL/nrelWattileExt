SkySpark Resources for Deployment Testing
=========================================

This directory contains database records, point history, and functions that
implement a replicable SkySpark test environment for testing the deployment of
predictive analytics models for building time series data. Optionally, the
setup script also imports the SkySpark functions from `lib/` to facilitate
extension development.

Directory Structure
-------------------

This directory (`test/`) includes the following files:

- `example_funcs.trio`: Example SkySpark [Axon] functions for data interaction;
  for SkySpark import
- `folio_records.trio`: SkySpark database records for predictors and targets;
  for SkySpark import
- `folio_his.zinc`: Point history in Haystack [Zinc] format; for reference
- `README.md`: This README document
- `reference_funcs.trio`: SkySpark [Axon] functions included for reference only;
  not used in the test environment
- `setup.trio`: SkySpark [Axon] function for automated setup of the SkySpark
  test environment (see *Instructions* below)

In addition, the repository's `lib/` directory includes files that define
the SkySpark extension's Axon functions; these can be imported for development
as an optional step.

All `*.trio` files are encoded in Haystack [Trio] format.

[Zinc]: https://project-haystack.org/doc/docHaystack/Zinc "Zinc file format"
[Trio]: https://project-haystack.org/doc/docHaystack/Trio "Trio file format"
[Axon]: https://haxall.io/doc/appendix/axon "Axon documentation"

Setup Instructions
------------------

### Prerequisites ###

1. SkySpark installation (version 3.1.3+) with superuser permissions (must be
   able to install packages and create new projects)
2. The **nrelWattileExt** extension built and installed in SkySpark (unless you
   manually import the relevant functions or use the 'developer' option during
   setup; see below).
3. Docker installed and running (not needed for setup; needed for running the
   example code)
4. A local Docker image built using the [Wattile] repo and tagged as "wattile"

[Wattile]: https://github.com/NREL/wattile/

### Setup Instructions ###

1. Launch SkySpark and log in with a superuser account

2. From the host interface, create a new empty project with the following
   metadata:
   
   1. **name:** "wattile_test" (required)
   2. **dis:** "Wattile Test" (optional)
   3. **doc:** "SkySpark test environment for Wattile interaction using Python and Docker" (optional)

   Note: if the default project name "wattile_test" is altered, remember to use
   the new name where applicable in each of the following steps.

3. Navigate to the new *Wattile Test* project you just created

4. Within the *Settings* app, *Exts* tab, enable the `docker`, `py`, and
   `task` exts.

5. Unless you plan to import the required **nrelWattileExt** functions
   separately (see *Notes*), within the *Settings* app, *Exts* tab, also enable
   `nrelWattile`. 

6. Within the *Tools* app, *Files* tab, upload the following files from this
   directory to `proj > wattile_test > io`:
   
   1. `setup.trio`
   2. `example_funcs.trio`
   3. `folio_records.trio`
   4. `folio_his.zinc`
   
   Alternatively, transfer these files manually to your SkySpark project's `io`
   directory using your operating system. (If you intend to develop the
   extension functions, also upload the TRIO files from the repository's `lib/`
   directory now. See *Notes*.)

7. To import the setup function `testEnvironmentSetup()`, execute the following
   command in the *Tools* app, *Shell* tab:
   
   ```
   ioReadTrio(`io/setup.trio`).map(rec => diff(null, rec, {add})).commit
   ```
   
   (If the setup function already exists in the current project, skip this step
   or remove the existing function first. Otherwise you will end up with a
   duplicate setup function.)

8. In the *Tools* app, *Shell* tab, execute the newly imported
   `testEnvironmentSetup()` function:
   
   ```
   testEnvironmentSetup()
   ```
   
   See *Notes* below for some configuration options you can pass to the
   `testEnvironmentSetup()` function.

To check that the test environment is correctly configured, you can run the
following command from the SkySpark  after completing steps 1-8 above:

```
readAll(point and his).hisRead(2021-12-01)
```

You should see a time series plot of eight total points: seven weather points
and one power point named "Synthetic Site Electricity Main Total Power".

### Notes ###

1. To ensure maximum replicability, the `testEnvironmentSetup()` function
   commits records with fixed unique IDs. Therefore, step 7 above *must* be
   executed in a clean project; otherwise the setup function will throw the
   error: `folio::CommitErr: Rec already exists`. To completely clear an
   existing project and re-import the test environment, pass the `resetProject`
   option to `testEnvironmentSetup()`:
   
   ```
   testEnvironmentSetup({resetProject})
   ```
   
   **Warning:** This will completely remove all `weatherStation`, `site`,
   `equip`, `point`, and `task` records in the current project and will
   overwrite existing example functions. Use with caution!

2. Executing the example code you just imported requires that you either have
   **nrelWattileExt** built, installed, and enabled; or that you have manually
   imported the extension's functions (located in the files in `lib/`) into the
   SkySpark database. (Manually importing the functions is best for development;
   see the top-level **README**.) The `testEnvironmentSetup()` function can
   facilitate importing the files from `lib/`:
   
   1. Upload the TRIO files from `lib/` into SkySpark during Step 6 above.
   
   2. In Step 8 above, supply the `developer` marker tag as an option:

      ```
      testEnvironmentSetup({developer})
      ```
   
   See the top-level **README** for instructions on exporting modified versions
   of the functions to include in the extension codebase.

3. If you need to replace any existing files (`setup.trio`,
   `example_funcs.trio`, `folio_records.trio`, etc.) after initially uploading
   them via the SkySpark *Tools* app, you must first delete the existing
   versions. Otherwise, SkySpark will make a new copy with an integer suffix
   rather than overwriting the existing version.)
   
Getting Started
---------------

After setup, to get started, first start Docker (if it isn't alreay running).
Then, inspect and run the following functions:

1. `task(@p:wattile_test:r:29e7afcb-0fcefdd7).examplePythonInteraction`
2. `task(@p:wattile_test:r:2a06ba36-9cf5ad53).testPrepDataV4`

You can also try `testPrepDataV5`.