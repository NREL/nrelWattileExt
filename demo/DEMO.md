nrelWattileExt Demonstration
============================

This directory contains a simple demonstration of **nrelWattileExt** using the
"Headquarters" building in the SkySpark demo database. This demonstration was
created using:

- [SkySpark] 3.0.10`https://skyfoundry.com/product`
- [Wattile] 0.3
- [nrelWattileExt] 0.3

[SkySpark]: http://skyfoundry.com/skyspark/ "SkySpark"
[Wattile]: https://github.com/NREL/Wattile/releases/ "Wattile Releases"
[nrelWattileExt]: https://stackhub.org/package/nrelWattileExt "nrelWattileExt"

Setup
-----

This demonstration works with the SkySpark demo database. To set up the demo:

1. Install SkySpark
2. Run *demogen*, preferably with 2 years of simulated past history
   (see SkySpark [docs](https://skyfoundry.com/doc/docSkySpark/Setup#demogen))
3. Install [nrelWattileExt] and [nrelUtilityExt] from [StackHub]
4. In the demo project, enable the `nrelWattile` extension (this also enables
   dependencies `docker` , `py`, `task`, and `nrelUtility`)

### Docker Image

You will also need Docker running on the same computer as SkySpark and a Docker
image for the correct version of Wattile (see above). To build the Wattile
Docker image, see [these instructions]
(https://github.com/NREL/nrelWattileExt/?tab=readme-ov-file#docker).

### Example Code

The TRIO files in this directory contain example code used in the demo. Each
block of example code is within a self-contained function. You may:

- Import the functions to SkySpark and run them in the *Shell*
- Copy function contents from the TRIO files and run it in a multiline *Shell*

If you wish to preload the example functions into SkySpark, place each TRIO file
in your demo project's `io/` folder and then import the function records:

```
importFunctions(`io/data_export.trio`, {commit})

```

Exporting Training Data
-----------------------

*Example code for this section is found in `data_export.trio`.*

Training a Wattile model requires time series data for the model *target* and
*predictors*. For this demo, the *target* will be the Headquarters building's
main electricity meter's power measurement. The *predictors* will be:

- Outside air temperature for Richmond, VA
- Outside air humidity for Richmond, VA

(Richmond, VA is the 'weatherStation' for the "Headquarters" 'site'.)

The function `wattileDemoExportTrainingData()` contains example code for
exporting training data from these points. After running the code, your demo
project's `io` folder will have the following new files:

- `io/`
  - `wattile/`
    - `training_data/`
      - `Headquarters/`
        - `Headquarters Config.json`
        - `Headquarters Predictors.csv`
        - `Headquarters Targets.csv`

These three files have all the metadata and time series data required to train
the demo Wattile model.

Model Training
--------------

At this time, Wattile model training happens outside of SkySpark. A Python
notebook that demonstrates how to build the Headquarters example model is
available in the [Wattile_Examples] repository on GitHub. The example model:

- Accepts as input the predictors from the training data
- Generates time-based features as additional predictors
- Outputs predictions at an hourly resolution
- Predicts five quantiles: 0.05, 0.25, 0.50, 0.75, 0.95

[Wattile_Examples]: https://github.com/NREL/Wattile_Examples/tree/main/notebooks/examples/exp_dir

**TO DO:** Update link for new folder structure when available

To use the model later in this demo, first download the entire "Headquarters"
model directory from [Wattile_Examples].

**TO DO:** Confirm name of folder

### Model Options

Wattile supports a wide variety of model configuration options for tasks such as
data cleaning, feature generation, neural network architecture, and
hyperparameter tuning. For more information, see the Wattile [documentation].

[documentation]: https://github.com/NREL/Wattile/tree/0.2.0?tab=readme-ov-file#quick-start

**TO DO:** Update to 0.3 tree when 0.3 release is public

### Model Structure

A trained Wattile model includes many files. The core files that SkySpark
requires in order to run predictions from the model are:

- `configs.json`
- `predictors_target_config.json`
- `metadata.json`
- `train_stats.json`
- `error_stats_train.json`
- `torch_model`

These six files within a directory make a complete Wattile model.

Importing a Trained Model
-------------------------

Running Predictions
-------------------

Syncing Prediction History
--------------------------
