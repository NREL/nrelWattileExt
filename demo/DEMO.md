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

This section demonstrates how to export data from SkySpark for training a
Wattile model. Training a Wattile model requires time series data for the model
*target* and *predictors*. For this demo, the *target* will be the Headquarters
building's main electricity meter power measurement. The *predictors* will be:

- Outside air temperature for Richmond, VA
- Outside air humidity for Richmond, VA

(Richmond, VA is the `weatherStation` for the "Headquarters" `site`.)

1. Run the example code in the `wattileDemoExportTrainingData()` function.

2. After running the code, your demo project's `io` folder should contain the
   following subfolders and files:

   - `wattile/`
     - `training_data/`
       - `Headquarters/`
         - `Headquarters Config.json`
         - `Headquarters Predictors.csv`
         - `Headquarters Targets.csv`

   These three files contain all the metadata and time series data required to
   train the demo Wattile model.

Model Training
--------------

At this time, Wattile model training happens outside of SkySpark. A Python
notebook that demonstrates how to build the Headquarters example model is
available in the [Wattile_Examples] repository on GitHub. The example model:

- Accepts as input the predictors from the training data set created above
- Generates time-based features as additional predictors
- Outputs predictions at an hourly resolution
- Predicts five quantiles: 0.05, 0.25, 0.50, 0.75, 0.95

Training the model itself is outside the scope of this demo. (If you want to
learn how to train the model, see these [python notebooks].) Instead, for this
demo, you will download and use the pre-trained example model available in the
"Headquarters-Electricity" [model directory] from the Wattile_Examples repo.

[Wattile_Examples]: https://github.com/NREL/Wattile_Examples/ex-1-skyspark-demo/ "Wattile Example: SkySpark Demo"
[python notebooks]: https://github.com/NREL/Wattile_Examples/tree/main/ex-1-skyspark-demo/notebooks "Wattile Example Python Notebooks"
[model directory]: https://github.com/NREL/Wattile_Examples/tree/main/ex-1-skyspark-demo/models/headquarters-electricity "Headquarters-Electricity"

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
- `predictions.h5`

These six files within a directory make a minimal Wattile model. Additional
files created during training include cached data, cached predictions, and
plots/visualizations of model's performance with respect to the validation data
set. (Of these additional files, only the plots/visualizations are included with
the example model.)

Importing a Trained Model
-------------------------

*Example code for this section is found in `model_import.trio`.*

This section demonstrates how to import a trained Wattile model into SkySpark.

1. If you haven't already, download the entire "Headquarters-Electricity"
   [model directory] from [Wattile_Examples].

2. Create this subfolder for your model within the SkySpark demo project:
   `io/wattile/Headquarters-Electricity/`

3. Copy the "Headquarters-Electricity" directory contents into the new SkySpark
   subfolder created in step 2. You need at minimum the 5 files mentioned under
   [Model Structure](#model-structure) above.

4. Run the example code in the `wattileDemoFixPredictorsTargetConfig()`
   function to update the point IDs in `predictors_target_config.json` to match
   your local demo project.

   - This step is not normally needed; it is only necessary for this demo
     because the example model was trained from a different database than the
     demo project you just created.
   - For more information, see
     [Demo Model Target and Predictor Refs](#demo-model-target-and-predictor-refs)
     below.

5. **TO DO:** Model import command

6. **TO DO:** Model record query

### Demo Model Target and Predictor Refs

Normally, you will be importing a Wattile model back into the same SkySpark
project where you originally exported the training data. Therefore, the `id`
values for the target and predictor points in `predictors_target_config.json`
will match points in the SkySpark project database. For this demo, however,
that's not the case.

SkySpark's demo database automatically generates a randomized `id` tag for each
record. This means that the ids of the target and predictor points in the data
set used to train the "Headquarters-Electricity" example model will not be the
same as the ids of the parallel target and predictor points in your local demo
project. To fix this, we replace the original `predictors_target_config.json`
with a new version that contains `id` values matched to your local demo project.

Running Predictions
-------------------

- Create task
- Model setup
- Execute a prediction

Syncing Prediction History
--------------------------

- Describe prediction point structure in brief; reference extension docs.

### Create Prediction Points

- Create a point manually
- Create points automatically

### Initial Prediction Sync

### Create a Sync Task