# docker-jmeter

A Docker image to run [Apache JMeter](https://jmeter.apache.org/). Only includes
one plugin (the plugins manager plugin). Optionally you can specify JMeter
version, plugins manager plugin version, load runner JMX script, HTTP host to
test, and a CSV load script. View the Dockerfile for all of the available
arguments.

```
$ docker build -t jmeter -f Dockerfile . --build-arg JMETER_VERSION=4.0
```

Please file PRs or issues if you see anything that needs to be added or changed.
