import numpy as np


'''
import pbc1109.data as pbcd
ds = pbcd.PBCData('/home/ian/Data/PBC/pbc2009icdm')

s11 = ds.get_data(1,1)

labels = s11.labels
labels = 
label_ids_expert = set(labels[:,1])

labels_mine = 

d = {}
for id in label_ids:
    d[id] = set(labels[labels[:,1]==id,0])
    
d.keys()

d1=d.copy()
d2=d.copy()

d = {}
for id in label_ids:
    d[id] = set(labels[labels[:,1]==id,0])
    print d[id]
'''

class ConfusionMatrix():
    ''' Confusion Matrix Class
    
    '''
    
    def __init__(self, data):
        ''' 
         
        >>> asdfasf
         
        '''    
        
        row_cats = set(data[:,0])
        col_cats = set(data[:,1])
        self.row_cats = row_cats
        self.col_cats = col_cats
        self.counts = np.zeros((len(row_cats),len(col_cats)))
        for row in data:
            self.counts[row[0],row[1]] += 1
        
        
