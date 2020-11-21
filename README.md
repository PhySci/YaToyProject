# Exam Card Wizard
The repo contains end-to-end pipeline for prediction of an optimal protocol for MRI study (i.e. exam card) from text of clinical referrals.

## Usage examples
### Getting the docker image
To get the latest Docker image, pull image from the project registry (username: _philips_, deployment key: _v7js3uRxpovsu9fVFyr__). The example below shows how to pull the latest version:
```
docker login -u philips -p v7js3uRxpovsu9fVFyr_ https://gitlab.ta.philips.com:5432
docker pull gitlab.ta.philips.com:5432/ai4r/examcardwizard/examcardwizard-pipeline/release:latest
```

### Inference mode
Inference mode is intended to get recommended MRI protocols based on clinical recommendations using the pre-trained models. Running of the Docker image in inference mode executes \textit{inference} entrypoint (see section \ref{sec:inference}). To run the Docker image in inference mode, execute the following command (listing \ref{lst:docker_inference}):

```
docker run -it --rm --name ExamCardWizardInference  \
	--mount 'type=bind,source='$DATA_DIR',destination=/opt/script/data' \
	--mount 'type=bind,source='$OUTPUT_DIR',destination=/opt/script/result' \
	--mount 'type=bind,source='$MODELS_DIR',destination=/opt/script/models' \
	--mount 'type=bind,source='$CONFIGS_DIR',destination=/opt/script/configs' \
	examcard_wizard:latest

```
Parameters:
- ${TEST_DIR} is an absolute path to a folder with clinical indications in JSON files.
- ${OUTPUT_DIR} is an absolute path to a folder where recommended protocols will be saved into;
- ${MODELS_DIR} is an absolute path to a folder containing serialized models;
- ${CONFIGS_DIR} is an absolute path to a folder containing configuration files.

${TEST_DIR} contains JSON files with clinical indications in the the following format:
```
[{"ClinicalIndication":"brain tumor follow up"}]
```
or
```
[{"ClinicalIndication":"brain tumor follow up","code4":6010}]
```

Output of the pipeline is a JSON file with MRI exam card, i.e. list of MRI series with key parameters. Example of output JSON file is shown below:
```
[{"Type":"T1", "Mode":"TSE", "FAT SAT":"None", "Orientation":"SAG", "FOV":"23cm","Gap":"1mm","Slice":"4mm","Scan Range":"Scalp to Scalp","Contrast":"No"},
{"Type":"T2", "Mode":"TSE", "FAT SAT":"None", "Orientation":"AXIAL", "FOV":"23cm", "Gap":"1mm", "Slice":"4mm", "Scan Range":"Angle to Corpus- Skull Base to Vertex", "Contrast":"No"},
{"Type":"T1", "Mode":"TSE", "FAT SAT":"None", "Orientation":"AXIAL", "FOV":"23cm", "Gap":"1mm", "Slice":"4mm", "Scan Range":"Angle to Corpus- Skull Base to Vertex","Contrast":"No"},
{"Type":"T2* GRE", "Mode":"GRE", "FAT SAT":"None", "Orientation":"AXIAL", "FOV":"23cm", "Gap":"1mm", "Slice":"4mm", "Scan Range":"Angle to Corpus- Skull Base to Vertex","Contrast":"No"},
{"Type":"DWI 2mm Voxel", "Mode":"SE EPI", "FAT SAT":"SPIR", "Orientation":"AXIAL", "FOV":"23cm", "Gap":"0.3mm", "Slice":"3mm", "Scan Range":"Angle to Corpus- Skull Base to Vertex","Contrast":"No"},
{"Type":"FLAIR", "Mode":"TSE", "FAT SAT":"None", "Orientation":"COR", "FOV":"23cm", "Gap":"1mm","Slice":"4mm", "Scan Range":"Frontal through Occipital Bone", "Contrast":"No"},
{"Type":"T1", "Mode":"TSE", "FAT SAT":"None", "Orientation":"AXIAL", "FOV":"23cm", "Gap":"1mm", "Slice":"4mm", "Scan Range":"Angle to Corpus- Skull Base to Vertex", "Contrast":"Yes"},
{"Type":"T1 FAT SAT", "Mode":"TSE", "FAT SAT":"SPIR", "Orientation":"COR", "FOV":"23cm", "Gap":"1mm", "Slice":"4mm", "Scan Range":"Frontal through Occipital Bone", "Contrast":"Yes"}]
```

### Training mode
```
docker run --runtime=nvidia -it --rm --name ExamCardWizardTrain \
  --mount type=bind,source=${DATA_DIR},destination=/opt/script/train/data \
	--mount type=bind,source=${CONFIGS_DIR},destination=/opt/script/train/configs \
	--mount type=bind,source=${OUTPUT_DIR},destination=/opt/script/train/models \
	examcard_wizard:latest	train
```
Parameters:
- ${DATA_DIR} is a path to a folder that contains  training data;
- ${MODELS_DIR} is a path to a folder where serialized models will be saved;
- ${CONFIGS_DIR} is a path to a folder containing configuration files.
