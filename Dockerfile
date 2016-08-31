FROM golang:1.6

ENV APPPATH /app

RUN mkdir -p "$APPPATH" && chmod -R 777 "$APPPATH"
WORKDIR $APPPATH

COPY . $APPPATH

# Install dependencies, build, and remove the dependencies.
RUN apt-get install -y git && \
    go get github.com/constabulary/gb/... && \
    go install github.com/constabulary/gb && \
    gb build -f && \
    find . -not -name "*bin*" -not -name "*f5-k8s-controller" -not -name ".." -not -name "." | xargs rm -rf && \
    rm -rf $GOPATH/* && \
    apt-get remove -y git && \
    apt-get autoremove -y && \
    apt-get clean -y

# Run the run application in the projects bin directory.
CMD [ "/app/bin/f5-k8s-controller" ]