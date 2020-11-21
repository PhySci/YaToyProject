SCRIPT_DIR:=$(shell pwd)
TRAIN_DATA_DIR:=${SCRIPT_DIR}/data

TRAIN_DIR:=${SCRIPT_DIR}/test_fixtures

CONFIGS_DIR:=${TRAIN_DIR}/configs


MODELS_DIR:=${TRAIN_DIR}/output/models

INFERENCE_INPUT_DIR:=${SCRIPT_DIR}/test_fixtures/data/inference
INFERENCE_RESULTS_DIR:=${SCRIPT_DIR}/test_fixtures/output/inference


docker_base:
	cd docker/base && docker build -t fedor_ecw:base .

docker_build:
	cp docker/main/Dockerfile Dockerfile 
	docker build -t fedor_ecw:latest .
	rm Dockerfile
 
docker_run:
	rm -f ${SCRIPT_DIR}/test/output/*
	docker run -it --rm --name ExamCardWizard \
			--mount type=bind,source=${SCRIPT_DIR}/test/data,destination=/opt/script/data \
			--mount type=bind,source=${SCRIPT_DIR}/test/output,destination=/opt/script/result \
			--mount type=bind,source=${SCRIPT_DIR}/models,destination=/opt/script/models \
			fedor_ecw:latest

docker_train:
	docker run -it --rm --name ExamCardWizardTrain \
                            --mount type=bind,source=${DATA_DIR},destination=/opt/script/train/data \
                            --mount type=bind,source=${MODELS_DIR},destination=/opt/script/train/models \
                            fedor_ecw:latest train


DEV_DIR:=$(shell pwd)/dev_image
docker_run_dev:
	docker run --runtime=nvidia -it --rm  --name ExamCardWizardDev \
	           --mount type=bind,source=${SCRIPT_DIR},destination=/opt/project \
                   -p 8072:22 fedor_ecw:base bash


pipeline_train:
	@echo "Run pipeline test recipe"
	@echo "Output folder is ${OUTPUT_DIR}"
	@echo "Folder with test samples is ${TEST_DIR}"
	@echo "Folder with training samples is ${DATA_DIR}"
	@echo "Folder with models is ${MODELS_DIR}"


	@echo "Train stage"
	@echo "==================================="
	docker run --runtime=nvidia -it --rm --name ExamCardWizardTrain \
		--mount type=bind,source=${TRAIN_DATA_DIR},destination=/opt/script/train/data \
		--mount type=bind,source=${MODELS_DIR},destination=/opt/script/train/models \
		--mount type=bind,source=${CONFIGS_DIR},destination=/opt/script/train/configs \
		fedor_ecw:latest train --cuda_device 3


pipeline_test:
	@echo "Test stage"
	@echo "==================================="
	docker run -it --rm --name ExamCardWizardInference  \
		--mount type=bind,source=${INFERENCE_INPUT_DIR},destination=/opt/script/data \
		--mount type=bind,source=${INFERENCE_RESULTS_DIR},destination=/opt/script/result \
		--mount type=bind,source=${MODELS_DIR},destination=/opt/script/models \
		--mount type=bind,source=${CONFIGS_DIR},destination=/opt/script/configs \
		fedor_ecw:latest inference --verbose 

pipeline: docker_build pipeline_train pipeline_test
