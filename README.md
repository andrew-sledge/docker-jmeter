# docker-jmeter

A Docker image to run [Apache JMeter](https://jmeter.apache.org/). Only includes one plugin (the plugins manager plugin). Optionally you can specify JMeter version, plugins manager plugin version, load runner JMX script, HTTP host to test, and a CSV load script. View the Dockerfile for all of the available arguments.

```
$ docker build -t jmeter -f Dockerfile . --build-arg JMETER_VERSION=4.0
$ docker run -e "JMETER_SCRIPT_S3_LOCATION=s3://mybucket/loadrunner.jmx" -e "JMETER_CSV_LOAD_SCRIPT_S3_LOCATION=s3://mybucket/data.csv" -e "JMETER_HTTP_HOST=www.host.com" -it jmeter .
```

When ran, you can specify S3 buckets to pull the load runner and data CSV files for the JMeter task by supplying the `JMETER_SCRIPT_S3_LOCATION` and `JMETER_CSV_LOAD_SCRIPT_S3_LOCATION` (respectively) values. You can also specify the `JMETER_HTTP_HOST` to run the test against. 

Please file PRs or issues if you see anything that needs to be added or changed.

