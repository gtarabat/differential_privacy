#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 12 14:53:57 2017

@author: G. Arampatzis (gtarabat@gmail.com)
"""

import numpy as np

def entropy( data , N=None):
    d = data.flatten()
    
    if N is None:
        bins = 'auto'
    else:
        bins = N
    
    [f, edges] = np.histogram( d, bins )             
        
    f[f<1] = 1;
    
    f = f/float(np.sum(f))
    
    dx = edges[1]-edges[0]

#    print(dx)

    return  - np.sum( f * np.log( f/dx ) );






e = np.loadtxt( '../data/t.txt', delimiter=',' )

print( 'entropy = ' , entropy(e,50) )