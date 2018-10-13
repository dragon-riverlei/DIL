#!/usr/bin/python
# -*- coding: utf-8 -*-

import random

import string

import time


class EastMoney(object):
    @staticmethod
    def randomString(n):
        return ''.join(
            random.choice(string.ascii_uppercase + string.ascii_lowercase)
            for _ in range(n))

    @staticmethod
    def currentTime():
        return int(time.time() / 30)
