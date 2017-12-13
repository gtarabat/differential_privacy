#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np


N = 100;
M = 30;

x = np.random.uniform( 0 , 10, (N,M) )

np.savetxt('data.txt', x, delimiter=',')



