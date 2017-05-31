#!/usr/bin/env bash

Xvfb :10 -ac &
grunt
chmod -R a+rwx .tmp build
