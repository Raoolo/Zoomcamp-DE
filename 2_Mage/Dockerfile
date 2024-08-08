# build from the mageai/mageai:latest image
FROM mageai/mageai:latest      

# Set the working directory to /home/src
ARG USER_CODE_PATH=/home/src/${PROJECT_NAME}

# Note: this overwrites the requirements.txt file in your new project on first run. 
# You can delete this line for the second run :) 
# copy the requirements file into the image's path
COPY requirements.txt ${USER_CODE_PATH}requirements.txt 

# install the requirements
RUN pip3 install -r ${USER_CODE_PATH}requirements.txt
