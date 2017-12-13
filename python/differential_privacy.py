#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 11 10:11:24 2017

@author: G. Arampatzis (gtarabat@gmail.com)
"""



'''
Notes: CMAES doesn't run with nvar=1
'''


import numpy as np
import sys
from platypus import Problem, Real


class DataHolder:

    def __init__(self, data):
        self.data = data;
        self.N    = len(data.squeeze().shape)

    def mean( self ):
        return self.data.mean()


    def std( self ):
        return self.data.std()



    def entropy( self , N=None):

        d = self.data.flatten()

        if N is None:
            bins = 'auto'
        else:
            bins = N

        [f, edges] = np.histogram( d, bins )

        f[f<1] = 1;

        f = f/float(np.sum(f))

        dx = edges[1]-edges[0]

        return  - np.sum( f * np.log( f/dx ) );


    def aggregate( self ):
        return self.data.sum( 0 )







class DifferentialPrivacy:

    def __init__( self, data_file,  fitness='fitness_2d',  mask='laplace'  ):
        try:
            data = np.loadtxt( data_file, delimiter=',' )
        except IOError:
            print('Error: file ', data_file, ' does not exist.')
            sys.exit(1)


        self.s  = DataHolder( data )
        self.ms = DataHolder( np.zeros( data.shape ) )

        self.e  = DataHolder( np.zeros( data.shape ) )

        self.alpha = np.array([0.2, 0.4, 0.4])
        self.gamma = np.array([0.2, 0.4, 0.4])

        self.Ns = 10;



        getattr(self, fitness+'_init')()
        self.fitness =  getattr(self, fitness)

        getattr(self, mask+'_init')()
        self.mask =  getattr(self, mask)

        self.cnt = 0;






    #**************************************************************************
    def privacy( self ):
        p = np.zeros(3)
        p[0] = self.e.mean()
        p[1] = self.e.std()
        p[2] = self.e.entropy()

        pr = self.alpha.dot(p)

        return ( pr, p[0], p[1], p[2] )


    def accuracy( self ):
        g = self.s.aggregate();

        E = DataHolder( np.absolute( (g-self.ms.aggregate()) / g ) )

        p = np.zeros(3)
        p[0] = E.mean()
        p[1] = E.std()
        p[2] = E.entropy()

        ac = -self.gamma.dot(p)

        return ( ac, p[0], p[1], p[2] )







    #**************************************************************************
    def laplace_init( self ):
        self.theta_dim = 1;


    def laplace( self, theta ):
        self.e.data  =  np.random.laplace( 0.0, theta, self.e.data.shape )
        self.ms.data =  self.s.data + self.e.data
        self.e.data  =  np.absolute( self.e.data / self.s.data )








    #**************************************************************************
    def fitness_2d_init( self ):
        self.nobjs = 2
        self.ncnst = 0


    def fitness_2d( self, theta ):
        p = np.zeros(self.Ns)
        a = np.zeros(self.Ns)

        for i in range( self.Ns ):
            self.mask(theta)
            tmp  = self.privacy()
            p[i] = tmp[0]

            tmp = self.accuracy()
            a[i] = tmp[0]

        self.cnt+=1

        obj = [ -p.mean(), -a.mean()  ]
        cns = []
        
        return [obj,cns]



    #**************************************************************************
    def fitness_2d_cnstr_init( self ):
        self.nobjs = 2
        self.ncnst = 2


    def fitness_2d_cnstr( self, theta ):
        p = np.zeros(self.Ns)
        a = np.zeros(self.Ns)
        ma = np.zeros(self.Ns)
        sa = np.zeros(self.Ns)

        for i in range( self.Ns ):
            self.mask(theta)
            tmp  = self.privacy()
            p[i] = tmp[0]

            tmp = self.accuracy()
            a[i]  = tmp[0]
            ma[i] = tmp[1]
            sa[i] = tmp[2]

        self.cnt+=1
        
        obj = [ -p.mean(), -a.mean()  ]
        cns = [ np.absolute(ma.mean())-0.1,  sa.mean()-0.1 ]
        
        return [obj,cns]



    #**************************************************************************
    def fitness_3d_init( self ):
        self.nobjs = 3
        self.ncnst = 0


    def fitness_3d( self, theta ):
        self.nobjs = 3
        p = np.zeros(self.Ns)
        a = np.zeros(self.Ns)

        for i in range( self.Ns ):
            self.mask(theta)
            tmp  = self.privacy()
            p[i] = tmp[0]

            tmp = self.accuracy()
            a[i]  = tmp[0]

        self.cnt+=1

        n = max( p.std(), a.std() )
        
        obj = [ -p.mean(), -a.mean(), n  ]
        cns = []

        return [obj,cns]



    #**************************************************************************
    def fitness_3d_cnstr_init( self ):
        self.nobjs = 3
        self.ncnst = 2


    def fitness_3d_cnstr( self, theta ):
        self.nobjs = 3
        p = np.zeros(self.Ns)
        a = np.zeros(self.Ns)
        ma = np.zeros(self.Ns)
        sa = np.zeros(self.Ns)

        for i in range( self.Ns ):
            self.mask(theta)
            tmp  = self.privacy()
            p[i] = tmp[0]

            tmp = self.accuracy()
            a[i]  = tmp[0]
            ma[i] = tmp[1]
            sa[i] = tmp[2]

        self.cnt+=1

        n = max( p.std(), a.std() )
        
        obj = [ -p.mean(), -a.mean(), n  ]
        cns = [ np.absolute(ma.mean())-0.1,  sa.mean()-0.1 ]
        
        return [obj,cns]










class DpProblem( Problem ):

    def __init__( self , dpo, domain ):
        if not isinstance(dpo,list):
            raise TypeError("Input in DpProblem must be a list.")

        super(DpProblem, self).__init__( dpo[0].theta_dim, dpo[0].nobjs, dpo[0].ncnst )
        self.types[:] = domain
        self.constraints[:] = "<=0"
        self.dpo = dpo[0]


    def evaluate(self, solution):
        theta = solution.variables[:]
        s = self.dpo.fitness(theta)
        solution.objectives[:]  = s[0]
        solution.constraints[:] = s[1]












