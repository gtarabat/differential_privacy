#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 10:11:24 2017

@author: G. Arampatzis (gtarabat@gmail.com)
"""


import differential_privacy as dp
import matplotlib.pyplot as plt
from platypus import algorithms as alg
from platypus import Real

import logging

fit_str = 'fitness_3d'

dpo = dp.DifferentialPrivacy( 'data/data.txt', fitness=fit_str, mask='laplace' )

dpp = dp.DpProblem( [dpo], domain=Real(0.0001, 20) )

logging.basicConfig(level=logging.DEBUG)

algorithm = alg.NSGAIII( dpp, 10, log_frequency=100 )

algorithm.run(1000)




if '2d' in fit_str:
    plt.scatter([s.objectives[0] for s in algorithm.result],
                [s.objectives[1] for s in algorithm.result])
    plt.show()


if '3d' in fit_str:
    plt.scatter([s.objectives[0] for s in algorithm.result],
                [s.objectives[1] for s in algorithm.result],
                [s.objectives[2] for s in algorithm.result])
    plt.show()

