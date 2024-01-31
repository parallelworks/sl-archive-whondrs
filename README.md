# sl-archive-whondrs
Machine learning (ML) achive directory for use with the WHONDRS/ICON-ModEx 
SuperLearner (SL) workflow. 
This repository stores the data, results (including ML models) for a paper about
training and evaluating ML models of sediment respiration rate. The similarly-
structured ML archive repository for a paper about how crowdsourced observations
power observation-model iterations is 
[dynamic-learning-rivers](https://github.com/parallelworks/dynamic-learning-rivers/).

## Purpose
This ML archive repository is set up to use a [SuperLearner ML workflow repository](https://github.com/parallelworks/sl_core)
that holds the training code itself.  The workflow is divided into two stages:
1. a workflow launch, orchestrated by a GitHub action in this repository
(see `.github/workflows/main.yml`) that starts a high performance computing (HPC, i.e. on a cloud cluster) workflow on the PW platform and
2. the [HPC workflow itself](https://github.com/parallelworks/sl_core/blob/main/workflow.sh).
Therefore, this ML archive repository is at the center of an automated ML workflow that
kicks off the training of ML models (with the code in the ML workflow repo) whenever
new data is available in this repository. The presence of new data is determined with
a new release of this repository, not just a push.  Since we want to automate the
training and the archiving, the ML workflow will automatically start with a new release,
train the SuperLearner using the data here, and then push a commit of trained models
back to the archive repository.  If the automated workflow were started 
with a push, this feedback loop would become unlimited because all archiving pushes 
would start another round of training.

## Branch Navigation

A visualization of the organization of the branches of this repository is available under the
`Insights` tab at the top and then selecting `Network` from the list on the left sidebar. There are three main "trunks" in this repository:
1. `main` - the main branch which contains ML models/results from the Summer 2019 WHONDRS campaign (the dataset with the most features/inputs). Also, this branch contains a record of all the analysis/figures in the manuscript.
2. `main-no-fticr` - this parallel branch to `main` contains ML models/results from a merged Summer 2019 and 2022 sampling campaigns. There are more data points, but fewer features in this data set; in particular no FTICR, isotope, NPOC, cytometry, sediment fractions, or %C/%N.
3. `main-extrapolate` - this parallel branch to `main` and `main-no-fticr` contains ML models/results using only the "large-scale" features - the variables that we can collect from [global databases](https://github.com/parallelworks/global-river-databases) so that we have ML models that can make predictions at nearly any river segment.
Each main "trunk" has several ML models "sprouting" from it. The trunks contain the core configuration of each type of ML model described above while the ML model branches contain small adjustments to those configurations for particular cases and/or reproducibility runs.

## Contents

1. `input_data` training data for the ML models.
2. `ml_models` machine learning models trained on the `input_data`.
3. `test_deploy_key.sh` allows for testing the deploy key of a repository by cloning, making a branch, and pushing changes on that branch back to the repository.
4. `scripts` contains data preprocessing/wrangling/postprocessing scripts specific to this data set that bookend the workflow.
5. `examples` contains the visualation of the results in this repository including examples for plotting FPI results and running predictions with the ML models.
6. `output_data` (only available on ML model branches, not on the `main*` trunks) holds the overall results of the ML model on that branch.

## Setup on GitHub

1. This repository holds an API key to a PW account as an encrypted secret.
2. A `.github/workflows/main.yml` has been added here to launch the ML workflow on release
3. An SSH public deploy key has been added to this repository that corresponds to the 
private key on the PW account that corresponds to the API key in #1, above. This allows that 
PW account to push commits back to this repository after the training is complete.
4. The GitHub action itself is defined in `action.yml` in a [separate repository](https://github.com/parallelworks/test-workflow-action) - this action starts a resource on the PW platform, launches the HPC workflow (sending workflow-parameters from this repository's launch workflow to the HPC workflow on PW).

## Set up with ICON-ModEx ([sl_core](https://github.com/parallelworks/sl_core/)) workflow

1. The code for the ML workflow (i.e. the SuperLearner) needs to be established on the platform.
Please see the `README.md` in the [SuperLearner workflow](https://github.com/parallelworks/sl_core) for more details.
2. The launch of the workflow (the specific workflow parameters) needs to be specified in `.github/workflows/main.yml`.
3. Data set specific preprocessing and postprocessing scripts need to be set up in `./scripts/`.
4. Input data (which is used by the preprocessing scripts, above) is added in `./input_data/`.
5. Empty `ml_models` directory is added as a placeholder.

## Branch, tag (version), and release naming conventions

This ML archive repository tracks the status of inputs and outputs of the ML
workflow as more data become available. Each model-experiment (ModEx) iteration
is treated as a separate branch. This allows the core fabric of this repository
to evolve over time while also "sprouting" distinct ML models that are a snapshot
of a particular ModEx iteration. Some basic guidelines:
+ **Branches** can have human readable names (e.g. mid-April-2023-test).
+ **Tags** (e.g. `v2.2.1`) are assigned to the state of a branch immediately before the machine learning workflow is run. This is because the ML workflow is started when a release is published, and each release gets a tag. `v2` indicates that the workflow is fully automated (`v1` is partial automation). The middle digit (`v2.2`) reflects changes in the `main` branch and is incremented. The last digit indicates the number of ModEx iterations for this particular state of the `main` branch.
+ **Releases** are automatically named using the create release notes button.
