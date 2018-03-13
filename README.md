需要手动下载jdk包，并保持与Dockerfile在同一目录下
docker build -t your_image_name .

docker run -d -p 8080:8080 --name your_container_name your_build_image_name
