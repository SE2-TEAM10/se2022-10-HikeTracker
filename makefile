
docker_update:
	sudo docker login docker.io
	cd backend && sudo docker image build -t se2team10/se2hiketracker:be . && docker push se2team10/se2hiketracker:be
	cd frontend && sudo docker image build -t se2team10/se2hiketracker:fe . && docker push se2team10/se2hiketracker:fe