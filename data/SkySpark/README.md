SkySpark Project for Deployment Testing
=======================================

This directory contains database records, point history, and functions that
implement a replicable SkySpark test environment for testing the deployment of
predictive analytics models for building time series data.

Directory Structure
-------------------

- `folio_records.trio`: SkySpark database records for predictors and targets;
  for SkySpark import
- `folio_his.zinc`: Point history in Haystack [Zinc] format; for SkySpark import
- `funcs.trio`: Example SkySpark [Axon] functions for data interaction; for
  SkySpark import
- `README.md`: This README document
- `reference_funcs.trio`: SkySpark [Axon] functions included for reference only;
  not used in the test environment
- `setup_funcs.trio`: kySpark [Axon] functions for automated setup of the
  SkySpark test environment (see *Instructions* below)

All `*.trio` files are encoded in Haystack [Trio] format.

**TO DO:** `funcs.trio` should eventually move to a different part of the repo,
especially if we end up packaging this repo as a SkySpark extension.

[Zinc]: https://project-haystack.org/doc/docHaystack/Zinc "Zinc file format"
[Trio]: https://project-haystack.org/doc/docHaystack/Trio "Trio file format"
[Axon]: https://haxall.io/doc/appendix/axon "Axon documentation"

Instructions
------------

### Prerequisites ###

1. SkySpark installation (version 3.1.3+) with superuser permissions (must be
   able to install packages and create new projects)
2. Docker installation

### Setup Instructions ###

1. Launch SkySpark and log in with a superuser account

2. From the host interface, create a new empty project with the following
   metadata:
   
   a. **name:** "pred_test" (required)
   b. **dis:** "Predictive Analytics Test" (optional)
   c. **doc:** "SkySpark test environment for integrating predictive analytics time series models using Python and Docker" (optional)

   Note: if the default project name "pred_test" is altered, remember to use the
   new name where applicable in each of the following steps.

3. Navigate to the new *Predictive Analytics Test* project you just created

4. Within the *Settings* app, *Exts* tab, enable the `docker` and `py` exts.

5. Within the *Tools* app, *Files* tab, upload the following files from this
   directory to `proj > pred_test > io`:
   
   a. `setup.trio`
   b. `folio_records.trio`
   c. `folio_his.zinc`
   
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
readAll(point).hisRead(2021-12-01)
```

You should see a time series plot of eight total points: seven weather points
and one power point named "Synthetic Site Electricity Main Total Power".

Notes
-----

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
   `equip`, and `point` records in the current project. Use with caution!

3. If you need to replace the existing files `setup.trio`, `folio_records.trio`,
   or `folio_his.zinc` after initially uploading them via the SkySpark *Tools*
   app, you must first delete the existing version. (Otherwise, SkySpark will
   make a new copy with an integer suffix rather than overwriting the existing
   version.)

4. If re-importing the test environment to an existing project