import numpy as np


'''
import pbc1109.data as pbcd
ds = pbcd.PBCData('/home/ian/Data/PBC/pbc2009icdm')

s11 = ds.get_data(1,1)

expert_labels = s11.labels[:,1]

np.random.seed(0)
random_labels = np.random.randint(12,size=250000)

cm=venn.ConfusionMatrix(np.c_[expert_labels,random_labels])
cmcounts[5,8]
97.0
'''

class ConfusionMatrix():
    '''
    Confusion Matrix Class
    '''
  
    def __init__(self, data):
        '''create a new confusion matrix from a table of data
        
        '''    
        row_cats = set(data[:,0])
        col_cats = set(data[:,1])
        self.row_cats = row_cats
        self.col_cats = col_cats
        self.counts = np.zeros((len(row_cats),len(col_cats)))
        for row in data:
            self.counts[row[0],row[1]] += 1

