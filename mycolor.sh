#!/bin/bash
cecho() {
    echo -e "\033[$1m$2\033[0m"
}
cecho 32 OK
cecho 33 OK
cecho 34 OK
cecho 35 OK
