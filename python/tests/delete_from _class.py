#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 12 11:35:40 2017

@author: G. Arampatzis (gtarabat@gmail.com)
"""

class A(object):

    def __init__(self, val):
        self.val = val
        
        
        
        
        
        
class B(object):

    def __init__(self, a):
        # initialize things
        self.a = a[0]
        a[0].val='very new val'
        pass


    def changeA( self ) :
        self.a.val = 'new value'
        
        

        
a = A('value')
print(a.val)


b = B([a])
print(a.val)

b.changeA();
print(a.val)