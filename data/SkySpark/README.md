SkySpark Project for Deployment Testing
=======================================

This directory contains database records, point history, and functions that
implement a replicable SkySpark test environment for testing the deployment of
predictive analytics models for building time series data.

Directory Structure
-------------------

- `example_funcs.trio`: Example SkySpark [Axon] functions for data interaction;
  for SkySpark import
- `folio_records.trio`: SkySpark database records for predictors and targets;
  for SkySpark import
- `folio_his.zinc`: Point history in Haystack [Zinc] format; for reference
- `README.md`: This README document
- `reference_funcs.trio`: SkySpark [Axon] functions included for reference only;
  not used in the test environment
- `setup.trio`: kySpark [Axon] function for automated setup of the SkySpark test
  environment (see *Instructions* below)

All `*.trio` files are encoded in Haystack [Trio] format.

**TO DO:** `example_funcs.trio` should eventually move to a different part of
the repo, especially if we end up packaging this repo as a SkySpark extension?

[Zinc]: https://project-haystack.org/doc/docHaystack/Zinc "Zinc file format"
[Trio]: https://project-haystack.org/doc/docHaystack/Trio "Trio file format"
[Axon]: https://haxall.io/doc/appendix/axon "Axon documentation"

Setup Instructions
------------------

### Prerequisites ###

1. SkySpark installation (version 3.1.3+) with superuser permissions (must be
   able to install packages and create new projects)
2. Docker installed and running (not needed for setup; needed for running the
   example code)

### Setup Instructions ###

1. Launch SkySpark and log in with a superuser account

2. From the host interface, create a new empty project with the following
   metadata:
   
   1. **name:** "pred_test" (required)
   2. **dis:** "Predictive Analytics Test" (optional)
   3. **doc:** "SkySpark test environment for integrating predictive analytics time series models using Python and Docker" (optional)

   Note: if the default project name "pred_test" is altered, remember to use the
   new name where applicable in each of the following steps.

3. Navigate to the new *Predictive Analytics Test* project you just created

4. Within the *Settings* app, *Exts* tab, enable the `docker` and `py` exts.

5. Within the *Tools* app, *Files* tab, upload the following files from this
   directory to `proj > pred_test > io`:
   
   1. `setup.trio`
   2. `example_funcs.trio`
   3. `folio_records.trio`
   4. `folio_his.zinc`
   
   Alternatively, transfer these files manually to your SkySpark project's `io`
   directory using your operating system.

6. To import the setup function `testEnvironmentSetup()`, execute the following
   command in the *Tools* app, *Shell* tab:
   
   ```
   ioReadTrio(`io/setup.trio`).map(rec => diff(null, rec, {add})).commit
   ```
   
   (If the setup function already exists in the current project, skip this
   step. Otherwise you will end up with a duplicate setup function.)

7. In the *Tools* app, *Shell* tab, execute the newly imported
   `testEnvironmentSetup()` function:
   
   ```
   testEnvironmentSetup()
   ```

To check that the test environment is correctly configured, you can run the
following command from the SkySpark  after completing steps 1-7 above:

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

2. If you need to replace the existing files `setup.trio`, `example_funcs.trio`,
   `folio_records.trio`, or `folio_his.zinc` after initially uploading them via
   the SkySpark *Tools* app, you must first delete the existing versions.
   (Otherwise, SkySpark will make a new copy with an integer suffix rather than
   overwriting the existing version.)
   
Getting Started
---------------

After setup, to get started, try looking at the source code, then running, the
following functions:

1. `exampleQuery()`
2. `exampleHistoryRead()`
3. `task(@p:pred_test:r:29e7afcb-0fcefdd7).examplePythonInteraction` -- Make
   sure Docker is running for this one!

The function `examplePythonTask()` is for use with the pre-defined `task` record
and provides a simple way to interface with a persistent Python session. It is
not intended to be called directly.

**TO DO:** If we create a SkySpark extension out of this, most of the *example*
functions would possible go away? The test environment would just install and
use the extension?