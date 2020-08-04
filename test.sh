#!/bin/bash

cd .rk

if [ $? -ne 0 ]; then
    echo "failed"
else
    echo "succeed"
fi