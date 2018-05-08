# simulation_module.py
# Module definining activaiton functions, change in state, update to state,
# and a numerical simulation of the solution to a nonlinear dynamical system.

import numpy as np

def thresh_exp(x):
    '''Activation function'''
    return 1 / (1 + np.exp(-x))

def find_dx(state, It, params):
    '''Returns dx/dt given the parameters and current state'''
    Winh = params['Winh']
    Wexc = params['Wexc'] 
    tau = params['tau']
    
    x = state
    dx = (-x + thresh_exp(Winh * x + Wexc * x + It)) / tau
    return dx

def update_x(state, It, params):
    '''Update u based on params'''
    nextState = state
    nextState += find_dx(state, It, params) * params['dt']
    return nextState

def simulate_x(state_init, I0, params, niter):
    '''Simulate for niter iterations'''
    curr_state = state_init
    x_lst = state_init
    
    for i in range(niter):
        It = I0;
        curr_state = update_x(curr_state, It, params)
        x_lst = np.append(x_lst,curr_state, axis=1)
        
    return x_lst
