nrelWattileExt Demonstration
============================

This directory contains a simple demonstration of **nrelWattileExt** using the
"Headquarters" building in the SkySpark demo database. This demonstration was
created using:

- [SkySpark] 3.0.10
- [Wattile] 0.3
- [nrelWattileExt] 0.3

[SkySpark]: https://skyfoundry.com/product "SkySpark"
[Wattile]: https://github.com/NREL/Wattile/releases/ "Wattile"
[nrelWattileExt]: https://stackhub.org/package/nrelWattileExt/ "nrelWattileExt"

Setup
-----

This demonstration works with the SkySpark demo database. To set up the demo:

1. Install SkySpark
2. Run *demogen*, with ~2 years of simulated past history
   (see SkySpark [docs](https://skyfoundry.com/doc/docSkySpark/Setup#demogen))
3. Install [nrelWattileExt] and [nrelUtilityExt] from [StackHub]
4. In the demo project, enable the `nrelWattile` extension (this also enables
   dependencies `docker` , `py`, `task`, and `nrelUtility`)

[nrelUtilityExt]: https://stackhub.org/package/nrelUtilityExt/ "nrelUtilityExt"
[StackHub]: https://stackhub.org/ "StackHub"

### Docker Image

You will also need Docker running on the same computer as SkySpark and a Docker
image for the correct version of Wattile (see above). To build the Wattile
Docker image, see [these instructions](https://github.com/NREL/nrelWattileExt/?tab=readme-ov-file#docker).

### Example Code

The TRIO files in this directory contain example code used for the demo. Each
block of example code is within a self-contained function. You may:

- Import the functions to SkySpark and run them in the *Shell*
- Copy function contents from the TRIO files and run it in a multiline *Shell*

If you wish to preload the example functions into SkySpark, place each TRIO file
in your demo project's `io/` folder and then import the function records:

```
importFunctions(`io/data_export.trio`, {commit})
... TO DO
```

Exporting Training Data
-----------------------

*Example code for this section is found in `data_export.trio`.*

Training a Wattile model requires time series data for the model *target* and
*predictors*. For this demo, the *target* will be the Headquarters building's
main electricity meter's power measurement. The *predictors* will be:

- Outside air temperature for Richmond, VA
- Outside air humidity for Richmond, VA

(Richmond, VA is the `weatherStation` for the "Headquarters" `site`.)

The function `wattileDemoExportTrainingData()` contains example code for
exporting training data from these points. After running the code, your demo
project's `io` folder will have the following subfolders and files:

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

- Accepts as input the predictors from the training data set created above
- Generates time-based features as additional predictors
- Outputs predictions at an hourly resolution
- Predicts five quantiles: 0.05, 0.25, 0.50, 0.75, 0.95

[Wattile_Examples]: https://github.com/NREL/Wattile_Examples/

To use the model, first download the "Headquarters-Electricity"
[model directory] from [Wattile_Examples].

[model directory]: https://github.com/NREL/Wattile_Examples/tree/main/ex-1-skyspark-demo/models/model-1 "Headquarters-Electricity"

**TO DO:** Update link for new folder name when available

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
- `metadata.json`
- `predictors_target_config.json`
- `train_stats.json`
- `torch_model`

**TO DO:** Is `predictions.h5` also needed?

These five files within a directory make a minimal Wattile model. Additional
files created during training include cached data, cached predictions, and
plots/visualizations of model's performance with respect to the validation data
set.

Importing a Trained Model
-------------------------

*Example code for this section is found in `model_import.trio`.*

1. If you haven't already, download the "Headquarters-Electricity"
   [model directory] from [Wattile_Examples].

2. Create a subfolder for your model within the SkySpark demo project:
   `io/wattile/Headquarters-Electricity/`

3. Copy the "Headquarters-Electricity" directory contents into the new SkySpark
   subfolder created in step 2. You need at minimum the 5 files mentioned under
   [#model-structure] above.

Running Predictions
-------------------

Syncing Prediction History
--------------------------
